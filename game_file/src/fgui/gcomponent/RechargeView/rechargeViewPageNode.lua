local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local rechargeRead = include("rechargeRead")
local resDesRead = include("resDesRead")
local rechargePresentUtil = include("rechargePresentUtil")
local rechargePresentCtrl = SoraDGetCtrl("rechargePresentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local rechargeViewPageNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/rechargeViewPageNode", rechargeViewPageNode)
function rechargeViewPageNode:onInit()
	self.lastRid = nil
	self.isJumpInit = true
	self.fields.List_items:setVirtual()
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.Text_once:setAlign(0)
	self.fields.Text_gold:setAlign(0)
	self.Text_point_title = SoraDCreateTimerLabel(self, self.fields.Text_point_title)
	self.fields.Button_buyItem:addClickListener(handler(self, self.btnItemBuyClick))
	self.fields.Button_add:addClickListener(handler(self, self.onClickAdd))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Button_menu:addClickListener(handler(self, self.menuBtnClick))
	self.fields.Button_switch:setString(i18n("recharge_setting_text_11"))
	self.fields.Button_switch:addClickListener(handler(self, self.switchBtnClick))
	self:setTipStatus(false)
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
	self.fields.Button_add:fixPos()
	self.fields.icon_item:fixPos()
	self.fields.Node_style:fixPos()
	self.fields.Text_discount:fixPos()
	self.fields.Button_switch:fixPos()
