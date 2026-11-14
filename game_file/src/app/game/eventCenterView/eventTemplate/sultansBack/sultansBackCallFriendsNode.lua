local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackCallFriendsNode = class("sultansBackCallFriendsNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sultansBackCallFriendsNode")
	end
	return target
end)
function sultansBackCallFriendsNode:ctor()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.activityID = gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS
	self.desBgColor = "#D7C39B"
	self.scheduBgColor = "#D7C39B"
	self.scheduValeColor = "#6CDE00"
	self.desColor = "#FFBF00"
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(640, 56))
	self.ccs_tab:setNewStyle()
	_ENV = cc.size(640, 56)
	cc.size(640, 56).tabNum = 2
	_ENV, _ENV, cc.size(640, 56).defaultClick = cc.size(640, 56)
	cc.size(640, 56).title = i18n("activity_name_9001298")
	_ENV, cc.size(640, 56)[1], cc.size(640, 56).handle = cc.size(640, 56)
	cc.size(640, 56).title = i18n("friend_back_text04")
	cc.size(640, 56).tabsetArray, cc.size(640, 56)[2], cc.size(640, 56).handle = cc.size(640, 56)
	self.ccs_tab:initView(cc.size(640, 56))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_607", nil)
	end)
	self.ScrollView_task = include("commonAutoScrollList").new(self.ScrollView_task)
	self.ScrollView_task:setSingleCreate(handler(self, self.createTaskSingle))
	self.ScrollView_item = include("commonAutoScrollList").new(self.ScrollView_item)
	self.ScrollView_item:setSingleCreate(handler(self, self.createFriendsSingle))
	self.Button_copy:setTitleText(i18n("common_text_078"))
	self.Text_facebook:setString("FaceBook")
	self.Text_whatsapp:setString("WhatsApp")
	self.text_noFriend:setString(i18n("friend_back_text05"))
	self.text_grad:setString(i18n("friend_back_text01"))
	self.text_grad:setFontSize(24)
	self.Button_copy:addTouchEventListener(handler(self, self.btnCopyClick))
	self.Button_whatsapp:addTouchEventListener(handler(self, self.btnWhatsClick))
	self.Button_facebook:addTouchEventListener(handler(self, self.btnfaceClick))
	self:suitView()
	self:initTime()
end
function sultansBackCallFriendsNode:onEnterPanel()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
function sultansBackCallFriendsNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_CALLFRIENDS_REFRESH", function()
		SoraDCloseLoading(self)
		self:initData()
	end)
end
function sultansBackCallFriendsNode:suitView()
	self.Node_head:setPositionY(display.height - 420)
	self.ScrollView_task:setContentSize(cc.size(640, display.height - 715))
	self.text_noFriend:setPositionY(self.ScrollView_item:getContentSize().height / 2)
end
function sultansBackCallFriendsNode:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		local leftTime = eventTime.timerNode.timer:getRemainTime()
		activityShowCtrl = nil
		;(nil).time = leftTime
		self.Text_time:setString(i18n("common_text_607", nil))
		self.Text_time:beginTime(leftTime)
		self.icon_hourglass:setPositionX(self.Text_time:getPositionX() + SoraDFSign(self.Text_time:getContentSize().width / 2) + SoraDFSign(20))
	end
end
function sultansBackCallFriendsNode:initData()
	local callFriendData = sultansBackCtrl:getCallFriendData()
	local taskList = sultansBackRead.getCallFriendTaskConfig()
	local sultansBackCtrl, friendList
	local sultansBackCtrl, sortedTaskList
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
	for k, v in pairs(callFriendData.friendsData) do
		print("slkdflskjf", k)
		table.insert(friendList, v)
	end
	for i, v in ipairs(friendList) do
		v.index = i
	end
	sultansBackCtrl = table.insert
	table.insert.scroll = self.ScrollView_task
	table.insert.view = self
	self.ScrollView_task:updateScrollView(cc.size(640, 154), sortedTaskList, 1, table.insert)
	sultansBackCtrl = table.insert
	table.insert.scroll = self.ScrollView_item
	table.insert.view = self
	self.ScrollView_item:updateScrollView(cc.size(640, 115), friendList, 1, table.insert)
	sultansBackCtrl = 1
	;(1).code = callFriendData.inviteCode
	self.Text_mineCode:setString(i18n("invite_text_10", 1))
	SoraDDrawTextUnderLine(self.Text_mineCode, cc.c4b(255, 200, 100, 255), 2)
