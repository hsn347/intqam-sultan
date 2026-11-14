local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local treasureCourtCtrl = SoraDGetCtrl("treasureCourtCtrl")
local itemDesRead = include("itemDesRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local treasureCourtView = class("treasureCourtView", function(target)
	return target or SoraDCreateBasePanel("treasureCourtView")
end)
function treasureCourtView:ctor()
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.boxTbl, _ENV = SoraDGetChildByName(self, "Image_bg").setFillType, SoraDGetChildByName(self, "Image_bg").setFillType
	self.activityID = gActivityTimeActivityID.JADE_STONE_MALL_ACTIVITY
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.ccs_title:setTitle(i18n("activity_name_9001241"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.btnLogMore = SoraDGetChildByName(self, "Button_log_more")
	self.btnVulnera = SoraDGetChildByName(self, "Button_Vulnerary")
	self.btnWarDrum = SoraDGetChildByName(self, "Button_WarDrum")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.nodeDisCount = SoraDGetChildByName(self, "Node_Discount")
	self.node_gold = SoraDGetChildByName(self, "Node_Top_Gold")
	self.btnToRecharge = SoraDGetChildByName(self.node_gold, "Button_gold")
	self.textStone = SoraDGetChildByName(self.node_gold, "Text_gold")
	self.stoneIcon = SoraDGetChildByName(self.node_gold, "Image_gold")
	self.bgEffect = SoraDGetChildByName(self, "Effect_Node")
	self.bgEffect = SoraDCreatAnimation("treasureCourtEffect", self.bgEffect, true)
	self.upEffect = SoraDGetChildByName(self, "Top_Effect")
	self.upEffect = SoraDCreatAnimation("treasureCourtEffectUp", self.upEffect, true)
	self.Text_RedTip = SoraDGetChildByName(self, "Text_RedTip")
	self.Text_RedTip:setString(i18n("court_text_03"))
	self.checkBox = SoraDGetChildByName(self, "CheckBox_RedTip")
	_ENV = i18n("court_text_03")
	i18n("court_text_03").byUID = true
	self.checkBox:setSelected(SoraDConfigGet("Game:treasureCourtView:redShow~bool", i18n("court_text_03")))
	self.checkBox:addEventListener(handler(self, self.btnCheckClick))
	self:initData()
end
function treasureCourtView:initData()
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.activityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.btnHelp:addTouchEventListener(handler(self, self.btnClickHelp))
	self.btnToRecharge:addTouchEventListener(handler(self, self.btnClickJump))
	self.nodeDisCount:setTag(SoraDFIsRA() and 2 or 1)
	self:updataData()
end
function treasureCourtView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_TREASURECOURT_REFRESH", handler(self, self.updataData))
end
function treasureCourtView:updataData(target, data)
	self.stoneNum = treasureCourtCtrl:getStoneNum()
	self.textStone:setString(string.formatnumberthousands(self.stoneNum))
	self:refreshSingle(self.nodeDisCount, shopltCtrl:getTreasureCourtSuper(), true)
	local tmp = clone(shopltCtrl:getTreasureCourtNormalList())
	local nums = table.nums(tmp)
	if nums % 2 ~= 0 then
		treasureCourtCtrl = shopltCtrl:getTreasureCourtNormalList()
		table.insert(tmp, shopltCtrl:getTreasureCourtNormalList())
	end
	self.scroll:setIsRight(SoraDFIsRA())
	self.scroll:recyclingAll()
	treasureCourtCtrl = SoraDFIsRA()
	SoraDFIsRA().scroll = self.scroll
	SoraDFIsRA().view = self
	self.scroll:updateScrollView(cc.size(320, 168), tmp, 2, SoraDFIsRA())
end
function treasureCourtView:createSingle()
	local single = self.singleNode:clone()
	return single
end
function treasureCourtView:refreshSingle(parent, data, notInscroll)
	local nodeInfo = SoraDGetChildByName(parent, "Node_Info")
	local imageLine = SoraDGetChildByName(parent, "Image_tile_line")
	local panelBlack = SoraDGetChildByName(parent, "Panel_Black")
	local bgBlack = SoraDGetChildByName(parent, "bg_Black")
	local item = SoraDGetExtendChildFromCCSByName(nodeInfo, "CCS_commonItemAward")
	local itemName = SoraDGetChildByName(nodeInfo, "Text_Name")
	local btnGold = SoraDGetChildByName(nodeInfo, "Button_buy")
	local labelNowPrice = SoraDGetChildByName(btnGold, "Text_nowPrice")
	local labelOriPrice = SoraDGetChildByName(btnGold, "Text_oriPrice")
	local discout = SoraDGetChildByName(nodeInfo, "bmfont")
	local textLimit = SoraDGetChildByName(nodeInfo, "Text_Limit")
	textLimit = SoraDChangeTextToHtml(textLimit)
	local index = parent:getTag()
	if index % 2 ~= 0 and SoraDFIsRA() or index % 2 == 0 and not SoraDFIsRA() and imageLine then
		imageLine:setFlippedX(true)
		imageLine:setPositionX(154)
		panelBlack:setPositionX(0)
		bgBlack:setFlippedX(false)
		bgBlack:setPositionX(320)
	elseif imageLine then
		imageLine:setFlippedX(false)
		imageLine:setPositionX(166)
		panelBlack:setPositionX(0)
		bgBlack:setFlippedX(true)
		bgBlack:setPositionX(0)
	end
	if next(data) then
		nodeInfo:setVisible(true)
		item:setOwnView(self)
		if not notInscroll then
			item:setOwnScroll(self.scroll)
		end
		item:initData(data.itemID[1], tostring(data.itemID[2]))
		itemName:setString(itemDesRead.getName(data.itemID[1]))
		labelOriPrice:setString(string.formatnumberthousands(data.originalPrice))
		labelNowPrice:setString(string.formatnumberthousands(data.price))
		labelNowPrice:setColor(treasureCourtCtrl:isEnoughStone(data.price, true) and cc.c3b(255, 255, 0) or display.COLOR_RED)
		if discout then
			discout:setString(tostring(math.floor(data.originalPrice / data.price * 100)) .. "%")
		else
			local lang = SoraDGetDefaultLanguage()
			if lang ~= "ar" and lang ~= "en" and lang ~= "ko" then
				lang = "en"
			end
			SoraDGetChildByName(nodeInfo, "Image_Super"):loadTexture("frame_font_premium_" .. lang .. ".png", ccui.TextureResType.plistType)
		end
		local curMax = data.limitNum - treasureCourtCtrl:getShopItemHaveBuy(data.shopItemID)
		local color = 0 < curMax and "#FFFFFF" or "#BE2828"
		_ENV = math.floor(data.originalPrice / data.price * 100)
		math.floor(data.originalPrice / data.price * 100).member = curMax
		_ENV, _ENV, math.floor(data.originalPrice / data.price * 100).total = math.floor(data.originalPrice / data.price * 100)
		data.limitNum.member, math.floor(data.originalPrice / data.price * 100).color = math.floor(data.originalPrice / data.price * 100)
		textLimit:setString(i18n_html("common_text_155", math.floor(data.originalPrice / data.price * 100)))
		btnGold:setBright(0 < curMax)
		btnGold:addTouchEventListener(handlerEx(self, self.btnClickBuy, data))
		btnGold:setTag(data.shopItemID)
	else
		nodeInfo:setVisible(false)
	end
end
function treasureCourtView:btnClickBuy(info, button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseShopItemID = button:getTag()
		print("treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID)", info.shopItemID, treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID))
		if treasureCourtCtrl:isEnoughStone(info.price, true) then
			local maxNum = info.limitNum - treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID)
			_ENV, _ENV = treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID)
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).id = info.itemID[1]
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).originalPrice = info.originalPrice
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).price = info.price
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).cur = maxNum
			_ENV, treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).itemData, treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).max = treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID)
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).maxCount = math.min(math.floor(self.stoneNum / info.price), maxNum)
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).exchangeID = gIDDef.JADE_STONE
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).exchangeNum = self.stoneNum
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).curValue = 1
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).otherData, treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).itemCount = treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID)
			treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID).buyHandle = handler(self, self.sureBuy)
			uiManager:show("newShopSingleBuy", treasureCourtCtrl:getShopItemHaveBuy(info.shopItemID))
		else
			self:showLimitBox(info)
		end
	end
