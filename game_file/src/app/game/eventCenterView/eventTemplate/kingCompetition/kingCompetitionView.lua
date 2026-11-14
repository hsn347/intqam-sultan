local gametop = gModuleMgr.getObject("gametop")
local timeCtrl = gametop.playertop_:getModule("timeCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local kingCompetitionCtrl = gametop.playertop_:getModule("kingCompetitionCtrl")
local kingCompetitionltCtrl = include("kingCompetitionltCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local lordSpineDef = include("lordSpineDef")
local lordLocalData = include("lordLocalData")
local kingCompetitionView = class("kingCompetitionView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingCompetitionView")
	end
	return target
end)
function kingCompetitionView:onEnterPanel()
	rankingsCtrl:getRankings(lordRankingsDef.lordCastle)
	SoraDShowLoading(self)
end
function kingCompetitionView:ctor()
	self.isHideCurrentSceneView = true
	self:initView()
	self:initEvent()
	self:initTimer()
	self:initScroll()
	self:updateScroll()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.updateLeader))
	SoraDAddMessage(self, "MESSAGE_SERVER_KING_COMPETITION_GET_REWARD_SUCCESS", handler(self, self.showGetAward))
end
function kingCompetitionView:initView()
	self:getPlayerData()
	_ENV, self.spriteTabTable, _ENV, self.chooseTable, _ENV, self.redNodeTable, _ENV, self.scrollItemTable, _ENV, self.btnTable, _ENV = self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData
	self.getPlayerData.castle = 1
	self.getPlayerData.level = 2
	_ENV, self.tabTagDef, self.getPlayerData.strength = self.getPlayerData, self.getPlayerData, 3
	self.getPlayerData.claim = 1
	self.getPlayerData.go = 2
	self.btnStatusDef, self.getPlayerData.received = self.getPlayerData, 3
	self.animation, _ENV, self.rewardTable, _ENV, self.selectTab = self.getPlayerData, self.getPlayerData, self.getPlayerData, self.getPlayerData, 1
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_kingCompeti")
	self.title:setTitle(i18n("kindom_competition_text_01"))
	self.btnNode = self.topNode:getChildByName("btn_Node")
	for i = 1, 3 do
		self.btnTable[i] = self.btnNode:getChildByName("btn_tab_" .. i)
		local textTab = self.btnTable[i]:getChildByName("text_Tab")
		if i == 1 then
			textTab:setString(i18n("kindom_competition_text_15"))
			textTab:setColor(cc.c3b(251, 251, 198))
		elseif i == 2 then
			textTab:setString(i18n("kindom_competition_text_17"))
		else
			textTab:setString(i18n("kindom_competition_text_16"))
		end
		self.redNodeTable[i] = self.btnTable[i]:getChildByName("sprite_RedNode")
		self.redNodeTable[i]:setVisible(false)
		self.chooseTable[i] = self.btnTable[i]:getChildByName("sprite_choose")
		self.chooseTable[i]:setVisible(false)
		self.spriteTabTable[i] = self.btnTable[i]:getChildByName("sprite_tab_1")
		self.spriteTabTable[i]:setVisible(true)
	end
	self.btnTable[self.selectTab]:setTouchEnabled(false)
	self.btnTable[self.selectTab]:setBright(false)
	self.chooseTable[self.selectTab]:setVisible(true)
	self.spriteTabTable[self.selectTab]:setVisible(false)
	self.middleNode = self.topNode:getChildByName("middle_Node")
	self.bgMiddle = self.middleNode:getChildByName("bg_middle")
	self.animateNode = self.middleNode:getChildByName("animation_Node")
	self.spriteHead = self.middleNode:getChildByName("Sprite_head")
	self.spriteHead:setVisible(false)
	self.btnRewardInfo = SoraDGetChildByName(self.middleNode, "btn_info")
	SoraDGetChildByName(self.btnRewardInfo, "text_btn"):setString(i18n("kindom_competition_text_02"))
	self.btnRank = SoraDGetChildByName(self.middleNode, "btn_rank")
	SoraDGetChildByName(self.btnRank, "text_btn"):setString(i18n("kindom_competition_text_03"))
	SoraDGetChildByName(self.middleNode, "text_leader"):setString(i18n("kindom_competition_text_04"))
	self.leaderName = SoraDGetChildByName(self.middleNode, "text_name")
	self.leaderNum = SoraDGetChildByName(self.middleNode, "text_info")
	self.spriteWar = SoraDGetChildByName(self.middleNode, "sprite_war")
	self.spriteWar:setVisible(false)
	self.leftTime = SoraDGetChildByName(self.middleNode, "text_lefttime")
	self.scroll = SoraDGetChildByName(self.topNode, "Top_Size_Scroll")
	self.scrollItem = self.scroll:getChildByName("scroll_item")
	self.scrollItem:setVisible(false)
	local height = self:getPanelOffsetHeight() - 590
	self.scroll:setContentSize(640, height)
	SoraDGetChildByName(self, "Image_left"):setContentSize(280, height)
	SoraDGetChildByName(self, "Image_right"):setContentSize(280, height)
	self.bgMiddle:setSpriteFrame("bg_xinwangguozhengbasaiqingjing@2x.png")
