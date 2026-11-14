local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local anniversaryRead = include("anniversaryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001690_ListPanel = class("Activity_9001690_ListPanel", baseFguiPanel)
function Activity_9001690_ListPanel:ctor(...)
	self.isLRU = true
	Activity_9001690_ListPanel.super.ctor(self, ...)
	print("Activity_9001690_ListPanel:ctor", self.viewName)
end
function Activity_9001690_ListPanel:onInit()
	print("=======Activity_9001690_ListPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.activityID = gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001690"), handler(self, self.onClickClose))
	self.fields.List_event:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001690_ListPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.actConfig[index + 1])
end
function Activity_9001690_ListPanel:endShow()
	print("=======Activity_9001690_ListPanel:endShow")
	self.week = self.param.week
	_ENV = nil
	;(nil).week = self.week
	self.fields.Text_title:setString(i18n("ramadan_pilgrimage_text05", nil))
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self:initData()
end
function Activity_9001690_ListPanel:initData()
	self.showConfig, activityShowCtrl = nil, nil
	local showConfig = activityShowCtrl:getParamByID(self.activityID).showConfig
	local openActList = anniversaryRead.getOpenActCfgEX(2, self.activityID)
	for k, v in ipairs(showConfig) do
		if not SoraDisInList(v.activityID, openActList) then
			table.insert(self.showConfig, v)
		end
	end
	self.actConfig, activityShowCtrl = ipairs(showConfig)
	local activityShowCtrl, bufferNew = ipairs(showConfig)
	local activityShowCtrl, bufferNoNew = ipairs(showConfig)
	local activityShowCtrl, bufferOver = ipairs(showConfig)
	local activityShowCtrl, bufferNotOver
	table.sort(self.showConfig, function(a, b)
		if a.beginTime == b.beginTime then
			return a.activityID < b.activityID
		end
		return a.beginTime < b.beginTime
	end)
	for i, v in ipairs(self.showConfig) do
		if self:isNeedShow(v.weeks, self.week, v.activityID) then
			if clientEventMgr.judgeIsOpen(v.activityID) then
				if self:getNewInfo(v.activityID) then
					table.insert(bufferNew, v)
				else
					table.insert(bufferNoNew, v)
				end
			elseif v.endTime <= serviceFunctions.systemTime() then
				table.insert(bufferOver, v)
			else
				table.insert(bufferNotOver, v)
			end
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
function Activity_9001690_ListPanel:isNeedShow(weeks, week, activityID)
	for i, v in ipairs(weeks) do
		if v == week then
			return true
		end
	end
	return false
end
function Activity_9001690_ListPanel:getNewInfo(eid)
	if clientEventMgr.judgeIsOpen(eid) and clientEventMgr.getNewInfo(eid).isNew then
		return true
	end
	return false
end
return Activity_9001690_ListPanel
