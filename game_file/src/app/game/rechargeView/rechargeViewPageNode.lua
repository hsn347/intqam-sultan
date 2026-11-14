local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local equipDesRead = include("equipDesRead")
local rechargePresentUtil = include("rechargePresentUtil")
local rechargeRead = include("rechargeRead")
local RechargeViewPageNode = class("rechargeViewPageNode", function(target)
	print("创建 rechargeViewPageNode!!!")
	local targetType = type(target)
	if targetType == "nil" then
		return SoraDCreateBasePanel("rechargeViewPageNode")
	elseif targetType == "userdata" then
		return SoraDCreateCloneBasePanel(target, "rechargeViewPageNode")
	else
		return target
	end
end)
function RechargeViewPageNode:ctor()
	self.defaultClick = 1
	self.pageMaxHeigh = 0
	self.buffDatas, _ENV, self.itemOcxsList, _ENV, self.itemOcxsRecycleList, _ENV, self.eventHeadHeight = nil, nil, nil, nil, nil, nil, 400
	self.nodeHead = SoraDGetChildByName(self, "ProjectNode_head")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.txtNowPrice = SoraDGetChildByName(self, "Text_nowPrice")
	self.txtOriPrice = SoraDGetChildByName(self, "Text_oriPrice")
	self.txtGiftTip = SoraDGetChildByName(self, "Text_giftTip")
	self.scroll = SoraDGetChildByName(self, "ScrollView_itemList")
	self.nodeCharge = SoraDGetChildByName(self, "Node_recharge")
	self.btnBuy:setContentSize(cc.size(460, 70))
	self.nodeCharge:setPositionX(62)
	self.spDownArrow = SoraDGetChildByName(self, "Sprite_downArrow")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.imgItem:setVisible(false)
	self.imgItemPanel = SoraDGetChildByName(self, "Image_itemList")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.Top_Node_clound = SoraDGetChildByName(self, "Top_Node_clound")
	self.Node_PirceTab = SoraDGetChildByName(self, "Node_PirceTab")
	self.ScrollView_Price = SoraDGetChildByName(self.Node_PirceTab, "ScrollView_Price")
	self.ccs_PriceTab = SoraDGetExtendChildFromCCSByName(self.Node_PirceTab, "CCS_commonTabBtnEX_Price")
	self.ccs_PriceTab:setNewStyle(true)
	self.Node_PirceTab:setVisible(false)
	self.ccs_car = SoraDGetExtendChildFromCCSByName(self, "CCS_giftShopCar_car")
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btnBuy:setSwallowTouches(false)
	SoraDRechargeBtnEffect(self.btnBuy)
	self.scroll:addTouchEventListener(function(img, eventType)
		if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.began then
			_ENV = nil
			;(nil).msg = "MESSAGE_CLIENT_RECHARGECENTER_TIMEOVER"
			SoraDSendMessage(nil)
		end
	end)
end
function RechargeViewPageNode:checkRedPackage(id)
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local redPackageID = activityShowCtrl:getRedPackageRid()
	if SoraDisInList(id, redPackageID) then
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		if not self.btnRedPackage and not isInConquestWar then
			self.btnRedPackage = include("rechargeRedPackageNode").new()
			self.btnRedPackage:setPosition(cc.p(-170, -57))
			self.btnRedPackage:addTo(self, 99)
		end
	elseif self.btnRedPackage then
		self.btnRedPackage:removeFromParent()
		self.btnRedPackage = nil
	end
end
function RechargeViewPageNode:recycleAll()
	local hiddleHighLight = function(item)
		local effect = item:getChildByName("highLight")
		if effect then
			effect:setVisible(false)
		end
	end
	for i, v in ipairs(self.itemOcxsList) do
		hiddleHighLight(v)
		v:setVisible(false)
		table.insert(self.itemOcxsRecycleList, v)
	end
	self.itemOcxsList, _ENV = ipairs(self.itemOcxsList)
end
function RechargeViewPageNode:initGroup(_info, fromCenter, isPageTurn)
	if _info.group then
		self.groupData = _info.data
		_info = _info.data[1]
		dump(_info, "_info")
		self.fromCenter = fromCenter or gRechargeActiveFromEnum.ROAD03
		if _info.data and _info.data.activityType == gRechargeActivityType.THIRD_RECHARGE then
			self.fromCenter = gRechargeActiveFromEnum.ROAD40
		end
		self.isPageTurn = isPageTurn or false
		self:initPriceMenu()
	else
		self.Node_PirceTab:setVisible(false)
		self:initData(_info, fromCenter, isPageTurn)
	end
