local roaringFlameWarRead = include("roaringFlameWarRead")
_UPVALUE6_ = "roaringFlameWarRead"
_UPVALUE6_, ("roaringFlameWarRead")[1] = "SinglePicture/frame_9001674_jiantou1.png", "SinglePicture/frame_9001674_jiantou1.png"
_UPVALUE6_, ("roaringFlameWarRead")[2] = "SinglePicture/frame_9001674_jiantou1.png", "SinglePicture/frame_9001674_jiantou2.png"
_UPVALUE6_, ("roaringFlameWarRead")[3] = "SinglePicture/frame_9001674_jiantou1.png", "SinglePicture/frame_9001674_jiantou3.png"
_UPVALUE6_, ("roaringFlameWarRead")[4] = "SinglePicture/frame_9001674_jiantou1.png", "SinglePicture/frame_9001674_shixian.png"
_UPVALUE6_, ("roaringFlameWarRead")[5] = "SinglePicture/frame_9001674_jiantou1.png", "SinglePicture/frame_9001674_xuxian.png"
local _UPVALUE6_, ("roaringFlameWarRead")[6], lineType2texture = "SinglePicture/frame_9001674_jiantou1.png", "SinglePicture/frame_9001674_xuxian_1.png", "roaringFlameWarRead"
;("SinglePicture/frame_9001674_jiantou1.png")[1] = 28
;("SinglePicture/frame_9001674_jiantou1.png")[2] = 28
;("SinglePicture/frame_9001674_jiantou1.png")[3] = 28
;("SinglePicture/frame_9001674_jiantou1.png")[4] = 4
;("SinglePicture/frame_9001674_jiantou1.png")[5] = 4
local ("SinglePicture/frame_9001674_jiantou1.png")[6], lineType2stepWidth = 28, "SinglePicture/frame_9001674_jiantou1.png"
local worldMapRoaringFlameLine = class("worldMapRoaringFlameLine", function(beginPoint, endPoint, lineType)
	local distance = cc.pGetDistance(beginPoint, endPoint)
	local fileName = lineType2texture[lineType] or lineType2texture[1]
	local moveLineStepWidth = lineType2stepWidth[lineType] or lineType2stepWidth[1]
	local preSprite = display.newTilesSprite(fileName, cc.rect(0, 0, distance, moveLineStepWidth), true)
	preSprite:setAutoCull(false)
	preSprite:setAnchorPoint(0, 0.5)
	preSprite.distance = distance
	return preSprite
end)
function worldMapRoaringFlameLine:ctor(beginPoint, endPoint, lineType)
	local rotation = -SoraDGetAngleByPos(beginPoint, endPoint)
	self:setRotation(rotation)
	self:setLineType(lineType)
end
function worldMapRoaringFlameLine:setLineType(lineType)
	if lineType == 1 then
		SoraDcreateMarchSpriteWithProgramName(self, 3, "marchMove_1")
	elseif lineType == 2 then
		SoraDcreateMarchSpriteWithProgramName(self, 3, "marchMove_2")
	elseif lineType == 3 then
		SoraDcreateMarchSprite(self, 3)
	end
end
function worldMapRoaringFlameLine:changeLineType(lineType)
	self:setLineType(lineType)
	self:setTexture(lineType2texture[lineType])
end
function worldMapRoaringFlameLine:setMoveLineColor(colorType, isGatewayLine)
	local color = roaringFlameWarRead.getCampBuildLineColor(colorType)
	if isGatewayLine and colorType == 0 then
		color = cc.c3b(187, 0, 0)
	end
	self:setColor(color)
end
return worldMapRoaringFlameLine
