local gametop = gModuleMgr.getObject("gametop")
local friendsCallbackRead = include("friendsCallbackRead")
local friendsCallbackCtrl = gametop.playertop_:getModule("friendsCallbackCtrl")
local publicRead = include("publicRead")
local friendsTaskItem = class("friendsTaskItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("friendsTaskItem")
	end
	return target
end)
local colorRed = cc.c3b(204, 8, 8)
local colorYellow = cc.c3b(200, 140, 0)
function friendsTaskItem:ctor(...)
	self.item_single = SoraDGetChildByName(self, "item_single")
	self.panel_content = SoraDGetChildByName(self, "panel_content")
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.img_received = SoraDGetChildByName(self, "Image_received")
	self.text_progress_title = SoraDGetChildByName(self, "text_progress_title")
	self.text_value = SoraDGetChildByName(self, "text_progress_value")
	self.text_total = SoraDGetChildByName(self, "text_progress_total")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.text_progress_title:setString(i18n("common_text_3780"))
	self.btn_operate:setTitleText(i18n("common_text_1146"))
	self.btn_operate:addTouchEventListener(handler(self, self.btnOperateClick))
	self.img_received:setVisible(false)
	self.tbInUse, _ENV, self.tbNotUse, _ENV = self.img_received.setVisible, self.img_received.setVisible, self.img_received.setVisible, self.img_received.setVisible
	self.item_single:setVisible(false)
	table.insert(self.tbNotUse, self.item_single)
end
function friendsTaskItem:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_TASK", function(target, data)
		SoraDCloseLoading(self)
	end)
end
function friendsTaskItem:initView(data)
	self.taskData = data
	local _ENV, singleTable
	dump(data, "friendsTaskItem:initView", 10)
	local curNum = friendsCallbackCtrl:getTaskCurNum(data.taskID) or 0
	self.text_total:setString("/" .. data.Quest)
	self.text_value:setString(curNum)
	if curNum and curNum < data.Quest then
		self.text_value:setColor(colorRed)
	else
		self.text_value:setColor(colorYellow)
	end
	self.text_title:setString(i18n(data.name))
	local taskstatus = friendsCallbackCtrl:getTaskState(data.taskID)
	print("现在的status", taskstatus)
	local _ENV, nodeArray = print, print
	local _ENV, paddingArray = "现在的status", "现在的status"
	local align = false
	if SoraDFIsRA() then
		colorYellow = SoraDFIsRA()
		colorRed, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_value
		colorRed, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_total
		colorRed, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = false
	else
		colorYellow = SoraDFIsRA()
		colorRed, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_total
		colorRed, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_value
		colorRed, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = true
	end
	SoraDAlignNodeArray(nodeArray, align, paddingArray)
	self:recycleAll()
	for i, v in ipairs(data.Reward) do
		local single = self:getItem()
		if SoraDFIsRA() then
			single:setPositionX(535 - (i - 1) * 90)
			single:setVisible(true)
		else
			single:setPositionX(90 + (i - 1) * 90)
			single:setVisible(true)
		end
		self:initSingle(single, v)
		table.insert(self.tbInUse, single)
	end
	if taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
		self.btn_operate:setVisible(true)
		self.btn_operate:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btn_operate:setTitleText(i18n("common_text_1146"))
	elseif taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE_DONE then
		self.btn_operate:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btn_operate:setVisible(true)
		self.btn_operate:setTouchEnabled(false)
		SoraDSetNodeGray(self.btn_operate, true)
		self.btn_operate:setTitleText(i18n("common_text_1892"))
	elseif taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_DOING then
		self.btn_operate:setVisible(false)
	end
end
function friendsTaskItem:recycleAll()
	for i, v in ipairs(self.tbInUse) do
		v:setVisible(false)
		table.insert(self.tbNotUse, v)
	end
	self.tbInUse, _ENV = ipairs(self.tbInUse)
end
function friendsTaskItem:getItem()
	if #self.tbNotUse > 0 then
		local node = table.remove(self.tbNotUse)
		node:setVisible(true)
		return node
	else
		itemSingle = self.item_single:clone()
		itemSingle:addTo(self.panel_content)
		return itemSingle
	end
end
function friendsTaskItem:initSingle(_node, data)
	local itemSingle = _node
	itemSingle:getChildByName("item_single_quality"):loadTexture(publicRead.getBg(data.id), ccui.TextureResType.plistType)
	itemSingle:getChildByName("item_single_icon"):loadTexture(publicRead.getIcon(data.id), ccui.TextureResType.plistType)
	itemSingle:getChildByName("item_single_num"):setString(data.count)
	local item_single_show = itemSingle:getChildByName("item_single_show")
	item_single_show:setTouchEnabled(true)
	item_single_show:setSwallowTouches(false)
	item_single_show:addTouchEventListener(handler(self, self.onClick_Button_show))
	item_single_show.itemId = data.id
end
function friendsTaskItem:btnOperateClick(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		local taskstatus = friendsCallbackCtrl:getTaskState(self.taskData.taskID)
		local taskID = self.taskData.taskID
		if taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
			print("TODO:领取-----")
			local loading = SoraDShowLoading(sender, sender:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
			_ENV = cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)
			cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).taskID = taskID
			friendsCallbackCtrl:reqCommitTask(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
		end
	end
end
function friendsTaskItem:setScroll(_scroll)
	self.scorll = _scroll
end
function friendsTaskItem:onClick_Button_show(sender, event)
	if event == ccui.TouchEventType.began then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll, event) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		self:openItemInfo(sender.itemId, sender)
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
		self:closeItemInfo()
	elseif event == ccui.TouchEventType.ended then
		self:closeItemInfo()
	end
end
function friendsTaskItem:openItemInfo(id, sender)
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_SERVER_SPICE_SHOW_ITEMINFO"
	;(nil).isShow = true
	;(nil).id = id
	;(nil).item = sender
	SoraDSendMessage(nil)
end
function friendsTaskItem:closeItemInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_SERVER_SPICE_SHOW_ITEMINFO"
	;(nil).isShow = false
	SoraDSendMessage(nil)
end
return friendsTaskItem
