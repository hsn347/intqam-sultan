local baseProxy = require("fgui.base.baseProxy")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001628_Ctrl = SoraDGetCtrl("activity_9001628_Ctrl")
local Activity_9001628_ViewProxy = class("Activity_9001628_ViewProxy", baseProxy)
function Activity_9001628_ViewProxy:onRegisterEvent()
	print("=======Activity_9001628_ViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_INIT_BACK", function(target, data)
		SoraDCloseLoading(self.view)
		self.view:initData()
		self.view.curGrid = activity_9001628_Ctrl:getCurGrid()
		self.view.oldGrid = activity_9001628_Ctrl:getCurGrid()
		self.view.mapSize = activity_9001628_Ctrl:getMapSize()
		self.view.isMerchantGrid = activity_9001628_Ctrl:isMerchantGrid()
		local curNode = self.view.tableNode[self.view.curGrid]
		print("self.view.curGrid======", self.view.curGrid)
		self.view:initCammelAnimation(curNode:getPositionX(), curNode:getPositionY(), 1)
		self.view:initMapObjects()
		if self.view.isMerchantGrid and not activity_9001628_Ctrl:isAllPackageBought() then
			uiManager:show("Activity_9001628_Pop")
			self.view:updateShopBtn()
		end
		self.view:refreshRedPoint()
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_THROW_DICE", function(target, data)
		SoraDCloseLoading(self.view)
		if self.view.mapInfo == nil or next(self.view.mapInfo) == nil then
			return
		end
		if data.err == gErrDef.Err_None then
			SoraDShowLoading(self.view, nil, nil, true)
			self.view.stepSet = activity_9001628_Ctrl:getCastDataStepSet()
			self.view.multiple = activity_9001628_Ctrl:getMultipleForAmazing()
			if self.view.stepSet then
				self.view.diceCount = (self.view.stepSet[1].curMapIndex - self.view.oldGrid) % self.view.mapSize or 0
			end
			if not self.view.isSkip then
				self.view:startThrowDiceAnimation()
			else
				self.view:stopThrowDiceAnimationShowCount(self.view.diceCount)
				self.view:runCammelToTargetGrid(self.view.stepSet)
			end
		elseif self.view.isSkip then
			self.view:initCammelAnimation()
		end
		self.view:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_DICE_COUNT", function(target, data)
		SoraDCloseLoading(self.view)
		self.view:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_CANCEL_BUY_PACKAGE", function(target, data)
		SoraDCloseLoading(self.view)
		self.view:initData()
		if self.view.isSkip then
			self.view:initCammelAnimation()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_GET_REWARD_BACK", function(target, data)
		self.view:refreshRedPoint()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_COMMON_ICON_TIP", function()
		self.view:onEventTouchEnd()
	end)
	SoraDAddMessage(self, "MESSAGE_ANNIVERSARY_TREASURE_HUNT_BUY_PACKAGE", function(target, data)
		self.view:refreshGiftBtn()
	end)
end
function Activity_9001628_ViewProxy:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001628_ViewProxy
