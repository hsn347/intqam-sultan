serviceFunctions, _ENV = nil, nil
serviceFunctions.log, _ENV = nil, nil
local randomSeed
function serviceFunctions.getModule(moduleName)
	return gModuleMgr.getObject("gametop").playertop_:getModule(moduleName)
end
function serviceFunctions.table_copy_table(ori_tab)
	if type(ori_tab) ~= "table" then
		return nil
	end
	local _ENV, new_tab
	for i, v in pairs(ori_tab) do
		local vtyp = type(v)
		if vtyp == "table" then
			new_tab[i] = serviceFunctions.table_copy_table(v)
		elseif vtyp == "thread" then
			new_tab[i] = v
		elseif vtyp == "userdata" then
			new_tab[i] = v
		else
			new_tab[i] = v
		end
	end
	return new_tab
end
function serviceFunctions.getWeekDay(time)
	time = time or serviceFunctions.systemTime()
	local weekDay = tonumber(os.date("%w", time))
	weekDay = weekDay == 0 and 7 or weekDay
	return tonumber(weekDay)
end
function serviceFunctions.getWeekDayEx(time)
	time = time or serviceFunctions.systemTime()
	local weekDay = tonumber(os.date("!%w", time))
	weekDay = weekDay == 0 and 7 or weekDay
	return tonumber(weekDay)
end
function serviceFunctions.getNextWeekDayUTC(nextWeekDay, beginTime)
	if "number" ~= type(nextWeekDay) or nextWeekDay < 1 or 7 < nextWeekDay then
		return nil
	end
	local sec0 = serviceFunctions.getTomorrowZeroHourUTC(beginTime)
	local secOfOneDay = 86400
	local weekDay = serviceFunctions.getWeekDay(sec0)
	if nextWeekDay == weekDay then
		return sec0
	elseif nextWeekDay > weekDay then
		return sec0 + secOfOneDay * (nextWeekDay - weekDay)
	elseif nextWeekDay < weekDay then
		return sec0 + secOfOneDay * (gWeekDay.SUNDAY - weekDay + nextWeekDay)
	end
end
function serviceFunctions.getTodayTimeSec()
	local time = serviceFunctions.systemTime()
	local h = tonumber(os.date("%H", time))
	local m = tonumber(os.date("%M", time))
	local s = tonumber(os.date("%S", time))
	return h * 3600 + m * 60 + s
end
function serviceFunctions.getTomorrowZeroHourUTC(time)
	time = time or serviceFunctions.systemTime()
	local h = tonumber(os.date("!%H", time))
	local m = tonumber(os.date("%M", time))
	local s = tonumber(os.date("%S", time))
	return time + ((23 - h) * 3600 + (59 - m) * 60 + (60 - s))
end
function serviceFunctions.getTimeZone(isdst)
	local now = os.time()
	local now_time_table = os.date("*t", now)
	local diff = os.difftime(now, os.time(os.date("!*t", now)))
	if isdst and now_time_table.isdst then
		diff = diff + 3600
	end
	return diff
end
function serviceFunctions.getNextHourTime(time)
	time = time or serviceFunctions.systemTime()
	local m = tonumber(os.date("%M", time))
	local s = tonumber(os.date("%S", time))
	return 3600 - (m * 60 + s)
end
function serviceFunctions.getNextMonthFirstDayTime(day)
	local curTime = serviceFunctions.systemTime()
	local curVal = os.date("!*t", curTime)
	local timeZone = serviceFunctions.getTimeZone(true)
	_ENV = nil
	;(nil).year = curVal.year
	;(nil).month = curVal.month + 1
	;(nil).day = day or 1
	;(nil).hour = 0
	;(nil).min = 0
	;(nil).sec = timeZone
	local firstDate = os.time(nil)
	return firstDate - curTime
end
function serviceFunctions.getNextMonthDayTime(time, month, day)
	local curTime = time or serviceFunctions.systemTime()
	local curVal = os.date("!*t", curTime)
	local timeZone = serviceFunctions.getTimeZone(true)
	_ENV = nil
	;(nil).year = curVal.year
	;(nil).month = curVal.month + (month or 1)
	;(nil).day = day or 1
	;(nil).hour = 0
	;(nil).min = 0
	;(nil).sec = timeZone
	local firstDate = os.time(nil)
	return firstDate - serviceFunctions.systemTime()
end
function serviceFunctions.getNextSeasonFirstDayTime(day)
	local curTime = serviceFunctions.systemTime()
	local curVal = os.date("!*t", curTime)
	local timeZone = serviceFunctions.getTimeZone(true)
	_UPVALUE4_ = true
	;(true)[1] = 1
	;(true)[2] = 4
	;(true)[3] = 7
	local (true)[4], seasonCfg = 10, true
	local sMonth = seasonCfg[1]
	local sYear = curVal.year
	if curVal.month < seasonCfg[2] then
		sMonth = seasonCfg[2]
	elseif curVal.month >= seasonCfg[2] and curVal.month < seasonCfg[3] then
		sMonth = seasonCfg[3]
	elseif curVal.month >= seasonCfg[3] and curVal.month < seasonCfg[4] then
		sMonth = seasonCfg[4]
	else
		sYear = sYear + 1
	end
	_ENV = seasonCfg[4]
	seasonCfg[4].year = sYear
	seasonCfg[4].month = sMonth
	seasonCfg[4].day = day or 1
	seasonCfg[4].hour = 0
	seasonCfg[4].min = 0
	seasonCfg[4].sec = timeZone
	local firstDate = os.time(seasonCfg[4])
	return firstDate - curTime
