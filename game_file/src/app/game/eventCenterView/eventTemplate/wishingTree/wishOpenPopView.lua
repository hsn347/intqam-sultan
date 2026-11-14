local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local wishingTreeRead = include("wishingTreeRead")
local wishOpenPopView = class("wishOpenPopView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("wishOpenPopView")
end)
function wishOpenPopView:ctor()
	self.group = activityShowCtrl:getParamByID(gActivityTimeActivityID.WISH_TREE_ACTIVITY).classtype or 1
	self.btnSure = SoraDGetChildByName(self, "btn_sure")
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnClickSure))
	self.Text_Tips = SoraDGetChildByName(self, "Text_Tips")
	self.imageFont = SoraDGetChildByName(self, "Image_Font")
	self.imageWishExplosion = SoraDGetChildByName(self, "image_WishExplosion")
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" and lang ~= "en" and lang ~= "ko" then
		lang = "en"
	end
	self.imageFont:ignoreContentAdaptWithSize(true)
	self.imageWishExplosion:setSpriteFrame("fong_wishing_wishbroke_" .. lang .. ".png")
	self.imageFont:loadTexture("font_wishing_star_" .. lang .. ".png", ccui.TextureResType.plistType)
	self.goldNode = SoraDGetChildByName(self, "Node_Gold")
	local loop = true
	local cssFileName = "wishOpenPopView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	SoraDMixtureGLONEByParent(self)
	self:runAction(action)
	if action and tolua.cast(action, "cc.Action") then
		action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			if frameEvent and frameEvent == "EndFrame" then
				self.goldNode:setVisible(false)
			end
		end)
	end
	self:initData()
end
function wishOpenPopView:initData(consumeGold, isPrivilege)
	self.stageNow = wishingTreeRead.getNowStage(self.group, consumeGold or 0)
	local numGoldCanGet = wishingTreeRead.getStageCoin(self.group, self.stageNow, isPrivilege) or 0
	if numGoldCanGet == 0 then
		self.Text_Tips:setString(i18n("wish_text_22"))
	else
		wishingTreeRead = i18n("wish_text_22")
		i18n("wish_text_22").num = string.formatnumberthousands(numGoldCanGet)
		i18n("wish_text_22").num1 = string.formatnumberthousands(numGoldCanGet * 5)
		self.Text_Tips:setString(i18n("wish_text_14", i18n("wish_text_22")))
	end
end
function wishOpenPopView:btnClickSure(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:layerClickCallBack(self, ccui.TouchEventType.ended)
	end
end
return wishOpenPopView
