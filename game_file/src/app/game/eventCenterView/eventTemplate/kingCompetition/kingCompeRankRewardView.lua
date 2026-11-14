local gametop = gModuleMgr.getObject("gametop")
local kingCompetitionltCtrl = include("kingCompetitionltCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local CELL_SIZE_HEIGHT = 280
local kingCompeRankRewardView = class("kingCompeRankRewardView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingCompeRankRewardView")
	end
	return target
end)
function kingCompeRankRewardView:ctor()
	self.isHideCurrentSceneView = true
	self:initView()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.initMyData))
end
function kingCompeRankRewardView:initView()
	self.rewardTable, _ENV, self.rankInfo, _ENV, self.scrollItemTable, _ENV = nil, nil, nil, nil, nil, nil
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.imageBg = SoraDGetChildByName(self, "Image_bg")
	self.imageBg:setFillType(1)
	SoraDGetChildByName(self.topNode, "Image_18"):setFillType(1)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_kingCompeti")
	SoraDGetChildByName(self.title, "btn_FAQ"):addTouchEventListener(handler(self, self.clickFAQBtn))
	self.textTips = self.topNode:getChildByName("text_tips")
	self.textTips:setString(i18n("kindom_competition_text_11"))
	self.scroll = self.topNode:getChildByName("scroll")
	local height = self:getPanelOffsetHeight() - 360
	self.scroll:setContentSize(640, height)
	self.scrollItem = SoraDGetChildByName(self.scroll, "item_Node")
	self.scrollItem:setVisible(false)
	SoraDGetChildByName(self, "Image_left"):setContentSize(280, height)
	SoraDGetChildByName(self, "Image_right"):setContentSize(280, height)
	self.spriteTop = self.topNode:getChildByName("sprite_top")
	self.downNode = SoraDGetChildByName(self, "bottomBg")
	self.myRank = SoraDGetChildByName(self.downNode, "Text_myRank")
	self.myHead = SoraDGetChildByName(self.downNode, "Image_head")
	self.myName = SoraDGetChildByName(self.downNode, "Text_myName")
	self.myAlli = SoraDGetChildByName(self.downNode, "Text_myLordName")
	self.myNum = SoraDGetChildByName(self.downNode, "Text_myNum")
	self.spriteWar = SoraDGetChildByName(self.downNode, "Sprite_war")
end
function kingCompeRankRewardView:initData(index)
	self.selectType = index
	self:initScroll()
	self:updataScroll()
	if self.selectType == 1 then
		rankingsCtrl:getRankings(lordRankingsDef.lordCastle)
		self.spriteTop:loadTexture("bg_xinwangguozhengbasai11@2x.png", ccui.TextureResType.plistType)
		self.title:setTitle(i18n("kindom_competition_text_08"))
	elseif self.selectType == 2 then
		rankingsCtrl:getRankings(lordRankingsDef.lordLevel)
		self.spriteTop:loadTexture("bg_xinwangguozhengbasai10@2x.png", ccui.TextureResType.plistType)
		self.title:setTitle(i18n("kindom_competition_text_09"))
	elseif self.selectType == 3 then
		rankingsCtrl:getRankings(lordRankingsDef.lordPower)
		self.spriteTop:loadTexture("bg_xinwangguozhengbasai12@2x.png", ccui.TextureResType.plistType)
		self.title:setTitle(i18n("kindom_competition_text_10"))
	end
end
function kingCompeRankRewardView:initScroll()
end
function kingCompeRankRewardView:updataScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollW = scrollInner:getContentSize().width
	local scrollMinH = self.scroll:getContentSize().height
	local rankInfo = kingCompetitionltCtrl:getRankInfo(self.selectType)
	local rankNums = table.nums(rankInfo)
	local scrollH = math.max(self.scroll:getContentSize().height, rankNums * 280)
	local rewardInfo = kingCompetitionltCtrl:getRankInfo(self.selectType)
	for k, v in ipairs(rewardInfo) do
		local item = self.scrollItemTable[k]
		if not item then
			item = self.scrollItem:clone()
			self.scrollItemTable[k] = item
			item:addTo(self.scroll)
			item:setPosition(320, scrollH - 10 - 280 * (k - 1))
			item:setTag(k)
		end
		item:setVisible(true)
		self:updataScrollItem(item, v)
	end
	offsetY = math.min(0, math.max(scrollMinH - scrollH, offsetY - (scrollH - scrollInner:getContentSize().height)))
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
	scrollInner:setPositionY(offsetY)
