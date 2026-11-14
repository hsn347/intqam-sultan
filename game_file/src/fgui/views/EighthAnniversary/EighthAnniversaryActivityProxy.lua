local baseProxy = require("fgui.base.baseProxy")
local EighthAnniversaryActivityProxy = class("EighthAnniversaryActivityProxy", baseProxy)
function EighthAnniversaryActivityProxy:onRegisterEvent()
	print("=======EighthAnniversaryActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function EighthAnniversaryActivityProxy:judgeClose(target, data)
	if data == nil or data.activityID == nil then
		return
	end
	if tolua.type(data.activityID) == "table" then
		for i, v in ipairs(self.view.showConfig) do
			for j, k in ipairs(data.activityID) do
				if v.activityID == k then
					self.view:initData()
					return
				end
			end
		end
	else
		for i, v in ipairs(self.view.showConfig) do
			if v.activityID == data.activityID then
				self.view:initData()
				return
			end
		end
	end
end
return EighthAnniversaryActivityProxy
