local gametop = gModuleMgr.getObject("gametop")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamMemberPanel = class("NebulaWarTeamMemberPanel", baseFguiPanel)
_ENV = "NebulaWarTeamMemberPanel"
;("NebulaWarTeamMemberPanel").Type_info = 1
;("NebulaWarTeamMemberPanel").Type_transfer = 2
;("NebulaWarTeamMemberPanel").Type_kick = 3
;("NebulaWarTeamMemberPanel").Type_kick2 = 32
;("NebulaWarTeamMemberPanel").Type_kick3 = 33
;("NebulaWarTeamMemberPanel").Type_quit = 4
;("NebulaWarTeamMemberPanel").Type_commander = 5
;("NebulaWarTeamMemberPanel").Type_assemblerAdd = 6
;("NebulaWarTeamMemberPanel").Type_assemblerAdd2 = 62
;("NebulaWarTeamMemberPanel").Type_assemblerDel = 7
;("NebulaWarTeamMemberPanel").Type_assemblerDel2 = 72
;("NebulaWarTeamMemberPanel").Type_commanderAdd = 8
;("NebulaWarTeamMemberPanel").Type_commanderAdd2 = 82
;("NebulaWarTeamMemberPanel").Type_commanderDel = 9
;("NebulaWarTeamMemberPanel").Type_commanderDel2 = 92
local ("NebulaWarTeamMemberPanel").Type_chat, BUTTON_TYPE = 10, "NebulaWarTeamMemberPanel"
local BUTTON_MAX = 4
_ENV = nil
_ENV = nil
;(nil).pos = 2
;(nil).name = "remains_btn_12"
;(nil)[BUTTON_TYPE.Type_transfer], (nil).icon = nil, "icon_alliance_replace.png"
_ENV = nil
;(nil).pos = 2
;(nil).name = "nebula_war_text_0376"
;(nil)[BUTTON_TYPE.Type_commander], (nil).icon = nil, "icon_nebulawars_remove.png"
_ENV = nil
;(nil).pos = 1
;(nil).name = "nebula_war_text_0454"
;(nil)[BUTTON_TYPE.Type_assemblerAdd], (nil).icon = nil, "icon_nebulawars_rally.png"
_ENV = nil
;(nil).pos = 1
;(nil).name = "nebula_war_text_0454"
;(nil)[BUTTON_TYPE.Type_assemblerAdd2], (nil).icon = nil, "icon_xydw_renming1.png"
_ENV = nil
;(nil).pos = 1
;(nil).name = "nebula_war_text_0455"
;(nil)[BUTTON_TYPE.Type_assemblerDel], (nil).icon = nil, "icon_nebulawars_rally.png"
_ENV = nil
;(nil).pos = 1
;(nil).name = "nebula_war_text_0455"
;(nil)[BUTTON_TYPE.Type_assemblerDel2], (nil).icon = nil, "icon_xydw_renming1.png"
_ENV = nil
;(nil).pos = 3
;(nil).name = "remains_btn_13"
;(nil)[BUTTON_TYPE.Type_kick], (nil).icon = nil, "icon_alliance_out.png"
_ENV = nil
;(nil).pos = 3
;(nil).name = "nebulaemperor_text_63"
;(nil)[BUTTON_TYPE.Type_kick2], (nil).icon = nil, "icon_alliance_out.png"
_ENV = nil
;(nil).pos = 3
;(nil).name = "NebulaAllstar_68"
;(nil)[BUTTON_TYPE.Type_kick3], (nil).icon = nil, "icon_alliance_out.png"
_ENV = nil
;(nil).pos = 3
;(nil).name = "remains_btn_09"
;(nil)[BUTTON_TYPE.Type_quit], (nil).icon = nil, "icon_alliance_out.png"
_ENV = nil
;(nil).pos = 4
;(nil).name = "nebula_war_text_0197"
;(nil)[BUTTON_TYPE.Type_info], (nil).icon = nil, "btn_common_record.png"
_ENV = nil
;(nil).pos = 2
;(nil).name = "nebulaemperor_text_51"
;(nil)[BUTTON_TYPE.Type_commanderAdd], (nil).icon = nil, "icon_xydw_renming2.png"
_ENV = nil
;(nil).pos = 2
;(nil).name = "NebulaAllstar_66"
;(nil)[BUTTON_TYPE.Type_commanderAdd2], (nil).icon = nil, "icon_nebulawars_remove.png"
_ENV = nil
;(nil).pos = 2
;(nil).name = "nebulaemperor_text_58"
;(nil)[BUTTON_TYPE.Type_commanderDel], (nil).icon = nil, "icon_xydw_renming2.png"
_ENV = nil
;(nil).pos = 2
;(nil).name = "NebulaAllstar_67"
;(nil)[BUTTON_TYPE.Type_commanderDel2], (nil).icon = nil, "icon_nebulawars_remove.png"
_ENV = nil
;(nil).pos = 2
;(nil).name = "chat_text_69"
_ENV, (nil)[BUTTON_TYPE.Type_chat], (nil).icon = BUTTON_TYPE.Type_chat, nil, "icon_xydw_lt.png"
local btnConfig
BUTTON_TYPE.Type_chat[BUTTON_TYPE.Type_assemblerAdd2] = 2
BUTTON_TYPE.Type_chat[BUTTON_TYPE.Type_assemblerDel2] = 2
BUTTON_TYPE.Type_chat[BUTTON_TYPE.Type_commanderAdd] = 1
local _ENV, BUTTON_TYPE.Type_chat[BUTTON_TYPE.Type_commanderDel], btnPos_nebulaEmperor = BUTTON_TYPE.Type_commanderDel, 1, BUTTON_TYPE.Type_chat
BUTTON_TYPE.Type_commanderDel[BUTTON_TYPE.Type_commanderAdd2] = 1
BUTTON_TYPE.Type_commanderDel[BUTTON_TYPE.Type_commanderDel2] = 1
BUTTON_TYPE.Type_commanderDel[BUTTON_TYPE.Type_chat] = 2
BUTTON_TYPE.Type_commanderDel[BUTTON_TYPE.Type_info] = 3
local BUTTON_TYPE.Type_commanderDel[BUTTON_TYPE.Type_kick3], btnPos_nebulaAllStar = 4, BUTTON_TYPE.Type_commanderDel
function NebulaWarTeamMemberPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamMemberPanel:ctor", self.viewName)
end
function NebulaWarTeamMemberPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarTeamMemberPanel:onInit()
	print("=======NebulaWarTeamMemberPanel:onInit")
	self.memberData = self.proxy.param.memberData
	self.teamType = self.proxy.param and self.proxy.param.teamType or teamAreaEnum.NEBULA_WAR
	local lordLocalData = include("lordLocalData")
	self.fields.Image_portrait:setURL(lordLocalData.getPortrait(self.memberData.headid))
	local name = string.format("%s#%d", self.memberData.nickName, self.memberData.kid)
	self.fields.Text_name:setString(name)
	local allanceStr
	if self.memberData.allianceAbbr then
		_ENV = lordLocalData.getPortrait(self.memberData.headid)
		lordLocalData.getPortrait(self.memberData.headid).abbr = self.memberData.allianceAbbr
		lordLocalData.getPortrait(self.memberData.headid).name = self.memberData.allianceName
		allanceStr = i18n("common_text_186", lordLocalData.getPortrait(self.memberData.headid))
	else
		allanceStr = i18n("common_text_480")
	end
	_ENV = lordLocalData.getPortrait(self.memberData.headid)
	lordLocalData.getPortrait(self.memberData.headid).conten = allanceStr
	self.fields.Text_alliance:setString(i18n("common_text_925", lordLocalData.getPortrait(self.memberData.headid)))
	self.fields.Com_castleLv:initData(self.memberData.cityLevel, self.memberData.starLv)
	self.fields.Com_castleLv:resetViewWidth()
	self.fields.Com_castleLv:fixChildrenPos()
	_ENV = self.memberData.cityLevel
	self.memberData.cityLevel.power = string.formatnumberthousands(self.memberData.totalFc)
	local powerStr = i18n("common_text_128", self.memberData.cityLevel)
	self.fields.Text_power:setString(powerStr)
	for i = 1, BUTTON_MAX do
		local Button = self.fields["Button_left" .. i]
		Button:addClickListener(handler(self, self.onClickOperateBtn))
		Button:fixPos()
	end
	self:updateOperateBtns()
