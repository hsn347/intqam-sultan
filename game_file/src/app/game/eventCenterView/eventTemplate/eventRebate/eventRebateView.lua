local gametop = gModuleMgr.getObject("gametop")
local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
local LevelUpInfoList = require("app." .. LocalTblPath .. ".config_server.grownup_found_config")
local eventRebateView = class("eventRebateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventRebateView")
	end
	return target
end)
function eventRebateView:ctor()
	SoraDCreatAnimation("eventRebateView", self._ccsView, true)
	self.redPointList, _ENV, self.itemList, _ENV, self.isAddToPopManager = SoraDCreatAnimation, SoraDCreatAnimation, SoraDCreatAnimation, SoraDCreatAnimation, true
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("activity_name_26"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("eventRebateSingle")
	self.Text_tips = SoraDGetChildByName(self, "Text_tips")
	self.Text_tips:setString(i18n("Gather_text_16"))
	self.Text_total = SoraDGetChildByName(self, "Text_total")
	self.Text_total:setString(i18n("Gather_text_15"))
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.Text_nowPrice = SoraDGetChildByName(self, "Text_nowPrice")
	self.Node_gold = SoraDGetChildByName(self, "Node_gold")
	self.Sprte_goldNum = SoraDGetChildByName(self.Node_gold, "Sprte_goldNum")
	local textWidth = self.Text_total:getContentSize().width
	if 100 < textWidth then
		textWidth = 100
		SoraDSetTextWidthHeight(self.Text_total, cc.size(textWidth, 40))
	end
	self.Node_gold:setPositionX(SoraDFSign(110))
	self.selectTimes, _ENV, self.selectBtn, _ENV, self.selectTab, _ENV, self.Image_select = SoraDGetChildByName(self, "Image_select"), SoraDGetChildByName(self, "Image_select"), SoraDGetChildByName(self, "Image_select"), SoraDGetChildByName(self, "Image_select"), SoraDGetChildByName(self, "Image_select"), SoraDGetChildByName(self, "Image_select"), SoraDGetChildByName(self, "Image_select")
	self:initItemList()
	self.selectTag = self:getNewTag()
	for i = 1, 3 do
		self.selectTab[i] = SoraDGetChildByName(self, "Node_times_" .. i)
		self.selectBtn[i] = SoraDGetChildByName(self.selectTab[i], "Button_touch")
		self.selectBtn[i]:setTag(i)
		self.redPointList[i] = SoraDGetChildByName(self.selectTab[i], "Sprite_redPoint")
		self.selectBtn[i] = include("commonBtnInstance").new(self.selectBtn[i])
		self.selectBtn[i]:setHandle(handler(self, self.btnTabClick))
		self.selectTimes[i] = SoraDGetChildByName(self.selectTab[i], "Sprite_times")
	end
	self:updateTab()
	self:refreshRedPoint()
end
function eventRebateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_VALUE_REBATE_BUY_REFRESH", function(...)
		self:initData()
		self:refreshRedPoint()
	end)
	SoraDAddMessage(self, "MESSAGE_VALUE_REBATE_RECEIVE_REFRESH", function(...)
		self.infoList = self:getLevelUpInfoList()
		self:refreshScroll()
		self:refreshRedPoint()
		self:judgeClose()
	end)
end
function eventRebateView:judgeClose()
	if not ladderGiftCtrl:getGrowUpHasEnter() then
		self:removeFromParent()
	end
end
function eventRebateView:getNewTag()
	local tag = self.selectTag
	local _ENV, tmpData
	for k, v in ipairs(self.itemList) do
		local isBought = ladderGiftCtrl:getGrowUpBuyRecord(v) and true or false
		local isCanReceive = ladderGiftCtrl:getReceiveNumByID(v) > 0
		local packageInfo = self:getPackageInfo(v)
		_ENV = self
		self.rid = v
		self.fontType = k
		self.isBought = isBought
		self.isCanReceive = isCanReceive
		tmpData[k], self.price = self, packageInfo.price
	end
	table.sort(tmpData, function(a, b)
		if a.isBought and b.isBought then
			if a.isCanReceive and b.isCanReceive then
				return a.price > b.price
			elseif a.isCanReceive and not b.isCanReceive then
				return true
			elseif not a.isCanReceive and b.isCanReceive then
				return false
			else
				return a.price > b.price
			end
		elseif a.isBought and not b.isBought then
			return true
		elseif not a.isBought and b.isBought then
			return false
		else
			return a.price > b.price
		end
	end)
	tag = tmpData[1].fontType
	return tag
end
function eventRebateView:initItemList()
	for k, v in ipairs(LevelUpInfoList) do
		if v.type == 2 and v.fontType > 0 and not self.itemList[v.fontType] then
			self.itemList[v.fontType] = v.rid
		end
	end
end
function eventRebateView:updateTab()
	self.Image_select:setPositionX(self.selectTab[self.selectTag]:getPositionX())
	self:initData()
