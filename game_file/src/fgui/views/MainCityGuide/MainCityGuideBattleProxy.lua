local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideBattleProxy = class("MainCityGuideBattleProxy", baseProxy)
function MainCityGuideBattleProxy:onRegisterEvent()
	print("=======MainCityGuideBattleProxy:onRegisterEvent")
end
function MainCityGuideBattleProxy:showSkillBtn()
	self.view:showSkillBtn()
end
return MainCityGuideBattleProxy
