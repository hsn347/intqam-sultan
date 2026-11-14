local baseComponent = require("fgui.base.baseComponent")
local com_Meteorite_skill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MeteoriteMagicCan/com_Meteorite_skill", com_Meteorite_skill)
function com_Meteorite_skill:onInit()
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.text_time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_UPDATE_METEOR_MAGIC_SKILL"
		SoraDSendMessage(nil)
	end)
	self.fields.icon:addClickEventListener(handler(self, self.onClicked))
end
function com_Meteorite_skill:onShow()
end
function com_Meteorite_skill:initData(skill, idx, isSelected)
	self.idx = idx
	self.fields.name:setString(i18n(skill.info.name))
	self.fields.icon:setIcon(skill.info.icon)
	self.text_time:removeTime()
	if not skill.isUnLock then
		self.controllers.c1:setSelectedIndex(3)
	elseif skill.cdEndtime and skill.cdEndtime > serviceFunctions.systemTime() then
		self.fields.text_cooldown:setString(i18n("common_text_046"))
		self.controllers.c1:setSelectedIndex(1)
		self.text_time:beginTime(skill.cdEndtime - serviceFunctions.systemTime())
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.selected:setVisible(isSelected)
end
function com_Meteorite_skill:setHandler(handler)
	self.clickHandler = handler
end
function com_Meteorite_skill:onClicked()
	if self.clickHandler then
		self.clickHandler(self.idx)
	end
end
return com_Meteorite_skill
