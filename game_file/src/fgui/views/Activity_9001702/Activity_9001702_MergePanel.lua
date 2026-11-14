local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local activity_9001702_Read = include("activity_9001702_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityDropRead = include("activityDropRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_MergePanel = class("Activity_9001702_MergePanel", baseFguiPanel)
function Activity_9001702_MergePanel:ctor(...)
	self.isLRU = true
	Activity_9001702_MergePanel.super.ctor(self, ...)
	print("Activity_9001702_MergePanel:ctor", self.viewName)
	self.activitytp = DROP_ACTIVITY_ISNEW.NORMAL_ACTIVITY_9001702
	self.activityID_DROP = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702_DROP
end
function Activity_9001702_MergePanel:onInit()
	print("=======Activity_9001702_MergePanel:onInit")
	self.itemMerge = activity_9001702_Read.getItemMerge()
	self.fields.Panel_bg:setString(i18n("Eidal_celebration_text_14"))
	self.fields.Button_merge:setString(i18n("btn_cooking"))
	self.fields.Button_merge:addClickListener(handler(self, self.onClickBtnMerge))
	self.fields.Com_item:initData(self.itemMerge.id)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
		self.fields.arrow:fix()
	end
end
function Activity_9001702_MergePanel:endShow()
	print("=======Activity_9001702_MergePanel:endShow")
	self:updateItemCount()
	self.itemGetCount, _ENV = self.updateItemCount, self.updateItemCount
	activityShowCtrl:sendCurDayDrop(self.activitytp)
	self.eventList = activityDropRead.getEventList(self.activityID_DROP)
	self.fields.List:setNumItems(#self.eventList)
end
function Activity_9001702_MergePanel:onClickBtnMerge()
	SoraDPlaySound()
	if activity_9001702_Ctrl:checkItemCount(self.itemMerge.id, self.itemMerge.count) then
		activity_9001702_Ctrl:reqMerge()
	end
end
function Activity_9001702_MergePanel:onItemRenderer(index, obj)
	local cfg = self.eventList[index + 1]
	local dropType = cfg.dropType
	local dropCount = self.itemGetCount[tostring(dropType)] or 0
	obj:initData(dropType, dropCount)
end
function Activity_9001702_MergePanel:updateItemCount()
	local itemCount = backpackCtrl:getItemCount(self.itemMerge.id)
	backpackCtrl = nil
	;(nil).member = itemCount
	;(nil).total = self.itemMerge.count
	local haveStr = i18n("common_text_155", nil)
	self.fields.Text_have:setString(haveStr)
	if itemCount >= self.itemMerge.count then
		self.fields.Button_merge:setTitleColor(cc.c3b(255, 251, 213))
	else
		self.fields.Button_merge:setTitleColor(cc.c3b(255, 0, 0))
	end
end
function Activity_9001702_MergePanel:onMsgUpdate(target, event)
	local subMsg = event.subMsg
	if subMsg == "itemCount" and event.itemID == self.itemMerge.id then
		self:updateItemCount()
	end
end
function Activity_9001702_MergePanel:onMsgUpdateDropData(target, event)
	if event.activitytp ~= self.activitytp then
		return
	end
	if not event.itemGetCount then
		_ENV = event.itemGetCount
	end
	self.itemGetCount = event.itemGetCount
	self.fields.List:setNumItems(#self.eventList)
	local curNum = 0
	local limit = 0
	for __, cfg in ipairs(self.eventList) do
		local _dropMax = activityDropRead.getMaxDrop(self.activityID_DROP, cfg.dropType)
		limit = limit + _dropMax
		local _dropCount = self.itemGetCount[tostring(cfg.dropType)] or 0
		curNum = curNum + _dropCount
	end
	_ENV = ipairs(self.eventList)
	ipairs(self.eventList).num1 = curNum
	ipairs(self.eventList).num2 = limit
	local numStr = i18n("Eidal_celebration_text_16", ipairs(self.eventList))
	self.fields.Text_num:setString(numStr)
end
return Activity_9001702_MergePanel
