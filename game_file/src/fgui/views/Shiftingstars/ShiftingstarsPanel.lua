local shiftingstarsRead = include("shiftingstarsRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ShiftingstarsPanel = class("ShiftingstarsPanel", baseFguiPanel)
function ShiftingstarsPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ShiftingstarsPanel:ctor", self.viewName)
end
function ShiftingstarsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ShiftingstarsPanel:onInit()
	print("=======ShiftingstarsPanel:onInit")
	self.controllers.c1:setSelectedIndex(SoraDGetDefaultLanguage() == "ar" and 0 or 1)
	self.activityID = gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001432"), handler(self, self.onClickClose))
	self.fields.Text_title:setString(i18n("WanderingStars_text_01"))
	self.fields.List_event:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function ShiftingstarsPanel:initData()
	self.actConfig = activityShowCtrl:getParamByID(self.activityID).showConfig
	dump(self.actConfig, "self.actConfig")
	local activityShowCtrl, buffer1 = dump, dump
	local activityShowCtrl, buffer2 = self.actConfig, self.actConfig
	table.sort(self.actConfig, function(a, b)
		return a.activityID < b.activityID
	end)
	for i, v in ipairs(self.actConfig) do
		if clientEventMgr.judgeIsOpen(v.activityID) then
			table.insert(buffer1, v)
		else
			table.insert(buffer2, v)
		end
	end
	local activityShowCtrl, bufferNew = (for generator), ipairs(self.actConfig)
	local activityShowCtrl, bufferNoNew = ipairs(self.actConfig)
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
	dump(bufferNew, "fsjkdfjkdfjkdjkf1111")
	dump(bufferNoNew, "fsjkdfjkdfjkdjkf2222")
	dump(bufferNotOver, "fsjkdfjkdfjkdjkf3333")
	dump(bufferOver, "fsjkdfjkdfjkdjkf4444")
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
	self.fields.List_event:setNumItems(table.nums(self.actConfig))
end
function ShiftingstarsPanel:getNewInfo(eid)
	if clientEventMgr.judgeIsOpen(eid) and clientEventMgr.getNewInfo(eid).isNew then
		dump(eid, "fskfsldfjkdfjkdfjkd")
		return true
	end
	return false
end
function ShiftingstarsPanel:setNewByActID(eid)
	local size = self.fields.List_event:getNumItems()
	for i = 1, size do
		local obj = self.fields.List_event:getChildAt(i - 1)
		if obj:getEventActID() == eid then
			obj:setNewFlag()
			return
		end
	end
end
function ShiftingstarsPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.actConfig[index + 1])
end
function ShiftingstarsPanel:onShow()
	print("=======ShiftingstarsPanel:onShow")
end
return ShiftingstarsPanel
