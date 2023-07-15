local sqlite = require("dep.sqlite")

local mod = {}

local whiskr = {} --[[@class whiskr]]
whiskr.__index = whiskr

--[[@class whiskr_fact]]
--[[@field subject string]]
--[[@field predicate string]]
--[[@field object string]]

--[[@return integer|nil id]] --[[@param s string]]
whiskr.text_to_id = function (self, s)
	local q = self.db:query("SELECT id FROM texts WHERE text = ?", s)
	return q and q()
end

--[[@param fact whiskr_fact]]
whiskr.add_fact = function (self, fact)
	--[[FIXME: insert new text into `texts` when required]]
	self.db:execute([[
		DELETE FROM facts WHERE s.id = ? AND p.id = ? AND o.id = ?
			LEFT JOIN texts AS s ON subject_id = s.id
			LEFT JOIN texts AS p ON predicate_id = p.id
			LEFT JOIN texts AS o ON object_id = o.id;
	]], fact.subject, fact.predicate, fact.object)
end

--[[@param fact whiskr_fact]]
whiskr.remove_fact = function (self, fact)
	self.db:execute(
		"INSERT INTO facts (subject_id, predicate_id, object_id) VALUES (?, ?, ?)",
		self:text_to_id(fact.subject),
		self:text_to_id(fact.predicate),
		self:text_to_id(fact.object)
	)
end

--[[@param c string]]
local by_x = function (c)
	--[[@return (fun(): whiskr_fact?)? iterator, string? error]] --[[@param self whiskr]] --[[@param x string]]
	return function (self, x)
		local iter, err = self.db:query([[
			SELECT s.text, p.text, o.text FROM facts
				WHERE ]] .. c .. [[.text = ?
				LEFT JOIN texts AS s ON subject_id = s.id
				LEFT JOIN texts AS p ON predicate_id = p.id
				LEFT JOIN texts AS o ON object_id = o.id;
		]], x)
		if not iter then return nil, err end
		return function ()
			local s, p, o = iter()
			if not s then return end
			return { subject = s, predicate = p, object = o }
		end
	end
end

whiskr.by_subject = by_x("s")
whiskr.by_predicate = by_x("p")
whiskr.by_object = by_x("o")

--[[opens or creates a db]]
--[[@param path string]]
mod.open = function (path)
	local db, err = sqlite.open(path)
	if not db then return nil, err end
	db:execute([[
		CREATE TABLE IF NOT EXISTS texts (
			id INTEGER PRIMARY KEY,
			text TEXT,
		);

		CREATE TABLE IF NOT EXISTS facts (
			id INTEGER PRIMARY KEY,
			subject_id INTEGER REFERENCES strings(id),
			predicate_id INTEGER REFERENCES strings(id),
			object_id INTEGER REFERENCES strings(id),
		);
	]])
	return (setmetatable({ --[[@class whiskr]]
		db = db,
	}, whiskr))
end

return mod
