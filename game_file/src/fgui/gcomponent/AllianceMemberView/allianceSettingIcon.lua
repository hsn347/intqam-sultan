local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local romeActivityCtrl = SoraDGetCtrl("romeActivityCtrl")
local memberMgr = SoraDGetCtrl("memberMgr")
local cityCtrl = SoraDGetCtrl("cityCtrl")
_ENV = "cityCtrl"
;("cityCtrl")[gAPermission.APPOINT_KING] = true
;("cityCtrl")[gAPermission.QUIT] = true
;("cityCtrl")[gAPermission.DEMISE] = true
;("cityCtrl")[gAPermission.EXPEL_MEMBER] = true
;("cityCtrl")[gAPermission.DEMOTE_MEMBER] = true
;("cityCtrl")[gAPermission.PROMOTE_MEMBER] = true
local ("cityCtrl")[gAPermission.ALLIANCE_OFFICIAL_FIRE], forbidInWar = true, "cityCtrl"
local baseComponent = require("fgui.base.baseComponent")
local allianceSettingIcon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceMemberView/allianceSettingIcon", allianceSettingIcon)
function allianceSettingIcon:onInit()
	self.pID = 0
	self.tableSingleData, _ENV, self.curID = nil, nil, nil
	self:addClickListener(handler(self, self.btnClick))
