local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Lab_HaveItem = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001734/Lab_HaveItem", Lab_HaveItem)
fgui.register_extension("ui://Activity_9001734/Lab_HaveItem2", Lab_HaveItem)
function Lab_HaveItem:onInit()
	self:fixChildrenPos()
end
function Lab_HaveItem:onShow()
end
function Lab_HaveItem:setitemInfo(itemId)
	local title = itemDesRead.getName(itemId) .. ":"
	self.fields.title:setString(title)
	self.fields.icon_item:setURL(publicRead.getIcon(itemId))
	self.fields.num:setString(backpackCtrl:getItemCount(itemId))
end
function Lab_HaveItem:setTitle(title)
	self.fields.title:setString(title)
end
function Lab_HaveItem:setItemAndNum(itemId, num)
	self.fields.icon_item:setURL(publicRead.getIcon(itemId))
	self.fields.num:setString(num)
end
return Lab_HaveItem
