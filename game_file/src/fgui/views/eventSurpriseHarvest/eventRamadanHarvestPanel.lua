local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local buildLogic = include("buildLogic")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local eventRamadanHarvestPanel = class("eventRamadanHarvestPanel", baseFguiPanel)
function eventRamadanHarvestPanel:ctor(...)
	eventRamadanHarvestPanel.super.ctor(self, ...)
	print("eventRamadanHarvestPanel:ctor", self.viewName)
end
function eventRamadanHarvestPanel:onInit()
	print("=======eventRamadanHarvestPanel:onInit")
	_ENV, _ENV, self.openList, _ENV, self.activityID = "=======eventRamadanHarvestPanel:onInit", self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP, self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP, self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP, self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP
	;("=======eventRamadanHarvestPanel:onInit").name = i18n("common_text_3531")
	;("=======eventRamadanHarvestPanel:onInit").des = i18n("common_text_3535")
	;("=======eventRamadanHarvestPanel:onInit").bg = "frame_zydl_jsyg.png"
	_ENV, (self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP)[1], ("=======eventRamadanHarvestPanel:onInit").dropType = "=======eventRamadanHarvestPanel:onInit", "=======eventRamadanHarvestPanel:onInit", gActivityDropType.KILL_MONSTER
	;("=======eventRamadanHarvestPanel:onInit").name = i18n("common_text_3532")
	;("=======eventRamadanHarvestPanel:onInit").des = i18n("common_text_3537")
	;("=======eventRamadanHarvestPanel:onInit").bg = "frame_zydl_cjzy.png"
	_ENV, (self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP)[2], ("=======eventRamadanHarvestPanel:onInit").dropType = "=======eventRamadanHarvestPanel:onInit", "=======eventRamadanHarvestPanel:onInit", gActivityDropType.COLLECT_RES
	;("=======eventRamadanHarvestPanel:onInit").name = i18n("common_text_3533")
	;("=======eventRamadanHarvestPanel:onInit").des = i18n("common_text_3536")
	;("=======eventRamadanHarvestPanel:onInit").bg = "frame_zydl_cjdl.png"
	_ENV, (self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP)[3], ("=======eventRamadanHarvestPanel:onInit").dropType = "=======eventRamadanHarvestPanel:onInit", "=======eventRamadanHarvestPanel:onInit", gActivityDropType.OUTCITY_RES
	;("=======eventRamadanHarvestPanel:onInit").name = i18n("common_text_3534")
	;("=======eventRamadanHarvestPanel:onInit").des = i18n("common_text_3538")
	;("=======eventRamadanHarvestPanel:onInit").bg = "frame_zydl_xy.png"
	self.eventList, (self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP)[4], ("=======eventRamadanHarvestPanel:onInit").dropType = self.param and self.param.activityID or gActivityTimeActivityID.RAMADAN_SURPRISED_DROP, "=======eventRamadanHarvestPanel:onInit", gActivityDropType.TREVI_FOUNTAIN
	self.fields.Com_title:initData(i18n(activityTimeRead.getActivityNameByID(self.activityID) or "activity_name_9001600"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onEventRenderer))
end
function eventRamadanHarvestPanel:onShow()
	print("=======eventRamadanHarvestPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	_ENV = self.fields.Com_title.initCommonActivityTime
	self.fields.Com_title.initCommonActivityTime[gActivityTimeActivityID.RAMADAN_SURPRISED_DROP] = DROP_ACTIVITY_ISNEW.RAMADAN_SURPRISED_DROP
	local self.fields.Com_title.initCommonActivityTime[gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001662], activityTypes = DROP_ACTIVITY_ISNEW.ANNIVERSARY_SURPRISED_DROP, self.fields.Com_title.initCommonActivityTime
	activityShowCtrl:sendCurDayDrop(activityTypes[self.activityID])
end
function eventRamadanHarvestPanel:onEventRenderer(index, obj)
	obj:initData(self.openList[index + 1], self.activityID)
end
function eventRamadanHarvestPanel:initData()
	self.openList, _ENV = nil, nil
	for k, v in ipairs(self.eventList) do
		local isShowEvent = true
		if k == 4 and not buildLogic.isOwnBuildedBuilding(BUILDID.WISHING_WELL) then
			isShowEvent = false
		end
		if isShowEvent then
			table.insert(self.openList, v)
		end
	end
	self.fields.List:setNumItems(#self.openList)
end
function eventRamadanHarvestPanel:refreshGot(target, data)
	if data and data.itemGetCount then
		for k, v in ipairs(self.openList) do
			v.dropCount = data.itemGetCount[tostring(v.dropType)] or 0
		end
	end
	self.fields.List:setNumItems(#self.openList)
end
function eventRamadanHarvestPanel:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	self:initData()
end
return eventRamadanHarvestPanel
