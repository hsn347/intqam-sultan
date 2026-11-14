local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarUtil = include("remainsWarUtil")
local RUINS_WAR_TEAM_STATE = _G.RUINS_WAR_TEAM_STATE
local myTeamView = class("myTeamView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("myTeamView")
	end
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function myTeamView:ctor()
	self.listNode, _ENV, self.scrollItems, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("remains_title_01"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnHelp:setVisible(IsArClient)
	self.btnShare = SoraDGetChildByName(self, "btn_share")
	self.btnShare:setTouchEnabled(true)
	self.btnShare:addTouchEventListener(handler(self, self.onClick_btn_share))
	self.btnChat = SoraDGetChildByName(self, "btn_chat")
	self.btnChat:setTouchEnabled(true)
	self.btnChat:addTouchEventListener(handler(self, self.onClick_btn_chat))
	self.nodeChat = SoraDGetChildByName(self, "Node_chat")
	self.spRedPointChat = SoraDGetChildByName(self, "Sprite_RedPoint_chat")
	self.nodeMatchAnimation = SoraDGetChildByName(self, "Node_match_animation")
	self.panelLoadUpgrade = SoraDGetChildByName(self, "Panel_skillLoader")
	self.txtTeamName = SoraDGetChildByName(self, "Text_team_name")
	self.txtMatchTimeTitle = SoraDGetChildByName(self, "Text_match_time_title")
	self.txtMatchTimeNum = SoraDGetChildByName(self, "Text_match_time_num")
	self.txtMatchTimeNum = SoraDCreateTimerLabel(self, self.txtMatchTimeNum)
	self.txtMatchTimeNum:setTimeUpdateListener(function(ticket)
		_UPVALUE2_ = nil
		;(nil)[1] = self.txtMatchTimeNum
		;(nil)[2] = self.txtMatchTimeTitle
		self = self.txtMatchTimeTitle
		self.txtMatchTimeTitle[1] = 10
		_G.SoraDAlignNodeArrayOnCenterX(0, nil, not SoraDFIsRA(), self.txtMatchTimeTitle)
	end)
	self.txtMatchTitle = SoraDGetChildByName(self, "Text_match_title")
	self.txtTeamScoreTitle = SoraDGetChildByName(self, "Text_team_score_title")
	self.txtTeamScoreNum = SoraDGetChildByName(self, "Text_team_score_num")
	self.txtTeamTips = SoraDGetChildByName(self, "Text_team_tips")
	self.txtTeamTips:setVisible(false)
	self.txtTeamCount = SoraDGetChildByName(self, "Text_teamCount")
	self.txtTeamTitle = SoraDGetChildByName(self, "Text_teamTitle")
	self.txtTeamTitle:setString(i18n("remains_text_125"))
	self.txtTeamTota = SoraDGetChildByName(self, "Text_teamTota")
	self.txtTeamTota:setString("/" .. _G.TEAM_MEMBER_MAX .. ")")
	self.frameLaceL = SoraDGetChildByName(self, "frame_title_lace_L")
	self.frameLaceR = SoraDGetChildByName(self, "frame_title_lace_R")
	self.txtTeamScoreTitle:setString(i18n("remains_text_27"))
	self.spTeamFlag = SoraDGetChildByName(self, "Sprite_team_flag")
	self.btnTeamDissolve = SoraDGetChildByName(self, "Button_team_dissolve")
	self.btnTeamApproval = SoraDGetChildByName(self, "Button_team_approval")
	self.btnTeamInvited = SoraDGetChildByName(self, "Button_team_invited")
	self.btnMatch = SoraDGetChildByName(self, "Button_match")
	self.btnMatch:addTouchEventListener(handler(self, self.onClick_btnMatch))
	self.nodeTeamOperator = SoraDGetChildByName(self, "Node_team_operator")
	self.txtTeamDissolve = SoraDGetChildByName(self, "Text_team_dissolve")
	self.spRedPoint = SoraDGetChildByName(self, "Sprite_RedPoint")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_team")
	self.nodeMember = SoraDGetChildByName(self, "Node_member")
	self.btnTeamDissolve:addTouchEventListener(handler(self, self.onClick_btnTeamDissolve))
	self.btnTeamApproval:addTouchEventListener(handler(self, self.onClick_btnTeamApproval))
	self.btnTeamInvited:addTouchEventListener(handler(self, self.onClick_btnTeamInvited))
	self.btnTeamApproval:setTitleText(i18n("remains_btn_11"))
	self.btnTeamInvited:setTitleText(i18n("remains_btn_10"))
	SoraDAutoSizeButtonTextByContent(self.btnTeamApproval)
	SoraDAutoSizeButtonTextByContent(self.btnTeamInvited)
	self.memberList, _ENV, self.myTeamInfo, _ENV = SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent, SoraDAutoSizeButtonTextByContent
	self.hasNewTeamMsg = false
	self:addFireEffect()
	self:setHegemonEffect()
	self:initView()
	self:req4Data()
end
function myTeamView:setHegemonEffect()
	local showEffect = function()
		local act_eBg = SoraDCreatAnimation("etHegemonTop")
		for i = 1, 2 do
			local v = SoraDGetChildByName(act_eBg, "sp_dh_fire_" .. i)
			if v:isOpacityModifyRGB() then
				v:setBlendFunc(gl.ONE, gl.ONE)
			else
				v:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
			end
		end
		act_eBg:addTo(self.nodeMatchAnimation)
		act_eBg:setPosition(cc.p(-5, 0))
	end
	if _G.SoraDIsFileExistByKey("lucency") then
		_ENV, _UPVALUE1_ = "lucency", _G.SoraDIsFileExistByKey("lucency")
		;("lucency").name = "Common/lucency"
		local _G.SoraDIsFileExistByKey("lucency")[1], imgArray = "lucency", _G.SoraDIsFileExistByKey("lucency")
		self:loadImages(imgArray, function()
			showEffect()
		end)
	end
end
function myTeamView:addFireEffect()
	self.fireLeft = SoraDGetChildByName(self, "Sprite_fire_left")
	self.fireRight = SoraDGetChildByName(self, "Sprite_fire_right")
	local nodeFireL = _G.SoraDGetCommonJetFireNode(true)
	nodeFireL:setPosition(10, 55)
	nodeFireL:addTo(self.fireLeft)
	local nodeFireR = _G.SoraDGetCommonJetFireNode(true)
	nodeFireR:setPosition(10, 55)
	nodeFireR:addTo(self.fireRight)
	for i = 7, 9 do
		local particle = SoraDGetChildByName(self, "Particle_" .. i)
		if particle then
			particle:setAutoCull(false)
		end
	end
end
function myTeamView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_QUIT_BACK", handler(self, self.rspQuitTeam))
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_MATCH_STATUS", handler(self, self.updateTeamInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MEMBER_INFO_BACK", handler(self, self.updateScrollList))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_BACK", handler(self, self.rspMatchTeam))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_CANCEL_BACK", handler(self, self.rspCancelMatchTeam))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_SUC_BEFFER", handler(self, self.onTeamMatchSuc))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MSG", handler(self, self.updateNewTeamMsg))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_REQ", function()
		SoraDShowLoading(self)
	end)
