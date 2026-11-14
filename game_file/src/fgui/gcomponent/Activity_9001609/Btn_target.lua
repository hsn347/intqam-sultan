local activity_9001609_Ctrl = SoraDGetCtrl("activity_9001609_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_target = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001609/Btn_target", Btn_target)
function Btn_target:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_target:onShow()
end
function Btn_target:initData(data)
	self.data = data
	self.fields.title:setString(self.data.taskTarget)
	self.status = 0
	if activity_9001609_Ctrl:isTaskRewarded(self.data.taskID) then
		self.status = 2
	else
		local val = 0
		if self.data.taskType == 1 then
			val = activity_9001609_Ctrl:getBackersCount()
		elseif self.data.taskType == 2 then
			val = activity_9001609_Ctrl:getBackersTotalRecharge()
		elseif self.data.taskType == 3 then
			val = activity_9001609_Ctrl:getBackersCountReachDailyPoint()
		end
		self.status = val >= self.data.taskTarget and 1 or 0
	end
	self.controllers.c1:setSelectedIndex(self.status)
end
function Btn_target:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	;(nil).status = self.status
	uiManager:show("Activity_9001609_pop", nil)
end
return Btn_target
