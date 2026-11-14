local rechargePresentUtil = include("rechargePresentUtil")
local inheritGiftCtrl = SoraDGetCtrl("inheritGiftCtrl")
local dailyRemindManager = include("dailyRemindManager")
local baseComponent = require("fgui.base.baseComponent")
local Com_inheritGiftPage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_inheritGiftPage", Com_inheritGiftPage)
function Com_inheritGiftPage:onInit()
	self.fields.Icon_gold:fixPos()
	self.fields.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.fields.touch_bg:addClickListener(handler(self, self.onClickArea))
	self.fields.ScrollView_itemList:addClickListener(handler(self, self.onClickArea))
end
function Com_inheritGiftPage:initData(_info, fromCenter, isPageTurn, actID)
	self.fromCenter = fromCenter or gRechargeActiveFromEnum.ROAD03
	self.isPageTurn = isPageTurn or false
	local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
	if self.fromCenter then
		paymentManager.OnemtOpenGiftUI(_info.rid, self.fromCenter, self.isPageTurn, _info.data.push_id)
	end
	local rechargeRead = include("rechargeRead")
	dump(_info, "Com_inheriπtGiftPage:initData")
	local giftStyle = rechargeRead.getInheritPageViewData(_info.rid)
	self.giftRid = _info.rid
	self.giftType = giftStyle.activeModelType
	self.giftData = _info.data
	self.giftData.giftStyle = giftStyle
	self.giftData.leftTime = rechargePresentUtil.getActivityLeftTime(gActivityTimeActivityID.WEALTH_INHERITANCE_ACTIVTY)
	self:initRechargePresentPage()
	self:updatePresentGold()
end
function Com_inheritGiftPage:registerEvent()
	SoraDAddMessage(self, "MESSAGE_WEALTH_INHERIT_REFRESH", handler(self, self.onUpdateView))
end
function Com_inheritGiftPage:onUpdateView(target, data)
	if self:isVisible() and data.subMsg == "exchange" and data.rid == self.giftData.rechargeID then
		self:initRechargePresentPage()
		self:updatePresentGold()
	end
end
function Com_inheritGiftPage:initRechargePresentPage(...)
	dump(self.giftData, "Com_inheritGiftPage:initRechargePresentPage")
	self.fields.Label_banner:setIcon(SoraDCheckPNG(self.giftData.giftStyle.popBanner, gDefaultPNG.RECHARGE_PAGEBG))
	if self.giftData.gold and tonumber(self.giftData.gold) > 0 then
		self.fields.txtGold:setVisible(true)
		self.fields.Icon_gold:setVisible(true)
	else
		self.fields.txtGold:setVisible(false)
		self.fields.Icon_gold:setVisible(false)
	end
	self.fields.txtGold:setString(string.formatnumberthousands(tonumber(self.giftData.gold)))
	if self.giftData.giftStyle.activeExplain ~= "" then
		if type(self.giftData.giftStyle.activeExplain) == "string" then
			self.fields.txtGiftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
		elseif type(self.giftData.giftStyle.activeExplain) == "table" then
			if next(self.giftData.giftStyle.activeExplain) then
				self.fields.txtGiftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
			else
				self.fields.txtGiftTip:setString("")
			end
		end
	else
		self.fields.txtGiftTip:setString("")
	end
	self.giftData.extraData = rechargePresentUtil.getInheritGiftNum(self.giftData)
	local isMoreBuyTimes = tonumber(self.giftData.extraData) or 0
	if not self.giftData.payType and self.giftData.luckyGiftID then
		self.giftData.already_buy = self.giftData.already_buy or 0
		isMoreBuyTimes = self.giftData.buy_limit - self.giftData.already_buy
	end
	_ENV = i18n(self.giftData.giftStyle.activeExplain)
	i18n(self.giftData.giftStyle.activeExplain).num = isMoreBuyTimes
	self.fields.txtLimit:setString(i18n("common_text_2516", i18n(self.giftData.giftStyle.activeExplain)))
	self.isMoreBuyTimes = isMoreBuyTimes
	if self.fields.txtLimit then
		self.fields.txtLimit:setVisible(true)
		self.fields.Icon_gold:setPositionY(self.fields.txtLimit:getPositionY() - 44)
	end
	if gRechargeActiveModelType.NORMAL == self.giftType and self.giftData.payType == gRechargeActivityBuyType.NORMAL then
		self.fields.txtLimit:setVisible(false)
		self.fields.Icon_gold:setPositionY(self.fields.txtLimit:getPositionY() - 30)
	end
	self:initScroll(SoraDIntArr2FormatTable(self.giftData.gift))
	return true
end
function Com_inheritGiftPage:initScroll(giftData, id)
	giftData = giftData or self.giftData.gift
	giftData = rechargePresentUtil.setInheritGiftSpecialData(giftData, self.giftData.highlight)
	self.giftDataList = giftData
	self.fields.ScrollView_itemList:setItemRenderer(handler(self, self.onItemRendererGift))
	self.fields.ScrollView_itemList:setNumItems(table.nums(giftData))
end
function Com_inheritGiftPage:updatePresentGold()
	local presentGold = inheritGiftCtrl:getInheritPoint()
	local count = self.giftData.exchangeID and self.giftData.exchangeID[2] or 0
	local content = string.format("%s/%s", string.formatnumberthousands(presentGold), string.formatnumberthousands(count))
	self.fields.btnBuy:setTitleText(content)
	local bDisable = presentGold < count
	if bDisable then
		self.fields.btnBuy:setTouchable(false)
		self.fields.btnBuy:setTitleColor(display.COLOR_BLACK)
		self.fields.btnBuy:setGrayed(true)
	else
		self.fields.btnBuy:setTouchable(true)
		self.fields.btnBuy:setTitleColor(display.COLOR_WHITE)
		self.fields.btnBuy:setGrayed(false)
	end
end
function Com_inheritGiftPage:btnBuyClick()
	SoraDPlaySound()
	local presentHave = inheritGiftCtrl:getInheritPoint()
	local count = self.giftData.exchangeID and self.giftData.exchangeID[2] or 0
	if presentHave >= count then
		local key = dailyRemindManager.REMIND_TYPE.inheritGiftBuy
		if dailyRemindManager.checkNeedRemind(key) then
			_ENV = dailyRemindManager.checkNeedRemind(key)
			_ENV = nil
			;(nil).num = count
			dailyRemindManager.checkNeedRemind(key).Text_tip = i18n("newstart_text_58", nil)
			dailyRemindManager.checkNeedRemind(key).Text_reminder = i18n("sudanGift_text_14")
			local dailyRemindManager.checkNeedRemind(key).btnHandle, data = function(isClick)
				SoraDPlaySound()
				inheritGiftCtrl:reqWealthInheritExchange(self.giftData.rechargeID)
				if isClick then
					dailyRemindManager.addRemindToManager(key)
				end
			end, dailyRemindManager.checkNeedRemind(key)
			uiManager:show("RemindCheckPopBox", data):setOwnerKey(self)
		else
			inheritGiftCtrl:reqWealthInheritExchange(self.giftData.rechargeID)
		end
	end
end
function Com_inheritGiftPage:onItemRendererGift(index, object)
	object:initData(index + 1, self.giftDataList[index + 1])
end
function Com_inheritGiftPage:onClickArea(context, data)
	local obj = context:getSender()
	if obj ~= self.fields.Node_menu then
		_ENV = nil
		;(nil).msg = "MESSAGE_WEALTH_INHERIT_MENU"
		SoraDSendMessage(nil)
	end
end
function Com_inheritGiftPage:onShow()
end
return Com_inheritGiftPage
