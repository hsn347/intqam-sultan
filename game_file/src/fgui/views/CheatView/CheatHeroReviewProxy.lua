local baseProxy = require("fgui.base.baseProxy")
local CheatHeroReviewProxy = class("CheatHeroReviewProxy", baseProxy)
function CheatHeroReviewProxy:onRegisterEvent()
	print("=======CheatHeroReviewProxy:onRegisterEvent")
end
return CheatHeroReviewProxy
