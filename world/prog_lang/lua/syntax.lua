local mod = {}

mod.make_syntax = function(x)
	local any = x.any
	local many = x.many
	local opt = x.optional
	local seq = x.sequence
	local lit = x.literal

	local assignment = seq(varlist, lit "=", explist)
	--[[FIXME: `block` doesn't exist yet here]]
	local do_ = seq(lit "do", block, lit "end")
	local while_ = seq(lit "while", expression, lit "do", block, lit "end")
	local statement = any(
		assignment,
		functioncall,
		do_,
		while_,
		repeat_,
		if_,
		for_,
		for_in,
		function_,
		local_function,
		local_
	)
	local return_ = seq(lit "return", opt(explist))
	local break_ = lit "break"
	local last_statement = any(return_, break_)
	local chunk = seq(many(seq(statement, opt(lit ";"))), opt(seq(last_statement, lit ";")))
	local block = chunk

	return {
		chunk = chunk,
		block = block,
		statement = statement,
		return_ = return_,
		break_ = break_,
		last_statement = last_statement,
	}
end

return mod
