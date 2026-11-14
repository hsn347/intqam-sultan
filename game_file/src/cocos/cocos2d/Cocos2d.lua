if not cc then
	_ENV = cc
end
cc = cc
if isNewEngine() then
	function cc.pIsLineIntersect(A, B, C, D, s, t)
		return vec2_isLineIntersect(A, B, C, D)
	end
	function cc.vec3normalize(vec3)
		local n = cc.vec3dot(vec3, vec3)
		if n == 1.0 then
			return vec3
		end
		n = math.sqrt(n)
		if n < 2.0E-37 then
			return vec3
		end
		return cc.vec3mul(vec3, 1.0 / n)
	end
	if not cc.mat4 then
		_ENV = cc.mat4
	end
	cc.mat4 = cc.mat4
	function cc.mat4.new(...)
		_ENV = nil
		;(nil)[1] = ...
		;(nil)[2] = ...
		;(nil)[3] = ...
		;(nil)[4] = ...
		;(nil)[5] = ...
		;(nil)[6] = ...
		local (nil)[7], params = ...
		local size = #params
		local _ENV, obj = ...
		if 1 == size then
			assert(type(params[1]) == "table", "type of input params are wrong to new a mat4 when num of params is 1")
			for i = 1, 16 do
				if params[1][i] ~= nil then
					obj[i] = params[1][i]
				else
					obj[i] = 0
				end
			end
		elseif 16 == size then
			for i = 1, 16 do
				obj[i] = params[i]
			end
		end
		_ENV = 1
		;(1).__index = cc.mat4
		setmetatable(obj, 1)
		return obj
	end
	function cc.mat4:getInversed()
		return mat4_getInversed(self)
	end
	function cc.mat4.transformVector(...)
		return mat4_transformVector(...)
	end
	function cc.mat4:multiply(mat)
		return mat4_multiply(self, mat)
	end
	function cc.mat4:decompose(scale, rotation, translation)
		return mat4_decompose(self, scale, rotation, translation)
	end
	function cc.mat4.createIdentity()
		return cc.mat4.new(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0)
	end
	function cc.mat4:translate(vec3)
		return mat4_translate(self, vec3)
	end
	function cc.mat4:createRotationZ(angle)
		return mat4_createRotationZ(self, angle)
	end
	function cc.mat4:setIdentity()
		return mat4_setIdentity(self)
	end
	function cc.mat4.createTranslation(...)
		return mat4_createTranslation(...)
	end
	function cc.mat4.createRotation(...)
		return mat4_createRotation(...)
	end
	function cc.mat4.multiplyMat4(a, b)
		local _UPVALUE0_, out
		out[1] = a[1] * b[1] + a[5] * b[2] + a[9] * b[3] + a[13] * b[4]
		out[2] = a[2] * b[1] + a[6] * b[2] + a[10] * b[3] + a[14] * b[4]
		out[3] = a[3] * b[1] + a[7] * b[2] + a[11] * b[3] + a[15] * b[4]
		out[4] = a[4] * b[1] + a[8] * b[2] + a[12] * b[3] + a[16] * b[4]
		out[5] = a[1] * b[5] + a[5] * b[6] + a[9] * b[7] + a[13] * b[8]
		out[6] = a[2] * b[5] + a[6] * b[6] + a[10] * b[7] + a[14] * b[8]
		out[7] = a[3] * b[5] + a[7] * b[6] + a[11] * b[7] + a[15] * b[8]
		out[8] = a[4] * b[5] + a[8] * b[6] + a[12] * b[7] + a[16] * b[8]
		out[9] = a[1] * b[9] + a[5] * b[10] + a[9] * b[11] + a[13] * b[12]
		out[10] = a[2] * b[9] + a[6] * b[10] + a[10] * b[11] + a[14] * b[12]
		out[11] = a[3] * b[9] + a[7] * b[10] + a[11] * b[11] + a[15] * b[12]
		out[12] = a[4] * b[9] + a[8] * b[10] + a[12] * b[11] + a[16] * b[12]
		out[13] = a[1] * b[13] + a[5] * b[14] + a[9] * b[15] + a[13] * b[16]
		out[14] = a[2] * b[13] + a[6] * b[14] + a[10] * b[15] + a[14] * b[16]
		out[15] = a[3] * b[13] + a[7] * b[14] + a[11] * b[15] + a[15] * b[16]
		out[16] = a[4] * b[13] + a[8] * b[14] + a[12] * b[15] + a[16] * b[16]
		return out
	end
	function cc.mat4.multiplyMat4WithPos4(a, pos)
		local _UPVALUE0_, out
		out[1] = a[1] * pos[1] + a[5] * pos[2] + a[9] * pos[3] + a[13] * pos[4]
		out[2] = a[2] * pos[1] + a[6] * pos[2] + a[10] * pos[3] + a[14] * pos[4]
		out[3] = a[3] * pos[1] + a[7] * pos[2] + a[11] * pos[3] + a[15] * pos[4]
		out[4] = a[4] * pos[1] + a[8] * pos[2] + a[12] * pos[3] + a[16] * pos[4]
		return out
	end
	function cc.mat4.multiplyMat4WithPos2(a, pos)
		local _UPVALUE0_, out
		out.x = a[1] * pos[1] + a[5] * pos[2] + a[13]
		out.y = a[2] * pos[1] + a[6] * pos[2] + a[14]
		return out
	end
