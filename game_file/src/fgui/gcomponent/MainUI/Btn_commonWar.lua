local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local remainsTeamCtrl = SoraDGetCtrl("remainsTeamCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_commonWar = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_commonWar", Btn_commonWar)
function Btn_commonWar:onInit()
	self.index = 1
	self.showIndex = 1
	self.seconds = 0
	self.changeSec = 10
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self.Text_Time:setTimeUpdateListener(handler(self, self.updateShow))
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_commonWar:onShow()
end
function Btn_commonWar:initData(data)
	self.showIndex = 1
	self.seconds = 0
	self.list = data.list
	self.index = self.list[self.showIndex].ctype
	self:initView()
end
function Btn_commonWar:initView()
	self.controllers.c1:setSelectedIndex(self.index - 1)
	local leftTime = 0
	if self.index == 1 then
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		local coolQueue = queueCtrl:queryQueue(gQueueTypeDef.world_resource_cool, gWorldResourceCoolQueueId)
		if coolQueue then
			leftTime = coolQueue.timerNode.timer:getRemainTime()
		end
	elseif self.index == 2 then
		leftTime = conquestWarCtrl:getLeftTime()
	elseif self.index == 3 then
		leftTime = remainsTeamCtrl:getWarStatusTime()
	elseif self.index == 4 then
		local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY)
		if _eventTime then
			leftTime = _eventTime.timerNode.timer:getRemainTime()
		end
	elseif self.index == 5 then
		local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
		if _eventTime then
			leftTime = _eventTime.timerNode.timer:getRemainTime()
		end
	elseif self.index == 6 then
		local _eventTime = SoraDGetCtrl("atlantisActivityCtrl"):getStageEndTime()
		if _eventTime then
			leftTime = _eventTime - serviceFunctions.systemTime()
		end
	elseif self.index == 7 then
		local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.KING_STAR_BATTLE)
		if _eventTime then
			leftTime = _eventTime.timerNode.timer:getRemainTime()
		end
	end
	if leftTime and 0 < leftTime then
		self.Text_Time:beginTime(leftTime)
	end
end
function Btn_commonWar:updateShow()
	self.seconds = self.seconds + 1
	if self.seconds > self.changeSec then
		self.seconds = 0
		self.showIndex = self.showIndex + 1
		if self.showIndex > #self.list then
			self.showIndex = 1
		end
		self.index = self.list[self.showIndex].ctype
		self:initView()
	end
end
function Btn_commonWar:onBtnClick()
	SoraDPlaySound()
	if self.index == 1 then
		SoraDGotoWorldMapPoint(cc.p(gPlaceSetting[gPlaceId].x, gPlaceSetting[gPlaceId].y), true)
	elseif self.index == 2 then
		uiManager:show("kingdomBattleReady")
	elseif self.index == 3 then
		SoraDCreatePanel("remainsWarActivity"):show()
	elseif self.index == 4 then
		SoraDCreatePanel("newTrialMainView"):show()
	elseif self.index == 5 then
		SoraDCreatePanel("legendaryKingActivity"):show()
	elseif self.index == 6 then
		uiManager:show("atlantisWarActivity")
	elseif self.index == 7 then
		uiManager:show("KingStarActivity")
	end
end
return Btn_commonWar
