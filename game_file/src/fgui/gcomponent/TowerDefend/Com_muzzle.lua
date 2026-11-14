local baseComponent = require("fgui.base.baseComponent")
local Com_muzzle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_muzzle", Com_muzzle)
local timeScaleFactor = 5
function Com_muzzle:onInit()
	self.transitions.boom:setTimeScale(timeScaleFactor)
	local framesNpc = display.newFrames("dh_paokou_%02d.png", 1, 36)
	local animationNpc = display.newAnimation(framesNpc, 0.016666666666666666)
	self.fields.Ani_paokou:setAnimation(animationNpc)
end
function Com_muzzle:setCallback(backHandle)
	self.callBackFunc = backHandle
	self.transitions.boom:setHook("boomEnd", function()
		self.callBackFunc()
	end)
end
function Com_muzzle:showEffect()
	self.transitions.boom:play()
end
function Com_muzzle:onShow()
end
return Com_muzzle
