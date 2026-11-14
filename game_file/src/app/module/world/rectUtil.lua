local _ENV, rectUtil
function rectUtil.rect(ltX, ltY, rbX, rbY)
	_UPVALUE0_ = nil
	;(nil).ltX = ltX
	;(nil).ltY = ltY
	;(nil).rbX = rbX
	;(nil).rbY = rbY
	return nil
end
function rectUtil.getRectBySize(ltX, ltY, size)
	_UPVALUE0_ = nil
	;(nil).ltX = ltX
	;(nil).ltY = ltY
	;(nil).rbX = ltX + size - 1
	;(nil).rbY = ltY + size - 1
	return nil
end
function rectUtil.isConnect(rectA, rectB)
	return not rectUtil.isOverlap(rectUtil.getExpRect(rectA), rectB) or IS_SUPPORT_TERR_ANGLE_CONNECT or not rectUtil.isAngleConnect(rectA, rectB)
end
function rectUtil.isOverlap(rectA, rectB)
	return not (rectA.rbX < rectB.ltX) and not (rectA.ltX > rectB.rbX) and not (rectA.rbY < rectB.ltY) and not (rectA.ltY > rectB.rbY)
end
function rectUtil.isRectInRect(rect, outRect)
	return rect.ltX >= outRect.ltX and rect.ltY >= outRect.ltY and rect.rbX <= outRect.rbX and rect.rbY <= outRect.rbY
end
function rectUtil.isEdgeConnect(rectA, rectB)
	return (rectA.rbX == rectB.ltX - 1 or rectA.ltX == rectB.rbX + 1) and not (rectA.rbY < rectB.ltY) and not (rectA.ltY > rectB.rbY) or (rectA.rbY == rectB.ltY - 1 or rectA.ltY == rectB.rbY + 1) and not (rectA.rbX < rectB.ltX) and not (rectA.ltX > rectB.rbX)
end
function rectUtil.isAngleConnect(rectA, rectB)
	return (rectA.rbX == rectB.ltX - 1 or rectA.ltX == rectB.rbX + 1) and (rectA.rbY == rectB.ltY - 1 or rectA.ltY == rectB.rbY + 1)
end
function rectUtil.getExpRect(rect, l)
	_UPVALUE0_, l = nil, l or 1
	;(nil).ltX = rect.ltX - l
	;(nil).ltY = rect.ltY - l
	;(nil).rbX = rect.rbX + l
	;(nil).rbY = rect.rbY + l
	return nil
end
function rectUtil.expRect(rect, l)
	l = l or 1
	rect.ltX = rect.ltX - l
	rect.ltY = rect.ltY - l
	rect.rbX = rect.rbX + l
	rect.rbY = rect.rbY + l
	return rect
end
function rectUtil.getInterRect(rectA, rectB)
	_ENV = nil
	;(nil).ltX = math.max(rectA.ltX, rectB.ltX)
	;(nil).ltY = math.max(rectA.ltY, rectB.ltY)
	;(nil).rbX = math.min(rectA.rbX, rectB.rbX)
	;(nil).rbY = math.min(rectA.rbY, rectB.rbY)
	return nil
end
function rectUtil.setInterRect(rect, outRect)
	rect.ltX = math.max(rect.ltX, outRect.ltX)
	rect.ltY = math.max(rect.ltY, outRect.ltY)
	rect.rbX = math.min(rect.rbX, outRect.rbX)
	rect.rbY = math.min(rect.rbY, outRect.rbY)
	return rect
end
function rectUtil.getMBR(rectA, rectB)
	_ENV = nil
	;(nil).ltX = math.min(rectA.ltX, rectB.ltX)
	;(nil).ltY = math.min(rectA.ltY, rectB.ltY)
	;(nil).rbX = math.max(rectA.rbX, rectB.rbX)
	;(nil).rbY = math.max(rectA.rbY, rectB.rbY)
	return nil
end
function rectUtil.updateMBR(MBR, addRect)
	MBR.ltX = math.min(MBR.ltX or addRect.ltX, addRect.ltX)
	MBR.ltY = math.min(MBR.ltY or addRect.ltY, addRect.ltY)
	MBR.rbX = math.max(MBR.rbX or addRect.rbX, addRect.rbX)
	MBR.rbY = math.max(MBR.rbY or addRect.rbY, addRect.rbY)
	return MBR
end
function rectUtil.isPointInRect(x, y, rect)
	return x >= rect.ltX and x <= rect.rbX and y >= rect.ltY and y <= rect.rbY
end
function rectUtil.area(rect)
	return (rect.rbX - rect.ltX + 1) * (rect.rbY - rect.ltY + 1)
end
return rectUtil
