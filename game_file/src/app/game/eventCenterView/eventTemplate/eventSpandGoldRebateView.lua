local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventSpandGoldRebateView = class("eventSpandGoldRebateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventBackGoldView")
	end
	return target
end)
function eventSpandGoldRebateView:ctor()
	self:bindBtnClose()
	_ENV = self.bindBtnClose
	self.bindBtnClose.noReach = 1
	self.bindBtnClose.reached = 2
	self.bindBtnClose.received = 3
	self.receiveStatus, self.bindBtnClose.canReceive = self.bindBtnClose, 4
	self.singleArray, _ENV, self.activityID = gActivityTimeActivityID.SPEND_GOLD_REBATE, gActivityTimeActivityID.SPEND_GOLD_REBATE, gActivityTimeActivityID.SPEND_GOLD_REBATE
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventBackGold")
	self.ccs_title:setTitle(i18n("gold_return_text_01"))
	self.ccs_title:setFontSize(24)
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeTime:setVisible(false)
	self.text_leftTime = SoraDGetChildByName(self, "Text_leftTime")
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.text_tip = SoraDGetChildByName(self, "Text_tip")
	self.text_cur = SoraDGetChildByName(self, "Text_cur")
	self.btn_help = SoraDGetChildByName(self, "Button_help")
	self.btn_help:setVisible(false)
	self.Image_eventBg = SoraDGetChildByName(self, "Image_eventBg")
	self.Image_eventBg:loadTexture(SoraDCheckPNG("bg_activity_gold_back.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.single = SoraDGetChildByName(self, "Panel_single")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rewards")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SPAND_GOLD_REBATE_REFRESH", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SPAND_GOLD_REBATE_INIT", handler(self, self.initData))
	self:addDoubleFireEffect()
	activityShowCtrl:sendSpendGoldRebate()
	SoraDShowLoading(self)
end
function eventSpandGoldRebateView:initData(target, data)
	SoraDCloseLoading(self)
	self.activityData = data.data.actData
	local total_spent_gold = self.activityData.costGold
	local lab_leftTime = i18n("common_text_2892")
	local lab_tip = i18n("gold_return_text_03")
	_ENV = nil
	;(nil).gold = total_spent_gold
	local lab_cur = i18n("common_text_2893", nil)
	self.text_leftTime:setString(lab_leftTime)
	self.text_tip:setString(lab_tip)
	self.text_cur:setString(lab_cur)
	local activityTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if activityTime then
		self.nodeTime:setVisible(true)
		self.text_time:beginTime(activityTime.timerNode.timer:getRemainTime())
		self.text_time:setPositionX(-self.text_leftTime:getContentSize().width - 10)
		if not SoraDFIsRA() then
			self.text_time:setPositionX(self.text_leftTime:getContentSize().width + 10)
		end
	end
	self:initScroll()
end
function eventSpandGoldRebateView:getBackGoldInfo()
	local actInfo = activityShowCtrl:getShowDataByID(self.activityID)
	local nums = table.nums(actInfo.param)
	local activityShowCtrl, backInfo = actInfo.param, actInfo.param
	for i = 1, nums do
		table.insert(backInfo, actInfo.param[tostring(i)])
	end
	return backInfo
end
function eventSpandGoldRebateView:initScroll()
	local actInfo = activityShowCtrl:getShowDataByID(gActivityTimeActivityID.SPEND_GOLD_REBATE)
	local backGoldInfo = self:getBackGoldInfo()
	local initOffsetY = 30
	local singleHeight = self.single:getContentSize().height + 45
	local scrollH = math.max(self.scroll:getContentSize().height, singleHeight * table.nums(backGoldInfo))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH + initOffsetY))
	local initPosX = 36
	if not SoraDFIsRA() then
		initPosX = 560
	end
	local totalNum = #backGoldInfo
	for k, v in ipairs(backGoldInfo) do
		self.singleArray[k] = self:getSingle()
		self.singleArray[k]:setTag(k)
		self.singleArray[k]:setPosition(cc.p(initPosX, scrollH - (totalNum - k + 1) * singleHeight))
		self.singleArray[k]:setLocalZOrder(table.nums(backGoldInfo) - k)
		self.singleArray[k]:addTo(self.scroll)
	end
	self:refreshView()
