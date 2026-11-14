local baseComponent = require("fgui.base.baseComponent")
local Com_decreelevelLock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_decreelevelLock", Com_decreelevelLock)
function Com_decreelevelLock:onInit()
	self.fields.title:setString(i18n("StarlitNight_text_02"))
	self.fields.Ani_lock:setAllFrameName("dh_zbhd1_%.2d.png", 1)
	self.fields.Ani_normal:setAllFrameName("dh_weijiesuo1_%02d.png", 1)
	self.transitions.t0:setHook("endShow", function()
		self.callBackFunc()
	end)
end
function Com_decreelevelLock:initData(num, title)
	self.fields.Text_num:setString(num)
	self.fields.title:setString(title)
end
function Com_decreelevelLock:setCallback(backFunc)
	self.callBackFunc = backFunc
end
function Com_decreelevelLock:setStatus(engouh)
	self.controllers.state:setSelectedIndex(engouh and 0 or 1)
end
function Com_decreelevelLock:onShow()
end
return Com_decreelevelLock
