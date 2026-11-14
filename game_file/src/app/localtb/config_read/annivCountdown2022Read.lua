local annivCountdown2022Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "anniversary_2022"
;(nil)[2] = true
annivCountdown2022Read:defineValue("anniversary_2022", nil)
_UPVALUE2_ = nil
;(nil)[1] = "anniversary_2022_sign_in"
;(nil)[2] = true
annivCountdown2022Read:defineValue("anniversary_2022_sign_in", nil)
function annivCountdown2022Read.getSignCfg()
	local _ENV, data
	for i, v in ipairs(annivCountdown2022Read.anniversary_2022_sign_in) do
		if v.type == 1 then
			table.insert(data, v)
		end
	end
	return data
end
function annivCountdown2022Read.getBigRewardCfg()
	for i, v in ipairs(annivCountdown2022Read.anniversary_2022_sign_in) do
		if v.type == 2 then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(annivCountdown2022Read.anniversary_2022_sign_in)
end
function annivCountdown2022Read.getCountDownConfig()
	return annivCountdown2022Read.anniversary_2022[1]
end
function annivCountdown2022Read.getRewardConfigByDay(day)
	return annivCountdown2022Read.anniversary_2022_sign_in[day]
end
return annivCountdown2022Read
