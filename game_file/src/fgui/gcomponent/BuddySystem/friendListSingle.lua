local contactCtrl = SoraDGetCtrl("contactCtrl")
local buildLogic = include("buildLogic")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local friendListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuddySystem/friendListSingle", friendListSingle)
function friendListSingle:onInit()
	self.fields.btn_delete:addClickListener(handler(self, self.onDeleteClick))
	self.fields.btn_mail:addClickListener(handler(self, self.onMailClick))
	self.fields.btn_rename:setVisible(false)
	self.fields.btn_rename:addClickListener(handler(self, self.btnRenameClick))
	self.fields.btn_add:setString(i18n("shopping_text_10"))
	self.fields.btn_add:addClickListener(handler(self, self.onAddClick))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onCancelClick))
	self:fixChildrenPos()
	self.fields.nxbg:fix()
end
function friendListSingle:onShow()
end
function friendListSingle:initData(data, viewType, rankIndex, delMode)
	self.data = data
	self.viewType = viewType
	self.rankIndex = rankIndex
	self.delMode = delMode
	self.isCooling = false
	if self.viewType == 1 then
		self.controllers.c1:setSelectedIndex(0)
		if self.data.online then
			self.fields.Text_time:setVisible(true)
			if 0 < self.data.online then
				self.fields.Text_time:setString(SoraDConverSecondToDate(self.data.online, false, true))
				self.fields.Text_time:setColor(cc.c3b(215, 195, 155))
			else
				self.fields.Text_time:setString(i18n("common_text_224"))
				self.fields.Text_time:setColor(cc.c3b(0, 190, 30))
			end
		else
			self.fields.Text_time:setVisible(false)
		end
		if self.delMode then
			self:setPositionX(SoraDFIsRA() and -66 or 66)
		else
			self:setPositionX(0)
		end
		self.fields.com_head:setTouchEnabled(true)
		if exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.CONTACT_REMARKS) then
			self.fields.btn_rename:setVisible(true)
		end
	else
		self.fields.btn_rename:setVisible(false)
		self.fields.com_head:setTouchEnabled(false)
		if self.isCooling then
			self.controllers.c1:setSelectedIndex(3)
		elseif contactCtrl:isSendInvite(self.data.uid) then
			self.controllers.c1:setSelectedIndex(2)
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	end
	self.fields.com_head:setHeadSprite(self.data.headid or self.data.iconID, self.data.avatar)
	self.fields.com_head:setPlayerID(self.data.uid)
	self.fields.com_head:setKid(self.data.kid or self.data.sourceKid)
	local abbr = self.data.allianceAbbr or self.data.abbr
	local name = self.data.remarkName or self.data.nickName or self.data.name
	if abbr and abbr ~= "" then
		_ENV = cc.c3b(0, 190, 30)
		cc.c3b(0, 190, 30).abbr = abbr
		cc.c3b(0, 190, 30).name = name
		self.fields.Text_name:setString(string.format("%s #%d", i18n("common_text_186", cc.c3b(0, 190, 30)), self.data.kid or self.data.sourceKid))
	else
		self.fields.Text_name:setString(string.format("%s #%d", name, self.data.kid or self.data.sourceKid))
	end
	if self.rankIndex == 2 then
		_ENV = string.format("%s #%d", name, self.data.kid or self.data.sourceKid)
		string.format("%s #%d", name, self.data.kid or self.data.sourceKid).lv = self:trasnWarLv(self.data.cityLevel)
		self.fields.Text_show:setString(i18n("common_text_3514", string.format("%s #%d", name, self.data.kid or self.data.sourceKid)))
	else
		_ENV = i18n("common_text_3514", string.format("%s #%d", name, self.data.kid or self.data.sourceKid))
		i18n("common_text_3514", string.format("%s #%d", name, self.data.kid or self.data.sourceKid)).count = string.formatnumberthousands(self.data.totalFc)
		self.fields.Text_show:setString(i18n("common_text_555", i18n("common_text_3514", string.format("%s #%d", name, self.data.kid or self.data.sourceKid))))
	end
end
function friendListSingle:trasnWarLv(clv)
	local warLv = buildLogic.transformBuildLvToWarLv(clv)
	if 0 < warLv then
		buildLogic = nil
		;(nil).lv = warLv
		return i18n("common_text_1948", nil)
	else
		return math.min(clv, CASTLE_MAXLV_NOWAR)
	end
end
function friendListSingle:onMailClick()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.targetType = gMailType.CHAT
	SoraDPlaySound.target = self.data.uid
	SoraDPlaySound.nickName = self.data.nickName or self.data.name
	local SoraDPlaySound.allianceAbbr, data = self.data.allianceAbbr or self.data.abbr, SoraDPlaySound
	SoraDCreateChatView(data)
end
function friendListSingle:onDeleteClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("friend_text_18"), i18n("common_text_204"), nil, function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			contactCtrl:reqDelContact(self.data.uid)
		end
	end)
end
function friendListSingle:btnRenameClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).info = self.data
	uiManager:show("friendRenameView", nil)
end
function friendListSingle:onAddClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("friendApplyView", nil)
end
function friendListSingle:onCancelClick(button, event)
	SoraDPlaySound()
	if contactCtrl:isSendInvite(self.data.uid) then
		contactCtrl:reqCancelSendFriendInvite(self.data.uid)
		self.fields.Text_leftTime:setTimeLast(function(ticket, second)
			if 1 < second then
				return string.format("%ds", second)
			else
				self.controllers.c1:setSelectedIndex(1)
				self.isCooling = false
				return ""
			end
		end)
		self.fields.Text_leftTime:beginTime(CONTACT_CANCEL_INVITE_FRIEND_INTERVAL)
		self.isCooling = true
		self.controllers.c1:setSelectedIndex(3)
	else
		SoraDShowMsgTip(i18n("friend_text_34"))
		self.controllers.c1:setSelectedIndex(1)
	end
end
return friendListSingle
