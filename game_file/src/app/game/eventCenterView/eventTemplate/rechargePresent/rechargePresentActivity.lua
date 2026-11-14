local rechargePresentUtil = include("rechargePresentUtil")
local rechargePresentActivity = class("rechargePresentActivity", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargePresentActivity")
	end
	return target
end)
function rechargePresentActivity:ctor()
	self.activityID = gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT
	self.txtTitle = SoraDGetChildByName(self, "Text_Title")
	self.txtExplain = SoraDGetChildByName(self, "Text_Explain")
	self.btnGo = SoraDGetChildByName(self, "btn_go")
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self.btnGo:getTitleRenderer():setPositionY(32)
	self.nodeTime = SoraDGetChildByName(self, "Node_Time")
	self.textActivityTime = SoraDGetChildByName(self.nodeTime, "text_time")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.txtTitle:setString(i18n("activity_name_9001316"))
	self.txtExplain = SoraDCreateTimerLabel(self, self.txtExplain)
	SoraDCreatAnimation(self.__cname, self)
	local node = SoraDGetChildByName(self, "Node_1")
	_G.SoraDSetParticleAutoCull(node:getChildren(), false)
	self.nodePoint = SoraDGetChildByName(self, "Node_point")
	self.txtPointAdd = SoraDGetChildByName(self, "Text_point_add")
	self.txtPointTitle = SoraDGetChildByName(self, "Text_point_title")
	self.txtPointTitle:setString(i18n("sheepFeed_text_10"))
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	if IsArClient then
		self.Button_help:addTouchEventListener(handler(self, self.onClick_Button_help))
	else
		self.Button_help:setVisible(false)
	end
	self:initActivityTime()
	self:updateePresentGold()
end
function rechargePresentActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH", handler(self, self.updateePresentGold))
end
function rechargePresentActivity:initActivityTime()
	self.textActivityTime:setTimeLast(function(ticket)
		return ticket
	end)
	do
		local eventTime = rechargePresentUtil.getActivityLeftTime()
		if eventTime and 0 < eventTime then
			self.textActivityTime:beginTime(eventTime)
		end
	end
	do
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		self.txtExplain:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("sudanGift_text_01", nil)
		end)
		if eventTime then
			self.txtExplain:beginTime(eventTime.timerNode.timer:getRemainTime())
		end
	end
	SoraDToCenter(self.nodeTime, 2, SoraDFIsRA())
end
function rechargePresentActivity:updateePresentGold()
	local gametop = gModuleMgr.getObject("gametop")
	local rechargePresentCtrl = gametop.playertop_:getModule("rechargePresentCtrl")
	local presentGold = rechargePresentCtrl:getRechargePresentGold()
	self.txtPointAdd:setString(string.formatnumberthousands(presentGold))
	SoraDToCenter(self.nodePoint, 10, not SoraDFIsRA())
end
function rechargePresentActivity:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		rechargePresentUtil.openRechargeView()
		self:removeFromParent()
	end
end
function rechargePresentActivity:msgCallBack(target, data)
	if not _G.clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function rechargePresentActivity:onClick_Button_help(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.RECHARGE_PRESENT)
	end
end
return rechargePresentActivity