end
function RechargeViewPageNode:initData(_info, fromCenter, isPageTurn)
	self.fromCenter = fromCenter or gRechargeActiveFromEnum.ROAD03
	if _info.data and _info.data.activityType == gRechargeActivityType.THIRD_RECHARGE then
		self.fromCenter = gRechargeActiveFromEnum.ROAD40
	end
	self.isPageTurn = isPageTurn or false
	self.ccs_car:setGiftID(_info.rid)
	local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
	self.ccs_car:setVisible(shoppingCartCtrl:isValidUse())
	if self.fromCenter then
		paymentManager.OnemtOpenGiftUI(_info.rid, self.fromCenter, self.isPageTurn, _info.data.push_id)
	end
	local giftStyle
	if gRechargeActiveModelType.RECHARGE_PRESENT == _info.rType then
		giftStyle = rechargeRead.getRechargePresentPageViewData(_info.rid)
	else
		giftStyle = rechargeRead.getPageViewData(_info.rid)
	end
	self.giftRid = _info.rid
	self.giftType = giftStyle.activeModelType
	self.giftData = _info.data
	self.giftData.giftStyle = giftStyle
	_ENV = _info.rid
	_info.rid.msg = "MESSAGE_SERVER_RECHARGECENTER_CHANGEGIFTNAME"
	_info.rid.str = giftStyle.activeName
	SoraDSendMessage(_info.rid)
	self:recycleAll()
	if gRechargeActiveModelType.NORMAL == _info.rType then
		local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
		self.giftData.leftTime = rechargeActivityCtrl:queryQueue(self.giftData.ID).timerNode.timer:getRemainTime()
		self:initNormalPage()
	elseif gRechargeActiveModelType.RUIRUILADDER == _info.rType then
		self.giftData.leftTime = self.giftData.endtime - self.giftData.starttime
		self:initNormalPage()
	elseif gRechargeActiveModelType.LUCKYGIFT == _info.rType then
		local luckyGiftCtrl = gametop.playertop_:getModule("luckyGiftCtrl")
		self.giftData.leftTime = luckyGiftCtrl:getLuckyGiftTime(self.giftData.luckyGiftID)
		self:initLuckyPage()
	elseif gRechargeActiveModelType.RECHARGE_PRESENT == _info.rType then
		self.giftData.leftTime = rechargePresentUtil.getActivityLeftTime()
		self:initRechargePresentPage()
	elseif gRechargeActiveModelType.NEW_PRINCE_GIFT == _info.rType then
		self.giftData.leftTime = 0
		self:initNewPrinceGiftPage()
	end
	self.scroll:jumpToTop()
	self:checkRedPackage(_info.rid)
	dump(self.giftData, "self.giftData", 10)
	_ENV, rechargeRead = "self.giftData", self.giftData
	;("self.giftData").rechargeID = self.giftData.ID or self.giftData.luckyGiftID
	self.giftData[1] = "self.giftData"
	SoraDCreateRechargeGiftNode(self.giftData, self.Node_bottom, cc.p(282, SoraDGetChildByName(self.Node_bottom, "Image_content"):getPositionY() + 123), nil, 2)
	self:updateOutAppPurchase()
end
function RechargeViewPageNode:initPriceMenu()
	if self.groupData and next(self.groupData) then
		self.Node_PirceTab:setVisible(true)
		local tabNum = table.nums(self.groupData)
		local width = 140 * tabNum
		self.ccs_PriceTab:setContentSize(cc.size(width, 56))
		local rSize = math.max(width, 640)
		self.ScrollView_Price:setInnerContainerSize(cc.size(rSize, 50))
		local _ENV, tabsetArray = self.ScrollView_Price.setInnerContainerSize, self.ScrollView_Price.setInnerContainerSize
		local defaultClick
		for i, v in ipairs(self.groupData) do
			if self.lastRid == v.rid then
				defaultClick = i
			end
			local showPrice, isGetPrice = paymentManager.judgePrice(v.rid, v.data.price)
			_ENV = cc.size(rSize, 50)
			cc.size(rSize, 50).title = showPrice
			cc.size(rSize, 50).tag = i
			cc.size(rSize, 50).handle = handler(self, self.clickPriceTab)
			table.insert(tabsetArray, cc.size(rSize, 50))
		end
		_ENV = ipairs(self.groupData)
		ipairs(self.groupData).defaultClick = defaultClick or 1
		ipairs(self.groupData).tabNum = tabNum
		ipairs(self.groupData).tabsetArray = tabsetArray
		self.ccs_PriceTab:initView(ipairs(self.groupData))
		self.ccs_PriceTab:setSwallow(false)
		self.ccs_PriceTab:setPositionX(rSize / 2)
	else
		self.Node_PirceTab:setVisible(false)
	end
