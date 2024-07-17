--[=[
local gen = require("lovr.gen")
local model
function lovr.load()
	local bytes = gen.model_from_tris({
		{ 0, 1, 3 }, --[[-x left]]
		{ 0, 3, 2 },
		{ 0, 1, 5 }, --[[-y bottom]]
		{ 0, 5, 4 },
		{ 0, 2, 6 }, --[[-z back]]
		{ 0, 6, 4 },
		{ 4, 5, 7 }, --[[x right]]
		{ 4, 7, 6 },
		{ 2, 3, 7 }, --[[y top]]
		{ 2, 7, 6 },
		{ 1, 3, 7 }, --[[z front]]
		{ 1, 7, 5 },
	}, {
		{ x = -0.5, y = -0.5, z = -0.5 }, --[[0]]
		{ x = -0.5, y = -0.5, z = 0.5 }, --[[1]]
		{ x = -0.5, y = 0.5,  z = -0.5 }, --[[2]]
		{ x = -0.5, y = 0.5,  z = 0.5 }, --[[3]]
		{ x = 0.5,  y = -0.5, z = -0.5 }, --[[4]]
		{ x = 0.5,  y = -0.5, z = 0.5 }, --[[5]]
		{ x = 0.5,  y = 0.5,  z = -0.5 }, --[[6]]
		{ x = 0.5,  y = 0.5,  z = 0.5 }, --[[7]]
	})
	model = lovr.graphics.newModel(lovr.data.newBlob(bytes, "cube.glb"))
end

function lovr.draw(pass)
	pass:draw(model, 0, 2, -3, 2)
end
]=]

local model --[[@type lovr_model]]
local shader --[[@type lovr_shader]]

function lovr.load()
	model = lovr.graphics.newModel("saves/meow.glb")
	shader = require("lovr.lighting.pbr")()
	-- shader = require("lovr.lighting.phong")()
end

function lovr.draw(pass)
	pass:setCullMode("back")
	pass:setViewCull(true)
	pass:setShader(shader)
	pass:draw(model, 0, 0, -3, 2)

	for _, hand in ipairs(lovr.headset.getHands()) do
		local x, y, z = lovr.headset.getPosition(hand)
		pass:sphere(x, y, z, .1)
	end
end
