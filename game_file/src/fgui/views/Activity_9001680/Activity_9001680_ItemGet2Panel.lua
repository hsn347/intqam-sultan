local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_ItemGet2Panel = class("Activity_9001680_ItemGet2Panel", baseFguiPanel)
local activity_9001680_Read = include("activity_9001680_Read")
function Activity_9001680_ItemGet2Panel:ctor(...)
	self.isLRU = true
	Activity_9001680_ItemGet2Panel.super.ctor(self, ...)
	print("Activity_9001680_ItemGet2Panel:ctor", self.viewName)
end
function Activity_9001680_ItemGet2Panel:onInit()
	print("=======Activity_9001680_ItemGet2Panel:onInit")
	self.view:fixChildrenPos()
	self.giftList = activity_9001680_Read.getRechargeCfgList(2)
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Panel_bg:setTitle(i18n("minecraft_text_16"))
end
function Activity_9001680_ItemGet2Panel:endShow()
	print("=======Activity_9001680_ItemGet2Panel:endShow")
	self:updateView()
end
function Activity_9001680_ItemGet2Panel:updateView()
	self.fields.list:setNumItems(#self.giftList)
end
function Activity_9001680_ItemGet2Panel:onItemRenderer(index, obj)
	obj:initData(self.giftList[index + 1])
end
return Activity_9001680_ItemGet2Panel
