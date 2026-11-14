local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local legendTeamUtil = include("legendTeamUtil")
local kingStarTeamInvitedView = class("kingStarTeamInvitedView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("kingStarTeamInvitedView")
	end
	return target
end)
function kingStarTeamInvitedView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("free_team_text_78"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("kingStarTeamInvitedSingle")
	kingStarTeamCtrl:reqTeamInitData()
end
function kingStarTeamInvitedView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO", handler(self, self.updateInviteInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_INVITE_BACK", handler(self, self.updateInviteBack))
end
function kingStarTeamInvitedView:updateTeamInfo(target, data)
	print("=====updateTeamInfo")
	if kingStarTeamCtrl:isHasTeam() then
		self:removeFromParent()
	else
		self:initData()
	end
end
function kingStarTeamInvitedView:updateInviteInfo(target, data)
	if kingStarTeamCtrl:isHasTeam() then
		SoraDCreatePanel("kingStarTeamView"):show()
		self:removeFromParent()
	else
		self:initData()
	end
end
function kingStarTeamInvitedView:updateInviteBack(target, data)
	SoraDCloseLoading(self)
	if data.err == gErrDef.Err_None then
		if kingStarTeamCtrl:isHasTeam() then
			SoraDCreatePanel("kingStarTeamView"):show()
			self:removeFromParent()
		else
			self:initData()
		end
	else
		self:errHandle(data.err)
	end
end
function kingStarTeamInvitedView:initData()
	if not kingStarTeamCtrl:getInvitedInfo() then
		kingStarTeamCtrl = kingStarTeamCtrl:getInvitedInfo()
	end
	self.list = kingStarTeamCtrl:getInvitedInfo()
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
	kingStarTeamCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).handlerInvite = handlerInvite
	self.scroll:updateScrollView(cc.size(536, 100), self.list, 1, nil)
end
function kingStarTeamInvitedView:doInvite(agree, data)
	if data and data.tid then
		if agree then
			local kingdomID = kingStarTeamCtrl:getLegendLordTeamOpenKingdomID() or worldMapDefine.KINGSTAR_KINGDOM_ID
			local err = legendTeamUtil.checkAgreeInviteTeam(data, kingdomID)
			if err == gErrDef.Err_None then
				kingStarTeamCtrl:reqAgreeInviteJoin(data.tid)
				SoraDShowLoading(self)
			else
				self:errHandle(err)
			end
		else
			kingStarTeamCtrl:reqRejectInviteJoin(data.tid)
			SoraDShowLoading(self)
		end
	end
end
function kingStarTeamInvitedView:errHandle(err)
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
return kingStarTeamInvitedView
