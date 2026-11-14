local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local giftBagsInfoView = class("giftBagsInfoView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("superCommanderView")
end)
function giftBagsInfoView:ctor()
	SoraDGetChildByName(self, "Image_Cent"):loadTexture("bg_sendgift_9th.png", ccui.TextureResType.plistType)
	SoraDGetChildByName(self, "Text_name"):setString(i18n("gift_send_title_01"))
	local nextBagsTime = activityShowCtrl:getGiftBagsInfo(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY)
	self.btnLook = SoraDGetChildByName(self, "Button_Look")
	self.btnLook:addTouchEventListener(handler(self, self.btnClickLook))
	self.btnLook:setTitleText(i18n("common_text_204"))
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.textTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.textTime:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n(nextBagsTime and "gift_send_text_03" or "gift_send_text_04", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY)
	if timer then
		self.leftTime = timer.timerNode.timer:getRemainTime()
		_ENV = i18n("common_text_204")
		i18n("common_text_204").time = self.leftTime
		self.textTime:setString(i18n(nextBagsTime and "gift_send_text_03" or "gift_send_text_04", i18n("common_text_204")))
		self.textTime:beginTime(nextBagsTime and nextBagsTime - serviceFunctions.systemTime() or self.leftTime)
	end
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	self.textInfo:setString(i18n(nextBagsTime and "gift_send_text_01" or "gift_send_text_02"))
	SoraDGetAutoHeightLabel(self.textInfo, 480)
end
function giftBagsInfoView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function giftBagsInfoView:btnClickLook(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(self, type)
	end
end
function giftBagsInfoView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY) then
		self:layerClickCallBack(self, ccui.TouchEventType.ended)
	end
end
return giftBagsInfoView
