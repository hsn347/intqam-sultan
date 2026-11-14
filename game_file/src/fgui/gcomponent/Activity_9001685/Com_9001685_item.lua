local baseComponent = require("fgui.base.baseComponent")
local Com_9001685_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001685/Com_9001685_item", Com_9001685_item)
function Com_9001685_item:onInit()
end
function Com_9001685_item:onShow()
end
function Com_9001685_item:initData(data, index)
	self.fields.item:initData(data.id, data.count)
	self.fields.item:setAlpha(0)
	self.fields.item:runAction(ffa.seq(ffa.delay(index * 0.2 + 0.1), ffa.callFunc(function()
		self.fields.item:setVisible(true)
	end), ffa.fadeIn(0.2)))
	self.fields.ani:runAction(ffa.seq(ffa.delay(index * 0.2), ffa.callFunc(function()
		self.fields.ani:setAllFrameNameOnce("G_dh_9001649_03_%02d.png", 1, false)
	end)))
end
return Com_9001685_item