end
function RechargeViewPageNode:bindOcx(...)
	if self.giftData.giftStyle then
		if self.imgHeadPage == nil then
			self.imgHeadPage = SoraDGetChildByName(self.nodeHead, "Image_bg")
			self.Node_gold = SoraDGetChildByName(self.nodeHead, "Node_gold")
			self.txtGoldNum = SoraDGetChildByName(self.nodeHead, "Text_gold")
			self.icon_coin = SoraDGetChildByName(self.nodeHead, "icon_coin")
			self.txtLimit = SoraDGetChildByName(self.nodeHead, "Text_once")
			self.Node_time = SoraDGetChildByName(self.nodeHead, "Node_time")
			self.txtTime = SoraDGetChildByName(self.nodeHead, "Text_time")
			self.nodeDiscount = SoraDGetChildByName(self.nodeHead, "Node_discount")
			self.txtDiscount = self.nodeDiscount:getChildByName("Text_discount")
			self.nodeStyle = SoraDGetChildByName(self.nodeHead, "Node_style")
			self.txtGold = SoraDGetChildByName(self.nodeHead, "Text_gold")
			self.Node_bottom = SoraDGetChildByName(self.nodeHead, "Node_bottom")
			self.spTime = SoraDGetChildByName(self.nodeHead, "Sprite_time")
			self.Image_tbg = SoraDGetChildByName(self.nodeHead, "Image_tbg")
			self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
			self.txtTime:setTimeEndListener(function()
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT"
				SoraDSendMessage(nil)
			end)
		end
		self.imgHeadPage:loadTexture(SoraDCheckPNG(self.giftData.giftStyle.popBanner, gDefaultPNG.RECHARGE_PAGEBG), ccui.TextureResType.plistType)
		local smallH = display.height < 960 and 250 or 300
		local suitH = math.min(400, math.max(smallH, display.height - 736))
		self.imgHeadPage:setContentSize(cc.size(640, suitH))
		self.Node_bottom:setPositionY(400 - suitH)
		self.eventHeadHeight = suitH
		return true
	else
		self.eventHeadHeight = 400
		if self.txtLimit then
			self.txtLimit:setVisible(true)
			self.Node_gold:setPositionY(0)
		end
		return false
	end
