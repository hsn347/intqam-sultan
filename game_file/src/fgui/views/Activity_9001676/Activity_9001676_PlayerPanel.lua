local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001676_PlayerPanel = class("Activity_9001676_PlayerPanel", baseFguiPanel)
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
function Activity_9001676_PlayerPanel:ctor(...)
	self.isLRU = true
	Activity_9001676_PlayerPanel.super.ctor(self, ...)
	print("Activity_9001676_PlayerPanel:ctor", self.viewName)
end
function Activity_9001676_PlayerPanel:onInit()
	print("=======Activity_9001676_PlayerPanel:onInit")
	self.fields.Btn_chat:setTitle(i18n("krone_text_31"))
	self.fields.Btn_chat:addClickEventListener(handler(self, self.onChatClick))
	self.fields.Btn_kick:setTitle(i18n("krone_text_32"))
	self.fields.Btn_kick:addClickEventListener(handler(self, self.onKickClick))
end
function Activity_9001676_PlayerPanel:onChatClick()
	SoraDPlaySound()
	local playerId = self.playerData.uid
	local nickName = self.playerData.name
	local allianceAbbr = self.playerData.abbr
	_ENV = nil
	;(nil).targetType = gMailType.CHAT
	;(nil).target = playerId
	;(nil).nickName = nickName
	local (nil).allianceAbbr, data = allianceAbbr, nil
	SoraDCreateChatView(data)
	self:close()
end
function Activity_9001676_PlayerPanel:onKickClick()
	SoraDPlaySound()
	activity_9001676_Ctrl:reqKoreanChessRoomKick()
	self:close()
end
function Activity_9001676_PlayerPanel:endShow()
	print("=======Activity_9001676_PlayerPanel:endShow")
	self.playerData = self.param.playerData
	self:updateView()
end
function Activity_9001676_PlayerPanel:updateView()
	self.fields.Spine_lord:initData(self.playerData.headid)
	self.fields.Text_name:setString(self.playerData.name)
	self.fields.Btn_kick:setVisible(not self.param.isHost)
end
return Activity_9001676_PlayerPanel
