local allianceDesRead = include("allianceDesRead")
local AllianceSettingIcon = class("allianceSettingIcon", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceSettingIcon")
	end
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
_ENV = 255
;(255)[gAPermission.APPOINT_KING] = true
;(255)[gAPermission.QUIT] = true
;(255)[gAPermission.DEMISE] = true
;(255)[gAPermission.EXPEL_MEMBER] = true
;(255)[gAPermission.DEMOTE_MEMBER] = true
;(255)[gAPermission.PROMOTE_MEMBER] = true
local (255)[gAPermission.ALLIANCE_OFFICIAL_FIRE], forbidInWar = true, 255
function AllianceSettingIcon:ctor()
	self.pID = 0
	self.tableSingleData, _ENV, self.curID = nil, nil, nil
	self.labelName = SoraDGetChildByName(self, "Text_title")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnIcon = SoraDGetChildByName(self, "Button_icon")
	if self.btnIcon then
		self.btnIcon:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceSettingIcon:initData(pID, tableSingleData)
	self.pID = pID
	self.tableSingleData = tableSingleData
	if self.pID == gAPermission.ALLIANCE_OFFICIAL_FIRE and self.tableSingleData:getProperty("rank") == gAllianceRank.OFFICIAL then
		self.labelName:setString(i18n("alliance_office_btn_﻿03"))
	else
		self.labelName:setString(allianceDesRead.getPermissionName(self.pID))
	end
	self.spriteIcon:setSpriteFrame(allianceDesRead.getPermissionIcon(self.pID))
	if forbidInWar[self.pID] and worldMapDefine.isInWarForbid(true) then
		self:setColor(colorGray)
	elseif self.pID == gAPermission.INVITE_MOVE_CITY and worldMapDefine.isInNewTrial() then
		self:setColor(colorGray)
	else
		self:setColor(colorNormal)
	end
end
function AllianceSettingIcon:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
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
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
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
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
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
end
function AllianceSettingIcon:makeSure(type)
	if type == MSGBOX_CALLBACK_YES then
		if tolua.isnull(self) then
			return
		end
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local uid = self.tableSingleData:getProperty("uid")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
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
				local pos = GLOBAL_GAME_ALLIANCE_MODE and gTableParam.inviteMoveCityPos or include("allianceMemberList").getParam().inviteMoveCityPos
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
function AllianceSettingIcon:closeSettingView(uid)
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIACNE_MEMBER_SETTING_CLOSE"
	;(nil).uid = uid
	SoraDSendMessage(nil)
end
return AllianceSettingIcon
