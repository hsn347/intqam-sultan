local evaluationOfStarsView = class("evaluationOfStarsView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("evaluationOfStarsView")
	end
	return target
end)
function evaluationOfStarsView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.isFilterCurrentScreen = false
	self.isAddToPopManager = true
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.textContent = SoraDGetChildByName(self, "Text_content")
	self.textContent:setString(i18n("common_text_1964"))
	self.btnNotGreat = SoraDGetChildByName(self, "Button_not_great")
	SoraDAutoSizeButtonText(self.btnNotGreat, cc.size(200, 60))
	self.btnNotGreat:setTitleText(i18n("common_text_1965"))
	self.btnAwesome = SoraDGetChildByName(self, "Button_awesome")
	SoraDAutoSizeButtonText(self.btnAwesome, cc.size(200, 60))
	self.btnAwesome:setTitleText(i18n("common_text_1966"))
	self.btnNotGreat:addTouchEventListener(handler(self, self.OnBtnClickNotGreat))
	self.btnAwesome:addTouchEventListener(handler(self, self.OnBtnClickAwesome))
	self:setCloseCallBack(handler(self, self.exitView))
end
function evaluationOfStarsView:OnBtnClickClose(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:sendData(gEvaluationOfStars.DIREDCT_CLOSE)
		self:close(button, event)
	end
end
function evaluationOfStarsView:OnBtnClickNotGreat(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:sendData(gEvaluationOfStars.NOT_GREATE)
		userSDKManager.openFeedback("RateStar", true)
		self:close(button, event)
	end
end
function evaluationOfStarsView:OnBtnClickAwesome(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:sendData(gEvaluationOfStars.VERY_GREATE)
		SoraDGoToAppStore()
		self:close(button, event)
	end
end
function evaluationOfStarsView:exitView(exitType)
	if exitType == MSGBOX_CALLBACK_CANCEL then
		print("评星界面关闭了------------")
		self:sendData(gEvaluationOfStars.DIREDCT_CLOSE)
		self:close(self, ccui.TouchEventType.ended)
	end
end
function evaluationOfStarsView:sendData(nType)
	local gametop = gModuleMgr.getObject("gametop")
	local evaluationCtrl = gametop.playertop_:getModule("evaluationCtrl")
	evaluationCtrl:sendStarsType(nType)
end
return evaluationOfStarsView
