local baseComponent = require("fgui.base.baseComponent")
local Com_9001746_rewardItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001746/Com_9001746_rewardItem", Com_9001746_rewardItem)
function Com_9001746_rewardItem:onInit()
	self.fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
	self.fields.Ani_item:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_9001746_rewardItem:initData(id, num)
	self.itemID = id
	self.itemNum = num
	self.fields.Com_item:initData(id, num)
end
function Com_9001746_rewardItem:setStatus(status)
	self.controllers.c1:setSelectedIndex(status or 3)
end
return Com_9001746_rewardItem
