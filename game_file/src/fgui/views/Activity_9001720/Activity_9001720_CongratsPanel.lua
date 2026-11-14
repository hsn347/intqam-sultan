local activity_9001720_Ctrl = SoraDGetCtrl("activity_9001720_Ctrl")
local CommonCongratulationsPanel = include_fgui("CommonCongratulationsPanel")
local Activity_9001720_CongratsPanel = class("Activity_9001720_CongratsPanel", CommonCongratulationsPanel)
function Activity_9001720_CongratsPanel:ctor(...)
	Activity_9001720_CongratsPanel.super.ctor(self, ...)
	print("Activity_9001720_CongratsPanel:ctor", self.viewName)
end
function Activity_9001720_CongratsPanel:onInit()
	Activity_9001720_CongratsPanel.super.onInit(self)
	print("=======Activity_9001720_CongratsPanel:onInit")
end
function Activity_9001720_CongratsPanel:onShow()
	Activity_9001720_CongratsPanel.super.onShow(self)
	print("=======Activity_9001720_CongratsPanel:onShow")
	local recordStr = self.param and self.param.recordStr
	if recordStr then
		self.fields.Text_des:setString(recordStr)
		local addScrollH = 45 + self.fields.Text_des:getHeight()
		Activity_9001720_CongratsPanel = nil
		;(nil).scrollH = self.scrollH + addScrollH
		self.fields.Com_base:initBaseData(nil)
		self.fields.List:setPositionY(self.fields.List:getPositionY() - addScrollH / 2)
	end
end
return Activity_9001720_CongratsPanel
