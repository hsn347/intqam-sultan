local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local simulatedDrillUtil = include("simulatedDrillUtil")
local simulatedDrillRead = include("simulatedDrillRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_warInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SimulatedDrill/Com_warInfo", Com_warInfo)
function Com_warInfo:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_CAMP_SCORE", handler(self, self.onMsgUpdateCampScore))
	SoraDAddMessage(self, "MESSAGE_SIMULATED_DRILL_BUILD_OWNER", handler(self, self.onMsgUpdateBuildOwner))
end
function Com_warInfo:onInit()
	self.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	local scoreMax = CONST_VALUE.SIMULATED_DRILL_WIN_POINT or 0
	self.fields.bar1:setMax(scoreMax)
	self.fields.bar2:setMax(scoreMax)
	local subType = gWorldTypeServerDef.subTypeSimulatedDrillWarPalace
	self.actionlnv = simulatedDrillRead.getBuildActionlnv(subType)
	self.point = simulatedDrillRead.getBuildPoint(subType)
end
function Com_warInfo:onShow()
	local remainTime = simulatedDrillCtrl:getWarRemainTime()
	self.Text_time:beginTime(remainTime)
	self:updateCampScore()
	self:updateBuildOwner()
end
function Com_warInfo:updateCampScore()
	local score1 = simulatedDrillCtrl:getWarCampScore(SIMULATED_DRILL_WAR_CAMP.WEST)
	self.fields.bar1:setValue(score1)
	local score2 = simulatedDrillCtrl:getWarCampScore(SIMULATED_DRILL_WAR_CAMP.EAST)
	self.fields.bar2:setValue(score2)
end
function Com_warInfo:onMsgUpdateCampScore(target, event)
	self:updateCampScore()
end
function Com_warInfo:updateBuildOwner()
	local speed1, speed2 = 0, 0
	local owner = simulatedDrillUtil.getPalaceOwner()
	local camp = owner and owner.camp or 0
	if camp == SIMULATED_DRILL_WAR_CAMP.WEST then
		speed1 = self.point
	elseif camp == SIMULATED_DRILL_WAR_CAMP.EAST then
		speed2 = self.point
	end
	simulatedDrillUtil = nil
	;(nil).num = speed1
	;(nil).time = self.actionlnv .. "s"
	self.fields.Text_speed1:setString(i18n("simulated_drill_text_32", nil))
	simulatedDrillUtil = i18n("simulated_drill_text_32", nil)
	i18n("simulated_drill_text_32", nil).num = speed2
	i18n("simulated_drill_text_32", nil).time = self.actionlnv .. "s"
	self.fields.Text_speed2:setString(i18n("simulated_drill_text_32", i18n("simulated_drill_text_32", nil)))
end
function Com_warInfo:onMsgUpdateBuildOwner(target, event)
	self:updateBuildOwner()
end
return Com_warInfo
