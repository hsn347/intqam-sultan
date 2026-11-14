local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseProxy = require("fgui.base.baseProxy")
local ShiftingstarsProxy = class("ShiftingstarsProxy", baseProxy)
function ShiftingstarsProxy:onRegisterEvent()
	print("=======ShiftingstarsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.setNewByActID))
	SoraDAddMessage(self, "MESSAGE_SHIFTING_STARS_REFRESH", handler(self, self.updateView))
end
function ShiftingstarsProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY) then
		self.view:close()
		return
	end
	if data == nil or data.activityID == nil then
		return
	end
	local actConfig = activityShowCtrl:getParamByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY).showConfig
	if tolua.type(data.activityID) == "table" then
		for i, v in ipairs(actConfig) do
			for j, k in ipairs(data.activityID) do
				if v.activityID == k then
					self.view:initData()
					return
				end
			end
		end
	else
		for i, v in ipairs(actConfig) do
			if v.activityID == data.activityID then
				self.view:initData()
				return
			end
		end
	end
end
function ShiftingstarsProxy:setNewByActID(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY) then
		self.view:close()
		return
	end
	if data == nil or data.eid == nil then
		return
	end
	local actConfig = activityShowCtrl:getParamByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY).showConfig
	for i, v in ipairs(actConfig) do
		if v.activityID == data.eid then
			self.view:setNewByActID(v.activityID)
			return
		end
	end
end
function ShiftingstarsProxy:updateView(target, data)
	if self and self.view then
		self.view:initData()
	end
end
return ShiftingstarsProxy
