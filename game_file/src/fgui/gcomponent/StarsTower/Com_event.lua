local baseComponent = require("fgui.base.baseComponent")
local Com_event = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://StarsTower/Com_event", Com_event)
function Com_event:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Com_event:onShow()
end
function Com_event:initData(data, index, curIndex)
	self.index = index
	self.fields.title:setString(i18n(data.name))
	self.fields.icon:setSpriteFrame(data.icon)
	self.controllers.button:setSelectedIndex(index == curIndex and 1 or 0)
end
function Com_event:onClick()
	SoraDPlaySound()
	if self.clickHandle then
		self.clickHandle(self, self.index)
		return
	end
	_ENV = self
	self.msg = "MESSAGE_ACTIVITY_STARSTOWER_UI_SELECT"
	self.index = self.index
	SoraDSendMessage(self)
end
function Com_event:setClickHandle(clickHandle)
	self.clickHandle = clickHandle
end
return Com_event