end
function myTeamView:initView()
	local myTeamInfo = remainsTeamCtrl:getMyTeamInfo()
	self.myTeamInfo = myTeamInfo
	self.status = remainsTeamCtrl:getTeamStatus()
	self.memberList = myTeamInfo:getTeamMemberList()
	self:updateScrollList()
	self:updateTeamStatus()
	self:updateBtnStatus()
	self:updateRedPoint()
	self:updateMsgBox()
	self:updateNewTeamMsg()
end
function myTeamView:req4Data()
	remainsTeamCtrl:reqGetMemberInfo()
end
function myTeamView:updateMsgBox()
	if self.msgBox and not tolua.isnull(self.msgBox) and (not remainsTeamCtrl:isTeamCanOperator() or self.isOldLeader ~= self:isTeamLeader()) then
		self.msgBox:closePanel()
		self.msgBox = nil
	end
	self.isOldLeader = self:isTeamLeader()
end
function myTeamView:updateRedPoint()
	local isTeamCanOperator = remainsTeamCtrl:isTeamCanOperator()
	local isTeamApproval = remainsTeamCtrl:isTeamHasApproval()
	local isNotFull = #self.memberList < _G.TEAM_MEMBER_MAX
	self.spRedPoint:setVisible(isTeamCanOperator and isTeamApproval and isNotFull)
end
function myTeamView:updateTeamInfo(target, data)
	if not remainsTeamCtrl:isHasTeam() then
		self:removeFromParent()
	elseif not remainsTeamCtrl:isWarMatchBegin() then
		self:removeFromParent()
	else
		self:initView()
	end
