local activityCommonMergeRead = include("activityCommonMergeRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001663_mapPanel = class("Activity_9001663_mapPanel", baseFguiPanel)
function Activity_9001663_mapPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001692"
	return nil
end
function Activity_9001663_mapPanel:ctor(...)
	Activity_9001663_mapPanel.super.ctor(self, ...)
	print("Activity_9001663_mapPanel:ctor", self.viewName)
end
function Activity_9001663_mapPanel:onInit()
	print("=======Activity_9001663_mapPanel:onInit")
	self.detailList, _ENV, self.needList, _ENV = print, print, print, print
	self.fields.Panel_bg:setString(i18n("bubble_party_text_25"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_detail:setItemRenderer(handler(self, self.onDetailRenderer))
end
function Activity_9001663_mapPanel:onItemRenderer(index, obj)
	local id = self.needList[index + 1]
	local count = backpackCtrl:getItemCount(id)
	obj:initData(id, count)
	obj:setTitleMaxSize(50)
end
function Activity_9001663_mapPanel:onDetailRenderer(index, obj)
	obj:setActivityID(self.activityID)
	obj:initData(self.detailList[index + 1], self.bubbleType)
end
function Activity_9001663_mapPanel:onShow()
	print("=======Activity_9001663_mapPanel:onShow")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.BUBBLE_CARNIVAL
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001692 then
		self.fields.Panel_bg:setString(i18n("collect_colored_ribbon_text_03"))
		self.fields.List_detail:setDefaultItem("ui://Activity_9001663/Com_bubbleSingle_9001692")
	else
		self.fields.Panel_bg:setString(i18n("bubble_party_text_25"))
		self.fields.List_detail:setDefaultItem("ui://Activity_9001663/Com_bubbleSingle")
	end
	self:initData()
end
function Activity_9001663_mapPanel:initData(target, data)
	self.bubbleType = nil
	if data and data.subMsg == "compose" then
		self.bubbleType = data.bubbleType
	end
	self.needList = activityCommonMergeRead.getCfgFormula(self.activityID)
	self.fields.List_item:setNumItems(#self.needList)
	self.detailList = activityCommonMergeRead.getCfg(self.activityID)
	self.fields.List_detail:setNumItems(#self.detailList)
end
function Activity_9001663_mapPanel:onMsgMergeUpdate(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	_UPVALUE0_ = event.activityID
	event.activityID.compose = true
	event.activityID.exchangeDeal = true
	event.activityID.exchangePost = true
	event.activityID.exchangeCancel = true
	local event.activityID.notify, config = true, event.activityID
	if config[event.subMsg] then
		self:initData(target, event)
	end
end
return Activity_9001663_mapPanel
