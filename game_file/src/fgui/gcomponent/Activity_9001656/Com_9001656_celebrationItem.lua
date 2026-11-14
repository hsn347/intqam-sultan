local baseComponent = require("fgui.base.baseComponent")
local Com_9001656_celebrationItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001656/Com_9001656_celebrationItem", Com_9001656_celebrationItem)
function Com_9001656_celebrationItem:onInit()
	self.fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
	self.fields.Ani_item:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_9001656_celebrationItem:onShow()
end
function Com_9001656_celebrationItem:initData(id, num)
	self.fields.Com_item:initData(id, num)
end
function Com_9001656_celebrationItem:setStatus(status)
	self.controllers.c1:setSelectedIndex(status)
end
return Com_9001656_celebrationItem