end
function eventSpandGoldRebateView:refreshView(target, data)
	local backGoldInfo = self:getBackGoldInfo()
	local total_spent_gold = self.activityData.costGold
	local lastNeedGold = 0
	self.reachedIndex = -1
	local singleSize = #self.singleArray
	for k, v in ipairs(self.singleArray) do
		local isShowLine = false
		local status = self.receiveStatus.noReach
		local percent = 0
		if total_spent_gold >= backGoldInfo[k].needGold then
			status = self.receiveStatus.received
			percent = 100
			lastNeedGold = backGoldInfo[k].needGold
			isShowLine = true
		elseif self.reachedIndex == -1 then
			status = self.receiveStatus.noReach
			self.reachedIndex = k
			percent = (total_spent_gold - lastNeedGold) / (backGoldInfo[k].needGold - lastNeedGold) * 100
			percent = (total_spent_gold - lastNeedGold) / (backGoldInfo[k].needGold - lastNeedGold)
			print("111", percent, total_spent_gold, lastNeedGold, backGoldInfo[k].needGold)
		else
			percent = 0
		end
		if k == singleSize then
			isShowLine = false
		end
		_ENV = total_spent_gold
		total_spent_gold.gold1 = backGoldInfo[k].needGold
		total_spent_gold.gold2 = backGoldInfo[k].rebate
		v.setDes(i18n("gold_return_text_02", total_spent_gold))
		v.setPoint(backGoldInfo[k].needGold)
		v.setPointPercent(percent)
		v.setConnectLine(k ~= table.nums(backGoldInfo), isShowLine)
		v.setStatus(status)
	end
	self:offsetScroll()
end
function eventSpandGoldRebateView:offsetScroll()
	local curIndex = self.reachedIndex
	local singleHeight = self.single:getContentSize().height + 45
	local backGoldInfo = self:getBackGoldInfo()
	local initOffsetY = 30
	if 0 < curIndex and self.singleArray[curIndex] then
		local num = math.floor(self.scroll:getContentSize().height / singleHeight)
		if curIndex > table.nums(backGoldInfo) - num then
			self.scroll:jumpToTop()
		else
			local singleY = self.singleArray[curIndex]:getPositionY()
			local inner = self.scroll:getInnerContainer()
			local offsetY = -singleY + initOffsetY
			inner:setPositionY(offsetY)
		end
	else
		self.scroll:jumpToBottom()
	end
end
function eventSpandGoldRebateView:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_2896"))
	end
end
function eventSpandGoldRebateView:addDoubleFireEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 48
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 78
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 33
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 48
	local param
	local parNode1 = SoraDCreateEffectNode(param)
	parNode1:addTo(SoraDGetChildByName(self, "frame_lace_base_1"), -2)
	local parNode2 = SoraDCreateEffectNode(param)
	parNode2:addTo(SoraDGetChildByName(self, "frame_lace_base_2"), -2)
