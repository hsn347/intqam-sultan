local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemNeed = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://kohMigrate/Com_itemNeed", Com_itemNeed)
function Com_itemNeed:onInit()
	self.itemIDList = kohMigrateCtrl:getItemIDList()
	self.fields.Text_has:setString(i18n("arossDesc_text_014"))
	self.fields.Sprite_item:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onEventTouchBegin))
	self.fields.Sprite_item:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onEventTouchEnd))
	self.fields.Button_getWay:addClickListener(handler(self, self.btnGetWayClick))
end
function Com_itemNeed:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(target, event)
		local itemMap = event and event.itemMap
		if not itemMap then
			return
		end
		for i, v in ipairs(self.itemIDList) do
			if itemMap[v] then
				self:refreshItemCount()
				break
			end
		end
	end)
end
function Com_itemNeed:onShow()
	self:refreshItemCount()
end
function Com_itemNeed:onEventTouchBegin(context)
	context:captureTouch()
	self.fields.Com_itemInfo:showInfo(true)
end
function Com_itemNeed:onEventTouchEnd(context)
	self.fields.Com_itemInfo:showInfo(false)
end
function Com_itemNeed:btnGetWayClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemIDList[1]
	;(nil).title = i18n("common_text_4347")
	uiManager:show("CommonSourceGuide", nil)
end
function Com_itemNeed:refreshItemCount(...)
	local itemCount = kohMigrateCtrl:getItemCount()
	local itemCost = kohMigrateCtrl:getItemCost()
	local countStr
	if itemCount < itemCost then
		kohMigrateCtrl = itemCount
		itemCount.color = "#FF0000"
		countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(itemCount), itemCount) .. "/" .. string.formatnumberthousands(itemCost)
	else
		countStr = string.formatnumberthousands(itemCount) .. "/" .. string.formatnumberthousands(itemCost)
	end
	self.fields.Text_count:setString(countStr)
end
return Com_itemNeed