end
function myTeamView:updateTeamBase()
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
	local teamScore = remainsWarUtil.caclulateMatchPoint(self.memberList)
	self.txtTeamScoreNum:setString(string.formatnumberthousands(teamScore))
	_UPVALUE2_ = string.formatnumberthousands(teamScore)
	string.formatnumberthousands(teamScore)[1] = self.txtTeamScoreNum
	string.formatnumberthousands(teamScore)[2] = self.txtTeamScoreTitle
	remainsWarUtil = self.txtTeamScoreTitle
	self.txtTeamScoreTitle[1] = 10
	_G.SoraDAlignNodeArrayOnCenterX(0, string.formatnumberthousands(teamScore))
	local width = self.txtTeamName:getContentSize().width / 2 + 25
	self.spTeamFlag:setPositionX(SoraDFIsRA() and width or -width)
end
function myTeamView:updateBtnStatus()
	local isLeader = self:isTeamLeader()
	if isLeader then
		self.btnTeamDissolve:setTitleText(i18n("common_text_301"))
	else
		self.btnTeamDissolve:setTitleText(i18n("remains_btn_09"))
	end
	SoraDAutoSizeButtonTextByContent(self.btnTeamDissolve)
end
function myTeamView:resetTeamStatus()
	self.txtTeamTips:setVisible(false)
	self.panelLoadUpgrade:setContentSize(cc.size(130, 130))
	self.txtMatchTimeNum:setTimeLast(nil)
	self.btnMatch:setTouchEnabled(false)
	self.btnShare:setVisible(false)
end
function myTeamView:updateTeamStatus()
	local status = self.status
	self:resetTeamStatus()
	self:updateTeamStatus_MatchTime()
	if status == RUINS_WAR_TEAM_STATE.BATTLE then
		self:updateTeamStatus_MatchSuc()
		self:setBtnGray(true)
	elseif status == RUINS_WAR_TEAM_STATE.MATCHING then
		self:updateTeamStatus_MatchIng()
		self:setBtnGray(true)
	elseif status == RUINS_WAR_TEAM_STATE.REST then
		self:updateTeamStatus_MatchReset()
		self:setBtnGray(true)
	else
		self:updateTeamStatus_MatchBegin()
		self:setBtnGray(false)
	end
end
function myTeamView:updateTeamStatus_MatchTime()
	self.txtMatchTimeTitle:setString(i18n("remains_text_26"))
	local warTime = remainsTeamCtrl:getWarStatusTime()
	if 0 <= warTime then
		self.txtMatchTimeNum:beginTime(warTime)
	end
end
function myTeamView:updateTeamStatus_MatchBegin()
	local isCanMatch_num = #self.memberList >= _G.TEAM_MEMBER_MIN
	local isLeader = self:isTeamLeader()
	if isCanMatch_num then
		if isLeader then
			self.txtMatchTitle:setString(i18n("remains_btn_06"))
			self:setMatchAnimatGray(false)
			self.btnMatch:setTouchEnabled(true)
		else
			self.txtMatchTitle:setString(i18n("remains_btn_07"))
			self:setMatchAnimatGray(true)
		end
	else
		self.txtMatchTitle:setString(i18n("remains_btn_06"))
		self:setMatchAnimatGray(true)
	end
	self:updateTeamMatchTime()
	self.btnShare:setVisible(true)
end
function myTeamView:updateTeamStatus_MatchIng()
	local isLeader = self:isTeamLeader()
	if isLeader then
		self.txtMatchTitle:setString(i18n("remains_text_134"))
		self.btnMatch:setTouchEnabled(true)
		self:setMatchAnimatGray(false)
	else
		self.txtMatchTitle:setString(i18n("remains_btn_08"))
		self:setMatchAnimatGray(true)
	end
	self:updateTeamMatchTime()
end
function myTeamView:updateTeamStatus_MatchReset()
	self.txtMatchTitle:setString(i18n("remains_text_31"))
	self.txtMatchTimeTitle:setString(i18n("remains_text_203"))
	self:setMatchAnimatGray(true)
end
function myTeamView:updateTeamMatchTime()
	local totalTime = remainsTeamCtrl:getWarMatchTotalTime()
	local warTime = remainsTeamCtrl:getWarStatusTime()
	self.panelLoadUpgrade:setContentSize(cc.size(130, 130 * warTime / totalTime))
	self.txtMatchTimeNum:setTimeLast(function(showTime, ticket)
		self.panelLoadUpgrade:setContentSize(cc.size(130, 130 * ticket / totalTime))
		totalTime = cc.size(130, 130 * ticket / totalTime)
		cc.size(130, 130 * ticket / totalTime)[1] = self.txtMatchTimeNum
		cc.size(130, 130 * ticket / totalTime)[2] = self.txtMatchTimeTitle
		_ENV = self.txtMatchTimeTitle
		self.txtMatchTimeTitle[1] = 10
		_G.SoraDAlignNodeArrayOnCenterX(0, cc.size(130, 130 * ticket / totalTime))
		return showTime
	end)
