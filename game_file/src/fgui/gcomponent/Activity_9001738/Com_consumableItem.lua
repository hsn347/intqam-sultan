local baseComponent = require("fgui.base.baseComponent")
local Com_consumableItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_consumableItem", Com_consumableItem)
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Com_consumableItem:onInit()
	self:addClickListener(handler(self, self.onClickItem))
	self.fields.n2:fix()
	self:fixChildrenPos()
end
function Com_consumableItem:onShow()
end
function Com_consumableItem:initData(data)
	self.data = data
	self.itemID = data.itemID or data.id or 0
	local count = backpackCtrl:getItemCount(self.itemID) or 0
	self.fields.txtNum:setString(string.formatnumberthousands(count))
	self.fields.icon:setIcon(publicRead.getIcon(self.itemID))
end
function Com_consumableItem:onClickItem()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("Activity_9001738_Consumable", nil)
end
return Com_consumableItem
