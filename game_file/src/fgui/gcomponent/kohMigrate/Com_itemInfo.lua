local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/Com_itemInfo", Com_itemInfo)
function Com_itemInfo:onInit()
	self.itemIDList = kohMigrateCtrl:getItemIDList()
	self.fields.Text_tip:setString(i18n("migrant_move_text45"))
	self:updateNum()
end
function Com_itemInfo:onShow()
end
function Com_itemInfo:updateNum(...)
	for i, itemID in ipairs(self.itemIDList) do
		local Text_item = self.fields["Text_item" .. i]
		local itemName = itemDesRead.getName(itemID)
		local itemCount = backpackCtrl:getItemCount(itemID)
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
function Com_itemInfo:showInfo(visible)
	if visible then
		self:updateNum()
	end
	self:setVisible(visible)
end
return Com_itemInfo