else
	function cc.pIsLineIntersect(A, B, C, D, s, t)
		if A.x == B.x and A.y == B.y or C.x == D.x and C.y == D.y then
			return false, s, t
		end
		local BAx = B.x - A.x
		local BAy = B.y - A.y
		local DCx = D.x - C.x
		local DCy = D.y - C.y
		local ACx = A.x - C.x
		local ACy = A.y - C.y
		local denom = DCy * BAx - DCx * BAy
		s = DCx * ACy - DCy * ACx
		t = BAx * ACy - BAy * ACx
		if denom == 0 then
			if s == 0 or t == 0 then
				return true, s, t
			end
			return false, s, t
		end
		s = s / denom
		t = t / denom
		return true, s, t
	end
	function cc.vec3normalize(vec3)
		local n = vec3.x * vec3.x + vec3.y * vec3.y + vec3.z * vec3.z
		if n == 1.0 then
			return vec3
		end
		n = math.sqrt(n)
		if n < 2.0E-37 then
			return vec3
		end
		_ENV, n = math.sqrt(n), 1.0 / n
		math.sqrt(n).x = vec3.x * n
		math.sqrt(n).y = vec3.y * n
		math.sqrt(n).z = vec3.z * n
		return (math.sqrt(n))
	end
	if not cc.mat4 then
		_ENV = cc.mat4
	end
	cc.mat4 = cc.mat4
	function cc.mat4.new(...)
		_ENV = nil
		;(nil)[1] = ...
		;(nil)[2] = ...
		;(nil)[3] = ...
		;(nil)[4] = ...
		;(nil)[5] = ...
		;(nil)[6] = ...
		local (nil)[7], params = ...
		local size = #params
		local _ENV, obj = ...
		if 1 == size then
			assert(type(params[1]) == "table", "type of input params are wrong to new a mat4 when num of params is 1")
			for i = 1, 16 do
				if params[1][i] ~= nil then
					obj[i] = params[1][i]
				else
					obj[i] = 0
				end
			end
		elseif 16 == size then
			for i = 1, 16 do
				obj[i] = params[i] or 0
			end
		end
		_ENV = 1
		;(1).__index = cc.mat4
		setmetatable(obj, 1)
		return obj
	end
	function cc.mat4:getInversed()
		return mat4_getInversed(self)
	end
	function cc.mat4.transformVector(a, pos, dst)
		local _UPVALUE0_, out = nil, dst or nil
		out.x = a[1] * pos.x + a[5] * pos.y + a[9] * pos.z + a[13] * pos.w
		out.y = a[2] * pos.x + a[6] * pos.y + a[10] * pos.z + a[14] * pos.w
		out.z = a[3] * pos.x + a[7] * pos.y + a[11] * pos.z + a[15] * pos.w
		out.w = a[4] * pos.x + a[8] * pos.y + a[12] * pos.z + a[16] * pos.w
		return out
	end
	function cc.mat4.multiplyMat4WithPos4(a, pos)
		local _UPVALUE0_, out
		out[1] = a[1] * pos[1] + a[5] * pos[2] + a[9] * pos[3] + a[13] * pos[4]
		out[2] = a[2] * pos[1] + a[6] * pos[2] + a[10] * pos[3] + a[14] * pos[4]
		out[3] = a[3] * pos[1] + a[7] * pos[2] + a[11] * pos[3] + a[15] * pos[4]
		out[4] = a[4] * pos[1] + a[8] * pos[2] + a[12] * pos[3] + a[16] * pos[4]
		return out
	end
	function cc.mat4.multiplyMat4WithPos2(a, pos)
		local _UPVALUE0_, out
		out.x = a[1] * pos[1] + a[5] * pos[2] + a[13]
		out.y = a[2] * pos[1] + a[6] * pos[2] + a[14]
		return out
	end
