local baseComponent = require("fgui.base.baseComponent")
local Com_9001606_kingdom = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
local nationalFlagRead = include("nationalFlagRead")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
fgui.register_extension("ui://Activity_9001606/Com_9001606_kingdom", Com_9001606_kingdom)
function Com_9001606_kingdom:onInit()
	self:fixChildrenPos()
	self.fields.btn_mail:addClickEventListener(handler(self, self.onMailClick))
	self.fields.btn_state:addClickEventListener(handler(self, self.onstateClick))
end
function Com_9001606_kingdom:onShow()
end
function Com_9001606_kingdom:initData(data, inviteList, invitedList)
	self.data = data
	local kindomName = (data.kingdomName == "" and i18n("common_text_479") or data.kingdomName) .. "#" .. data.kid
	self.fields.txt_kingdom:setString(kindomName)
	self.fields.txt_power:setString(i18n("CombineServers_15") .. data.power)
	if not data.kingInfo.isAgentKing then
		self.fields.txt_king:setString(i18n("CombineServers_11") .. (data.kingInfo.nickName and data.kingInfo.nickName or ""))
	else
		self.fields.txt_king:setString(i18n("CombineServers_12") .. (data.kingInfo.nickName and data.kingInfo.nickName or ""))
	end
	self.fields.btn_mail:setVisible(activity_9001606_Ctrl:getIsKing() and not activity_9001606_Ctrl:getIsSelfKingdom(data.kid))
	local isKing = activity_9001606_Ctrl:getIsKing()
	self.fields.btn_state:setVisible(isKing)
	self.fields.icon:setURL(kingdomCtrl:getKindomPalaceModelIcon(data.kid))
	self.inviteList = inviteList
	if inviteList and isKing then
		self:setInvitedData(inviteList, invitedList)
	elseif isKing then
		self.fields.btn_state:setBtnColorIndex(0)
		self.fields.btn_state:setTitle(i18n("CombineServers_22"))
	end
end
function Com_9001606_kingdom:setInvitedData(inviteList, invitedList)
	self.state = gMergeServerInvitState.NONE
	for k, v in pairs(inviteList) do
		if self.data.kid == v.kid then
			self.state = v.state
			break
		end
	end
	for k, v in pairs(invitedList) do
		if self.data.kid == v.kid and v.state == gMergeServerInvitState.AGREED then
			self.state = v.state
			break
		end
	end
	dump(inviteList, "Com_9001606_kingdom:setInvitedData")
	if self.state == gMergeServerInvitState.NONE then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.btn_state:setBtnColorIndex(0)
		self.fields.btn_state:setTitle(i18n("CombineServers_16"))
	elseif self.state == gMergeServerInvitState.INVITED then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.btn_state:setBtnColorIndex(3)
		self.fields.btn_state:setTitle(i18n("CombineServers_17"))
	elseif self.state == gMergeServerInvitState.AGREED then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.btn_state:setBtnColorIndex(1)
		self.fields.btn_state:setTitle(i18n("CombineServers_18"))
	end
end
function Com_9001606_kingdom:onMailClick()
	SoraDPlaySound()
	if next(self.data.kingInfo) == nil then
		return
	end
	if self.data.kingInfo.shiledStranger and not SoraDGetCtrl("contactCtrl"):isFriend(self.data.kingInfo.uid) then
		SoraDShowMsgTip(i18n("chat_text_66"))
		return
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.targetType = gMailType.CHAT
	SoraDShowMsgTip.target = self.data.kingInfo.uid
	local SoraDShowMsgTip.nickName, data = self.data.kingInfo.nickName, SoraDShowMsgTip
	SoraDCreateChatView(data)
end
function Com_9001606_kingdom:onstateClick()
	SoraDPlaySound()
	if self.inviteList == nil then
		if activity_9001606_Ctrl:getIsBindKingdom() then
			SoraDShowMsgTip(i18n("CombineServers_39"))
			return
		end
		activity_9001606_Ctrl:reqAgree(self.data.kid)
	elseif self.state == gMergeServerInvitState.NONE then
		dump(activity_9001606_Ctrl:getIsInviteSameGroupKindom(self.data.kid), "activity_9001606_Ctrl:getIsInviteSameGroupKindom(self.data.kid)")
		if activity_9001606_Ctrl:getIsInviteSameGroupKindom(self.data.kid) then
			SoraDShowMsgTip(i18n("CombineServers_52"))
			return
		end
		activity_9001606_Ctrl:reqInvite(self.data.kid)
	elseif self.state == gMergeServerInvitState.INVITED then
		activity_9001606_Ctrl:reqCancel(self.data.kid)
	elseif self.state == gMergeServerInvitState.AGREED then
		SoraDShowMsgBoxNew(i18n("CombineServers_40"), i18n("common_text_204"), i18n("common_text_185"), function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			activity_9001606_Ctrl:reqUnbind(self.data.kid)
		end)
	end
end
return Com_9001606_kingdom
