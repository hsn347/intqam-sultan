local config = require("app." .. LocalTblPath .. ".config_server.act_common_config")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local shiftingstarsRead = include("shiftingstarsRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_shiftingStars = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_shiftingStars", Btn_shiftingStars)
function Btn_shiftingStars:onInit()
	self.fields.lab_red:setVisible(false)
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_shiftingStars:onShow()
end
function Btn_shiftingStars:initData(data)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY) then
		local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
		if eventTime then
			local remainTime = eventTime.timerNode.timer:getRemainTime()
			if 0 < remainTime then
				self.Text_Time:beginTime(remainTime)
			end
		end
	end
end
function Btn_shiftingStars:onBtnClick()
	SoraDPlaySound()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
	self.fields.lab_red:setVisible(false)
	uiManager:show("Shiftingstars")
end
return Btn_shiftingStars
