local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameTreasureCave_PopPanel = class("RoaringFlameTreasureCave_PopPanel", baseFguiPanel)
function RoaringFlameTreasureCave_PopPanel:ctor(...)
	self.isLRU = true
	RoaringFlameTreasureCave_PopPanel.super.ctor(self, ...)
	print("RoaringFlameTreasureCave_PopPanel:ctor", self.viewName)
end
function RoaringFlameTreasureCave_PopPanel:onInit()
	print("=======RoaringFlameTreasureCave_PopPanel:onInit")
	self.caveWeekTimes = roaringFlameWarRead.getConstValue("FLAMES_DUNES_CAVE_WEEK_TIMES", 5)
	self.fields.Text_title:setString(i18n("flames_dunes_text147"))
	self.fields.Text_tip:setString(i18n("flames_dunes_text132"))
	self.fields.Text_title:setAlign(2)
	self.fields.Text_tip:setAlign(2)
	self.fields.Button_explore:setString(i18n("Eidal_feast_text_22"))
	self.fields.Button_explore:addClickListener(handler(self, self.btnExploreClick))
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("flames_dunes_text148", nil)
	end)
end
function RoaringFlameTreasureCave_PopPanel:endShow()
	print("=======RoaringFlameTreasureCave_PopPanel:endShow")
	self.data = self.param.data
	self.leftTime = self.data.endTime - serviceFunctions.systemTime()
	self.fields.Label_time:beginTime(self.leftTime)
	roaringFlameWarCtrl:reqCaveData()
end
function RoaringFlameTreasureCave_PopPanel:initView(target, data)
	if data and data.key == "data" then
		self.leftReceiveCaveCount = self.caveWeekTimes - (data.receiveCaveCount or 0)
		self.fields.Com_award:initData(self.leftReceiveCaveCount)
	end
end
function RoaringFlameTreasureCave_PopPanel:btnExploreClick()
	SoraDPlaySound()
	if self.data.state == gRoaringFlameWarCaveStateEnum.EXPLORE and self.leftTime <= 0 or self.data.state == gRoaringFlameWarCaveStateEnum.EXPLORE_FINISH then
		SoraDShowMsgTip(i18n("flames_dunes_text149"))
		return
	end
	if SoraDisInList(SoraDGetPlayerID(), self.data.uidList) then
		SoraDShowMsgTip(i18n("flames_dunes_text150"))
		return
	end
	if roaringFlameWarCtrl:getCaveMapNum() >= roaringFlameWarRead.getConstValue("FLAMES_DUNES_CAVE_TEAM", 1) then
		SoraDShowMsgTip(i18n("flames_dunes_text342"))
		return
	end
	roaringFlameWarCtrl:reqExploreCave(self.data.objId)
	self:close()
end
return RoaringFlameTreasureCave_PopPanel
