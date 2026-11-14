local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local monthSeasonSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/monthSeasonSingle", monthSeasonSingle)
function monthSeasonSingle:onInit()
	self.infoList, _ENV, self.itemList, _ENV = nil, nil, nil, nil
	self.isdayget = false
	self.Text_limitTime = SoraDCreateTimerLabel(self, self.fields.Text_limitTime)
	self.fields.Text_tip:setString(i18n("common_text_3984"))
	self.fields.Button_weekBuy:addClickListener(handler(self, self.onBuyClick))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_info:setItemRenderer(handler(self, self.onInfoRenderer))
	self.fields.glass:setVisible(false)
	self.fields.Text_monthTitle:fixPos()
	self.Text_limitTime:fixPos()
	self.fields.glass:fixPos()
	self.fields.Image_monthBanner:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.ntbg:fix()
	self.fields.List_info:fixPos()
	self.fields.List_award:fixPos()
	self.fields.Text_tip:fixPos()
	self.fields.outAppPurchaseButtons:fixPos()
	self.fields.Button_weekBuy:fixPos()
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePosEX()
end
function monthSeasonSingle:onItemRenderer(index, obj)
	local itemData = self.itemList[index + 1]
	obj:initData(tonumber(itemData.id), tonumber(itemData.count))
	obj:setBright(not self.isdayget)
end
function monthSeasonSingle:onInfoRenderer(index, obj)
	obj:initData(self.infoList[index + 1])