end
function eventSpandGoldRebateView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function eventSpandGoldRebateView:getSingle()
	local single = self.single:clone()
	local btn = single:getChildByName("Button_receive")
	local gold = single:getChildByName("Image_gold")
	local img_line_bg = single:getChildByName("Image_line_bg")
	local img_line = single:getChildByName("Image_line")
	local img_point = SoraDGetChildByName(single, "Image_point")
	btn:setTouchEnabled(false)
	local Text_des = single:getChildByName("Text_des")
	local Text_point = single:getChildByName("Text_point")
	function single.setHandler(handler)
		btn:setTouchEnabled(true)
		btn:addTouchEventListener(handler)
	end
	function single.setDes(des)
		local des = des or ""
		Text_des:setString(des)
	end
	function single.setPoint(point)
		local point = point or 0
		Text_point:setString(point)
	end
	function single.setPointPercent(percent)
		local percent = percent or 0
		local Panel_point = single:getChildByName("Panel_point")
		local realHeight = 91 * percent
		Panel_point:setContentSize(cc.size(91, realHeight))
	end
	function single.setConnectLine(isBgVisible, isLineVisible)
		local isBgVisible = isBgVisible or false
		local isLineVisible = isLineVisible or false
		img_line_bg:setVisible(isBgVisible)
		img_line:setVisible(isLineVisible)
	end
	function single.setStatus(status)
		local status = status or self.receiveStatus.noReach
		local got = single:getChildByName("Image_got")
		local panel_got = single:getChildByName("Panel_got")
		if status == self.receiveStatus.noReach then
			gold:getVirtualRenderer():setState(0)
			panel_got:setVisible(false)
			got:setVisible(false)
			Text_des:setColor(cc.c3b(255, 255, 255))
			Text_point:setColor(cc.c3b(240, 180, 20))
		elseif status == self.receiveStatus.reached then
			gold:getVirtualRenderer():setState(0)
			panel_got:setVisible(true)
			got:setVisible(false)
			Text_des:setColor(cc.c3b(255, 255, 255))
			Text_point:setColor(cc.c3b(75, 215, 55))
		elseif status == self.receiveStatus.received then
			panel_got:setVisible(true)
			got:setVisible(true)
			Text_des:setColor(cc.c3b(75, 215, 55))
			Text_point:setColor(cc.c3b(75, 215, 55))
		end
	end
	function single.addEffect()
		single.effectnode = display.newNode()
		single.effectnode:setLocalZOrder(99)
		single.effectnode:setPosition(cc.p(475, 35))
		if not SoraDFIsRA() then
			single.effectnode:setPosition(cc.p(15, 35))
		end
		single.effectnode:setScale(1.1375)
		single.effectnode:addTo(single)
		local dh_rotate_1 = display.newSprite("#dh_gold_rotate.png")
		dh_rotate_1:addTo(single.effectnode, 1)
		dh_rotate_1:runAction(cc.RepeatForever:create(cca.rotateBy(2.0, 360)))
		local dh_rotate_2 = display.newSprite("#dh_gold_rotate.png")
		dh_rotate_2:setRotation(-180)
		dh_rotate_2:addTo(single.effectnode, 1)
		dh_rotate_2:runAction(cc.RepeatForever:create(cca.rotateBy(2.0, 360)))
		single, single = dh_rotate_2, dh_rotate_2.runAction
		single, dh_rotate_2.runAction[1], dh_rotate_2.plist = dh_rotate_2, dh_rotate_2, "et_jinbituchulailizi01.plist"
		dh_rotate_2.plist = "et_jinbituchulailizi02.plist"
		single, dh_rotate_2.runAction[2], dh_rotate_2.scale = dh_rotate_2, dh_rotate_2, 0.85
		single, dh_rotate_2.plist = cc.RepeatForever:create(cca.rotateBy(2.0, 360))
		cc.RepeatForever:create(cca.rotateBy(2.0, 360)).x = -0.9
		dh_rotate_2.scale, cc.RepeatForever:create(cca.rotateBy(2.0, 360)).y = cc.RepeatForever:create(cca.rotateBy(2.0, 360))
		single, dh_rotate_2.runAction[3], dh_rotate_2.rotate = dh_rotate_2, dh_rotate_2, 215.85
		single, dh_rotate_2.plist = cc.RepeatForever:create(cca.rotateBy(2.0, 360))
		cc.RepeatForever:create(cca.rotateBy(2.0, 360)).x = -0.9
		dh_rotate_2.scale, cc.RepeatForever:create(cca.rotateBy(2.0, 360)).y = cc.RepeatForever:create(cca.rotateBy(2.0, 360))
		dh_rotate_2.runAction[4], dh_rotate_2.rotate = dh_rotate_2, 30.38
		local param_bg = dh_rotate_2.runAction
		local et_node_bg = SoraDCreateEffectNode(param_bg)
		et_node_bg:addTo(single.effectnode, 2)
		_UPVALUE6_ = et_node_bg
		et_node_bg[1] = cca.scaleTo(0.4, 1.25)
		et_node_bg[2] = cca.scaleTo(0.4, 1)
		et_node_bg[3] = cca.scaleTo(0.2, 1.15)
		et_node_bg[4] = cca.scaleTo(0.2, 1)
		et_node_bg[5] = cca.scaleTo(0.1, 1.05)
		et_node_bg[6] = cca.scaleTo(0.1, 1)
		et_node_bg[7] = cca.delay(2)
		et_node_bg[8] = cca.delay(2)
		local seq = cca.seq(et_node_bg)
		gold:runAction(cc.RepeatForever:create(seq))
	end
	function single.removeEffect()
		gold:stopAllActions()
		gold:setScale(1)
		if single.effectnode then
			single.effectnode:removeFromParent()
			single.effectnode = nil
		end
	end
	function single.setGray()
		local Image_single_points = SoraDGetChildByName(single, "Image_single_points")
		local Image_single_bg = SoraDGetChildByName(single, "Image_single_bg")
		gold:getVirtualRenderer():setState(1)
		Image_single_points:getVirtualRenderer():setState(1)
		Image_single_bg:getVirtualRenderer():setState(1)
		img_point:getVirtualRenderer():setState(1)
		img_line:getVirtualRenderer():setState(1)
	end
	function single.setNormal()
		local Image_single_points = SoraDGetChildByName(single, "Image_single_points")
		local Image_single_bg = SoraDGetChildByName(single, "Image_single_bg")
		gold:getVirtualRenderer():setState(0)
		Image_single_points:getVirtualRenderer():setState(0)
		Image_single_bg:getVirtualRenderer():setState(0)
		img_point:getVirtualRenderer():setState(0)
		img_line:getVirtualRenderer():setState(0)
	end
	return single
end
return eventSpandGoldRebateView
