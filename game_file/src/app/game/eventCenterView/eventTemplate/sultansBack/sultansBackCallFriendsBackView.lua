local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackCallFriendsBackView = class("sultansBackCallFriendsBackView", function(target)
	return SoraDCreateBasePanel("sultansBackCallFriendsBackView")
end)
function sultansBackCallFriendsBackView:ctor()
	self.activityID = gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("activity_name_9001289"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("callFriendsBackTaskSingle")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_607", nil)
	end)
	self.Text_grad = SoraDGetChildByName(self, "Text_grad")
	self.Text_grad:setString(i18n("friend_back_text01"))
	self.Text_callBack = SoraDGetChildByName(self, "Text_callBack")
	self.Text_callBack:setString(i18n("friend_back_text04"))
	self.Button_callBack = SoraDGetChildByName(self, "Button_callBack")
	self.Button_callBack:addTouchEventListener(handler(self, self.btnCallBackClick))
	self.Button_whatsapp = SoraDGetChildByName(self, "Button_whatsapp")
	self.Node_whatsapp = SoraDGetChildByName(self, "Node_whatsapp")
	self.Text_whatsapp = SoraDGetChildByName(self, "Text_whatsapp")
	self.Text_whatsapp:setString("WhatsApp")
	SoraDToCenter(self.Node_whatsapp)
	self.Button_facebook = SoraDGetChildByName(self, "Button_facebook")
	self.Node_facebook = SoraDGetChildByName(self, "Node_facebook")
	self.Text_facebook = SoraDGetChildByName(self, "Text_facebook")
	self.Text_facebook:setString("FaceBook")
	SoraDToCenter(self.Node_facebook)
	self.Button_whatsapp:addTouchEventListener(handler(self, self.btnWhatsClick))
	self.Button_facebook:addTouchEventListener(handler(self, self.btnfaceClick))
	self.Node_code = SoraDGetChildByName(self, "Node_code")
	self.Text_mineCode = SoraDGetChildByName(self, "Text_mineCode")
	self.Button_copy = SoraDGetChildByName(self, "Button_copy")
	self.Button_copy:addTouchEventListener(handler(self, self.btnCopyClick))
	self:initTime()
	self:initData()
end
function sultansBackCallFriendsBackView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_CALLFRIENDS_REFRESH", function()
		SoraDCloseLoading(self)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function sultansBackCallFriendsBackView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function sultansBackCallFriendsBackView:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		local leftTime = eventTime.timerNode.timer:getRemainTime()
		activityShowCtrl = nil
		;(nil).time = leftTime
		self.Text_time:setString(i18n("common_text_607", nil))
		self.Text_time:beginTime(leftTime)
		SoraDToCenter(self.Node_time)
	end
end
function sultansBackCallFriendsBackView:initData()
	local taskList = sultansBackRead.getCallFriendTaskConfig()
	local callFriendData = sultansBackCtrl:getCallFriendData()
	sultansBackRead = nil
	;(nil).code = callFriendData.inviteCode
	self.Text_mineCode:setString(i18n("invite_text_10", nil))
	SoraDToCenter(self.Node_code)
	local sultansBackRead, sortedTaskList = SoraDToCenter, SoraDToCenter
	for i, v in ipairs(taskList) do
		table.insert(sortedTaskList, v)
		local curCount = callFriendData.friendsNum or 0
		if v.Type == 2 then
			curCount = callFriendData.rechargeSum
		end
		sortedTaskList[i].weight = 1
		if callFriendData.rewardFlag[tostring(sortedTaskList[i].taskID)] then
			sortedTaskList[i].weight = 2
		elseif curCount >= v.name.num then
			sortedTaskList[i].weight = 0
		end
	end
	table.sort(sortedTaskList, function(a, b)
		if a.weight ~= b.weight then
			return a.weight < b.weight
		end
		return a.taskID < b.taskID
	end)
	sultansBackRead = callFriendData.rechargeSum
	callFriendData.rechargeSum.scroll = self.scroll
	callFriendData.rechargeSum.view = self
	self.scroll:updateScrollView(cc.size(640, 154), sortedTaskList, 1, callFriendData.rechargeSum)
end
function sultansBackCallFriendsBackView:getShareUrl(cid)
	local reUrl = ""
	local callFriendData = sultansBackCtrl:getCallFriendData()
	local invCode = callFriendData.inviteCode
	local languange = SoraDGetDefaultLanguage()
	reUrl = string.format("https://h5share.onemtshare.com/koh/callfriend?aid=097032e86994a9acbc4e09db9bcd56c0&inviteCode=%s&source=%s&lang=%s", invCode, cid, languange)
	return reUrl
end
function sultansBackCallFriendsBackView:btnCallBackClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("callFriendsBackPopView"):show()
	end
end
function sultansBackCallFriendsBackView:btnCopyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local callFriendData = sultansBackCtrl:getCallFriendData()
		SoraDCopyText(callFriendData.inviteCode)
		_ENV = nil
		;(nil).code = callFriendData.inviteCode
		SoraDShowMsgTip(i18n("invite_text_10", nil))
	end
end
function sultansBackCallFriendsBackView:btnfaceClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentUrl = self:getShareUrl("facebook")
		print(contentUrl)
		if device.platform == "mac" then
			device.openURL(contentUrl)
		end
		userSDKManager.shareFacebookLinkContent(contentUrl)
		print("facebookfuck", url)
	end
end
function sultansBackCallFriendsBackView:btnWhatsClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentUrl = self:getShareUrl("whatsapp")
		print(contentUrl)
		if device.platform == "mac" then
			device.openURL(contentUrl)
		end
		print("whatsappfuck", url)
		userSDKManager.shareWhatsappLinkContent(contentUrl)
	end
end
return sultansBackCallFriendsBackView
