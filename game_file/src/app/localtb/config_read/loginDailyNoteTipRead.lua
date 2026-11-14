local LoginDailyNoteTipRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	LoginDailyNoteTipRead = nil
	;(nil)[1] = "login_tips"
	LoginDailyNoteTipRead:defineValue("readTableData", nil)
end
init()
function LoginDailyNoteTipRead.getCounts()
	return #LoginDailyNoteTipRead.readTableData
end
function LoginDailyNoteTipRead.getTip(id)
	return i18n(LoginDailyNoteTipRead.readTableData[id].tips)
end
return LoginDailyNoteTipRead
