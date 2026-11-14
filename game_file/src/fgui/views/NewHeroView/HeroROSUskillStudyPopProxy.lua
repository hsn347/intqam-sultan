local baseProxy = require("fgui.base.baseProxy")
local HeroROSUskillStudyPopProxy = class("HeroROSUskillStudyPopProxy", baseProxy)
function HeroROSUskillStudyPopProxy:onRegisterEvent()
	print("=======HeroROSUskillStudyPopProxy:onRegisterEvent")
end
function HeroROSUskillStudyPopProxy:updateView(target, data)
	SoraDCloseLoading(self.view)
	self.view:updateView(data)
end
return HeroROSUskillStudyPopProxy
