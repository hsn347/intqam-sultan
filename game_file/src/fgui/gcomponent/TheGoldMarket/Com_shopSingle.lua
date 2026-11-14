local baseComponent = require("fgui.base.baseComponent")
local Com_shopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TheGoldMarket/Com_shopSingle", Com_shopSingle)
function Com_shopSingle:onInit()
	self.isPlay = false
end
function Com_shopSingle:onShow()
end
function Com_shopSingle:initData(data)
	if not self.isPlay then
		self.transitions.t0:play(1, data.group * 3 / 60)
		self.isPlay = true
	end
	self.fields.com_single:initData(data.cfg)
end
return Com_shopSingle
