local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillRoomListPanel = class("SimulatedDrillRoomListPanel", baseFguiPanel)
function SimulatedDrillRoomListPanel:ctor(...)
	self.isLRU = true
	SimulatedDrillRoomListPanel.super.ctor(self, ...)
	print("SimulatedDrillRoomListPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY
end
function SimulatedDrillRoomListPanel:onInit()
	print("=======SimulatedDrillRoomListPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_room:setVirtual()
	self.fields.List_room:setItemRenderer(handler(self, self.onRoomItemRenderer))
	self.fields.Text_noData:setString(i18n("chat_text_01"))
	self.fields.Button_search:setTitle(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.fields.Button_create:setTitle(i18n("chat_btn_02"))
	self.fields.Button_create:addClickListener(handler(self, self.onClickBtnCreate))
	local _fields = fguiHelper.get_fields(self.fields.Com_roomTitle)
	_fields.Text_title1:setString(i18n("simulated_drill_text_47"))
	_fields.Text_title2:setString(i18n("simulated_drill_text_46"))
	_fields.Text_title3:setString(i18n("simulated_drill_text_45"))
	self.input = self.fields.input_search:getChild("input")
	self.input:setPrompt(i18n("simulated_drill_text_02"))
	self.input:setMaxLength(15)
	if not SoraDFIsRA() then
		self.fields.Com_roomTitle:fixChildrenPos()
		self.fields.input_search:fixPos()
		self.fields.Button_search:fixPos()
	end
end
function SimulatedDrillRoomListPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("simulated_drill_text_44")
	uiManager:show("RuleView", nil)
end
function SimulatedDrillRoomListPanel:endShow()
	print("=======SimulatedDrillRoomListPanel:endShow")
	self.input:setText("")
	simulatedDrillCtrl:reqRoomList()
end
function SimulatedDrillRoomListPanel:onRoomItemRenderer(index, obj)
	local room = self.roomList[index + 1]
	obj:initData(room)
end
function SimulatedDrillRoomListPanel:onClickBtnSearch(context)
	SoraDPlaySound()
	local inputText = self.fields.input_search:getInputText()
	if not inputText or inputText == "" then
		simulatedDrillCtrl:reqRoomList()
		return
	end
	local roomId = tonumber(inputText)
	if roomId then
		simulatedDrillCtrl:reqRoomSearch(roomId)
	else
		SoraDShowMsgTip(i18n("simulated_drill_text_01"))
	end
end
function SimulatedDrillRoomListPanel:onClickBtnCreate(context)
	SoraDPlaySound()
	uiManager:show("SimulatedDrillCreateRoom")
end
function SimulatedDrillRoomListPanel:onMsgUpdateRoomList(target, event)
	dump(event, "SimulatedDrillRoomListPanel:onMsgUpdateRoomList", 10)
	if not event.roomList then
		local _ENV, roomList = event.roomList, event.roomList
	end
	self.roomList = roomList
	self.fields.List_room:setNumItems(#self.roomList)
	self.fields.Text_noData:setVisible(#self.roomList == 0)
end
function SimulatedDrillRoomListPanel:onMsgUpdateRoomData(target, event)
	dump(event, "SimulatedDrillRoomListPanel:onMsgUpdateRoomData", 10)
	local subMsg = event.subMsg
	if subMsg == "create" or subMsg == "enter" then
		local room = simulatedDrillCtrl:getSelfRoom()
		if room then
			SoraDRemoveAllAfterPanelFromManager(self)
			uiManager:show("SimulatedDrillRoom")
		end
	end
end
return SimulatedDrillRoomListPanel
