local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local simulatedDrillRead = include("simulatedDrillRead")
local simulatedDrillUtil = include("simulatedDrillUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SimulatedDrillBuildPanel = class("SimulatedDrillBuildPanel", baseFguiPanel)
function SimulatedDrillBuildPanel:ctor(...)
	self.isLRU = true
	SimulatedDrillBuildPanel.super.ctor(self, ...)
	print("SimulatedDrillBuildPanel:ctor", self.viewName)
end
function SimulatedDrillBuildPanel:onInit()
	print("=======SimulatedDrillBuildPanel:onInit")
	self.selfCamp = simulatedDrillCtrl:getSelfCamp()
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	self.fields.Text_occupy:setString(i18n("common_text_1426"))
	self.fields.Button_record:setTitle(i18n("common_text_836"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	self.fields.Text_noOccupy:setString(i18n("simulated_drill_text_30"))
	self.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).color = "#F0E6D2"
		return i18n("common_text_3136") .. SoraDWrapHtmlTagByStyle(ticket, nil)
	end)
end
function SimulatedDrillBuildPanel:endShow()
	print("=======SimulatedDrillBuildPanel:endShow")
	self.objId = self.param.objId
	local buildName = simulatedDrillRead.getBuildName(self.objId)
	self.fields.Text_build:setString(buildName)
	local remainTime = simulatedDrillCtrl:getWarRemainTime()
	if 0 < remainTime then
		self.Text_time:beginTime(remainTime)
	end
	self:updateData(self.param.data)
end
function SimulatedDrillBuildPanel:updateData(data)
	if not data then
		return
	end
	dump(data, "==SimulatedDrillBuildPanel:updateData==")
	self.data = data
	self.fromKid = self.data.fromKid
	self.fromCamp = self.data.camp
	self:updatePlayerInfo(self.data)
end
function SimulatedDrillBuildPanel:updatePlayerInfo(data)
	if self.fromCamp and self.fromCamp > 0 then
		self.controllers.state:setSelectedIndex(1)
		local nameColor = simulatedDrillUtil.getPlayerNameColor(self.fromCamp, self.selfCamp)
		self.fields.Text_camp:setColor(nameColor)
		local campName = simulatedDrillUtil.getCampName(self.fromCamp)
		self.fields.Text_camp:setString(campName)
		local playerName = textParser.formatPlayerName(nil, data.nickName, self.fromKid)
		self.fields.Text_player:setString(playerName)
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	else
		self.controllers.state:setSelectedIndex(0)
	end
end
function SimulatedDrillBuildPanel:onClickBtnHelp(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("nebula_war_text_0264")
	;(nil).content = i18n("simulated_build_des_01")
	uiManager:show("RuleView", nil)
end
function SimulatedDrillBuildPanel:onClickBtnRecord(context)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("batteryStateViewLogRecord")
	local buildName = simulatedDrillRead.getBuildName(self.objId)
	_ENV = nil
	;(nil).place = buildName
	;(nil).buildId = self.objId
	;(nil).warType = gKingdomClassType.simulatedDrill
	panel:initData(nil)
	panel:show()
end
function SimulatedDrillBuildPanel:onMsgBuildUpdate(target, event)
	if event.objId ~= self.objId then
		return
	end
	self:updateData(event.data)
end
return SimulatedDrillBuildPanel
