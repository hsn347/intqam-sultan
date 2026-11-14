local gametop = gModuleMgr.getObject("gametop")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001606_myKingdom = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
local nationalFlagRead = include("nationalFlagRead")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
fgui.register_extension("ui://Activity_9001606/Com_9001606_myKingdom", Com_9001606_myKingdom)
function Com_9001606_myKingdom:onInit()
	self:fixChildrenPos()
	self.fields.txt_server:setString(i18n("CombineServers_13"))
	self.fields.btn_detail:setTitle(i18n("CombineServers_20"))
	self.fields.btn_detail:addClickEventListener(handler(self, self.onDetailClick))
	self.fields.btn_unbind:setTitle(i18n("CombineServers_18"))
	self.fields.btn_unbind:addClickEventListener(handler(self, self.onUnBindClick))
	self.fields.btn_mail:addClickEventListener(handler(self, self.onMailClick))
end
function Com_9001606_myKingdom:onShow()
end
function Com_9001606_myKingdom:initData(data, isShowPower)
	if data == nil then
		return
	end
	self.data = data
	local kindomName = (data.kingdomName == "" and i18n("common_text_479") or data.kingdomName) .. "#" .. data.kid
	self.fields.txt_serverName:setString(kindomName)
	if isShowPower then
		self.fields.txt_power:setString(i18n("CombineServers_15"))
		self.fields.txt_powerValue:setString(data.power)
	else
		if not data.kingInfo.isAgentKing then
			self.fields.txt_power:setString(i18n("CombineServers_11"))
		else
			self.fields.txt_power:setString(i18n("CombineServers_12"))
		end
		self.fields.txt_powerValue:setString(data.kingInfo == nil and data.kingdomName or data.kingInfo.nickName)
	end
	self.fields.icon:setURL(kingdomCtrl:getKindomPalaceModelIcon(data.kid))
	self.fields.btn_mail:setVisible(activity_9001606_Ctrl:getIsKing() and not activity_9001606_Ctrl:getIsSelfKingdom(data.kid))
end
function Com_9001606_myKingdom:onDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = "detail"
	uiManager:show("Activity_9001606_showing", nil)
end
function Com_9001606_myKingdom:onMailClick()
	SoraDPlaySound()
	if not self.data.kingInfo then
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
function Com_9001606_myKingdom:setUnBindVisible(value)
	self.fields.btn_detail:setVisible(false)
	self.fields.btn_unbind:setVisible(value)
end
function Com_9001606_myKingdom:onUnBindClick()
	SoraDPlaySound()
	SoraDShowMsgBoxNew(i18n("CombineServers_40"), i18n("common_text_204"), i18n("common_text_185"), function(exitType, other)
		if exitType ~= MSGBOX_CALLBACK_YES then
			return
		end
		activity_9001606_Ctrl:reqUnbind(self.data.kid)
	end)
end
return Com_9001606_myKingdom
