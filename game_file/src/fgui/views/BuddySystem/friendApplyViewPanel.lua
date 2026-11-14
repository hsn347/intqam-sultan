local contactCtrl = SoraDGetCtrl("contactCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local friendApplyViewPanel = class("friendApplyViewPanel", baseFguiPanel)
function friendApplyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("friendApplyViewPanel:ctor", self.viewName)
end
function friendApplyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function friendApplyViewPanel:onInit()
	print("=======friendApplyViewPanel:onInit")
	self.isHaveTextField = true
	self.fields.Panel_bg:setString(i18n("friend_btn_02"))
	self.fields.Button_apply:setString(i18n("common_text_073"))
	self.fields.Button_apply:addClickListener(handler(self, self.onApplyClick))
	self.fields.Com_head:fixPos()
	self.fields.Text_name:fixPos()
end
function friendApplyViewPanel:onShow()
	print("=======friendApplyViewPanel:onShow")
	self.data = self.param.data
	self.isIgnore = self.param.isIgnore or false
	self.handle = self.param.handle
	self:initData()
end
function friendApplyViewPanel:initData()
	self.fields.Com_head:setHeadSprite(self.data.headid or self.data.iconID, self.data.avatar)
	self.fields.Com_head:setPlayerID(self.data.uid)
	self.fields.Com_head:setTouchEnabled(not self.isIgnore)
	local abbr = self.data.abbr
	if abbr and abbr ~= "" then
		_ENV = nil
		;(nil).abbr = abbr
		;(nil).name = self.data.nickName
		self.fields.Text_name:setString(string.format("%s #%d", i18n("common_text_186", nil), self.data.kid))
	else
		self.fields.Text_name:setString(string.format("%s #%d", self.data.nickName, self.data.kid))
	end
end
function friendApplyViewPanel:onApplyClick()
	SoraDPlaySound()
	local text = i18n("friend_text_15")
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(text) then
		SoraDShowMsgTip(i18n("notice_0071"))
		return
	end
	if self.data.cityLevel < CASTLE_LV6_LIMITED then
		SoraDShowMsgTip(i18n("friend_text_14"))
		return
	end
	if contactCtrl:getSendInviteNum() >= CONTACT_INVITE_FRIEND_SEND_MAX then
		SoraDShowMsgTip(i18n("friend_text_37"))
		return
	end
	if contactCtrl:isSendInvite(self.data.uid) then
		SoraDShowMsgTip(i18n("alliance_office_btn_02"))
		return
	end
	if contactCtrl:isOwnFriendMaxLimit() then
		SoraDShowMsgTip(i18n("friend_text_06"))
	else
		SoraDShowLoading()
		contactCtrl:reqSendFriendInvite(self.data.uid, text)
		if self.handle then
			self.handle()
		end
		self:close()
	end
end
return friendApplyViewPanel
