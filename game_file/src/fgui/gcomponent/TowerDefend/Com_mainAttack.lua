local baseComponent = require("fgui.base.baseComponent")
local Com_mainAttack = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_mainAttack", Com_mainAttack)
function Com_mainAttack:onInit()
end
function Com_mainAttack:initData(index)
	self.index = index
	local framesNpc = display.newFrames("dh_tf_bz_%02d.png", 1, 29)
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1, function()
		self.fields.Ani_load:setPlaying(false)
		self.callBackFunc(self.index)
	end)
end
function Com_mainAttack:setPlay()
	self.fields.Ani_load:setPlaying(true)
end
function Com_mainAttack:setCallBack(callHandle)
	self.callBackFunc = callHandle
end
function Com_mainAttack:endCallback()
	self.callBackFunc()
end
function Com_mainAttack:onShow()
end
return Com_mainAttack
