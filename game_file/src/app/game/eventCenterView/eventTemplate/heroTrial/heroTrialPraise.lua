local GridScrollView = include("GridScrollView")
local lordLocalData = include("lordLocalData")
local gametop = gModuleMgr.getObject("gametop")
local heroTrialltCtrl = include("heroTrialltCtrl")
local heroTrialPraise = class("heroTrialPraise", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroTrialRank")
	end
	return target
end)
function heroTrialPraise:ctor()
	local title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle")
	local playerName = SoraDGetChildByName(self, "Text_2")
	local cupNum = SoraDGetChildByName(self, "Text_3")
	self.scrollView = SoraDGetChildByName(self, "Top_Size_ScrollView_rankings")
	local rewardBtn = SoraDGetChildByName(self, "rewardBtn")
	local helpBtn = SoraDGetChildByName(self, "helpBtn")
	local tip = SoraDGetChildByName(self, "tip")
	self.textMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.textMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self, "Text_myName")
	self.textMyLordName = SoraDGetChildByName(self, "Text_myLordName")
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.imageBottomBg = SoraDGetChildByName(self, "bottomBg")
	self.imageBottomBg:setTouchEnabled(true)
	self.imageBottomBg:addTouchEventListener(handler(self, self.onRank))
	rewardBtn:addTouchEventListener(handler(self, self.onReward))
	helpBtn:addTouchEventListener(handler(self, self.onHelp))
	title:setTitle(i18n("common_text_1704"))
	playerName:setString(i18n("common_text_264"))
	cupNum:setString(i18n("common_text_1706"))
	tip:setString(i18n("common_text_1705"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.rankData, _ENV, self.scrollView = GridScrollView.new(self.scrollView), GridScrollView.new(self.scrollView), GridScrollView.new(self.scrollView)
	self.rankNum = 0
	local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
	rankingsCtrl:getRankings(lordRankingsDef.htLike)
	SoraDShowLoading(self)
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", function(target, data)
		if self.haveGetRankData then
			return
		end
		self.haveGetRankData = true
		SoraDCloseLoading(self)
		if data.rank and data.rank.data and data.rank.league then
			self.rankData = data.rank.data
			local str = i18n("common_text_827")
			if data.rank.league > 0 then
				self = nil
				;(nil).rank = data.rank.league
				str = i18n("common_text_825", nil)
				self.rankNum = data.rank.league
			end
			self.textMyRank:setString(str)
			self = str
			str.col = 1
			str.top = 10
			str.h = 20
			str.left = 10
			self.scrollView:init(str, #self.rankData, handler(self, self.createCell), handler(self, self.updateCell))
			self.scrollView:updateNum(#self.rankData)
			self:initMyData()
		end
	end)
end
function heroTrialPraise:onEnterPanel()
end
function heroTrialPraise:createCell()
	local cell = SoraDCreateBasePanel("heroTrialRankSingle")
	return cell
end
function heroTrialPraise:updateCell(cell, index)
	local rankNum = SoraDGetChildByName(cell, "Text_1")
	local rankIcon = SoraDGetChildByName(cell, "icon_ranking_1_1")
	local playerIcon = SoraDGetChildByName(cell, "Image_3")
	local playerName = SoraDGetChildByName(cell, "Text_2")
	local allianceName = SoraDGetChildByName(cell, "Text_3")
	local cupNum = SoraDGetChildByName(cell, "Text_4")
	local imgCurBg = SoraDGetChildByName(cell, "Image_1")
	local Allianceflag_001_2 = SoraDGetChildByName(cell, "Allianceflag_001_2")
	Allianceflag_001_2:setVisible(false)
	if index <= RANK_TOP_SPECIAL then
		imgCurBg:setVisible(true)
		imgCurBg:loadTexture("frame_alliance_pank_0" .. index .. ".png", ccui.TextureResType.plistType)
		rankIcon:setVisible(true)
		rankNum:setVisible(false)
		rankIcon:setSpriteFrame("icon_ranking_" .. index .. ".png")
	elseif index == self.rankNum then
		imgCurBg:setVisible(true)
		imgCurBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		rankNum:setVisible(true)
		rankNum:setString(index)
		rankIcon:setVisible(false)
	else
		imgCurBg:setVisible(false)
		rankNum:setVisible(true)
		rankIcon:setVisible(false)
		rankNum:setString(index)
	end
	SoraDGetHeadFromManager(playerIcon, self.rankData[index].imageId, self.rankData[index].avatar)
	playerName:setString(self.rankData[index].nickName)
	if self.rankData[index].allianceName then
		_ENV = ".png"
		;(".png").conten = self.rankData[index].allianceName
		allianceName:setString(i18n("common_text_925", ".png"))
	else
		_ENV = i18n("common_text_925", ".png")
		i18n("common_text_925", ".png").conten = i18n("common_text_826")
		allianceName:setString(i18n("common_text_925", i18n("common_text_925", ".png")))
	end
	cupNum:setString(self.rankData[index].ranking)
	local touchLayer = SoraDGetChildByName(cell, "Panel_touch")
	touchLayer.idx = index
	touchLayer:addTouchEventListener(handler(self, self.onCell))
	touchLayer:setSwallowTouches(false)
end
function heroTrialPraise:onCell(sender, type)
	if type == ccui.TouchEventType.ended then
		if self.isMove then
			self.isMove = false
			return
		end
		SoraDPlaySound()
		local index = sender.idx
		if gametop.playertop_:getPlayerID() ~= self.rankData[index].uid then
			local chatConst = include("chatConst")
			_UPVALUE3_ = "chatConst"
			;("chatConst")[1] = chatConst.OpId.OpSendEmail
			;("chatConst")[2] = chatConst.OpId.OpViewInfo
			local ("chatConst")[3], menuData = chatConst.OpId.OpShield, "chatConst"
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			if curLevel >= CASTLE_LV10_LIMITED then
				table.insert(menuData, chatConst.OpId.OpSendFlower)
			end
			_ENV = nil
			;(nil).playerId = self.rankData[index].uid
			;(nil).nickName = self.rankData[index].nickName
			;(nil).allianceAbbr = self.rankData[index].allianceName
			SoraDShowPlayerOperatePanel(self.rankData[index].nickName, menuData, nil)
		else
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			SoraDOpenLordView(lordInfoCtrl:getLordInfo())
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMove = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.isMove = false
	end
end
function heroTrialPraise:onReward(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rankData = heroTrialltCtrl.getHTLikeRankingRewardList()
		local panel = SoraDCreatePanel("commonRankAwardView")
		panel:setTitle(i18n("common_text_1709"))
		panel:initData(rankData)
		panel:show()
	end
end
function heroTrialPraise:onHelp(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1712"
		;("common_text_1712").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_1712"), "common_text_1712")
	end
end
function heroTrialPraise:onRank(sender, type)
	if type == ccui.TouchEventType.ended and self.rankNum > 0 and self.rankNum <= #self.rankData then
		SoraDPlaySound()
		self.scrollView:scrollToIndex(self.rankNum)
	end
end
function heroTrialPraise:initMyData()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownInfo = lordInfoCtrl:getLordInfo()
	local ownAlliance = allianceMgr:getAlliance()
	local myNum = 0
	local heroTrialCommon = include("heroTrialCommon")
	for i, v in ipairs(self.rankData) do
		if ownInfo.base.uid == v.uid then
			myNum = v.ranking
			break
		end
	end
	self.textMyNum:setString(string.formatnumberthousands(myNum))
	self.textMyName:setString(ownInfo.base.nickName)
	local allianceStr = i18n("common_text_480")
	if ownAlliance then
		gametop = string.formatnumberthousands(myNum)
		string.formatnumberthousands(myNum).conten = ownAlliance:getProperty("abbr")
		allianceStr = i18n("common_text_925", string.formatnumberthousands(myNum))
	end
	self.textMyLordName:setString(allianceStr)
	self.ccs_head:setHeadSprite(ownInfo.base.imageId, ownInfo.base.avatar)
	self.ccs_head:setTouchEnabled(false)
end
return heroTrialPraise