end
function rechargeViewPageNode:onShow()
end
function rechargeViewPageNode:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], index + 1)
end
function rechargeViewPageNode:initGroup(_info, tag, isPageTurn, tabType, jumpToRID, isJumpInit)
	self.tabType = tabType
	self.rType = _info.rType
	self.category = tag
	local fromCenter = gRechargeActiveFromEnum.ROAD18 .. string.format("%0.2d", self.category)
	self.jumpToRID = jumpToRID
	self.curLadderID = nil
	self.isJumpInit = isJumpInit or self.isJumpInit
	if _info.group then
		self.controllers.c1:setSelectedIndex(1)
		self.groupData = _info.data
		for k, v in ipairs(self.groupData) do
			v.group = _info.group
		end
		_info = _info.data[1]
		self.fromCenter = fromCenter or gRechargeActiveFromEnum.ROAD03
		if _info.data and _info.data.activityType == gRechargeActivityType.THIRD_RECHARGE then
			self.fromCenter = gRechargeActiveFromEnum.ROAD40
		end
		self.isPageTurn = isPageTurn or false
		self:initPriceMenu()
	elseif _info.rType == gRechargeActiveModelType.CLIENTLADDER or _info.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
		local curGift = _info
		self.curLadderID = not curGift.ID and curGift.data and curGift.data.ID
		if not curGift.nextLadderList and not curGift.data.nextLadderList then
			local _ENV, nextLadderList = curGift.data.nextLadderList, curGift.data.nextLadderList
		end
		self.controllers.c1:setSelectedIndex(0 < #nextLadderList and 1 or 0)
		self.groupData, _ENV = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
		_ENV = 0 < #nextLadderList and 1 or 0
		;(0 < #nextLadderList and 1 or 0).rid = tonumber(self.curLadderID)
		;(0 < #nextLadderList and 1 or 0).rType = _info.rType
		;(0 < #nextLadderList and 1 or 0).price = tonumber(not curGift.price and curGift.data and curGift.data.price)
		;(0 < #nextLadderList and 1 or 0).data = curGift
		table.insert(self.groupData, 0 < #nextLadderList and 1 or 0)
		for k, v in ipairs(nextLadderList) do
			_ENV = nil
			;(nil).rid = tonumber(v.ID)
			;(nil).rType = _info.rType
			;(nil).price = tonumber(v.price)
			;(nil).data = v
			table.insert(self.groupData, nil)
		end
		self.fromCenter = fromCenter or gRechargeActiveFromEnum.ROAD03
		self.isPageTurn = isPageTurn or false
		self:initPriceMenu()
	else
		self:initData(_info, fromCenter, isPageTurn)
		self.controllers.c1:setSelectedIndex(0)
	end
	if self.tabType == gRechargeCenterCategory.RECHARGE_PRESENT then
		self.activityID = rechargePresentUtil.getActivityIDByModelType(_info.rType)
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Button_buyItem:setVisible(true)
		self.fields.Text_point_title:setVisible(true)
		self.fields.icon_item:setVisible(true)
		self.fields.Button_add:setVisible(true)
		self.fields.List_items:setHeight(self:getHeight() - 580)
		self:setPresentContent()
	else
		self.fields.Button_buyItem:setVisible(false)
		self.fields.Text_point_title:setVisible(false)
		self.fields.icon_item:setVisible(false)
		self.fields.Button_add:setVisible(false)
		local index = self.controllers.c1:getSelectedIndex()
		self.fields.List_items:setHeight(self:getHeight() - 550 - index * 44)
	end
	self.fields.Button_switch:getChild("Button_switch"):setSelected(false)
end
function rechargeViewPageNode:setPresentContent()
	if rechargePresentUtil.checkActivityFirstStage(self.activityID) then
		local titleKey = "sudanGift_text_09"
		self.Text_point_title:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).num = ticket
			return i18n(titleKey, nil)
		end)
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if eventTime then
			self.Text_point_title:beginTime(eventTime.timerNode.timer:getRemainTime())
		end
		self.fields.Button_add:setVisible(true)
	else
		self.Text_point_title:endTime()
		self.Text_point_title:setString(i18n("sudanGift_text_10"))
		self.fields.Button_add:setVisible(false)
	end
	local resId = rechargePresentUtil.getResIdByActivityID(self.activityID)
	local iconName = resDesRead.getIcon(resId)
	local presentGold = rechargePresentCtrl:getRechargePresentGold(self.activityID)
	local count = self.giftData.exchangeID and self.giftData.exchangeID[2] or 0
	self.fields.Button_buyItem:initData(iconName, presentGold, count)
	self.fields.icon_item:setSpriteFrame(iconName)
end
function rechargeViewPageNode:setTipStatus(ret, str)
	self.fields.Text_tip:setVisible(ret)
	if ret then
		self.fields.Text_tip:setString(str)
		self.fields.rechargeGift:setPositionY(254)
	else
		self.fields.rechargeGift:setPositionY(286)
	end
end
function rechargeViewPageNode:initData(_info, fromCenter, isPageTurn)
	self.fromCenter = fromCenter or gRechargeActiveFromEnum.ROAD03
	if _info.data and _info.data.activityType == gRechargeActivityType.THIRD_RECHARGE then
		self.fromCenter = gRechargeActiveFromEnum.ROAD40
	end
	self.isPageTurn = isPageTurn or false
	self.fields.Com_giftCar:setVisible(shoppingCartCtrl:isValidUse())
	self.fields.Com_giftCar:setGiftID(_info.rid)
	if self.fromCenter then
		paymentManager.OnemtOpenGiftUI(_info.rid, self.fromCenter, self.isPageTurn, _info.data.push_id)
	end
	local giftStyle = rechargeRead.getPageViewData(_info.rid)
	if gRechargeActiveModelType.RECHARGE_PRESENT == _info.rType then
		giftStyle = rechargeRead.getRechargePresentPageViewData(_info.rid)
	elseif gRechargeActiveModelType.NEW_YEAR_PRESENT == _info.rType then
		giftStyle = rechargeRead.getNewyearPresentPageViewData(_info.rid)
	end
	self.giftRid = _info.rid
	self.giftType = giftStyle and giftStyle.activeModelType
	self.giftData = _info.data
	self.groupOwn = _info.group
	self.giftData.giftStyle = giftStyle
	if giftStyle then
		_ENV = _info.rid
		_info.rid.msg = "MESSAGE_SERVER_RECHARGECENTER_CHANGEGIFTNAME"
		_info.rid.str = giftStyle.activeName
		SoraDSendMessage(_info.rid)
	end
	local tipRet = _info.data.refund and _info.data.refund == 1 or false
	local tipStr = i18n("common_text_789")
	if gRechargeActiveModelType.NORMAL == _info.rType then
		self.giftData.leftTime = rechargeActivityCtrl:queryQueue(self.giftData.ID).timerNode.timer:getRemainTime()
		self:initNormalPage()
	elseif gRechargeActiveModelType.RUIRUILADDER == _info.rType then
		self.giftData.leftTime = self.giftData.endtime - self.giftData.starttime
		self:initNormalPage()
	elseif gRechargeActiveModelType.CLIENTLADDER == _info.rType or gRechargeActiveModelType.BIRTHDAY_LADDER == _info.rType then
		self.giftData.leftTime = self.giftData.endtime - serviceFunctions.systemTime()
		self:initNormalPage()
		tipRet = true
		tipStr = self.giftRid == self.curLadderID and i18n("common_text_789") or i18n("common_text_2848")
	elseif gRechargeActiveModelType.LUCKYGIFT == _info.rType then
		self.giftData.leftTime = luckyGiftCtrl:getLuckyGiftTime(self.giftData.luckyGiftID)
		self:initLuckyPage()
	elseif gRechargeActiveModelType.RECHARGE_PRESENT == _info.rType then
		self.giftType = gRechargeActiveModelType.RECHARGE_PRESENT
		self.giftData.leftTime = rechargePresentUtil.getActivityLeftTime()
		self:initRechargePresentPage()
	elseif gRechargeActiveModelType.NEW_YEAR_PRESENT == _info.rType then
		self.giftType = gRechargeActiveModelType.NEW_YEAR_PRESENT
		self.giftData.leftTime = rechargePresentUtil.getActivityLeftTime()
		self:initRechargePresentPage()
	elseif gRechargeActiveModelType.NEW_PRINCE_GIFT == _info.rType then
		self.giftData.leftTime = 0
		self:initNewPrinceGiftPage()
	end
	self.fields.List_items:jumpToTop()
	self:checkRedPackage(_info.rid)
	_ENV, shoppingCartCtrl = self, self.checkRedPackage
	self.rechargeID = self.giftData.ID or self.giftData.luckyGiftID
	local self.checkRedPackage[1], rechargeIDList = self, self.checkRedPackage
	self.fields.rechargeGift:initData(rechargeIDList)
	self:updateOutAppPurchase()
	self:setTipStatus(tipRet, tipStr)
end
function rechargeViewPageNode:initLuckyPage()
	luckyGiftCtrl:clickGift(self.giftData.luckyGiftID)
	luckyGiftCtrl = luckyGiftCtrl
	luckyGiftCtrl.msg = "MESSAGE_CLIENT_RECHARGECENTER_LUCKYGIFTPOINTREFRESH"
	SoraDSendMessage(luckyGiftCtrl)
	local id = self.giftData.luckyGiftID
	self:initPublicView(id)
	self:initScroll(self.giftData.gift, id)
end
function rechargeViewPageNode:initRechargePresentPage()
	self.fields.Text_title:setString(i18n(self.giftData.giftStyle.activeName))
	self.fields.icon:setSpriteFrame(self.giftData.giftStyle.popBanner)
	if self.giftData.gold and tonumber(self.giftData.gold) > 0 then
		self.fields.Image_gold:setVisible(true)
		self.fields.Text_gold:setVisible(true)
		self.fields.Text_once:setVisible(true)
		self.fields.Text_onceEx:setVisible(false)
		self.fields.Text_gold:setString(string.formatnumberthousands(self.giftData.gold))
	else
		self.fields.Image_gold:setVisible(false)
		self.fields.Text_gold:setVisible(false)
		self.fields.Text_once:setVisible(false)
		self.fields.Text_onceEx:setVisible(true)
	end
	self.fields.Text_discount:setVisible(false)
	self.fields.Node_style:setVisible(false)
	if self.giftData.giftStyle.hideTime and self.giftData.giftStyle.hideTime == 1 then
		self.fields.Text_time:setVisible(false)
		self.fields.tbg:setVisible(false)
	else
		self.fields.Text_time:setVisible(true)
		self.fields.tbg:setVisible(true)
	end
	if self.giftData.giftStyle.activeExplain ~= "" then
		if type(self.giftData.giftStyle.activeExplain) == "string" then
			self.fields.Text_giftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
		elseif type(self.giftData.giftStyle.activeExplain) == "table" then
			if next(self.giftData.giftStyle.activeExplain) then
				self.fields.Text_giftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
			else
				self.fields.Text_giftTip:setString("")
			end
		end
	else
		self.fields.Text_giftTip:setString("")
	end
	local isMoreBuyTimes = (self.giftData.payType == gRechargeActivityBuyType.LIMIT or self.giftData.payType == gRechargeActivityBuyType.LIMIT_DAILY) and tonumber(self.giftData.extraData) or 1
	if not self.giftData.payType and self.giftData.luckyGiftID then
		self.giftData.already_buy = self.giftData.already_buy or 0
		isMoreBuyTimes = self.giftData.buy_limit - self.giftData.already_buy
	end
	_ENV = i18n(self.giftData.giftStyle.activeExplain)
	i18n(self.giftData.giftStyle.activeExplain).num = isMoreBuyTimes
	self.fields.Text_once:setString(i18n("common_text_2516", i18n(self.giftData.giftStyle.activeExplain)))
	_ENV = i18n("common_text_2516", i18n(self.giftData.giftStyle.activeExplain))
	i18n("common_text_2516", i18n(self.giftData.giftStyle.activeExplain)).num = isMoreBuyTimes
	self.fields.Text_onceEx:setString(i18n("common_text_2516", i18n("common_text_2516", i18n(self.giftData.giftStyle.activeExplain))))
	self:initScroll(SoraDIntArr2FormatTable(self.giftData.gift))
end
function rechargeViewPageNode:initNewPrinceGiftPage()
	local id = self.giftData.ID
	self:initPublicView(id)
	local _ENV, gift = self.initPublicView, self.initPublicView
	local name = i18n(self.giftData.buffName)
	_ENV = nil
	;(nil).num1 = self.giftData.buffValue / 60
	_ENV, _ENV, (nil).num2 = nil, self.giftData.buffTime / 86400, self.giftData.buffTime / 86400
	_ENV, (self.giftData.buffTime / 86400).num1, (nil).color = nil, nil, "#00FF00"
	_ENV, (self.giftData.buffTime / 86400).num2, (nil).color = nil, nil, "#00FF00"
	;(self.giftData.buffTime / 86400).__default, (nil).color = nil, "#FAD26E"
	local desc = i18n_html(self.giftData.buffDescribe, nil, self.giftData.buffTime / 86400)
	local introduction = i18n(self.giftData.buffBriefIntroduction)
	_ENV = self.giftData.buffBriefIntroduction
	_ENV, self.giftData.buffBriefIntroduction.type = self.giftData.buffTime / 86400, "buff"
	;(self.giftData.buffTime / 86400).icon = self.giftData.buffIcon
	;(self.giftData.buffTime / 86400).name = name
	;(self.giftData.buffTime / 86400).desc = desc
	self.giftData.buffBriefIntroduction.buff, (self.giftData.buffTime / 86400).introduction = self.giftData.buffTime / 86400, introduction
	local self.giftData.buffBriefIntroduction.index, buffData = 1, self.giftData.buffBriefIntroduction
	table.insert(gift, buffData)
	for i, v in ipairs(self.giftData.gift) do
		if i % 2 == 1 then
			_ENV = nil
			;(nil).type = "item"
			;(nil).id = v
			;(nil).num = self.giftData.gift[i + 1]
			table.insert(gift, nil)
		end
	end
	self:initScroll(gift, id)
end
function rechargeViewPageNode:initNormalPage()
	local id = not self.giftData.ID and self.giftData.data and self.giftData.data.ID
	self:initPublicView(id)
	local rechargeRead, gift = self.initPublicView, self.initPublicView
	local buffCfg = rechargeRead.getRechargeBuffCfg(tonumber(id))
	if buffCfg then
		rechargeRead = tonumber(id)
		rechargeRead, tonumber(id).type = tonumber(id)
		tonumber(id).icon = buffCfg.buffIcon
		tonumber(id).name = i18n(buffCfg.buffName)
		tonumber(id).buff, tonumber(id).desc = tonumber(id)
		local tonumber(id).index, buffData = 1, tonumber(id)
		table.insert(gift, buffData)
	end
	if type(self.giftData.gift) == "string" then
		local item = SoraDArrary2Table(self.giftData.gift)
		for k, v in ipairs(item) do
			rechargeRead = tonumber(id)
			tonumber(id).type = "item"
			tonumber(id).id = v.id
			tonumber(id).num = v.num
			table.insert(gift, tonumber(id))
		end
	else
		local giftList = not self.giftData.gift and self.giftData.data and self.giftData.data.gift
		if type(giftList) == "table" then
			for k, v in ipairs(giftList) do
				rechargeRead = tonumber(id)
				tonumber(id).type = "item"
				tonumber(id).id = v.id
				tonumber(id).num = v.count
				table.insert(gift, tonumber(id))
			end
		end
	end
	self:initScroll(gift, id)
end
function rechargeViewPageNode:isHighLightShow(list, index)
	local ret = false
	for k, v in pairs(list) do
		if tonumber(v) == tonumber(index) then
			ret = true
		end
	end
	return ret
end
function rechargeViewPageNode:initScroll(giftData, id)
	self.itemList, rechargePresentUtil = nil, nil
	giftData = giftData or self.giftData.gift
	local fixData = rechargePresentUtil.fixRechargePresentData(id, giftData, self.giftData.highlight)
	giftData = fixData.gift
	for i, v in ipairs(giftData) do
		if v.type == nil or v.type == "item" then
			local isHighLight = false
			if type(fixData.highlight) == "table" and self:isHighLightShow(fixData.highlight, i) then
				isHighLight = true
			end
			rechargePresentUtil = fixData.highlight
			fixData.highlight.id = v.id
			fixData.highlight.count = v.num or v.count
			fixData.highlight.type = v.type
			fixData.highlight.isHighLight = isHighLight
			table.insert(self.itemList, fixData.highlight)
		elseif v.type == "buff" then
			rechargePresentUtil = v.type
			rechargePresentUtil, v.type.type = table.insert, "buff"
			table.insert.icon = v.buff.icon
			table.insert.name = v.buff.name
			table.insert.desc = v.buff.desc
			v.type.buff, table.insert.isHighLight = table.insert, true
			local buffData = v.type
			table.insert(self.itemList, buffData)
		end
	end
	self.fields.List_items:setNumItems(#self.itemList)
	if self.giftData.leftTime and self.giftData.leftTime > 0 then
		if self.giftData.activityType == gRechargeActivityType.THIRD_RECHARGE and self.giftData.leftTime > serviceFunctions.getMothRemainTime() then
			self.fields.Text_time:beginTime(serviceFunctions.getMothRemainTime())
		else
			self.fields.Text_time:beginTime(self.giftData.leftTime)
		end
		self.fields.Text_time:setVisible(true)
		self.fields.tbg:setVisible(true)
	else
		self.fields.Text_time:setVisible(false)
		self.fields.tbg:setVisible(false)
	end
end
function rechargeViewPageNode:initPublicView(giftID)
	local price = tonumber(not self.giftData.price and self.giftData.data and self.giftData.data.price)
	local originalPrice = tonumber(not self.giftData.originalPrice and self.giftData.data and self.giftData.data.originalPrice)
	local showPrice, isGetPrice = paymentManager.judgePrice(giftID, price)
	local discount = 0 < price and originalPrice / price or 99.99
	local oriShowPrice = paymentManager.calculateDiscount(giftID, showPrice, discount, originalPrice)
	self.fields.Button_buy:initData(showPrice, oriShowPrice)
	self.nowPrice = showPrice
	self.oriPrice = oriShowPrice
	local giftStyle = not self.giftData.giftStyle and self.giftData.data and self.giftData.data.giftStyle
	self.fields.Text_title:setString(i18n(giftStyle.activeName))
	self.fields.icon:setSpriteFrame(giftStyle.popBanner)
	local giftGold = tonumber(not self.giftData.gold and self.giftData.data and self.giftData.data.gold) or 0
	if 0 < giftGold then
		self.fields.Image_gold:setVisible(true)
		self.fields.Text_gold:setVisible(true)
		self.fields.Text_once:setVisible(true)
		self.fields.Text_onceEx:setVisible(false)
		self.fields.Text_gold:setString(string.formatnumberthousands(giftGold))
	else
		self.fields.Image_gold:setVisible(false)
		self.fields.Text_gold:setVisible(false)
		self.fields.Text_once:setVisible(false)
		self.fields.Text_onceEx:setVisible(true)
	end
	local discount = not self.giftData.discount and self.giftData.data and self.giftData.data.discount
	self:styleChangeDes(discount)
	if giftStyle.hideTime and tonumber(giftStyle.hideTime) == 1 then
		self.fields.Text_time:setVisible(false)
		self.fields.tbg:setVisible(false)
	else
		self.fields.Text_time:setVisible(true)
		self.fields.tbg:setVisible(true)
	end
	if giftStyle.activeExplain ~= "" then
		if type(giftStyle.activeExplain) == "string" then
			self.fields.Text_giftTip:setString(i18n(giftStyle.activeExplain))
			if not IsArClient and SoraDGetDefaultLanguage() ~= "en" and (giftID == 13835 or giftID == 13836) then
				self.fields.Text_giftTip:setString("")
			end
		elseif type(giftStyle.activeExplain) == "table" then
			if next(giftStyle.activeExplain) then
				self.fields.Text_giftTip:setString(i18n(giftStyle.activeExplain))
			else
				self.fields.Text_giftTip:setString("")
			end
		end
	else
		self.fields.Text_giftTip:setString("")
	end
	local payType = not self.giftData.payType and self.giftData.data and self.giftData.data.payType
	local isMoreBuyTimes = (payType == gRechargeActivityBuyType.LIMIT or payType == gRechargeActivityBuyType.LIMIT_DAILY) and tonumber(self.giftData.extraData) or 1
	if not payType and self.giftData.luckyGiftID then
		self.giftData.already_buy = self.giftData.already_buy or 0
		isMoreBuyTimes = self.giftData.buy_limit - self.giftData.already_buy
	end
	_ENV = i18n(giftStyle.activeExplain)
	i18n(giftStyle.activeExplain).num = isMoreBuyTimes
	self.fields.Text_once:setString(i18n("common_text_2516", i18n(giftStyle.activeExplain)))
	_ENV = i18n("common_text_2516", i18n(giftStyle.activeExplain))
	i18n("common_text_2516", i18n(giftStyle.activeExplain)).num = isMoreBuyTimes
	self.fields.Text_onceEx:setString(i18n("common_text_2516", i18n("common_text_2516", i18n(giftStyle.activeExplain))))
	if gRechargeActiveModelType.NORMAL == self.giftType and payType == gRechargeActivityBuyType.NORMAL then
		self.fields.Text_once:setVisible(false)
		self.fields.Text_onceEx:setVisible(false)
	end
	local _ENV, categoryMap = self.fields.Text_onceEx.setVisible, self.fields.Text_onceEx.setVisible
	if self.giftData.category then
		categoryMap[self.giftData.category] = true
	end
	local extraCategory = self.giftData.extraCategory
	if extraCategory and type(extraCategory) == "string" and 0 < string.len(extraCategory) then
		local tmpList = SoraDStringSplit(extraCategory, ",")
		for _, _category in ipairs(tmpList) do
			categoryMap[tonumber(_category)] = true
		end
	end
	self.fields.Button_switch:setVisible(rechargeRead.isCanHideCategory(categoryMap))
end
function rechargeViewPageNode:styleChangeDes(discount)
	if gRechargeDiscountStyle.NUMBER == tonumber(discount[1]) then
		self.fields.Node_style:setVisible(false)
		self.fields.Text_discount:setVisible(true)
		_ENV = nil
		;(nil).num = math.floor(tonumber(discount[2]))
		;(nil).char = "%"
		self.fields.Text_discount:setTitle(i18n("common_text_1470", nil))
	elseif gRechargeDiscountStyle.IMAGE == tonumber(discount[1]) then
		self.fields.Node_style:setVisible(true)
		self.fields.Text_discount:setVisible(false)
		local img = rechargeRead.getPromoIcon(tonumber(discount[2])).icon
		self.fields.Node_style:setIcon(img)
	end
end
function rechargeViewPageNode:checkRedPackage(id)
	local redPackageID = activityShowCtrl:getRedPackageRid()
	if SoraDisInList(id, redPackageID) then
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		self.fields.rechargeRedPackageNode:setVisible(not isInConquestWar)
	else
		self.fields.rechargeRedPackageNode:setVisible(false)
	end
end
function rechargeViewPageNode:updateOutAppPurchase()
	if self.rType == gRechargeActiveModelType.CLIENTLADDER or self.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
		if self.giftRid == self.curLadderID then
			if SoraDCheckOAPIsOpen(self.giftRid) and self.giftData.activityType ~= gRechargeActivityType.THIRD_RECHARGE then
				self.fields.outAppPurchaseButtons:setVisible(true)
				self.fields.Button_buy:setVisible(false)
				_ENV = false
				;(false).rid = self.giftRid
				;(false).nowPrice = self.nowPrice
				_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
				self.oriPrice.fromCenter = self.fromCenter
				self.oriPrice.isPageTurn = self.isPageTurn
				;(false).logInfo, self.oriPrice.pushID = self.oriPrice, self.giftData.push_id
				;(false).handleBuyClick = handler(self, self.btnBuyClick)
				;(false).handleItemBuyEx = function()
					_ENV = nil
					;(nil).msg = "MESSAGE_UI_RECHARGECENTER_GROUP_NOTIFY"
					;(nil).group = self.groupOwn
					SoraDSendMessage(nil)
				end
				self.fields.outAppPurchaseButtons:initData(false)
			else
				self.fields.outAppPurchaseButtons:setVisible(false)
				self.fields.Button_buy:setVisible(true)
				self.fields.Button_buy:setEnabled(true)
			end
		else
			self.fields.outAppPurchaseButtons:setVisible(false)
			self.fields.Button_buy:setVisible(true)
			self.fields.Button_buy:setTitle(i18n("common_text_2274"))
			self.fields.Button_buy:setEnabled(false)
		end
	elseif SoraDCheckOAPIsOpen(self.giftRid) and self.giftData.activityType ~= gRechargeActivityType.THIRD_RECHARGE then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftRid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		self.oriPrice.fromCenter = self.fromCenter
		self.oriPrice.isPageTurn = self.isPageTurn
		;(false).logInfo, self.oriPrice.pushID = self.oriPrice, self.giftData.push_id
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		;(false).handleItemBuyEx = function()
			_ENV = nil
			;(nil).msg = "MESSAGE_UI_RECHARGECENTER_GROUP_NOTIFY"
			;(nil).group = self.groupOwn
			SoraDSendMessage(nil)
		end
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
	end
end
function rechargeViewPageNode:btnBuyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RECHARGECENTER_GROUP_NOTIFY"
	;(nil).group = self.groupOwn
	SoraDSendMessage(nil)
	local rid = self.giftData.ID or self.giftData.rid
	if gRechargeActiveModelType.NORMAL == self.giftType or gRechargeActiveModelType.RUIRUILADDER == self.giftType or gRechargeActiveModelType.PETRA_GIFT == self.giftType or gRechargeActiveModelType.LINGLANG_GIFT == self.giftType then
		if self.giftData.activityType == gRechargeActivityType.THIRD_RECHARGE and tonumber(self.giftData.extraData) < 1 then
			SoraDShowMsgTip(i18n("common_text_4629"))
			return
		end
		paymentManager.normalGiftBuyClassify(rid)
		paymentManager.OnemtReadyBuy(rid, self.fromCenter, self.isPageTurn)
	elseif gRechargeActiveModelType.LUCKYGIFT == self.giftType then
		if self.giftData.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
			paymentManager.normalGiftBuyClassify(self.giftData.luckyGiftID)
			paymentManager.OnemtReadyBuy(self.giftData.luckyGiftID, self.fromCenter, self.isPageTurn, nil, self.giftData.push_id)
		else
			paymentManager.normalGiftBuyClassify(self.giftData.luckyGiftID)
			paymentManager.OnemtReadyBuy(self.giftData.luckyGiftID, self.fromCenter, self.isPageTurn, nil, self.giftData.push_id)
		end
	elseif gRechargeActiveModelType.NEW_PRINCE_GIFT == self.giftType then
		princeGiftNewCtrl:reqBuyPackage(rid)
	end
end
function rechargeViewPageNode:initPriceMenu()
	local self.tabsetArray, _ENV, defaultClick = gRechargeActiveModelType.BIRTHDAY_LADDER, gRechargeActiveModelType.BIRTHDAY_LADDER, (self.rType == gRechargeActiveModelType.CLIENTLADDER or self.rType == gRechargeActiveModelType.BIRTHDAY_LADDER) and #self.groupData or 1
	for i, v in ipairs(self.groupData) do
		if self.rType ~= gRechargeActiveModelType.CLIENTLADDER and self.rType ~= gRechargeActiveModelType.BIRTHDAY_LADDER and self.lastRid and self.lastRid == v.rid then
			defaultClick = i
		end
		local price = tonumber(not v.data.price and v.data.data and v.data.data.price)
		print("initPriceMenu=======", v.rid, price)
		local showPrice, isGetPrice = paymentManager.judgePrice(v.rid, price)
		_ENV = nil
		;(nil).title = showPrice
		;(nil).tag = i
		;(nil).price = price
		;(nil).rid = tonumber(v.rid)
		table.insert(self.tabsetArray, nil)
	end
	table.sort(self.tabsetArray, function(a, b)
		if a.price == b.price then
			return a.rid > b.rid
		else
			return a.price > b.price
		end
	end)
	for k, v in ipairs(self.tabsetArray) do
		v.tag = k
	end
	if self.jumpToRID and self.isJumpInit then
		for i, v in ipairs(self.tabsetArray) do
			if tonumber(self.jumpToRID) == tonumber(v.rid) then
				defaultClick = v.tag
				break
			end
		end
		self.isJumpInit = false
	end
	print("defaultClick======", defaultClick)
	_ENV = defaultClick
	defaultClick.defaultClick = defaultClick
	defaultClick.tabsetArray = self.tabsetArray
	defaultClick.callback = handler(self, self.clickPriceTab)
	self.fields.Tab_price:initView(defaultClick)
end
function rechargeViewPageNode:clickPriceTab(tag)
	local _ENV, showData
	for k, v in ipairs(self.groupData) do
		if v.rid == self.tabsetArray[tag].rid then
			showData = v
			break
		end
	end
	self.lastRid = showData.rid
	self:initData(showData, self.fromCenter, self.isPageTurn)
end
function rechargeViewPageNode:btnTouchClick()
	if self.rType == gRechargeActiveModelType.CLIENTLADDER then
		SoraDPlaySound()
		if self.giftRid == self.curLadderID then
			_ENV = nil
			;(nil).id = self.giftRid
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD03
			uiManager:show("rechargePopView", nil)
		else
			_ENV = nil
			;(nil).id = self.giftRid
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD03
			;(nil).isLadder = true
			;(nil).info = self.giftData
			uiManager:show("rechargePopView", nil)
		end
	elseif self.rType == gRechargeActiveModelType.RECHARGE_PRESENT or self.rType == gRechargeActiveModelType.NEW_YEAR_PRESENT then
	else
		SoraDPlaySound()
		_ENV = nil
		;(nil).id = self.giftRid
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD03
		uiManager:show("rechargePopFrame", nil)
	end
end
function rechargeViewPageNode:onClickAdd()
	SoraDPlaySound()
	print("self.activityID=====", self.activityID)
	rechargePresentUtil.openRechargeViewLimit(self.activityID)
end
function rechargeViewPageNode:btnItemBuyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RECHARGECENTER_GROUP_NOTIFY"
	;(nil).group = self.groupOwn
	SoraDSendMessage(nil)
	if gRechargeActiveModelType.NORMAL == self.giftType or gRechargeActiveModelType.RUIRUILADDER == self.giftType or gRechargeActiveModelType.PETRA_GIFT == self.giftType or gRechargeActiveModelType.LINGLANG_GIFT == self.giftType then
		paymentManager.normalGiftBuyClassify(self.giftData.ID)
		paymentManager.OnemtReadyBuy(self.giftData.ID, self.fromCenter, self.isPageTurn)
	elseif gRechargeActiveModelType.LUCKYGIFT == self.giftType then
		if self.giftData.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
			paymentManager.normalGiftBuyClassify(self.giftData.luckyGiftID)
			paymentManager.OnemtReadyBuy(self.giftData.luckyGiftID, self.fromCenter, self.isPageTurn, nil, self.giftData.push_id)
		else
			paymentManager.normalGiftBuyClassify(self.giftData.luckyGiftID)
			paymentManager.OnemtReadyBuy(self.giftData.luckyGiftID, self.fromCenter, self.isPageTurn, nil, self.giftData.push_id)
		end
	elseif gRechargeActiveModelType.RECHARGE_PRESENT == self.giftType or gRechargeActiveModelType.NEW_YEAR_PRESENT == self.giftType then
		rechargePresentUtil.sendPresentGiftExchange(self.giftData, self.activityID)
	end
end
function rechargeViewPageNode:menuBtnClick()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RECHARGECENTER_MENU_SHOW"
	SoraDSendMessage(nil)
end
function rechargeViewPageNode:switchBtnClick()
	SoraDPlaySound()
	local dailyRemindManager = include("dailyRemindManager")
	local remindType = dailyRemindManager.REMIND_TYPE.recharge_hide_gift
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:Recharge:hideGift~table", nil) then
		local _ENV, hideList = SoraDConfigGet("Game:Recharge:hideGift~table", nil), SoraDConfigGet("Game:Recharge:hideGift~table", nil)
	end
	if dailyRemindManager.checkNeedRemind(remindType) then
		_ENV = nil
		;(nil).name = i18n(self.giftData.giftStyle.activeName)
		local content = i18n("recharge_setting_text_02", nil)
		if self.rType == gRechargeActiveModelType.CLIENTLADDER or self.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
			content = i18n("recharge_setting_text_12")
		end
		_ENV = self.giftData.giftStyle.activeName
		self.giftData.giftStyle.activeName.content = content
		function self.giftData.giftStyle.activeName.confirmFunc()
			hideList[tostring(self.giftRid)] = true
			hideList = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:Recharge:hideGift~table", hideList, nil)
			SoraDShowMsgTip(i18n("recharge_setting_text_03"))
			hideList = i18n("recharge_setting_text_03")
			i18n("recharge_setting_text_03").msg = "MESSAGE_UI_RECHARGECENTER_HIDE_GIFT"
			SoraDSendMessage(i18n("recharge_setting_text_03"))
		end
		self.giftData.giftStyle.activeName.cancel = true
		function self.giftData.giftStyle.activeName.hideFunc()
			self.fields.Button_switch:getChild("Button_switch"):setSelected(false)
		end
		self.giftData.giftStyle.activeName.remindString = i18n("coffeeCraftsman_text_27")
		function self.giftData.giftStyle.activeName.remindFunc(value)
			if value then
				dailyRemindManager.addRemindToManager(remindType)
			end
		end
		uiManager:show("MessageBox", self.giftData.giftStyle.activeName)
	else
		hideList[tostring(self.giftRid)] = true
		_ENV = "MessageBox"
		;("MessageBox").byUID = true
		SoraDConfigSet("Game:Recharge:hideGift~table", hideList, "MessageBox")
		SoraDShowMsgTip(i18n("recharge_setting_text_03"))
		_ENV = i18n("recharge_setting_text_03")
		i18n("recharge_setting_text_03").msg = "MESSAGE_UI_RECHARGECENTER_HIDE_GIFT"
		SoraDSendMessage(i18n("recharge_setting_text_03"))
	end
end
return rechargeViewPageNode