end
function myTeamView:updateTeamStatus_MatchSuc()
	self.txtMatchTitle:setString(i18n("remains_text_31"))
	self:setMatchAnimatGray(true)
end
function myTeamView:setBtnGray(gray)
	local enable = not gray
	self.btnTeamDissolve:setTouchEnabled(enable)
	if gray then
		self.btnTeamApproval:setTouchEnabled(enable)
		self.btnTeamInvited:setTouchEnabled(enable)
		self.nodeTeamOperator:setColor(colorGray)
	else
		local isNotFull = #self.memberList < _G.TEAM_MEMBER_MAX
		self.btnTeamApproval:setTouchEnabled(isNotFull)
		self.btnTeamInvited:setTouchEnabled(isNotFull)
		if isNotFull then
			self.btnTeamApproval:setColor(colorNormal)
			self.btnTeamInvited:setColor(colorNormal)
		else
			self.btnTeamApproval:setColor(colorGray)
			self.btnTeamInvited:setColor(colorGray)
		end
		self.nodeTeamOperator:setColor(colorNormal)
	end
end
function myTeamView:setMatchAnimatGray(gray)
	self.panelLoadUpgrade:setVisible(not gray)
	if gray then
		self.nodeMatchAnimation:setColor(colorGray)
	else
		self.nodeMatchAnimation:setColor(colorNormal)
	end
end
function myTeamView:isTeamLeader()
	return self.myTeamInfo:isTeamLeader()
end
function myTeamView:updateScrollView()
	for _, v in ipairs(self.scrollItems) do
		v:updateView()
	end
end
function myTeamView:createSingle(index, data)
	local single = self:getSingle()
	single:setScroll(self.scroll)
	single:setPosition(0, -index * 115)
	single:initData(data)
	table.insert(self.scrollItems, single)
