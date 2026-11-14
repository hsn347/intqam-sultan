local activity_9001721_Read = include("activity_9001721_Read")
local activity_9001721_Ctrl = SoraDGetCtrl("activity_9001721_Ctrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001721_ShopPanel = class("Activity_9001721_ShopPanel", baseFguiPanel)
function Activity_9001721_ShopPanel:ctor(...)
	self.isLRU = true
	Activity_9001721_ShopPanel.super.ctor(self, ...)
	print("Activity_9001721_ShopPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY
end
function Activity_9001721_ShopPanel:onInit()
	print("=======Activity_9001721_ShopPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Com_have:hideBtnAdd()
end
function Activity_9001721_ShopPanel:endShow()
	print("=======Activity_9001721_ShopPanel:endShow")
	self:initView()
	self.fields.List:jumpToTop()
end
function Activity_9001721_ShopPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.ListData = activityExchangeMallCtrl:getConfigByActivityID(self.activityID)
	local itemID
	for _, v in ipairs(self.ListData) do
		v.leftCount = math.max(0, v.limitnum - activityExchangeMallCtrl:getExchangeNum(self.activityID, v.shopItemID))
		itemID = v.exchangeitem
	end
	table.sort(self.ListData, function(a, b)
		if a.leftCount <= 0 and b.leftCount > 0 then
			return false
		elseif a.leftCount > 0 and b.leftCount <= 0 then
			return true
		else
			return a.shopItemID < b.shopItemID
		end
	end)
	self.fields.List:setNumItems(#self.ListData)
	self.fields.Com_have:initData(itemID)
end
function Activity_9001721_ShopPanel:itemRenderer_List(index, obj)
	obj:initData(self.ListData[index + 1])
end
return Activity_9001721_ShopPanel
