local _ENV, _ENV, Size
;(nil).__index = function(t, k)
	if k == "width" then
		k = "x"
	elseif k == "height" then
		k = "y"
	end
	return rawget(t, k)
end
;(nil).__newindex = function(t, k, v)
	if k == "width" then
		k = "x"
	elseif k == "height" then
		k = "y"
	end
	return rawset(t, k, v)
end
;(nil).__add = function(a, b)
	return cc.size(a.x + b.x, a.y + b.y)
end
;(nil).__sub = function(a, b)
	return cc.size(a.x - b.x, a.y - b.y)
end
;(nil).__mul = function(a, b)
	assert(type(b) == "number", "Size.__mul right value except number, got " .. type(b))
	return cc.size(a.x * b, a.y * b)
end
;(nil).__div = function(a, b)
	assert(type(b) == "number", "Size.__div right value except number, got " .. type(b))
	assert(b ~= 0, "Size.__div right value can not be 0")
	return cc.size(a.x / b, a.y / b)
end
;(nil).__eq = function(a, b)
	return a.x == b.x and a.y == b.y
end
local (nil).__tostring, Size_obj_mt = function(t)
	return string.format("{%d, %d}", t.x, t.y)
end, nil
_ENV = nil
;(nil).__call = function(_, width, height)
	local _ENV, obj
	if width and type(width) ~= "number" then
		print_warn("Size width is not number, got " .. type(width))
		width = 0
	end
	obj.x = width or 0
	obj.y = height or 0
	setmetatable(obj, Size_obj_mt)
	return obj
end
setmetatable(Size, nil)
return Size
