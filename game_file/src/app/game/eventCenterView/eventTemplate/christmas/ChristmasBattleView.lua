local SRD = require_data("stocking_info")
local SFD = require_data("stocking_favorite", true)
local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = SoraDGetCtrl("backpackCtrl", gametop)
local christmasBattleCtrl = SoraDGetCtrl("christmasBattleCtrl", gametop)
local MAX_CHRIST_GIFT_NUM = 3
local ChristmasBattleView = class("ChristmasBattleView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("ChristmasBattleView")
	end
	return target
end)
function ChristmasBattleView:ctor()
	self.isHideCurrentSceneView = true
	self:initView()
	self:initScroll()
	self:updateProcent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_EXCHANGE_BACK", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_UPDATE", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ChristmasBattleView:getProgressCfg(curScore)
	if not self.baseProgressCfg then
		self.baseProgressCfg, _ENV = self.baseProgressCfg, self.baseProgressCfg
		local score = 0
		for i, v in ipairs(SFD.data) do
			_ENV = nil
			;(nil).from = score
			;(nil).to = v.Rank
			;(nil).index = v.Index
			;(nil).rewards = v.Rewards
			table.insert(self.baseProgressCfg, nil)
			score = v.Rank
		end
	end
	local from = 0
	local maxIndex = 0
	local cfg
	for i, v in ipairs(self.baseProgressCfg) do
		cfg = v
		if self:canReceiveGift(i) then
			break
		end
	end
	return cfg
end
function ChristmasBattleView:getReceiveGiftMaxIndex(...)
	return self.baseProgressCfg and #self.baseProgressCfg or 0
end
function ChristmasBattleView:initView()
	self.tableItemList, _ENV = nil, nil
	local root = self._ccsView
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_christmas")
	self.title:setTitle(i18n("christmas_stocking_text_01"))
	ChristmasBattleView = i18n("christmas_stocking_text_01")
	i18n("christmas_stocking_text_01")[1] = "Bottom_Node"
	self.bottomNode = SoraDGetChildByFullPath(root, i18n("christmas_stocking_text_01"))
	ChristmasBattleView = i18n("christmas_stocking_text_01")
	i18n("christmas_stocking_text_01")[1] = "Top_node"
	self.rewardBtnList, _ENV, self.topNode = SoraDGetChildByFullPath(root, i18n("christmas_stocking_text_01")), SoraDGetChildByFullPath(root, i18n("christmas_stocking_text_01")), SoraDGetChildByFullPath(root, i18n("christmas_stocking_text_01"))
	self.effectStoke = SoraDCreatAnimation("buyStoke")
	self.effectStoke:setPosition(cc.p(321, -586))
	self.topNode:addChild(self.effectStoke, 100)
	for i = 1, 4 do
		ChristmasBattleView = cc.p(321, -586)
		cc.p(321, -586)[1] = "reward_btn_" .. i
		local btn = SoraDGetChildByFullPath(self.bottomNode, cc.p(321, -586))
		btn:addTouchEventListener(handlerEx(self, ChristmasBattleView.clickBoxRewardBtn, i))
		self.rewardBtnList[i] = btn
	end
	local helpBtn = SoraDGetChildByName(self.title, "faqBtn")
	helpBtn:addTouchEventListener(function(target, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CHRISTMAS_BATTLE)
		end
	end)
	function gametop(target, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CHRISTMAS_BATTLE)
		end
	end
	;(function(target, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CHRISTMAS_BATTLE)
		end
	end)[1] = "buy_bg"
	;(function(target, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CHRISTMAS_BATTLE)
		end
	end)[2] = "buy_btn"
	self.buyBtn = SoraDGetChildByFullPath(self.bottomNode, function(target, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CHRISTMAS_BATTLE)
		end
	end)
	self.buyBtn:addTouchEventListener(handler(self, ChristmasBattleView.clickBuyBtn))
	gametop = handler(self, ChristmasBattleView.clickBuyBtn)
	handler(self, ChristmasBattleView.clickBuyBtn)[1] = "buy_bg"
	handler(self, ChristmasBattleView.clickBuyBtn)[2] = "buy_tips"
	SoraDGetChildByFullPath(self.bottomNode, handler(self, ChristmasBattleView.clickBuyBtn)):setString(i18n("christmas_stocking_text_02"))
	gametop = i18n("christmas_stocking_text_02")
	i18n("christmas_stocking_text_02")[1] = "buy_bg"
	i18n("christmas_stocking_text_02")[2] = "buy_tips"
	SoraDSetTextWidthHeight(SoraDGetChildByFullPath(self.bottomNode, i18n("christmas_stocking_text_02")), cc.size(100, 60))
	gametop = cc.size(100, 60)
	cc.size(100, 60)[1] = "buy_bg"
	cc.size(100, 60)[2] = "buy_tips"
	SoraDGetChildByFullPath(self.bottomNode, cc.size(100, 60)):setFontSize(17)
	self.progressBar = SoraDGetExtendChildFromCCSByName(self.topNode, "CCS_commonProgressBar_feel")
	ChristmasBattleView = "CCS_commonProgressBar_feel"
	;("CCS_commonProgressBar_feel")[1] = "btn_sddzz_05_37"
	self.feelBoxBtnImg = SoraDGetChildByFullPath(self.topNode, "CCS_commonProgressBar_feel")
	ChristmasBattleView = "CCS_commonProgressBar_feel"
	;("CCS_commonProgressBar_feel")[1] = "feelBoxBtn"
	self.feelBoxBtn = SoraDGetChildByFullPath(self.topNode, "CCS_commonProgressBar_feel")
	self.feelBoxBtn:addTouchEventListener(handler(self, ChristmasBattleView.clickFeelBoxBtn))
	ChristmasBattleView = handler(self, ChristmasBattleView.clickFeelBoxBtn)
	handler(self, ChristmasBattleView.clickFeelBoxBtn)[1] = "minFeelLabel"
	self.minFeelLabel = SoraDGetChildByFullPath(self.topNode, handler(self, ChristmasBattleView.clickFeelBoxBtn))
	ChristmasBattleView = handler(self, ChristmasBattleView.clickFeelBoxBtn)
	handler(self, ChristmasBattleView.clickFeelBoxBtn)[1] = "maxFeelLabel"
	self.maxFeelLabel = SoraDGetChildByFullPath(self.topNode, handler(self, ChristmasBattleView.clickFeelBoxBtn))
	ChristmasBattleView = handler(self, ChristmasBattleView.clickFeelBoxBtn)
	handler(self, ChristmasBattleView.clickFeelBoxBtn)[1] = "curFeelLabel"
	self.curFeelLabel = SoraDGetChildByFullPath(self.topNode, handler(self, ChristmasBattleView.clickFeelBoxBtn))
	ChristmasBattleView = handler(self, ChristmasBattleView.clickFeelBoxBtn)
	handler(self, ChristmasBattleView.clickFeelBoxBtn)[1] = "left_time_label"
	self.timeLabel = SoraDGetChildByFullPath(self.topNode, handler(self, ChristmasBattleView.clickFeelBoxBtn))
	self.timeLabel = SoraDCreateTimerLabel(self, self.timeLabel)
	self.timeLabel:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.timeLabel:setTimeEndListener(function()
		self:closePanel()
	end)
	self.timeLabel:setPositionX(320)
	ChristmasBattleView = 320
	;(320)[1] = "scroll"
	self.scroll = SoraDGetChildByFullPath(self.bottomNode, 320)
	ChristmasBattleView = 320
	;(320)[1] = "single_item"
	self.defaultItem = SoraDGetChildByFullPath(root, 320)
	self.bottomNode:setPositionY(math.max(self:getPanelOffsetHeight() - 960, 0))
	ChristmasBattleView = math.max(self:getPanelOffsetHeight() - 960, 0)
	math.max(self:getPanelOffsetHeight() - 960, 0)[1] = "bottom_bg"
	self.bottomBg = SoraDGetChildByFullPath(self.bottomNode, math.max(self:getPanelOffsetHeight() - 960, 0))
	self.bottomBg:setPositionY(math.min(960 - self:getPanelOffsetHeight(), 0))
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl", gametop)
	local packageTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CHRISTMAS_BATTLE)
	if packageTime then
		self.timeLabel:beginTime(packageTime.timerNode.timer:getRemainTime())
	end
