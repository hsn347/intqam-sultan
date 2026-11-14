local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local monthSeasonSingle = class("monthSeasonSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("monthSeasonSingle")
	end
	return target
end)
function monthSeasonSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.imgBanner = SoraDGetChildByName(self, "Image_monthBanner")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_limitTime = SoraDGetChildByName(self, "Text_limitTime")
	self.Text_limitTime = SoraDCreateTimerLabel(self, self.Text_limitTime)
	SoraDSetTextWidthHeight(self.Text_limitTime, cc.size(150, 40))
	self.Text_monthTitle = SoraDGetChildByName(self, "Text_monthTitle")
	SoraDSetTextWidthHeight(self.Text_monthTitle, cc.size(360, 40))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("common_text_3984"))
	self.Node_info = SoraDGetChildByName(self, "Node_info")
	self.Button_weekBuy = SoraDGetChildByName(self, "Button_weekBuy")
	self.Button_weekBuy = include("commonBtnInstance").new(self.Button_weekBuy)
	self.Button_weekBuy:setHandle(handler(self, self.onBuyClick))
	self.Text_limitTime:setFontSize(15)
	SoraDAutoSizeButtonText(self.Button_weekBuy, cc.size(130, 60))
end
function monthSeasonSingle:initData(data, otherData)
	self.id = data.id or data.ID
	print("self.id =====", self.id)
	self.view = otherData.view
	self.scroll = otherData.scroll
	self.Button_weekBuy:setScroll(self.scroll)
	local weekInfo = rechargeRead.getPageViewData(self.id)
	if weekInfo and weekInfo.activeBg then
		self.imgBanner:loadTexture(weekInfo.activeBg, ccui.TextureResType.plistType)
	end
	if weekInfo and weekInfo.activeName then
		self.Text_monthTitle:setString(i18n(weekInfo.activeName))
	end
	self.btnReqStyle = 1
	self.Button_weekBuy:setTitleColor(cc.c3b(255, 255, 255))
	if data.isbuy then
		local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.id)
		self.Text_limitTime:beginTime(leftTime)
		if data.isdayget then
			local weekDays, showTicket = SoraDConverSecondToDayAndHours(leftTime)
			if weekDays < data.totalday and data.canRenew then
				self.btnReqStyle = 1
				self.Button_weekBuy:setTouchEnabled(true)
				self.Button_weekBuy:setBright(true)
				local showPrice = i18n("common_text_282")
				if data.price then
					showPrice = paymentManager.judgePrice(self.id, data.price)
				end
				_ENV = cc.c3b(255, 255, 255)
				cc.c3b(255, 255, 255).des = showPrice
				self.Button_weekBuy:setTitleText(i18n("common_text_4186", cc.c3b(255, 255, 255)))
			else
				self.btnReqStyle = 3
				self.Button_weekBuy:setTouchEnabled(false)
				self.Button_weekBuy:setBright(false)
				self.Button_weekBuy:setTitleText(i18n("common_text_1892"))
			end
		else
			self.btnReqStyle = 2
			self.Button_weekBuy:setTouchEnabled(true)
			self.Button_weekBuy:setTitleText(i18n("common_text_1146"))
			self.Button_weekBuy:setBright(true)
			self.Button_weekBuy:setTitleColor(cc.c3b(255, 255, 0))
		end
	else
		self.btnReqStyle = 1
		local dayExTab = serviceFunctions.formatStr2Table(data.extraData or "")
		local activeDay = dayExTab[1] or data.extraData
		self.Text_limitTime:endTime()
		_ENV = cc.c3b(255, 255, 0)
		cc.c3b(255, 255, 0).day = activeDay
		self.Text_limitTime:setString(i18n("common_text_3838", cc.c3b(255, 255, 0)))
		self.Button_weekBuy:setTouchEnabled(true)
		local showPrice = i18n("common_text_282")
		if data.price then
			showPrice = paymentManager.judgePrice(self.id, data.price)
		end
		self.Button_weekBuy:setTitleText(showPrice)
	end
	self:updateOutAppPurchase(self.btnReqStyle == 1)
	local itemList = rechargeActivityCtrl:getMonthAwardList(self.id)
	for k, v in ipairs(self.itemArray) do
		v:setVisible(false)
	end
	for i, v in ipairs(itemList) do
		if not self.itemArray[i] then
			self.itemArray[i] = include("commonItemAward").new()
			self.itemArray[i]:setScale(0.7)
			self.itemArray[i]:setBaseScale(1.0)
			self.itemArray[i]:setOwnView(display.getRunningScene())
			self.itemArray[i]:setOwnScroll(self.scroll)
			self.itemArray[i]:addTo(self, 9)
		end
		self.itemArray[i]:setVisible(true)
		self.itemArray[i]:initData(v.id, v.count)
		self.itemArray[i]:setPosition(SoraDFPosX(640 - i * 80 + 20), 45)
	end
	self.Node_info:setVisible(false)
	if not data.buff then
		_ENV = data.buff
	end
	data.buff = data.buff
	if data.gold and 0 < data.gold and data.buff[1] ~= gIDDef.GOLD then
		table.insert(data.buff, 1, gIDDef.GOLD)
	end
	if next(data.buff) then
		self.Node_info:setVisible(true)
		for i = 1, 3 do
			local text_info = self.Node_info:getChildByName("Text_info_" .. i)
			local line_info = self.Node_info:getChildByName("Image_line_" .. i)
			if text_info and line_info then
				if data.buff[i] then
					text_info:setVisible(true)
					line_info:setVisible(true)
					local isbuy = data.isbuy
					local isdayget = data.isdayget
					local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.id)
					local monthDays, showTicket = SoraDConverSecondToDayAndHours(leftTime)
					if data.buff[i] == gIDDef.GOLD then
						if not isbuy or isbuy and isdayget and monthDays < 1 and not data.canContinueReceive then
							_ENV = display.getRunningScene()
							display.getRunningScene().num = data.gold
							text_info:setString(i18n("common_text_3839", display.getRunningScene()))
						else
							text_info:setVisible(false)
							line_info:setVisible(false)
						end
					else
						text_info:setString(rechargeRead.getBuffWeekInfoByID(data.buff[i]))
					end
				else
					text_info:setVisible(false)
					line_info:setVisible(false)
				end
			end
		end
	end
	_ENV, rechargeRead = 1, 3
	;(1).rechargeID = self.id
	;(3)[1] = 1
	SoraDCreateRechargeGiftNode(3, self, cc.p(SoraDFPosX(43, 640), 273), 0.9, SoraDFPosX(3, 5))
