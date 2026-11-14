local gametop = gModuleMgr.getObject("gametop")
local newKingRisesCtrl = gametop.playertop_:getModule("newKingRisesCtrl")
local newKingRisesltCtrl = gModuleMgr.sharedMgr("newKingRisesltCtrl")
local colorDaySel = cc.c3b(255, 200, 100)
local colorDayUnSel = cc.c3b(102, 80, 40)
local colorEventSel = cc.c3b(255, 238, 169)
local colorEventUnSel = cc.c3b(136, 123, 112)
local newKingRiseView = class("newKingRiseView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("newKingRiseView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function newKingRiseView:ctor()
	self.isHideCurrentSceneView = true
	self.isAddToPopManager = true
	self:createUI()
	self.Size_Tile_Image_bg = SoraDGetChildByName(self, "Size_Tile_Image_bg")
	self.Size_Tile_Image_bg:setContentSize(cc.size(display.width, display.height))
	self.Top_Info_Node = SoraDGetChildByName(self, "Top_Info_Node")
	self.bg_activity = SoraDGetChildByName(self, "bg_activity")
	self.bg_text_end_time = SoraDGetChildByName(self, "bg_text_end_time")
	self.bg_text_end_time:setVisible(false)
	self.text_end_time = SoraDGetChildByName(self, "text_end_time")
	self.text_end_time:setVisible(false)
	self.bg_task_tip = SoraDGetChildByName(self, "bg_task_tip")
	self.text_task_tip = SoraDGetChildByName(self, "text_task_tip")
	self.bg_progress = SoraDGetChildByName(self, "bg_progress")
	self.progress_bar = SoraDGetChildByName(self, "progress_bar")
	self.frame_line_top = SoraDGetChildByName(self, "frame_line_top")
	self.bg_box = SoraDGetChildByName(self, "bg_box")
	self.btn_award = SoraDGetChildByName(self, "btn_award")
	self.btn_shop = SoraDGetChildByName(self, "btn_shop")
	self.bg_num = SoraDGetChildByName(self, "bg_num")
	self.text_num = SoraDGetChildByName(self, "text_num")
	self.text_claim_time = SoraDGetChildByName(self, "text_claim_time")
	self.text_claim_time_2 = SoraDGetChildByName(self, "text_claim_time_2")
	self.text_progress = SoraDGetChildByName(self, "text_progress")
	self.node_tab = SoraDGetChildByName(self, "node_tab")
	self.btn_tab_1 = SoraDGetChildByName(self, "btn_tab_1")
	self.img_sel = SoraDGetChildByName(self, "img_sel")
	self.text_tab = SoraDGetChildByName(self, "text_tab")
	self.frame_tab_line1 = SoraDGetChildByName(self, "frame_tab_line1")
	self.frame_tab_line2 = SoraDGetChildByName(self, "frame_tab_line2")
	self.Size_Image_L = SoraDGetChildByName(self, "Size_Image_L")
	self.Size_Image_R = SoraDGetChildByName(self, "Size_Image_R")
	self.frame_line_bottom = SoraDGetChildByName(self, "frame_line_bottom")
	self.frame_line_left = SoraDGetChildByName(self, "frame_line_left")
	self.frame_line_right = SoraDGetChildByName(self, "frame_line_right")
	self.img_day_number1 = SoraDGetChildByName(self, "img_day_number1")
	self.img_event_number1 = SoraDGetChildByName(self, "img_event_number1")
	self.text_event_number = SoraDGetChildByName(self, "text_event_number")
	self.btn_day_1 = SoraDGetChildByName(self, "btn_day_1")
	self.img_day_number = SoraDGetChildByName(self, "img_day_number")
	self.text_day_num = SoraDGetChildByName(self, "text_day_num")
	self.Top_Node_head = SoraDGetChildByName(self, "Top_Node_head")
	self.btn_help_tip = SoraDGetChildByName(self, "btn_help_tip")
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.Size_ScrollEvents = SoraDGetChildByName(self, "Size_ScrollEvents")
	self.Sprite_box = SoraDGetChildByName(self, "Sprite_box")
	self.frame_red_tip = SoraDGetChildByName(self, "frame_red_tip")
	SoraDGetChildByName(self.frame_red_tip, "Text_ePoint"):setString("!")
	self.sprite_box = SoraDGetChildByName(self, "Sprite_box")
	self.node_box_bg_effect = SoraDGetChildByName(self, "Node_box_bg_effect")
	self.node_box_top_effect_reset = SoraDGetChildByName(self, "Node_box_top_effect_reset")
	self.node_box_top_effect = SoraDGetChildByName(self, "Node_box_top_effect")
	self.sprite_box:setSpriteFrame("icon_king_road_box_01.png")
	self.btn_shop:setTitleText(i18n("common_text_1809"))
	self.btn_award:addTouchEventListener(handler(self, self.onClick_btn_award))
	self.btn_shop:addTouchEventListener(handler(self, self.onClick_btn_shop))
	self.btn_tab_1:addTouchEventListener(handler(self, self.onClick_btn_tab))
	self.btn_day_1:addTouchEventListener(handler(self, self.onClick_btn_day))
	self.btn_help_tip:addTouchEventListener(handler(self, self.onClick_btn_help_tip))
	local preViewHeight = 960
	local curHeight = display.height
	local deltaHeight = curHeight - preViewHeight
	self.commonFramTitle_node:setTitle(i18n("common_text_3717"))
	self.tbInUse, _ENV, self.tbNotUse, _ENV = self.commonFramTitle_node.setTitle, self.commonFramTitle_node.setTitle, self.commonFramTitle_node.setTitle, self.commonFramTitle_node.setTitle
	self.selDayIndex = 1
	self.selSetIndex = 1
	self:init()
	self.bg_activity:loadTexture(SoraDCheckPNG("bg_xwjq_01.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
end
function newKingRiseView:createUI()
end
function newKingRiseView:init(data)
	self.text_task_tip:setString(i18n("xwjq_text_03"))
	self.frame_red_tip:setVisible(false)
	if not self.isInitTabs then
		self:initTabs()
	end
	self:beginTime()
	self:updateTaskPercent()
	self:didSelectTabDay(1)
	self:updateDaysBtn()
	print("newKingRisesCtrl   = ", newKingRisesCtrl:getActivityStatus())
end
function newKingRiseView:updateTaskPercent()
	local totalComplete = newKingRisesCtrl:getTotalCompleteNum()
	local totalNum = newKingRisesltCtrl:getTotalTaskNum()
	_ENV = nil
	;(nil)[1] = totalComplete
	;(nil)[2] = totalNum
	dump(nil, "totalComplete, totalNum")
	local percent = string.format("%d/%d", totalComplete, totalNum)
	self.text_progress:setString(percent)
	local percent = 100 * (totalComplete / totalNum)
	self.progress_bar:setPercent(percent)
	self.progress_bar:setScale9Enabled(true)
	local curRewardNum = newKingRisesCtrl:getRewardNum()
	self.text_num:setString(curRewardNum)
	self.text_task_tip:setString(i18n("xwjq_text_03"))
	if curRewardNum == 0 then
		self.bg_num:setVisible(false)
		if self.isBoxOpenEffect then
			self:setBoxClose()
		end
		local activityStatus = newKingRisesCtrl:getActivityStatus()
		if activityStatus == gKingRisesActivityStatus.CALCULATE then
			self.text_task_tip:setString(i18n("xwjq_text_03"))
		end
	else
		self.bg_num:setVisible(true)
		local activityStatus = newKingRisesCtrl:getActivityStatus()
		if activityStatus == gKingRisesActivityStatus.CALCULATE then
			self.text_task_tip:setString(i18n("xwjq_text_03"))
			if not self.isBoxOpenEffect then
				self:openBoxEffect()
			end
		elseif self.isBoxOpenEffect then
			self:setBoxClose()
		end
	end
end
function newKingRiseView:initTabs()
	local btnDayNumBg = self.img_day_number1
	local btnDayNumText = self.img_day_number1:getChildByName("text_day_num")
	colorDayUnSel = self.img_day_number1
	colorDayUnSel, self.btnDays, self.img_day_number1[1] = self.img_day_number1, self.img_day_number1, self.btn_day_1
	colorDayUnSel, self.btnDayNumBgs, self.img_day_number1[1] = self.img_day_number1, self.img_day_number1, btnDayNumBg
	self.btnDayLocks, _ENV, self.btnDayNumTexts, self.img_day_number1[1] = self.img_day_number1, self.img_day_number1, self.img_day_number1, btnDayNumText
	for i = 2, 5 do
		local btnDayNode = self.btn_day_1:clone()
		btnDayNode:setName("btn_day_" .. i)
		btnDayNode:addTo(self.btn_day_1:getParent())
		local btnDayNumBg = self.img_day_number1:clone()
		btnDayNumBg:addTo(self.img_day_number1:getParent())
		btnDayNumBg:setName("img_event_number" .. i)
		local btnDayNumText = btnDayNumBg:getChildByName("text_day_num")
		table.insert(self.btnDays, btnDayNode)
		table.insert(self.btnDayNumBgs, btnDayNumBg)
		table.insert(self.btnDayNumTexts, btnDayNumText)
		btnDayNode:addTouchEventListener(handler(self, self.onClick_btn_day))
	end
	for i = 1, 5 do
		local btnx = SoraDFPosX(576 - (i - 1) * 128, 640)
		self.btnDays[i]:setPositionX(btnx)
		self.btnDays[i]:setPressedActionEnabled(false)
		self.btnDays[i]:setLocalZOrder(10 - i)
		_ENV = handler(self, self.onClick_btn_day)
		handler(self, self.onClick_btn_day).count = i
		self.btnDays[i]:setTitleText(i18n("common_text_523", handler(self, self.onClick_btn_day)))
		self.btnDays[i].index = i
		table.insert(self.btnDayLocks, self.btnDays[i]:getChildByName("img_lock"))
		self.btnDayLocks[i]:setVisible(false)
		local numx = SoraDFPosX(526 - (i - 1) * 128, 640)
		self.btnDayNumBgs[i]:setPositionX(numx)
		self.btnDays[i]:setTitleColor(colorDayUnSel)
	end
	local imgSel = self.btn_tab_1:getChildByName("img_sel")
	local textTb = self.btn_tab_1:getChildByName("text_tab")
	colorDayUnSel = self.btn_tab_1
	colorDayUnSel, self.btnTabs, self.btn_tab_1[1] = self.btn_tab_1, self.btn_tab_1, self.btn_tab_1
	colorDayUnSel, self.btnTabImgs, self.btn_tab_1[1] = self.btn_tab_1, self.btn_tab_1, imgSel
	self.btnTabTexts, self.btn_tab_1[1] = self.btn_tab_1, textTb
	local btnTabNumText = self.img_event_number1:getChildByName("text_event_number")
	colorDayUnSel = self.img_event_number1
	colorDayUnSel, self.btnTabNumBgs, self.img_event_number1[1] = self.img_event_number1, self.img_event_number1, self.img_event_number1
	self.btnTabNumTexts, self.img_event_number1[1] = self.img_event_number1, btnTabNumText
	for i = 2, 3 do
		local btnTabNode = self.btn_tab_1:clone()
		btnTabNode:setName("btn_tab_" .. i)
		btnTabNode:addTo(self.btn_tab_1:getParent())
		table.insert(self.btnTabs, btnTabNode)
		local imgSel = btnTabNode:getChildByName("img_sel")
		local textTb = btnTabNode:getChildByName("text_tab")
		table.insert(self.btnTabImgs, imgSel)
		table.insert(self.btnTabTexts, textTb)
		local btnTabNumNode = self.img_event_number1:clone()
		btnTabNumNode:setName("img_event_number" .. i)
		btnTabNumNode:addTo(self.img_event_number1:getParent())
		local btnTabNumText = btnTabNumNode:getChildByName("text_event_number")
		table.insert(self.btnTabNumBgs, btnTabNumNode)
		table.insert(self.btnTabNumTexts, btnTabNumText)
		btnTabNode:addTouchEventListener(handler(self, self.onClick_btn_tab))
	end
	for i = 1, 3 do
		local btnx = SoraDFPosX(531 - (i - 1) * 213, 640)
		self.btnTabs[i]:setPositionX(btnx)
		self.btnTabs[i]:setPressedActionEnabled(false)
		self.btnTabTexts[i]:setColor(colorEventUnSel)
		local imgnumx = 0
		if SoraDFIsRA() then
			imgnumx = 435 - (i - 1) * 213
		else
			imgnumx = 206 + (i - 1) * 213
		end
		self.btnTabNumBgs[i]:setPositionX(imgnumx)
		self.btnTabs[i].index = i
		self.btnTabImgs[i]:setVisible(false)
	end
	self.isInitTabs = true
end
function newKingRiseView:recycleAll()
	print("进行回收节点--------------:", #self.tbInUse)
	for i, v in ipairs(self.tbInUse) do
		v:recycleAll()
		v:setVisible(false)
		table.insert(self.tbNotUse, v)
	end
	self.tbInUse, _ENV = ipairs(self.tbInUse)
end
function newKingRiseView:initEvents(isReload)
	self:recycleAll()
	self.heightEvent = 156
	local numOfEvents = #self.eventDatas
	local totalHeight = numOfEvents * self.heightEvent
	for i = 1, numOfEvents do
		local nodeEvent = self:getEventItem()
		table.insert(self.tbInUse, nodeEvent)
	end
	local newScrollH = numOfEvents * self.heightEvent
	local scrollInner = self.Size_ScrollEvents:getInnerContainer()
	local scrollH = self.Size_ScrollEvents:getContentSize().height
	if newScrollH < scrollH then
		newScrollH = scrollH
	end
	newScrollH = newScrollH + 70
	print("newScrollH = ", newScrollH)
	self.Size_ScrollEvents:setInnerContainerSize(cc.size(scrollInner:getContentSize().width, newScrollH))
	for i, v in ipairs(self.tbInUse) do
		v.index = i
		v:setPositionY(newScrollH - i * self.heightEvent)
		v:setPositionX(0)
		local eventData = self.eventDatas[i]
		local isShowBottomLine = false
		if i == #self.tbInUse then
			isShowBottomLine = true
		end
		self:initEventItem(v, eventData, i, isShowBottomLine)
	end
	if isReload then
		self.Size_ScrollEvents:scrollToTop(0.01, false)
	end
end
function newKingRiseView:initEventItem(itemNode, eventData, index, isShowBottomLine)
	_UPVALUE0_ = nil
	;(nil).eventData = eventData
	;(nil).index = index
	;(nil).isShowBottomLine = isShowBottomLine
	;(nil).view = self
	itemNode:init(nil)
	itemNode:setScroll(self.Size_ScrollEvents)
end
function newKingRiseView:getEventItem()
	if #self.tbNotUse > 0 then
		local node = table.remove(self.tbNotUse)
		node:setVisible(true)
		print("有可复用的节点------ newKingRiseView:getEventItem()")
		return node
	else
		local newNode = self:newNode("kingRiseItem")
		newNode:setFlyTargetPos(self.btn_award:getParent():convertToWorldSpace(cc.p(self.btn_award:getPosition())))
		self.Size_ScrollEvents:addChild(newNode)
		return newNode
	end
end
function newKingRiseView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_NEW_KING_RISE_UPDATE_EVENTS", handler(self, self.sMsgUpdateEvents))
	SoraDAddMessage(self, "MESSAGE_SERVER_NEW_KING_RISE_UPDATE_REWARDS", handler(self, self.sMsgUpdateRewards))
	SoraDAddMessage(self, "MESSAGE_SERVER_NEW_KING_RISE_GET_REWARD_SUCCESS", handler(self, self.sMsgGetRewardSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_NEW_KING_RISE_ACTIVITY_CHANGE", handler(self, self.sMsgActivityChange))
end
function newKingRiseView:sMsgUpdateEvents(target, data)
	self:updateBtns()
	self:loadDayEvents(self.selDayIndex, self.selSetIndex, false)
end
function newKingRiseView:sMsgUpdateRewards(target, data)
	self:updateBtns()
	self:updateTaskPercent()
	self:updateTime()
end
function newKingRiseView:sMsgGetRewardSuccess(target, data)
	SoraDCloseLoading()
	if data.err == gErrDef.Err_None then
		self:updateTaskPercent()
		self:updateTime()
	end
end
function newKingRiseView:sMsgActivityChange(target, data)
	local activityStatus = newKingRisesCtrl:getActivityStatus()
	if activityStatus == gKingRisesActivityStatus.CALCULATE then
		self:updateTaskPercent()
	elseif activityStatus == gKingRisesActivityStatus.CLOSE then
		SoraDRemoveAllPanelFromManager()
	end
end
function newKingRiseView:onClick_btn_award(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local activityStatus = newKingRisesCtrl:getActivityStatus()
		if activityStatus ~= gKingRisesActivityStatus.CALCULATE then
			local remainEndTime = newKingRisesCtrl:getRewardQueue() and newKingRisesCtrl:getRewardQueue().timerNode.timer:getRemainTime() or 0
			_ENV = nil
			;(nil).var = SoraDConvertSecondToString(remainEndTime)
			SoraDShowMsgTip(i18n("xwjq_text_04", nil))
		else
			local curRewardNum = newKingRisesCtrl:getRewardNum()
			if 0 < curRewardNum then
				SoraDShowLoading()
				newKingRisesCtrl:reqAward()
			else
			end
		end
	end
end
function newKingRiseView:onClick_btn_shop(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("newKingExchangeAwardView")
		panel:initData(NEW_KING_RISES_AWARD_BOX)
		panel:show()
	end
end
function newKingRiseView:onClick_btn_tab(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("选中了 事件----", sender.index)
		self:didSelectTabEvent(sender.index)
	end
end
function newKingRiseView:onClick_btn_day(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnDays[sender.index].isLocked then
			SoraDShowMsgTip(i18n("common_text_2274"))
			return
		end
		print("选中了 天----", sender.index)
		self:didSelectTabDay(sender.index)
	end
end
function newKingRiseView:onClick_btn_help_tip(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("activity_des_9001110"))
	end
end
function newKingRiseView:newNode(nodeType)
	if nodeType == "kingRiseItem" then
		local kingRiseItem = include("kingRiseItem")
		if self.kingRiseItemNode == nil then
			print("第一次加载-------------kingRiseItem")
			self.kingRiseItemNode = cc.uiloader:load(getCCSPath("kingRiseItem"))
			return kingRiseItem.new(self.kingRiseItemNode)
		else
			print("克隆加载-------------kingRiseItem")
			return kingRiseItem.new(self.kingRiseItemNode:clone())
		end
	else
	end
end
function newKingRiseView:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function newKingRiseView:updateTime()
	local activityStatus = newKingRisesCtrl:getActivityStatus()
	if activityStatus == gKingRisesActivityStatus.CALCULATE then
		local remainEndTime = newKingRisesCtrl:getCloseQueue().timerNode.timer:getRemainTime()
		newKingRisesCtrl = nil
		;(nil).time = SoraDConvertSecondToString(remainEndTime)
		local enTimeStr = i18n("common_text_3721", nil)
		self.text_end_time:setString(enTimeStr)
		local curRewardNum = newKingRisesCtrl:getRewardNum()
		if curRewardNum == 0 then
			self.text_claim_time:setString(i18n("common_text_1261"))
			self.text_claim_time:setVisible(false)
			self.text_claim_time_2:setVisible(false)
			if not self.isBoxGray then
				SoraDSetGray(self.Sprite_box, true)
				self.btn_award:setTouchEnabled(false)
				self.isBoxGray = true
			end
		else
			self.text_claim_time:setVisible(true)
			self.text_claim_time_2:setVisible(false)
			self.text_claim_time:setString(i18n("common_text_1261"))
			if self.isBoxGray then
				SoraDSetGray(self.Sprite_box, false)
				self.btn_award:setTouchEnabled(false)
				self.isBoxGray = false
			end
		end
	elseif activityStatus == gKingRisesActivityStatus.CLOSE then
		self.text_claim_time:setString("")
		self.text_claim_time_2:setString("")
		self.text_end_time:setString(i18n("common_text_1859"))
	elseif activityStatus == gKingRisesActivityStatus.OPEN then
		if newKingRisesCtrl:getRewardQueue() == nil or newKingRisesCtrl:getRewardQueue().timerNode == nil then
			return
		end
		local remainCalTime = newKingRisesCtrl:getRewardQueue().timerNode.timer:getRemainTime()
		local enTimeStr = SoraDConvertSecondToString(remainCalTime)
		self.text_claim_time:setString(enTimeStr)
		newKingRisesCtrl = i18n("common_text_1859")
		i18n("common_text_1859").time = ""
		self.text_claim_time_2:setString(i18n("common_text_3722", i18n("common_text_1859")))
		newKingRisesCtrl = i18n("common_text_3722", i18n("common_text_1859"))
		i18n("common_text_3722", i18n("common_text_1859")).time = SoraDConvertSecondToString(remainCalTime)
		local enTimeStr = i18n("common_text_421", i18n("common_text_3722", i18n("common_text_1859")))
		self.text_end_time:setString(enTimeStr)
	end
end
function newKingRiseView:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function newKingRiseView:loadDay(selDayIndex, isReload)
	self.selDayIndex = selDayIndex
	self.selSetIndex = 1
	self:loadSet(self.selSetIndex, isReload)
end
function newKingRiseView:loadSet(selSetIndex, isReload)
	self.selSetIndex = selSetIndex
	self:loadDayEvents(self.selDayIndex, self.selSetIndex, isReload)
end
function newKingRiseView:loadDayEvents(selDayIndex, selSetIndex, isReload)
