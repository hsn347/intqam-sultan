local legendTeamDef = include("legendTeamDef")
local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local kingStarTeamManageView = class("kingStarTeamManageView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingStarTeamManageView")
	end
	return target
end)
function kingStarTeamManageView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_187"))
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_icon")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setIsRight(SoraDFIsRA())
	self.scroll:setSingleCCS("kingStarTeamManageSingle")
	self:initData()
end
function kingStarTeamManageView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_FLAG", handler(self, self.updateFlag))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
end
function kingStarTeamManageView:updateTeamInfo(target, data)
	if not kingStarTeamCtrl:isHasTeam() or not kingStarTeamCtrl:isTeamLeader() then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function kingStarTeamManageView:updateFlag()
	local curFlag = kingStarTeamCtrl:getTeamFlag()
	self.nodeFlag:removeAllChildren()
	local allianceDesRead = include("allianceDesRead")
	allianceDesRead.getFlagWithParticle(curFlag, self.nodeFlag)
end
function kingStarTeamManageView:initData()
	self:updateFlag()
	self:initScroll()
end
function kingStarTeamManageView:initScroll()
	local tableManageData = legendTeamDef.TeamManageType
	tableManageData = table.values(tableManageData)
	table.sort(tableManageData)
	local legendTeamDef, tableData = table.sort, table.sort
	for _, v in ipairs(tableManageData) do
		legendTeamDef = nil
		;(nil).mid = v
		table.insert(tableData, nil)
	end
	local itemSize = cc.size(200, 155)
	legendTeamDef = tableData
	tableData.scroll = self.scroll
	tableData.view = self
	self.scroll:updateScrollView(itemSize, tableData, 3, tableData)
end
return kingStarTeamManageView
