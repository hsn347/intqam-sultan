local baseProxy = require("fgui.base.baseProxy")
local RewardViewProxy = class("RewardViewProxy", baseProxy)
function RewardViewProxy:ctor(...)
	self.super.ctor(self, ...)
	self.addMode = UI_ADD_MODE.Multi
	self.fadeInDelay = true
end
function RewardViewProxy:onRegisterEvent()
	print("=======RewardViewProxy:onRegisterEvent")
end
function RewardViewProxy:onRemoveView()
	print("=======RewardViewProxy:onRemoveView")
end
return RewardViewProxy
