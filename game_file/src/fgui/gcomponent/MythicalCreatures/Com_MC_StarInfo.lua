local baseComponent = require("fgui.base.baseComponent")
local divineBeastRead = include("divineBeastRead")
local Com_MC_StarInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_StarInfo", Com_MC_StarInfo)
function Com_MC_StarInfo:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_MC_StarInfo:onShow()
end
function Com_MC_StarInfo:initData(growDesCfgs, starCfg)
	self.fields.list_star:setNumItems(starCfg.starLevel)
	for i = 1, 5 do
		self.fields["single" .. i]:initData(growDesCfgs[i])
	end
	self.fields.n15:ensureBoundsCorrect()
end
return Com_MC_StarInfo
