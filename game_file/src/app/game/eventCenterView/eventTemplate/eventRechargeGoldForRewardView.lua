local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventRechargeGoldForRewardView = class("eventRechargeGoldForRewardView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventRechargeGoldForRewardView")
	end
	return target
end)
function eventRechargeGoldForRewardView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_rechargeGold")
	self.nodeTitle:setTitle(i18n("activity_name_9001075_ROS"))
	self.nodeTitle:setBtnHelpClickCallBack(handler(self, self.helpClickCallBack))
	self.Image_1 = SoraDGetChildByName(self, "Image_1")
	self.Image_1:loadTexture(SoraDCheckPNG("bg_activity_show_9001075.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.Top_Text_des = SoraDGetChildByName(self, "Top_Text_des")
	self.Top_Text_des:setString(i18n("activity_des1_9001075_ROS"))
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_name = SoraDCreateTimerLabel(self, self.Text_name)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("eventRechargeGoldForRewardSingle")
	self.btn_goStore = SoraDGetChildByName(self, "btn_goStore")
	self.btn_goStore:setTitleText(i18n("activity_btn_9001075_ROS"))
	SoraDAutoSizeButtonText(self.btn_goStore, cc.size(210, 68))
	self.btn_goStore:addTouchEventListener(handler(self, self.goStoreCallBack))
	self:suitView()
	self:initTime()
	self:initData()
end
function eventRechargeGoldForRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_GOLD_FOR_REWARD_REFRESH", handler(self, self.initData))
end
function eventRechargeGoldForRewardView:initTime()
	local rechargeTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RECHARGE_GOLD_FOR_REWARD)
	if rechargeTime then
		self.Text_name:setTimeLast(function(str)
			_ENV = nil
			;(nil).time = str
			return i18n("common_text_607", nil)
		end)
		self.Text_name:beginTime(rechargeTime.timerNode.timer:getRemainTime())
		self.Text_name:setTimeEndListener(function(...)
			self:removeFromParent()
		end)
	end
end
function eventRechargeGoldForRewardView:suitView()
	self.scroll:setContentSize(cc.size(640, display.height - 488))
end
function eventRechargeGoldForRewardView:initData(target, data)
	SoraDCloseLoading(self)
	self.rewardList = activityShowCtrl:getRechargeGoldForReward()
	_ENV = nil
	;(nil).view = self
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 170), self.rewardList, 1, nil)
end
function eventRechargeGoldForRewardView:goStoreCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function eventRechargeGoldForRewardView:helpClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "activity_des2_9001075_ROS"
		;("activity_des2_9001075_ROS").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("activity_des2_9001075_ROS"), "activity_des2_9001075_ROS")
	end
end
function eventRechargeGoldForRewardView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RECHARGE_GOLD_FOR_REWARD) then
		self:removeFromParent()
	end
end
return eventRechargeGoldForRewardView