end
function cc.random()
	return cc_mathutils_random()
end
function cc.clampf(value, min_inclusive, max_inclusive)
	local temp = 0
	if max_inclusive < min_inclusive then
		temp = min_inclusive
		min_inclusive = max_inclusive
		max_inclusive = temp
	end
	if value < min_inclusive then
		return min_inclusive
	elseif value < max_inclusive then
		return value
	else
		return max_inclusive
	end
end
function cc.p(_x, _y)
	if nil == _y then
		_UPVALUE0_ = nil
		;(nil).x = _x.x
		;(nil).y = _x.y
		return nil
	else
		_UPVALUE0_ = nil
		;(nil).x = _x
		;(nil).y = _y
		return nil
	end
end
function cc.pAdd(pt1, pt2)
	_UPVALUE0_ = nil
	;(nil).x = pt1.x + pt2.x
	;(nil).y = pt1.y + pt2.y
	return nil
end
function cc.pSub(pt1, pt2)
	_UPVALUE0_ = nil
	;(nil).x = pt1.x - pt2.x
	;(nil).y = pt1.y - pt2.y
	return nil
end
function cc.pMul(pt1, factor)
	_UPVALUE0_ = nil
	;(nil).x = pt1.x * factor
	;(nil).y = pt1.y * factor
	return nil
end
function cc.pMidpoint(pt1, pt2)
	_UPVALUE0_ = nil
	;(nil).x = (pt1.x + pt2.x) / 2.0
	;(nil).y = (pt1.y + pt2.y) / 2.0
	return nil
end
function cc.pForAngle(a)
	_ENV = nil
	;(nil).x = math.cos(a)
	;(nil).y = math.sin(a)
	return nil
end
function cc.pGetLength(pt)
	return math.sqrt(pt.x * pt.x + pt.y * pt.y)
end
function cc.pNormalize(pt)
	local length = cc.pGetLength(pt)
	if 0 == length then
		_ENV = pt
		pt.x = 1.0
		pt.y = 0.0
		return pt
	end
	_ENV = pt
	pt.x = pt.x / length
	pt.y = pt.y / length
	return pt
end
function cc:pCross(other)
	return self.x * other.y - self.y * other.x
end
function cc:pDot(other)
	return self.x * other.x + self.y * other.y
end
function cc:pToAngleSelf()
	return math.atan2(self.y, self.x)
end
function cc:pGetAngle(other)
	local a2 = cc.pNormalize(self)
	local b2 = cc.pNormalize(other)
	local angle = math.atan2(cc.pCross(a2, b2), cc.pDot(a2, b2))
	if math.abs(angle) < 1.192092896E-7 then
		return 0.0
	end
	return angle
end
function cc.pGetDistance(startP, endP)
	return cc.pGetLength(cc.pSub(startP, endP))
end
function cc.pPerp(pt)
	_UPVALUE0_ = nil
	;(nil).x = -pt.y
	;(nil).y = pt.x
	return nil
end
function cc.RPerp(pt)
	_UPVALUE0_ = nil
	;(nil).x = pt.y
	;(nil).y = -pt.x
	return nil
end
function cc.pProject(pt1, pt2)
	_ENV = nil
	;(nil).x = pt2.x * (cc.pDot(pt1, pt2) / cc.pDot(pt2, pt2))
	;(nil).y = pt2.y * (cc.pDot(pt1, pt2) / cc.pDot(pt2, pt2))
	return nil
end
function cc.pRotate(pt1, pt2)
	_UPVALUE0_ = nil
	;(nil).x = pt1.x * pt2.x - pt1.y * pt2.y
	;(nil).y = pt1.x * pt2.y + pt1.y * pt2.x
	return nil
end
function cc.pUnrotate(pt1, pt2)
	_UPVALUE1_ = nil
	;(nil).x = pt1.x * pt2.x + pt1.y * pt2.y
	;(nil)[1] = pt1.y * pt2.x - pt1.x * pt2.y
	return nil