end
function ChristmasBattleView:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollMinH = self.scroll:getContentSize().height
	local scrollW = scrollInner:getContentSize().width
	local stockingSize = #SRD.data
	local scrollH = math.max(scrollMinH, stockingSize * 150)
	print("scrollSize", scrollW, scrollH, scrollH)
	local defaultItem = self.defaultItem
	for k = 1, stockingSize do
		local singleItem = self.tableItemList[i]
		if not singleItem then
			singleItem = defaultItem:clone()
			singleItem:addTo(self.scroll)
			singleItem:setTag(k)
			self.tableItemList[k] = singleItem
		end
		singleItem:setPosition(0, scrollH - k * 150)
		self:updateCell(singleItem, k, true)
	end
	local scrollContentH = math.max(scrollMinH, self:getPanelOffsetHeight() - 750)
	self.scroll:setContentSize(cc.size(scrollW, scrollContentH))
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
end
function ChristmasBattleView:updateCell(node, index, isInit)
	local info = SRD.data[index]
	local itemName = SoraDGetChildByName(node, "itemName")
	local descLabel = SoraDGetChildByName(node, "desc")
	local leftNumLabel = SoraDGetChildByName(node, "leftNum")
	local eventBtn = SoraDGetChildByName(node, "eventBtn")
	local iconNode = SoraDGetChildByName(node, "iconNode")
	if isInit then
		eventBtn:setTitleText(i18n("christmas_stocking_text_04"))
		eventBtn:addTouchEventListener(handlerEx(self, self.clickSubmitBtn, index))
		iconNode = include("itemSingleView").new()
		iconNode:sendParentToButton(self)
		iconNode:addTo(node)
		iconNode:setPosition(cc.p(20, 130))
		iconNode:setScale(0.7)
		iconNode:setName("iconNode")
	end
	local leftNum = backpackCtrl:getItemCount(info.ItemID) or 0
	descLabel:setString(i18n(info.describe))
	leftNumLabel:setString(i18n("common_text_096") .. leftNum)
	itemName:setString(i18n(info.name))
	SRD, SRD = i18n(info.name)
	i18n(info.name).itemData, i18n(info.name).id = i18n(info.name)
	iconNode:initData(i18n(info.name))
	iconNode:hidenNumLabel()