end
function monthSeasonSingle:onBuyClick()
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
		self.Button_weekBuy:setTouchEnabled(false)
		self.Button_weekBuy:setBright(false)
		self.Button_weekBuy:setTitleText(i18n("common_text_1892"))
		SoraDShowLoading()
		rechargeActivityCtrl:getMonthAwardReq(self.id)
	end
end
function monthSeasonSingle:updateOutAppPurchase(isShow)
	if isShow and SoraDCheckOAPIsOpen(self.id) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new("outAppPurchaseButtonsSmall")
			self.outAppPurchaseButtons:addTo(self.Button_weekBuy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(SoraDFPosX(170, 640), 45))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.Button_weekBuy:setVisible(false)
		_ENV = false
		;(false).rid = self.id
		_ENV, (false).nowPrice = self.Button_weekBuy:getTitleText(), self.Button_weekBuy:getTitleText()
		;(false).logInfo, self.Button_weekBuy:getTitleText().fromCenter = self.Button_weekBuy:getTitleText(), gRechargeActiveFromEnum.ROAD04
		;(false).handleBuyClick = handler(self, self.onBuyClick)
		self.outAppPurchaseButtons:initData(false)
	else
		if self.outAppPurchaseButtons then
			self.outAppPurchaseButtons:setVisible(false)
		end
		self.Button_weekBuy:setVisible(true)
	end
end
return monthSeasonSingle
