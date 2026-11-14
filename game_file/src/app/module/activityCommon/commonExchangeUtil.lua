local newExchangeMallRead = include("newExchangeMallRead")
local activityExchangeMallRead = include("activityExchangeMallRead")
local _ENV, commonExchangeUtil = "activityExchangeMallRead", "activityExchangeMallRead"
function commonExchangeUtil.openView(activityID)
	if newExchangeMallRead.getExchangeConfig(activityID) then
		newExchangeMallRead = nil
		;(nil).id = activityID
		uiManager:show("ExchangeEventPage", nil)
		return
	end
	if activityExchangeMallRead.getExchangeConfig(activityID) then
		newExchangeMallRead = nil
		;(nil).id = activityID
		uiManager:show("ActExchangePageNew", nil)
		return
	end
end
return commonExchangeUtil
