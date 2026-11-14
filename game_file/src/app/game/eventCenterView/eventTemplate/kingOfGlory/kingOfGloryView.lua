local kingOfGloryCtrl = SoraDGetCtrl("kingOfGloryCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local kingOfGloryView = class("kingOfGloryView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingOfGloryView")
	end
	return target
end)
function kingOfGloryView:ctor()
	self.activityID = gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle"):setTitle(i18n("activity_name_9001347"))
	SoraDGetChildByName(self, "btn_FAQ"):addTouchEventListener(handler(self, self.clickFAQBtn))
	self.Text_left = SoraDGetChildByName(self, "Text_left")
	self.Text_left:setString(i18n("common_text_1663"))
	self.Text_lefttime = SoraDGetChildByName(self, "Text_lefttime")
	self.Top_Image_title = SoraDGetChildByName(self, "Top_Image_title")
	self.Top_Image_title:loadTexture(SoraDFIsRA() and "bg_activity_9001347_ar.png" or "bg_activity_9001347_en.png", ccui.TextureResType.plistType)
	self.scrollTask = SoraDGetChildByName(self, "Bottom_ScrollView_task")
	self.scrollTask = include("commonAutoScrollList").new(self.scrollTask)
	self.scrollTask:setSingleCCS("kingOfGlorySingle")
	kingOfGloryCtrl:reqInit()
	self:initTime()
	self:suitView()
end
function kingOfGloryView:suitView()
	self.scrollTask:setContentSize(cc.size(640, display.height - 355))
end
function kingOfGloryView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_KING_OF_GLORY_INIT", handler(self, self.initScrollView))
	SoraDAddMessage(self, "MESSAGE_KING_OF_GLORY_GET_REWARD", handler(self, self.initScrollView))
	SoraDAddMessage(self, "MESSAGE_KING_OF_GLORY_ON_CLOSE", handler(self, self.closePanel))
end
function kingOfGloryView:initTime()
	self.text_time = SoraDCreateTimerLabel(self, self.Text_lefttime)
	self.remainTime = 0
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.remainTime = leftTime
		self.text_time:setString(SoraDConvertSecondToString(leftTime))
		self.text_time:beginTime(leftTime)
	end
end
function kingOfGloryView:initScrollView(target, data)
	SoraDCloseLoading(self)
	self:reflashScroll()
end
function kingOfGloryView:reflashScroll()
	self.cfgs = kingOfGloryCtrl:getCfgList()
	kingOfGloryCtrl = nil
	;(nil).scroll = self.scrollTask
	;(nil).view = self
	;(nil).activityID = self.activityID
	self.scrollTask:updateScrollView(cc.size(627, 161), self.cfgs, 1, nil)
end
function kingOfGloryView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "kingglory_text_01"
		;("kingglory_text_01").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("kingglory_text_01"), "kingglory_text_01")
	end
end
function kingOfGloryView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return kingOfGloryView
