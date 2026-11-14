local baseProxy = require("fgui.base.baseProxy")
local HomePopupProxy = class("HomePopupProxy", baseProxy)
function HomePopupProxy:onRegisterEvent()
	print("=======HomePopupProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function HomePopupProxy:judgeClose(target, data)
	local dirtyMark = false
	if not self.activityList then
		_ENV = self.activityList
	end
	for i, activityID in ipairs(self.activityList) do
		if not self:judgeIsShow(activityID) then
			dirtyMark = true
			break
		end
	end
	if dirtyMark then
		self.view:refreshActivityList()
	end
end
local getKey = function(activityID, atype)
	return tostring(activityID) .. tostring(atype)
end
local activitypublicity = require_data("activitypublicity").data
function HomePopupProxy:judgeIsShow(activityID)
	return clientEventMgr.nowEventStateList[activityID] and clientEventMgr.nowEventStateList[activityID].eventState == gActivityState.OPEN
end
function HomePopupProxy:checkShowView(popList)
	local _ENV, popList = nil, popList or nil
	for i, v in ipairs(activitypublicity) do
		if self:judgeIsShow(v.ID) and not popList[tostring(v.ID)] then
			return true
		end
	end
end
function HomePopupProxy:getActivityList(...)
	local _ENV, ret
	for i, v in ipairs(activitypublicity) do
		if self:judgeIsShow(v.ID) then
			ret[v.ID] = true
		end
	end
	ret = table.keys(ret)
	table.sort(ret, function(a, b)
		local sorta = self:getConfigData(a).sort
		local sortb = self:getConfigData(b).sort
		if sorta ~= sortb then
			return sorta < sortb
		end
		return a < b
	end)
	self.activityList = ret
	return self.activityList
end
function HomePopupProxy:getConfigData(activityID, atype)
	if not self.activityconfigmap then
		self.activityconfigmap, _ENV = self.activityconfigmap, self.activityconfigmap
		for i, v in ipairs(activitypublicity) do
			self.activityconfigmap[getKey(v.ID, v.type)] = v
		end
	end
	local activityIDStr = getKey(activityID, 0)
	local config = self.activityconfigmap[activityIDStr]
	if not config then
		if not atype or atype == 0 then
			atype = 1
		end
		activityIDStr = getKey(activityID, atype)
		config = self.activityconfigmap[activityIDStr]
	end
	return config
end
return HomePopupProxy
