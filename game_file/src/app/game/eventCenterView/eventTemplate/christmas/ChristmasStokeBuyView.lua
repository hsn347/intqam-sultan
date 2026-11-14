local SID = require_data("stocking_info")
local SRD = require_data("stocking_reward", true)
local SFD = require_data("stocking_favorite", true)
local itemDesRead = include("itemDesRead")
local resDesRead = include("resDesRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = SoraDGetCtrl("backpackCtrl", gametop)
local christmasBattleCtrl = SoraDGetCtrl("christmasBattleCtrl", gametop)
local NO_LIMIT_EXCHANGE_NUM = 99999
local ChristmasStokeBuyView = class("ChristmasStokeBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("ChristmasStokeBuyView")
	end
	return target
end)
function ChristmasStokeBuyView:ctor()
	self:initView()
	self:initScroll()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_EXCHANGE_BACK", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ChristmasStokeBuyView:initView()
	local root = self._ccsView
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	_UPVALUE1_ = 1
	;(1)[1] = "Top_node"
	self.topNode = SoraDGetChildByFullPath(root, 1)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_christmas")
	self.title:setTitle(i18n("christmas_stocking_text_01"))
	self.nodeGold = SoraDGetExtendChildFromCCSByName(root, "CCS_commonGoldTop_gold")
	_UPVALUE1_ = "CCS_commonGoldTop_gold"
	;("CCS_commonGoldTop_gold")[1] = "resetTips"
	local resetTips = SoraDGetChildByFullPath(self.topNode, "CCS_commonGoldTop_gold")
	resetTips:setString(i18n("christmas_stocking_text_06"))
	SoraDSetTextWidthHeight(resetTips, cc.size(600, 60))
	resetTips:setFontSize(16)
	_UPVALUE1_ = 16
	;(16)[1] = "Top_Size_scroll"
	self.scroll = SoraDGetChildByFullPath(root, 16)
	_UPVALUE1_ = 16
	;(16)[1] = "single_item"
	self.tableItemList, _ENV, self.defaultItem = SoraDGetChildByFullPath(root, 16), SoraDGetChildByFullPath(root, 16), SoraDGetChildByFullPath(root, 16)
end
function ChristmasStokeBuyView:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollMinH = self.scroll:getContentSize().height
	local scrollW = scrollInner:getContentSize().width
	local stockingSize = #SID.data - 1
	dump(SID, "水煎豆腐")
	local scrollH = stockingSize * 230
	print("scrollSize", scrollW, scrollH, scrollH)
	local defaultItem = self.defaultItem
	local scrollH = math.max(scrollMinH, scrollH)
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
	for k = 1, stockingSize do
		local singleItem = self.tableItemList[i]
		if not singleItem then
			singleItem = defaultItem:clone()
			singleItem:addTo(self.scroll)
			singleItem:setTag(k)
			self.tableItemList[k] = singleItem
		end
		singleItem:setPosition(0, scrollH - k * 230)
		self:updateCell(singleItem, k, true)
	end
end
function ChristmasStokeBuyView:updateCell(node, index, isInit)
	local info = SID.data[index]
	local baseReward = SRD.data[index]
	local itemName = SoraDGetChildByName(node, "itemName")
	local descLabel = SoraDGetChildByName(node, "desc")
	local eventBtn = SoraDGetChildByName(node, "eventBtn")
	local iconNode = SoraDGetChildByName(node, "iconNode")
	local Sprite_gold = SoraDGetChildByName(eventBtn, "Sprite_gold")
	if isInit then
		eventBtn:getChildByName("btn_name"):setString(i18n("common_text_1889"))
		eventBtn:addTouchEventListener(handlerEx(self, self.clickBuyStokeBtn, index))
		iconNode = include("itemSingleView").new()
		iconNode:sendParentToButton(self)
		iconNode:addTo(node)
		iconNode:setPosition(cc.p(30, 210))
		iconNode:setScale(0.7)
		iconNode:setName("iconNode")
		local resId = baseReward.consume[1]
		if SoraDJudgeResOrItem(resId) then
			resIcon = itemDesRead.getIcon(resId)
		else
			resIcon = resDesRead.getIcon(resId)
		end
		Sprite_gold:setSpriteFrame(resIcon)
		Sprite_gold:setScale(60 / Sprite_gold:getContentSize().width)
	end
	descLabel:setString(i18n(info.describe))
	eventBtn:getChildByName("btn_gold"):setString(baseReward.consume[2])
	local num = self:getLimitBuyNum(index)
	if num == NO_LIMIT_EXCHANGE_NUM then
		itemName:setString(string.format("%s(%s%s)", i18n(info.name), i18n("christmas_stocking_text_07"), i18n("christmas_stocking_text_08")))
	else
		itemName:setString(string.format("%s(%s%s)", i18n(info.name), i18n("christmas_stocking_text_07"), num))
	end
	SID, SID = string.format("%s(%s%s)", i18n(info.name), i18n("christmas_stocking_text_07"), num)
	string.format("%s(%s%s)", i18n(info.name), i18n("christmas_stocking_text_07"), num).itemData, string.format("%s(%s%s)", i18n(info.name), i18n("christmas_stocking_text_07"), num).id = string.format("%s(%s%s)", i18n(info.name), i18n("christmas_stocking_text_07"), num)
	iconNode:initData(string.format("%s(%s%s)", i18n(info.name), i18n("christmas_stocking_text_07"), num))
	iconNode:hidenNumLabel()
end
function ChristmasStokeBuyView:getLimitBuyNum(index)
	local data = christmasBattleCtrl:getChristData()
	local num = data.exchangeNum[index] or 0
	local baseReward = SRD.data[index]
	if baseReward.time == NO_LIMIT_EXCHANGE_NUM then
		return NO_LIMIT_EXCHANGE_NUM
	else
		return baseReward.time - num
	end
end
function ChristmasStokeBuyView:updateScroll()
	for i, v in ipairs(self.tableItemList) do
		self:updateCell(v, i, false)
	end
end
function ChristmasStokeBuyView:clickBuyStokeBtn(index, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local info = SID.data[index]
		local baseReward = SRD.data[index]
		if self:getLimitBuyNum(index) <= 0 then
			SoraDShowMsgTip(i18n("Secret_explore_notice_13"))
			return
		end
		local resid = baseReward.consume[1]
		local exchangeCount
		if resid == gIDDef.COPPER then
			exchangeCount = SoraDGetCtrl("pyramidCtrl"):getCopperNum()
		elseif resid == gIDDef.GOLD then
			exchangeCount = SoraDGetCtrl("lordInfoCtrl"):getLordInfo().base.gold
		else
			exchangeCount = SoraDGetCtrl("cityCtrl"):getResCountEx(resid)
		end
		if 0 >= math.floor(exchangeCount / baseReward.consume[2]) then
			if resid == gIDDef.GOLD then
				SoraDEnoughGold(baseReward.consume[2])
			elseif resid == gIDDef.COPPER then
				uiManager:show("copperBuyView")
			else
				_ENV = i18n("Secret_explore_notice_13")
				i18n("Secret_explore_notice_13").rid = SoraDGetCtrl("cityCtrl"):getRealResid(resid)
				uiManager:show("resourceBuyView", i18n("Secret_explore_notice_13"))
			end
			return
		end
		local maxExchangeNum = math.min(self:getLimitBuyNum(index), math.floor(exchangeCount / baseReward.consume[2]))
		print("exchangeCount", exchangeCount, baseReward.consume[1], baseReward.consume[2], maxExchangeNum)
		if self:getLimitBuyNum(index) == NO_LIMIT_EXCHANGE_NUM then
			maxExchangeNum = math.min(maxExchangeNum, 10)
		end
		if maxExchangeNum == 1 then
			christmasBattleCtrl:sendExchangeSocks(index, 1)
			return
		end
		_ENV, _ENV, _ENV = maxExchangeNum, baseReward.consume[2], 1
		maxExchangeNum.targetID = info.ItemID
		maxExchangeNum.exchangeID = baseReward.consume[1]
		maxExchangeNum.singCount = baseReward.consume[2]
		baseReward.consume[2].exchangeData, maxExchangeNum.curNum = maxExchangeNum, maxExchangeNum
		;(1).exchangeCfg, baseReward.consume[2].exchangeHandler = baseReward.consume[2], function(exchangeNum)
			SoraDShowLoading(self)
			christmasBattleCtrl:sendExchangeSocks(index, exchangeNum)
		end
		uiManager:show("newShopSingleBuy", 1)
	end
end
function ChristmasStokeBuyView:msgCallBack(target, data)
	if data.msg == "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_EXCHANGE_BACK" then
		SoraDCloseLoading(self)
		self:updateScroll()
	end
end
function ChristmasStokeBuyView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_BATTLE) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return ChristmasStokeBuyView
