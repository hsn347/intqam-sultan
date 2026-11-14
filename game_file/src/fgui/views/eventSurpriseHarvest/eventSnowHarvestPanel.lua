local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local buildLogic = include("buildLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local eventSnowHarvestPanel = class("eventSnowHarvestPanel", baseFguiPanel)
function eventSnowHarvestPanel:ctor(...)
	eventSnowHarvestPanel.super.ctor(self, ...)
	print("eventSnowHarvestPanel:ctor", self.viewName)
end
function eventSnowHarvestPanel:onInit()
	print("=======eventSnowHarvestPanel:onInit")
	_ENV, _ENV, self.openList, _ENV = "=======eventSnowHarvestPanel:onInit", print, print, print
	;("=======eventSnowHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_0
	;("=======eventSnowHarvestPanel:onInit").name = i18n("common_text_3531")
	;("=======eventSnowHarvestPanel:onInit").des = i18n("common_text_3535")
	;("=======eventSnowHarvestPanel:onInit").bg = "frame_jxdl_jsyg.png"
	_ENV, print[1], ("=======eventSnowHarvestPanel:onInit").dropType = "=======eventSnowHarvestPanel:onInit", "=======eventSnowHarvestPanel:onInit", gActivityDropType.KILL_MONSTER
	;("=======eventSnowHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_1
	;("=======eventSnowHarvestPanel:onInit").name = i18n("common_text_3532")
	;("=======eventSnowHarvestPanel:onInit").des = i18n("common_text_3537")
	;("=======eventSnowHarvestPanel:onInit").bg = "frame_jxdl_cjzy.png"
	_ENV, print[2], ("=======eventSnowHarvestPanel:onInit").dropType = "=======eventSnowHarvestPanel:onInit", "=======eventSnowHarvestPanel:onInit", gActivityDropType.COLLECT_RES
	;("=======eventSnowHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_2
	;("=======eventSnowHarvestPanel:onInit").name = i18n("common_text_3533")
	;("=======eventSnowHarvestPanel:onInit").des = i18n("common_text_3536")
	;("=======eventSnowHarvestPanel:onInit").bg = "frame_jxdl_cjdl.png"
	_ENV, print[3], ("=======eventSnowHarvestPanel:onInit").dropType = "=======eventSnowHarvestPanel:onInit", "=======eventSnowHarvestPanel:onInit", gActivityDropType.OUTCITY_RES
	;("=======eventSnowHarvestPanel:onInit").eid = gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_3
	;("=======eventSnowHarvestPanel:onInit").name = i18n("common_text_3534")
	;("=======eventSnowHarvestPanel:onInit").des = i18n("common_text_3538")
	;("=======eventSnowHarvestPanel:onInit").bg = "frame_jxdl_xy.png"
	self.eventList, print[4], ("=======eventSnowHarvestPanel:onInit").dropType = print, "=======eventSnowHarvestPanel:onInit", gActivityDropType.TREVI_FOUNTAIN
	self.fields.Com_title:initData(i18n("activity_name_9001579"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onEventRenderer))
end
function eventSnowHarvestPanel:onShow()
	print("=======eventSnowHarvestPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
	local leftTime = activityShowCtrl:getSnowDropTime()
	if 0 < leftTime then
		self.fields.Com_title:getLabelTime():setVisible(true)
		self.fields.Com_title:initSpecialActivityTime(leftTime)
	else
		self.fields.Com_title:getLabelTime():setVisible(false)
	end
	activityShowCtrl:sendCurDayDrop()
end
function eventSnowHarvestPanel:onEventRenderer(index, obj)
	obj:initData(self.openList[index + 1])
end
function eventSnowHarvestPanel:initData()
	self.openList, _ENV = nil, nil
	for k, v in ipairs(self.eventList) do
		local eventState = activityShowCtrl:getStateByID(v.eid)
		local isShowEvent = true
		if v.eid == gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_3 and not buildLogic.isOwnBuildedBuilding(BUILDID.WISHING_WELL) then
			isShowEvent = false
		end
		if (eventState == gActivityState.OPEN or eventState == gActivityState.PREPARE) and isShowEvent then
			table.insert(self.openList, v)
		end
	end
	self.fields.List:setNumItems(#self.openList)
end
function eventSnowHarvestPanel:refreshGot(target, data)
	if data and data.itemGetCount then
		for k, v in ipairs(self.openList) do
			v.dropCount = data.itemGetCount[tostring(v.dropType)] or 0
		end
	end
	self.fields.List:setNumItems(#self.openList)
end
function eventSnowHarvestPanel:judgeClose()
	if not activityShowCtrl:isSnowDropOpenOrPrepare() then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	self:initData()
end
return eventSnowHarvestPanel
