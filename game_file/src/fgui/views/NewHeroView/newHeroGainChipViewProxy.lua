local baseProxy = require("fgui.base.baseProxy")
local newHeroGainChipViewProxy = class("newHeroGainChipViewProxy", baseProxy)
function newHeroGainChipViewProxy:onRegisterEvent()
	print("=======newHeroGainChipViewProxy:onRegisterEvent")
end
return newHeroGainChipViewProxy
