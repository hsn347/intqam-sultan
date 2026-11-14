local pyramidWarltCtrl = include("aAReadClass").new()
local channel = userSDKManager.getChannel()
local isInited = false
local init = function()
	if isInited then
		return
	end
	pyramidWarltCtrl.alliancewar_knockout_match, isInited = {}, {}
	pyramidWarltCtrl:defineValue("alliancewar_matchtime", function()
		pyramidWarltCtrl.alliancewar_matchtime, pyramidWarltCtrl = nil, nil
		local path = "app." .. LocalTblPath .. ".config_server."
		local alliancewar_matchtime
		if not IsArClient then
			alliancewar_matchtime = require_once(path .. "alliancewar_matchtime_en")
		else
			alliancewar_matchtime = require_once(path .. "alliancewar_matchtime_ar")
		end
		for k, v in pairs(alliancewar_matchtime) do
			pyramidWarltCtrl.alliancewar_matchtime[v.number] = v
		end
		return pyramidWarltCtrl.alliancewar_matchtime
	end)
	pyramidWarltCtrl:defineValue("matchTimeList", function()
		local _ENV, ret
		for number, v in pairs(pyramidWarltCtrl.alliancewar_matchtime) do
			_ENV = nil
			;(nil).week = v.starttime[1]
			;(nil).hour = v.starttime[2] < 10 and "0" .. v.starttime[2] or v.starttime[2]
			;(nil).min = 10 > v.starttime[3] and "0" .. v.starttime[3] or v.starttime[3]
			local _ENV, (nil).sec, starttime = 10 > v.starttime[4] and "0" .. v.starttime[4] or v.starttime[4], 10 > v.starttime[4] and "0" .. v.starttime[4] or v.starttime[4], nil
			;(10 > v.starttime[4] and "0" .. v.starttime[4] or v.starttime[4]).week = v.endtime[1]
			;(10 > v.starttime[4] and "0" .. v.starttime[4] or v.starttime[4]).hour = 10 > v.endtime[2] and "0" .. v.endtime[2] or v.endtime[2]
			;(10 > v.starttime[4] and "0" .. v.starttime[4] or v.starttime[4]).min = 10 > v.endtime[3] and "0" .. v.endtime[3] or v.endtime[3]
			local _ENV, (10 > v.starttime[4] and "0" .. v.starttime[4] or v.starttime[4]).sec, endtime = 10 > v.endtime[4] and "0" .. v.endtime[4] or v.endtime[4], 10 > v.endtime[4] and "0" .. v.endtime[4] or v.endtime[4], 10 > v.starttime[4] and "0" .. v.starttime[4] or v.starttime[4]
			;(10 > v.endtime[4] and "0" .. v.endtime[4] or v.endtime[4]).number = number
			;(10 > v.endtime[4] and "0" .. v.endtime[4] or v.endtime[4]).starttime = starttime
			;(10 > v.endtime[4] and "0" .. v.endtime[4] or v.endtime[4]).endtime = endtime
			ret[number], (10 > v.endtime[4] and "0" .. v.endtime[4] or v.endtime[4]).type = 10 > v.endtime[4] and "0" .. v.endtime[4] or v.endtime[4], v.type
		end
		return ret
	end)
end
init()
function pyramidWarltCtrl.getGroupName(group)
	local ret = ""
	_ENV = nil
	;(nil)[1] = i18n("pyramid_btn_12")
	;(nil)[2] = i18n("pyramid_btn_13")
	local (nil)[3], data = i18n("pyramid_btn_14"), nil
	if data[group] then
		ret = data[group]
	end
	return ret
end
function pyramidWarltCtrl.getWeedTimeStr(number, nextweek, otherStr)
	otherStr = otherStr or " "
	local timedata = pyramidWarltCtrl.getMatchtimeList()[number]
	if timedata then
		local yearstr = SoraDConvertTimeToYear(serviceFunctions.getWeekTime(nil, timedata.starttime.week, nextweek))
		yearstr = yearstr .. otherStr .. timedata.starttime.hour .. ":" .. timedata.starttime.min .. ":" .. timedata.starttime.sec .. " -- " .. timedata.endtime.hour .. ":" .. timedata.endtime.min .. ":" .. timedata.endtime.sec
		return yearstr
	else
		return ""
	end
end
function pyramidWarltCtrl.getWeedTimeStrByData(data, otherStr)
	otherStr = otherStr or " "
	local number = data.number
	local timestr = pyramidWarltCtrl.getMatchtimeList()[number]
	local timedata = data.queue[tostring(gPinnacleSeasonAllianceState.APPLY_ED)] or data.queue[tostring(gRegularSeasonAllianceState.APPLY_ED)]
	local yearTime
	if timedata and timedata.data and timedata.data.finalBeginTime then
		yearTime = timedata.data.finalBeginTime
	else
		timedata = data.queue[tostring(gPinnacleSeasonAllianceState.PREPARE)] or data.queue[tostring(gRegularSeasonAllianceState.PREPARE)]
		if timedata and timedata.starttime then
			yearTime = timedata.starttime + timedata.totaltime
		else
			timedata = data.queue[tostring(gPinnacleSeasonAllianceState.RUNNING)] or data.queue[tostring(gRegularSeasonAllianceState.RUNNING)]
			if timedata and timedata.starttime then
				yearTime = timedata.starttime
			end
		end
	end
	if yearTime and timestr then
		local yearstr = os.date("!%Y-%m-%d", yearTime)
		yearstr = yearstr .. otherStr .. timestr.starttime.hour .. ":" .. timestr.starttime.min .. ":" .. timestr.starttime.sec .. " -- " .. timestr.endtime.hour .. ":" .. timestr.endtime.min .. ":" .. timestr.endtime.sec
		return yearstr
	else
		return ""
	end
end
function pyramidWarltCtrl.getMatchtimeList()
	return pyramidWarltCtrl.matchTimeList
end
function pyramidWarltCtrl.checkPwXianXiaSai(notNotice)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	if pyramidWarCtrl:getPwXianXiaSaiStatus() == 2 then
		if not notNotice then
			if pyramidWarCtrl:getIsInPwXianXiaSai() then
				SoraDShowMsgTip(i18n("worldwar_text_16"))
			else
				SoraDShowMsgTip(i18n("offline_text_03"))
			end
		end
		SoraDCloseLoading(nil, nil, true)
		return false
	else
		return true
	end
end
return pyramidWarltCtrl
