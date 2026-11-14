local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeCardRenew = class("rechargeCardRenew", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeCardRenew")
	end
	return target
end)
_ENV = "rechargeCardRenew"
;("rechargeCardRenew").renew = 1
local ("rechargeCardRenew").success, windowType = 2, "rechargeCardRenew"
function rechargeCardRenew:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_4182"))
	self.text_info = SoraDGetChildByName(self, "Text_info")
	self.bit_gold = SoraDGetChildByName(self, "BitmapFontLabel_gold")
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.btn_renew = SoraDGetChildByName(self, "Button_renew")
	SoraDAutoSizeButtonText(self.btn_renew, cc.size(200, 72))
	self.btn_renew:addTouchEventListener(handler(self, self.OnBtnClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", function(...)
		self:removeFromParent()
	end)
end
function rechargeCardRenew:initData(data, otherID)
	self.data = data
	self.wType = windowType.renew
	self:initView()
end
function rechargeCardRenew:initView()
	self.time = rechargeActivityCtrl:getRechargeLeftTime(otherID or self.data.ID)
	self.text_info:setString(i18n("common_text_4174"))
	self.bit_gold:setString("x" .. string.formatnumberthousands(self.data.renewalsgift[2]))
	local showPrice = paymentManager.judgePrice(self.data.ID, self.data.price)
	rechargeActivityCtrl = i18n("common_text_4174")
	i18n("common_text_4174").des = showPrice
	self.btn_renew:setTitleText(i18n("common_text_4186", i18n("common_text_4174")))
	if self.time > 0 then
		self:openTimer()
	end
end
function rechargeCardRenew:openTimer()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.updateTime))
		self:updateTime()
	else
		self:updateTime()
	end
end
function rechargeCardRenew:updateTime(dt)
	if self.time <= 0 then
		self.text_time:setVisible(false)
		self:closeTimer()
	else
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(self.time)
		self.text_time:setString(i18n("common_text_4179", nil))
		self.time = self.time - 1
	end
end
function rechargeCardRenew:closeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function rechargeCardRenew:OnBtnClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.data.ID)
		paymentManager.OnemtReadyBuy(self.data.ID, gRechargeActiveFromEnum.ROAD04, false)
		self:close(target, event)
	end
end
return rechargeCardRenew
