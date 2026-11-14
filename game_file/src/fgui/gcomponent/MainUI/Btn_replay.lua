local baseComponent = require("fgui.base.baseComponent")
local Btn_replay = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_replay", Btn_replay)
function Btn_replay:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_replay:onShow()
	self.Text_Time:setTimeUpdateListener(function()
		gSDKDef.GAME_RECORD_TIME = gSDKDef.GAME_RECORD_TIME + 1
	end)
	self.Text_Time:beginTime(gSDKDef.GAME_RECORD_TIME, true)
end
function Btn_replay:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIN_STOP_RECORD_SCREEN"
	SoraDSendMessage(nil)
end
return Btn_replay