end
function serviceFunctions.tableFormat(t, keys)
	local _ENV, ret
	local n = #keys
	if n <= 0 then
		return t
	end
	local totalNum = #t
	assert(totalNum % n == 0, "配置表和分割数不对应:" .. totalNum)
	for i = 1, #t, n do
		local _ENV, d
		for j, key in ipairs(keys) do
			d[key] = t[i + j - 1]
		end
		ret[#ret + 1] = d
	end
	return ret
end
function serviceFunctions.tableFormatToMap(t)
	local _ENV, ret
	local totalNum = #t
	assert(totalNum % 2 == 0, "配置表和分割数不对应")
	for i = 1, #t, 2 do
		local key = t[i]
		local value = t[i + 1]
		ret[key] = value
	end
	return ret
end
function serviceFunctions.resConvertToGold(resid, rescount)
	if rescount <= 0 then
		return 0
	end
	local resid = tonumber(resid)
	local rescount = tonumber(rescount)
	local coefficient = 1
	if resid == 1002 or resid == 1003 then
		coefficient = 1
	elseif resid == 1004 then
		coefficient = 6
	elseif resid == 1005 then
		coefficient = 25
	elseif resid == 1027 or resid == 1620 then
		coefficient = 100
	end
	local x = 250
	local y = 610000
	local temp = 1 - rescount / (rescount + y)
	if temp <= 0.55 then
		temp = 0.55
	end
	local ret = math.ceil(rescount / x * temp * coefficient + 1)
	return ret
end
function serviceFunctions.timeConvertToRadianceQuarry(time)
	if time <= 0 then
		return 0
	end
	local radianceWarDef = include("radianceWarDef")
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local value = backpackltCtrl:getResult(radianceWarDef.RADIANCE_QUARRY).value or 1
	return math.ceil(time / value)
end
function serviceFunctions.timeConvertToGold(time, isArmy, isAllianceTech, isMaterialFactory)
	if time <= 0 then
		return 0
	end
	local x = 22
	local y = 1750000
	local temp = 1 - time / (time + y)
	if temp <= 0.67 then
		temp = 0.67
	end
	local params = 13
	if isArmy then
		params = 0
	end
	local ret = math.ceil(time / x * temp - params)
	if ret < 1 then
		ret = 1
	end
	if isAllianceTech then
		ret = math.ceil(ret * 0.25)
		if ret < 1 then
			ret = 1
		end
	elseif isMaterialFactory then
		ret = serviceFunctions.refineryTimeCovertToGold(time)
	end
	if not isMaterialFactory and not isArmy and ret > time / 3600 * 150 then
		ret = math.ceil(time / 3600 * 150)
	end
	return ret
end
function serviceFunctions.refineryTimeCovertToGold(mTime)
	local tmpGold = 0
	if nil ~= mTime then
		local tmpMin = math.floor(mTime / 60)
		local tmpLeftSec = mTime - tmpMin * 60
		if 0 < tmpLeftSec and tmpLeftSec < 60 then
			tmpMin = tmpMin + 1
		end
		if tmpMin % 2 ~= 0 then
			tmpMin = tmpMin + 1
		end
		tmpGold = tmpMin / 2
	end
	return tmpGold
end
function serviceFunctions.systemTime()
	local gametop = gModuleMgr.getObject("gametop")
	if gametop and gametop.playertop_ then
		local timeCtrl = gametop.playertop_:getModule("timeCtrl")
		return timeCtrl:getServerTime()
	else
		return os.time()
	end
end
function serviceFunctions.print(...)
	local removeNum = #serviceFunctions.log - 20
	if 0 < removeNum then
		for i = 1, removeNum do
			table.remove(serviceFunctions.log, 1)
		end
	end
	local formattedTime = os.date("%H:%M:%S")
	_UPVALUE1_ = "%H:%M:%S"
	;("%H:%M:%S")[1] = formattedTime
	;("%H:%M:%S")[2] = ...
	;("%H:%M:%S")[3] = ...
	;("%H:%M:%S")[4] = ...
	;("%H:%M:%S")[5] = ...
	;("%H:%M:%S")[6] = ...
	;("%H:%M:%S")[7] = ...
	;("%H:%M:%S")[8] = ...
	;("%H:%M:%S")[9] = ...
	local ("%H:%M:%S")[10], args = ...
	local _ENV, logParts = formattedTime, formattedTime
	for _, arg in ipairs(args) do
		table.insert(logParts, tostring(arg))
	end
	local log = table.concat(logParts, " ")
	table.insert(serviceFunctions.log, log)
end
function serviceFunctions.getLoginFailType()
	local strLog = table.concat(serviceFunctions.log, "\r\n")
	return strLog
end
function serviceFunctions.vagueCompare(comStr, origStr)
	if "string" == type(comStr) and "string" == type(origStr) then
		if comStr == origStr then
			return true, 1
		end
		origStr = string.lower(origStr)
		comStr = string.lower(comStr)
		local ret = string.match(origStr, "^(" .. comStr .. ")")
		if ret then
			return true, 2
		end
	end
	return false
end
function serviceFunctions.getWeehoursUTC()
	local tb = os.date("*t", serviceFunctions.systemTime())
	tb.hour = 0
	tb.min = 0
	tb.sec = 0
	local weehoursutc = os.time(tb)
	return weehoursutc
end
function serviceFunctions.getMothhoursUTC()
	local systemTime = serviceFunctions.systemTime()
	local y = os.date("!%Y", systemTime)
	local m = os.date("!%m", systemTime)
	m = m + 1
	if 12 < m then
		m = 1
		y = y + 1
	end
	local timeZone = serviceFunctions.getTimeZone(true)
	_ENV = nil
	;(nil).year = y
	;(nil).month = m
	;(nil).day = 1
	;(nil).hour = 0
	;(nil).min = 0
	;(nil).sec = timeZone
	local monthhoursutc = os.time(nil)
	return monthhoursutc
end
function serviceFunctions.isInWeehours()
	local ret = false
	local systemTime = serviceFunctions.systemTime()
	local hour = os.date("%H", systemTime)
	local minute = os.date("%M", systemTime)
	local second = os.date("%S", systemTime)
	if hour == "00" and minute == "00" and second == "00" then
		ret = true
	end
	return ret
end
function serviceFunctions.getTodayRemainTime()
	local todayTime = serviceFunctions.systemTime() - serviceFunctions.getTodayZeroHourUTC()
	local leftTime = 86400 - todayTime
	return leftTime
end
function serviceFunctions.getMothRemainTime()
	local leftTime = serviceFunctions.getMothhoursUTC() - serviceFunctions.systemTime()
	return leftTime
end
function serviceFunctions.isInSundayWeehours()
	local ret = false
	local systemTime = serviceFunctions.systemTime()
	local week = os.date("%A", systemTime)
	if isInWeehours and week == "Sunday" then
		ret = true
	end
	return ret
end
function serviceFunctions.exception(errorMessage)
	print("===========================================================")
	print("LUA EXCEPTION: " .. tostring(errorMessage) .. "\n")
	print(debug.traceback("", 2))
	print("===========================================================")
end
function serviceFunctions.lineIntersectRang(p1, p2, rang)
	_ENV = nil
	;(nil).x = rang.startX
	_ENV, (nil).y = rang.startY, rang.startY
	rang.startY.x = rang.endX
	rang.startY.y = rang.startY
	if serviceFunctions.getHitPoint(p1, p2, nil, rang.startY) then
		return true
	else
		_ENV = nil
		;(nil).x = rang.endX
		_ENV, (nil).y = rang.startY, rang.startY
		rang.startY.x = rang.endX
		rang.startY.y = rang.endY
		if serviceFunctions.getHitPoint(p1, p2, nil, rang.startY) then
			return true
		else
			_ENV = nil
			;(nil).x = rang.startX
			_ENV, (nil).y = rang.endY, rang.endY
			rang.endY.x = rang.endX
			rang.endY.y = rang.endY
			if serviceFunctions.getHitPoint(p1, p2, nil, rang.endY) then
				return true
			else
				_ENV = nil
				;(nil).x = rang.startX
				_ENV, (nil).y = rang.startY, rang.startY
				rang.startY.x = rang.startX
				rang.startY.y = rang.endY
				if serviceFunctions.getHitPoint(p1, p2, nil, rang.startY) then
					return true
				else
					print(string.format("serviceFunctions.lineIntersectRang false,x=%d,y=%d,x1=%d,y1=%d,startX=%d,startY=%d,endX=%d,endY=%d", p1.x, p1.y, p2.x, p2.y, rang.startX, rang.startY, rang.endX, rang.endY))
					return false
				end
			end
		end
	end
end
function serviceFunctions.getHitPoint(p1, p2, p3, p4)
	local p
	local isParallel = false
	if p1.x ~= p2.x and p3.x ~= p4.x then
		local k1 = (p1.y - p2.y) / (p1.x - p2.x)
		local b1 = p1.y - k1 * p1.x
		local k2 = (p3.y - p4.y) / (p3.x - p4.x)
		local b2 = p3.y - k2 * p3.x
		if k1 == k2 then
			isParallel = true
			return nil, isParallel
		end
		p, _ENV = nil, nil
		p.x = -(b1 - b2) / (k1 - k2)
		p.y = (k1 * b2 - k2 * b1) / (k1 - k2)
	else
		local k, b
		if p1.x == p2.x and p3.x ~= p4.x then
			k = (p3.y - p4.y) / (p3.x - p4.x)
			p, _ENV, b = p3.y, p3.y, p3.y - k * p3.x
			p.x = p1.x
			p.y = k * p.x + b
		elseif p1.x ~= p2.x then
			k = (p1.y - p2.y) / (p1.x - p2.x)
			p, _ENV, b = p1.y, p1.y, p1.y - k * p1.x
			p.x = p3.x
			p.y = k * p.x + b
		end
	end
	if p then
		p.x = tonumber(tostring(p.x))
		p.y = tonumber(tostring(p.y))
		if p.x < math.min(p1.x, p2.x) or p.x > math.max(p1.x, p2.x) or p.x < math.min(p3.x, p4.x) or p.x > math.max(p3.x, p4.x) or p.y < math.min(p1.y, p2.y) or p.y > math.max(p1.y, p2.y) or p.y < math.min(p3.y, p4.y) or p.y > math.max(p3.y, p4.y) then
			return nil, isParallel
		end
	end
	return p, isParallel
end
function serviceFunctions.lineSpace(x1, y1, x2, y2)
	local lineLength = 0
	lineLength = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
	return lineLength
end
function serviceFunctions.pointToLine(x1, y1, x2, y2, x0, y0)
	local space = 0
	local a, b, c
	a = serviceFunctions.lineSpace(x1, y1, x2, y2)
	b = serviceFunctions.lineSpace(x1, y1, x0, y0)
	c = serviceFunctions.lineSpace(x2, y2, x0, y0)
	if c <= 1.0E-6 or b <= 1.0E-6 then
		space = 0
		return space
	end
	if a <= 1.0E-6 then
		space = b
		return space
	end
	if c * c >= a * a + b * b then
		space = b
		return space
	end
	if b * b >= a * a + c * c then
		space = c
		return space
	end
	local p = (a + b + c) / 2
	local s = math.sqrt(p * (p - a) * (p - b) * (p - c))
	space = 2 * s / a
	return space
end
function serviceFunctions.heronForS(x1, y1, x2, y2, x0, y0)
	local a = serviceFunctions.lineSpace(x1, y1, x2, y2)
	local b = serviceFunctions.lineSpace(x1, y1, x0, y0)
	local c = serviceFunctions.lineSpace(x2, y2, x0, y0)
	local p = (a + b + c) / 2
	return math.sqrt(p * (p - a) * (p - b) * (p - c))
end
function serviceFunctions.getMapDistance(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)) * 100
end
function serviceFunctions.getTwoPointDistance(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end
function serviceFunctions.isPointSame(p1, p2)
	return p1.x == p2.x and p1.y == p2.y
end
function serviceFunctions.mapConvertArrayAndSort(map, sortFun)
	local _ENV, ret
	for _, v in pairs(map) do
		table.insert(ret, v)
	end
	table.sort(ret, sortFun)
	return ret
end
function serviceFunctions.getArmyLvNType(armyid)
	local armyid = tonumber(armyid)
	if not armyid then
		return
	end
	armyid = armyid % 1000
	local sType, lv = string.match(armyid, "(%d)(%d%d)")
	sType = tonumber(sType)
	lv = tonumber(lv)
	return lv, sType
end
function serviceFunctions.getArmyViewLev(armyID)
	if armyID then
		local curArmy = tonumber(armyID)
		if math.floor(curArmy / 100000000) > 0 then
			local curLv = serviceFunctions.getArmyLvNType(curArmy)
			if curLv then
				return curLv * 10 + 5
			end
		else
			local curLv = serviceFunctions.getArmyLvNType(curArmy)
			if curLv then
				return curLv * 10
			end
		end
	end
end
function serviceFunctions.getArmyClassByArmyId(armyId)
	local armyId = tonumber(armyId)
	for key, armyClass in pairs(gArmyClassRefId) do
		if 1000 <= armyId then
			armyId = armyId % 1000
		end
		if armyId >= armyClass.startId and armyId <= armyClass.endId then
			return key
		end
	end
end
function serviceFunctions.getArmyTypeByArmyId(armyId)
	for _, armyClass in pairs(gArmyClassRefId) do
		if 1000 <= armyId then
			armyId = armyId % 1000
		end
		if armyId >= armyClass.startId and armyId <= armyClass.endId then
			return armyClass.armyClassType
		end
	end
end
function serviceFunctions.isTrapID(armyid)
	local armyid = tonumber(armyid)
	if 800 < armyid and armyid <= 899 then
		return true
	end
end
function serviceFunctions.getMapObjSizeByMapType(mapType)
	if mapType == gMapObjTypeDef.mapObjTypeCastale then
		return gCastleSize
	elseif mapType == gMapObjTypeDef.mapObjTypeBattery or mapType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
		return gBatterySize
	elseif mapType == gMapObjTypeDef.mapObjTypePlayer then
		return gCitySize
	elseif mapType == gMapObjTypeDef.mapObjTypeRelics then
		return gRelicsSize
	elseif mapType == gMapObjTypeDef.desertMeteorite then
		return gDesertMeteoriteSize
	else
		return gMapObjDefaultSize
	end
end
local type = type
function serviceFunctions.deepMerge(dest, src)
	for k, v in pairs(src) do
		if type(v) == "table" then
			local dk = dest[k]
			if not dk then
				dest[k] = v
			elseif type(dk) == "table" then
				serviceFunctions.deepMerge(dk, v)
			else
				print("serviceFunctions.deepMerge type not same")
			end
		else
			dest[k] = v
		end
	end
end
function serviceFunctions.getCurDate(time)
	time = time or os.time()
	local h = os.date("%H", time)
	local m = os.date("%M", time)
	local s = os.date("%S", time)
	local sec0 = time - (h * 3600 + m * 60 + s)
	return sec0
end
_ENV, serviceFunctions.getKingdomFormatName = serviceFunctions, function(kingdomName, kingdomId)
	if not kingdomName or kingdomName == "" then
		kingdomName = "Kingdom"
	end
	return tostring(kingdomName) .. "#" .. tostring(kingdomId)
end
serviceFunctions.MONDAY = 1
serviceFunctions.TUESDA = 2
serviceFunctions.WEDNESDAY = 3
serviceFunctions.THURSDAY = 4
serviceFunctions.FRIDAY = 5
serviceFunctions.SATURDAY = 6
gWeekDay, serviceFunctions.SUNDAY = serviceFunctions, 7
local SEC_OF_DAY = 86400
function serviceFunctions.getUtcDayIndex(ts)
	ts = tonumber(ts) or 0
	return math.floor(ts / SEC_OF_DAY)
end
function serviceFunctions.isSameDay(time1, time2)
	time2 = time2 or serviceFunctions.systemTime()
	local day1 = serviceFunctions.getUtcDayIndex(time1)
	local day2 = serviceFunctions.getUtcDayIndex(time2)
	if day1 ~= day2 then
		return false
	end
	local mon1 = os.date("!%m", time1)
	local mon2 = os.date("!%m", time2)
	if mon1 ~= mon2 then
		return false
	end
	local year1 = os.date("!%Y", time1)
	local year2 = os.date("!%Y", time2)
	if year1 ~= year2 then
		return false
	end
	return true
end
function serviceFunctions.sameDayDo(time, f, ...)
	local currentTime = serviceFunctions.systemTime()
	if serviceFunctions.isSameDay(time, currentTime) then
		f(currentTime, ...)
	end
end
function serviceFunctions.notSameDayDo(time, f, ...)
	local currentTime = serviceFunctions.systemTime()
	if not serviceFunctions.isSameDay(time, currentTime) then
		f(currentTime, ...)
	end
end
function serviceFunctions.isSameYear(time1, time2)
	time2 = time2 or serviceFunctions.systemTime()
	local year1 = os.date("!%Y", time1)
	local year2 = os.date("!%Y", time2)
	if year1 ~= year2 then
		return false
	end
	return true
end
function serviceFunctions.isSameYearAndMonth(time1, time2)
	if not serviceFunctions.isSameYear(time1, time2) then
		return false
	end
	time2 = time2 or serviceFunctions.systemTime()
	local month1 = os.date("!%m", time1)
	local month2 = os.date("!%m", time2)
	if month1 ~= month2 then
		return false
	end
	return true
end
_ENV, serviceFunctions.isSameYearWeeks = serviceFunctions, function(startWeekDay, time1, time2)
	local curTime = serviceFunctions.systemTime()
	time2 = time2 or curTime
	local curVal = os.date("*t", curTime)
	_ENV = curTime
	curTime.year = curVal.year
	curTime.month = 1
	curTime.day = 1
	curTime.hour = 0
	curTime.min = 0
	curTime.sec = 0
	local firstDate = os.time(curTime)
	local firstDateWeek = tonumber(os.date("%w", firstDate))
	if firstDateWeek == 0 then
		firstDateWeek = 7
	end
	if startWeekDay < firstDateWeek then
		_ENV = os.date("%w", firstDate)
		os.date("%w", firstDate).year = curVal.year
		os.date("%w", firstDate).month = 1
		os.date("%w", firstDate).day = 7 - firstDateWeek + startWeekDay + 1
		os.date("%w", firstDate).hour = 0
		os.date("%w", firstDate).min = 0
		os.date("%w", firstDate).sec = 0
		firstDate = os.time(os.date("%w", firstDate))
	elseif startWeekDay > firstDateWeek then
		_ENV = os.date("%w", firstDate)
		os.date("%w", firstDate).year = curVal.year
		os.date("%w", firstDate).month = 1
		os.date("%w", firstDate).day = startWeekDay - firstDateWeek + 1
		os.date("%w", firstDate).hour = 0
		os.date("%w", firstDate).min = 0
		os.date("%w", firstDate).sec = 0
		firstDate = os.time(os.date("%w", firstDate))
	end
	local difDate1 = math.floor((time1 - firstDate) / 86400)
	local difDate2 = math.floor((time2 - firstDate) / 86400)
	return math.floor(difDate1 / 7) == math.floor(difDate2 / 7)
end
serviceFunctions.permillage = 1
local serviceFunctions.value, valueTypeClass = 2, serviceFunctions
function serviceFunctions.getPermillageValue(v)
	local num = tonumber(v)
	local valueType = math.floor(num / 10000)
	local value = num - valueType * 10000
	if valueType == valueTypeClass.permillage then
		return value
	else
		skynet.error("getPermillageValue valueType is error v=", v)
		return 0
	end
end
function serviceFunctions.getValue(v)
	local num = tonumber(v)
	local valueType = num % 10000
	local value = num - valueType * 10000
	if valueType == valueTypeClass.value then
		return value
	else
		skynet.error("getValue valueType is error v=", v)
		return 0
	end
end
function serviceFunctions.isNilOrZero(value)
	return value == nil or value == 0
end
function serviceFunctions.isSameButNotNil(v1, v2)
	if not serviceFunctions.isNilOrZero(v1) and not serviceFunctions.isNilOrZero(v2) and v1 == v2 then
		return true
	else
		return false
	end
end
function serviceFunctions.formatStr2Table(str)
	local _ENV, ret
	for w in string.gmatch(str, "%w+") do
		table.insert(ret, w)
	end
	return ret
end
function serviceFunctions.isEmojiCodePoint(codePoint)
	if "number" ~= type(codePoint) then
		return
	end
	return 9728 <= codePoint and codePoint <= 10175 or codePoint == 12349 or codePoint == 8265 or codePoint == 8252 or 8192 <= codePoint and codePoint <= 8207 or 8232 <= codePoint and codePoint <= 8239 or codePoint == 8287 or 8293 <= codePoint and codePoint <= 8303 or 8448 <= codePoint and codePoint <= 8527 or 8960 <= codePoint and codePoint <= 9215 or 11008 <= codePoint and codePoint <= 11263 or 10496 <= codePoint and codePoint <= 10623 or 12800 <= codePoint and codePoint <= 13055 or 55296 <= codePoint and codePoint <= 57343 or 57344 <= codePoint and codePoint <= 63743 or 65024 <= codePoint and codePoint <= 65039 or 65536 <= codePoint
end
local bit = require("bit32")
local MAXUNICODE = 1114111
function serviceFunctions.utf8_decode(s)
	_ENV = nil
	;(nil)[0] = 255
	;(nil)[1] = 127
	;(nil)[2] = 2047
	local (nil)[3], limits = 65535, nil
	local c = string.byte(s, 1)
	local res = 0
	if c < 128 then
		res = c
	else
		local i = 2
		while 0 ~= bit.band(c, 64) do
			local cc = string.byte(s, i)
			if not cc then
				break
			end
			if bit.band(cc, 192) ~= 128 then
				return
			end
			res = bit.bor(bit.lshift(res, 6), bit.band(cc, 63))
			c = bit.lshift(c, 1)
			i = i + 1
		end
		local count = string.len(s) - 1
		res = bit.bor(res, (bit.lshift(bit.band(c, 127), count * 5)))
		if 3 < count or res > MAXUNICODE or res <= limits[count] then
			return
		end
	end
	return res
end
function serviceFunctions.isEmojiChar(c)
	if "string" ~= type(c) or "" == c then
		return
	end
	local codePoint = serviceFunctions.utf8_decode(c)
	return serviceFunctions.isEmojiCodePoint(codePoint)
end
function serviceFunctions.convertStringToArray(input)
	if "string" ~= type(input) and string.len(input) > 0 then
		_ENV = string.len(input)
		string.len(input)[1] = input
		return (string.len(input))
	end
	local type, array = string.len(input), string.len(input)
	local len = string.len(input)
	local pos = 1
	_UPVALUE6_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 192
	;(nil)[3] = 224
	;(nil)[4] = 240
	;(nil)[5] = 248
	local (nil)[6], arr = 252, nil
	while 0 < pos and len >= pos do
		local tmp = string.byte(input, pos)
		local i = #arr
		while arr[i] do
			if tmp >= arr[i] then
				local c = string.sub(input, pos, pos + i - 1)
				table.insert(array, c)
				pos = pos + i
				break
			end
			i = i - 1
		end
	end
	return array
end
function serviceFunctions.isMatchEnNumAndArPerfectly(str)
	local matchFun = function(c)
		if not serviceFunctions.isArAlphabet(c) and not serviceFunctions.isEnAlphabet(c) and not tonumber(c) then
			return false
		end
		return true
	end
	return serviceFunctions.isMatchPerfectly(str, matchFun)
end
function serviceFunctions.isArAlphabet(c)
	if "string" ~= type(c) or "" == c then
		return
	end
	if #c == 2 and 216 <= string.byte(c, 1) and string.byte(c, 1) <= 219 and string.byte(c, 2) >= 128 and string.byte(c, 2) <= 191 then
		return true
	end
	return false
end
function serviceFunctions.isEnAlphabet(c)
	if "string" ~= type(c) or "" == c then
		return
	end
	if string.match(c, "%a") then
		return true
	end
	return false
end
function serviceFunctions.isMatchPerfectly(str, matchFun)
	if "string" ~= type(str) or "function" ~= type(matchFun) then
		return false
	end
	local strArray = serviceFunctions.convertStringToArray(str)
	if "table" ~= type(strArray) or 0 == #strArray then
		return false
	end
	local strRet = ""
	for i, c in ipairs(strArray) do
		if not matchFun(c) then
			return false
		end
		strRet = strRet .. c
	end
	return true, strRet
end
function serviceFunctions.isResourceID(resId)
	local resId = tonumber(resId)
	if resId == gIDDef.FOOD or resId == gIDDef.WOOD or resId == gIDDef.IRON or resId == gIDDef.MITHRIL or resId == gIDDef.STEEL or resId == gIDDef.CRYSTAL or resId == gIDDef.METEOR_CRYSTAL or resId == gIDDef.LEGEND_CRYSTAL or resId == gIDDef.GILDED_CRYSTAL or resId == gIDDef.GILDED_CURE_ESSENCE then
		return true
	end
end
function serviceFunctions.isCanBuyResource(resId)
	local resId = tonumber(resId)
	if resId == gIDDef.FOOD or resId == gIDDef.WOOD or resId == gIDDef.IRON or resId == gIDDef.MITHRIL or resId == gIDDef.STEEL or resId == gIDDef.CRYSTAL then
		return true
	end
	return false
end
function serviceFunctions.getIntPart(x)
	local tmpCeilX = math.ceil(x)
	local offset = tmpCeilX - x
	if offset <= 1.0E-6 and -1.0E-6 <= offset then
		return tmpCeilX
	elseif 0 < offset then
		return tmpCeilX - 1
	else
		return tmpCeilX
	end
end
function serviceFunctions.getWeekTime(time, dayindex, nextweek)
	time = time or serviceFunctions.systemTime()
	local curIndex = serviceFunctions.getWeekDay(time)
	local endIndex = nextweek and 14 or 7
	for i = 1 - curIndex, endIndex - curIndex do
		local wIndex = serviceFunctions.getWeekDay(time + 86400 * i)
		if nextweek then
			if wIndex == 7 then
				nextweek = false
			end
		elseif wIndex == dayindex then
			return time + 86400 * i
		end
	end
end
function serviceFunctions.differDays(time1, time2)
	if not time1 then
		return
	end
	time2 = time2 or serviceFunctions.systemTime()
	if time1 > time2 then
		time1, time2 = time2, time1
	end
	local ret = serviceFunctions.isSameDay(time1, time2)
	if ret then
		return 0
	end
	local h = os.date("!%H", time2)
	local m = os.date("!%M", time2)
	local s = os.date("!%S", time2)
	local sec0 = time2 - (h * 3600 + m * 60 + s)
	local passSecond = sec0 - time1
	local secOfOneDay = 86400
	return math.ceil(passSecond / secOfOneDay)
end
function serviceFunctions.getTodayZeroHourUTC(time)
	time = time or serviceFunctions.systemTime()
	local h = tonumber(os.date("!%H", time))
	local m = tonumber(os.date("!%M", time))
	local s = tonumber(os.date("!%S", time))
	return time - (h * 3600 + m * 60 + s)
end
function serviceFunctions.getIDType(id_)
	if not id_ then
		return
	end
	local id = tonumber(id_)
	local left = 1
	local right = #ID_RANGE
	while left <= right do
		local mid = math.floor((right + left) / 2)
		local idRange = ID_RANGE[mid]
		if id >= idRange.START and id <= idRange.END then
			return idRange.IDTYPE
		elseif id < idRange.START then
			right = mid - 1
		elseif id > idRange.END then
			left = mid + 1
		end
	end
	Log.i("invalid id:", id_)
end
function serviceFunctions.bubbleSort(sortTable)
	if sortTable and next(sortTable) then
		local len = #sortTable
		local flag = true
		for i = 1, #sortTable do
			if flag then
				flag = false
				for j = 1, len - i do
					if sortTable[j] > sortTable[j + 1] then
						serviceFunctions.swapNum(sortTable, j, j + 1)
						flag = true
					end
				end
			end
		end
		return sortTable
	end
end
function serviceFunctions.swapNum(sortTable, i, j)
	local temp = tonumber(sortTable[i])
	sortTable[i] = tonumber(sortTable[j])
	sortTable[j] = temp
end
function serviceFunctions.setRandomSeed(num)
	math.randomseed(randomSeed)
end
function serviceFunctions.randomItem(params)
	if "table" ~= type(params) or 0 == #params then
		return
	end
	if not randomSeed then
		serviceFunctions.setRandomSeed()
	end
	local type, rates = serviceFunctions.setRandomSeed, serviceFunctions.setRandomSeed
	local curRate = 0
	local n = 10000
	for i, rate in ipairs(params) do
		curRate = curRate + rate
		rates[i] = curRate * n
	end
	n = rates[#rates]
	local ret = 0
	local random = math.random(1, n)
	for i, rateNum in ipairs(rates) do
		if rateNum >= random then
			ret = i
			break
		end
	end
	return ret
end
function serviceFunctions.transformArmyID(armyID, wlv)
	local oldArmyID = tonumber(armyID)
	if not oldArmyID then
		return armyID
	end
	local origArmyID = oldArmyID % 1000
	if wlv < 1 then
		return armyID
	end
	local newArmyID = 10000000 + (wlv - 1) * 1000 + origArmyID
	local armyltCtrl = include("armyltCtrl")
	if not armyltCtrl.isArmyID(newArmyID) then
		return armyID
	end
	Log.d(string.format("army log: serviceFunctions.transformArmyID  oldArmyID(%s) -> newArmyID(%s), wlv(%s)", tostring(armyID), tostring(newArmyID), tostring(wlv)))
	return newArmyID
end
function serviceFunctions.checkCondtion(condition)
	for i, v in ipairs(condition) do
		local condKey = v.condKey
		local condValue = v.condValue
		if gConditionType.ITEM == condKey then
		elseif gConditionType.VIP_LEVEL_AND_ACTIVE == condKey then
			local lordInfoCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("lordInfoCtrl")
			local vipInfo = lordInfoCtrl:getVip()
			local isActive = vipInfo and vipInfo[2]
			if not isActive then
				return false, condValue, condKey
			end
			local vipLevel = vipInfo and vipInfo[1]
			if not vipLevel or condValue > vipLevel then
				return false, condValue, condKey
			end
		elseif gConditionType.VIP_ACTIVE == condKey then
			local lordInfoCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("lordInfoCtrl")
			local vipInfo = lordInfoCtrl:getVip()
			local isActive = vipInfo and vipInfo[2]
			if not isActive then
				return false, condValue, condKey
			end
		elseif gConditionType.VIP_LEVEL == condKey then
			local lordInfoCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("lordInfoCtrl")
			local vipInfo = lordInfoCtrl:getVip()
			local vipLevel = vipInfo and vipInfo[1]
			if not vipLevel or condValue > vipLevel then
				return false, condValue, condKey
			end
		elseif gConditionType.CASTLE_LEVEL == condKey then
			local cityCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("cityCtrl")
			local castleLevel = cityCtrl:getCastleLevel()
			if not castleLevel or condValue > castleLevel then
				return false, condValue, condKey
			end
		elseif gConditionType.EXALTED_PRIVILEGE == condKey then
			local targetValue = v.targetValue
			local retVal, retList = SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(condValue)
			if retVal and targetValue <= retVal then
				return true
			else
				return false, condValue, condKey, targetValue
			end
		end
	end
	return true
end
function serviceFunctions.split(szFullString, szSeparator)
	local type, nSplitArray
	if type(szFullString) == "string" then
		local nFindStartIndex = 1
		local nSplitIndex = 1
		while true do
			local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
			if not nFindLastIndex then
				nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
				break
			end
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
			nFindStartIndex = nFindLastIndex + string.len(szSeparator)
			nSplitIndex = nSplitIndex + 1
		end
	end
	return nSplitArray
end
function serviceFunctions.getMapKey(x, y)
	return x * 10000 + y
end
function serviceFunctions.getPosFromMapKey(mapKey)
	return math.floor(mapKey / 10000), mapKey % 10000
end
function serviceFunctions.greaterThan0(value)
	if "number" == type(value) and 0 < value then
		return true
	end
	return false
end
function serviceFunctions.getArmyPercentData(armyList)
	local armyltCtrl = include("armyltCtrl")
	local _ENV, ret = "armyltCtrl", "armyltCtrl"
	local _ENV, result
	local totalNum = 0
	if type(armyList) == "table" then
		for k, v in pairs(armyList) do
			local armyID = v.id
			local armyNum = v.num
			if armyID and 0 < armyID and armyNum and 0 < armyNum then
				local armyType = armyltCtrl.armyAttr(armyID, ARMY_ATTR.ARMY_TYPE)
				if armyType and (1 <= armyType and armyType <= 8 or armyType == 13) then
					totalNum = totalNum + armyNum
					if ret[armyType] then
						ret[armyType] = ret[armyType] + armyNum
					else
						ret[armyType] = armyNum
					end
				end
			end
		end
		if 0 < totalNum then
			for k, v in pairs(ret) do
				result[k] = math.floor(v / totalNum * 100)
			end
		end
	end
	dump(result, "getArmyPercentData", 10)
	return result
end
function serviceFunctions.isExistSpecialSymbol(strIn)
	if not strIn then
		return false
	end
	local stringArr = serviceFunctions.convertStringToArray(strIn)
	_UPVALUE2_ = strIn
	strIn[1] = "\""
	local strIn[2], symbolConfig = "\\", strIn
	for k, v in pairs(stringArr) do
		for k1, v1 in pairs(symbolConfig) do
			if v == v1 then
				return true
			end
		end
	end
	return false
end
function serviceFunctions.tableComp(a, b, conds)
	for _, cond in ipairs(conds) do
		local key = cond[1]
		local sign = cond[2]
		local aValue = a[key] or 0
		local bValue = b[key] or 0
		if aValue ~= bValue then
			if sign == ">" then
				return aValue > bValue
			elseif sign == "<" then
				return aValue < bValue
			end
		end
	end
end
function serviceFunctions.tableMax(tab, conds)
	local maxValue, maxKey
	for k, v in pairs(tab) do
		if not maxValue or serviceFunctions.tableComp(v, maxValue, conds) then
			maxValue = v
			maxKey = k
		end
	end
	return maxValue, maxKey
end
function serviceFunctions.sort(list, conds)
	return table.sort(list, function(a, b)
		return serviceFunctions.tableComp(a, b, conds)
	end)
end
function serviceFunctions.addValueToArray(dest, temp, id, count)
	if id and count then
		local index = temp[id]
		if index then
			dest[index].count = dest[index].count + count
		else
			_ENV = nil
			;(nil).id = id
			;(nil).count = count
			table.insert(dest, nil)
			temp[id] = #dest
		end
	end
end
function serviceFunctions.getRandomReward(rewards, totalRate)
	if not totalRate then
		totalRate = 0
		for _, v in pairs(rewards) do
			totalRate = totalRate + v.rate
		end
	end
	if 0 < totalRate then
		local randNum = serviceFunctions.random(1, totalRate)
		local index = 1
		local curTotalRate = 0
		for _, v in pairs(rewards) do
			curTotalRate = curTotalRate + v.rate
			if randNum <= curTotalRate then
				_ENV = v.rate
				v.rate.id = v.id
				v.rate.count = v.count
				return v.rate, v.rate
			end
			index = index + 1
		end
	end
end
function serviceFunctions.random(min, max)
	if not randomSeed then
		serviceFunctions.setRandomSeed()
	end
	if "number" == type(min) and "number" == type(max) and min <= max then
		return math.random(min, max)
	else
		print("serviceFunctions.random min max", min, max, type(min), type(max))
		return 0
	end
end
return serviceFunctions
