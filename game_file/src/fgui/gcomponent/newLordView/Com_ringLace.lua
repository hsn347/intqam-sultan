local baseComponent = require("fgui.base.baseComponent")
local Com_ringLace = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_ringLace", Com_ringLace)
function Com_ringLace:onInit()
end
function Com_ringLace:onShow()
end
function Com_ringLace:initData(part, equipment)
	self.fields.com_equip:initRingNeckLace(part, equipment)
end
return Com_ringLace
