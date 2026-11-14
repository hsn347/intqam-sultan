local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local legendTeamUtil = include("legendTeamUtil")
local legendTeamDef = include("legendTeamDef")
local allianceDesRead = include("allianceDesRead")
local teamDef = include("teamDef")
local kingStarTeamView = class("kingStarTeamView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingStarTeamView")
	end
	return target
end)
function kingStarTeamView:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("free_team_text_41"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnRename = SoraDGetChildByName(self, "Button_rename")
	self.txtTeamName = SoraDGetChildByName(self, "Text_team_name")
	self.txtTeamCount = SoraDGetChildByName(self, "Text_teamCount")
	self.txtTeamTitle = SoraDGetChildByName(self, "Text_teamTitle")
	self.txtTeamTitle:setString(i18n("remains_text_125"))
	self.txtTeamTota = SoraDGetChildByName(self, "Text_teamTota")
	self.txtTeamTota:setString("/" .. legendTeamDef.TEAM_MEMBER_MAX .. ")")
	self.frameLaceL = SoraDGetChildByName(self, "frame_title_lace_L")
	self.frameLaceR = SoraDGetChildByName(self, "frame_title_lace_R")
	self.spTeamFlag = SoraDGetChildByName(self, "Sprite_team_flag")
	self.btnTeamDissolve = SoraDGetChildByName(self, "Button_team_dissolve")
	self.btnTeamApproval = SoraDGetChildByName(self, "Button_team_approval")
	self.btnTeamInvited = SoraDGetChildByName(self, "Button_team_invited")
	self.btnTeamWar = SoraDGetChildByName(self, "Button_alliance")
	self.btnTeamFlag = SoraDGetChildByName(self, "Button_flag")
	self.nodeTeamOpLeader = SoraDGetChildByName(self, "Node_op_leader")
	self.nodeTeamOpMember = SoraDGetChildByName(self, "Node_op_member")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.nodeWarRed = SoraDGetChildByName(self.btnTeamWar, "Sprite_green")
	self.txtWarRed = SoraDGetChildByName(self.btnTeamWar, "Text_green")
	self.nodeWarRed:setVisible(false)
	self.txtTeamDissolve = SoraDGetChildByName(self, "Text_team_dissolve")
	self.spRedPoint = SoraDGetChildByName(self, "Sprite_RedPoint")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("kingStarTeamMember")
	self.btnTeamDissolve:addTouchEventListener(handler(self, self.onClick_btnTeamDissolve))
	self.btnTeamApproval:addTouchEventListener(handler(self, self.onClick_btnTeamApproval))
	self.btnTeamInvited:addTouchEventListener(handler(self, self.onClick_btnTeamInvited))
	self.btnRename:addTouchEventListener(handler(self, self.onClick_btnRename))
	self.btnTeamWar:addTouchEventListener(handler(self, self.onClick_btnTeamWar))
	self.btnTeamFlag:addTouchEventListener(handler(self, self.onClick_btnTeamFlag))
	self.btnTeamApproval:setTitleText(i18n("free_team_text_48"))
	SoraDAutoSizeButtonTextByContent(self.btnTeamApproval)
	self.btnTeamInvited:setTitleText(i18n("remains_btn_10"))
	SoraDAutoSizeButtonTextByContent(self.btnTeamInvited)
	self.btnTeamDissolve:setTitleText(i18n("remains_btn_09"))
	SoraDAutoSizeButtonTextByContent(self.btnTeamDissolve)
	self.btnTeamWar:setTitleText(i18n("free_team_text_47"))
	SoraDAutoSizeButtonTextByContent(self.btnTeamWar)
	self.memberList, _ENV, self.myTeamInfo, _ENV = SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent
	self.tableBtn, _ENV, self.flag = SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent, nil
	self.tableBtn[1] = SoraDGetChildByName(self, "Button_team")
	self.tableBtn[1]:setTitleText(i18n("remains_text_85"))
	self.tableBtn[1]:setTitleColor(cc.c3b(255, 245, 176))
	self.tableBtn[1]:setTouchEnabled(false)
	self.tableBtn[1]:setBright(true)
	self.tableBtn[2] = SoraDGetChildByName(self, "Button_alliance")
	self.tableBtn[2]:setTitleColor(cc.c3b(144, 132, 97))
	self.tableBtn[2]:setTouchEnabled(true)
	self.tableBtn[2]:setBright(false)
	self:initView()
	self:req4Data()
end
function kingStarTeamView:req4Data()
	kingStarTeamCtrl:reqGetMemberInfo()
end
function kingStarTeamView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_QUIT_BACK", handler(self, self.rspQuitTeam))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_MEMBER_EXPEL", handler(self, self.rspMemberExpel))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_MEMBER_INFO_BACK", handler(self, self.updateScrollList))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateGreenPointAlliance))
end
function kingStarTeamView:initView()
	local myTeamInfo = kingStarTeamCtrl:getMyTeamInfo()
	self.myTeamInfo = myTeamInfo
	self.memberList = myTeamInfo:getTeamMemberList()
	self:updateScrollList()
	self:updateBtnStatus()
	self:updateRedPoint()
	self:updateMsgBox()
	self:updateFlag()
	self:updateGreenPointAlliance()
