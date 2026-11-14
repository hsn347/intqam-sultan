local baseComponent = require("fgui.base.baseComponent")
local Com_MC_MarkList = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastMarkRead = include("divineBeastMarkRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_MarkList", Com_MC_MarkList)
function Com_MC_MarkList:onInit()
	self.filterArmy, _ENV, self.filterQuality, _ENV, self.curID = nil, nil, nil, nil, nil
	self.fields.list_marks:setVirtual()
	self.fields.list_marks:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_MC_MarkList:onShow()
end
function Com_MC_MarkList:initData(filterQuality, filterArmy)