end
function monthSeasonSingle:onShow()
end
function monthSeasonSingle:initData(data)
	self.id = data.id or data.ID
	local weekInfo = rechargeRead.getPageViewData(self.id)
	if weekInfo and weekInfo.activeBg then
		self.fields.Image_monthBanner:setSpriteFrame(weekInfo.activeBg)
	end
	if weekInfo and weekInfo.activeName then
		self.fields.Text_monthTitle:setString(i18n(weekInfo.activeName))
	end
	self.fields.Text_tip:setString(i18n("common_text_3984"))
	self.fields.Text_tip:setColor(cc.c3b(255, 239, 167))
	self.btnReqStyle = 1
	self.isdayget = data.isbuy and data.isdayget or false
	if data.isbuy then
		local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.id)
		self.Text_limitTime:beginTime(leftTime)
		self.fields.glass:setVisible(true)
		if data.isdayget then
			local weekDays, showTicket = SoraDConverSecondToDayAndHours(leftTime)
			if weekDays < data.totalday and data.canRenew then
				self.btnReqStyle = 1
				self.fields.Button_weekBuy:setEnabled(true)
				local showPrice = i18n("common_text_282")
				if data.price then
					showPrice = paymentManager.judgePrice(self.id, data.price)
				end
				rechargeRead = cc.c3b(255, 239, 167)
				cc.c3b(255, 239, 167).des = showPrice
				self.fields.Button_weekBuy:setString(i18n("common_text_4186", cc.c3b(255, 239, 167)))
			else
				self.btnReqStyle = 3
				self.fields.Button_weekBuy:setEnabled(false)
				self.fields.Button_weekBuy:setString(i18n("common_text_1892"))
			end
			self.fields.Text_tip:setString(i18n("protect_text_09"))
			self.fields.Text_tip:setColor(cc.c3b(112, 199, 35))
		else
			self.btnReqStyle = 2
			self.fields.Button_weekBuy:setEnabled(true)
			self.fields.Button_weekBuy:setString(i18n("common_text_1146"))
		end
	else
		self.btnReqStyle = 1
		local dayExTab = serviceFunctions.formatStr2Table(data.extraData or "")
		local activeDay = dayExTab[1] or data.extraData
		self.Text_limitTime:endTime()
		rechargeRead = i18n("common_text_1146")
		i18n("common_text_1146").day = fguiHelper.getColorString("#FFEFA7", activeDay)
		self.Text_limitTime:setString(i18n("common_text_3838", i18n("common_text_1146")))
		self.fields.glass:setVisible(false)
		self.fields.Button_weekBuy:setEnabled(true)
		local showPrice = i18n("common_text_282")
		if data.price then
			showPrice = paymentManager.judgePrice(self.id, data.price)
		end
		self.fields.Button_weekBuy:setString(showPrice)
	end
	self:updateOutAppPurchase(self.btnReqStyle == 1)
	self.itemList = rechargeActivityCtrl:getMonthAwardList(self.id)
	self.fields.List_award:setNumItems(#self.itemList)
	self.infoList, rechargeRead = self.fields.List_award.setNumItems, self.fields.List_award.setNumItems
	if not data.buff then
		rechargeRead = data.buff
	end
	data.buff = data.buff
	if data.gold and data.gold > 0 and data.buff[1] ~= gIDDef.GOLD then
		table.insert(data.buff, 1, gIDDef.GOLD)
	end
	for i = 1, 3 do
		if data.buff[i] then
			local isbuy = data.isbuy
			local isdayget = data.isdayget
			local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.id)
			local monthDays, showTicket = SoraDConverSecondToDayAndHours(leftTime)
			if data.buff[i] == gIDDef.GOLD then
				if not isbuy or isbuy and isdayget and monthDays < 1 and not data.canContinueReceive then
					rechargeRead = i18n("common_text_3838", i18n("common_text_1146"))
					rechargeRead = i18n("common_text_3838", i18n("common_text_1146"))
					i18n("common_text_3838", i18n("common_text_1146")).num = data.gold
					i18n("common_text_3838", i18n("common_text_1146")).title = i18n("common_text_3839", i18n("common_text_3838", i18n("common_text_1146")))
					table.insert(self.infoList, i18n("common_text_3838", i18n("common_text_1146")))
				end
			else
				rechargeRead = i18n("common_text_3838", i18n("common_text_1146"))
				i18n("common_text_3838", i18n("common_text_1146")).title = rechargeRead.getBuffWeekInfoByID(data.buff[i])
				table.insert(self.infoList, i18n("common_text_3838", i18n("common_text_1146")))
			end
		end
	end
	self.fields.List_info:setNumItems(#self.infoList)
	rechargeRead, _ENV = self.fields.List_info, self.fields.List_info.setNumItems
	self.fields.List_info.rechargeID = self.id
	local self.fields.List_info.setNumItems[1], rechargeIDList = self.fields.List_info, self.fields.List_info.setNumItems
	self.fields.rechargeGift:initData(rechargeIDList, true)
end
function monthSeasonSingle:updateOutAppPurchase(isShow)
	if isShow and SoraDCheckOAPIsOpen(self.id) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_weekBuy:setVisible(false)
		_ENV = false
		;(false).rid = self.id
		_ENV, (false).nowPrice = self.fields.Button_weekBuy:getTitle(), self.fields.Button_weekBuy:getTitle()
		;(false).logInfo, self.fields.Button_weekBuy:getTitle().fromCenter = self.fields.Button_weekBuy:getTitle(), gRechargeActiveFromEnum.ROAD04
		;(false).handleBuyClick = handler(self, self.onBuyClick)
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_weekBuy:setVisible(true)
	end
end
function monthSeasonSingle:onBuyClick()
	SoraDPlaySound()
	if self.btnReqStyle == 1 then
		local dailyRemindManager = include("dailyRemindManager")
		local rechargeRead = include("rechargeRead")
		local key = dailyRemindManager.REMIND_TYPE.rechargePop
		if dailyRemindManager.checkNeedRemind(key) then
			local info = rechargeRead.getPageViewData(self.id)
			_ENV = self.id
			_ENV = nil
			;(nil).rechargeName = i18n(info.activeName)
			self.id.Text_tip = i18n("common_text_4934", nil)
			self.id.Text_reminder = i18n("coffeeCraftsman_text_27")
			local self.id.btnHandle, data = function(isClick)
				paymentManager.normalGiftBuyClassify(self.id)
				paymentManager.OnemtReadyBuy(self.id, gRechargeActiveFromEnum.ROAD04, false)
				if isClick then
					dailyRemindManager.addRemindToManager(key)
				end
			end, self.id
			uiManager:show("RemindCheckPopBox", data)
		else
			paymentManager.normalGiftBuyClassify(self.id)
			paymentManager.OnemtReadyBuy(self.id, gRechargeActiveFromEnum.ROAD04, false)
		end
	elseif self.btnReqStyle == 2 then
		self.fields.Button_weekBuy:setEnabled(false)
		self.fields.Button_weekBuy:setString(i18n("common_text_1892"))
		rechargeActivityCtrl:getMonthAwardReq(self.id)
	end
end
return monthSeasonSingle
