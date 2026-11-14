local baseComponent = require("fgui.base.baseComponent")
local Com_chat = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MainUI/Com_chat", Com_chat)
function Com_chat:onInit()
end
function Com_chat:onShow()
end
function Com_chat:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
function Com_chat:setRedVisible(ret)
	self.fields.Sprite_redPoint:setVisible(ret)
end
return Com_chat
