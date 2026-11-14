local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonGetWayViewPanel = class("commonGetWayViewPanel", baseFguiPanel)
function commonGetWayViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("commonGetWayViewPanel:ctor", self.viewName)
end
function commonGetWayViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonGetWayViewPanel:onInit()
	print("=======commonGetWayViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4342"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function commonGetWayViewPanel:onShow()
	print("=======commonGetWayViewPanel:onShow")
	self.itemID = self.param.itemID
	self.otherData = self.param.otherData
	self:initData()
end
function commonGetWayViewPanel:initData()
	self.getWayList, _ENV = nil, nil
	if self.itemID == 202801 then
		_ENV = nil
		;(nil).sourceid = 1
		;(nil).des = i18n("brightWar_text_21")
		;(nil).icon = "icon_activity_radiance.png"
		;(nil).itemID = 202801
		;(nil).activityID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
		table.insert(self.getWayList, nil)
		_ENV = nil
		;(nil).sourceid = 2
		;(nil).des = i18n("equip_text_46")
		;(nil).icon = "icon_main_gold.png"
		;(nil).itemID = 202801
		table.insert(self.getWayList, nil)
	elseif self.itemID == 220201 then
		_ENV = nil
		;(nil).sourceid = 1
		;(nil).des = i18n("nebula_war_text_0143")
		;(nil).icon = "icon_activity_9001421.png"
		;(nil).itemID = 220201
		;(nil).activityID = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
		table.insert(self.getWayList, nil)
	else
		local getWayList = itemDesRead.getOutput(self.itemID)
		for k, v in ipairs(getWayList) do
			table.insert(self.getWayList, v)
		end
		if self.otherData and self.otherData.isOrangItem and backpackCtrl:getItemCount(299201) > 0 and 0 < self.otherData.needNum then
			local needNum = math.min(backpackCtrl:getItemCount(299201), self.otherData.needNum)
			_ENV = 299201
			;(299201).sourceid = 0
			;(299201).icon = "2992.png"
			;(299201).des = i18n("item_name_299201")
			;(299201).isItemUse = true
			;(299201).needNum = needNum
			;(299201).needCount = self.otherData.needCount
			table.insert(self.getWayList, 299201)
		end
	end
	self.fields.List:setNumItems(#self.getWayList)
end
function commonGetWayViewPanel:onItemRenderer(index, obj)
	obj:initData(self.getWayList[index + 1], self.itemID, self)
end
return commonGetWayViewPanel