end
function kingCompetitionView:initEvent()
	SoraDGetChildByName(self.title, "btn_FAQ"):addTouchEventListener(handler(self, self.clickFAQBtn))
	self.btnRewardInfo:addTouchEventListener(handler(self, self.clickRewardInfoBtn))
	self.btnRank:addTouchEventListener(handler(self, self.clickRankBtn))
	for i = 1, 3 do
		self.btnTable[i]:addTouchEventListener(handlerEx(self, self.clickTabBtn, i))
		self.btnTable[i]:setPressedActionEnabled(false)
	end
end
function kingCompetitionView:initTimer()
	self.leftTime = SoraDCreateTimerLabel(self, self.leftTime)
	self.leftTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.leftTime:setTimeEndListener(function()
		self:removeFromParent()
	end)
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_SERVER_RANK_MATCH)
	if activityTime then
		self.leftTime:beginTime(activityTime.timerNode.timer:getRemainTime())
	end
end
function kingCompetitionView:initScroll()
	local num = kingCompetitionltCtrl:getTargetNum(self.selectTab)
	for i = 1, num do
		if not self.scrollItemTable[i] then
			local scrollItem = self.scrollItem:clone()
			scrollItem:addTo(self.scroll)
			local btn = scrollItem:getChildByName("btn_item")
			btn:addTouchEventListener(handlerEx(self, self.clickItemBtn, i))
			scrollItem.btnStatus = self.btnStatusDef.go
			scrollItem.tabTag = self.tabTagDef.castle
			self.scrollItemTable[i] = scrollItem
			self:initRewardTable(i)
		end
	end
end
function kingCompetitionView:initRewardTable(index)
	local _ENV, rewardTable
	if self.rewardTable[index] then
		return
	end
	for i = 1, 4 do
		local Item = include("itemSingleView").new()
		Item:setRechargeUse(true)
		Item:sendParentToButton(self)
		Item:setScale(0.6)
		Item:addTo(self.scrollItemTable[index])
		Item:setPosition(-280 + (i - 1) * 90, -50)
		rewardTable[i] = Item
	end
	self.rewardTable[index] = rewardTable