end
function sultansBackCallFriendsNode:clickFriendTab()
	self.node_friend:setVisible(false)
	self.node_back:setVisible(true)
end
function sultansBackCallFriendsNode:clickBackTab()
	self.node_friend:setVisible(true)
	self.node_back:setVisible(false)
	self.text_noFriend:setVisible(false)
	local callFriendData = sultansBackCtrl:getCallFriendData()
	if not next(callFriendData.friendsData) then
		self.text_noFriend:setVisible(true)
	end
end
function sultansBackCallFriendsNode:createFriendsSingle()
	local target = self.Node_FriendSingle:clone()
	local Text_index = SoraDGetChildByName(target, "Text_index")
	local Text_name = SoraDGetChildByName(target, "Text_name")
	local Text_alliance = SoraDGetChildByName(target, "Text_alliance")
	local Image_head = SoraDGetChildByName(target, "Image_head")
	local Image_headBg = SoraDGetChildByName(target, "Image_headBg")
	local Panel_touch = SoraDGetChildByName(target, "Panel_touch")
	Panel_touch:setSwallowTouches(false)
	function target.initData(target, data, otherData)
		dump(data, "slkdfsljfkldj")
		Text_index:setString(data.index)
		Text_name:setString(data.nickName .. " " .. "#" .. data.kid)
		SoraDGetHeadFromManager(Image_head, data.imageId, data.avatar)
	end
	return target
end
function sultansBackCallFriendsNode:setParentView(parent)
	self.parentView = parent
end
function sultansBackCallFriendsNode:createTaskSingle()
	local target = self.Node_TaskSingle:clone()
	local Button_go = SoraDGetChildByName(target, "Button_go")
	local Text_schedule = SoraDGetChildByName(target, "Text_schedule")
	local Text_des = SoraDGetChildByName(target, "Text_des")
	local Node_Finish = SoraDGetChildByName(target, "Node_Finish")
	local Text_Finish = SoraDGetChildByName(Node_Finish, "Text_Finish")
	Node_Finish:setVisible(false)
	Text_des = _G.SoraDChangeTextToHtml(Text_des)
	Text_schedule = _G.SoraDChangeTextToHtml(Text_schedule)
	Button_go:addTouchEventListener(handler(self, self.btnGetRewardsClick))
	function target.initData(target, data, otherData)
		self = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local awardList = serviceFunctions.tableFormat(data.Reward, nil)
		local callFriendData = sultansBackCtrl:getCallFriendData()
		for i, v in ipairs(awardList) do
			local itemAward = SoraDCreatePanel("commonItemAward")
			itemAward:setScale(0.7)
			itemAward:setBaseScale(1.0)
			itemAward:addTo(target)
			itemAward:setOwnView(self.parentView)
			itemAward:setOwnScroll(self.ScrollView_task)
			if SoraDFIsRA() then
				itemAward:setPosition(580 - (i - 1) * 80, 60)
			else
				itemAward:setPosition(60 + (i - 1) * 80, 60)
			end
			itemAward:initData(v.id, v.count)
		end
		local lang = data.name[1]
		local targetNum = data.name.num
		local curCount = callFriendData.friendsNum or 0
		if not lang or lang == "" then
			lang = "NA"
		end
		_ENV = SoraDCreatePanel("commonItemAward")
		_ENV, _ENV, SoraDCreatePanel("commonItemAward").num = itemAward, targetNum or "", targetNum or ""
		itemAward.color = self.desColor
		_ENV, (targetNum or "").num, itemAward.i = itemAward, itemAward, "true"
		;(targetNum or "").__default, itemAward.color = itemAward, self.desBgColor
		local str_des = _G.i18n_html(lang, SoraDCreatePanel("commonItemAward"), targetNum or "")
		dump(lang, "skdjflsdjflksjd")
		if data.Type == 2 then
			curCount = callFriendData.rechargeSum
			local tempPrice = paymentManager.judgePrice(301, 9.9)
			_ENV = itemAward
			itemAward.num = targetNum or ""
			_ENV, _ENV, itemAward.price = v.count, targetNum or "", tempPrice
			v.count.color = self.desColor
			_ENV, (targetNum or "").num, v.count.i = v.count, v.count, "true"
			;(targetNum or "").__default, v.count.color = v.count, self.desBgColor
			str_des = _G.i18n_html(lang, itemAward, targetNum or "")
		end
		local isGetReward = callFriendData.rewardFlag[tostring(data.taskID)] or false
		Text_des:setString(str_des)
		self:setScheduleText(curCount, targetNum, isGetReward, Text_schedule)
		self:setBtnStatus(curCount, targetNum, isGetReward, Button_go)
		Button_go:setTag(data.taskID)
	end
	return target
