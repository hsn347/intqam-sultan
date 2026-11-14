local baseComponent = require("fgui.base.baseComponent")
local Com_9001628_itemInfo = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001628_Ctrl = SoraDGetCtrl("activity_9001628_Ctrl")
local publicRead = include("publicRead")
fgui.register_extension("ui://Activity_9001628/Com_9001628_itemInfo", Com_9001628_itemInfo)
function Com_9001628_itemInfo:onInit()
	self:fixChildrenPos()
	self.fields.Text_tip2:setString(i18n("nebula_treasure_hunt_text13"))
end
function Com_9001628_itemInfo:onShow()
end
function Com_9001628_itemInfo:updateNum(...)
	for i, itemID in ipairs(self.itemIDList) do
		local Text_item = self.fields["Text_item" .. i]
		local itemName = publicRead.getName(itemID)
		print(itemID, "Com_9001628_itemInfo:updateNum")
		local itemCount = itemID == 1683 and activity_9001628_Ctrl:getDiceCount() or activity_9001628_Ctrl:getFreeDiceCount()
		_ENV = nil
		;(nil).color = "#F0E6D2"
		local countStr = SoraDWrapHtmlTagByStyle(itemCount, nil)
		_ENV = nil
		;(nil).itemname = itemName
		;(nil).num = countStr
		local itemStr = i18n("migrant_move_text44", nil)
		Text_item:setString(itemStr)
	end
end
function Com_9001628_itemInfo:showInfo(visible, itemList)
	self.itemIDList = itemList
	if visible then
		self:updateNum()
	end
	self:setVisible(visible)
end
return Com_9001628_itemInfo
