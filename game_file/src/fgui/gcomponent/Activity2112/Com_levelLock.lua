local baseComponent = require("fgui.base.baseComponent")
local Com_levelLock = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity2112/Com_levelLock", Com_levelLock)
function Com_levelLock:onInit()
	self:fixChildrenPos()
	self.fields.Ani_lock:setAllFrameName("dh_Tex_XL_xykh03_0%.2d.png", 0)
	self.fields.Ani_lock:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_levelLock:initData(num, title)
	self.fields.Text_num:setString(num)
	self.fields.title:setString(title)
end
function Com_levelLock:setStatus(engouh)
	self.controllers.state:setSelectedIndex(engouh and 0 or 1)
end
function Com_levelLock:onShow()
end
return Com_levelLock
