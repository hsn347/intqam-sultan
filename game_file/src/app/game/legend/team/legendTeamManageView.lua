local legendTeamDef = include("legendTeamDef")
local gametop = gModuleMgr.getObject("gametop")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local legendTeamManageView = class("legendTeamManageView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendTeamManageView")
	end
	return target
end)
function legendTeamManageView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_187"))
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_icon")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setIsRight(SoraDFIsRA())
	self.scroll:setSingleCCS("legendTeamManageSingle")
	self:initData()
end
function legendTeamManageView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_CHANGE_FLAG", handler(self, self.updateFlag))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
end
function legendTeamManageView:updateTeamInfo(target, data)
	if not legendTeamCtrl:isHasTeam() or not legendTeamCtrl:isTeamLeader() then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function legendTeamManageView:updateFlag()
	local curFlag = legendTeamCtrl:getTeamFlag()
	self.nodeFlag:removeAllChildren()
	local allianceDesRead = include("allianceDesRead")
	allianceDesRead.getFlagWithParticle(curFlag, self.nodeFlag)
end
function legendTeamManageView:initData()
	self:updateFlag()
	self:initScroll()
end
function legendTeamManageView:initScroll()
	local tableManageData = legendTeamDef.TeamManageType_legend
	tableManageData = table.values(tableManageData)
	table.sort(tableManageData)
	local legendTeamDef, tableData = table.sort, table.sort
	for _, v in ipairs(tableManageData) do
		if not IsArClient and v == legendTeamDef.TeamManageType_legend.COMMANDERS then
		else
			legendTeamDef = nil
			;(nil).mid = v
			table.insert(tableData, nil)
		end
	end
	local itemSize = cc.size(200, 155)
	legendTeamDef = tableData
	tableData.scroll = self.scroll
	tableData.view = self
	self.scroll:updateScrollView(itemSize, tableData, 3, tableData)
end
return legendTeamManageView