end
function RechargeViewPageNode:initPublicView(giftID)
	if not self:bindOcx() then
		return false
	end
	local showPrice, isGetPrice = paymentManager.judgePrice(giftID, self.giftData.price)
	self.nowPrice = showPrice
	self.txtNowPrice:setString(showPrice)
	local discount = tonumber(self.giftData.price) > 0 and tonumber(self.giftData.originalPrice) / tonumber(self.giftData.price) or 99.99
	local oriShowPrice = paymentManager.calculateDiscount(giftID, showPrice, discount, self.giftData.originalPrice)
	self.oriPrice = oriShowPrice
	self.txtOriPrice:setString(oriShowPrice)
	if self.giftData.gold and 0 < tonumber(self.giftData.gold) then
		self.Node_gold:setVisible(true)
		self.txtLimit:setPositionY(-380)
	else
		self.Node_gold:setVisible(false)
		self.txtLimit:setPositionY(-362)
	end
	self:styleChangeDes(self.giftData.discount)
	self.txtGold:setString(string.formatnumberthousands(self.giftData.gold))
	if self.giftData.giftStyle.hideTime and self.giftData.giftStyle.hideTime == 1 then
		self.spTime:setVisible(false)
		self.Image_tbg:setVisible(false)
		self.txtTime:setVisible(false)
		self.Node_time:setVisible(false)
	else
		self.spTime:setVisible(true)
		self.Image_tbg:setVisible(true)
		self.txtTime:setVisible(true)
		self.Node_time:setVisible(true)
	end
	if self.giftData.giftStyle.activeExplain ~= "" then
		if type(self.giftData.giftStyle.activeExplain) == "string" then
			self.txtGiftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
			if not IsArClient and SoraDGetDefaultLanguage() ~= "en" and (giftID == 13835 or giftID == 13836) then
				self.txtGiftTip:setString("")
			end
		elseif type(self.giftData.giftStyle.activeExplain) == "table" then
			if next(self.giftData.giftStyle.activeExplain) then
				self.txtGiftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
			else
				self.txtGiftTip:setString("")
			end
		end
	else
		self.txtGiftTip:setString("")
	end
	local isMoreBuyTimes = (self.giftData.payType == gRechargeActivityBuyType.LIMIT or self.giftData.payType == gRechargeActivityBuyType.LIMIT_DAILY) and tonumber(self.giftData.extraData) or 1
	if not self.giftData.payType and self.giftData.luckyGiftID then
		self.giftData.already_buy = self.giftData.already_buy or 0
		isMoreBuyTimes = self.giftData.buy_limit - self.giftData.already_buy
	end
	_ENV = i18n(self.giftData.giftStyle.activeExplain)
	i18n(self.giftData.giftStyle.activeExplain).num = isMoreBuyTimes
	self.txtLimit:setString(i18n("common_text_2516", i18n(self.giftData.giftStyle.activeExplain)))
	if self.txtLimit then
		self.txtLimit:setVisible(true)
		self.Node_gold:setPositionY(0)
	end
	if gRechargeActiveModelType.NORMAL == self.giftType and self.giftData.payType == gRechargeActivityBuyType.NORMAL then
		self.txtLimit:setVisible(false)
		self.Node_gold:setPositionY(-16)
	end
	if tonumber(self.giftData.price) <= 0 then
		self.nodeCharge:setVisible(false)
		self.btnBuy:setTitleText(i18n("common_text_1261"))
	else
		self.nodeCharge:setVisible(true)
		self.btnBuy:setTitleText("")
	end
	return true
