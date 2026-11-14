local eventLightShiningSingle = class("eventLightShiningSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventLightShiningSingle")
	end
	return target
end)
function eventLightShiningSingle:ctor()
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.Image_bg = include("commonBtnInstance").new(self.Image_bg)
	self.Image_bg:setHandle(handler(self, self.onTouchClick))
	self.Image_flower = SoraDGetChildByName(self, "Image_flower")
	self.Node_light = SoraDGetChildByName(self, "Node_light")
	self.Node_light:setVisible(false)
	self.Node_all = SoraDGetChildByName(self, "Node_all")
	self:initEffect()
end
function eventLightShiningSingle:initEffect()
	local et_aniLSFA = SoraDCreatAnimation("animationLSFA")
	et_aniLSFA:addTo(self.Node_light)
end
function eventLightShiningSingle:setStatus(isGray, isAllLight)
	self.isGray = isGray
	self.Image_bg:setColor(isGray and cc.c3b(160, 160, 160) or cc.c3b(255, 255, 255))
	self.Image_flower:setColor(isGray and cc.c3b(160, 160, 160) or cc.c3b(255, 255, 255))
	self.Node_light:setVisible(not self.isGray and not isAllLight)
end
function eventLightShiningSingle:playAllEffect()
	if not self.et_aniLSFS then
		self.et_aniLSFS = SoraDCreatAnimationEx("animationLSFS", nil, false)
		self.et_aniLSFS:addTo(self.Node_all)
	else
		self.et_aniLSFS.action:gotoFrameAndPlay(0, false)
	end
end
function eventLightShiningSingle:onTouchClick()
	if self.isGray then
		SoraDShowMsgTip(i18n("Shine_text_06"))
	end
end
return eventLightShiningSingle
