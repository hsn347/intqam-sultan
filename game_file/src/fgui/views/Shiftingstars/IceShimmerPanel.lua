local shiftingstarsRead = include("shiftingstarsRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceShimmerPanel = class("IceShimmerPanel", baseFguiPanel)
function IceShimmerPanel:ctor(...)
	IceShimmerPanel.super.ctor(self, ...)
	print("IceShimmerPanel:ctor", self.viewName)
end
function IceShimmerPanel:onInit()
	print("=======IceShimmerPanel:onInit")
	self.actConfig, _ENV = print, print
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.activityID = gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001575"), handler(self, self.onClickClose))
	self.fields.Text_title:setString(i18n("Icefestival2024_text18"))
	self.fields.List_event:setItemRenderer(handler(self, self.onItemRenderer))
end
function IceShimmerPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.actConfig[index + 1])
end
function IceShimmerPanel:onShow()
	print("=======IceShimmerPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function IceShimmerPanel:initData()
	self.actConfig, activityShowCtrl = nil, nil
	local actCfg = activityShowCtrl:getParamByID(self.activityID).showConfig
	dump(actCfg, "actCfg===")
	local activityShowCtrl, buffer1 = dump, dump
	local activityShowCtrl, buffer2 = actCfg, actCfg
	table.sort(actCfg, function(a, b)
		return a.activityID < b.activityID
	end)
	for i, v in ipairs(actCfg) do
		if clientEventMgr.judgeIsOpen(v.activityID) then
			table.insert(buffer1, v)
		else
			table.insert(buffer2, v)
		end
	end
	local activityShowCtrl, bufferNew = (for generator), ipairs(actCfg)
	local activityShowCtrl, bufferNoNew = ipairs(actCfg)
	for i, v in ipairs(buffer1) do
		if self:getNewInfo(v.activityID) then
			table.insert(bufferNew, v)
		else
			table.insert(bufferNoNew, v)
		end
	end
	table.sort(bufferNew, function(a, b)
		if a.beginTime == b.beginTime then
			return a.activityID < b.activityID
		end
		return a.beginTime < b.beginTime
	end)
	table.sort(bufferNoNew, function(a, b)
		if a.beginTime == b.beginTime then
			return a.activityID < b.activityID
		end
		return a.beginTime < b.beginTime
	end)
	table.sort(buffer2, function(a, b)
		if a.beginTime == b.beginTime then
			return a.activityID < b.activityID
		end
		return a.beginTime < b.beginTime
	end)
	local activityShowCtrl, bufferOver = table.sort, table.sort
	local activityShowCtrl, bufferNotOver = buffer2, buffer2
	for i, v in ipairs(buffer2) do
		if v.endTime <= serviceFunctions.systemTime() then
			table.insert(bufferOver, v)
		else
			table.insert(bufferNotOver, v)
		end
	end
	local index = 1
	for i, v in ipairs(bufferNew) do
		self.actConfig[index] = v
		index = index + 1
	end
	for i, v in ipairs(bufferNoNew) do
		self.actConfig[index] = v
		index = index + 1
	end
	for i, v in ipairs(bufferNotOver) do
		self.actConfig[index] = v
		index = index + 1
	end
	for i, v in ipairs(bufferOver) do
		self.actConfig[index] = v
		index = index + 1
	end
	self.fields.List_event:setNumItems(#self.actConfig)
end
function IceShimmerPanel:getNewInfo(eid)
	if clientEventMgr.judgeIsOpen(eid) and clientEventMgr.getNewInfo(eid).isNew then
		return true
	end
	return false
end
return IceShimmerPanel