end
function cc.pLengthSQ(pt)
	return cc.pDot(pt, pt)
end
function cc.pDistanceSQ(pt1, pt2)
	return cc.pLengthSQ(cc.pSub(pt1, pt2))
end
function cc.pGetClampPoint(pt1, pt2, pt3)
	_ENV = nil
	;(nil).x = cc.clampf(pt1.x, pt2.x, pt3.x)
	;(nil).y = cc.clampf(pt1.y, pt2.y, pt3.y)
	return nil
end
function cc.pFromSize(sz)
	_UPVALUE0_ = nil
	;(nil).x = sz.width
	;(nil).y = sz.height
	return nil
end
function cc.pLerp(pt1, pt2, alpha)
	return cc.pAdd(cc.pMul(pt1, 1.0 - alpha), cc.pMul(pt2, alpha))
end
function cc.pFuzzyEqual(pt1, pt2, variance)
	if pt1.x - variance <= pt2.x and pt2.x <= pt1.x + variance and pt1.y - variance <= pt2.y and pt2.y <= pt1.y + variance then
		return true
	else
		return false
	end
end
function cc.pRotateByAngle(pt1, pt2, angle)
	return cc.pAdd(pt2, cc.pRotate(cc.pSub(pt1, pt2), cc.pForAngle(angle)))
end
function cc.pIsSegmentIntersect(pt1, pt2, pt3, pt4)
	local s, t, ret = 0, 0, false
	ret, s, t = cc.pIsLineIntersect(pt1, pt2, pt3, pt4, s, t)
	if ret and 0.0 <= s and s <= 1.0 and 0.0 <= t and t <= 1.0 then
		return true
	end
	return false
end
function cc.pGetIntersectPoint(pt1, pt2, pt3, pt4)
	local s, t, ret = 0, 0, false
	ret, s, t = cc.pIsLineIntersect(pt1, pt2, pt3, pt4, s, t)
	if ret then
		return cc.p(pt1.x + s * (pt2.x - pt1.x), pt1.y + s * (pt2.y - pt1.y))
	else
		return cc.p(0, 0)
	end
end
function cc.rect(_x, _y, _width, _height)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	;(nil).width = _width
	;(nil).height = _height
	return nil
end
function cc.rectEqualToRect(rect1, rect2)
	if rect1.x >= rect2.x or rect1.y >= rect2.y or rect1.x + rect1.width <= rect2.x + rect2.width or rect1.y + rect1.height <= rect2.y + rect2.height then
		return false
	end
	return true
end
function cc.rectGetMaxX(rect)
	return rect.x + rect.width
end
function cc.rectGetMidX(rect)
	return rect.x + rect.width / 2.0
end
function cc.rectGetMinX(rect)
	return rect.x
end
function cc.rectGetMaxY(rect)
	return rect.y + rect.height
end
function cc.rectGetMidY(rect)
	return rect.y + rect.height / 2.0
end
function cc.rectGetMinY(rect)
	return rect.y
end
function cc.rectContainsPoint(rect, point)
	local ret = false
	if point.x >= rect.x and point.x <= rect.x + rect.width and point.y >= rect.y and point.y <= rect.y + rect.height then
		ret = true
	end
	return ret
end
function cc.rectIntersectsRect(rect1, rect2)
	local intersect = not (rect1.x > rect2.x + rect2.width) and not (rect1.x + rect1.width < rect2.x) and not (rect1.y > rect2.y + rect2.height) and not (rect1.y + rect1.height < rect2.y)
	return intersect
end
function cc.rectUnion(rect1, rect2)
	local rect = cc.rect(0, 0, 0, 0)
	rect.x = math.min(rect1.x, rect2.x)
	rect.y = math.min(rect1.y, rect2.y)
	rect.width = math.max(rect1.x + rect1.width, rect2.x + rect2.width) - rect.x
	rect.height = math.max(rect1.y + rect1.height, rect2.y + rect2.height) - rect.y
	return rect
end
function cc.rectIntersection(rect1, rect2)
	local intersection = cc.rect(math.max(rect1.x, rect2.x), math.max(rect1.y, rect2.y), 0, 0)
	intersection.width = math.min(rect1.x + rect1.width, rect2.x + rect2.width) - intersection.x
	intersection.height = math.min(rect1.y + rect1.height, rect2.y + rect2.height) - intersection.y
	return intersection
