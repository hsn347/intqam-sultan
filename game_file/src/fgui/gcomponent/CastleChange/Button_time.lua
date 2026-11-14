local baseComponent = require("fgui.base.baseComponent")
local Button_time = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CastleChange/Button_time", Button_time)
function Button_time:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Button_time:onShow()
end
function Button_time:initData(data, tag, index)
	self.data = data
	self.index = index
	self:setTitle(i18n(self.data.title))
	self:setSelected(tag == self.index)
end
function Button_time:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_DRESS_TIME_SELECT"
	;(nil).tag = self.index
	SoraDSendMessage(nil)
end
return Button_time