end
function kingCompeRankRewardView:updataScrollItem(item, info)
	local title = SoraDGetChildByName(item, "text_title")
	if info.min == info.max then
		_ENV = nil
		;(nil).num = info.min
		title:setString(i18n("common_text_617", nil))
	else
		_ENV = i18n("common_text_617", nil)
		i18n("common_text_617", nil).min = info.min
		i18n("common_text_617", nil).max = info.max
		title:setString(i18n("common_text_1770", i18n("common_text_617", nil)))
	end
	local rewardsInfo = SoraDIntArr2FormatTable(info.rewards)
	local maxRewardIndex = 8
	for i = 1, maxRewardIndex do
		local rewardItem = item:getChildByName("reward_item" .. i)
		if rewardItem then
			rewardItem:setVisible(false)
		end
	end
	for k, v in ipairs(rewardsInfo) do
		if k > maxRewardIndex then
			break
		end
		local rewardItem = item:getChildByName("reward_item" .. k)
		if not rewardItem then
			rewardItem = include("itemSingleView").new()
			rewardItem:setRechargeUse(true)
			rewardItem:sendParentToButton(self)
			rewardItem:setScale(0.6)
			rewardItem:addTo(item)
			rewardItem:setName("reward_item" .. k)
			if 4 < k then
				rewardItem:setPosition(-225 + (k - 5) * 120, -160)
			else
				rewardItem:setPosition(-225 + (k - 1) * 120, -60)
			end
		end
		_ENV, _ENV = -60, -225 + (k - 1) * 120
		;(-60).id = v.id
		;(-225 + (k - 1) * 120).itemData, (-60).count = -60, v.num
		rewardItem:initData(-225 + (k - 1) * 120)
		rewardItem:setButtonTag(v.id)
		rewardItem:setVisible(true)
	end
end
function kingCompeRankRewardView:initMyData(target, data)
	local msg = data.rank.league
	local maxCount = RANK_ALLIANCE_MAX_SHOW or RANK_MAX_SHOW
	if (data.rank.league <= 0 or maxCount < data.rank.league) and data.rank.league <= 0 then
		msg = i18n("common_text_827")
	end
	self.myRank:setString(msg)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownInfo = lordInfoCtrl:getLordInfo()
	local abbr = ownInfo.abbr
	if abbr and abbr ~= "" then
		self.myName:setString(string.format("(%s)", abbr) .. i18n(ownInfo.base.nickName))
	else
		self.myName:setString(ownInfo.base.nickName)
	end
	self.myHead:setVisible(true)
	self.myName:setPositionY(50)
	self.myAlli:setVisible(false)
	SoraDGetHeadFromManager(self.myHead, ownInfo.base.imageId, ownInfo.base.avatar)
	if self.selectType == 1 then
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(data.rank.ranking)
		self.spriteWar:setVisible(warLv >= CASTLE_MIN_WARLV)
		self.spriteWar:setSpriteFrame("icon_main_honourgrade.png")
		self.spriteWar:setScale(0.8)
		if 0 <= warLv then
			if warLv == 0 then
				warLv = CASTLE_MAXLV_NOWAR
			end
			self.myNum:setString(string.formatnumberthousands(warLv))
		else
			self.myNum:setString(string.formatnumberthousands(data.rank.ranking))
		end
	else
		self.spriteWar:setVisible(false)
		self.myNum:setString(string.formatnumberthousands(data.rank.ranking))
	end
	if SoraDFIsRA() then
		self.spriteWar:setPositionX(self.myNum:getPositionX() + self.myNum:getContentSize().width)
	elseif self.selectType == 1 then
		self.spriteWar:setPositionX(self.myNum:getPositionX() - 10)
	else
		self.spriteWar:setPositionX(self.myNum:getPositionX() - self.myNum:getContentSize().width)
	end
end
function kingCompeRankRewardView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.KING_COMPETITION)
	end
end
function kingCompeRankRewardView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_RANK_MATCH) then
		self:removeFromParent()
		return
	end
end
return kingCompeRankRewardView
