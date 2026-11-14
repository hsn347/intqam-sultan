local baseComponent = require("fgui.base.baseComponent")
local Com_npc = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001719/Com_npc", Com_npc)
function Com_npc:onInit()
	self.fields.icon:setVisible(true)
	self.fields.prefabEx:setVisible(false)
end
function Com_npc:onShow()
end
function Com_npc:initData(data)
	self.data = data
	self.fields.icon:setVisible(true)
end
function Com_npc:getData()
	return self.data
end
function Com_npc:showZDEffect()
	self.fields.prefabEx:setVisible(true)
	self.fields.icon:setVisible(false)
end
return Com_npc
