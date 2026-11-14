local cityCell = class("cityCell", cc.mvc.ModelBase)
local timerList = gModuleMgr.getObject("timerList")
local cityBuildConstDef = include("cityBuildConstDef")
function cityCell:ctor()
	cityCell.super.ctor(self)
	self.drawingData, cityCell, self.mastery, cityCell, self.saferes, cityCell, self.queue, cityCell, self.areaList, cityCell, self.resList, cityCell, self.buildList, cityCell, self.info, cityCell = cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor, cityCell.super.ctor
	self:addEventListener(tostring(gQueueTypeDef.charge_build_queue), handler(self, self.cityCellCallback))
end
function cityCell:addBuild(index, buildcell)
	if not cityBuildConstDef.buildIndexDef.abandonBuildIndex[tonumber(index)] then
		if not self.buildList[tostring(index)] then
			self.buildList[tostring(index)] = buildcell
		end
	else
		print("cityCell:addBuild add build failed,index=", index)
	end
end
function cityCell:removeBuild(index)
	if self.buildList[tostring(index)] then
		self.buildList[tostring(index)] = nil
	else
	end
end
function cityCell:upgradeBuild(index)
	local buildcell = self.buildList[tostring(index)]
	if buildcell then
		buildcell:upgrade()
	end
end
function cityCell:upgradeBuildStar(index)
	local buildcell = self.buildList[tostring(index)]
	if buildcell then
		buildcell:upgradeStar()
	end
end
function cityCell:exchangeBuild(preindex, aftindex)
	local prebuild = self.buildList[tostring(preindex)]
	local aftbuild = self.buildList[tostring(aftindex)]
	if prebuild and aftbuild then
		prebuild.info.index = tostring(aftindex)
		self.buildList[tostring(aftindex)] = prebuild
		aftbuild.info.index = tostring(preindex)
		self.buildList[tostring(preindex)] = aftbuild
	end
	if prebuild and not aftbuild then
		prebuild.info.index = tostring(aftindex)
		self.buildList[tostring(aftindex)] = prebuild
		self.buildList[tostring(preindex)] = nil
	end
	if not prebuild and aftbuild then
		aftbuild.info.index = tostring(preindex)
		self.buildList[tostring(preindex)] = aftbuild
		self.buildList[tostring(aftindex)] = nil
	end
end
function cityCell:openArea(areaid)
	table.insert(self.areaList, areaid)
end
function cityCell:addBuildChargeQueue(queuetype, starttime, totaltime, lefttime)
	local queuetype = tostring(queuetype)
	local curqueue = self:queryQueue(queuetype)
	if not curqueue then
		local dispatchQueueEvent = function()
			local data
			queuetype = nil
			;(nil).name = queuetype
			local (nil).data, event = data, nil
			self:dispatchEvent(event)
			self.queue[queuetype] = nil
		end
		local _ENV, queue = queuetype, queuetype
		queue.qtype = queuetype
		queue.starttime = starttime
		queue.totaltime = totaltime
		local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
		if ok then
			queue.timerNode = node
			self.queue[queuetype] = queue
		end
	else
		timerList:increaseTime(curqueue.timerNode, totaltime)
	end
end
function cityCell:queryQueue(queuetype)
	local queuetype = tostring(queuetype)
	local ret = self.queue[queuetype]
	if ret then
		return ret
	else
	end
end
function cityCell:cityCellCallback(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_RECHARGE_BUILDER_COLSE"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_PANDECT_BUILDER"
	;(nil).queueType = gQueueTypeDef.charge_build_queue
	SoraDSendMessage(nil)
end
function cityCell:resetDayMaxRes()
	_ENV = nil
	_ENV = nil
	;(nil)["1001"] = 0
	;(nil)["1002"] = 0
	;(nil)["1003"] = 0
	;(nil)["1004"] = 0
	;(nil)["1005"] = 0
	;(nil)["1006"] = 0
	;(nil)[gResSourceEnum.OTHER], (nil)["1027"] = nil, 0
	_ENV = nil
	;(nil)["1001"] = 0
	;(nil)["1002"] = 0
	;(nil)["1003"] = 0
	;(nil)["1004"] = 0
	;(nil)["1005"] = 0
	;(nil)["1006"] = 0
	;(nil)[gResSourceEnum.DISCOUNT], (nil)["1027"] = nil, 0
	;(nil).rtime = serviceFunctions.getWeehoursUTC()
	self.dayMaxRes, (nil).version = nil, "new_daily_res_limit"
	return self.dayMaxRes
end
function cityCell:judgeDayMaxRes()
	local curtime = serviceFunctions.systemTime()
	local lasttime = curtime - self.dayMaxRes.rtime
	if 86400 <= lasttime then
		self:resetDayMaxRes()
	end
end
function cityCell:getCurDayMaxRes(resid, source)
	source = source or gResSourceEnum.OTHER
	self:judgeDayMaxRes()
	local count = 0
	if self.dayMaxRes[source] then
		count = self.dayMaxRes[source][tostring(resid)] or 0
	end
	return count
end
function cityCell:addMastery(mid, mInfo)
	self.mastery[tostring(mid)] = mInfo
end
function cityCell:getBuildMasteryInfo(...)
	if not self.mastery then
		_UPVALUE0_ = self.mastery
	end
	return self.mastery
end
function cityCell:setDrawingData(data)
	self.drawingData = data
end
function cityCell:getDrawingData(...)
	if not self.drawingData then
		_UPVALUE0_ = self.drawingData
	end
	return self.drawingData
end
return cityCell
