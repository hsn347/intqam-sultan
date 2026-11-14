local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local friendsCallbackCtrl = gametop.playertop_:getModule("friendsCallbackCtrl")
local friendsCallbackRead = include("friendsCallbackRead")
local gameInviteltCtrl = include("gameInviteltCtrl")
local friendsCallbackView = class("friendsCallbackView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("friendsCallbackView")
	end
	return target
end)
function friendsCallbackView:ctor()
	self.node_common_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.node_common_title:setTitle(i18n("activity_name_9001113"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_item")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btn_copy = SoraDGetChildByName(self, "Button_ctrlC")
	self.btn_store = SoraDGetChildByName(self, "Button_store")
	self.btn_friend = SoraDGetChildByName(self, "Button_friend")
	self.btn_share_lucky = SoraDGetChildByName(self, "Button_shareLucky")
	self.btn_help = SoraDGetChildByName(self, "btn_help_tip")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_inviteCode = SoraDGetChildByName(self, "Text_inviteCode")
	self.Text_inviteCode = SoraDChangeTextToHtml(self.Text_inviteCode)
	self.btn_copy:setTitleText(i18n("common_text_078"))
	self.btn_store:setTitleText(i18n("return_title_02"))
	self.btn_friend:setTitleText(i18n("return_text_24"))
	self.btn_share_lucky:setTitleText(i18n("return_title_01"))
	self.Text_des:setString(i18n("returnnew_text_012"))
	self.btn_store:addTouchEventListener(handler(self, self.btnOperateClick))
	self.btn_friend:addTouchEventListener(handler(self, self.btnOperateClick))
	self.btn_share_lucky:addTouchEventListener(handler(self, self.btnOperateClick))
	self.btn_help:addTouchEventListener(handler(self, self.btnOperateClick))
	self.btn_copy:addTouchEventListener(handler(self, self.btnCopyClick))
	self.btnCallFriendBack = SoraDGetChildByName(self, "Button_CalBack")
	self.btnCallFriendBack:setTitleText(i18n("callback_friend_btn_01"))
	self.btnCallFriendBack:addTouchEventListener(handler(self, self.btnCallFriendClick))
	SoraDAutoSizeButtonText(self.btnCallFriendBack)
	self.btnReward = SoraDGetChildByName(self, "Button_reward")
	self.btnReward:setTitleText(i18n("returnnew_title_013"))
	self.btnReward:addTouchEventListener(handler(self, self.btnRewardClick))
	SoraDAutoSizeButtonText(self.btnReward)
	self.eventDatas, _ENV, self.tableItemsSpare, _ENV, self.tableItemsSel, _ENV = SoraDAutoSizeButtonText, SoraDAutoSizeButtonText, SoraDAutoSizeButtonText, SoraDAutoSizeButtonText, SoraDAutoSizeButtonText, SoraDAutoSizeButtonText
	self.copied = false
	self.itemSize = cc.size(600, 140)
	self:initView()
end
function friendsCallbackView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_TASK", function(target, data)
		self:clearOld()
		self:updateTaskData()
		self:updateScrollData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FRIEND_CALLBACK) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_UI_SERVER_SPICE_SHOW_ITEMINFO", handler(self, self.msgShowItemInfo))
end
function friendsCallbackView:initView()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_CALLBACK)
	if eventTime then
		self.text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, 10, SoraDFIsRA())
	end
	activityShowCtrl = SoraDFIsRA()
	SoraDFIsRA().code = friendsCallbackCtrl:getInviteCode()
	activityShowCtrl = "invite_text_10"
	;("invite_text_10").u = true
	local str = SoraDWrapHtmlTagByStyle(i18n("invite_text_10", SoraDFIsRA()), "invite_text_10")
	self.Text_inviteCode:setString(str)
	self:clearOld()
	self:updateTaskData()
	self:updateScrollData()
end
function friendsCallbackView:clearOld()
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableItemsSpare, v.point)
			v.point = nil
		end
	end
	self.tableItemsSel, _ENV = ipairs(self.tableItemsSel)
end
function friendsCallbackView:sortData()
	table.sort(self.eventDatas, function(a, b)
		local aState = friendsCallbackCtrl:getTaskState(a.taskID)
		local bState = friendsCallbackCtrl:getTaskState(b.taskID)
		if aState == bState then
			return a.taskID < b.taskID
		end
		friendsCallbackCtrl = a.taskID < b.taskID
		;(a.taskID < b.taskID)[gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE] = 1
		;(a.taskID < b.taskID)[gFriendCallbackTaskStatus.TASK_STATUS_DOING] = 2
		local (a.taskID < b.taskID)[gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE_DONE], priorityTab = 3, a.taskID < b.taskID
		return priorityTab[aState] < priorityTab[bState]
	end)
