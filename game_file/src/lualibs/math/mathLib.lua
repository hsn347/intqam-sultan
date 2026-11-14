local _ENV, mathLib
function mathLib.Init(...)
	mathLib.zero = 0
	mathLib.zeroVec2 = mathLib.vec2_1(0)
	mathLib.zeroVec3 = mathLib.vec3_1(0)
	mathLib.zeroVec4 = mathLib.vec4_1(0)
end
function mathLib.vec2(_x, _y)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	return nil
end
function mathLib.vec2_1(_x)
	return mathLib.vec2(_x, _x)
end
function mathLib.vec3(_x, _y, _z)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	;(nil).z = _z
	return nil
end
function mathLib.vec3_1(_x)
	return mathLib.vec3(_x, _x, _x)
end
function mathLib.vec4(_x, _y, _z, _w)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y or _x
	;(nil).z = _z or _x
	;(nil).w = _w or _x
	return nil
end
function mathLib.vec4_1(_x)
	return mathLib.vec4(_x, _x, _x, _x)
end
function mathLib.vec3Mul(vec, factor)
	_UPVALUE0_ = nil
	;(nil).x = vec.x * factor
	;(nil).y = vec.y * factor
	;(nil).z = vec.z * factor
	return nil
end
function mathLib.c3bAdd(vec1, vec2)
	_UPVALUE0_ = nil
	;(nil).r = vec1.r + vec2.r
	;(nil).g = vec1.g + vec2.g
	;(nil).b = vec1.b + vec2.b
	return nil
end
function mathLib.c3bSub(vec1, vec2)
	_UPVALUE0_ = nil
	;(nil).r = vec1.r - vec2.r
	;(nil).g = vec1.g - vec2.g
	;(nil).b = vec1.b - vec2.b
	return nil
end
function mathLib.c3bMul(vec, factor)
	_UPVALUE0_ = nil
	;(nil).r = vec.r * factor
	;(nil).g = vec.g * factor
	;(nil).b = vec.b * factor
	return nil
end
function mathLib.mod(v, m)
	local result = v % m
	if result == 0 then
		result = m
	end
	return result
end
function mathLib.Add(x, y)
	return x + y
end
function mathLib.AddVec2(p1, p2)
	return mathLib.vec2(p1.x + p2.x, p1.y + p2.y)
end
function mathLib.AddVec3(p1, p2)
	return mathLib.vec3(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)
end
function mathLib.AddVec4(p1, p2)
	return mathLib.vec4(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z, p1.w + p2.w)
end
function mathLib.AddC3b(p1, p2)
	return mathLib.vec3(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)
end
function mathLib.Mul(x, y)
	return x * y
end
function mathLib.MulVec2(p1, p2)
	return mathLib.vec2(p1.x * p2.x, p1.y * p2.y)
end
function mathLib.MulVec3(p1, p2)
	return mathLib.vec3(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z)
end
function mathLib.MulVec4(p1, p2)
	return mathLib.vec4(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z, p1.w * p2.w)
end
function mathLib.Sub(x, y)
	return x - y
end
function mathLib.SubVec2(p1, p2)
	return mathLib.vec2(p1.x - p2.x, p1.y - p2.y)
end
function mathLib.SubVec3(p1, p2)
	return mathLib.vec3(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z)
end
function mathLib.SubVec4(p1, p2)
	return mathLib.vec4(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z, p1.w - p2.w)
end
function mathLib.Division(x, y)
	return x / y
end
function mathLib.DivisionVec2(p1, p2)
	return mathLib.vec2(p1.x / p2.x, p1.y / p2.y)
end
function mathLib.DivisionVec3(p1, p2)
	return mathLib.vec3(p1.x / p2.x, p1.y / p2.y, p1.z / p2.z)
end
function mathLib.DivisionVec4(p1, p2)
	return mathLib.vec4(p1.x / p2.x, p1.y / p2.y, p1.z / p2.z, p1.w / p2.w)
end
function mathLib.Equals(x, y)
	return x == y
end
function mathLib.EqualsVec2(x, y)
	return x.x == y.x and x.y == y.y
