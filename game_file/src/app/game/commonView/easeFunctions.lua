local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin = math.asin
local linear = function(t, b, c, d)
	return c * t / d + b
end
local inQuad = function(t, b, c, d)
	t = t / d
	return c * pow(t, 2) + b
end
local outQuad = function(t, b, c, d)
	t = t / d
	return -c * t * (t - 2) + b
end
local inOutQuad = function(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 2) + b
	else
		return -c / 2 * ((t - 1) * (t - 3) - 1) + b
	end
end
local outInQuad = function(t, b, c, d)
	if t < d / 2 then
		return outQuad(t * 2, b, c / 2, d)
	else
		return inQuad(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local inCubic = function(t, b, c, d)
	t = t / d
	return c * pow(t, 3) + b
end
local outCubic = function(t, b, c, d)
	t = t / d - 1
	return c * (pow(t, 3) + 1) + b
end
local inOutCubic = function(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * t * t * t + b
	else
		t = t - 2
		return c / 2 * (t * t * t + 2) + b
	end
end
local outInCubic = function(t, b, c, d)
	if t < d / 2 then
		return outCubic(t * 2, b, c / 2, d)
	else
		return inCubic(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local inQuart = function(t, b, c, d)
	t = t / d
	return c * pow(t, 4) + b
end
local outQuart = function(t, b, c, d)
	t = t / d - 1
	return -c * (pow(t, 4) - 1) + b
end
local inOutQuart = function(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 4) + b
	else
		t = t - 2
		return -c / 2 * (pow(t, 4) - 2) + b
	end
end
local outInQuart = function(t, b, c, d)
	if t < d / 2 then
		return outQuart(t * 2, b, c / 2, d)
	else
		return inQuart(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local inQuint = function(t, b, c, d)
	t = t / d
	return c * pow(t, 5) + b
end
local outQuint = function(t, b, c, d)
	t = t / d - 1
	return c * (pow(t, 5) + 1) + b
end
local inOutQuint = function(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 5) + b
	else
		t = t - 2
		return c / 2 * (pow(t, 5) + 2) + b
	end
end
local outInQuint = function(t, b, c, d)
	if t < d / 2 then
		return outQuint(t * 2, b, c / 2, d)
	else
		return inQuint(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local inSine = function(t, b, c, d)
	return -c * cos(t / d * (pi / 2)) + c + b
end
local outSine = function(t, b, c, d)
	return c * sin(t / d * (pi / 2)) + b
end
local inOutSine = function(t, b, c, d)
	return -c / 2 * (cos(pi * t / d) - 1) + b
end
local outInSine = function(t, b, c, d)
	if t < d / 2 then
		return outSine(t * 2, b, c / 2, d)
	else
		return inSine(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local inExpo = function(t, b, c, d)
	if t == 0 then
		return b
	else
		return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
	end
end
local outExpo = function(t, b, c, d)
	if t == d then
		return b + c
	else
		return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
	end
end
local inOutExpo = function(t, b, c, d)
	if t == 0 then
		return b
	end
	if t == d then
		return b + c
	end
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(2, 10 * (t - 1)) + b - c * 5.0E-4
	else
		t = t - 1
		return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
	end
end
local outInExpo = function(t, b, c, d)
	if t < d / 2 then
		return outExpo(t * 2, b, c / 2, d)
	else
		return inExpo(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local inCirc = function(t, b, c, d)
	t = t / d
	return -c * (sqrt(1 - pow(t, 2)) - 1) + b
end
local outCirc = function(t, b, c, d)
	t = t / d - 1
	return c * sqrt(1 - pow(t, 2)) + b
end
local inOutCirc = function(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return -c / 2 * (sqrt(1 - t * t) - 1) + b
	else
		t = t - 2
		return c / 2 * (sqrt(1 - t * t) + 1) + b
	end
end
local outInCirc = function(t, b, c, d)
	if t < d / 2 then
		return outCirc(t * 2, b, c / 2, d)
	else
		return inCirc(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local inElastic = function(t, b, c, d, a, p)
	if t == 0 then
		return b
	end
	t = t / d
	if t == 1 then
		return b + c
	end
	p = p or d * 0.3
	local s
	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end
	t = t - 1
	return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
end
local outElastic = function(t, b, c, d, a, p)
	if t == 0 then
		return b
	end
	t = t / d
	if t == 1 then
		return b + c
	end
	p = p or d * 0.3
	local s
	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end
	return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
end
local inOutElastic = function(t, b, c, d, a, p)
	if t == 0 then
		return b
	end
	t = t / d * 2
	if t == 2 then
		return b + c
	end
	p = p or d * 0.44999999999999996
	a = a or 0
	local s
	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end
	if t < 1 then
		t = t - 1
		return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
	else
		t = t - 1
		return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) * 0.5 + c + b
	end
end
local outInElastic = function(t, b, c, d, a, p)
	if t < d / 2 then
		return outElastic(t * 2, b, c / 2, d, a, p)
	else
		return inElastic(t * 2 - d, b + c / 2, c / 2, d, a, p)
	end
end
local inBack = function(t, b, c, d, s)
	s = s or 1.70158
	t = t / d
	return c * t * t * ((s + 1) * t - s) + b
end
local outBack = function(t, b, c, d, s)
	s = s or 1.70158
	t = t / d - 1
	return c * (t * t * ((s + 1) * t + s) + 1) + b
end
local inOutBack = function(t, b, c, d, s)
	s = s or 1.70158
	s = s * 1.525
	t = t / d * 2
	if t < 1 then
		return c / 2 * (t * t * ((s + 1) * t - s)) + b
	else
		t = t - 2
		return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	end
end
local outInBack = function(t, b, c, d, s)
	if t < d / 2 then
		return outBack(t * 2, b, c / 2, d, s)
	else
		return inBack(t * 2 - d, b + c / 2, c / 2, d, s)
	end
end
local outBounce = function(t, b, c, d)
	t = t / d
	if t < 0.36363636363636365 then
		return c * (7.5625 * t * t) + b
	elseif t < 0.7272727272727273 then
		t = t - 0.5454545454545454
		return c * (7.5625 * t * t + 0.75) + b
	elseif t < 0.9090909090909091 then
		t = t - 0.8181818181818182
		return c * (7.5625 * t * t + 0.9375) + b
	else
		t = t - 0.9545454545454546
		return c * (7.5625 * t * t + 0.984375) + b
	end
end
local inBounce = function(t, b, c, d)
	return c - outBounce(d - t, 0, c, d) + b
end
local inOutBounce = function(t, b, c, d)
	if t < d / 2 then
		return inBounce(t * 2, 0, c, d) * 0.5 + b
	else
		return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b
	end
end
local outInBounce = function(t, b, c, d)
	if t < d / 2 then
		return outBounce(t * 2, b, c / 2, d)
	else
		return inBounce(t * 2 - d, b + c / 2, c / 2, d)
	end
end
local _ENV, easeFunctions
easeFunctions.linear = linear
easeFunctions.inQuad = inQuad
easeFunctions.outQuad = outQuad
easeFunctions.inOutQuad = inOutQuad
easeFunctions.outInQuad = outInQuad
easeFunctions.inCubic = inCubic
easeFunctions.outCubic = outCubic
easeFunctions.inOutCubic = inOutCubic
easeFunctions.outInCubic = outInCubic
easeFunctions.inQuart = inQuart
easeFunctions.outQuart = outQuart
easeFunctions.inOutQuart = inOutQuart
easeFunctions.outInQuart = outInQuart
easeFunctions.inQuint = inQuint
easeFunctions.outQuint = outQuint
easeFunctions.inOutQuint = inOutQuint
easeFunctions.outInQuint = outInQuint
easeFunctions.inSine = inSine
easeFunctions.outSine = outSine
easeFunctions.inOutSine = inOutSine
easeFunctions.outInSine = outInSine
easeFunctions.inExpo = inExpo
easeFunctions.outExpo = outExpo
easeFunctions.inOutExpo = inOutExpo
easeFunctions.outInExpo = outInExpo
easeFunctions.inCirc = inCirc
easeFunctions.outCirc = outCirc
easeFunctions.inOutCirc = inOutCirc
easeFunctions.outInCirc = outInCirc
easeFunctions.inElastic = inElastic
easeFunctions.outElastic = outElastic
easeFunctions.inOutElastic = inOutElastic
easeFunctions.outInElastic = outInElastic
easeFunctions.inBack = inBack
easeFunctions.outBack = outBack
easeFunctions.inOutBack = inOutBack
easeFunctions.outInBack = outInBack
easeFunctions.inBounce = inBounce
easeFunctions.outBounce = outBounce
easeFunctions.inOutBounce = inOutBounce
easeFunctions.outInBounce = outInBounce
return easeFunctions
