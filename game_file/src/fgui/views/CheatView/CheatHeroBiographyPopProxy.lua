local baseProxy = require("fgui.base.baseProxy")
local CheatHeroBiographyPopProxy = class("CheatHeroBiographyPopProxy", baseProxy)
function CheatHeroBiographyPopProxy:onRegisterEvent()
	print("=======CheatHeroBiographyPopProxy:onRegisterEvent")
end
return CheatHeroBiographyPopProxy
