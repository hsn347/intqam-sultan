local gemGoodsBuyPopView = class("gemGoodsBuyPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("gemGoodsBuyPopView")
	end
	return target
end)
function gemGoodsBuyPopView:ctor()
	self.enableTouchCloseSelf = true
	self:initWidget()
end
function gemGoodsBuyPopView:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Text_1 = SoraDGetChildByName(self, "Text_1")
	self.Text_2 = SoraDGetChildByName(self, "Text_2")
	self.btnYes = SoraDGetChildByName(self, "Button_yes")
	self.btnNo = SoraDGetChildByName(self, "Button_no")
	self.showCheck = SoraDGetChildByName(self, "CheckBox_item")
	self.showCheck:setSelected(false)
	self.btnYes:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnNo:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.showCheck:addEventListener(handler(self, self.showCheckClick))
	self.Text_2:setString(i18n("common_text_2273"))
	self.btnYes:setTitleText(i18n("common_text_204"))
	self.btnNo:setTitleText(i18n("common_text_185"))
	if not SoraDFIsRA() then
		self.Text_1:setTextHorizontalAlignment(SoraDFLabelR())
		self.showCheck:setPositionX(-self.showCheck:getPositionX())
		self.Text_2:setPositionX(-self.Text_2:getPositionX() + self.showCheck:getContentSize().width)
		local anchor = self.Text_2:getAnchorPoint()
		self.Text_2:setAnchorPoint(cc.p(1.0 - anchor.x, anchor.y))
	end
end
function gemGoodsBuyPopView:initData(data)
	if data.showMsg then
		self.Text_1:setString(data.showMsg)
	end
	if data.yesBtnTitle then
		self.btnYes:setTitleText(data.yesBtnTitle)
	end
	if data.noBtnTitle then
		self.btnNo:setTitleText(data.noBtnTitle)
	end
	if data.callBackHandle then
		self.callBackHandle = data.callBackHandle
	end
	if data.remindType then
		self.remindType = data.remindType
	end
end
function gemGoodsBuyPopView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnYes then
			self:exitView(MSGBOX_CALLBACK_YES)
		elseif button == self.btnNo then
			self:exitView(MSGBOX_CALLBACK_NO)
		end
		self:close(button, type)
	end
end
function gemGoodsBuyPopView:showCheckClick(button, type)
	SoraDPlaySound()
	if not self.remindType then
		return
	end
	local dailyRemindManager = include("dailyRemindManager")
	if button:isSelected() then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local openCount = activityShowCtrl:getOpenCount(gActivityTimeActivityID.GEM_GOODS_ACTIVITY)
		dailyRemindManager.addRemindToManager(self.remindType, openCount)
	else
		dailyRemindManager.addRemindToManager(self.remindType, 0)
	end
end
function gemGoodsBuyPopView:exitView(exitType)
	if self.callBackHandle then
		self.callBackHandle(exitType, self)
	end
end
return gemGoodsBuyPopView
