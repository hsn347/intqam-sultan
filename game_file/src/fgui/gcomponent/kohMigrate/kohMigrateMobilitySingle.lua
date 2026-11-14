local gametop = gModuleMgr.getObject("gametop")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local lordLocalData = include("lordLocalData")
local kohMigrateRead = include("kohMigrateRead")
local baseComponent = require("fgui.base.baseComponent")
local kohMigrateMobilitySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/kohMigrateMobilitySingle", kohMigrateMobilitySingle)
function kohMigrateMobilitySingle:onInit()
	self.jumpKid = nil
	self.selfKid = gametop.playertop_:getKingdomID()
	self.fields.Button_touch:addClickListener(handler(self, self.onTouchHeadBack))
	local playerTypeName = kohMigrateRead.getPlayerTypeName(gKohMigratePlayerType.T1)
	self.fields.Com_playerType:setString(playerTypeName)
	self.fields.Com_playerType:setVisible(false)
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function kohMigrateMobilitySingle:onShow()
end
function kohMigrateMobilitySingle:initMobilitySingle(...)
	if self.isInit then
		return
	end
	self.isInit = true
	self.singleType = 1
	self.controllers.c_type:setSelectedIndex(0)
	self.fields.Text_in:setString(i18n("across_inKingdom_name"))
	self.fields.Text_out:setString(i18n("across_outKingdom_name"))
end
function kohMigrateMobilitySingle:initPrivilegeApplySingle(...)
	if self.isInit then
		return
	end
	self.isInit = true
	self.singleType = 2
	self.controllers.c_type:setSelectedIndex(1)
	self.fields.Text_agreed:setString(i18n("across_move_approved_name"))
	self.fields.Button_yes:addClickListener(handler(self, self.btnApplyYesClick))
	self.fields.Button_no:addClickListener(handler(self, self.btnApplyNoClick))
end
function kohMigrateMobilitySingle:initData(data, otherData)
	self.data = data
	self:refreshTextName(data)
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
	self.jumpKid = data.kid
	if self.singleType == 1 then
		local isMoveIn = self.selfKid == data.toKid
		self.fields.Node_in:setVisible(isMoveIn)
		self.fields.Node_out:setVisible(not isMoveIn)
		self.fields.Text_time:setString(SoraDConverTimeStr(data.t))
		self.jumpKid = data.toKid
	elseif self.singleType == 2 then
		self.fields.Node_agree:setVisible(false)
		self.fields.Node_apply:setVisible(false)
		if data.status == gKohMigrateApplyMsgStatus.WAIT then
			self.fields.Node_apply:setVisible(true)
		elseif data.status == gKohMigrateApplyMsgStatus.ACCEPTED then
			self.fields.Node_agree:setVisible(true)
		end
	end
end
function kohMigrateMobilitySingle:refreshTextName(data)
	local nameStr = data.name
	local kid = data.kid
	if self.singleType == 1 and self.selfKid == data.toKid then
		kid = data.fromKid
	end
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
function kohMigrateMobilitySingle:btnApplyYesClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).initData = true
	;(nil).data = self.data
	uiManager:show("kohMigratePrivilegeApplySure", nil)
end
function kohMigrateMobilitySingle:btnApplyNoClick()
	SoraDPlaySound()
	_ENV = nil
	_ENV, _ENV, (nil).var1 = self.fields.Text_name, self.fields.Text_name:getText(), self.fields.Text_name:getText()
	_ENV, self.fields.Text_name:getText().var1, self.fields.Text_name.color = self.fields.Text_name, self.fields.Text_name, "#FFFFFF"
	self.fields.Text_name:getText().__default, self.fields.Text_name.color = self.fields.Text_name, "#D7C39B"
	local str = i18n_html("across_approvalRefuseSure_desc", nil, (self.fields.Text_name:getText()))
	_ENV = nil
	;(nil).useHtml = true
	SoraDShowMsgBoxNew(str, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			SoraDShowLoading()
			kohMigrateCtrl:reqRejectExtraApply(self.data.uid)
		end
	end, nil)
end
function kohMigrateMobilitySingle:onTouchHeadBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.data.uid
	;(nil).kid = self.jumpKid
	SoraDSendMessage(nil)
end
function kohMigrateMobilitySingle:onClickBtnHelp(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateRank")
end
return kohMigrateMobilitySingle
