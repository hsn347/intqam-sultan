local baseProxy = require("fgui.base.baseProxy")
local FootballSpiritProxy = class("FootballSpiritProxy", baseProxy)
function FootballSpiritProxy:onRegisterEvent()
	print("=======FootballSpiritProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FOOTBALL_ELF_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function FootballSpiritProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function FootballSpiritProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FOOTBALL_ELF_ACTIVITY) then
		self.view:close()
	end
end
return FootballSpiritProxy