end
function allianceSettingIcon:onShow()
end
function allianceSettingIcon:initData(pID, tableSingleData)
	self.pID = pID
	self.tableSingleData = tableSingleData
	if self.pID == gAPermission.ALLIANCE_OFFICIAL_FIRE and self.tableSingleData:getProperty("rank") == gAllianceRank.OFFICIAL then
		self.fields.title:setString(i18n("alliance_office_btn_﻿03"))
	else
		self.fields.title:setString(allianceDesRead.getPermissionName(self.pID))
	end
	self.fields.icon:setSpriteFrame(allianceDesRead.getPermissionIcon(self.pID))
	if forbidInWar[self.pID] and worldMapDefine.isInWarForbid(true) then
		self.controllers.c1:setSelectedIndex(1)
	elseif self.pID == gAPermission.INVITE_MOVE_CITY and worldMapDefine.isInNewTrial() then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function allianceSettingIcon:btnClick()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound[gAPermission.MAIL_ALL] = true
	local SoraDPlaySound[gAPermission.HELP_SOLDIERS], ignoreList = true, SoraDPlaySound
	if not ignoreList[self.pID] and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if forbidInWar[self.pID] and worldMapDefine.isInWarForbid() then
		return
	elseif self.pID == gAPermission.INVITE_MOVE_CITY and worldMapDefine.isInNewTrial() then
		SoraDShowMsgTip(i18n("devilvalley_text_50"))
		return
	end
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	local uid = self.tableSingleData:getProperty("uid")
	local msg
	self.curID = self.pID
	if self.pID == gAPermission.DEMISE then
		if romeActivityCtrl:isOpenAllianceRomeActivity() then
			SoraDShowMsgBox(i18n("common_text_1511"), i18n("common_text_204"))
		elseif allianceDesRead.checkAlliancePackStatus() then
			_ENV = i18n("common_text_204")
			i18n("common_text_204").name = self.tableSingleData:getProperty("nickName")
			msg = i18n("common_text_667", i18n("common_text_204"))
			SoraDShowMsgBox(msg, i18n("common_text_054"), nil, handler(self, self.makeSure))
		elseif ownRank == gAllianceRank.R5 and KWKingdomCtrl:isProxyKing() then
			SoraDShowMsgBox(i18n("common_text_4288"), i18n("common_text_204"))
		end
	elseif self.pID == gAPermission.REPLACE_LEADER then
		local lastTime = self.tableSingleData:getProperty("online")
		if lastTime > gConstValue.ALLIANCE_LEADER_LOGOUT_DAY_TO_SECOND then
			if ownRank < gAllianceRank.R3 then
				_ENV = i18n("common_text_204")
				i18n("common_text_204").gold = ALLIANCE_BE_NEW_LORD_GOLD
				SoraDShowBuyBox(i18n("common_text_668", i18n("common_text_204")), ALLIANCE_BE_NEW_LORD_GOLD, i18n("common_text_229"), handler(self, self.makeSure), false)
			elseif romeActivityCtrl:isOpenAllianceRomeActivity() then
				SoraDShowMsgBox(i18n("common_text_1511"), i18n("common_text_204"))
			else
				_ENV = i18n("common_text_204")
				i18n("common_text_204").gold = ALLIANCE_BE_NEW_LORD_GOLD
				SoraDShowBuyBox(i18n("common_text_668", i18n("common_text_204")), ALLIANCE_BE_NEW_LORD_GOLD, i18n("common_text_229"), handler(self, self.makeSure))
			end
		else
			_ENV = i18n("common_text_229")
			i18n("common_text_229").gold = ALLIANCE_BE_NEW_LORD_GOLD
			SoraDShowBuyBox(i18n("common_text_669", (i18n("common_text_229"))), ALLIANCE_BE_NEW_LORD_GOLD, i18n("common_text_229"), handler(self, self.makeSure), false)
		end
	elseif self.pID == gAPermission.EXPEL_MEMBER then
		if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
			return
		elseif kingdomMapCtrl:isHasMassQueue4Uid(uid) then
			SoraDShowMsgBox(i18n("common_text_670"), i18n("common_text_204"))
		elseif kingdomMapCtrl:hasKWQueue(uid) then
			SoraDShowMsgBox(i18n("common_text_1440"), i18n("common_text_204"))
		else
			_ENV = i18n("common_text_204")
			i18n("common_text_204").name = self.tableSingleData:getProperty("nickName")
			msg = i18n("common_text_671", i18n("common_text_204"))
			SoraDShowMsgBox(msg, i18n("common_text_054"), nil, handler(self, self.makeSure))
		end
	elseif self.pID == gAPermission.RECRUIT then
		allianceMgr:reqAgreeApplication(uid)
	elseif self.pID == gAPermission.DEMOTE_MEMBER then
		_ENV = uid
		uid.name = self.tableSingleData:getProperty("nickName")
		uid.fromRank = self.tableSingleData:getProperty("rank")
		uid.toRank = self.tableSingleData:getProperty("rank") - 1
		msg = i18n("common_text_672", uid)
		SoraDShowMsgBox(msg, i18n("common_text_054"), nil, handler(self, self.makeSure))
	elseif self.pID == gAPermission.ALLIANCE_OFFICIAL_FIRE then
		if self.tableSingleData:getProperty("rank") == gAllianceRank.OFFICIAL then
			local official = self.tableSingleData:getProperty("official")
			allianceMgr:reqFireAllianceOfficial(official)
		end
	elseif self.pID == gAPermission.PROMOTE_MEMBER then
		_ENV = allianceMgr
		allianceMgr.name = self.tableSingleData:getProperty("nickName")
		allianceMgr.fromRank = self.tableSingleData:getProperty("rank")
		allianceMgr.toRank = self.tableSingleData:getProperty("rank") + 1
		msg = i18n("common_text_672", allianceMgr)
		SoraDShowMsgBox(msg, i18n("common_text_054"), nil, handler(self, self.makeSure))
	elseif self.pID == gAPermission.INVITE_MOVE_CITY then
		local mapId = self.tableSingleData:getProperty("mapId")
		if ownmember:getProperty("mapId") ~= mapId then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return
		end
		msg = i18n("common_text_673")
		SoraDShowMsgBox(msg, i18n("common_text_054"), nil, handler(self, self.makeSure))
	elseif self.pID == gAPermission.HELP_RESOURCE then
		local mapId = self.tableSingleData:getProperty("mapId")
		if ownmember:getProperty("mapId") ~= mapId then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return
		end
		if cityCtrl:getBuildCell(BUILDID.MARKET, 0) then
			if SoraDEnoughTroops() then
				local panel = uiManager:show("marketView").view
				_ENV = 0
				;(0).uid = uid
				panel:initView(0)
			end
		else
			SoraDShowMsgTip(i18n("common_text_498"), nil, button)
		end
	elseif self.pID == gAPermission.HELP_SOLDIERS then
		local mapId = self.tableSingleData:getProperty("mapId")
		if ownmember:getProperty("mapId") ~= mapId then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return
		end
		if not kingdomMapCtrl:hasArmyHelpQueue2Player(uid) then
			_ENV = kingdomMapCtrl:hasArmyHelpQueue2Player(uid)
			kingdomMapCtrl:hasArmyHelpQueue2Player(uid).uid = uid
			local kingdomMapCtrl:hasArmyHelpQueue2Player(uid).dispatchType, cityArmyData = worldMapDefine.worldMapTipButtonType_shibingYuabzhu, kingdomMapCtrl:hasArmyHelpQueue2Player(uid)
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").cityArmyData = cityArmyData
			uiManager:show("ReinforcementsMsgBox", i18n("common_text_3302"))
		else
			SoraDShowMsgTip(i18n("common_text_704"))
		end
	elseif self.pID == gAPermission.MAIL_ALL then
		local playerId = uid
		local nickName = self.tableSingleData:getProperty("nickName")
		local allianceAbbr = self.tableSingleData:getProperty("abbr")
		_ENV = self.tableSingleData
		self.tableSingleData.targetType = gMailType.CHAT
		self.tableSingleData.target = playerId
		self.tableSingleData.nickName = nickName
		local self.tableSingleData.allianceAbbr, data = allianceAbbr, self.tableSingleData
		local panel = SoraDCreateChatView(data)
	elseif self.pID == gAPermission.REJECT then
		allianceMgr:reqRejectApplication(uid)
		self:closeSettingView(uid)
	elseif self.pID == gAPermission.APPOINT_KING then
		_ENV = uid
		uid.name = self.tableSingleData:getProperty("nickName")
		msg = i18n("common_text_1186", uid)
		SoraDShowMsgBox(msg, i18n("common_text_054"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				SoraDShowMsgBox(i18n("common_text_1185"), i18n("common_text_054"), nil, handler(self, self.makeSure))
			end
		end)
	end
end
function allianceSettingIcon:makeSure(type)
	if type == MSGBOX_CALLBACK_YES then
		if tolua.isnull(self) then
			return
		end
		local uid = self.tableSingleData:getProperty("uid")
		if self.curID == self.pID then
			if self.pID == gAPermission.DEMISE then
				allianceMgr:reqDemiseAlliance(uid)
			elseif self.pID == gAPermission.REPLACE_LEADER then
				allianceMgr:reqReplaceLeader(uid)
			elseif self.pID == gAPermission.EXPEL_MEMBER then
				allianceMgr:reqExpelMember(uid)
				self:closeSettingView(uid)
			elseif self.pID == gAPermission.DEMOTE_MEMBER then
				allianceMgr:reqDemoteMember(uid)
			elseif self.pID == gAPermission.PROMOTE_MEMBER then
				allianceMgr:reqPromoteMember(uid)
			elseif self.pID == gAPermission.INVITE_MOVE_CITY then
				local pos = gTableParam.inviteMoveCityPos
				local mtype = table.nums(pos) > 0 and gInviteMoveCityType.EXACT or gInviteMoveCityType.BLUR
				allianceMgr:reqInviteMoveCity(uid, pos, mtype)
			elseif self.pID == gAPermission.APPOINT_KING then
				KWKingdomCtrl:appiontKing(uid)
				self:closeSettingView(uid)
			end
		else
			SoraDShowMsgBox(i18n("common_text_203"), i18n("common_text_204"))
		end
	end
end
function allianceSettingIcon:closeSettingView(uid)
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIACNE_MEMBER_SETTING_CLOSE"
	;(nil).uid = uid
	SoraDSendMessage(nil)
end
return allianceSettingIcon
