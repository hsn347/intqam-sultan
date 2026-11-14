local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillRoomPanel = class("SimulatedDrillRoomPanel", baseFguiPanel)
function SimulatedDrillRoomPanel:ctor(...)
	self.isLRU = true
	SimulatedDrillRoomPanel.super.ctor(self, ...)
	print("SimulatedDrillRoomPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY
end
function SimulatedDrillRoomPanel:onInit()
	print("=======SimulatedDrillRoomPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_camp1:setString(i18n("simulated_drill_title_02"))
	self.fields.Text_camp2:setString(i18n("simulated_drill_title_03"))
	self.fields.List_camp1:setItemRenderer(handler(self, self.itemRenderer_List_camp1))
	self.fields.List_camp2:setItemRenderer(handler(self, self.itemRenderer_List_camp2))
	self.fields.Button_start:addClickListener(handler(self, self.onClickBtnStart))
	self.fields.Button_chat:setTitle(i18n("simulated_drill_btn_03"))
	self.fields.Button_chat:addClickListener(handler(self, self.onClickBtnChat))
	self.fields.Button_quit:setTitle(i18n("simulated_drill_text_42"))
	self.fields.Button_quit:addClickListener(handler(self, self.onClickBtnQuit))
	self.fields.Button_setting:setString(i18n("common_text_713"))
	self.fields.Button_setting:addClickListener(handler(self, self.onClickBtnSetting))
	self.fields.Button_share:setString(i18n("common_text_533"))
	self.fields.Button_share:addClickListener(handler(self, self.onClickBtnShare))
end
function SimulatedDrillRoomPanel:onHide()
	print("==SimulatedDrillRoomPanel:onHide==", self.isHost, self.isReady)
	if worldMapDefine.isInSimulatedDrill() then
		return
	end
	if not self.isHost and self.isReady then
		simulatedDrillCtrl:reqRoomReady(false)
	end
end
function SimulatedDrillRoomPanel:close(context)
	if not self.isHost and self.isReady then
		SoraDShowMsgTip(i18n("simulated_drill_text_16"))
		return
	end
	SimulatedDrillRoomPanel.super.close(self, context)
end
function SimulatedDrillRoomPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("simulated_drill_text_44")
	uiManager:show("RuleView", nil)
end
function SimulatedDrillRoomPanel:endShow()
	print("=======SimulatedDrillRoomPanel:endShow")
	simulatedDrillCtrl:reqRoomData()
	self:updateNewTeamMsg()
end
function SimulatedDrillRoomPanel:itemRenderer_List_camp1(index, obj)
	local rank = index + 1
	local player = self.playersMap1[tostring(rank)]
	_ENV = nil
	;(nil).camp = SIMULATED_DRILL_WAR_CAMP.WEST
	;(nil).rank = rank
	;(nil).player = player
	obj:initData(nil)
end
function SimulatedDrillRoomPanel:itemRenderer_List_camp2(index, obj)
	local rank = index + 1
	local player = self.playersMap2[tostring(rank)]
	_ENV = nil
	;(nil).camp = SIMULATED_DRILL_WAR_CAMP.EAST
	;(nil).rank = rank
	;(nil).player = player
	obj:initData(nil)
end
function SimulatedDrillRoomPanel:onClickBtnStart(context)
	SoraDPlaySound()
	if self.isHost then
		simulatedDrillCtrl:reqRoomStart()
	else
		simulatedDrillCtrl:reqRoomReady(not self.isReady)
	end
end
function SimulatedDrillRoomPanel:onClickBtnChat(context)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("teamChatView")
	panel:initWithActivityID(self.activityID)
	panel:show()
end
function SimulatedDrillRoomPanel:onClickBtnQuit(context)
	SoraDPlaySound()
	if self.isHost then
		local content = ""
		local playerCount = simulatedDrillCtrl:getRoomPlayerCount()
		if 1 < playerCount then
			content = i18n("simulated_drill_text_15")
		else
			content = i18n("simulated_drill_text_49")
		end
		_ENV = nil
		;(nil).content = content
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			simulatedDrillCtrl:reqRoomQuit()
		end
		uiManager:show("MessageBox", nil)
	else
		if self.isReady then
			SoraDShowMsgTip(i18n("simulated_drill_text_16"))
			return
		end
		simulatedDrillCtrl:reqRoomQuit()
	end
end
function SimulatedDrillRoomPanel:onClickBtnSetting(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).isSetting = true
	uiManager:show("SimulatedDrillCreateRoom", nil)
end
function SimulatedDrillRoomPanel:onClickBtnShare(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("worldMapCordinateShareView", nil)
end
function SimulatedDrillRoomPanel:updateRoomData()
	self.playersMap1 = simulatedDrillCtrl:getRoomCampPlayers(SIMULATED_DRILL_WAR_CAMP.WEST)
	self.playersMap2 = simulatedDrillCtrl:getRoomCampPlayers(SIMULATED_DRILL_WAR_CAMP.EAST)
	local playerMax = simulatedDrillCtrl:getRoomPlayerMax() / 2
	self.fields.List_camp1:setNumItems(playerMax)
	self.fields.List_camp2:setNumItems(playerMax)
	self.isHost = simulatedDrillCtrl:checkSelfIsHost()
	if self.isHost then
		self.fields.Button_start:setTitle(i18n("simulated_drill_btn_02"))
	else
		self.isReady = simulatedDrillCtrl:checkSelfIsReady()
		if self.isReady then
			self.fields.Button_start:setTitle(i18n("simulated_drill_btn_01"))
		else
			self.fields.Button_start:setTitle(i18n("krone_text_30"))
		end
	end
	self.fields.Button_setting:setVisible(self.isHost or false)
	self.fields.Button_share:setVisible(self.isHost or false)
	local roomName = simulatedDrillCtrl:getRoomName()
	simulatedDrillCtrl = i18n("krone_text_30")
	i18n("krone_text_30").name = roomName
	self.fields.Text_roomName:setString(i18n("chat_text_06", i18n("krone_text_30")))
	local roomPrivate = simulatedDrillCtrl:getRoomPrivate()
	local stateStr = roomPrivate and i18n("simulated_drill_text_22") or i18n("simulated_drill_text_21")
	local stateColor = roomPrivate and "#FF0000" or "#70C723"
	simulatedDrillCtrl = i18n("chat_text_06", i18n("krone_text_30"))
	simulatedDrillCtrl, simulatedDrillCtrl, i18n("chat_text_06", i18n("krone_text_30")).state = i18n("chat_text_06", i18n("krone_text_30"))
	i18n("chat_text_06", i18n("krone_text_30")).state, i18n("chat_text_06", i18n("krone_text_30")).color = i18n("chat_text_06", i18n("krone_text_30"))
	local roomState = i18n_html("simulated_drill_text_20", i18n("chat_text_06", i18n("krone_text_30")))
	self.fields.Text_roomState:setString(roomState)
	local roomPassword = simulatedDrillCtrl:getRoomPassword()
	if roomPassword then
		self.fields.Text_password:setVisible(true)
		simulatedDrillCtrl = true
		simulatedDrillCtrl, simulatedDrillCtrl, (true).password = i18n("chat_text_06", i18n("krone_text_30"))
		i18n("chat_text_06", i18n("krone_text_30")).password, i18n("chat_text_06", i18n("krone_text_30")).color = i18n("chat_text_06", i18n("krone_text_30"))
		local password = i18n_html("simulated_drill_text_19", true, i18n("chat_text_06", i18n("krone_text_30")))
		self.fields.Text_password:setString(password)
	else
		self.fields.Text_password:setVisible(false)
	end
end
function SimulatedDrillRoomPanel:onMsgUpdateRoomData(target, event)
	dump(event, "SimulatedDrillRoomListPanel:onMsgUpdateRoomData", 10)
	local room = simulatedDrillCtrl:getSelfRoom()
	if room then
		self:updateRoomData()
	else
		SoraDRemoveAllAfterPanelFromManager(self)
		uiManager:show("SimulatedDrillRoomList")
		if event.subMsg == "beKicked" then
			SoraDShowMsgTip(i18n("simulated_drill_text_25"))
		end
	end
end
function SimulatedDrillRoomPanel:onMsgUpdateTeamMsg(target, event)
	dump(event, "SimulatedDrillRoomListPanel:onMsgUpdateTeamMsg", 10)
	self:updateNewTeamMsg()
end
function SimulatedDrillRoomPanel:updateNewTeamMsg()
	local hasNewTeamMsg = simulatedDrillCtrl:isHasNewTeamMsg()
	self.fields.Button_chat:setReddot(hasNewTeamMsg)
end
return SimulatedDrillRoomPanel