end
function RechargeViewPageNode:initScroll(giftData, id)
	giftData = giftData or self.giftData.gift
	local fixData = rechargePresentUtil.fixRechargePresentData(id, giftData, self.giftData.highlight)
	giftData = fixData.gift
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #giftData * 65 + 40)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self:setDownArrow()
	for i, v in ipairs(giftData) do
		local item = table.remove(self.itemOcxsRecycleList)
		if item == nil then
			item = self.imgItem:clone()
			item:addTo(self.scroll)
		end
		item:setVisible(true)
		if v.type == nil or v.type == "item" then
			item:getChildByName("Image_itemBuff"):setVisible(true)
			item:getChildByName("Image_itemBuff"):loadTexture(publicRead.getBg(v.id), ccui.TextureResType.plistType)
			if tonumber(v.id) >= 40000091 and tonumber(v.id) <= 40003102 then
				item.equipQuality = equipDesRead.getEquipQuality(tonumber(v.id))
				v.id = equipDesRead.getEquipQualityCfgID(tonumber(v.id))
			end
			item:getChildByName("Image_itemIcon"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
			item:getChildByName("Text_itemName"):setString(publicRead.getName(v.id))
			if publicRead.checkLevelCondition(v.id) then
				item:getChildByName("Text_itemName"):setColor(display.COLOR_RED)
			else
				item:getChildByName("Text_itemName"):setColor(cc.c3b(204, 189, 147))
			end
			item:getChildByName("Text_itemCount"):setVisible(true)
			if v.num then
				item:getChildByName("Text_itemCount"):setString("x" .. v.num)
			else
				item:getChildByName("Text_itemCount"):setString("x" .. v.count)
			end
			item:addTouchEventListener(handler(self, self.itemClick))
			item:setTag(tonumber(v.id))
		elseif v.type == "buff" then
			item:getChildByName("Image_itemBuff"):setVisible(false)
			print("v.icon === ", v.icon)
			item:getChildByName("Image_itemIcon"):loadTexture(v.buff.icon, ccui.TextureResType.plistType)
			item:getChildByName("Text_itemName"):setString(v.buff.name)
			item:getChildByName("Text_itemCount"):setVisible(false)
			item:addTouchEventListener(handler(self, self.buffClick))
			item:setTag(v.index)
			fixData.highlight[1] = "1"
		end
		item:getChildByName("Image_itemSheer"):setVisible(i % 2 == 1)
		item:getChildByName("Node_effect"):setVisible(false)
		item:setTouchEnabled(true)
		item:setSwallowTouches(false)
		item:setPosition(sSize.width / 2, sH - 20 - (i - 1) * 65)
		table.insert(self.itemOcxsList, item)
	end
	if type(fixData.highlight) == "table" and tonumber(fixData.highlight[1]) ~= 0 then
		self:highLightItems(fixData.highlight)
	end
	if self.giftData.leftTime and 0 < self.giftData.leftTime then
		if self.giftData.activityType == gRechargeActivityType.THIRD_RECHARGE and self.giftData.leftTime > serviceFunctions.getMothRemainTime() then
			self.txtTime:beginTime(serviceFunctions.getMothRemainTime())
		else
			self.txtTime:beginTime(self.giftData.leftTime)
		end
		self.Node_time:setVisible(true)
	else
		self.Node_time:setVisible(false)
	end
end
function RechargeViewPageNode:initRechargePresentPage(...)
	if not self:bindOcx() then
		return false
	end
	if self.giftData.gold and tonumber(self.giftData.gold) > 0 then
		self.Node_gold:setVisible(true)
		self.txtLimit:setPositionY(-380)
	else
		self.Node_gold:setVisible(false)
		self.txtLimit:setPositionY(-362)
	end
	self.nodeDiscount:setVisible(false)
	self.nodeStyle:setVisible(false)
	self.txtGold:setString(string.formatnumberthousands(self.giftData.gold))
	if self.giftData.giftStyle.hideTime and self.giftData.giftStyle.hideTime == 1 then
		self.spTime:setVisible(false)
		self.Image_tbg:setVisible(false)
		self.txtTime:setVisible(false)
		self.Node_time:setVisible(false)
	else
		self.spTime:setVisible(true)
		self.Image_tbg:setVisible(true)
		self.txtTime:setVisible(true)
		self.Node_time:setVisible(true)
	end
	if self.giftData.giftStyle.activeExplain ~= "" then
		if type(self.giftData.giftStyle.activeExplain) == "string" then
			self.txtGiftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
		elseif type(self.giftData.giftStyle.activeExplain) == "table" then
			if next(self.giftData.giftStyle.activeExplain) then
				self.txtGiftTip:setString(i18n(self.giftData.giftStyle.activeExplain))
			else
				self.txtGiftTip:setString("")
			end
		end
	else
		self.txtGiftTip:setString("")
	end
	local isMoreBuyTimes = (self.giftData.payType == gRechargeActivityBuyType.LIMIT or self.giftData.payType == gRechargeActivityBuyType.LIMIT_DAILY) and tonumber(self.giftData.extraData) or 1
	if not self.giftData.payType and self.giftData.luckyGiftID then
		self.giftData.already_buy = self.giftData.already_buy or 0
		isMoreBuyTimes = self.giftData.buy_limit - self.giftData.already_buy
	end
	_ENV = i18n(self.giftData.giftStyle.activeExplain)
	i18n(self.giftData.giftStyle.activeExplain).num = isMoreBuyTimes
	self.txtLimit:setString(i18n("common_text_2516", i18n(self.giftData.giftStyle.activeExplain)))
	if self.txtLimit then
		self.txtLimit:setVisible(true)
		self.Node_gold:setPositionY(0)
	end
	if gRechargeActiveModelType.NORMAL == self.giftType and self.giftData.payType == gRechargeActivityBuyType.NORMAL then
		self.txtLimit:setVisible(false)
		self.Node_gold:setPositionY(-16)
	end
	self:initScroll(SoraDIntArr2FormatTable(self.giftData.gift))
	return true
end
function RechargeViewPageNode:initNormalPage(...)
	local id = self.giftData.ID
	self.buffDatas, rechargeRead = nil, nil
	if self:initPublicView(id) then
		local rechargeRead, gift = self:initPublicView(id), self:initPublicView(id)
		local buffCfg = rechargeRead.getRechargeBuffCfg(tonumber(id))
		if buffCfg then
			rechargeRead = tonumber(id)
			rechargeRead, tonumber(id).type = tonumber(id)
			tonumber(id).icon = buffCfg.buffIcon
			tonumber(id).name = i18n(buffCfg.buffName)
			tonumber(id).buff, tonumber(id).desc = tonumber(id)
			local tonumber(id).index, buffData = 1, tonumber(id)
			table.insert(gift, buffData)
			table.insert(self.buffDatas, buffData)
		end
		local item = SoraDArrary2Table(self.giftData.gift)
		for k, v in ipairs(item) do
			rechargeRead = tonumber(id)
			tonumber(id).type = "item"
			tonumber(id).id = v.id
			tonumber(id).num = v.num
			table.insert(gift, tonumber(id))
		end
		self:initScroll(gift, id)
	end
end
function RechargeViewPageNode:initNewPrinceGiftPage(...)
	local id = self.giftData.ID
	self.buffDatas, _ENV = nil, nil
	if self:initPublicView(id) then
		local _ENV, gift = self:initPublicView(id), self:initPublicView(id)
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
		table.insert(self.buffDatas, buffData)
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
end
function RechargeViewPageNode:initLuckyPage(...)
	local gametop = gModuleMgr.getObject("gametop")
	local luckyGiftCtrl = gametop.playertop_:getModule("luckyGiftCtrl")
	luckyGiftCtrl:clickGift(self.giftData.luckyGiftID)
	_ENV = luckyGiftCtrl
	luckyGiftCtrl.msg = "MESSAGE_CLIENT_RECHARGECENTER_LUCKYGIFTPOINTREFRESH"
	SoraDSendMessage(luckyGiftCtrl)
	local id = self.giftData.luckyGiftID
	if self:initPublicView(id) then
		self:initScroll(self.giftData.gift, id)
	end
end
function RechargeViewPageNode:styleChangeDes(discount)
	if gRechargeDiscountStyle.NUMBER == tonumber(discount[1]) then
		self.nodeDiscount:setVisible(true)
		self.nodeStyle:setVisible(false)
		_ENV = nil
		;(nil).num = math.floor(discount[2])
		;(nil).char = "%"
		self.txtDiscount:setString(i18n("common_text_1470", nil))
	elseif gRechargeDiscountStyle.IMAGE == tonumber(discount[1]) then
		self.nodeDiscount:setVisible(false)
		self.nodeStyle:setVisible(true)
		local img = rechargeRead.getPromoIcon(discount[2]).icon
		local imgOcx = self.nodeStyle:getChildByName("nodeStyleImg")
		if imgOcx then
			imgOcx:setURL(img)
		else
			imgOcx = display.newSprite("#" .. img)
			imgOcx:setName("nodeStyleImg")
			imgOcx:addTo(self.nodeStyle)
		end
	end
end
function RechargeViewPageNode:setFatherPanel(panel)
	self.fPanel = panel
end
function RechargeViewPageNode:setDownArrow(...)
	local judge2move = function(_sprite, _forward)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveBy(0.5, 0, _forward * 5)
		;(nil)[2] = cca.moveBy(0.5, 0, -_forward * 5)
		;(nil)[3] = cca.moveBy(0.5, 0, -_forward * 5)
		;(nil)[4] = cca.moveBy(0.5, 0, -_forward * 5)
		;(nil)[5] = cca.moveBy(0.5, 0, -_forward * 5)
		local seqList = cca.seq(nil)
		local acList = cc.RepeatForever:create(seqList)
		_sprite:runAction(acList)
	end
	local sSize = self.scroll:getContentSize()
	local innerContentView = self.scroll:getInnerContainer()
	local iSize = innerContentView:getContentSize()
	if iSize.height > sSize.height then
		self.spDownArrow:setVisible(true)
		self.spDownArrow:setPosition(self.imgItemPanel:getPositionX() + sSize.width / 2 - 5, self.imgItemPanel:getPositionY() - self.imgItemPanel:getContentSize().height + 15)
		if not self.initScrollArrow then
			judge2move(self.spDownArrow, 1)
			self.scroll:addEventListener(function(target, event)
				if event == ccui.ScrollviewEventType.bounceBottom then
					self.spDownArrow:setVisible(false)
				end
			end)
			self.initScrollArrow = true
		end
	else
		self.spDownArrow:setVisible(false)
	end
end
function RechargeViewPageNode:popDesView()
	if self.imgHeadPage then
		self.imgHeadPage:setTouchEnabled(true)
		self.imgHeadPage:setSwallowTouches(false)
		self.imgHeadPage:addTouchEventListener(function(image, eventType)
			if eventType == ccui.TouchEventType.ended then
				if not SoraDIsNodeVisibleOnScroll(image, self.fPanel) then
					print("node is not on view")
					return
				end
				if self.singleIsMoved then
					self.singleIsMoved = false
					return
				end
				self:popDesRechargeView()
			elseif eventType == ccui.TouchEventType.moved then
				local touchBeganPoint = image:getTouchBeganPosition()
				local touchmovePoint = image:getTouchMovePosition()
				local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
				if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
					self.singleIsMoved = true
				end
			elseif eventType == ccui.TouchEventType.canceled then
				self.singleIsMoved = false
			end
		end)
	end
end
function RechargeViewPageNode:setContentHeight(heigh, isLadder, isGroup)
	print("heigh = ", heigh)
	self.pageMaxHeigh = heigh
	local pSize = self.imgItemPanel:getContentSize()
	local smallH = display.height < 960 and 250 or 300
	self.eventHeadHeight = math.min(400, math.max(smallH, display.height - 736))
	self.Top_Node_clound:setPositionY(-self.eventHeadHeight - 27)
	self.imgItemPanel:setPositionY(-self.eventHeadHeight - 50)
	if isLadder then
		self.Bottom_Node:setPositionY(-self.pageMaxHeigh + 240)
		self.imgItemPanel:setContentSize(cc.size(pSize.width, display.height - self.eventHeadHeight - 518))
		self.scroll:setContentSize(cc.size(pSize.width, self.imgItemPanel:getContentSize().height - 2))
		self.scroll:setPositionY(self.imgItemPanel:getPositionY())
	else
		self.Bottom_Node:setPositionY(-self.pageMaxHeigh + 215)
		self.imgItemPanel:setContentSize(cc.size(pSize.width, display.height - self.eventHeadHeight - (isGroup and 518 or 468)))
		self.scroll:setContentSize(cc.size(pSize.width, self.imgItemPanel:getContentSize().height - 2))
		self.scroll:setPositionY(self.imgItemPanel:getPositionY())
	end
	self.ccs_car:setPositionY(self.btnBuy:getPositionY() - 5)
	self:setDownArrow()
end
function RechargeViewPageNode:highLightItems_imp(num)
	local item = self.itemOcxsList[num]
	if item then
		local Node_effect = SoraDGetChildByName(item, "Node_effect")
		local etNode = SoraDGetChildByName(Node_effect, "etNode")
		if not etNode then
			etNode = SoraDCreatAnimation("animationCZS")
			etNode:setName("etNode")
			etNode:addTo(Node_effect)
		end
		Node_effect:setVisible(true)
	end
end
function RechargeViewPageNode:highLightItems(highLight, offset)
	offset = offset or 0
	for i = 1, #highLight do
		self:highLightItems_imp(tonumber(highLight[i] + offset))
	end
end
function RechargeViewPageNode:itemClick(button, type)
	local resultType = backpackltCtrl:getResultType(button:getTag())
	if IsArClient and resultType == gItemEffectDef.KEY_OPEN or resultType == gItemEffectDef.SOLOMON_KEY then
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			local panel = SoraDCreatePanel("solomonKeyView")
			panel:initData(button:getTag())
			panel:show()
		end
	elseif type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:setVisible(false)
		end
	elseif type == ccui.TouchEventType.began then
		self:openItem(button, self:convertToNodeSpace(button:getTouchBeganPosition()))
	end
end
function RechargeViewPageNode:buffClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buffData = self.buffDatas[button:getTag()]
		local tmp = SoraDCreatePanel("princeGiftNewBuffPreviewPopView")
		tmp:initData(buffData.buff.desc)
		tmp:show()
	end
end
function RechargeViewPageNode:openItem(item, pos)
	if self.pFloor == nil then
		self.pFloor = SoraDCreatePanel("commonItemTips")
		self.pFloor:addTo(self, 100)
	end
	self.pFloor:initData(item:getTag(), item.equipQuality)
	local offsetEquipY = 0
	local offsetEquipX = 0
	local sType = serviceFunctions.getIDType(item:getTag())
	if sType == gIDType.EQUIPMENT then
		offsetEquipY = 250
		offsetEquipX = 20
	end
	if SoraDFIsRA() then
		if pos.x < -40 then
			self.pFloor:setPosition(pos.x + 280 + offsetEquipX, pos.y + offsetEquipY)
		else
			self.pFloor:setPosition(pos.x - offsetEquipX, pos.y + offsetEquipY)
		end
	elseif pos.x > 40 then
		self.pFloor:setPosition(pos.x - 280 - offsetEquipX, pos.y + offsetEquipY)
	else
		self.pFloor:setPosition(pos.x + offsetEquipX, pos.y + offsetEquipY)
	end
	self.pFloor:setVisible(true)
end
function RechargeViewPageNode:btnBuyClick(button, eventType)
	print(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rid = self.giftData.ID or self.giftData.rid
		if gRechargeActiveModelType.NORMAL == self.giftType or gRechargeActiveModelType.RUIRUILADDER == self.giftType or gRechargeActiveModelType.PETRA_GIFT == self.giftType or gRechargeActiveModelType.LINGLANG_GIFT == self.giftType then
			if self.giftData.activityType == gRechargeActivityType.THIRD_RECHARGE and tonumber(self.giftData.extraData) < 1 then
				SoraDShowMsgTip(i18n("common_text_4629"))
				return
			end
			if self.isLadder then
				SoraDShowMsgTip(i18n("common_text_2848"))
			else
				paymentManager.normalGiftBuyClassify(rid)
				paymentManager.OnemtReadyBuy(rid, self.fromCenter, self.isPageTurn)
			end
		elseif gRechargeActiveModelType.LUCKYGIFT == self.giftType then
			if self.giftData.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
				if self.isLadder then
					SoraDShowMsgTip(i18n("common_text_2848"))
				else
					paymentManager.normalGiftBuyClassify(self.giftData.luckyGiftID)
					paymentManager.OnemtReadyBuy(self.giftData.luckyGiftID, self.fromCenter, self.isPageTurn, nil, self.giftData.push_id)
				end
			else
				paymentManager.normalGiftBuyClassify(self.giftData.luckyGiftID)
				paymentManager.OnemtReadyBuy(self.giftData.luckyGiftID, self.fromCenter, self.isPageTurn, nil, self.giftData.push_id)
			end
		elseif gRechargeActiveModelType.NEW_PRINCE_GIFT == self.giftType then
			local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
			princeGiftNewCtrl:reqBuyPackage(rid)
		end
	end
end
function RechargeViewPageNode:clickPriceTab(tag)
	self.lastRid = self.groupData[tonumber(tag)].rid
	self:initData(self.groupData[tonumber(tag)], self.fromCenter, self.isPageTurn)
end
function RechargeViewPageNode:popDesRechargeView(isFrame)
	SoraDPlaySound()
	if isFrame then
		local listBox = SoraDCreatePanel("rechargePopFrame")
		listBox:initData(self.giftRid, gRechargeActiveFromEnum.ROAD03)
		listBox:show()
	else
		local listBox = SoraDCreatePanel("rechargePopView")
		listBox:initData(self.giftRid, gRechargeActiveFromEnum.ROAD03)
		listBox:show()
	end
end
function RechargeViewPageNode:updateOutAppPurchase()
	if SoraDCheckOAPIsOpen(self.giftRid) and self.giftData.activityType ~= gRechargeActivityType.THIRD_RECHARGE then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.Bottom_Node)
			self.outAppPurchaseButtons:setPosition(cc.p(0, -50))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnBuy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftRid
		;(false).nowPrice = self.nowPrice
		_ENV, (false).oriPrice = self.oriPrice, self.oriPrice
		self.oriPrice.fromCenter = self.fromCenter
		self.oriPrice.isPageTurn = self.isPageTurn
		;(false).logInfo, self.oriPrice.pushID = self.oriPrice, self.giftData.push_id
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
		self.ccs_car:setPosition(cc.p(273, -45))
		self.ccs_car:setButtomStyle()
	else
		if self.outAppPurchaseButtons then
			self.outAppPurchaseButtons:setVisible(false)
		end
		self.btnBuy:setVisible(true)
	end
end
return RechargeViewPageNode
