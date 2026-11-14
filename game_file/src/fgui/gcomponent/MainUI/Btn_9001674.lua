local baseComponent = require("fgui.base.baseComponent")
local Btn_9001674 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_9001674", Btn_9001674)
function Btn_9001674:onInit()
	self.activityID = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY
	self.fields.icon:setSpriteFrame("icon_activity_9001674.png")
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_9001674:onShow()
end
function Btn_9001674:initData(data)
	local info = clientEventMgr.getEventInfoByeid(self.activityID)
	if info and info.eventLeftTime then
		clientEventMgr.getEventTimeString(info.eventLeftTime, function(timefun)
			local timeLeft = clientEventMgr.getEventTimer(self.activityID)
			if timeLeft then
				self.Text_Time:setTimeLast(timefun)
				local remainTime = timeLeft.timerNode.timer:getRemainTime()
				if 0 < remainTime then
					self.Text_Time:beginTime(remainTime)
				else
					self.Text_Time:removeTime()
					self.Text_Time:setString("")
				end
			end
		end, function(timeMsg)
			self.Text_Time:removeTime()
			self.Text_Time:setString(timeMsg)
		end, function()
			self.Text_Time:removeTime()
			self.Text_Time:setString("")
		end)
	end
end
function Btn_9001674:onBtnClick()
	SoraDPlaySound()
	local info = clientEventMgr.getEventInfoByeid(self.activityID)
	if info then
		clientEventMgr.singleClickEvent(self.activityID)
	end
end
return Btn_9001674
