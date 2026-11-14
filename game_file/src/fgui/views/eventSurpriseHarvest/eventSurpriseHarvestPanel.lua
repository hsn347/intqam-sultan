local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local buildLogic = include("buildLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local eventSurpriseHarvestPanel = class("eventSurpriseHarvestPanel", baseFguiPanel)
function eventSurpriseHarvestPanel:ctor(...)
	eventSurpriseHarvestPanel.super.ctor(self, ...)
	print("eventSurpriseHarvestPanel:ctor", self.viewName)
end
function eventSurpriseHarvestPanel:onInit()
	print("=======eventSurpriseHarvestPanel:onInit")
	_ENV, _ENV, self.openList, _ENV = "=======eventSurpriseHarvestPanel:onInit", print, print, print
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_0
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3531")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3535")
	_ENV, print[1], ("=======eventSurpriseHarvestPanel:onInit").bg = "=======eventSurpriseHarvestPanel:onInit", "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t01.png"
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_1
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3532")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3537")
	_ENV, print[2], ("=======eventSurpriseHarvestPanel:onInit").bg = "=======eventSurpriseHarvestPanel:onInit", "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t02.png"
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_2
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3533")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3536")
	_ENV, print[3], ("=======eventSurpriseHarvestPanel:onInit").bg = "=======eventSurpriseHarvestPanel:onInit", "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t03.png"
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_3
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3534")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3538")
	_ENV, print[4], ("=======eventSurpriseHarvestPanel:onInit").bg = "=======eventSurpriseHarvestPanel:onInit", "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t04.png"
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_0
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3531")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3535")
	_ENV, print[5], ("=======eventSurpriseHarvestPanel:onInit").bg = "=======eventSurpriseHarvestPanel:onInit", "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t01.png"
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_1
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3532")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3537")
	_ENV, print[6], ("=======eventSurpriseHarvestPanel:onInit").bg = "=======eventSurpriseHarvestPanel:onInit", "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t02.png"
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_2
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3533")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3536")
	_ENV, print[7], ("=======eventSurpriseHarvestPanel:onInit").bg = "=======eventSurpriseHarvestPanel:onInit", "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t03.png"
	;("=======eventSurpriseHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_3
	;("=======eventSurpriseHarvestPanel:onInit").name = i18n("common_text_3534")
	;("=======eventSurpriseHarvestPanel:onInit").des = i18n("common_text_3538")
	self.eventList, print[8], ("=======eventSurpriseHarvestPanel:onInit").bg = print, "=======eventSurpriseHarvestPanel:onInit", "bg_jxdl_t04.png"
	self.fields.Com_title:initData(i18n("common_text_3530"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onEventRenderer))
end
function eventSurpriseHarvestPanel:onShow()
	print("=======eventSurpriseHarvestPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function eventSurpriseHarvestPanel:onEventRenderer(index, obj)
	obj:initData(self.openList[index + 1])
end
function eventSurpriseHarvestPanel:initData()
	self.openList, _ENV = nil, nil
	for k, v in ipairs(self.eventList) do
		local eventState = activityShowCtrl:getStateByID(v.eid)
		local isShowEvent = true
		if (v.eid == gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_3 or v.eid == gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_3) and not buildLogic.isOwnBuildedBuilding(BUILDID.WISHING_WELL) then
			isShowEvent = false
		end
		if (eventState == gActivityState.OPEN or eventState == gActivityState.PREPARE) and isShowEvent then
			table.insert(self.openList, v)
		end
	end
	self.fields.List:setNumItems(#self.openList)
end
function eventSurpriseHarvestPanel:judgeClose()
	if not activityShowCtrl:isSurprisedDropOpenOrPrepare() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
	self:initData()
end
return eventSurpriseHarvestPanel
