local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local legendTeamUtil = include("legendTeamUtil")
local kingStarTeamChangeLeaderView = class("kingStarTeamChangeLeaderView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("kingStarTeamChangeLeaderView")
	end
	return target
end)
function kingStarTeamChangeLeaderView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("free_team_text_43"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("kingStarTeamChangeLeaderSingle")
	self.Text_none = SoraDGetChildByName(self, "Text_none")
	self.Text_none:setString(i18n("free_team_text_73"))
	self.Text_none:setVisible(false)
	self:initData()
end
function kingStarTeamChangeLeaderView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_LEADER_CHANGE", handler(self, self.rspTeamOp))
end
function kingStarTeamChangeLeaderView:rspTeamOp(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	end
end
function kingStarTeamChangeLeaderView:updateTeamInfo(target, data)
	if not kingStarTeamCtrl:isHasTeam() or not kingStarTeamCtrl:isTeamLeader() then
		self:closeView()
	else
		self:initData()
	end
end
function kingStarTeamChangeLeaderView:closeView()
	if self.msgBox and not tolua.isnull(self.msgBox) then
		self.msgBox:closePanel()
		self.msgBox = nil
	end
	self:removeFromParent()
end
function kingStarTeamChangeLeaderView:initData()
	local myTeamInfo = kingStarTeamCtrl:getMyTeamInfo()
	local memberList = myTeamInfo:getTeamMemberList()
	local leader = myTeamInfo:getTeamLeader()
	for i, v in ipairs(memberList) do
		if v.uid == leader then
			table.remove(memberList, i)
			break
		end
	end
	self.Text_none:setVisible(#memberList < 1)
	local handlerChange = handler(self, self.changeTeamLeader)
	kingStarTeamCtrl = memberList
	memberList.scroll = self.scroll
	memberList.handlerChange = handlerChange
	self.scroll:updateScrollView(cc.size(536, 100), memberList, 1, memberList)
end
function kingStarTeamChangeLeaderView:changeTeamLeader(data)
	if data and data.uid then
		self.msgBox = SoraDShowMsgBox(i18n("free_team_text_44"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				kingStarTeamCtrl:reqDemiseTeam(data.uid)
				SoraDShowLoading(self)
			end
			self.msgBox = nil
		end)
	end
end
function kingStarTeamChangeLeaderView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = legendTeamUtil.getErrType(err)
	if errType == legendTeamUtil.errType.TIPS then
		legendTeamUtil.errShowTips(err)
	elseif errType == legendTeamUtil.errType.CLOSE then
		legendTeamUtil.errShowTips(err)
		self:closeView()
	end
end
return kingStarTeamChangeLeaderView
