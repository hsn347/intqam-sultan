local baseProxy = require("fgui.base.baseProxy")
local CaveExploreActivityProxy = class("CaveExploreActivityProxy", baseProxy)
function CaveExploreActivityProxy:onRegisterEvent()
	print("=======CaveExploreActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_CAVE_EXPLORE", handler(self, self.onExplore))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ANIMATION_GAIN_ITEM_CLOSE", handler(self, self.hideBackGround))
	SoraDAddMessage(self, "MESSAGE_ANIMATION_GAIN_ITEM_SHOW", handler(self, self.showBackGround))
	SoraDAddMessage(self, "MESSAGE_CAVE_EXPLORE_REWARD_CLOSE", handler(self, self.onRewardClose))
	self.animationGainItemShowingCount = 0
end
function CaveExploreActivityProxy:onExplore(target, data)
	self.view:showReward(data.rewards)
	self.view:updateView()
end
function CaveExploreActivityProxy:onUpdateView(target, data)
	self.view:updateView()
end
function CaveExploreActivityProxy:hideBackGround(target, data)
	self.animationGainItemShowingCount = self.animationGainItemShowingCount - 1
	if self.animationGainItemShowingCount <= 0 then
		self.view:setIsBlcakBgShow(false)
		self.view:playLoopSound()
	end
end
function CaveExploreActivityProxy:showBackGround(target, data)
	self.animationGainItemShowingCount = self.animationGainItemShowingCount + 1
	self.view:setIsBlcakBgShow(true)
end
function CaveExploreActivityProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY) then
		self.view:close()
	end
end
function CaveExploreActivityProxy:onRewardClose()
	self.view:playLoopSound()
end
return CaveExploreActivityProxy
