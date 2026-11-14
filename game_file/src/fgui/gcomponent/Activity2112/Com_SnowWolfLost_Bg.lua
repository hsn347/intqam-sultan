local baseComponent = require("fgui.base.baseComponent")
local Com_SnowWolfLost_Bg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_SnowWolfLost_Bg", Com_SnowWolfLost_Bg)
function Com_SnowWolfLost_Bg:onInit()
	self.fields.Usm_1:setPrivewImage("#snowwoflfp.png", cc.size(853, 1386), true)
end
function Com_SnowWolfLost_Bg:onShow()
end
return Com_SnowWolfLost_Bg
