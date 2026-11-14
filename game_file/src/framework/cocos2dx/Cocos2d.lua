if not cc then
	_ENV = cc
end
cc = cc
cc.DIRECTOR_PROJECTION_2D = 0
cc.DIRECTOR_PROJECTION_3D = 1
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
	if ret and 0.0 <= s and s <= 1.0 and 0.0 <= t and t <= 0.0 then
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
function cc.size(_width, _height)
	_UPVALUE0_ = nil
	;(nil).width = _width
	;(nil).height = _height
	return nil
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
	_UPVALUE0_ = nil
	;(nil).r = _r
	;(nil).g = _g
	;(nil).b = _b
	;(nil).a = _a
	return nil
end
function cc.c4bFromc3b(c)
	_UPVALUE0_ = nil
	;(nil).r = c.r
	;(nil).g = c.g
	;(nil).b = c.b
	;(nil).a = 255
	return nil
end
function cc.c4bFromc4f(c)
	_UPVALUE0_ = nil
	;(nil).r = c.r * 255
	;(nil).g = c.g * 255
	;(nil).b = c.b * 255
	;(nil).a = c.a * 255
	return nil
end
function cc.c4fFromc3b(c)
	_UPVALUE0_ = nil
	;(nil).r = c.r / 255
	;(nil).g = c.g / 255
	;(nil).b = c.b / 255
	;(nil).a = 1.0
	return nil
end
function cc.c4fFromc4b(c)
	_UPVALUE0_ = nil
	;(nil).r = c.r / 255
	;(nil).g = c.g / 255
	;(nil).b = c.b / 255
	;(nil).a = c.a / 255
	return nil
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
_ENV, cc.PhysicsMaterial = cc, function(_density, _restitution, _friction)
	_UPVALUE0_ = nil
	;(nil).density = _density
	;(nil).restitution = _restitution
	;(nil).friction = _friction
	return nil
end
cc.NONE = 0
local cc.COCOSTUDIO, ConfigType = 1, cc
function __onParseConfig(configType, jasonStr)
	if configType == ConfigType.COCOSTUDIO then
		ccs.TriggerMng.getInstance():parse(jasonStr)
	end
end