end
function sultansBackCallFriendsNode:setBtnStatus(curCount, totalCount, isGetReward, targetBtn)
	targetBtn:setVisible(totalCount <= curCount)
	targetBtn:setTitleText(curCount < totalCount and i18n("common_text_477") or not (not (totalCount <= curCount) or isGetReward) and i18n("common_text_1146") or isGetReward and i18n("common_text_1892"))
	targetBtn:setTitleColor(isGetReward and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	targetBtn:loadTextureNormal(isGetReward and "btn_gray_small.png" or curCount < totalCount and "btn_yellow_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
	if isGetReward then
		targetBtn:setTouchEnabled(false)
	end
end
function sultansBackCallFriendsNode:setScheduleText(curCount, totalCount, isGetReward, targetTxt)
	local count = curCount
	local total = totalCount
	count = math.min(count, total)
	if isGetReward then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduBgColor
	elseif curCount < totalCount then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduColor
	elseif totalCount <= curCount then
		scheduTotalColor = self.scheduValeColor
		scheduCountColor = self.scheduValeColor
	end
	_ENV = count
	count.color = scheduCountColor
	local countStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(count), count)
	_ENV = "/%s"
	;("/%s").color = scheduTotalColor
	local totalStr = SoraDWrapHtmlTagByStyle(string.format("/%s", string.formatnumberthousands(total)), "/%s")
	local value = string.format("%s%s", countStr, totalStr)
	value = _pq(value)
	_ENV = string.formatnumberthousands(total)
	_ENV, _ENV, string.formatnumberthousands(total).value = string.formatnumberthousands(total)
	string.formatnumberthousands(total).__default, string.formatnumberthousands(total).color = string.formatnumberthousands(total)
	targetTxt:setString(_G.i18n_html("complete_text_05", string.formatnumberthousands(total)))
end
function sultansBackCallFriendsNode:btnShowClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("common_text_4529"))
	end
end
function sultansBackCallFriendsNode:btnGetRewardsClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		sultansBackCtrl:reqCallFriendsReward(button:getTag())
		SoraDShowLoading(self)
	end
end
function sultansBackCallFriendsNode:btnCopyClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local callFriendData = sultansBackCtrl:getCallFriendData()
		SoraDCopyText(callFriendData.inviteCode)
		print("self:getShareContentText()=", self:getShareContentText())
		_ENV = self:getShareContentText()
		self:getShareContentText().code = callFriendData.inviteCode
		SoraDShowMsgTip(i18n("invite_text_10", self:getShareContentText()))
	end
end
function sultansBackCallFriendsNode:getShareContentText()
	return i18n("friend_back_text06")
end
function sultansBackCallFriendsNode:getShareUrl(cid)
	local reUrl = ""
	local callFriendData = sultansBackCtrl:getCallFriendData()
	local invCode = callFriendData.inviteCode
	local languange = SoraDGetDefaultLanguage()
	reUrl = string.format("https://h5share.onemtshare.com/koh/callfriend?aid=097032e86994a9acbc4e09db9bcd56c0&inviteCode=%s&source=%s&lang=%s", invCode, cid, languange)
	return reUrl
end
function sultansBackCallFriendsNode:btnfaceClick(button, type)
	if type == ccui.TouchEventType.ended then
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
function sultansBackCallFriendsNode:btnWhatsClick(button, type)
	if type == ccui.TouchEventType.ended then
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
return sultansBackCallFriendsNode
