local baseProxy = require("fgui.base.baseProxy")
local activity_9001649_Ctrl = SoraDGetCtrl("activity_9001649_Ctrl")
local Activity_9001649_MainProxy = class("Activity_9001649_MainProxy", baseProxy)
function Activity_9001649_MainProxy:onRegisterEvent()
	print("=======Activity_9001649_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001649_UPDATE", handler(self, self.msgRefreshView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgRefreshItemNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_LAST_FINISH", handler(self, self.msgGuideEnd))
end
function Activity_9001649_MainProxy:msgGuideEnd(target, data)
	if data.step == 9991104 then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:Activity_9001649_MainPanel:guide~bool", true, nil)
	end
end
function Activity_9001649_MainProxy:msgRefreshView(target, data)
	SoraDCloseLoading(self.view)
	if data.subMsg == "init" then
		self.view:updateView()
	elseif data.subMsg == "one" or data.subMsg == "all" then
		self.view:updateStageButton()
		self.view:updateButton()
		local isAll = data.subMsg == "all"
		if isAll or next(activity_9001649_Ctrl:getMineData()) == nil then
			print("Activity_9001649_MainProxy 重置了")
			self.view:updateGameUI()
		elseif not isAll then
			self.view:startNext()
		end
		self.view:showGetRewards(data.reward, isAll)
	elseif data.subMsg == "stage" then
		self.view:updateStageButton()
	elseif data.subMsg == "error" then
		self.view:updateView()
	end
end
function Activity_9001649_MainProxy:msgRefreshItemNum(target, data)
	self.view:updateButton()
end
function Activity_9001649_MainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001649_MainProxy
