local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local activity_9001702_Read = include("activity_9001702_Read")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_GiftPanel = class("Activity_9001702_GiftPanel", baseFguiPanel)
function Activity_9001702_GiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001702_GiftPanel.super.ctor(self, ...)
	print("Activity_9001702_GiftPanel:ctor", self.viewName)
end
function Activity_9001702_GiftPanel:onInit()
	print("=======Activity_9001702_GiftPanel:onInit")
	self.fields.Text_title:setString(i18n("Eidal_celebration_text_25"))
	self.fields.Button_receive:setString(i18n("cavalryrise_text_06"))
	self.fields.Button_receive:addClickEventListener(handler(self, self.onClickBtnReceive))
end
function Activity_9001702_GiftPanel:endShow()
	print("=======Activity_9001702_GiftPanel:endShow")
	local itemCount = activity_9001702_Ctrl:getCanReceiveItemCount()
	local receiveGift = activity_9001702_Read.getReceiveGift()
	local giftCount = math.floor(itemCount / receiveGift.count)
	local giftItemID = activity_9001702_Read.getGiftItemID()
	local giftItemName = publicRead.getName(giftItemID)
	_ENV = nil
	;(nil).num = giftCount
	;(nil).item = giftItemName
	local desStr = i18n("Eidal_celebration_text_38", nil)
	self.fields.Text_des:setString(desStr)
	self.fields.Com_item:initData(receiveGift.id, itemCount)
	local itemCount2 = activity_9001702_Ctrl:getBySendDrawItemCount()
	local limit = activity_9001702_Read.getReceiveGiftLimit()
	local remain = math.max(0, limit - itemCount2)
	_ENV = nil
	;(nil).num = remain
	local remainStr = i18n("Eidal_celebration_text_36", nil)
	self.fields.Text_remain:setString(remainStr)
end
function Activity_9001702_GiftPanel:onClickBtnReceive()
	SoraDPlaySound()
	activity_9001702_Ctrl:reqReceive()
	self:closePanel()
end
return Activity_9001702_GiftPanel
