local escortDataMgr = class("escortDataMgr")
function escortDataMgr:ctor()
	self.closestBuild, _ENV = nil, nil
	self.escortCount = 0
	self.assistCount = 0
	self.robCount = 0
	self.t = 0
	self.ESCORT_CITYLEVEL_MIN = ESCORT_CITYLEVEL_MIN
	self.ESCORT_DAY_MAX = ESCORT_DAY_MAX
	self.ESCORT_ASSIST_DAY_MAX = ESCORT_ASSIST_DAY_MAX
	self.ESCORT_ROB_DAY_MAX = ESCORT_ROB_DAY_MAX
	self.ESCORT_ALLOW_ROBBED_ONCE_MAX = ESCORT_ALLOW_ROBBED_ONCE_MAX
end
function escortDataMgr:getClosestBuild()
	return self.closestBuild
end
function escortDataMgr:setClosestBuild(build)
	self.closestBuild = build
end
function escortDataMgr:getEscortCount()
	return self.escortCount
end
function escortDataMgr:setEscortCount(count, t)
	self.escortCount = count
	self.t = t or serviceFunctions.systemTime()
end
function escortDataMgr:getAssistCount()
	return self.assistCount
end
function escortDataMgr:setAssistCount(count, t)
	self.assistCount = count
	self.t = t or serviceFunctions.systemTime()
end
function escortDataMgr:getRobCount()
	return self.robCount
end
function escortDataMgr:setRobCount(count, t)
	self.robCount = count
	self.t = t or serviceFunctions.systemTime()
end
function escortDataMgr:getEscortCityLevelMin()
	return self.ESCORT_CITYLEVEL_MIN
end
function escortDataMgr:getEscortDayMax()
	local ret = self.ESCORT_DAY_MAX
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local vip = lordInfoCtrl:getVip()
	if vip[2] and vip[1] >= 19 then
		ret = ret + 1
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local add = buffCtrl:getBuffEffect(gBuffEffect.ESCORT_ADD_TIMES) or 0
	ret = ret + add
	return ret
end
function escortDataMgr:getEscortAssistDayMax()
	return self.ESCORT_ASSIST_DAY_MAX
end
function escortDataMgr:getEscortRobDayMax()
	return self.ESCORT_ROB_DAY_MAX
end
function escortDataMgr:getEscortAllowRobbedOnceMax()
	return self.ESCORT_ALLOW_ROBBED_ONCE_MAX
end
return escortDataMgr
