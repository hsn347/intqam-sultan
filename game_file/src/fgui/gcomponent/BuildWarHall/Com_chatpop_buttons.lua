local baseComponent = require("fgui.base.baseComponent")
local Com_chatpop_buttons = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWarHall/Com_chatpop_buttons", Com_chatpop_buttons)
function Com_chatpop_buttons:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
	self.fields.btn1:addClickEventListener(handler(self, self.onClick))
	self.fields.btn2:addClickEventListener(handler(self, self.onClick))
end
function Com_chatpop_buttons:onShow()
end
function Com_chatpop_buttons:setClickHandler(clickHandler)
	self.clickHandler = clickHandler
end
function Com_chatpop_buttons:onClick(btn)
	if self.clickHandler then
		self.clickHandler(btn)
	end
end
return Com_chatpop_buttons
