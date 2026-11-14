local baseComponent = require("fgui.base.baseComponent")
local Com_levelLock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Com_levelLock", Com_levelLock)
function Com_levelLock:onInit()
	self.fields.Ani_lock:setAllFrameName("dh_zbhd1_%.2d.png", 1)
	self.fields.Ani_normal:setAllFrameName("dh_weijiesuo1_%02d.png", 1)
	self.fields.Ani_lock:setPlaySettings(1, -1, 1, -1, function()
		self.callBackFunc()
	end)
end
function Com_levelLock:initData(title)
	self.fields.title:setString(title)
end
function Com_levelLock:setCallback(backFunc)
	self.callBackFunc = backFunc
end
function Com_levelLock:setStatus(engouh)
	self.controllers.state:setSelectedIndex(engouh and 0 or 1)
end
function Com_levelLock:onShow()
end
return Com_levelLock
