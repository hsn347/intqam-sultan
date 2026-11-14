local activity_9001614_Ctrl = SoraDGetCtrl("activity_9001614_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_activity9001614 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_activity9001614", Com_activity9001614)
function Com_activity9001614:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_activity9001614:onShow()
end
function Com_activity9001614:setTime(time)
	self.Text_Time:beginTime(time)
end
function Com_activity9001614:onBtnClick()
	SoraDPlaySound()
	local ret, gift = activity_9001614_Ctrl:getActiveNotifyGift()
	if ret then
		_ENV = nil
		;(nil).giftData = gift
		uiManager:show("Activity_9001614_notify", nil)
	end
end
return Com_activity9001614
