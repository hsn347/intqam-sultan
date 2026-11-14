local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local preciousTreasurePopView = class("preciousTreasurePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("preciousTreasurePopView")
	end
	return target
end)
function preciousTreasurePopView:ctor()
	self.activityID = gActivityTimeActivityID.PRECIOUS_TREASURE_ACTIVITY
	self:initWidget()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		if not clientEventMgr.judgeIsOpen(self.activityID) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
end
function preciousTreasurePopView:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	SoraDCreatAnimation(self.__cname, self._ccsView, true)
	self.Text_title:setString(i18n("activity_name_9001272"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		return i18n("common_text_2669") .. ticket
	end)
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if self.eventTime then
		self.Text_time:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	self.Text_des:setString(i18n("preciouss_treasures_text_01"))
	self.Button_dig:setTitleText(i18n("preciouss_treasures_text_03"))
	self.Button_dig:addTouchEventListener(handler(self, self.btnDigCallback))
	SoraDAutoSizeButtonTextByContent(self.Button_dig)
	self.Button_go:setTitleText(i18n("preciouss_treasures_text_02"))
	self.Button_go:addTouchEventListener(handler(self, self.btnGoCallback))
	SoraDAutoSizeButtonTextByContent(self.Button_go)
	self.Button_buy:setTitleText(i18n("endless_treasures_text_47"))
	self.Button_buy:addTouchEventListener(handler(self, self.btnBuyCallback))
	SoraDAutoSizeButtonTextByContent(self.Button_buy)
end
function preciousTreasurePopView:initData()
end
function preciousTreasurePopView:btnDigCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local unlockLv = include("funUnlockRead").getUnlockLevel(gFunBuildKey.ENDLESS_TREASURE)
		if unlockLv > SoraDGetCastleLv() then
			_ENV = nil
			;(nil).name = i18n("endless_treasures_text_01")
			;(nil).lv = unlockLv
			SoraDShowMsgTip(i18n("common_text_2122", nil))
		elseif self:checkBuildExist() then
			SoraDRemoveAllPanelFromManager()
			uiManager:show("EndlessTreasureView")
		else
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function preciousTreasurePopView:btnGoCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self:checkBuildExist() then
			SoraDRemoveAllPanelFromManager()
			uiManager:show("TreasureHuntView")
		else
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function preciousTreasurePopView:checkBuildExist()
	if #cityCtrl:getBuildCellList(BUILDID.WISHING_WELL) > 0 then
		return true
	else
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		cityCtrl = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, nil)
		return false
	end
end
function preciousTreasurePopView:btnBuyCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_UPVALUE4_ = SoraDPlaySound
		SoraDPlaySound[1] = 13934
		SoraDPlaySound[2] = 13935
		SoraDPlaySound[3] = 13936
		local SoraDPlaySound[4], giftArray = 13937, SoraDPlaySound
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = 13937
			;(13937).rechargeIDList = giftArray
			uiManager:show("rechargeView", 13937)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, giftArray)
			panel:show()
		end
	end
end
return preciousTreasurePopView
