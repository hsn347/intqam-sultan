local baseComponent = require("fgui.base.baseComponent")
local kingsOrderRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001061/kingsOrderRankSingle", kingsOrderRankSingle)
function kingsOrderRankSingle:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function kingsOrderRankSingle:onShow()
end
function kingsOrderRankSingle:initData(data, rType, stage)
