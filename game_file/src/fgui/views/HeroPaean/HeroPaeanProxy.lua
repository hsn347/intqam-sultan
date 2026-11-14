local baseProxy = require("fgui.base.baseProxy")
local HeroPaeanProxy = class("HeroPaeanProxy", baseProxy)
function HeroPaeanProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_HERO_PEAEAN_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function HeroPaeanProxy:refreshView(target, data)
	if self.view then
		dump(data, "HeroPaeanProxy:refreshV")
		local subMsg = data.subMsg
		if subMsg then
			if subMsg == "init" then
				self.view:initData()
			elseif subMsg == "refresh" then
				self.view:initPage()
			end
		end
	end
end
function HeroPaeanProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_PAEAN_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return HeroPaeanProxy
