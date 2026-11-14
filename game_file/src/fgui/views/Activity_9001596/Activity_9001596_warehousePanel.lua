local publicRead = include("publicRead")
local activity_9001596_Read = include("activity_9001596_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001596_warehousePanel = class("Activity_9001596_warehousePanel", baseFguiPanel)
function Activity_9001596_warehousePanel:ctor(...)
	Activity_9001596_warehousePanel.super.ctor(self, ...)
	print("Activity_9001596_warehousePanel:ctor", self.viewName)
end
function Activity_9001596_warehousePanel:onInit()
	print("=======Activity_9001596_warehousePanel:onInit")
	self.itemList, _ENV = print, print
	self.selIndex = 1
	self.fields.Panel_bg:setString(i18n("buildDes_name_105"))
	self.fields.Text_none:setString(i18n("Ramadan_2024_text52"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setAlignCenter(true)
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
end
function Activity_9001596_warehousePanel:onShow()
	print("=======Activity_9001596_warehousePanel:onShow")
	self:initData()
end
function Activity_9001596_warehousePanel:onChooseItem()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	print("self.selIndex======", self.fields.List:getSelectedIndex(), self.selIndex)
	self:setItemInfo()
end
function Activity_9001596_warehousePanel:onItemRenderer(index, obj)
	local id = self.itemList[index + 1]
	local count = backpackCtrl:getItemCount(id)
	obj:initData(id, count)
end
function Activity_9001596_warehousePanel:initData()
	self.itemList = activity_9001596_Read.getWarehouseItems()
	self:updateView()
end
function Activity_9001596_warehousePanel:updateView()
	self.fields.List:setNumItems(#self.itemList)
	local isEmpty = true
	for k, v in ipairs(self.itemList) do
		if backpackCtrl:getItemCount(v) > 0 then
			isEmpty = false
			break
		end
	end
	self.controllers.c1:setSelectedIndex(isEmpty and 1 or 0)
	self:setItemInfo()
end
function Activity_9001596_warehousePanel:setItemInfo()
	local id = self.itemList[self.selIndex]
	local count = backpackCtrl:getItemCount(id)
	local itemPos = self.fields.List:getChildAt(self.selIndex - 1):localToGlobal(cc.p(50, 0))
	local toPos = self:globalToLocal(itemPos)
	self.fields.Image_arr:setPositionX(toPos.x)
	self.fields.Text_name:setString(publicRead.getName(id))
	self.fields.Text_des:setString(publicRead.getDes(id))
end
return Activity_9001596_warehousePanel
