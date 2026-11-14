local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local allianceHuntChallenge = class("allianceHuntChallenge", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("allianceHuntChallenge")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function allianceHuntChallenge:ctor()
	self:createUI()
	self.sizeScrollViewPm = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.nodeRankItemNode = SoraDGetChildByName(self, "nodeRankItem_node")
	self.txtTip = SoraDGetChildByName(self, "Center_Text_Tip")
	self.cSSNodeRankBottomNode = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeRankBottom_node")
	self.nodeInfo = SoraDGetChildByName(self, "Top_Node_info")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_node")
	self.nodeTitle = SoraDGetChildByName(self, "Top_Node_title")
	self.bgTitle = SoraDGetChildByName(self, "bg_title")
	self.textReward = SoraDGetChildByName(self, "text_reward")
	self.textScore = SoraDGetChildByName(self, "text_score")
	self.textRank = SoraDGetChildByName(self, "text_rank")
	self.textName = SoraDGetChildByName(self, "text_name")
	self.textDes = SoraDGetChildByName(self, "Top_text_des")
	self.nodeRankItemNode:setVisible(false)
	self.nodeBg = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeBg_node", true)
	self.nodeBg:setPositionY(display.height - 960)
	self.scroll = include("commonAutoScrollList").new(self.sizeScrollViewPm)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.commonFramTitle_node:setTitle(i18n("alliance_hunt_text_01"))
	self.textDes:setString(i18n("alliance_hunt_text_09"))
	self.textScore:setString(i18n("alliance_hunt_text_24"))
	self.textName:setString(i18n("common_text_2037"))
	self.textRank:setString(i18n("common_text_2193"))
	self.rankList, _ENV = self.textRank.setString, self.textRank.setString
	self:init()
end
function allianceHuntChallenge:createSingle()
	local ocx = self.nodeRankItemNode:clone()
	local single = include("nodeRankItem").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setTimes(self.times)
	single:setHandle(handler(self, self.queryPlayerInfo))
	return ocx
end
function allianceHuntChallenge:initChallengeTimes(times)
	print("times==222=====", times)
	self.times = times or 1
end
function allianceHuntChallenge:queryPlayerInfo(data)
	if data then
		local playerID = data.rankData.uinfo.uid
		if playerID == 0 then
			return
		end
		local kid = data.sourceKid
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading(self)
	end
end
function allianceHuntChallenge:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function allianceHuntChallenge:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function allianceHuntChallenge:init(data)
	SoraDShowLoading()
	allianceHuntCtrl:reqQueryRank()
end
function allianceHuntChallenge:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_RANK_DATA_SUCCESS", handler(self, self.msgHuntRankDataSuccess))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HUNT_RANK_DATA_FAILED", handler(self, self.msgHuntRankDataFailed))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function allianceHuntChallenge:msgHuntRankDataSuccess(target, data)
	SoraDCloseLoading()
	self:updateRank()
	self:updateMyRank()
end
function allianceHuntChallenge:updateRank()
	self.rankList, allianceHuntCtrl = nil, nil
	local rankData = allianceHuntCtrl:getRankData()
	local myRank = rankData.myRank
	local robotData = rankData.robotData
	if not rankData.rankInfo then
		local allianceHuntCtrl, rankList = rankData.rankInfo, rankData.rankInfo
	end
	for _, v in ipairs(rankList) do
		if v.uid == 0 then
			allianceHuntCtrl = nil
			;(nil).parentView = self
			;(nil).nodeType = HUNTING_RANK_NODE_TYPE.CHALLENGE
			;(nil).rankType = HUNTING_RANK_TYPE.ROBOT
			;(nil).rankData = v
			table.insert(self.rankList, nil)
		else
			allianceHuntCtrl = nil
			;(nil).parentView = self
			;(nil).nodeType = HUNTING_RANK_NODE_TYPE.CHALLENGE
			;(nil).rankType = HUNTING_RANK_TYPE.PLAYER
			;(nil).rankData = v
			table.insert(self.rankList, nil)
		end
	end
	dump(self.rankList, "self.rankList,")
	allianceHuntCtrl = table.insert
	table.insert.scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 120), self.rankList, 1, table.insert)
end
function allianceHuntChallenge:updateMyRank()
	local rankData = allianceHuntCtrl:getRankData()
	local myRank = rankData.myRank
	if not myRank or myRank == 0 then
		self.cSSNodeRankBottomNode:init(nil)
		return
	end
	local myRankData = self.rankList[myRank]
	self.cSSNodeRankBottomNode:init(myRankData)
end
function allianceHuntChallenge:msgHuntRankDataFailed(target, data)
end
return allianceHuntChallenge
