local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local jumpDesRead = include("jumpDesRead")
local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_astrolabe = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/Com_astrolabe", Com_astrolabe)
function Com_astrolabe:onInit()
end
function Com_astrolabe:onShow()
end
function Com_astrolabe:initData(stage)
	self.controllers.c1:setSelectedIndex(stage - 1)
end
function Com_astrolabe:showStageEffect(callback)
	self.transitions.t0:play(1, 0, 0, -1, callback)
end
function Com_astrolabe:updateStage()
end
return Com_astrolabe