end
function ChristmasBattleView:updateScroll()
	for i, v in ipairs(self.tableItemList) do
		self:updateCell(v, i, false)
	end
end
function ChristmasBattleView:updateProcent()
	local info = christmasBattleCtrl:getChristData()
	local curScore = info.favorite
	local cfg = self:getProgressCfg(curScore)
	christmasBattleCtrl = nil
	;(nil).curValue = curScore - cfg.from
	;(nil).maxValue = cfg.to - cfg.from
	self.progressBar:setProgressDate(nil)
	local progress = self.progressBar:getProgress()
	self.curFeelLabel:setString(curScore)
	print("updateProcent", progress)
	local offset = math.max(progress * 5 + 50, 65)
	offset = math.min(offset, 515)
	self.curFeelLabel:setPositionX(offset)
	self.maxFeelLabel:setString(cfg.to)
	self.minFeelLabel:setString(cfg.from)
	self.effectStoke:setVisible(100 <= progress)
	if self:getReceiveGiftMaxIndex() == cfg.index and info.favoriteReward[tostring(cfg.index)] == 1 then
		SoraDSetGray(self.feelBoxBtnImg, true)
		self.feelBoxBtn:setTouchEnabled(false)
		self.effectStoke:setVisible(false)
	end
end
function ChristmasBattleView:canReceiveGift(index)
	local info = christmasBattleCtrl:getChristData()
	if info.favoriteReward[tostring(index)] and info.favoriteReward[tostring(index)] == 1 then
		return false
	end
	return true
end
function ChristmasBattleView:getCanReceiveGiftIndex()
	local index = 1
	local info = christmasBattleCtrl:getChristData()
	local curScore = info.favorite
	local maxIndex = self:getReceiveGiftMaxIndex()
	for i = 1, maxIndex do
		index = i
		if (not info.favoriteReward[tostring(i)] or info.favoriteReward[tostring(i)] == 0) and self.baseProgressCfg[i] and curScore >= self.baseProgressCfg[i].to then
			return index
		end
	end
	return index
end
function ChristmasBattleView:clickFeelBoxBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local info = christmasBattleCtrl:getChristData()
		local cfg = self:getProgressCfg(info.favorite)
		_UPVALUE2_ = nil
		;(nil)[1] = "key"
		;(nil)[2] = "value"
		local rewards = serviceFunctions.tableFormat(cfg.rewards, nil)
		local panel = SoraDCreatePanel("ChristmasBattleShowBoxReward")
		_ENV = "value"
		;("value").reward = rewards
		;("value").index = self:getCanReceiveGiftIndex()
		panel:initData("value")
		panel:show()
	end
end
function ChristmasBattleView:clickBuyBtn(target, eventType)
	print("clickBuyBtn")
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("ChristmasStokeBuyView"):show()
	end
end
function ChristmasBattleView:clickBoxRewardBtn(index, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local info = christmasBattleCtrl:getChristData()
		if info.chrisGift > serviceFunctions.systemTime() then
			return
		end
		christmasBattleCtrl:sendGetChrisGift()
	end
end
function ChristmasBattleView:clickSubmitBtn(index, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		if not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		local info = SRD.data[index]
		local leftNum = backpackCtrl:getItemCount(info.ItemID) or 0
		if 0 < leftNum then
			if leftNum == 1 then
				SoraDShowLoading()
				christmasBattleCtrl:sendSubmitSocks(index, exchangeNum)
				return
			end
			local submitView = SoraDCreatePanel("cheatItemGetView")
			_ENV = exchangeNum
			exchangeNum.ItemName = i18n(info.name)
			local msgTips = i18n("christmas_stocking_tips_07", exchangeNum)
			_ENV = i18n(info.name)
			i18n(info.name).id = info.ItemID
			i18n(info.name).curValue = leftNum
			i18n(info.name).maxValue = leftNum
			i18n(info.name).btnText = i18n("common_text_3628")
			i18n(info.name).msg = msgTips
			submitView:initSubmitData((i18n(info.name)))
			submitView:setHandle(function(exchangeNum)
				SoraDShowLoading()
				christmasBattleCtrl:sendSubmitSocks(index, exchangeNum)
			end)
			submitView:show()
		else
			SoraDCreatePanel("ChristmasStokeBuyView"):show()
			SoraDShowMsgTip(i18n("notice_0120"))
		end
	end
end
function ChristmasBattleView:msgCallBack(target, data)
	if data.msg == "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_EXCHANGE_BACK" then
		self:updateScroll()
	elseif data.msg == "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_UPDATE" then
		SoraDCloseLoading()
		self:updateProcent()
		self:updateScroll()
	end
end
function ChristmasBattleView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_BATTLE) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return ChristmasBattleView
