local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillJoinRoomPanel = class("SimulatedDrillJoinRoomPanel", baseFguiPanel)
function SimulatedDrillJoinRoomPanel:ctor(...)
	self.isLRU = true
	SimulatedDrillJoinRoomPanel.super.ctor(self, ...)
	print("SimulatedDrillJoinRoomPanel:ctor", self.viewName)
end
function SimulatedDrillJoinRoomPanel:onInit()
	print("=======SimulatedDrillJoinRoomPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Safety_lock_text_04"))
	self.fields.Button_join:setTitle(i18n("common_text_068"))
	self.fields.Button_join:addClickListener(handler(self, self.onClickBtnJoin))
	self.input = self.fields.input:getChild("input")
	self.input:setPrompt(i18n("simulated_drill_text_07"))
end
function SimulatedDrillJoinRoomPanel:endShow()
	print("=======SimulatedDrillJoinRoomPanel:endShow")
	self.input:setText("")
	local roomId = self.param.room.roomId
	simulatedDrillCtrl:reqRoomSearch(roomId, "joinRoom")
end
function SimulatedDrillJoinRoomPanel:onClickBtnJoin(context)
	SoraDPlaySound()
	local room = self.param.room
	local roomId = room.roomId
	local createTime = room.createTime
	local password = self.input:getText()
	simulatedDrillCtrl:reqRoomEnter(roomId, nil, password, createTime, "roomList")
end
return SimulatedDrillJoinRoomPanel
