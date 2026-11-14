local baseComponent = require("fgui.base.baseComponent")
local Com_chat = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_chat", Com_chat)
function Com_chat:onInit()
end
function Com_chat:setChatTextOnly(chatStr)
	self:setVisible(true)
	self.fields.text_chat:setAutoSize(fgui.AutoSizeType.BOTH)
	self.fields.text_chat:setString(chatStr)
	if self.fields.text_chat:getSize().width >= 176 then
		self.fields.text_chat:setSize(cc.size(176, 0))
		self.fields.text_chat:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
end
function Com_chat:onShow()
end
return Com_chat
