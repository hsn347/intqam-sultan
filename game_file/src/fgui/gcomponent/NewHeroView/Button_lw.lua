local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_lw = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Button_lw", Button_lw)
function Button_lw:onInit()
	self.fields.Text_activity_time = SoraDCreateTimerLabel(self, self.fields.Text_activity_time)
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
	self:addEventListener(fgui.UIEventType.TouchEnd, function()
		self.controllers.c2:setSelectedIndex(0)
	end)
end
function Button_lw:onShow()
end
function Button_lw:initData(cfg)
	self.cfg = cfg
	local eventTime = activityShowCtrl:getTimeInfoByID(self.cfg.activityID)
	if eventTime then
		self.fields.Text_activity_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self.controllers.c1:setSelectedIndex(self.cfg.control)
	self.fields.Text_activity_name:setString(i18n(self.cfg.name))
	self.fields.Text_des:setString(i18n(self.cfg.desc))
end
function Button_lw:onLongPress()
	SoraDPlaySound()
	self.controllers.c2:setSelectedIndex(1)
end
function Button_lw:onClick()
	SoraDPlaySound()
	self.controllers.c2:setSelectedIndex(0)
end
return Button_lw
