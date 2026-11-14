local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarViewerGiftPanel = class("NebulaAllStarViewerGiftPanel", baseFguiPanel)
function NebulaAllStarViewerGiftPanel:ctor(...)
	NebulaAllStarViewerGiftPanel.super.ctor(self, ...)
	print("NebulaAllStarViewerGiftPanel:ctor", self.viewName)
end
function NebulaAllStarViewerGiftPanel:onInit()
	print("=======NebulaAllStarViewerGiftPanel:onInit")
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	local giftType = self.param.giftType or 1
	local giftName = nebulaAllStarRead.getViewerGiftName(giftType)
	self.fields.Panel_bg:setString(giftName)
	local content = self.param.content or ""
	self.fields.Text_content:setString(content)
	self.fields.Button_recive:setString(i18n("NebulaAllstar_374"))
	self.fields.Button_recive:addClickListener(handler(self, self.onClickBtnReceive))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeLast(function(timeStr)
		return timeStr .. i18n("NebulaAllstar_193")
	end)
	self.Text_time:setTimeEndListener(function()
		self.Text_time:setVisible(false)
	end)
	local remainTime = self:getRemainTime()
	if 0 < remainTime then
		self.Text_time:beginTime(remainTime)
	else
		self.Text_time:setVisible(false)
	end
end
function NebulaAllStarViewerGiftPanel:onShow()
	print("=======NebulaAllStarViewerGiftPanel:onShow")
	local id = self.param.id or 1
	nebulaAllStarCtrl:reqViewerGiftInfo(id)
	SoraDShowLoading(self:displayObject())
end
function NebulaAllStarViewerGiftPanel:onClickBtnReceive(...)
	SoraDPlaySound()
	if not self.isEnough then
		SoraDShowMsgTip(i18n("NebulaAllstar_194"))
		return
	end
	local remainTime = self:getRemainTime()
	if 0 < remainTime then
		SoraDShowMsgTip(SoraDConvertSecondToString(remainTime) .. i18n("NebulaAllstar_193"))
		return
	end
	local id = self.param.id or 1
	nebulaAllStarCtrl:reqViewerReciveGift(id)
	SoraDShowLoading(self:displayObject())
end
function NebulaAllStarViewerGiftPanel:getRemainTime(...)
	local time = self.param.time or 0
	local giftCD = nebulaAllStarRead.getConstValue("GiftPlunderCD", 10)
	local remainTime = time + giftCD - serviceFunctions.systemTime() + 1
	return remainTime
end
function NebulaAllStarViewerGiftPanel:onMsgUpdateGiftInfo(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	local recivedNum = rspdata.recivedNum or 0
	local maxNum = nebulaAllStarRead.getConstValue("GiftPlunderNum", 10)
	local remain = math.max(0, maxNum - recivedNum)
	self.isEnough = 0 < remain
	if self.isEnough then
		_ENV = self:displayObject()
		self:displayObject().num1 = remain
		self:displayObject().num2 = maxNum
		self.fields.Text_count:setString(i18n("NebulaAllstar_192", self:displayObject()))
	else
		self.fields.Text_count:setString(i18n("NebulaAllstar_194"))
	end
	if rspdata.isRecived then
		self.fields.Load_box:setURL("frame_qmx_baoxiang02.png")
		self.fields.Button_recive:setString(i18n("NebulaAllstar_360"))
		self.fields.Button_recive:setEnabled(false)
	end
end
return NebulaAllStarViewerGiftPanel