end
function mathLib.EqualsVec3(x, y)
	return x.x == y.x and x.y == y.y and x.z == y.z
end
function mathLib.EqualsVec4(x, y)
	return x.x == y.x and x.y == y.y and x.z == y.z and x.w == y.w
end
function mathLib.dot(x, y)
	return x * y
end
function mathLib.dotVec2(x, y)
	return x.x * y.x + x.y * y.y
end
function mathLib.dotVec3(x, y)
	return x.x * y.x + x.y * y.y + x.z * y.z
end
function mathLib.dotVec4(x, y)
	return x.x * y.x + x.y * y.y + x.z * y.z + x.w * y.w
end
function mathLib.tan(x)
	return math.tan(x)
end
function mathLib.tanVec2(x)
	return mathLib.vec2(mathLib.tan(x.x), mathLib.tan(x.y))
end
function mathLib.tanVec3(x)
	return mathLib.vec3(mathLib.tan(x.x), mathLib.tan(x.y), mathLib.tan(x.z))
end
function mathLib.tanVec4(x)
	return mathLib.vec4(mathLib.tan(x.x), mathLib.tan(x.y), mathLib.tan(x.z), mathLib.tan(x.w))
end
function mathLib.cos(x)
	return math.cos(x)
end
function mathLib.cosVec2(x)
	return mathLib.vec2(mathLib.cos(x.x), mathLib.cos(x.y))
end
function mathLib.cosVec3(x)
	return mathLib.vec3(mathLib.cos(x.x), mathLib.cos(x.y), mathLib.cos(x.z))
end
function mathLib.cosVec4(x)
	return mathLib.vec4(mathLib.cos(x.x), mathLib.cos(x.y), mathLib.cos(x.z), mathLib.cos(x.w))
end
function mathLib.sin(x)
	return math.sin(x)
end
function mathLib.sinVec2(x)
	return mathLib.vec2(mathLib.sin(x.x), mathLib.sin(x.y))
end
function mathLib.sinVec3(x)
	return mathLib.vec3(mathLib.sin(x.x), mathLib.sin(x.y), mathLib.sin(x.z))
end
function mathLib.sinVec4(x)
	return mathLib.vec4(mathLib.sin(x.x), mathLib.sin(x.y), mathLib.sin(x.z), mathLib.sin(x.w))
end
function mathLib.floor(x)
	return math.floor(x)
end
function mathLib.floorVec2(x)
	return mathLib.vec2(mathLib.floor(x.x), mathLib.floor(x.y))
end
function mathLib.floorVec3(x)
	return mathLib.vec3(mathLib.floor(x.x), mathLib.floor(x.y), mathLib.floor(x.z))
end
function mathLib.floorVec4(x)
	return mathLib.vec4(mathLib.floor(x.x), mathLib.floor(x.y), mathLib.floor(x.z), mathLib.floor(x.w))
end
function mathLib.ceil(x)
	return math.ceil(x)
end
function mathLib.ceilVec2(x)
	return mathLib.vec2(mathLib.ceil(x.x), mathLib.ceil(x.y))
end
function mathLib.ceilVec3(x)
	return mathLib.vec3(mathLib.ceil(x.x), mathLib.ceil(x.y), mathLib.ceil(x.z))
end
function mathLib.ceilVec4(x)
	return mathLib.vec4(mathLib.ceil(x.x), mathLib.ceil(x.y), mathLib.ceil(x.z), mathLib.ceil(x.w))
end
function mathLib.round(x)
	return mathLib.floor(x + 0.5)
end
function mathLib.roundVec2(x)
	return mathLib.vec2(mathLib.round(x.x), mathLib.round(x.y))
end
function mathLib.roundVec3(x)
	return mathLib.vec3(mathLib.round(x.x), mathLib.round(x.y), mathLib.round(x.z))
end
function mathLib.roundVec4(x)
	return mathLib.vec4(mathLib.round(x.x), mathLib.round(x.y), mathLib.round(x.z), mathLib.round(x.w))
