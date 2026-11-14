local SkeletonAnimation = class("SkeletonAnimation", fgui.GLoader3D)
function SkeletonAnimation:create(skelPath, atlasPath, scale, handle, isAsync)
	local sk = SkeletonAnimation.new()
	sk.isCocos = true
	sk:autoRelease()
	sk:setIsAsync(isAsync and isAsync or false)
	sk:setTouchable(false)
	sk:setTouchEnabled(false)
	sk:setAnchorPoint(0.5, 0.5)
	handle = handle or handler(self, self.callBack)
	scale = scale or 1.0
	sk:SetSpine(skelPath, handle, scale)
	return sk
end
function SkeletonAnimation:setAnimation(index, aniName, loop)
	self:setSpineAnimation(index, aniName, loop)
end
function SkeletonAnimation:playAnimationOnce()
end
function SkeletonAnimation:setAutoCull(value)
end
_ENV, SkeletonAnimation.callBack = function(self)
end, function(self)
end
local (function(self)
end)[3], eventTypeMap = "complete", function(self)
end
function SkeletonAnimation:registerSpineEventHandler(callback, eventType)
	fgui.GLoader3D.registerSpineEventHandler(self, function(eventData)
		local eventTypeMap, data
		data.animation = eventData.animation
		data.type = eventTypeMap[eventData.type] or ""
		callback(data)
	end, eventType)
end
return SkeletonAnimation
