local lordLocalData = include("lordLocalData")
local conquestWarCtrl = include("conquestWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Invitation_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Invitation_single", Invitation_single)
function Invitation_single:onInit()
	self:fixChildrenPos()
	self.fields.n20:fix()
	self.fields.n18:fix()
	self.fields.Button_Chat:addClickListener(handler(self, self.onClickChat))
	self.fields.Button_Chat:setString(i18n("conquestwar_text_25"))
	self.fields.Button_Cancle:addClickListener(handler(self, self.onClickCancle))
	self.fields.Button_Cancle:setString(i18n("conquestwar_text_49"))
	self.fields.Image_bust:addClickListener(handler(self, self.onClickHead))
end
function Invitation_single:onShow()
end
function Invitation_single:initData(data)
	self.uid = data.uid
	self.nickName = data.nickName
	self.abbr = data.abbr
	self.state = data.state
	self.fields.Image_bust:setURL(lordLocalData.getBust(data.iconID))
	self.fields.Text_name:setString(textParser.formatPlayerName(data.abbr, data.nickName, data.kid))
	self.fields.Text_Power:setString(string.formatnumberthousands(data.strength))
	self.fields.Text_Kingdom:setString(string.format("#%d", data.kid))
	if self.state == gConquestWarReinforcementsState.AGREE then
		self.fields.Text_Status:setString(i18n("conquestwar_text_23"))
	elseif self.state == gConquestWarReinforcementsState.REJECT then
		self.fields.Text_Status:setString(i18n("conquestwar_text_22"))
	elseif self.state == gConquestWarReinforcementsState.INVETED then
		self.fields.Text_Status:setString(i18n("conquestwar_text_21"))
	end
	self.controllers.c1:setSelectedIndex(self.state - 1)
end
function Invitation_single:onClickChat()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.targetType = gMailType.CHAT
	SoraDPlaySound.target = self.uid
	SoraDPlaySound.nickName = self.nickName
	local SoraDPlaySound.allianceAbbr, data = self.abbr, SoraDPlaySound
	SoraDCreateChatView(data)
end
function Invitation_single:onClickCancle()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("conquestwar_text_24")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		conquestWarCtrl:reqReinforcementsCancle(self.uid)
	end
	uiManager:show("MessageBox", nil)
end
function Invitation_single:onClickHead()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.uid
	;(nil).kid = self.kid
	SoraDSendMessage(nil)
end
return Invitation_single
