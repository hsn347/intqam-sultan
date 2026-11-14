local dailyLoginRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "daily_login_reward"
;(nil)[2] = true
dailyLoginRead:defineValue("dailyLoginCfg", nil)
dailyLoginRead.data, _ENV = dailyLoginRead.defineValue, dailyLoginRead.defineValue
_UPVALUE1_ = nil
;(nil)[1] = "loginwindow"
dailyLoginRead:defineValue("loginwindow", nil)
dailyLoginRead:defineValue("popCfg", function()
	local _ENV, popCfg
	for i, v in ipairs(dailyLoginRead.loginwindow) do
		if popCfg[v.uiDequeType] == nil then
			popCfg[v.uiDequeType], _ENV = nil, nil
		end
		table.insert(popCfg[v.uiDequeType], v)
	end
	for k, v in pairs(popCfg) do
		table.sort(v, function(a, b)
			return a.priority < b.priority
		end)
	end
	return popCfg
end)
function dailyLoginRead.init(rewardType)
	local rewardKey = ""
	if rewardType == 0 then
		rewardKey = "reward0"
	elseif rewardType == 1 then
		rewardKey = "reward1"
	else
		rewardKey = "reward2"
	end
	for i, v in ipairs(dailyLoginRead.dailyLoginCfg) do
		local reward = v[rewardKey]
		_ENV = nil
		;(nil).day = v.day
		;(nil).extraShow = v.extraShow
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		dailyLoginRead.data[v.day], (nil).reward = nil, serviceFunctions.tableFormat(reward, nil)
	end
end
function dailyLoginRead.getLoginAward()
	return dailyLoginRead.data
end
function dailyLoginRead.getLoginAwardByDay(day)
	return dailyLoginRead.data[day]
end
function dailyLoginRead.getMaxDay()
	return #dailyLoginRead.data
end
function dailyLoginRead.getNextShow(day)
	local showData
	for i = day, #dailyLoginRead.data do
		if dailyLoginRead.data[i].extraShow == 1 then
			showData = dailyLoginRead.data[i]
			break
		end
	end
	return showData or dailyLoginRead.data[#dailyLoginRead.data]
end
function dailyLoginRead.getNextShowNew(day)
	local showData
	for i = day, #dailyLoginRead.dailyLoginCfg do
		local data = dailyLoginRead.dailyLoginCfg[i]
		if data.extraShow == 1 then
			dailyLoginRead, reward = data.reward1, data.reward1
			data.reward1.day = data.day
			data.reward1.extraShow = data.extraShow
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			showData, data.reward1.reward = data.reward1, serviceFunctions.tableFormat(reward, nil)
			break
		end
	end
	return showData or dailyLoginRead.data[#dailyLoginRead.data]
end
function dailyLoginRead.getPopCfg()
	return dailyLoginRead.popCfg
end
return dailyLoginRead