end
function NebulaWarTeamMemberPanel:onShow()
	print("=======NebulaWarTeamMemberPanel:onShow")
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		self.fields.Text_history:setString(i18n("NebulaAllstar_75"))
		self.fields.List_history:setItemRenderer(handler(self, self.onHistoryItemRederer))
		nebulaActivityCtrl:reqPlayerHist(self.memberData.uid)
	end
end
function NebulaWarTeamMemberPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local myTeamInfo = self:getMyTeamInfo()
	local sender = EventContext:getSender()
	local btnType = sender:getTag()
	if btnType == BUTTON_TYPE.Type_info then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.memberData.uid
		;(nil).kid = self.memberData.kid
		SoraDSendMessage(nil)
	elseif btnType == BUTTON_TYPE.Type_transfer then
		if not nebulaWarUtil.checkChangeTeamNameState() then
			SoraDShowMsgTip(i18n("nebula_war_text_0260"))
			return
		end
		_ENV = i18n("nebula_war_text_0260")
		i18n("nebula_war_text_0260").name = self.memberData.nickName
		local msgStr = i18n("nebula_war_text_0044", i18n("nebula_war_text_0260"))
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamTransferLeader(self.memberData.uid)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_commander then
		if not nebulaWarUtil.checkChangeTeamNameState() then
			SoraDShowMsgTip(i18n("nebula_war_text_0378"))
			return
		end
		_ENV = i18n("nebula_war_text_0378")
		i18n("nebula_war_text_0378").name = self.memberData.nickName
		local msgStr = i18n("nebula_war_text_0435", i18n("nebula_war_text_0378"))
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamTransferLeader(self.memberData.uid)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_kick or btnType == BUTTON_TYPE.Type_kick2 or btnType == BUTTON_TYPE.Type_kick3 then
		if not self:checkQuitTeamState(true) then
			if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
				SoraDShowMsgTip(i18n("notice_0026"))
				self:closePanel()
			end
			return
		end
		local msgStr = ""
		if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
			_ENV = i18n("notice_0026")
			i18n("notice_0026").name = self.memberData.nickName
			msgStr = i18n("nebulaemperor_text_68", i18n("notice_0026"))
		elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			msgStr = i18n("NebulaAllstar_74")
		else
			_ENV = i18n("notice_0026")
			i18n("notice_0026").name = self.memberData.nickName
			msgStr = i18n("nebula_war_text_0047", i18n("notice_0026"))
		end
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamKick(self.memberData.uid, self.memberData.nickName)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_quit then
		if not self:checkQuitTeamState() then
			return
		end
		local msgStr = i18n("nebula_war_text_0049")
		if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
			msgStr = i18n("nebulaemperor_text_38")
		end
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamQuit()
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_assemblerAdd or btnType == BUTTON_TYPE.Type_assemblerAdd2 then
		if not self:checkAssemblerCount() then
			SoraDShowMsgTip(i18n("nebula_war_text_0457"))
			return
		end
		_ENV = i18n("nebula_war_text_0457")
		i18n("nebula_war_text_0457").name = self.memberData.nickName
		local msgStr = i18n("nebula_war_text_0475", i18n("nebula_war_text_0457"))
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamAddAssembler(self.memberData.uid)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_assemblerDel or btnType == BUTTON_TYPE.Type_assemblerDel2 then
		_ENV = msgStr
		msgStr.name = self.memberData.nickName
		local msgStr = i18n("nebula_war_text_0476", msgStr)
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamDelAssembler(self.memberData.uid)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_commanderAdd or btnType == BUTTON_TYPE.Type_commanderAdd2 then
		if not self:checkCommanderCount() then
			if btnType == BUTTON_TYPE.Type_commanderAdd2 then
				SoraDShowMsgTip(i18n("NebulaAllstar_70"))
			else
				_ENV = i18n("NebulaAllstar_70")
				i18n("NebulaAllstar_70").post = i18n("free_team_text_77")
				SoraDShowMsgTip(i18n("nebulaemperor_text_54", i18n("NebulaAllstar_70")))
			end
			return
		end
		local msgStr = ""
		if btnType == BUTTON_TYPE.Type_commanderAdd2 then
			msgStr = i18n("NebulaAllstar_69")
		else
			_ENV = i18n("nebulaemperor_text_54", i18n("NebulaAllstar_70"))
			i18n("nebulaemperor_text_54", i18n("NebulaAllstar_70")).name = self.memberData.nickName
			i18n("nebulaemperor_text_54", i18n("NebulaAllstar_70")).post = i18n("free_team_text_77")
			msgStr = i18n("nebulaemperor_text_57", i18n("nebulaemperor_text_54", i18n("NebulaAllstar_70")))
		end
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamAddCommander(self.memberData.uid)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_commanderDel or btnType == BUTTON_TYPE.Type_commanderDel2 then
		local msgStr = ""
		if btnType == BUTTON_TYPE.Type_commanderDel2 then
			msgStr = i18n("NebulaAllstar_278")
		else
			_ENV = nil
			;(nil).name = self.memberData.nickName
			;(nil).post = i18n("free_team_text_77")
			msgStr = i18n("nebulaemperor_text_61", nil)
		end
		SoraDShowMsgBox(msgStr, nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				myTeamInfo:reqTeamDelCommander(self.memberData.uid)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif btnType == BUTTON_TYPE.Type_chat then
		_ENV = BUTTON_TYPE.Type_chat
		BUTTON_TYPE.Type_chat.targetType = gMailType.CHAT
		BUTTON_TYPE.Type_chat.target = self.memberData.uid
		BUTTON_TYPE.Type_chat.nickName = self.memberData.nickName
		local BUTTON_TYPE.Type_chat.allianceAbbr, data = self.memberData.allianceAbbr, BUTTON_TYPE.Type_chat
		SoraDCreateChatView(data)
	end
end
function NebulaWarTeamMemberPanel:onMsgMemberQuit(target, event)
	if event.teamType and event.teamType ~= self.teamType then
		return
	end
	if event.uid == self.memberData.uid then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function NebulaWarTeamMemberPanel:updateOperateBtns(...)
	local teamAreaEnum, btnList
	local teamAreaEnum, btnPosConfig
	local teamAreaEnum, btnMap
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		btnList = self:getNebulaEmperorBtnList()
		btnPosConfig = btnPos_nebulaEmperor
	elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		btnList = self:getNebulaAllStarBtnList()
		btnPosConfig = btnPos_nebulaAllStar
	else
		btnList, btnMap = self:getOperateBtnList()
	end
	for i = 1, BUTTON_MAX do
		local Button = self.fields["Button_left" .. i]
		if Button then
			Button:setVisible(false)
		end
	end
	for __, btnType in ipairs(btnList) do
		local config = btnConfig[btnType]
		local pos = btnPosConfig[btnType] or config.pos
		local Button = self.fields["Button_left" .. pos]
		if Button then
			Button:setVisible(true)
			Button:setString(i18n(config.name))
			Button:setIcon(config.icon)
			Button:setTag(btnType)
			if btnMap[btnType] and btnMap[btnType].bright == false then
				Button:setBright(false)
			else
				Button:setBright(true)
			end
		end
	end
end
function NebulaWarTeamMemberPanel:getOperateBtnList(...)
	local myTeamInfo = self:getMyTeamInfo()
	local memberUid = self.memberData.uid
	local ownUid = gametop.playertop_:getPlayerID()
	local isLeader = myTeamInfo:isTeamLeader(ownUid)
	local isOtherLeader = myTeamInfo:isTeamLeader(memberUid)
	local isSelf = ownUid == memberUid
	local gametop, btnList = memberUid, memberUid
	local gametop, btnMap
	if isLeader then
		if isSelf then
		else
			table.insert(btnList, BUTTON_TYPE.Type_info)
			table.insert(btnList, BUTTON_TYPE.Type_transfer)
			table.insert(btnList, BUTTON_TYPE.Type_kick)
			if not nebulaWarUtil.checkSuperTeamSignUpState() then
				gametop = btnList
				btnMap[BUTTON_TYPE.Type_kick], btnList.bright = btnList, false
			end
		end
	elseif isSelf then
		table.insert(btnList, BUTTON_TYPE.Type_quit)
	else
		table.insert(btnList, BUTTON_TYPE.Type_info)
	end
	return btnList, btnMap
end
function NebulaWarTeamMemberPanel:getNebulaEmperorBtnList(...)
	local myTeamInfo = self:getMyTeamInfo()
	local memberUid = self.memberData.uid
	local ownUid = gametop.playertop_:getPlayerID()
	local isSelfLeader = myTeamInfo:isTeamLeader(ownUid)
	local isSelfCommander = myTeamInfo:isTeamCommander(ownUid)
	local isLeader = myTeamInfo:isTeamLeader(memberUid)
	local isCommander = myTeamInfo:isTeamCommander(memberUid)
	local isAssembler = myTeamInfo:isTeamAssembler(memberUid)
	local isSelf = ownUid == memberUid
	local gametop, btnList = memberUid, memberUid
	if isSelf then
		if isSelfLeader then
		else
			table.insert(btnList, BUTTON_TYPE.Type_quit)
		end
	else
		table.insert(btnList, BUTTON_TYPE.Type_info)
		if isSelfLeader then
			if not isLeader and not isCommander and not isAssembler then
				table.insert(btnList, BUTTON_TYPE.Type_commanderAdd)
				table.insert(btnList, BUTTON_TYPE.Type_assemblerAdd2)
				table.insert(btnList, BUTTON_TYPE.Type_kick2)
			elseif isCommander then
				table.insert(btnList, BUTTON_TYPE.Type_commanderDel)
			elseif isAssembler then
				table.insert(btnList, BUTTON_TYPE.Type_assemblerDel2)
				table.insert(btnList, BUTTON_TYPE.Type_kick2)
			end
		elseif isSelfCommander and not isLeader and not isCommander then
			table.insert(btnList, BUTTON_TYPE.Type_kick2)
		end
	end
	return btnList
end
function NebulaWarTeamMemberPanel:getNebulaAllStarBtnList(...)
	local isInSameTeam = self.param and self.param.isInSameTeam
	if not isInSameTeam then
		_ENV = nil
		;(nil)[1] = BUTTON_TYPE.Type_info
		local (nil)[2], btnList = BUTTON_TYPE.Type_chat, nil
		return btnList
	end
	local myTeamInfo = self:getMyTeamInfo()
	local memberUid = self.memberData.uid
	local ownUid = gametop.playertop_:getPlayerID()
	local isSelfLeader = myTeamInfo:isTeamLeader(ownUid)
	local isSelfCommander = myTeamInfo:isTeamCommander(ownUid)
	local isLeader = myTeamInfo:isTeamLeader(memberUid)
	local isCommander = myTeamInfo:isTeamCommander(memberUid)
	local isSelf = ownUid == memberUid
	local BUTTON_TYPE, btnList = memberUid, memberUid
	if isSelf then
	else
		table.insert(btnList, BUTTON_TYPE.Type_info)
		table.insert(btnList, BUTTON_TYPE.Type_chat)
		if isSelfLeader then
			if nebulaAllStarUtil.checkQuitTeamState() then
				table.insert(btnList, BUTTON_TYPE.Type_kick3)
			end
			if not isLeader and not isCommander then
				table.insert(btnList, BUTTON_TYPE.Type_commanderAdd2)
			elseif isCommander then
				table.insert(btnList, BUTTON_TYPE.Type_commanderDel2)
			end
		end
	end
	return btnList
end
function NebulaWarTeamMemberPanel:getMyTeamInfo(...)
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	return teamCtrl:getTeamData(self.teamType or teamAreaEnum.NEBULA_WAR)
end
function NebulaWarTeamMemberPanel:checkAssemblerCount(...)
	local myTeamInfo = self:getMyTeamInfo()
	local count = myTeamInfo:getAssemblerCount()
	local total = 0
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		total = nebulaEmperorRead.getTeamAssemblerMax()
	end
	return count < total
end
function NebulaWarTeamMemberPanel:checkCommanderCount(...)
	local myTeamInfo = self:getMyTeamInfo()
	local count = myTeamInfo:getCommanderCount()
	local total = 0
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		total = nebulaEmperorRead.getTeamCommandMax()
	elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local nebulaAllStarRead = include("nebulaAllStarRead")
		total = nebulaAllStarRead.getTeamCommandMax()
	end
	return count < total
end
function NebulaWarTeamMemberPanel:checkQuitTeamState(isKick)
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		if not nebulaEmperorUtil.checkQuitTeamState() then
			if isKick then
				SoraDShowMsgTip(i18n("nebulaemperor_text_64"))
			else
				SoraDShowMsgTip(i18n("nebulaemperor_text_35"))
			end
			return
		end
	elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		return nebulaAllStarUtil.checkQuitTeamState()
	elseif not nebulaWarUtil.checkQuitTeamState() then
		SoraDShowMsgTip(i18n("nebula_war_text_0512"))
		return
	end
	return true
end
function NebulaWarTeamMemberPanel:onMsgUpdatePlayerHist(target, event)
	if self.teamType ~= teamAreaEnum.NEBULA_ALL_STAR then
		return
	end
	if not event.rspdata then
		teamAreaEnum = event.rspdata
	end
	self.historyInfo = event.rspdata
	self.fields.List_history:setNumItems(4)
end
function NebulaWarTeamMemberPanel:onHistoryItemRederer(index, obj)
	local round = index + 1
	if not self.historyInfo or not self.historyInfo[tostring(round)] then
		local _ENV, data = self.historyInfo[tostring(round)], self.historyInfo[tostring(round)]
	end
	local _fields = fguiHelper.get_fields(obj)
	_ENV = nil
	;(nil).num = round
	_fields.Text_title:setString(i18n("NebulaAllstar_76", nil))
	local numStr = i18n("common_text_480")
	if data.score then
		numStr = string.formatnumberthousands(data.score)
	end
	_ENV = i18n("NebulaAllstar_76", nil)
	i18n("NebulaAllstar_76", nil).num = numStr
	_fields.Text_score:setString(i18n("NebulaAllstar_77", i18n("NebulaAllstar_76", nil)))
	local rankStr = i18n("common_text_480")
	if data.scoreRank then
		if data.scoreRank > 100 then
			rankStr = "100+"
		else
			rankStr = data.scoreRank
		end
	end
	_ENV = i18n("NebulaAllstar_77", i18n("NebulaAllstar_76", nil))
	i18n("NebulaAllstar_77", i18n("NebulaAllstar_76", nil)).num = rankStr
	_fields.Text_rank:setString(i18n("NebulaAllstar_78", i18n("NebulaAllstar_77", i18n("NebulaAllstar_76", nil))))
end
return NebulaWarTeamMemberPanel
