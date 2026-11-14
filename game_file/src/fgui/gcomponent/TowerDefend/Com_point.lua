local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_point = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_point", Com_point)
function Com_point:onInit()
	self.controllers.c1:setSelectedIndex(SoraDGetDefaultLanguage() == "ar" and 0 or 1)
	self.fields.Ani_light:setAllFrameName("dh_lingwubj_%02d.png", 1)
	self.fields.Ani_kill05:setAllFrameName("dh_Tex_XL_mnttf05_%03d.png", 1)
	self.fields.Ani_kill07:setAllFrameName("dh_Tex_XL_mnttf07_%03d.png", 2)
	self.transitions.firstShow:setHook("firstHit", function()
		self.callBackFunc()
	end)
	self.transitions.showNum:setHook("hitEnd", function()
		self.callBackFunc()
	end)
	self.transitions.showNum_ar:setHook("hitEndar", function()
		self.callBackFunc()
	end)
end
function Com_point:playHitEffect()
	if SoraDGetDefaultLanguage() == "ar" then
		self.transitions.showNum_ar:play()
	else
		self.transitions.showNum:play()
	end
end
function Com_point:setData(num)
	self.fields.title:setString(num)
	self.fields.title2:setString(num)
end
function Com_point:setCallBackHandle(cHandle)
	self.callBackFunc = cHandle
end
function Com_point:onShow()
end
return Com_point
