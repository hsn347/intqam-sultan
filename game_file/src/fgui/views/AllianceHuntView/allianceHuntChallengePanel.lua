local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceHuntChallengePanel = class("allianceHuntChallengePanel", baseFguiPanel)
function allianceHuntChallengePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceHuntChallengePanel:ctor", self.viewName)
end
function allianceHuntChallengePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceHuntChallengePanel:onInit()
	print("=======allianceHuntChallengePanel:onInit")
	self.sizeScrollViewPm = SoraDGetChildByName(self, "Size_ScrollView_pm")
	self.txtTip = SoraDGetChildByName(self, "Center_Text_Tip")
	self.cSSNodeRankBottomNode = SoraDGetChildByName(self, "CCS_nodeRankBottom_node")
	self.imgCellColor = SoraDGetChildByName(self, "Top_Image_cell_color")
	self.textDes = self.imgCellColor
	self.commonFramTitle_node = SoraDGetChildByName(self, "Top_Node_info")
	self.nodeTitle = SoraDGetChildByName(self, "Top_Node_title")
	self.bgTitle = SoraDGetChildByName(self, "bg_title")
	self.textReward = SoraDGetChildByName(self, "text_reward")
	self.textScore = SoraDGetChildByName(self, "text_score")
	self.textRank = SoraDGetChildByName(self, "text_rank")
	self.textName = SoraDGetChildByName(self, "text_name")
	self.textDes:setTitle(i18n("alliance_hunt_text_09"))
	self.textScore:setString(i18n("alliance_hunt_text_24"))
	self.textRank:setString(i18n("common_text_2193"))
	self.textName:setString(i18n("common_text_264"))
	self.commonFramTitle_node:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.scroll = self.fields.scroll
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.nodeTitle:fixChildrenPos()
	self:init()
end
function allianceHuntChallengePanel:onShow()
	print("=======allianceHuntChallengePanel:onShow")
end
function allianceHuntChallengePanel:initChallengeTimes(times)
	print("times==222=====", times)
	self.times = times or 1
end
function allianceHuntChallengePanel:init(data)
	SoraDShowLoading()
	allianceHuntCtrl:reqQueryRank()
end
function allianceHuntChallengePanel:onItemRenderer(index, single)
	local data = self.rankList[index + 1]
	single:setTimes(self.times)
	single:setHandle(handler(self, self.queryPlayerInfo))
	single:initData(data)
end
function allianceHuntChallengePanel:queryPlayerInfo(data)
	if data then
		local playerID = data.rankData.uinfo.uid
		if playerID == 0 then
			return
		end
		local kid = data.rankData.uinfo.sourceKid
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.view:getName()
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading(self)
	end
end
function allianceHuntChallengePanel:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function allianceHuntChallengePanel:msgHuntRankDataSuccess(target, data)
	SoraDCloseLoading()
	self:updateRank()
	self:updateMyRank()
end
function allianceHuntChallengePanel:updateRank()
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
	self.scroll:setNumItems(#self.rankList)
end
function allianceHuntChallengePanel:updateMyRank()
	local rankData = allianceHuntCtrl:getRankData()
	local myRank = rankData.myRank
	if not myRank or myRank == 0 then
		self.cSSNodeRankBottomNode:init(nil)
		return
	end
	local myRankData = self.rankList[myRank]
	self.cSSNodeRankBottomNode:init(myRankData, true)
end
function allianceHuntChallengePanel:msgHuntRankDataFailed(target, data)
end
return allianceHuntChallengePanel
