local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_food = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001669/Com_food", Com_food)
function Com_food:onInit()
end
function Com_food:onShow()
end
function Com_food:initItemID(itemID)
	local itemCount = backpackCtrl:getItemCount(itemID)
	self:initData(itemID, itemCount)
end
function Com_food:initData(itemID, itemCount)
	self:setString(string.formatnumberthousands(itemCount))
	self.fields.Com_item:initData(itemID)
	self.fields.Com_item:hideFrameAndQuality()
end
return Com_food