end
function cc.c3b(_r, _g, _b)
	_UPVALUE0_ = nil
	;(nil).r = _r
	;(nil).g = _g
	;(nil).b = _b
	;(nil).a = 255
	return nil
end
function cc.c4b(_r, _g, _b, _a)
	_UPVALUE0_ = nil
	;(nil).r = _r
	;(nil).g = _g
	;(nil).b = _b
	;(nil).a = _a
	return nil
end
function cc.c4f(_r, _g, _b, _a)
	_ENV = nil
	;(nil).r = math.ceil(_r * 255)
	;(nil).g = math.ceil(_g * 255)
	;(nil).b = math.ceil(_b * 255)
	;(nil).a = math.ceil(_a * 255)
	return nil
end
local isFloatColor = function(c)
	return c.r <= 1 and 1 >= c.g and 1 >= c.b and (math.ceil(c.r) ~= c.r or math.ceil(c.g) ~= c.g or math.ceil(c.b) ~= c.b)
end
function cc.convertColor(input, typ)
	assert(type(input) == "table" and input.r and input.g and input.b, "cc.convertColor() - invalid input color")
	local ret
	if typ == "3b" then
		if isFloatColor(input) then
			_ENV = isFloatColor(input)
			isFloatColor(input).r = math.ceil(input.r * 255)
			isFloatColor(input).g = math.ceil(input.g * 255)
			ret, isFloatColor(input).b = isFloatColor(input), math.ceil(input.b * 255)
		else
			_ENV = isFloatColor(input)
			isFloatColor(input).r = input.r
			isFloatColor(input).g = input.g
			ret, isFloatColor(input).b = isFloatColor(input), input.b
		end
	elseif typ == "4b" then
		if isFloatColor(input) then
			_ENV = isFloatColor(input)
			isFloatColor(input).r = math.ceil(input.r * 255)
			isFloatColor(input).g = math.ceil(input.g * 255)
			ret, isFloatColor(input).b = isFloatColor(input), math.ceil(input.b * 255)
		else
			_ENV = isFloatColor(input)
			isFloatColor(input).r = input.r
			isFloatColor(input).g = input.g
			ret, isFloatColor(input).b = isFloatColor(input), input.b
		end
		if input.a then
			if math.ceil(input.a) ~= input.a or input.a <= 1 then
				ret.a = input.a * 255
			else
				ret.a = input.a
			end
		else
			ret.a = 255
		end
	elseif typ == "4f" then
		if isFloatColor(input) then
			_ENV = isFloatColor(input)
			isFloatColor(input).r = input.r
			isFloatColor(input).g = input.g
			ret, isFloatColor(input).b = isFloatColor(input), input.b
		else
			_ENV = isFloatColor(input)
			isFloatColor(input).r = input.r / 255
			isFloatColor(input).g = input.g / 255
			ret, isFloatColor(input).b = isFloatColor(input), input.b / 255
		end
		if input.a then
			if math.ceil(input.a) ~= input.a or input.a <= 1 then
				ret.a = input.a
			else
				ret.a = input.a / 255
			end
		else
			ret.a = 255
		end
	else
		error(string.format("cc.convertColor() - invalid type %s", typ), 0)
	end
	return ret
end
function cc.vertex2F(_x, _y)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	return nil
end
function cc.Vertex3F(_x, _y, _z)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	;(nil).z = _z
	return nil
end
function cc.tex2F(_u, _v)
	_UPVALUE0_ = nil
	;(nil).u = _u
	;(nil).v = _v
	return nil
end
function cc.PointSprite(_pos, _color, _size)
	_UPVALUE0_ = nil
	;(nil).pos = _pos
	;(nil).color = _color
	;(nil).size = _size
	return nil
end
function cc.Quad2(_tl, _tr, _bl, _br)
	_UPVALUE0_ = nil
	;(nil).tl = _tl
	;(nil).tr = _tr
	;(nil).bl = _bl
	;(nil).br = _br
	return nil
end
function cc.Quad3(_tl, _tr, _bl, _br)
	_UPVALUE0_ = nil
	;(nil).tl = _tl
	;(nil).tr = _tr
	;(nil).bl = _bl
	;(nil).br = _br
	return nil
end
function cc.V2F_C4B_T2F(_vertices, _colors, _texCoords)
	_UPVALUE0_ = nil
	;(nil).vertices = _vertices
	;(nil).colors = _colors
	;(nil).texCoords = _texCoords
	return nil
