local baseProxy = require("fgui.base.baseProxy")
local WorldKingdomLvProxy = class("WorldKingdomLvProxy", baseProxy)
function WorldKingdomLvProxy:onRegisterEvent()
	print("=======WorldKingdomLvProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLDKINGDOM_LV_DATA_BACK", handler(self, self.msgDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
end
function WorldKingdomLvProxy:msgDataBack(target, data)
	dump(data, "返回数据-----------")
	print("worldKingdomLvView:msgDataBack")
	SoraDCloseLoading(self.view)
	self.view:updateLevelInfo(data.data)
end
function WorldKingdomLvProxy:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID and type(data.activityID) == "table" then
		for i, v in ipairs(data.activityID) do
			if tonumber(v) == gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY then
				local activityState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY)
				print("activityState = ", activityState)
				if activityState == gActivityState.CLOSE then
					self.view:removeFromParent()
				end
				break
			end
		end
	end
end
return WorldKingdomLvProxy
