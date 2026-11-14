local baseProxy = require("fgui.base.baseProxy")
local FootballSpiritPropProxy = class("FootballSpiritPropProxy", baseProxy)
function FootballSpiritPropProxy:onRegisterEvent()
	print("=======FootballSpiritPropProxy:onRegisterEvent")
end
return FootballSpiritPropProxy