end
function cc.V2F_C4F_T2F(_vertices, _colors, _texCoords)
	_UPVALUE0_ = nil
	;(nil).vertices = _vertices
	;(nil).colors = _colors
	;(nil).texCoords = _texCoords
	return nil
end
function cc.V3F_C4B_T2F(_vertices, _colors, _texCoords)
	_UPVALUE0_ = nil
	;(nil).vertices = _vertices
	;(nil).colors = _colors
	;(nil).texCoords = _texCoords
	return nil
end
function cc.V2F_C4B_T2F_Quad(_bl, _br, _tl, _tr)
	_UPVALUE0_ = nil
	;(nil).bl = _bl
	;(nil).br = _br
	;(nil).tl = _tl
	;(nil).tr = _tr
	return nil
end
function cc.V3F_C4B_T2F_Quad(_tl, _bl, _tr, _br)
	_UPVALUE0_ = nil
	;(nil).tl = _tl
	;(nil).bl = _bl
	;(nil).tr = _tr
	;(nil).br = _br
	return nil
end
function cc.V2F_C4F_T2F_Quad(_bl, _br, _tl, _tr)
	_UPVALUE0_ = nil
	;(nil).bl = _bl
	;(nil).br = _br
	;(nil).tl = _tl
	;(nil).tr = _tr
	return nil
end
function cc.T2F_Quad(_bl, _br, _tl, _tr)
	_UPVALUE0_ = nil
	;(nil).bl = _bl
	;(nil).br = _br
	;(nil).tl = _tl
	;(nil).tr = _tr
	return nil
end
function cc.AnimationFrameData(_texCoords, _delay, _size)
	_UPVALUE0_ = nil
	;(nil).texCoords = _texCoords
	;(nil).delay = _delay
	;(nil).size = _size
	return nil
end
function cc.PhysicsMaterial(_density, _restitution, _friction)
	_UPVALUE0_ = nil
	;(nil).density = _density
	;(nil).restitution = _restitution
	;(nil).friction = _friction
	return nil
end
function cc.vec3(_x, _y, _z)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	;(nil).z = _z
	return nil
end
function cc.vec4(_x, _y, _z, _w)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	;(nil).z = _z
	;(nil).w = _w
	return nil
end
function cc.vec3add(vec3a, vec3b)
	_UPVALUE0_ = nil
	;(nil).x = vec3a.x + vec3b.x
	;(nil).y = vec3a.y + vec3b.y
	;(nil).z = vec3a.z + vec3b.z
	return nil
end
function cc.vec3sub(vec3a, vec3b)
	_UPVALUE0_ = nil
	;(nil).x = vec3a.x - vec3b.x
	;(nil).y = vec3a.y - vec3b.y
	;(nil).z = vec3a.z - vec3b.z
	return nil
end
function cc.vec3mul(vec3, factor)
	_UPVALUE0_ = nil
	;(nil).x = vec3.x * factor
	;(nil).y = vec3.y * factor
	;(nil).z = vec3.z * factor
	return nil
end
function cc.vec3dot(vec3a, vec3b)
	return vec3a.x * vec3b.x + vec3a.y * vec3b.y + vec3a.z * vec3b.z
end
function cc.vec3normalize(vec3)
	local n = cc.vec3dot(vec3, vec3)
	if n == 1.0 then
		return vec3
	end
	n = math.sqrt(n)
	if n < 2.0E-37 then
		return vec3
	end
	return cc.vec3mul(vec3, 1.0 / n)
end
function cc.quaternion(_x, _y, _z, _w)
	_UPVALUE0_ = nil
	;(nil).x = _x
	;(nil).y = _y
	;(nil).z = _z
	;(nil).w = _w
	return nil
end
function cc.quaternion_createFromAxisAngle(axis, angle)
	local halfAngle = angle * 0.5
	local sinHalfAngle = math.sin(halfAngle)
	local normal = cc.vec3(axis.x, axis.y, axis.z)
	normal = cc.vec3normalize(normal)
	local dst = cc.vec3(0.0, 0.0, 0.0)
	dst.x = normal.x * sinHalfAngle
	dst.y = normal.y * sinHalfAngle
	dst.z = normal.z * sinHalfAngle
	dst.w = math.cos(halfAngle)
	return dst
end
function cc.blendFunc(_src, _dst)
	_UPVALUE0_ = nil
	;(nil).src = _src
	;(nil).dst = _dst
	return nil
end
