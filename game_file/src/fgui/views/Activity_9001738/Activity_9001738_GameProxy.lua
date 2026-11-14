local baseProxy = require("fgui.base.baseProxy")
local Activity_9001738_GameProxy = class("Activity_9001738_GameProxy", baseProxy)
function Activity_9001738_GameProxy:onRegisterEvent()
	print("=======Activity_9001738_GameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_CARD", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_USE_ITEM", handler(self, self.onUpdateView))
end
local getUpdateSource = function(data)
	if not data then
		return "update"
	end
	if data.msg == "MESSAGE_ACTIVITY_9001738_CARD" or data.subMsg == "card" then
		return "card"
	end
	if data.msg == "MESSAGE_ACTIVITY_9001738_USE_ITEM" or data.subMsg == "useItem" then
		return "useItem"
	end
	return "update"
end
local isDuplicateActionUpdate = function(data)
	if not data or data.msg ~= "MESSAGE_ACTIVITY_9001738_UPDATE" then
		return false
	end
	return data.subMsg == "card" or data.subMsg == "useItem"
end
function Activity_9001738_GameProxy:onUpdateView(target, data)
	if isDuplicateActionUpdate(data) then
		return
	end
	if self.view and self.view.updateView then
		isDuplicateActionUpdate = nil
		;(nil).source = getUpdateSource(data)
		;(nil).eventData = data
		self.view:updateView(nil)
	end
end
return Activity_9001738_GameProxy
