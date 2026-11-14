local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local simulatedDrillUtil = include("simulatedDrillUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillResultPanel = class("SimulatedDrillResultPanel", baseFguiPanel)
function SimulatedDrillResultPanel:ctor(...)
	self.isLRU = true
	SimulatedDrillResultPanel.super.ctor(self, ...)
	print("SimulatedDrillResultPanel:ctor", self.viewName)
end
function SimulatedDrillResultPanel:onInit()
	print("=======SimulatedDrillResultPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_quit:setTitle(i18n("common_text_204"))
	self.fields.Button_quit:addClickListener(handler(self, self.onClickClose))
	local _fields = fguiHelper.get_fields(self.fields.Com_resultTitle)
	_fields.Text_rank:setString(i18n("simulated_drill_title_05"))
	_fields.Text_name:setString(i18n("simulated_drill_title_06"))
	_fields.Text_score:setString(i18n("nebula_war_text_0104"))
	if not SoraDFIsRA() then
		self.fields.Image_victory:setURL("frame_DrillGrounds_shengli04.png")
		self.fields.Image_lose:setURL("frame_DrillGrounds_shibai04.png")
		self.fields.Com_resultTitle:fixChildrenPos()
	end
end
function SimulatedDrillResultPanel:endShow()
	print("=======SimulatedDrillResultPanel:endShow")
	self.playerList, _ENV = print, print
	self.isWin = false
	self:initData()
end
function SimulatedDrillResultPanel:initData()
	local selfCamp = simulatedDrillCtrl:getSelfCamp() or SIMULATED_DRILL_WAR_CAMP.WEST
	local campName = simulatedDrillUtil.getCampName(selfCamp)
	self.fields.Text_campName:setString(campName)
	local notifyData = self.param.notifyData
	if not notifyData then
		return
	end
	local winCamp = notifyData.winCamp
	self.isWin = winCamp == selfCamp
	if self.isWin then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_tip:setString(i18n("simulated_drill_text_34"))
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_tip:setString(i18n("simulated_drill_text_35"))
	end
	local campMap = notifyData.campMap
	local campInfo = campMap[selfCamp]
	if not campInfo.players then
		simulatedDrillCtrl = campInfo.players
	end
	self.playerList = campInfo.players
	self.fields.List:setNumItems(#self.playerList)
end
function SimulatedDrillResultPanel:itemRenderer_List(index, obj)
	local rank = index + 1
	local data = self.playerList[rank]
	obj:initData(data, self.isWin, rank)
end
function SimulatedDrillResultPanel:onHide(...)
	print("==SimulatedDrillResultPanel:onHide==")
	if self.param.isCheat then
		return
	end
	if not worldMapDefine.isInSimulatedDrill() then
		_G.SoraDQuickLogin()
	else
		kingdomMapCtrl:setIsBattleEnd(gKingdomClassType.simulatedDrill, false)
	end
end
function SimulatedDrillResultPanel:initCheatData()
	if self.param.notifyData then
		return
	end
	local _UPVALUE0_, players = self.param.notifyData, self.param.notifyData
	for i = 1, 5 do
		_UPVALUE0_ = nil
		;(nil).uid = i
		;(nil).iconID = 1402
		;(nil).avatar = ""
		;(nil).nickName = "player" .. i
		;(nil).fromKid = i
		;(nil).totalFc = i * 777777
		players[i], (nil).killArmyFc = nil, i * 77777
	end
	_UPVALUE0_ = (for index)
	_UPVALUE0_, _UPVALUE0_, (1).winCamp = 1, 5, 2
	;(1).occupyScore = 100
	_UPVALUE0_, (5)[1], (1).players = 1, 1, players
	;(1).occupyScore = 0
	;(1).campMap, (5)[2], (1).players = 5, 1, players
	local notifyData = 1
	self.param.notifyData = notifyData
	self.param.isCheat = true
end
return SimulatedDrillResultPanel
