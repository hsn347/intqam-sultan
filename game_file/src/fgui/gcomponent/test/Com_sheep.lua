local baseComponent = require("fgui.base.baseComponent")
local Com_sheep = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://test/Com_sheep", Com_sheep)
function Com_sheep:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Com_sheep:onShow()
end
function Com_sheep:initData(data, isFromMove)
	self.data = data
	self.isFromMove = isFromMove
	self.fields.title:setString(string.char(64 + self.data.id))
end
function Com_sheep:getData()
	return self.data
end
function Com_sheep:onClick()
	_ENV = nil
	;(nil).msg = "MESSAGE_GAME_SHEEP_CHOOSE"
	;(nil).data = self.data
	;(nil).isFromMove = self.isFromMove
	SoraDSendMessage(nil)
end
return Com_sheep