end
function kingCompetitionView:updateLeader(target, data)
	SoraDCloseLoading(self)
	local leaderInfo = data.rank.data[1]
	local info = lordSpineDef.getLordSpineInfo(leaderInfo.imageId)
	if info then
		self.spriteHead:setVisible(false)
		if self.animation[leaderInfo.imageId] == nil then
			self.animation[leaderInfo.imageId] = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
			local offset = info.offset or cc.p(0, 0)
			self.animation[leaderInfo.imageId]:setPosition(cc.p(0 + offset.x, 0 + offset.y))
			self.animation[leaderInfo.imageId]:setAnimation(0, "animation", true)
			self.animation[leaderInfo.imageId]:addTo(self.animateNode)
			self.animation[leaderInfo.imageId]:setScale(0.8)
		end
		for k, v in pairs(self.animation) do
			if k == leaderInfo.imageId then
				v:setVisible(true)
			else
				v:setVisible(false)
			end
		end
	else
		self.spriteHead:setVisible(true)
		self.spriteHead:setSpriteFrame(lordLocalData.getPortrait(leaderInfo.imageId))
	end
	local allianceName = leaderInfo.allianceName
	if allianceName and allianceName ~= "" then
		self.leaderName:setString(string.format("(%s)%s", allianceName, leaderInfo.nickName))
	else
		self.leaderName:setString(leaderInfo.nickName)
	end
	if self.selectTab == 1 then
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(leaderInfo.ranking)
		self.spriteWar:setVisible(warLv >= CASTLE_MIN_WARLV)
		if 0 <= warLv then
			if warLv == 0 then
				warLv = CASTLE_MAXLV_NOWAR
			end
			self.leaderNum:setString(i18n("kindom_competition_text_12") .. warLv)
		else
			self.leaderNum:setString(i18n("kindom_competition_text_12") .. leaderInfo.ranking)
		end
	elseif self.selectTab == 2 then
		self.spriteWar:setVisible(false)
		self.leaderNum:setString(string.format("%s:%s", i18n("kindom_competition_text_17"), leaderInfo.ranking))
	else
		self.spriteWar:setVisible(false)
		self.leaderNum:setString(i18n("kindom_competition_text_13") .. string.formatnumberthousands(leaderInfo.ranking))
	end
	self.spriteWar:setPositionX(self.leaderNum:getPositionX() - self.leaderNum:getContentSize().width / 2 - 20)
end
function kingCompetitionView:updateScroll()
	self:initScroll()
	local num = kingCompetitionltCtrl:getTargetNum(self.selectTab)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollW = scrollInner:getContentSize().width
	local scrollMinH = self.scroll:getContentSize().height
	local scrollH = math.max(self.scroll:getContentSize().height, num * 160)
	for i = 1, #self.scrollItemTable do
		if i > num then
			self.scrollItemTable[i]:setVisible(false)
		else
			local scrollItem = self.scrollItemTable[i]
			scrollItem:setVisible(true)
			scrollItem:setPosition(320, scrollH - 5 - 160 * (i - 1))
			self:updateScrollItem(i)
		end
	end
	offsetY = math.min(0, math.max(scrollMinH - scrollH, offsetY - (scrollH - scrollInner:getContentSize().height)))
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
	scrollInner:setPositionY(offsetY)
	local first = 0
	for i = 1, 3 do
		local targetNum = kingCompetitionltCtrl:getTargetNum(i)
		self.redNodeTable[i]:setVisible(self:checkRedNode(i, targetNum, first))
		first = first + targetNum
	end
	self:sortSingles(num)
	self.scroll:scrollToTop(0.01, false)
