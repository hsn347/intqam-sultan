local baseComponent = require("fgui.base.baseComponent")
local Com_MonthlyBuySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_MonthlyBuySingle", Com_MonthlyBuySingle)
_ENV, _ENV = "ui://RechargeView/Com_MonthlyBuySingle", fgui.register_extension
;("ui://RechargeView/Com_MonthlyBuySingle").tableBg = 5
;("ui://RechargeView/Com_MonthlyBuySingle").tableIcon = "icon_monthcard_30.png"
_ENV, fgui.register_extension[11485], ("ui://RechargeView/Com_MonthlyBuySingle").tableName = "ui://RechargeView/Com_MonthlyBuySingle", "ui://RechargeView/Com_MonthlyBuySingle", "monthCard_name_03"
;("ui://RechargeView/Com_MonthlyBuySingle").tableBg = 5
;("ui://RechargeView/Com_MonthlyBuySingle").tableIcon = "icon_monthcard_30.png"
_ENV, fgui.register_extension[14080], ("ui://RechargeView/Com_MonthlyBuySingle").tableName = "ui://RechargeView/Com_MonthlyBuySingle", "ui://RechargeView/Com_MonthlyBuySingle", "monthCard_name_03"
;("ui://RechargeView/Com_MonthlyBuySingle").tableBg = 3
;("ui://RechargeView/Com_MonthlyBuySingle").tableIcon = "icon_monthcard_15.png"
_ENV, fgui.register_extension[12934], ("ui://RechargeView/Com_MonthlyBuySingle").tableName = "ui://RechargeView/Com_MonthlyBuySingle", "ui://RechargeView/Com_MonthlyBuySingle", "monthCard_name_02"
;("ui://RechargeView/Com_MonthlyBuySingle").tableBg = 3
;("ui://RechargeView/Com_MonthlyBuySingle").tableIcon = "icon_monthcard_7.png"
fgui.register_extension[12933], ("ui://RechargeView/Com_MonthlyBuySingle").tableName = "ui://RechargeView/Com_MonthlyBuySingle", "monthCard_name_01"
local monthCardInfo = fgui.register_extension
function Com_MonthlyBuySingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_buy:addClickListener(handler(self, self.onClickRecharge))
end
function Com_MonthlyBuySingle:onShow()
end
function Com_MonthlyBuySingle:initData(data, index, payType, canRenew)
	self.payType = payType
	self.giftID = data.ID
	self.fields.Button_buy:getController("c1"):setSelectedIndex(payType == 1 and 0 or 1)
	local info = monthCardInfo[data.ID]
	self.fields.com_Item:setIcon(info.tableIcon)
	self.fields.com_Item:setQuality(info.tableBg)
	self.fields.com_Item:setSpecialNum(nil)
	self.fields.com_Item:setNumText(nil)
	self.fields.Text_name:setString(i18n(info.tableName))
	self.fields.Text_name:setPositionY(canRenew and 0 or 36)
	local showPrice = paymentManager.judgePrice(data.ID, data.price)
	local originPrice
	self.controllers.c2:setSelectedIndex(data.ID == 14080 and 1 or 0)
	self.controllers.c1:setSelectedIndex(canRenew and 1 or 0)
	if data.ID == 14080 then
		originPrice = paymentManager.judgePrice(11485, 19.99)
		self.fields.BitmapFontLabel_3:setString("50 OFF")
		local labelTime = SoraDCreateTimerLabel(self, self.fields.Text_stime)
		local leftTime = data.endtime - serviceFunctions.systemTime()
		labelTime:setTimeLast(function(ticket, timeNumber)
			if timeNumber <= 0 then
				_ENV = nil
				;(nil).msg = "MESSAGE_RECHARGE_EXCHANGE_REFRESH"
				SoraDSendMessage(nil)
			end
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_766", nil)
		end)
		labelTime:beginTime(leftTime)
	end
	self.fields.Button_buy:initData(showPrice, originPrice, data.ID)
	if index == 1 and (data.ID == 14080 or data.ID == 11485) then
		self.fields.com_Item:showCoolSquare(true)
	else
		self.fields.com_Item:showCoolSquare(false)
	end
	self.fields.Text_title:setString(i18n("rechare_text_01"))
	self.fields.Text_gold:setString(string.formatnumberthousands(data.renewalsgift[2]))
	self.fields.line:setVisible(index ~= 3 or canRenew)
end
function Com_MonthlyBuySingle:onClickRecharge()
	SoraDPlaySound()
	if SoraDCheckOAPIsOpen(self.giftID) and self.payType == 2 then
		_ENV = nil
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD04
		SoraDShowH5PurchaseView(self.giftID, param, nil)
	else
		paymentManager.normalGiftBuyClassify(self.giftID)
		paymentManager.OnemtReadyBuy(self.giftID, gRechargeActiveFromEnum.ROAD04, false)
	end
end
return Com_MonthlyBuySingle
