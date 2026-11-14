local baseProxy = require("fgui.base.baseProxy")
local AnnivColossusActivityProxy = class("AnnivColossusActivityProxy", baseProxy)
function AnnivColossusActivityProxy:onRegisterEvent()
	print("=======AnnivColossusActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ANNIV_COLOSSUS_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ANNIV_COLOSSUS_BUILD", handler(self, self.onBuild))
	SoraDAddMessage(self, "MESSAGE_ANNIV_COLOSSUS_GET_REWARD", handler(self, self.onGetReward))
	SoraDAddMessage(self, "MESSAGE_ANNIV_COLOSSUS_TOTAL_SCORE", handler(self, self.onGetScore))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onUpdateView))
end
function AnnivColossusActivityProxy:onUpdateView(target, data)
	self.view:updateView()
end
function AnnivColossusActivityProxy:onBuild(target, data)
	self.view:updateView()
end
function AnnivColossusActivityProxy:onGetReward(target, data)
	self.view:updateView()
end
function AnnivColossusActivityProxy:onGetScore(target, data)
	self.view:updateView()
end
function AnnivColossusActivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY) then
		self.view:close()
	end
end
return AnnivColossusActivityProxy