end
function kingCompetitionView:updateScrollItem(index)
	local item = self.scrollItemTable[index]
	local textTips = item:getChildByName("text_tips")
	local textProgress = item:getChildByName("text_progress")
	local btn = item:getChildByName("btn_item")
	local kingCompetitionltCtrl, info = item, item
	if self.selectTab == 1 then
		info = kingCompetitionltCtrl:getTaskInfo(index)
		kingCompetitionltCtrl = nil
		;(nil).lv = info.target
		textTips:setString(i18n("common_text_1973", nil))
		item.tabTag = self.tabTagDef.castle
	elseif self.selectTab == 2 then
		info = kingCompetitionltCtrl:getTaskInfo(index + kingCompetitionltCtrl:getTargetNum(1))
		kingCompetitionltCtrl = 1
		;(1).lv = info.target
		textTips:setString(i18n("common_text_1974", 1))
		item.tabTag = self.tabTagDef.level
	elseif self.selectTab == 3 then
		info = kingCompetitionltCtrl:getTaskInfo(index + kingCompetitionltCtrl:getTargetNum(1) + kingCompetitionltCtrl:getTargetNum(2))
		textTips:setString(i18n("kindom_competition_text_14") .. " " .. i18n(tostring(info.target)))
		item.tabTag = self.tabTagDef.strength
	end
	self.ncpLv = self.PlayerInfo[self.selectTab]
	local target = info.target
	textProgress:setString(i18n("common_text_3780") .. string.format("%s/%s", self.ncpLv, target))
	local targetStatus = kingCompetitionCtrl:getTargetStatus(self.selectTab, index)
	if target <= self.ncpLv then
		textProgress:setColor(cc.c3b(255, 190, 0))
		if targetStatus then
			btn:setTitleText(i18n("common_text_1892"))
			btn:loadTextures("btn_gray_small.png", "btn_gray_small.png", "btn_gray_small.png", ccui.TextureResType.plistType)
			btn:setTouchEnabled(false)
			item.btnStatus = self.btnStatusDef.received
		else
			btn:setTitleText(i18n("common_text_1146"))
			btn:loadTextures("btn_green_small_01.png", "btn_green_small_02.png", "btn_gray_small.png", ccui.TextureResType.plistType)
			item.btnStatus = self.btnStatusDef.claim
			btn:setTouchEnabled(true)
		end
	else
		textProgress:setColor(cc.c3b(200, 0, 0))
		btn:setTitleText(i18n("Secret_explore_text_21"))
		btn:loadTextures("btn_yellow_small_01.png", "btn_yellow_small_02.png", "btn_gray_small.png", ccui.TextureResType.plistType)
		item.btnStatus = self.btnStatusDef.go
		btn:setTouchEnabled(true)
	end
	local rewardTable = self.rewardTable[index]
	for i = 1, 4 do
		kingCompetitionltCtrl, kingCompetitionltCtrl = i18n("Secret_explore_text_21")
		i18n("Secret_explore_text_21").id = info.rewards[(i - 1) * 2 + 1]
		i18n("Secret_explore_text_21").itemData, i18n("Secret_explore_text_21").count = i18n("Secret_explore_text_21")
		rewardTable[i]:initData(i18n("Secret_explore_text_21"))
		rewardTable[i]:setButtonTag(info.rewards[(i - 1) * 2 + 1])
	end
end
function kingCompetitionView:sortSingles(num)
	local singleHeight = 160
	local preIndex = 0
	for i = 1, num do
		if self.scrollItemTable[i].btnStatus ~= self.btnStatusDef.received then
			self.scrollItemTable[i]:setPosition(cc.p(320, self.scroll:getInnerContainerSize().height - 5 - preIndex * singleHeight))
			preIndex = preIndex + 1
		end
	end
	for i = 1, num do
		if self.scrollItemTable[i].btnStatus == self.btnStatusDef.received then
			self.scrollItemTable[i]:setPosition(cc.p(320, self.scroll:getInnerContainerSize().height - 5 - preIndex * singleHeight))
			preIndex = preIndex + 1
		end
	end
end
function kingCompetitionView:getPlayerData()
	local info = lordInfoCtrl:getLordInfo()
	self.PlayerInfo, lordInfoCtrl = lordInfoCtrl, lordInfoCtrl
	self.PlayerInfo[2] = info.base.level
	self.PlayerInfo[3] = info.fcInfo.totalFc
	local depotBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	self.PlayerInfo[1] = tonumber(depotBcell.info.lv)
end
function kingCompetitionView:checkRedNode(index, num, first)
	for i = 1, num do
		local info = kingCompetitionltCtrl:getTaskInfo(first + i)
		local target = info.target
		local targetStatus = kingCompetitionCtrl:getTargetStatus(index, i)
		if target <= self.PlayerInfo[index] and not targetStatus then
			return true
		end
	end
	return false