end
function treasureCourtView:showLimitBox(info)
	local panel = SoraDCreatePanel("commonLimitBox")
	panel:setImageTouchEnable()
	local _ENV, lockInfo = panel.setImageTouchEnable, panel.setImageTouchEnable
	_ENV = nil
	_ENV = nil
	;(nil).num = info.price
	;(nil).content = i18n("item_name_103", nil)
	;(nil).icon = "1601.png"
	;(nil).btnTitle = i18n("common_text_2002")
	;(nil).btnFun = function(target)
		self:jumpToGift()
		target:close(target, ccui.TouchEventType.ended)
	end
	;(nil).isReach = false
	table.insert(lockInfo, nil)
	if panel:judgeData(lockInfo) then
		panel:initData(lockInfo)
		panel:setTitle(i18n("common_text_1976"))
		panel:show()
	end
end
function treasureCourtView:jumpToGift()
	local giftData = self:getGiftInfo()
	if giftData then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeID = tonumber(giftData.ID)
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
			panel:show()
		end
	else
		SoraDShowMsgTip(i18n("HeroVault_text_03"))
	end
end
function treasureCourtView:getGiftInfo()
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	_UPVALUE3_ = nil
	;(nil)[1] = 13696
	;(nil)[2] = 13695
	;(nil)[3] = 13694
	for _, v in ipairs(nil) do
		local item = giftInfo[tostring(v)]
		if item and tonumber(item.extraData) >= 1 then
			return item
		end
	end
end
function treasureCourtView:btnClickJump(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:jumpToGift()
	end
end
function treasureCourtView:sureBuy(count)
	treasureCourtCtrl = nil
	;(nil).shopID = self.chooseShopItemID
	;(nil).count = count
	treasureCourtCtrl:reqJadeStoneBuy(nil)
end
function treasureCourtView:btnClickHelp(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("court_text_01"))
	end
end
function treasureCourtView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function treasureCourtView:btnCheckClick(button, type)
	SoraDPlaySound()
	if type == ccui.CheckBoxEventType.selected then
		SoraDShowMsgTip(i18n("court_text_05"))
		_ENV = i18n("court_text_05")
		i18n("court_text_05").byUID = true
		SoraDConfigSet("Game:treasureCourtView:redShow~bool", true, i18n("court_text_05"))
	elseif type == ccui.CheckBoxEventType.unselected then
		SoraDShowMsgTip(i18n("court_text_04"))
		_ENV = i18n("court_text_04")
		i18n("court_text_04").byUID = true
		SoraDConfigSet("Game:treasureCourtView:redShow~bool", false, i18n("court_text_04"))
	end
end
return treasureCourtView
