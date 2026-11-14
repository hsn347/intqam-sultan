local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillCampPanel = class("SimulatedDrillCampPanel", baseFguiPanel)
function SimulatedDrillCampPanel:ctor(...)
	self.isLRU = true
	SimulatedDrillCampPanel.super.ctor(self, ...)
	print("SimulatedDrillCampPanel:ctor", self.viewName)
end
function SimulatedDrillCampPanel:onInit()
	print("=======SimulatedDrillCampPanel:onInit")
	self.fields.Com_title:initData(i18n("simulated_drill_title_04"), handler(self, self.onClickClose))
	self.fields.Button_quit:setTitle(i18n("common_text_3351"))
	self.fields.Button_quit:addClickListener(handler(self, self.onClickBtnQuit))
	self.fields.List_camp1:setItemRenderer(handler(self, self.itemRenderer_List_camp1))
	self.fields.List_camp2:setItemRenderer(handler(self, self.itemRenderer_List_camp2))
end
function SimulatedDrillCampPanel:endShow()
	print("=======SimulatedDrillCampPanel:endShow")
	self.fields.Button_quit:setEnabled(false)
	simulatedDrillCtrl:reqRoomData()
end
function SimulatedDrillCampPanel:itemRenderer_List_camp1(index, obj)
	local player = self.playerList1[index + 1]
	obj:initData(player)
end
function SimulatedDrillCampPanel:itemRenderer_List_camp2(index, obj)
	local player = self.playerList2[index + 1]
	obj:initData(player)
end
function SimulatedDrillCampPanel:onClickBtnQuit(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("simulated_drill_text_33")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		simulatedDrillCtrl:reqQuitBattleField()
	end
	uiManager:show("MessageBox", nil)
end
function SimulatedDrillCampPanel:updateRoomData()
	self.playerList1 = simulatedDrillCtrl:getRoomCampPlayerList(SIMULATED_DRILL_WAR_CAMP.WEST)
	self.playerList2 = simulatedDrillCtrl:getRoomCampPlayerList(SIMULATED_DRILL_WAR_CAMP.EAST)
	self.fields.List_camp1:setNumItems(#self.playerList1)
	self.fields.List_camp2:setNumItems(#self.playerList2)
	local remainTime = simulatedDrillCtrl:getWarTipRemainTime()
	if 0 < remainTime then
		self.fields.Button_quit:setEnabled(false)
	else
		self.fields.Button_quit:setEnabled(true)
	end
end
function SimulatedDrillCampPanel:onMsgUpdateRoomData(...)
	self:updateRoomData()
end
return SimulatedDrillCampPanel
