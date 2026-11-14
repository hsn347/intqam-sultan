local baseComponent = require("fgui.base.baseComponent")
local Com_scoreNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TheGoldMarket/Com_scoreNode", Com_scoreNode)
function Com_scoreNode:onInit()
end
function Com_scoreNode:onShow()
end
function Com_scoreNode:initData()
	self.fields.com_single:initData()
end
return Com_scoreNode
