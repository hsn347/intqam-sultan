local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local shiftingstarsRead = include("shiftingstarsRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_iceShimmer = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_iceShimmer", Btn_iceShimmer)
function Btn_iceShimmer:onInit()
	self.fields.lab_red:setVisible(false)
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_iceShimmer:onShow()
end
function Btn_iceShimmer:initData(data)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY) then
		local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY)
		if eventTime then
			local remainTime = eventTime.timerNode.timer:getRemainTime()
			if 0 < remainTime then
				self.Text_Time:beginTime(remainTime)
			end
		end
	end
end
function Btn_iceShimmer:onBtnClick()
	SoraDPlaySound()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY)
	self.fields.lab_red:setVisible(false)
	uiManager:show("IceShimmer")
end
return Btn_iceShimmer
