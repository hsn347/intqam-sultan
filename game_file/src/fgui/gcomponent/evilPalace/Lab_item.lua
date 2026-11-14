local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Lab_item = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://evilPalace/Lab_item", Lab_item)
function Lab_item:onInit()
	self:fixChildrenPos()
end
function Lab_item:onShow()
end
function Lab_item:initData(id)
	self.fields.icon:setSpriteFrame(publicRead.getIcon(id))
	self.fields.title:setString("x" .. backpackCtrl:getItemCount(id))
end
return Lab_item
