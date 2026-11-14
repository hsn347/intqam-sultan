local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
function SoraDManagerRemoveAllTimer()
	if SoraDTimerManager then
		for k, v in pairs(SoraDTimerManager) do
			for index, m in pairs(v) do
				schedulerTime.unscheduleGlobal(m)
				m = nil
			end
			v = nil
		end
		SoraDTimerManager, _ENV = pairs(SoraDTimerManager)
	end
end
SoraDManagerRemoveAllTimer()
SoraDTimerManager, _ENV = SoraDManagerRemoveAllTimer, SoraDManagerRemoveAllTimer
function SoraDManagerAddTimer(target, timer)
	local timerArray = SoraDTimerManager[target]
	if timerArray == nil then
		timerArray, _ENV = nil, nil
		SoraDTimerManager[target] = timerArray
	end
	timerArray[#timerArray + 1] = timer
end
function SoraDManagerRemoveTimer(target, timer)
	local timerArray = SoraDTimerManager[target]
	if timerArray then
		for k, v in pairs(timerArray) do
			if v == timer then
				schedulerTime.unscheduleGlobal(timer)
				table.remove(timerArray, k)
				return
			end
		end
	end
end
function SoraDManagerRemoveTimerCustom(customScheduler, target, timer)
	schedulerTime.unscheduleGlobalCustom(customScheduler, timer)
end
function SoraDManagerRemoveTimerByTarget(target)
	local timerArray = SoraDTimerManager[target]
	if timerArray then
		for k, v in pairs(timerArray) do
			schedulerTime.unscheduleGlobal(v)
			v = nil
		end
	end
	SoraDTimerManager[target] = nil
end
function SoraDManagerFindTimerByTarget(target)
	local ret = false
	local timerArray = SoraDTimerManager[target]
	if timerArray then
		ret = next(timerArray)
	end
	return ret
end
function SoraDManagerFindTimerByTargetHandle(target, handle)
	local ret = false
	local timerArray = SoraDTimerManager[target]
	if timerArray then
		for _, v in pairs(timerArray) do
			if v == handle then
				ret = true
				break
			end
		end
	end
	return ret
end
