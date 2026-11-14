local LOOP_TIME = 30
local baseComponent = require("fgui.base.baseComponent")
local Com_stageLoop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroNewTrial/Com_stageLoop", Com_stageLoop)
function Com_stageLoop:onInit()
	self.fields.Text_doing:setString(i18n("common_text_4833"))
	self.fields.Text_doing = SoraDCreateTimerLabel(self, self.fields.Text_doing)
	self.fields.Text_doing:setTimeLast(function(time, num)
		self.fields.bar:setFillAmount(1 - num / LOOP_TIME)
		return i18n("common_text_4833")
	end)
	self.fields.Text_doing:setTimeEndListener(handler(self, self.doneLoop))
end
function Com_stageLoop:onShow()
end
function Com_stageLoop:setOutLook(index)
	self.controllers.c2:setSelectedIndex(index)
end
function Com_stageLoop:idle()
	self.controllers.c1:setSelectedIndex(0)
end
function Com_stageLoop:doing(handle)
	self.handle = handle
	self.controllers.c1:setSelectedIndex(1)
	self.fields.bar:setFillAmount(0)
	self.fields.Text_doing:beginTime(LOOP_TIME)
end
function Com_stageLoop:doneLoop()
	if self.handle then
		self.handle()
	end
end
return Com_stageLoop
