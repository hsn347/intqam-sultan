local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local lordLocalData = include("lordLocalData")
local kohMigrateRead = include("kohMigrateRead")
local baseComponent = require("fgui.base.baseComponent")
local kohMigratePrivilegeKingSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigratePrivilegeKingSingle", kohMigratePrivilegeKingSingle)
function kohMigratePrivilegeKingSingle:onInit()
	self.fields.Text_none:setString(i18n("kingPower_noInvitationLord_desc"))
	self.fields.Text_status:setString(i18n("kingPower_invitation_join_desc"))
	self.fields.Button_invite:setString(i18n("common_text_189"))
	self.fields.Button_invite:addClickListener(handler(self, self.btnInviteClick))
	self.fields.Button_cancel:setString(i18n("kingPower_invitation_revoke_btn"))
	self.fields.Button_cancel:addClickListener(handler(self, self.btnCancelClick))
	self.fields.Button_chat:setString(i18n("prison_btn_02"))
	self.fields.Button_chat:addClickListener(handler(self, self.btnChatClick))
	local playerTypeName = kohMigrateRead.getPlayerTypeName(gKohMigratePlayerType.T1)
	self.fields.Com_playerType:setString(playerTypeName)
	self.fields.Com_playerType:setVisible(false)
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function kohMigratePrivilegeKingSingle:onShow()
end
function kohMigratePrivilegeKingSingle:initData(data)
	self.data = data
	if not data or not next(data) then
		self.controllers.c_type:setSelectedIndex(1)
		return
	end
	self.controllers.c_type:setSelectedIndex(0)
	self.fields.Com_castleLv:initData(data.castleLv, data.starLv)
	self:refreshTextName(data)
	self.fields.Sprite_player:setURL(lordLocalData.getBust(data.headid))
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
	if data.status == gKohMigrateApplyMsgStatus.WAIT then
		self.fields.Text_status:setVisible(false)
		self.fields.Button_cancel:setVisible(true)
		self.fields.Button_chat:setVisible(true)
	elseif data.status == gKohMigrateApplyMsgStatus.ACCEPTED then
		self.fields.Text_status:setVisible(true)
		self.fields.Button_cancel:setVisible(false)
		self.fields.Button_chat:setVisible(false)
	end
end
function kohMigratePrivilegeKingSingle:btnInviteClick(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateInviteSearch")
end
function kohMigratePrivilegeKingSingle:btnCancelClick(...)
	SoraDPlaySound()
	local inviteInfo = self.data
	_ENV = nil
	_ENV, _ENV, (nil).var1 = nil, inviteInfo.name, inviteInfo.name
	inviteInfo.name.var1, (nil).color = nil, "#ffff00"
	local str = i18n_html("tips_kingPower_recallSure_desc", nil, inviteInfo.name)
	_ENV = nil
	;(nil).align = SoraDFLabelR()
	;(nil).useHtml = true
	SoraDShowMsgBoxNew(str, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KOH_MIGRATE) then
				SoraDShowMsgTip(i18n("tips_acrossMove_activity_notOpen"))
				return
			end
			if not kohMigrateCtrl:isShowPrivilegeBtn() then
				SoraDShowMsgTip(i18n("tips_across_kingPowerLimit"))
				return
			end
			if not kohMigrateCtrl:checkPlayerHasInvite(inviteInfo.uid) then
				SoraDShowMsgTip(i18n("tips_kingPower_recall_noAtList"))
				return
			end
			print("执行撤销===")
			kohMigrateCtrl:reqCancelSpecInvite(inviteInfo.uid)
		end
	end, nil)
end
function kohMigratePrivilegeKingSingle:btnChatClick()
	SoraDPlaySound()
	local inviteInfo = self.data
	_ENV = nil
	;(nil).targetType = gMailType.CHAT
	;(nil).target = inviteInfo.uid
	;(nil).nickName = inviteInfo.name
	local (nil).allianceAbbr, data = inviteInfo.allianceAbb, nil
	SoraDCreateChatView(data)
end
function kohMigratePrivilegeKingSingle:refreshTextName(data)
	local nameStr = data.name
	local kid = data.kid
	if kid then
		nameStr = string.format("%s#%d", nameStr, kid)
	end
	if data.allianceAbb then
		_ENV = nameStr
		nameStr.abbr = data.allianceAbb
		nameStr.name = nameStr
		nameStr = i18n("common_text_186", nameStr)
	end
	self.fields.Text_name:setString(nameStr)
end
function kohMigratePrivilegeKingSingle:onClickBtnHelp(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateRank")
end
return kohMigratePrivilegeKingSingle
