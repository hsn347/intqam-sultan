local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local lordLocalData = include("lordLocalData")
local kohMigrateRead = include("kohMigrateRead")
local baseComponent = require("fgui.base.baseComponent")
local kohMigrateInviteSearchSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigrateInviteSearchSingle", kohMigrateInviteSearchSingle)
function kohMigrateInviteSearchSingle:onInit()
	self.lvLimit = kohMigrateCtrl:getLvLimit()
	self.isKingPrivilege = true
	self.fields.Sprite_player:addClickListener(handler(self, self.onTouchHeadBack))
	self.fields.Button_invite:addClickListener(handler(self, self.btnInviteClick))
	local playerTypeName = kohMigrateRead.getPlayerTypeName(gKohMigratePlayerType.T1)
	self.fields.Com_playerType:setString(playerTypeName)
	self.fields.Com_playerType:setVisible(false)
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function kohMigrateInviteSearchSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST", handler(self, self.onInviteBack))
end
function kohMigrateInviteSearchSingle:onShow()
end
function kohMigrateInviteSearchSingle:initData(data)
	self.data = data
	local nameStr = textParser.formatPlayerName(data.allianceAbb, data.name, data.kid)
	self.fields.Text_name:setString(nameStr)
	self.fields.Com_castleLv:initData(data.castleLv, data.starLv)
	self.fields.Sprite_player:setSpriteFrame(lordLocalData.getBust(data.headid))
	local legend = kohMigrateRead.getPlayerLegend(data.uid)
	local isLegend = legend ~= nil
	self.fields.Com_playerType:setVisible(isLegend)
	self.fields.Button_help:setVisible(isLegend)
	if legend then
		self.fields.Text_power:setString(string.formatnumberthousands(legend))
		self.fields.Image_power:setURL("icon_kfqc_cqph.png")
		self.fields.Image_power:setSize(cc.size(40, 40))
	else
		self.fields.Text_power:setString(string.formatnumberthousands(data.strength or 0))
		self.fields.Image_power:setURL("icon_powerLimit.png")
		self.fields.Image_power:setSize(cc.size(50, 50))
	end
	self.fields.Button_invite:setEnabled(true)
	if kohMigrateCtrl:checkPlayerHasInvite(self.data.uid) then
		self.fields.Button_invite:setString(i18n("remains_btn_15"))
		self.fields.Button_invite:setBright(false)
	else
		self.fields.Button_invite:setString(i18n("common_text_189"))
		self.fields.Button_invite:setBright(true)
	end
end
function kohMigrateInviteSearchSingle:btnInviteClick()
	if not kohMigrateCtrl:checkKingdomInviteTime(self.data.uid, true) then
		local constValue = kohMigrateCtrl:getAcrossParam("kingpower_invitation_CD")
		kohMigrateCtrl = nil
		;(nil).var1 = math.ceil(constValue / 60)
		SoraDShowMsgTip(i18n("tips_acs_invitationCD", nil))
		return
	end
	if not kohMigrateCtrl:checkKingInviteNum() then
		SoraDShowMsgTip(i18n("tips_kingPower_invitation_timesLimit"))
		return
	end
	if not kohMigrateCtrl:isPrivilegeOpen() then
		SoraDShowMsgTip(i18n("tips_across_kingPower_notOpen02"))
		return
	end
	local lvLimit = self.lvLimit
	if lvLimit > self.data.castleLv then
		local buildLogic = include("buildLogic")
		kohMigrateCtrl = i18n("tips_across_kingPower_notOpen02")
		i18n("tips_across_kingPower_notOpen02").var1 = buildLogic.getBuildLvStr(lvLimit)
		SoraDShowMsgTip(i18n("tips_acrossInvitation_lvLimit", i18n("tips_across_kingPower_notOpen02")))
		return
	end
	kohMigrateCtrl = i18n("tips_acrossInvitation_lvLimit", i18n("tips_across_kingPower_notOpen02"))
	i18n("tips_acrossInvitation_lvLimit", i18n("tips_across_kingPower_notOpen02")).initData = true
	i18n("tips_acrossInvitation_lvLimit", i18n("tips_across_kingPower_notOpen02")).data = self.data
	i18n("tips_acrossInvitation_lvLimit", i18n("tips_across_kingPower_notOpen02")).isKingPrivilege = true
	uiManager:show("kohMigratePrivilegeApplySure", i18n("tips_acrossInvitation_lvLimit", i18n("tips_across_kingPower_notOpen02")))
end
function kohMigrateInviteSearchSingle:onInviteBack(target, event)
	dump(event, "event=============")
	if event.uid ~= self.data.uid then
		return
	end
	SoraDCloseLoading()
	if event.err == gErrDef.Err_None then
		self.fields.Button_invite:setString(i18n("remains_btn_15"))
		self.fields.Button_invite:setBright(false)
	else
		self.fields.Button_invite:setEnabled(false)
	end
	self.data.err = event.err
end
function kohMigrateInviteSearchSingle:onTouchHeadBack(button, event)
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.data.uid
	;(nil).kid = self.data.kid
	SoraDSendMessage(nil)
end
function kohMigrateInviteSearchSingle:onClickBtnHelp(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateRank")
end
return kohMigrateInviteSearchSingle
