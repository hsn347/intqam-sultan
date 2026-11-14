local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarRead = include("remainsWarRead")
local teamDef = include("teamDef")
local teamDetailsView = class("teamDetailsView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("teamDetailsView")
	end
	return target
end)
function teamDetailsView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("remains_text_156"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_team")
	self.txtScoreNum = SoraDGetChildByName(self, "Text_score_num")
	self.spScore = SoraDGetChildByName(self, "Sprite_score")
	self.framehead = SoraDGetChildByName(self, "frame_head")
	if self.framehead then
		self.framehead:addTouchEventListener(handler(self, self.btnClickHeadCallBack))
	end
	self.nodeMember = SoraDGetChildByName(self, "Node_member")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.icon_head = SoraDGetChildByName(self, "icon_head")
	self.txtTeamName = SoraDGetChildByName(self, "Text_team_name")
	self.txtTeamNum = SoraDGetChildByName(self, "Text_team_num")
end
function teamDetailsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_INFO", handler(self, self.rspTeeamInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function teamDetailsView:rspTeeamInfo(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:removeFromParent()
	else
		local teamInfo = data.teamInfo
		self:initData(teamInfo)
	end
end
function teamDetailsView:initView(teamId)
	self:req4Data(teamId)
end
function teamDetailsView:initAnchorView(teamId)
	local anchorCtrl = gametop.playertop_:getModule("anchorCtrl")
	anchorCtrl:reqAnchorRwTeamMembers(teamId)
	SoraDShowLoading(self)
end
function teamDetailsView:req4Data(teamId)
	remainsTeamCtrl:reqGetTeamInfo(teamId)
	SoraDShowLoading(self)
end
function teamDetailsView:initData(data)
	self.tableSingleData = data
	self.memberList = teamDef.transMemberList(self.tableSingleData.memberList)
	self:updateTeamName()
	self:updateTeamInfo()
	self:updateLeaderInfo()
end
function teamDetailsView:updateTeamName()
	self.txtTeamName:setString(self.tableSingleData.name)
	_ENV = nil
	;(nil).member = #self.memberList
	;(nil).total = _G.TEAM_MEMBER_MAX
	self.txtTeamNum:setString("(" .. i18n("common_text_155", nil) .. ")")
end
function teamDetailsView:updateLeaderInfo()
	local leaderInfo
	for _, v in ipairs(self.memberList) do
		if v.uid == self.tableSingleData.leader then
			leaderInfo = v
			break
		end
	end
	if leaderInfo then
		self.leaderInfo = leaderInfo
		local name = leaderInfo.nickName
		if leaderInfo.allianceAbbr then
			_ENV = nil
			;(nil).abbr = leaderInfo.allianceAbbr
			;(nil).name = leaderInfo.nickName
			name = i18n("common_text_186", nil)
		end
		if leaderInfo.kid then
			name = name .. "#" .. tostring(leaderInfo.kid)
		end
		self.txtName:setString(name)
		local strScoreNum = string.formatnumberthousands(leaderInfo.rankScore)
		self.txtScoreNum:setString(strScoreNum)
		local imgScore = remainsWarRead.getDanIcon(leaderInfo.segment)
		self.spScore:setSpriteFrame(imgScore)
		local x, y = self.spScore:getPosition()
		_ENV = nil
		;(nil).parent = self.spScore:getParent()
		;(nil).pos = cc.p(x, y - 10)
		;(nil).scale = 0.3
		SoraDGetRemainsWarStartNode(leaderInfo.star or 0, nil)
		if leaderInfo.headid then
			SoraDGetHeadFromManager(self.icon_head, leaderInfo.headid, leaderInfo.avatar)
		else
			self.icon_head:setVisible(false)
		end
	end
end
function teamDetailsView:updateTeamInfo()
	if self.memberList then
		for i, v in ipairs(self.memberList) do
			local single = SoraDCreatePanel("teamDetailsMember")
			single:setScroll(self.scroll)
			single:addTo(self.nodeMember)
			single:setPosition(0, -(i - 1) * 100)
			single:setHandle(handler(self, self.queryPlayerInfo))
			single:initData(v)
		end
		local sSize = self.scroll:getContentSize()
		local listHeight = 100 * #self.memberList
		local sH = math.max(sSize.height, listHeight)
		self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
		self.nodeMember:setPositionY(sH)
	end
end
function teamDetailsView:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		local kid = data.kid
		self._queryInfo = true
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading(self)
	end
end
function teamDetailsView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function teamDetailsView:btnClickHeadCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.leaderInfo then
			self:queryPlayerInfo(self.leaderInfo)
		end
	end
end
return teamDetailsView
