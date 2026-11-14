local baseComponent = require("fgui.base.baseComponent")
local Com_bar = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://FootballSpirit/Com_bar", Com_bar)
function Com_bar:onInit()
end
function Com_bar:onShow()
end
function Com_bar:initData(curEXP, nextEXP)
	self:setMax(nextEXP)
	self:setValue(curEXP)
end
return Com_bar
