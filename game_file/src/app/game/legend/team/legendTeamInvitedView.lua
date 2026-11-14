local gametop = gModuleMgr.getObject("gametop")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local legendTeamUtil = include("legendTeamUtil")
local legendTeamInvitedView = class("legendTeamInvitedView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("legendTeamInvitedView")
	end
	return target
end)
function legendTeamInvitedView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("free_team_text_78"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("legendTeamInvitedSingle")
	legendTeamCtrl:reqTeamInitData()
end
function legendTeamInvitedView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO", handler(self, self.updateInviteInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_INVITE_BACK", handler(self, self.updateInviteBack))
end
function legendTeamInvitedView:updateTeamInfo(target, data)
	print("=====updateTeamInfo")
	if legendTeamCtrl:isHasTeam() then
		self:removeFromParent()
	else
		self:initData()
	end
end
function legendTeamInvitedView:updateInviteInfo(target, data)
	if legendTeamCtrl:isHasTeam() then
		SoraDCreatePanel("legendTeamView"):show()
		self:removeFromParent()
	else
		self:initData()
	end
end
function legendTeamInvitedView:updateInviteBack(target, data)
	SoraDCloseLoading(self)
	if data.err == gErrDef.Err_None then
		if legendTeamCtrl:isHasTeam() then
			SoraDCreatePanel("legendTeamView"):show()
			self:removeFromParent()
		else
			self:initData()
		end
	else
		self:errHandle(data.err)
	end
end
function legendTeamInvitedView:initData()
	if not legendTeamCtrl:getInvitedInfo() then
		legendTeamCtrl = legendTeamCtrl:getInvitedInfo()
	end
	self.list = legendTeamCtrl:getInvitedInfo()
	if not next(self.list) then
		self:removeFromParent()
		return
	end
	table.sort(self.list, function(a, b)
		if a.time ~= b.time then
			return b.time < a.time
		end
		return a.tid < b.tid
	end)
	local handlerInvite = handler(self, self.doInvite)
	legendTeamCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).handlerInvite = handlerInvite
	self.scroll:updateScrollView(cc.size(536, 100), self.list, 1, nil)
end
function legendTeamInvitedView:doInvite(agree, data)
	if data and data.tid then
		if agree then
			local err = legendTeamUtil.checkAgreeInviteTeam(data)
			if err == gErrDef.Err_None then
				legendTeamCtrl:reqAgreeInviteJoin(data.tid)
				SoraDShowLoading(self)
			else
				self:errHandle(err)
			end
		else
			legendTeamCtrl:reqRejectInviteJoin(data.tid)
			SoraDShowLoading(self)
		end
	end
end
function legendTeamInvitedView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = legendTeamUtil.getErrType(err)
	if errType == legendTeamUtil.errType.TIPS then
		legendTeamUtil.errShowTips(err)
	elseif errType == legendTeamUtil.errType.CLOSE then
		legendTeamUtil.errShowTips(err)
		self:removeFromParent()
	end
end
return legendTeamInvitedView