end
function mathLib.frac(x)
	return x - mathLib.floor(x)
end
function mathLib.fracVec2(x)
	return mathLib.vec2(mathLib.frac(x.x), mathLib.frac(x.y))
end
function mathLib.fracVec3(x)
	return mathLib.vec3(mathLib.frac(x.x), mathLib.frac(x.y), mathLib.frac(x.z))
end
function mathLib.fracVec4(x)
	return mathLib.vec4(mathLib.frac(x.x), mathLib.frac(x.y), mathLib.frac(x.z), mathLib.frac(x.w))
end
function mathLib.sign(x)
	return 0 < x and 1 or x < 0 and -1 or 0
end
function mathLib.signVec2(x)
	return mathLib.vec2(mathLib.sign(x.x), mathLib.sign(x.y))
end
function mathLib.signVec3(x)
	return mathLib.vec3(mathLib.sign(x.x), mathLib.sign(x.y), mathLib.sign(x.z))
end
function mathLib.signVec4(x)
	return mathLib.vec4(mathLib.sign(x.x), mathLib.sign(x.y), mathLib.sign(x.z), mathLib.sign(x.w))
end
function mathLib.pow(x, y)
	return math.pow(x, y)
end
function mathLib.powVec2(x, y)
	return mathLib.vec2(mathLib.pow(x.x, y.x), mathLib.pow(x.y, y.y))
end
function mathLib.powVec3(x, y)
	return mathLib.vec3(mathLib.pow(x.x, y.x), mathLib.pow(x.y, y.y), mathLib.pow(x.z, y.z))
end
function mathLib.powVec4(x, y)
	return mathLib.vec4(mathLib.pow(x.x, y.x), mathLib.pow(x.y, y.y), mathLib.pow(x.z, y.z), mathLib.pow(x.w, y.w))
end
function mathLib.exp(x)
	return math.exp(x)
end
function mathLib.expVec2(x)
	return mathLib.vec2(mathLib.exp(x.x), mathLib.exp(x.y))
end
function mathLib.expVec3(x)
	return mathLib.vec3(mathLib.exp(x.x), mathLib.exp(x.y), mathLib.exp(x.z))
end
function mathLib.expVec4(x)
	return mathLib.vec4(mathLib.exp(x.x), mathLib.exp(x.y), mathLib.exp(x.z), mathLib.exp(x.w))
end
function mathLib.log(x)
	return math.log(x)
end
function mathLib.logVec2(x)
	return mathLib.vec2(mathLib.log(x.x), mathLib.log(x.y))
end
function mathLib.logVec3(x)
	return mathLib.vec3(mathLib.log(x.x), mathLib.log(x.y), mathLib.log(x.z))
end
function mathLib.logVec4(x)
	return mathLib.vec4(mathLib.log(x.x), mathLib.log(x.y), mathLib.log(x.z), mathLib.log(x.w))
end
function mathLib.log2(x)
	return math.log(x, 2)
end
function mathLib.log2Vec2(x)
	return mathLib.vec2(mathLib.log2(x.x), mathLib.log2(x.y))
end
function mathLib.log2Vec3(x)
	return mathLib.vec3(mathLib.log2(x.x), mathLib.log2(x.y), mathLib.log2(x.z))
end
function mathLib.log2Vec4(x)
	return mathLib.vec4(mathLib.log2(x.x), mathLib.log2(x.y), mathLib.log2(x.z), mathLib.log2(x.w))
end
function mathLib.log10(x)
	return math.log10(x)
end
function mathLib.log10Vec2(x)
	return mathLib.vec2(mathLib.log10(x.x), mathLib.log10(x.y))
end
function mathLib.log10Vec3(x)
	return mathLib.vec3(mathLib.log10(x.x), mathLib.log10(x.y), mathLib.log10(x.z))
end
function mathLib.log10Vec4(x)
	return mathLib.vec4(mathLib.log10(x.x), mathLib.log10(x.y), mathLib.log10(x.z), mathLib.log10(x.w))
end
function mathLib.fmod(x, y)
	return x % y
