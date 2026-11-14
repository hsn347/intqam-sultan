local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rebateMoreView = class("rebateMoreView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rebateMoreView")
	end
	return target
end)
function rebateMoreView:ctor()
	self.activityID = gActivityTimeActivityID.NEW_RECHARGE_GOLD_FOR_REWARD
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle"):setTitle(i18n("activity_name_9001309"))
	SoraDGetChildByName(self, "btn_FAQ"):addTouchEventListener(handler(self, self.clickFAQBtn))
	self.Text_ps = SoraDGetChildByName(self, "Text_ps")
	self.Text_ps:setString(i18n("rebate_many_text_05"))
	self.Text_lefttime = SoraDGetChildByName(self, "Text_lefttime")
	self.scroll = SoraDGetChildByName(self, "Bottom_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("rebateMoreTaskSingle")
	self.Bottom_Node_cover_l = SoraDGetChildByName(self, "Bottom_Node_cover_l")
	self.Bottom_Node_cover_r = SoraDGetChildByName(self, "Bottom_Node_cover_r")
	self.img_l = SoraDGetChildByName(self.Bottom_Node_cover_l, "Top_Size_Left")
	self.img_r = SoraDGetChildByName(self.Bottom_Node_cover_r, "Top_Size_Left")
	self.Bottom_Button_buy = SoraDGetChildByName(self, "Bottom_Button_buy")
	self.Bottom_Button_buy:addTouchEventListener(handler(self, self.clickGoBtn))
	self.Bottom_Button_buy:setTitleText(i18n("activity_btn_9001075_ROS"))
	self:suitView()
	self:initTime()
	self:initData()
end
function rebateMoreView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_GOLD_FOR_REWARD_REFRESH", handler(self, self.initData))
end
function rebateMoreView:initTime()
	local rechargeTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_RECHARGE_GOLD_FOR_REWARD)
	self.text_time = SoraDCreateTimerLabel(self, self.Text_lefttime)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	dump(timer)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.text_time:setString(SoraDConvertSecondToString(leftTime))
		self.text_time:beginTime(leftTime)
	end
end
function rebateMoreView:suitView()
	self.scroll:setContentSize(cc.size(640, display.height - 545))
	self.img_l:setContentSize(cc.size(13, display.height - 300))
	self.img_r:setContentSize(cc.size(13, display.height - 300))
end
function rebateMoreView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("rebate_many_text_01"))
	end
end
function rebateMoreView:clickGoBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function rebateMoreView:initData(target, data)
	SoraDCloseLoading(self)
	self.rewardList = activityShowCtrl:getRebateMore()
	_ENV = nil
	;(nil).view = self
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 152), self.rewardList, 1, nil)
end
function rebateMoreView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_RECHARGE_GOLD_FOR_REWARD) then
		self:removeFromParent()
	end
end
return rebateMoreView