end
function myTeamView:updateScrollData()
	local leader = self.myTeamInfo:getTeamLeader()
	for i, v in ipairs(self.memberList) do
		v.isLeader = v.uid == leader
		v.index = i
	end
	table.sort(self.memberList, function(team1, team2)
		if team1.isLeader ~= team2.isLeader then
			return team1.isLeader
		end
		if team1.index ~= team2.index then
			return team1.index < team2.index
		end
		return team1.uid < team2.uid
	end)
	for i, v in ipairs(self.memberList) do
		self:createSingle(i - 1, v)
	end
	if #self.memberList < _G.TEAM_MEMBER_MAX then
		local canInvited = self:isCanInvited()
		_ENV = nil
		;(nil).canInvited = canInvited
		self:createSingle(#self.memberList, nil)
	end
	local sSize = self.scroll:getContentSize()
	local listHeight = 115 * math.ceil(#self.scrollItems)
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeMember:setPositionY(sH)
end
function myTeamView:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = SoraDCreatePanel("myTeamMember")
		single:setHandle(handler(self, self.queryPlayerInfo))
		single:setHandleBg(handler(self, self.queryTeamPlayerInfo))
		single:addTo(self.nodeMember)
	end
	single:setVisible(true)
	return single
end
function myTeamView:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function myTeamView:updateScrollList()
	self:updateTeamBase()
	self:recycleSingle()
	self:updateScrollData()
end
function myTeamView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and self._queryInfo then
		self._queryInfo = false
		SoraDOpenLordView(data.lord)
	end
end
function myTeamView:rspMatchTeam(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	end
end
function myTeamView:onTeamMatchSuc(target, data)
	SoraDRemoveAllAfterPanelFromManager(self)
end
function myTeamView:rspCancelMatchTeam(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:errHandle(data.err)
	else
		SoraDShowMsgTip(i18n("alliance_text_09"))
	end
end
function myTeamView:rspQuitTeam(target, data)
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
function myTeamView:onClick_btnTeamDissolve(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local showMsg
		if self:isTeamLeader() then
			showMsg = i18n("remains_text_34")
		else
			showMsg = i18n("remains_text_35")
		end
		self.msgBox = SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				if self:isTeamLeader() then
					remainsTeamCtrl:reqDismissTeam()
				else
					remainsTeamCtrl:reqQuitTeam()
				end
				SoraDShowLoading(self)
			end
			self.msgBox = nil
		end)
	end
end
function myTeamView:onClick_btnTeamApproval(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("teamApprovalListView")
		panel:show()
	end
end
function myTeamView:onClick_btnTeamInvited(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("teamApprovalListInviteView")
		panel:show()
	end
end
function myTeamView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not _G.IsArClient then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR_EN)
		else
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR)
		end
	end
end
function myTeamView:queryPlayerInfo(data)
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
function myTeamView:isCanInvited()
	return self.status == RUINS_WAR_TEAM_STATE.NONE
end
function myTeamView:queryTeamPlayerInfo(data)
	if data then
		if data and data.uid then
			local panel = SoraDCreatePanel("teamMemberArmyView")
			panel:show()
			panel:initView(data, self.myTeamInfo)
		elseif self:isCanInvited() then
			local panel = SoraDCreatePanel("teamApprovalListInviteView")
			panel:show()
		end
	end
end
function myTeamView:onClick_btnMatch(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local status = self.status
		if status == RUINS_WAR_TEAM_STATE.MATCHING then
			local err = remainsWarUtil.checkCaneclMatch()
			if gErrDef.Err_None == err then
				remainsTeamCtrl:reqCancelMatch()
				SoraDShowLoading(self)
			else
				self:errHandle(err)
			end
		elseif status == RUINS_WAR_TEAM_STATE.NONE then
			local err = remainsWarUtil.checkMatch()
			if gErrDef.Err_None == err then
				remainsWarUtil.reqMatch()
			else
				self:errHandle(err)
			end
		end
	end
end
function myTeamView:onClick_btn_share(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarResultShareBox")
		panel:initShareTeam()
		panel:show()
	end
end
function myTeamView:onClick_btn_chat(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:setNewTeamMsg(false)
		_ENV = self.setNewTeamMsg
		self.setNewTeamMsg.teamId = self.myTeamInfo:getTeamID()
		self.setNewTeamMsg.teamType = self.myTeamInfo:getTeamType()
		local self.setNewTeamMsg.myTeamInfo, data = self.myTeamInfo, self.setNewTeamMsg
		local panel = SoraDCreatePanel("teamChatView")
		panel:initWithData(data)
		panel:show()
	end
end
function myTeamView:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	local errType = remainsWarUtil.getErrType(err)
	if errType == remainsWarUtil.errType.TIPS then
		if errType == gErrDef.Err_RUINS_WAR_NOT_TEAM_LEADER then
			if self:isTeamLeader() then
				SoraDShowMsgTip(i18n("remains_text_141"))
			else
				SoraDShowMsgTip(i18n("remains_text_120"))
			end
		else
			remainsWarUtil.errShowTips(err)
		end
	elseif errType == remainsWarUtil.errType.CLOSE then
		remainsWarUtil.errShowTips(err)
		self:removeFromParent()
	end
end
function myTeamView:setNewTeamMsg(new)
	if self.hasNewTeamMsg == new then
		return
	end
	if new and SoraDSearchPanelFromManagerByName("teamChatView") then
		return
	end
	self.hasNewTeamMsg = new
	self:showNewEffect(self.hasNewTeamMsg)
end
function myTeamView:updateNewTeamMsg()
	local new = remainsTeamCtrl:isHasNewTeamMsg()
	self:setNewTeamMsg(new)
end
function myTeamView:showNewEffect(show)
	self.nodeChat:stopAllActions()
	if show then
		_UPVALUE7_ = self.nodeChat
		self.nodeChat[1] = cca.delay(1.0)
		self.nodeChat[2] = cca.rotateTo(0.25, 10)
		self.nodeChat[3] = cca.rotateTo(0.21666666666666667, -10)
		self.nodeChat[4] = cca.rotateTo(0.2, 8)
		self.nodeChat[5] = cca.rotateTo(0.16666666666666666, -5)
		self.nodeChat[6] = cca.rotateTo(0.15, 2)
		self.nodeChat[7] = cca.rotateTo(0.15, 0)
		self.nodeChat[8] = cca.delay(1.0)
		self.nodeChat[9] = cca.delay(1.0)
		local seq = cca.seq(self.nodeChat)
		self.nodeChat:runAction(cc.RepeatForever:create(seq))
	else
		self.nodeChat:setRotation(0)
	end
	self.spRedPointChat:setVisible(show)
end
return myTeamView
