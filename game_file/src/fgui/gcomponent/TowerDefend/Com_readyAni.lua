local baseComponent = require("fgui.base.baseComponent")
local Com_readyAni = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_readyAni", Com_readyAni)
function Com_readyAni:onInit()
end
function Com_readyAni:showCountDown()
	self.fields.Com_ready:beignCount()
end
function Com_readyAni:onShow()
end
return Com_readyAni
