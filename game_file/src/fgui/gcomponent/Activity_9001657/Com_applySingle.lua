local lordLocalData = include("lordLocalData")
local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_applySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001657/Com_applySingle", Com_applySingle)
function Com_applySingle:onInit()
	self.fields.Sprite_player:addClickListener(handler(self, self.onTouchHeadBack))
	self.fields.Text_agreed:setString(i18n("across_move_approved_name"))
	self.fields.Button_yes:addClickListener(handler(self, self.onClickBtnYes))
	self.fields.Button_no:addClickListener(handler(self, self.onClickBtnNo))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_applySingle:onShow()
end
function Com_applySingle:initData(data)
	self.data = data
	self.fields.Sprite_player:setSpriteFrame(lordLocalData.getBust(data.iconID))
	local playerName = textParser.formatPlayerName(data.allianceAbbr, data.nickName)
	self.fields.Text_name:setString(playerName)
	lordLocalData = lordLocalData.getBust(data.iconID)
	lordLocalData.getBust(data.iconID).kid = data.kid
	self.fields.Text_kingdom:setString(i18n("kingdom_merger_text10", lordLocalData.getBust(data.iconID)))
	self.fields.Text_power:setString(string.formatnumberthousands(data.totalFc or 0))
	self.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
	local state = data.state
	if state == gMergeServerApplyState.APPLIED then
		self.fields.Text_agreed:setVisible(false)
		self.fields.Button_yes:setVisible(true)
		self.fields.Button_no:setVisible(true)
	elseif state == gMergeServerApplyState.AGREED or state == gMergeServerApplyState.AUTO_AGREED then
		self.fields.Text_agreed:setVisible(true)
		self.fields.Button_yes:setVisible(false)
		self.fields.Button_no:setVisible(false)
	end
end
function Com_applySingle:onTouchHeadBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.data.uid
	;(nil).kid = self.data.kid
	SoraDSendMessage(nil)
end
function Com_applySingle:onClickBtnYes(...)
	SoraDPlaySound()
	if not activity_9001657_Ctrl:checkAgreedUserNum() then
		SoraDShowMsgTip(i18n("kingdom_merger_text26"))
		return
	end
	_ENV = i18n("kingdom_merger_text26")
	i18n("kingdom_merger_text26").initData_9001657 = true
	i18n("kingdom_merger_text26").data = self.data
	uiManager:show("kohMigratePrivilegeApplySure", i18n("kingdom_merger_text26"))
end
function Com_applySingle:onClickBtnNo(...)
	SoraDPlaySound()
	local playerName = textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName, self.data.kid)
	_ENV = self.data.kid
	_ENV, _ENV, self.data.kid.var1 = nil, nil, playerName
	_ENV, (nil).var1, (nil).color = nil, nil, "#FFFFFF"
	;(nil).__default, (nil).color = nil, "#D7C39B"
	local str = i18n_html("across_approvalRefuseSure_desc", self.data.kid, nil)
	_ENV = nil
	;(nil).useHtml = true
	SoraDShowMsgBoxNew(str, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			SoraDShowLoading()
			activity_9001657_Ctrl:reqRejectApply(self.data.uid)
		end
	end, nil)
end
return Com_applySingle
