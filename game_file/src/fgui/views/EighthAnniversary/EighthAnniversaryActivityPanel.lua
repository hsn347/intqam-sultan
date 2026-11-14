local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EighthAnniversaryActivityPanel = class("EighthAnniversaryActivityPanel", baseFguiPanel)
function EighthAnniversaryActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EighthAnniversaryActivityPanel:ctor", self.viewName)
end
function EighthAnniversaryActivityPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EighthAnniversaryActivityPanel:onInit()
	print("=======EighthAnniversaryActivityPanel:onInit")
	self.week = self.proxy.param.week
	self.activityID = gActivityTimeActivityID.CALENDAR_9001561_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001561"), handler(self, self.onClickClose))
	self.fields.Text_title:setString(i18n("ruise_rabia_05"))
	self.fields.List_event:setItemRenderer(handler(self, self.onItemRenderer))
end
function EighthAnniversaryActivityPanel:onShow()
	print("=======EighthAnniversaryActivityPanel:onShow")
	self:initData()
end
function EighthAnniversaryActivityPanel:initData()
	self.showConfig = activityShowCtrl:getParamByID(self.activityID).showConfig
	dump(self.showConfig, "self.actConfig")
	self.actConfig, activityShowCtrl = dump, dump
	local activityShowCtrl, bufferNew = dump, dump
	local activityShowCtrl, bufferNoNew = self.showConfig, self.showConfig
	local activityShowCtrl, bufferOver = "self.actConfig", "self.actConfig"
	local activityShowCtrl, bufferNotOver
	table.sort(self.showConfig, function(a, b)
		if a.beginTime == b.beginTime then
			return a.activityID < b.activityID
		end
		return a.beginTime < b.beginTime
	end)
	for i, v in ipairs(self.showConfig) do
		if self:isNeedShow(v.weeks, self.week) then
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
	dump(self.actConfig, "actConfig")
	self.fields.List_event:setNumItems(table.nums(self.actConfig))
end
function EighthAnniversaryActivityPanel:getNewInfo(eid)
	if clientEventMgr.judgeIsOpen(eid) and clientEventMgr.getNewInfo(eid).isNew then
		dump(eid, "fskfsldfjkdfjkdfjkd")
		return true
	end
	return false
end
function EighthAnniversaryActivityPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.actConfig[index + 1])
end
function EighthAnniversaryActivityPanel:isNeedShow(weeks, week)
	for i, v in ipairs(weeks) do
		if v == week then
			return true
		end
	end
	return false
end
return EighthAnniversaryActivityPanel
