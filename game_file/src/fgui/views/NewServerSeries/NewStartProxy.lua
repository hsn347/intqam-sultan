local baseProxy = require("fgui.base.baseProxy")
local NewStartProxy = class("NewStartProxy", baseProxy)
function NewStartProxy:onRegisterEvent()
	print("=======NewStartProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEW_START_INITOLD_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_NEW_START_CODE_REFRESH", handler(self, self.refreshCode))
end
function NewStartProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NewStartProxy:refreshView(target, event)
	self.view:refreshView(target, event)
end
function NewStartProxy:refreshCode(target, event)
	self.view:refreshCode(target, event)
end
function NewStartProxy:getInheritRewardGross(dollors)
	local newstart_inherit = require_data("newstart_inherit", true).data
	local num = 0
	for i, v in ipairs(newstart_inherit) do
		if dollors >= v.inheritGears[1] and dollors <= v.inheritGears[2] then
			num = v.rewardGross[1]
			break
		end
	end
	if num == 0 then
		local data = newstart_inherit[#newstart_inherit]
		if dollors > data.inheritGears[1] then
			num = data.rewardGross[1]
		end
	end
	return num
end
return NewStartProxy