end
function mathLib.fmodVec2(x, y)
	return mathLib.vec2(mathLib.fmod(x.x, y.x), mathLib.fmod(x.y, y.y))
end
function mathLib.fmodVec3(x, y)
	return mathLib.vec3(mathLib.fmod(x.x, y.x), mathLib.fmod(x.y, y.y), mathLib.fmod(x.z, y.z))
end
function mathLib.fmodVec4(x, y)
	return mathLib.vec4(mathLib.fmod(x.x, y.x), mathLib.fmod(x.y, y.y), mathLib.fmod(x.z, y.z), mathLib.fmod(x.w, y.w))
end
function mathLib.sqrt(x)
	return math.sqrt(x)
end
function mathLib.sqrtVec2(p)
	return mathLib.vec2(mathLib.sqrt(p.x), mathLib.sqrt(p.y))
end
function mathLib.sqrtVec3(p)
	return mathLib.vec3(mathLib.sqrt(p.x), mathLib.sqrt(p.y), mathLib.sqrt(p.z))
end
function mathLib.sqrtVec4(p)
	return mathLib.vec4(mathLib.sqrt(p.x), mathLib.sqrt(p.y), mathLib.sqrt(p.z), mathLib.sqrt(p.w))
end
function mathLib.rsqrt(x)
	return 1.0 / mathLib.sqrt(x)
end
function mathLib.rsqrtVec2(p)
	return 1.0 / mathLib.sqrtVec2(p)
end
function mathLib.rsqrtVec3(p)
	return 1.0 / mathLib.sqrtVec3(p)
end
function mathLib.rsqrtVec4(p)
	return 1.0 / mathLib.sqrtVec4(p)
end
function mathLib.normalize(p)
	return mathLib.MulVec2(mathLib.rsqrt(mathLib.dotVec2(p, p)), p)
end
function mathLib.normalizeVec3(p)
	return mathLib.MulVec3(mathLib.rsqrt(mathLib.dotVec3(p, p)), p)
end
function mathLib.normalizeVec4(p)
	return mathLib.MulVec4(mathLib.rsqrt(mathLib.dotVec4(p, p)), p)
end
function mathLib.length(x)
	return math.abs(x)
end
function mathLib.lengthVec2(p)
	return mathLib.sqrt(mathLib.dotVec2(p, p))
end
function mathLib.lengthVec3(p)
	return mathLib.sqrt(mathLib.dotVec3(p, p))
end
function mathLib.lengthVec4(p)
	return mathLib.sqrt(mathLib.dotVec4(p, p))
end
function mathLib.lengthsq(x)
	return x * x
end
function mathLib.lengthsqVec2(p)
	return mathLib.dotVec2(p, p)
end
function mathLib.lengthsqVec3(p)
	return mathLib.dotVec3(p, p)
end
function mathLib.lengthsqVec4(p)
	return mathLib.dotVec4(p, p)
end
function mathLib.distance(x, y)
	return mathLib.length(y - x)
end
function mathLib.distanceVec2(p1, p2)
	return mathLib.lengthVec2(mathLib.SubVec2(p2, p1))
end
function mathLib.distanceVec3(p1, p2)
	return mathLib.lengthVec3(mathLib.SubVec3(p2, p1))
end
function mathLib.distanceVec4(p1, p2)
	return mathLib.lengthVec4(mathLib.SubVec4(p2, p1))
end
function mathLib.min(x, y)
	return math.min(x, y)
end
function mathLib.minVec2(x, y)
	return mathLib.vec2(mathLib.min(x.x, y.x), mathLib.min(x.y, y.y))
end
function mathLib.minVec3(x, y)
	return mathLib.vec3(mathLib.min(x.x, y.x), mathLib.min(x.y, y.y), mathLib.min(x.z, y.z))
end
function mathLib.minVec4(x, y)
	return mathLib.vec4(mathLib.min(x.x, y.x), mathLib.min(x.y, y.y), mathLib.min(x.z, y.z), mathLib.min(x.w, y.w))
end
function mathLib.max(x, y)
	return math.max(x, y)
