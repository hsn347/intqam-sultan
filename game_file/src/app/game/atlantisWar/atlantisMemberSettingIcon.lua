local allianceDesRead = include("allianceDesRead")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisMemberSettingIcon = class("atlantisMemberSettingIcon", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisMemberSettingIcon")
	end
	return target
end)
function atlantisMemberSettingIcon:ctor()
	self.pID = 0
	self.labelName = SoraDGetChildByName(self, "Text_title")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.btnIcon = SoraDGetChildByName(self, "Button_icon")
	if self.btnIcon then
		self.btnIcon:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function atlantisMemberSettingIcon:initData(pID, tableSingleData)
	self.pID = pID
	self.tableSingleData = tableSingleData
	self.labelName:setString(allianceDesRead.getPermissionName(self.pID))
	self.spriteIcon:setSpriteFrame(allianceDesRead.getPermissionIcon(self.pID))
end
function atlantisMemberSettingIcon:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local uid = self.tableSingleData.uid
		self.curID = self.pID
		if self.pID == gAPermission.HELP_SOLDIERS then
			if worldMapDefine.isInAtlantis() then
				local atlantisWarUtil = include("atlantisWarUtil")
				local posx = self.tableSingleData:getProperty("x") or 0
				local posy = self.tableSingleData:getProperty("y") or 0
				if not atlantisWarUtil.checkCanJoinMass(cc.p(posx, posy), true) then
					return
				end
			end
			if not kingdomMapCtrl:hasArmyHelpQueue2Player(uid) then
				_ENV = kingdomMapCtrl:hasArmyHelpQueue2Player(uid)
				kingdomMapCtrl:hasArmyHelpQueue2Player(uid).uid = uid
				local kingdomMapCtrl:hasArmyHelpQueue2Player(uid).dispatchType, cityArmyData = worldMapDefine.worldMapTipButtonType_shibingYuabzhu, kingdomMapCtrl:hasArmyHelpQueue2Player(uid)
				_ENV = cc.p(posx, posy)
				cc.p(posx, posy).cityArmyData = cityArmyData
				uiManager:show("ReinforcementsMsgBox", (cc.p(posx, posy)))
			else
				SoraDShowMsgTip(i18n("common_text_704"))
			end
		elseif self.pID == gAPermission.MAIL_ALL then
			local playerId = uid
			local nickName = self.tableSingleData.nickName
			_ENV = i18n("common_text_704")
			i18n("common_text_704").targetType = gMailType.CHAT
			i18n("common_text_704").target = playerId
			local i18n("common_text_704").nickName, data = nickName, i18n("common_text_704")
			SoraDCreateChatView(data)
		elseif self.pID == gAPermission.DEMOTE_MEMBER or self.pID == gAPermission.PROMOTE_MEMBER then
			local memberClass = self.tableSingleData.memberClass
			local toLv = self.pID == gAPermission.DEMOTE_MEMBER and memberClass - 1 or memberClass + 1
			self.toLv = toLv
			_ENV = data
			data.name = self.tableSingleData.nickName
			data.fromLv = memberClass
			data.toLv = toLv
			msg = i18n("atlantiswar_text_0228", data)
			SoraDShowMsgBox(msg, i18n("common_text_054"), nil, handler(self, self.makeSure))
		end
	end
end
function atlantisMemberSettingIcon:makeSure(type)
	if type == MSGBOX_CALLBACK_YES then
		if self.curID ~= self.pID then
			SoraDShowMsgTip(i18n("notice_0026"))
			return
		end
		if self.pID == gAPermission.DEMOTE_MEMBER or self.pID == gAPermission.PROMOTE_MEMBER then
			local memberClass = self.tableSingleData.memberClass
			atlantisWarCtrl:reqSetMemberClass(self.tableSingleData.uid, self.toLv, memberClass)
		end
	end
end
return atlantisMemberSettingIcon