end
function friendsCallbackView:updateTaskData()
	self.eventDatas = friendsCallbackRead.callbackTaskGiftConfig
	self:sortData(self.eventDatas)
	dump(self.eventDatas, "friendsCallbackView:updateTaskData", 10)
	for k, v in ipairs(self.eventDatas) do
		friendsCallbackRead = nil
		;(nil).data = v
		friendsCallbackRead, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableItemsSel, nil)
	end
end
function friendsCallbackView:updateScrollData()
	self:initScroll()
	self:initTaskItems()
	self.scroll:jumpToTop()
end
function friendsCallbackView:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	local scrollW = self.scroll:getContentSize().width
	local accumulateHeight = self.itemSize.height * #self.tableItemsSel + 10
	for i, v in ipairs(self.tableItemsSel) do
		v.pos.y = accumulateHeight - i * self.itemSize.height
		v.pos.x = 0
		if v.point then
			v.point:setPositionY(v.pos.y)
			v.point:setPositionX(v.pos.x)
		end
	end
	local totalCellHeight = accumulateHeight
	if scrollH > totalCellHeight then
		local deltaY = scrollH - totalCellHeight
		totalCellHeight = scrollH
		for i, v in ipairs(self.tableItemsSel) do
			v.pos.y = v.pos.y + deltaY
			if v.point then
				v.point:setPositionY(v.pos.y)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function friendsCallbackView:initTaskItems()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableItemsSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableItemsSpare then
				single = table.remove(self.tableItemsSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("friendsTaskItem")
				single:addTo(self.scroll)
			end
			single:setScroll(self.scroll)
			single:initView(v.data, "login")
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function friendsCallbackView:btnOperateClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btn_store then
			local panel = SoraDCreatePanel("callbackStore")
			panel:show()
		elseif button == self.btn_friend then
			local panel = SoraDCreatePanel("callbackFriendsShare")
			panel:show()
		elseif button == self.btn_share_lucky then
			local panel = SoraDCreatePanel("blessWithShare")
			panel:show()
		elseif button == self.btn_help then
			userSDKManager.showSingleFAQ(IsArClient and gSDKDef.FAQSingleType.FRIEND_CALLBACK or gSDKDef.FAQSingleType.FRIEND_CALLBACK_ROS)
		end
	end
end
function friendsCallbackView:btnCallFriendClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local url = self:getShareUrl()
		print("···", url)
		userSDKManager.openSDKLink(url)
	end
end
function friendsCallbackView:btnRewardClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("callbackInviteGift"):show()
	end
end
function friendsCallbackView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initTaskItems()
	end
end
function friendsCallbackView:btnCopyClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCopyText(friendsCallbackCtrl:getInviteCode())
		SoraDShowMsgTip(i18n("common_text_1062"))
		self:recordPost(gGameInvitePlatform.COPY)
		self.copied = true
	end
end
function friendsCallbackView:recordPost(_channel)
	local accountExtCtrl = gametop.playertop_:getModule("accountExtCtrl")
	local invCode = friendsCallbackCtrl:getInviteCode()
	gametop = nil
	;(nil).channel = _channel
	;(nil).invite_code = invCode
	userSDKManager.logEvent(gSDKDef.TDonEvent.invite_friends_log, nil)
end
function friendsCallbackView:getShareUrl(cid)
	local reUrl = ""
	local invCode = friendsCallbackCtrl:getInviteCode()
	local timestamp = serviceFunctions.systemTime()
	local channel = userSDKManager.getChannel()
	if IsArClient then
		if userSDKManager.isBeta() then
			reUrl = string.format("https://h5action-test.onemt.co/koh/friendRecall?inviteCode=%s", invCode)
		else
			reUrl = string.format("https://h5action.onemt.co/koh/friendRecall/?inviteCode=%s&timestamp=%s", invCode, timestamp)
		end
	elseif userSDKManager.isBeta() then
		reUrl = "https://h5action-test.onemt.co/koh/versionnews"
	else
		reUrl = string.format("https://h5action.onemt.co/ros/friendrecall/?channel=%s&inviteCode=%s", channel, invCode)
	end
	print("", url)
	return reUrl
end
function friendsCallbackView:msgShowItemInfo(target, data)
	local isShow = data.isShow
	if isShow == true then
		self:openItemInfoMsg(data)
	else
		self:closeItemInfoMsg(data)
	end
end
function friendsCallbackView:openItemInfo(id, sender)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_SERVER_SPICE_SHOW_ITEMINFO"
	;(nil).isShow = true
	;(nil).id = id
	;(nil).item = sender
	SoraDSendMessage(nil)
end
function friendsCallbackView:closeItemInfo()
	self.isShowItemInfo = false
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_SERVER_SPICE_SHOW_ITEMINFO"
	;(nil).isShow = false
	SoraDSendMessage(nil)
end
function friendsCallbackView:openItemInfoMsg(data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	self.itemTips:initData(itemID)
end
function friendsCallbackView:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
return friendsCallbackView
