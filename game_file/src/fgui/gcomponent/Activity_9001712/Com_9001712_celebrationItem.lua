local baseComponent = require("fgui.base.baseComponent")
local Com_9001712_celebrationItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001712/Com_9001712_celebrationItem", Com_9001712_celebrationItem)
function Com_9001712_celebrationItem:onInit()
	self.fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
	self.fields.Ani_item:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_9001712_celebrationItem:onShow()
end
function Com_9001712_celebrationItem:initData(id, num)
	self.fields.Com_item:initData(id, num)
end
function Com_9001712_celebrationItem:setStatus(status)
	self.controllers.c1:setSelectedIndex(status)
end
function Com_9001712_celebrationItem:setClickCallback(callback)
	self.fields.Com_item:setClickCallback(callback)
end
return Com_9001712_celebrationItem
