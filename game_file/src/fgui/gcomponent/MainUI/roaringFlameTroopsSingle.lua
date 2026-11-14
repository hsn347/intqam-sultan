local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local mapSyncUtilClient = include("mapSyncUtilClient")
local baseComponent = require("fgui.base.baseComponent")
local roaringFlameTroopsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/roaringFlameTroopsSingle", roaringFlameTroopsSingle)
function roaringFlameTroopsSingle:onInit()
	self.totalTime = 0
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeUpdateListener(handler(self, self.updateTroopBar))
	self.Text_time:setTimeEndListener(handler(self, self.updateTimeEnd))
	self.fields.Button_troops:addClickListener(handler(self, self.OnBtnTroopsClick))
	self.fields.Button_jump:addClickListener(handler(self, self.OnBtnJumpClick))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.n0:fix()
		self.fields.Bar_et:setScaleX(SoraDFIsRA() and 1 or -1)
	end
end
function roaringFlameTroopsSingle:onShow()
end
function roaringFlameTroopsSingle:OnBtnTroopsClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("notice_0025"), i18n("common_text_054"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			roaringFlameWarCtrl:reqStopCollect(self.queueData.objId)
		end
	end)
end
function roaringFlameTroopsSingle:OnBtnJumpClick()
	SoraDPlaySound()
	if self.qType == 1 then
		local buildPos = roaringFlameWarRead.getBuildCoord(self.queueData.objId)
		SoraDGotoWorldMapPoint(buildPos, true)
	elseif self.qType == 2 then
		local buildPos = cc.p(self.data.x, self.data.y)
		buildPos = mapSyncUtilClient.serverTOClientPos(buildPos)
		SoraDGotoWorldMapPoint(buildPos, true)
	end
end
function roaringFlameTroopsSingle:initData(queueData)
	self.queueData = queueData
	self.qType = queueData.qType
	self.data = queueData.data
	if self.qType == 1 then
		self.fields.Text_state:setString(i18n("common_text_830"))
		self.fields.Button_troops:setVisible(true)
		self.totalTime = self.data.endCollTime - self.data.beginTime
		local remain = self.data.endCollTime - serviceFunctions.systemTime()
		self.Text_time:beginTime(remain)
		self:updateTroopBar(remain)
	elseif self.qType == 2 then
		self.fields.Text_state:setString(i18n("common_text_831"))
		self.fields.Button_troops:setVisible(false)
		self.totalTime = self.data.endTime - self.data.beginTime
		local remain = self.data.endTime - serviceFunctions.systemTime()
		self.Text_time:beginTime(remain)
		self:updateTroopBar(remain)
	end
end
function roaringFlameTroopsSingle:updateTroopBar(times)
	local totalTime = self.totalTime or 1
	local percent = (totalTime - times) / totalTime
	self.fields.Bar_et:setPercent(percent)
end
function roaringFlameTroopsSingle:updateTimeEnd(...)
end
return roaringFlameTroopsSingle