end
function eventRebateView:getPackageInfo(rid)
	local packageID = rid or self.itemList[self.selectTag]
	self.packageList = ladderGiftCtrl:getGrowUpLadderGiftList()
	for k, v in ipairs(self.packageList) do
		if tonumber(v.ID) == packageID then
			return v
		end
	end
end
function eventRebateView:getTagByPackageID(packageID)
	for k, v in ipairs(self.itemList) do
		if tonumber(v) == tonumber(packageID) then
			return k
		end
	end
end
function eventRebateView:initData()
	local showPackage = self:getPackageInfo() or self.packageList[1]
	self.packageID = showPackage.ID
	self.packagePrice = showPackage.price
	self.packagePrice = paymentManager.judgePrice(self.packageID, self.packagePrice)
	self.infoList = self:getLevelUpInfoList()
	self.hasBuy = ladderGiftCtrl:getGrowUpBuyRecord(self.packageID)
	if self.hasBuy then
		self.Text_nowPrice:setString(i18n("common_text_3833"))
		self.Button_buy:setTouchEnabled(false)
	else
		self.Text_nowPrice:setString(self.packagePrice)
		self.Button_buy:setBright(true)
		self.Button_buy:setTouchEnabled(true)
	end
	for i = 1, 3 do
		local pngGoldName = SoraDFIsRA() and string.format("font_9001153_gold_ar_%.2d.png", 4 - i) or string.format("font_9001153_gold_en_%.2d.png", 4 - i)
		local pngGrayName = SoraDFIsRA() and string.format("font_9001153_gray_ar_%.2d.png", 4 - i) or string.format("font_9001153_gray_en_%.2d.png", 4 - i)
		self.selectTimes[i]:setSpriteFrame(self.selectTag == i and pngGoldName or pngGrayName)
	end
	self:initTotalGold()
	self:refreshScroll()
	self:updateOutAppPurchase(not self.hasBuy)
end
function eventRebateView:refreshScroll()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).hasBuy = self.hasBuy
	;(nil).packageID = self.packageID
	self.scroll:updateScrollView(cc.size(640, 168), self.infoList, 1, nil)
end
function eventRebateView:refreshRedPoint()
	local ret, retNum = ladderGiftCtrl:getReceiveStatusAndNum()
	local boughtGift = ladderGiftCtrl:getBoughtGift()
	for k, v in ipairs(self.redPointList) do
		local rNum = boughtGift[tonumber(self.itemList[k])] or 0
		if 0 < rNum then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
end
function eventRebateView:initTotalGold()
	local total_gold = 0
	if not self.infoList then
		_ENV = self.infoList
	end
	for k, v in pairs(self.infoList) do
		if v.reward and v.reward[1] == 1001 then
			total_gold = total_gold + v.reward[2]
		end
	end
	self.Sprte_goldNum:setString(string.formatnumberthousands(total_gold))
end
function eventRebateView:btnBuyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(tonumber(self.packageID))
	end
end
function eventRebateView:btnTabClick(button)
	local tag = button:getTag()
	self.selectTag = tag
	self:updateTab()
	self.scroll:jumpToTop()
end
function eventRebateView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("grownup_text_02"))
	end
end
function eventRebateView:getLevelUpInfoList()
	local _ENV, tbl
	for i, v in ipairs(LevelUpInfoList) do
		if v.type == 2 and self.selectTag == v.fontType then
			local _ENV, temp = self.selectTag, self.selectTag
			for k, w in pairs(v) do
				temp[k] = w
			end
			if ladderGiftCtrl:getGrowUpReceive(self.packageID, v.castleLevel) then
				temp.hasReceive = true
			else
				temp.hasReceive = false
			end
			table.insert(tbl, temp)
		end
	end
	table.sort(tbl, function(a, b)
		if a.hasReceive ~= b.hasReceive then
			return b.hasReceive
		else
			return a.castleLevel < b.castleLevel
		end
	end)
	return tbl
end
function eventRebateView:updateOutAppPurchase(isShow)
	if isShow and SoraDCheckOAPIsOpen(self.packageID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new("outAppPurchaseButtonsSmall")
			self.outAppPurchaseButtons:addTo(SoraDGetChildByName(self, "Node_content"))
			self.outAppPurchaseButtons:setPosition(cc.p(SoraDFPosX(-150, 0), 40))
		end
		self.outAppPurchaseButtons:setVisible(true)
		SoraDGetChildByName(self, "Node_buy"):setVisible(false)
		_ENV = false
		;(false).rid = self.packageID
		;(false).nowPrice = self.packagePrice
		;(false).handlePurchaseBack = handler(self, self.purchaseBack)
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.outAppPurchaseButtons:initData(false)
	else
		if self.outAppPurchaseButtons then
			self.outAppPurchaseButtons:setVisible(false)
		end
		SoraDGetChildByName(self, "Node_buy"):setVisible(true)
	end
end
function eventRebateView:purchaseBack()
	self:initData()
	self:refreshRedPoint()
end
return eventRebateView
