local baseComponent = require("fgui.base.baseComponent")
local Btn_9001593 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_9001593", Btn_9001593)
function Btn_9001593:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_9001593:onShow()
end
function Btn_9001593:setModel(model)
	self.model = model
	local iconPng = "icon_activity_9001593.png"
	if self.model == 54 then
		iconPng = "icon_activity_9001690.png"
	end
	self.fields.icon:setURL(iconPng)
end
function Btn_9001593:setTime(time)
	self.Text_Time:beginTime(time)
end
function Btn_9001593:onBtnClick()
	SoraDPlaySound()
	if self.model == 54 then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY)
	else
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY)
	end
end
return Btn_9001593