end
function kingCompetitionView:clickItemBtn(index, button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		SoraDPlaySound()
		local item = self.scrollItemTable[index]
		if item.btnStatus == self.btnStatusDef.received then
			return
		elseif item.btnStatus == self.btnStatusDef.claim then
			kingCompetitionCtrl:reqGetReward(self.selectTab, index)
		elseif item.btnStatus == self.btnStatusDef.go then
			if item.tabTag == self.tabTagDef.castle then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local depotBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
				_ENV = nil
				;(nil).bid = BUILDID.CASTLE
				;(nil).lv = tonumber(depotBcell.info.lv)
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, nil)
				SoraDRemoveAllPanelFromManager()
			elseif item.tabTag == self.tabTagDef.level then
				SoraDOpenLordView(lordInfoCtrl:getLordInfo())
				self:removeFromParent()
			elseif item.tabTag == self.tabTagDef.strength then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				_ENV = lordInfoCtrl:getLordInfo()
				lordInfoCtrl:getLordInfo().bid = BUILDID.CHARIOT_PLANT
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, lordInfoCtrl:getLordInfo())
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
function kingCompetitionView:clickTabBtn(index, button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.selectTab = index
		SoraDShowLoading(self)
		if self.selectTab == 1 then
			rankingsCtrl:getRankings(lordRankingsDef.lordCastle)
			self.bgMiddle:setSpriteFrame("bg_xinwangguozhengbasaiqingjing@2x.png")
		elseif self.selectTab == 2 then
			rankingsCtrl:getRankings(lordRankingsDef.lordLevel)
			self.bgMiddle:setSpriteFrame("bg_xinwangguozhengbasaiqingjing2@2x.png")
		elseif self.selectTab == 3 then
			rankingsCtrl:getRankings(lordRankingsDef.lordPower)
			self.bgMiddle:setSpriteFrame("bg_xinwangguozhengbasaiqingjing3@2x.png")
		end
		for i = 1, 3 do
			if index == i then
				local textTab = self.btnTable[i]:getChildByName("text_Tab")
				textTab:setColor(cc.c3b(251, 251, 198))
				self.btnTable[i]:setTouchEnabled(false)
				self.btnTable[i]:setBright(false)
				self.chooseTable[i]:setVisible(true)
				self.spriteTabTable[i]:setVisible(false)
			else
				local textTab = self.btnTable[i]:getChildByName("text_Tab")
				textTab:setColor(cc.c3b(141, 130, 120))
				self.btnTable[i]:setTouchEnabled(true)
				self.btnTable[i]:setBright(true)
				self.chooseTable[i]:setVisible(false)
				self.spriteTabTable[i]:setVisible(true)
			end
		end
		self:updateScroll()
	end
end
function kingCompetitionView:clickRankBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			_ENV = nil
			;(nil).num = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1795", nil))
			return
		end
		local panel = SoraDCreatePanel("kingCompetiRankView")
		if self.selectTab == 1 then
			panel:initData(lordRankingsDef.lordCastle)
		elseif self.selectTab == 2 then
			panel:initData(lordRankingsDef.lordLevel)
		elseif self.selectTab == 3 then
			panel:initData(lordRankingsDef.lordPower)
		end
		panel:show()
	end
end
function kingCompetitionView:clickRewardInfoBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("kingCompeRankRewardView")
		panel:initData(self.selectTab)
		panel:show()
	end
end
function kingCompetitionView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.KING_COMPETITION)
	end
end
function kingCompetitionView:showGetAward(target, data)
	self:updateScroll()
	if data.reward then
		SoraDMailGainItems(data.reward, true)
	end
end
function kingCompetitionView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_RANK_MATCH) then
		self:removeFromParent()
		return
	end
end
return kingCompetitionView
