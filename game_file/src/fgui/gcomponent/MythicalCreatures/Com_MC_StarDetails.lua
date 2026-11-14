local baseComponent = require("fgui.base.baseComponent")
local Com_MC_StarDetails = fgui.extension_class(fgui.GComponent, baseComponent)
local divineBeastRead = include("divineBeastRead")
fgui.register_extension("ui://MythicalCreatures/Com_MC_StarDetails", Com_MC_StarDetails)
function Com_MC_StarDetails:onInit()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.list_star:setItemRenderer(handler(self, self.onStarRenderer))
end
function Com_MC_StarDetails:onShow()
end
function Com_MC_StarDetails:initData(divineID, starLv, isMax)
	self.growDesCfgs = divineBeastRead.getGrowDes(divineID, starLv)
	self.fields.list:setNumItems(#self.growDesCfgs)
	self.fields.list_star:setNumItems(starLv)
end
function Com_MC_StarDetails:onItemRenderer(index, obj)
	obj:initData(self.growDesCfgs[index + 1])
end
function Com_MC_StarDetails:onStarRenderer(index, obj)
	obj:initData(true, false)
end
return Com_MC_StarDetails
