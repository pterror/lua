local mod = {}

--[[each color must be a separate element in the array]]
--[[@param src integer[][] ]] --[[@param sw integer]] --[[@param sh integer]] --[[@param dest integer[][] ]] --[[@param dw integer]] --[[@param dh integer]] --[[@param x integer]] --[[@param y integer]] --[[@param epp? integer elements per pixel]]
mod.draw = function (src, sw, sh, dest, dw, dh, x, y, epp)
	epp = epp or 4
	local eppm1 = epp - 1
	local y_end = math.min(sh, dh - y) - 1
	local x_end = math.min(sw, dw - y) - 1
	for y_ = 0, y_end do
		-- not sure if scaling needs to be offset
		local sr = src[y_]
		local dr = dest[y_ + y]
		for x_ = 0, x_end do
			local xepp = (x_ + x) * epp
			local x0 = x_ * epp
			-- it's possible to use memcpy to make this way faster
			-- but it's also way less general
			for i = 0, eppm1 do dr[xepp + i] = sr[x0 + i] end
		end
	end
end

--[[each color must be a separate element in the array]]
--[[@param src integer[][] ]] --[[@param sw integer]] --[[@param sh integer]] --[[@param dest integer[][] ]] --[[@param dw integer]] --[[@param dh integer]] --[[@param epp? integer elements per pixel]]
mod.scale_nearest_neighbor = function (src, sw, sh, dest, dw, dh, epp)
	epp = epp or 4
	local eppm1 = epp - 1
	local rw = dw / sw
	local rh = dh / sh
	for y = 0, dh - 1 do
		-- not sure if scaling needs to be offset
		local sr = src[math.floor(y * rh + 0.5)]
		local dr = dest[y]
		for x = 0, dw - 1 do
			local xepp = x * epp
			local x0 = math.floor(x * rw + 0.5) * epp
			for i = 0, eppm1 do dr[xepp + i] = sr[x0 + i] end
		end
	end
end

--[[each color must be a separate element in the array]]
--[[@param src integer[][] ]] --[[@param sw integer]] --[[@param sh integer]] --[[@param dest integer[][] ]] --[[@param dw integer]] --[[@param dh integer]] --[[@param epp? integer elements per pixel]]
mod.scale_bilinear = function (src, sw, sh, dest, dw, dh, epp)
	epp = epp or 4
	local rw = dw / sw
	local rh = dh / sh
	for y = 0, dh - 1 do
		local scaled_y = y * rh
		local y0 = math.floor(scaled_y)
		local yr = scaled_y % 1
		local yR = 1 - yr
		local sr1 = src[y0]
		local sr2 = src[y0 + 1]
		local dr = dest[y]
		for x = 0, dw - 1 do
			local xepp = x * epp
			local scaled_x = x * rw
			local x0 = math.floor(scaled_x) * epp
			local x1 = x0 + epp
			local xr = scaled_x % 1
			local xR = 1 - xr
			for i = 0, epp do
				--[[@diagnostic disable-next-line: assign-type-mismatch]]
				dr[xepp + i] = (
					(sr1[x0 + i] * xr + sr1[x1 + i] * xR) * yr +
					(sr2[x0 + i] * xr + sr2[x1 + i] * xR) * yR
				)
			end
		end
	end
end

--[[@enum bitmap_horizontal_alignment]]
mod.horizontal_alignment = { left = 0, middle = 1, right = 2 }
--[[@enum bitmap_vertical_alignment]]
mod.vertical_alignment = { top = 0, middle = 1, bottom = 2 }

--[[each color must be a separate element in the array]]
--[[@param src integer[][] ]] --[[@param sw integer]] --[[@param sh integer]] --[[@param dest integer[][] ]] --[[@param dw integer]] --[[@param dh integer]] --[[@param ha? bitmap_horizontal_alignment]] --[[@param va? bitmap_vertical_alignment]] --[[@param epp? integer elements per pixel]]
mod.tile = function (src, sw, sh, dest, dw, dh, ha, va, epp)
	epp = epp or 4
	local eppm1 = epp - 1
	ha = ha or mod.horizontal_alignment.middle
	va = va or mod.vertical_alignment.middle
	local xo = 0
	if ha == mod.horizontal_alignment.middle then xo = sw - ((dw + bit.rshift(sw, 1) - 1) % sw) - 1
	elseif ha == mod.horizontal_alignment.right then xo = sw - ((dw - 1) % sw) - 1 end
	local yo = 0
	if va == mod.vertical_alignment.middle then yo = sh - ((dh + bit.rshift(sh, 1) - 1) % sh) - 1
	elseif va == mod.vertical_alignment.bottom then yo = sh - ((dh - 1) % sh) - 1 end
	for y = 0, dh - 1 do
		local sr = src[(y + yo) % sh]
		local dr = dest[y]
		for x = 0, dw - 1 do
			local x0 = ((x + xo) % sw) * (epp + 1)
			for i = 0, eppm1 do dr[x + i] = sr[x0 + i] end
		end
	end
end

return mod