end
function mathLib.maxVec2(x, y)
	return mathLib.vec2(mathLib.max(x.x, y.x), mathLib.max(x.y, y.y))
end
function mathLib.maxVec3(x, y)
	return mathLib.vec3(mathLib.max(x.x, y.x), mathLib.max(x.y, y.y), mathLib.max(x.z, y.z))
end
function mathLib.maxVec4(x, y)
	return mathLib.vec4(mathLib.max(x.x, y.x), mathLib.max(x.y, y.y), mathLib.max(x.z, y.z), mathLib.max(x.w, y.w))
end
function mathLib.lerp(x, y, s)
	return x + s * (y - x)
end
function mathLib.lerpVec2(x, y, s)
	return mathLib.AddVec2(x, mathLib.MulVec2(s, mathLib.SubVec2(y, x)))
end
function mathLib.lerpVec3(x, y, s)
	return mathLib.AddVec3(x, mathLib.MulVec3(s, mathLib.SubVec3(y, x)))
end
function mathLib.lerpVec4(x, y, s)
	return mathLib.AddVec4(x, mathLib.MulVec4(s, mathLib.SubVec4(y, x)))
end
function mathLib.clamp(x, a, b)
	return mathLib.max(a, mathLib.min(b, x))
end
function mathLib.clampVec2(x, a, b)
	return mathLib.maxVec2(a, mathLib.minVec2(b, x))
end
function mathLib.clampVec3(x, a, b)
	return mathLib.maxVec3(a, mathLib.minVec3(b, x))
end
function mathLib.clampVec4(x, a, b)
	return mathLib.maxVec4(a, mathLib.minVec4(b, x))
end
function mathLib.saturate(x)
	return mathLib.clamp(x, 0, 1)
end
function mathLib.saturateVec2(x)
	return mathLib.clampVec2(x, mathLib.vec2_1(0), mathLib.vec2_1(1))
end
function mathLib.saturateVec3(x)
	return mathLib.clampVec3(x, mathLib.vec3_1(0), mathLib.vec3_1(1))
end
function mathLib.saturateVec4(x)
	return mathLib.clampVec4(x, mathLib.vec4_1(0), mathLib.vec4_1(1))
end
function mathLib.smoothstep(a, b, x)
	local t = mathLib.saturate((x - a) / (b - a))
	return t * t * (3 - 2 * t)
end
function mathLib.smoothstepVec2(a, b, x)
	return mathLib.vec2(mathLib.smoothstep(a.x, b.x, x.x), mathLib.smoothstep(a.y, b.y, x.y))
end
function mathLib.smoothstepVec3(a, b, x)
	return mathLib.vec3(mathLib.smoothstep(a.x, b.x, x.x), mathLib.smoothstep(a.y, b.y, x.y), mathLib.smoothstep(a.z, b.z, x.z))
end
function mathLib.smoothstepVec4(a, b, x)
	return mathLib.vec4(mathLib.smoothstep(a.x, b.x, x.x), mathLib.smoothstep(a.y, b.y, x.y), mathLib.smoothstep(a.z, b.z, x.z), mathLib.smoothstep(a.w, b.w, x.w))
end
function mathLib.smooth(a, b, x)
	local t = mathLib.saturate(x)
	local m = t * t * (3 - 2 * t)
	return mathLib.lerp(a, b, m)
end
function mathLib.smoothVec2(a, b, x)
	return mathLib.vec2(mathLib.smooth(a.x, b.x, x.x), mathLib.smooth(a.y, b.y, x.y))
end
function mathLib.smoothVec3(a, b, x)
	return mathLib.vec3(mathLib.smooth(a.x, b.x, x.x), mathLib.smooth(a.y, b.y, x.y), mathLib.smooth(a.z, b.z, x.z))
end
function mathLib.smoothVec4(a, b, x)
	return mathLib.vec4(mathLib.smooth(a.x, b.x, x.x), mathLib.smooth(a.y, b.y, x.y), mathLib.smooth(a.z, b.z, x.z), mathLib.smooth(a.w, b.w, x.w))
end
mathLib.Init()
return mathLib
