local baseComponent = require("fgui.base.baseComponent")
local Com_box = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceStoreHouseView/Com_box", Com_box)
function Com_box:onInit()
end
function Com_box:onShow()
end
function Com_box:setBoxPng(png)
	self.fields.icon:setSpriteFrame(png)
end
function Com_box:setBoxParticle(index)
	self.controllers.cPar:setSelectedIndex(index - 1)
end
return Com_box