end
function kingStarTeamView:updateMsgBox()
	if self.msgBox and not tolua.isnull(self.msgBox) and self.isOldLeader ~= self:isTeamLeader() then
		self.msgBox:closePanel()
		self.msgBox = nil
	end
	self.isOldLeader = self:isTeamLeader()
end
function kingStarTeamView:updateRedPoint()
	local isTeamApproval = kingStarTeamCtrl:isTeamHasApproval()
	local isNotFull = #self.memberList < legendTeamDef.TEAM_MEMBER_MAX
	self.spRedPoint:setVisible(isTeamApproval and isNotFull)
end
function kingStarTeamView:updateTeamInfo(target, data)
	if not kingStarTeamCtrl:isHasTeam() then
		SoraDRemoveAllAfterPanelFromManager(self)
	else
		self:initView()
	end
end
function kingStarTeamView:updateTeamBase()
	local name = self.myTeamInfo:getTeamName()
	self.txtTeamName:setString(name)
	self.txtTeamCount:setString("(" .. tostring(#self.memberList))
	if SoraDFIsRA() then
		_UPVALUE5_ = "(" .. tostring(#self.memberList)
		;("(" .. tostring(#self.memberList))[1] = self.frameLaceR
		;("(" .. tostring(#self.memberList))[2] = self.txtTeamTitle
		;("(" .. tostring(#self.memberList))[3] = self.txtTeamTota
		;("(" .. tostring(#self.memberList))[4] = self.txtTeamCount
		;("(" .. tostring(#self.memberList))[5] = self.frameLaceL
		_UPVALUE4_ = self.txtTeamTitle
		self.txtTeamTitle[1] = 10
		self.txtTeamTitle[2] = 5
		self.txtTeamTitle[3] = 0
		self.txtTeamTitle[4] = 10
		_G.SoraDAlignNodeArrayOnCenterX(0, "(" .. tostring(#self.memberList), true, self.txtTeamTitle)
	else
		_UPVALUE5_ = "(" .. tostring(#self.memberList)
		;("(" .. tostring(#self.memberList))[1] = self.frameLaceR
		;("(" .. tostring(#self.memberList))[2] = self.txtTeamTota
		;("(" .. tostring(#self.memberList))[3] = self.txtTeamCount
		;("(" .. tostring(#self.memberList))[4] = self.txtTeamTitle
		;("(" .. tostring(#self.memberList))[5] = self.frameLaceL
		_UPVALUE4_ = self.txtTeamTota
		self.txtTeamTota[1] = 10
		self.txtTeamTota[2] = 0
		self.txtTeamTota[3] = 5
		self.txtTeamTota[4] = 10
		_G.SoraDAlignNodeArrayOnCenterX(0, "(" .. tostring(#self.memberList), true, self.txtTeamTota)
	end
	local width = self.txtTeamName:getContentSize().width / 2 + 25
	self.spTeamFlag:setPositionX(SoraDFIsRA() and width or -width)
	self.btnRename:setPositionX(SoraDFIsRA() and -width or width)
end
function kingStarTeamView:updateBtnStatus()
	local isLeader = self:isTeamLeader()
	self.nodeTeamOpLeader:setVisible(isLeader)
	self.nodeTeamOpMember:setVisible(not isLeader)
	self.btnRename:setVisible(isLeader)
	self.btnTeamFlag:setVisible(isLeader)
end
function kingStarTeamView:updateFlag()
	local curFlag = self.myTeamInfo:getTeamFlag()
	if self.flag ~= curFlag then
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(curFlag, self.nodeFlag)
	end
end
function kingStarTeamView:updateGreenPointAlliance()
	if worldMapDefine.isInLegendLord() then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local allianceCount = kingdomMapCtrl:getHallWarCount()
		self.txtWarRed:setString(allianceCount)
		self.nodeWarRed:setVisible(0 < allianceCount)
	end
end
function kingStarTeamView:isTeamLeader()
	return self.myTeamInfo:isTeamLeader()
end
function kingStarTeamView:updateScrollData()
	local leader = self.myTeamInfo:getTeamLeader()
	local isSelfLeader = self:isTeamLeader()
	for i, v in ipairs(self.memberList) do
		v.isLeader = v.uid == leader
		v.isSelfLeader = isSelfLeader
		v.index = i
	end
	table.sort(self.memberList, function(team1, team2)
		if team1.isLeader ~= team2.isLeader then
			return team1.isLeader
		end
		if team1.inBattleField ~= team2.inBattleField then
			return team1.inBattleField
		end
		if team1.totalFc ~= team2.totalFc then
			return team2.totalFc < team1.totalFc
		end
		if team1.cityLevel ~= team2.cityLevel then
			return team2.cityLevel < team1.cityLevel
		end
		if team1.index ~= team2.index then
			return team1.index < team2.index
		end
		return team1.uid < team2.uid
	end)
	local handlerOut = handler(self, self.memberOut)
	local handlerPlayer = handler(self, self.queryPlayerInfo)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).handlerPlayer = handlerPlayer
	;(nil).handlerOut = handlerOut
	self.scroll:updateScrollView(cc.size(640, 115), self.memberList, 1, nil)
end
function kingStarTeamView:updateScrollList()
	self:updateTeamBase()
	self:updateScrollData()
end
function kingStarTeamView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function kingStarTeamView:rspQuitTeam(target, data)
	if data.err ~= gErrDef.Err_None then
		SoraDCloseLoading(self)
		if data.err == gErrDef.Err_RUINS_WAR_TEAM_STATE_ERR then
			SoraDShowMsgTip(i18n("notice_0026"))
		else
			self:errHandle(data.err)
		end
	else
		self:removeFromParent()
	end
end
function kingStarTeamView:rspMemberExpel(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		self:initView()
	end
end
function kingStarTeamView:onClick_btnTeamDissolve(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local err = legendTeamUtil.checkQuitTeam(worldMapDefine.KINGSTAR_KINGDOM_ID)
		if err == gErrDef.Err_None then
			self.msgBox = SoraDShowMsgBox(i18n("remains_text_35"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
					kingStarTeamCtrl:reqQuitTeam()
					SoraDShowLoading(self)
				end
				self.msgBox = nil
			end)
		elseif err == gErrDef.Err_TEAM_NOT_IN_SELF_KID then
			if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
				SoraDShowMsgTip(i18n("kingstarbattle_text_03"))
			else
				SoraDShowMsgTip(i18n("free_team_text_18"))
			end
		else
			self:errHandle(err)
		end
	end
end
function kingStarTeamView:onClick_btnTeamApproval(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("kingStarTeamManageView")
		panel:show()
	end
end
function kingStarTeamView:onClick_btnTeamInvited(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("kingStarTeamApprovalListInviteView")
		panel:show()
	end
end
function kingStarTeamView:onClick_btnRename(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("kingStarTeamCreateView")
		panel:initChangeView(self.myTeamInfo:getTeamNameRaw(), self.myTeamInfo:getTeamAbbr())
		panel:show()
	end
end
function kingStarTeamView:onClick_btnTeamWar(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInLegendLord() then
			local panel = uiManager:show("AllianceWarView")
			panel.view:setShowTeamTab(worldMapDefine.KINGSTAR_KINGDOM_ID)
			self:removeFromParent()
		else
			SoraDShowMsgTip(i18n("kingstarbattle_text_34"))
		end
	end
end
function kingStarTeamView:onClick_btnTeamFlag(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if kingStarTeamCtrl:isHasTeam() then
			local panel = SoraDCreatePanel("kingStarTeamChangeFlagView")
			panel:show()
		end
	end
end
function kingStarTeamView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		legendTeamUtil.openHelp(worldMapDefine.KINGSTAR_KINGDOM_ID)
	end
end
function kingStarTeamView:queryPlayerInfo(data)
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
function kingStarTeamView:isCanInvited()
	return true
end
function kingStarTeamView:queryTeamPlayerInfo(data)
end
function kingStarTeamView:memberOut(data)
	if data and data.uid then
		local err = legendTeamUtil.checkExpelMember(data, worldMapDefine.KINGSTAR_KINGDOM_ID)
		if err == gErrDef.Err_None then
			self.msgBox = SoraDShowMsgBox(i18n("free_team_text_42"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
					kingStarTeamCtrl:reqExpelMember(data.uid)
					SoraDShowLoading(self)
				end
				self.msgBox = nil
			end)
		else
			self:errHandle(err)
		end
	end
end
function kingStarTeamView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = legendTeamUtil.getErrType(err)
	if errType == legendTeamUtil.errType.TIPS then
		if errType == gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER then
			if self:isTeamLeader() then
				SoraDShowMsgTip(i18n("remains_text_141"))
			else
				SoraDShowMsgTip(i18n("remains_text_120"))
			end
		else
			legendTeamUtil.errShowTips(err)
		end
	elseif errType == legendTeamUtil.errType.CLOSE then
		legendTeamUtil.errShowTips(err)
		self:removeFromParent()
	end
end
return kingStarTeamView
