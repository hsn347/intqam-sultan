local gametop = gModuleMgr.getObject("gametop")
local legendStageRewardCtrl = gametop.playertop_:getModule("legendStageRewardCtrl")
local legendTeamDef = include("legendTeamDef")
local legendaryStageRank = class("legendaryStageRank", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendaryStageRank")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendaryStageRank:ctor()
	self:createUI()
	self.nodeBg_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_nodeBg_node", true)
	self.sizeScrollViewPm = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.nodeStageRankItemNode = SoraDGetChildByName(self, "nodeStageRankItem_node")
	self.txtTip = SoraDGetChildByName(self, "Center_Text_Tip")
	self.txtTip:setString(i18n("common_text_927"))
	self.txtTip:setVisible(false)
	self.nodeStageRankBottom_node = SoraDGetExtendChildFromCCSByName(self, "CCS_nodeStageRankBottom_node")
	self.nodeInfo = SoraDGetChildByName(self, "Top_Node_info")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_node")
	self.nodeTitle = SoraDGetChildByName(self, "Top_Node_title")
	self.bgTitle = SoraDGetChildByName(self, "bg_title")
	self.textScore = SoraDGetChildByName(self, "text_score")
	self.textRank = SoraDGetChildByName(self, "text_rank")
	self.textName = SoraDGetChildByName(self, "text_name")
	self.nodeStageRankItemNode:setVisible(false)
	self.scroll = include("commonAutoScrollList").new(self.sizeScrollViewPm)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.textScore:setString(i18n("common_text_1764"))
	self.textName:setString(i18n("common_text_264"))
	self.textRank:setString(i18n("common_text_2193"))
end
function legendaryStageRank:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendaryStageRank:createSingle()
	local ocx = self.nodeStageRankItemNode:clone()
	local single = include("nodeStageRankItem").new(ocx)
	single:setVisible(true)
	single:setScroll(self.scroll)
	single:setHandle(handler(self, self.queryPlayerInfo))
	return ocx
end
function legendaryStageRank:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
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
function legendaryStageRank:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function legendaryStageRank:init(stageType)
	SoraDShowLoading(self)
	legendStageRewardCtrl:reqRank(1, legendTeamDef.TEAM_MEMBER_MAX)
	if stageType == gLegendStageType.KING then
		self.commonFramTitle_node:setTitle(i18n("legendaryking_text_34"))
	elseif stageType == gLegendStageType.KING_STAR then
		self.commonFramTitle_node:setTitle(i18n("kingstarbattle_text_41"))
	elseif stageType == gLegendStageType.HEGEMON then
		self.commonFramTitle_node:setTitle(i18n("hegemon_text_54"))
	end
end
function legendaryStageRank:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_STAGE_RANK_DATA_SUCCESS", handler(self, self.msgRankDataSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_STAGE_RANK_DATA_FAILED", handler(self, self.msgRankDataFailed))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function legendaryStageRank:msgRankDataSuccess(target, data)
	SoraDCloseLoading(self)
	self:updateRank()
	self:updateMyRank()
end
function legendaryStageRank:msgRankDataFailed(target, data)
	SoraDCloseLoading(self)
end
function legendaryStageRank:updateRank()
	self.rankList, legendStageRewardCtrl = nil, nil
	local rankData = legendStageRewardCtrl:getRankList()
	local legendStageRewardCtrl, rankList = legendStageRewardCtrl, rankData or legendStageRewardCtrl
	for _, v in ipairs(rankList) do
		table.insert(self.rankList, v)
	end
	dump(self.rankList, "self.rankList,")
	legendStageRewardCtrl = table.insert
	table.insert.scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 120), self.rankList, 1, table.insert)
	if #self.rankList == 0 then
		self.txtTip:setVisible(true)
	end
end
function legendaryStageRank:updateMyRank()
	local myRank = legendStageRewardCtrl:getMyRank()
	if not myRank or myRank.rank == 0 then
		self.nodeStageRankBottom_node:init(nil)
		return
	end
	local rankList = legendStageRewardCtrl:getRankList()
	local myRankData = rankList[myRank.rank]
	self.nodeStageRankBottom_node:init(myRankData)
end
function legendaryStageRank:msgHuntRankDataFailed(target, data)
	SoraDCloseLoading(self)
end
return legendaryStageRank
