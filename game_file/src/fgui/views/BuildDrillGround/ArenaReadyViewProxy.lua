local baseProxy = require("fgui.base.baseProxy")
local ArenaReadyViewProxy = class("ArenaReadyViewProxy", baseProxy)
function ArenaReadyViewProxy:onRegisterEvent()
	print("=======ArenaReadyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_GLOBALCHANGE", handler(self.view, self.view.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_MYINFOCHANGE", handler(self.view, self.view.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_GROUPCHANGE", handler(self.view, self.view.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_TIPCHANGE", handler(self.view, self.view.initTipIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", function(target, data)
		self.view:refreshTabBtn()
		SoraDCloseLoading(self.view:displayObject())
		if not data.name or data.name ~= "remind" then
			self.view:initExchangeData()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function(target, data)
		SoraDCloseLoading(self.view:displayObject())
	end)
end
function ArenaReadyViewProxy:judgeClose(target, redata)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ARENA_ACTIVITY) then
		_ENV = gActivityTimeActivityID.ARENA_ACTIVITY
		gActivityTimeActivityID.ARENA_ACTIVITY.msg = "MESSAGE_MAINCITYVIEW_REMOVE_DRILL_ARENA_TOP_TIP"
		SoraDSendMessage(gActivityTimeActivityID.ARENA_ACTIVITY)
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return ArenaReadyViewProxy
