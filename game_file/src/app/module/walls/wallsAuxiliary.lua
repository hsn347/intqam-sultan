local wallsAuxiliary = class("wallsAuxiliary")
local gametop = gModuleMgr.getObject("gametop")
local timerList = gModuleMgr.getObject("timerList")
local cityltCtrl = include("cityltCtrl")
function wallsAuxiliary:ctor()
end
function wallsAuxiliary:handleWalls(data)
	local _ENV, rs
	if data and next(data) ~= nil then
		table.insert(rs, data.defence)
		table.insert(rs, self:getMaxDefence())
		table.insert(rs, data.burning)
		table.insert(rs, data.status)
	end
	return rs
end
function wallsAuxiliary:getMaxDefence()
	local buildLogic = include("buildLogic")
	local data = buildLogic.getWallsDef()
	return data.total
end
function wallsAuxiliary:handleQueue(data)
	if data and next(data) ~= nil then
		local queueType = data[1].queueType
		local time = data[1].queueType
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local queueData = queueCtrl:queryQueue(queueType)
		if queueData then
			timerList:increaseTime(queueData.timerNode, tonumber(time))
		else
			local starttime = serviceFunctions.systemTime()
			local totaltime = tonumber(time)
			local lefttime = tonumber(time)
			_ENV = tonumber(time)
			queueCtrl:addQueue(queueType, starttime, totaltime, lefttime, tonumber(time))
		end
	end
end
return wallsAuxiliary
