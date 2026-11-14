local baseComponent = require("fgui.base.baseComponent")
local Com_MC_Stars = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_Stars", Com_MC_Stars)
function Com_MC_Stars:onInit()
	self:fixChildrenPos()
end
function Com_MC_Stars:onShow()
end
function Com_MC_Stars:initData(star)
	for i = 1, 7 do
		self.fields["star" .. i]:setGrayed(star < i)
	end
end
return Com_MC_Stars
