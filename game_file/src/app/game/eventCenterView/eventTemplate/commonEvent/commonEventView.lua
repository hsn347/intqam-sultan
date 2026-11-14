local CommonEventView = class("commonEventView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonEventView")
	end
	return target
end)
function CommonEventView:ctor()
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_commonEventTitle")
	self.windowTitle:setTitleSize()
	self.imgHead = SoraDGetChildByName(self, "Top_Image_page")
	self.txtTitle = SoraDGetChildByName(self, "Top_Text_title")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.nodeContent = SoraDGetChildByName(self, "Node_content")
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_page")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.txtDes = SoraDGetChildByName(self, "Text_descri")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtBgTitle = SoraDGetChildByName(self, "Text_bgTitle")
	self.txtBgDes = SoraDGetChildByName(self, "Text_bgDes")
	self.txtBgDes:setTextHorizontalAlignment(SoraDFLabelR())
	SoraDGetChildByName(self, "Top_Text_title"):setString(i18n("common_text_779"))
	SoraDGetChildByName(self, "Top_Size_ImageBg"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.refreshData))
end
function CommonEventView:refreshData(target, redata)
	self:initData(self.eventID)
end
function CommonEventView:initData(eventID)
	local commonEventRead = include("commonEventRead")
	self.eventSystemInfo = clientEventMgr.getCommonEventList(eventID)
	self.eventInfo = commonEventRead.getInfoByEID(eventID)
	self.eventID = eventID
	if self.eventInfo then
		self.imgHead:loadTexture(SoraDCheckPNG(self.eventInfo.image, gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	else
		return
	end
	if self.activeTimer then
		SoraDManagerRemoveTimer(self, self.activeTimer)
		self.activeTimer = nil
	end
	self:initView()
end
function CommonEventView:initView(...)
	local publicRead = include("publicRead")
	if self.ocxItem and next(self.ocxItem) ~= nil then
		for _, v in pairs(self.ocxItem) do
			if v ~= self.imgItem then
				v:removeFromParent()
			end
		end
	end
	if SoraDGetChildByName(self.nodeHead, "Text_headDes") then
		SoraDGetChildByName(self.nodeHead, "Text_headDes"):setString(i18n(self.eventInfo.des))
	end
	self.windowTitle:setTitle(i18n(self.eventInfo.name))
	local dividH = 20
	if self.eventInfo.activity ~= "" then
		self.txtDes:setString(i18n(self.eventInfo.activity))
		self.txtDes:setPositionY(0)
	end
	local autoHeigh = SoraDGetAutoHeightLabel(self.txtDes, 500)
	self.txtTip:setString(i18n("common_text_1661"))
	self.txtTip:setPositionY(-autoHeigh - dividH)
	autoHeigh = autoHeigh + 23 + dividH * 2
	local rewardList = self.eventInfo.reward
	if 0 < #rewardList then
		self.ocxItem, _ENV = #rewardList, #rewardList
		table.insert(self.ocxItem, self.imgItem)
		if 1 < #rewardList then
			for i = 2, #rewardList do
				local item = self.imgItem:clone()
				item:addTo(self.nodeContent)
				table.insert(self.ocxItem, item)
			end
		end
		local disItems = -(#rewardList - 1) * 130 / 2
		for i, v in ipairs(self.ocxItem) do
			v:setTouchEnabled(true)
			v:setSwallowTouches(false)
			v:addTouchEventListener(handler(self, self.itemClick))
			v:setPosition(disItems, -autoHeigh - 45.0)
			v:setTag(rewardList[i])
			v:loadTexture(publicRead.getBg(rewardList[i]), ccui.TextureResType.plistType)
			v:getChildByName("Image_head"):loadTexture(publicRead.getIcon(rewardList[i]), ccui.TextureResType.plistType)
			disItems = disItems + 130
		end
		autoHeigh = autoHeigh + 90 + dividH
	else
		self.imgItem:setVisible(false)
	end
	SoraDGetChildByName(self, "Sprite_divid"):setPositionY(-autoHeigh - 9.5)
	autoHeigh = autoHeigh + 19 + dividH
	self.txtBgTitle:setString(i18n("common_text_1662"))
	self.txtBgTitle:setPositionY(-autoHeigh)
	autoHeigh = autoHeigh + 23 + dividH
	self.txtBgDes:setString(i18n(self.eventInfo.background))
	self.txtBgDes:setPositionY(-autoHeigh)
	local desHeigh = SoraDGetAutoHeightLabel(self.txtBgDes, 500)
	autoHeigh = autoHeigh + desHeigh
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, autoHeigh)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeContent:setPosition(sSize.width / 2, sH)
	if self.eventSystemInfo and next(self.eventSystemInfo) ~= nil then
		self.tableTimers, _ENV = next(self.eventSystemInfo), next(self.eventSystemInfo)
		self.timerLast = self.eventSystemInfo.otherData and self.eventSystemInfo.otherData.timerLast or ""
		self.txtTime = SoraDGetChildByName(self.nodeHead, "Text_time")
		self.imgTime = SoraDGetChildByName(self.nodeHead, "Sprite_hourGlass")
		clientEventMgr.getEventTimeString(self.eventSystemInfo.eventLeftTime, function(timefun)
			local timeLeft = clientEventMgr.getEventTimer(self.eventID)
			if timeLeft then
				_ENV = nil
				;(nil).leftTime = timeLeft.timerNode.timer:getRemainTime()
				;(nil).timeFun = timefun
				;(nil).obj = self.txtTime
				table.insert(self.tableTimers, nil)
			end
		end, function(timeMsg)
			self.imgTime:setVisible(false)
			self.txtTime:setString(timeMsg)
		end, function()
			self.imgTime:setVisible(false)
			self.txtTime:setString(i18n("common_text_699"))
		end)
		self:activeTimeUp()
		self.activeTimer = SoradCreateTimer(self, handler(self, self.activeTimeUp))
	else
		self:removeFromParent()
	end
end
function CommonEventView:itemClick(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		button:stopAllActions()
		button:runAction(cca.scaleTo(0.05, 1))
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		_UPVALUE2_ = button:getTouchBeganPosition()
		button:getTouchBeganPosition()[1] = cca.scaleTo(0.05, 1.1)
		button:getTouchBeganPosition()[2] = cca.delay(0.2)
		button:getTouchBeganPosition()[3] = cca.callFunc(function(button)
			self:openItem(button, pos)
		end)
		button:getTouchBeganPosition()[4] = cca.callFunc(function(button)
			self:openItem(button, pos)
		end)
		button:runAction(cca.seq(button:getTouchBeganPosition()))
	end
end
function CommonEventView:openItem(item, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(item:getTag())
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y + 160)
		else
			self.pFloor:setPosition(pos.x, pos.y + 160)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 160)
	else
		self.pFloor:setPosition(pos.x, pos.y + 160)
	end
	self.pFloor:addTo(self, 100)
end
function CommonEventView:activeTimeUp(dt)
	if next(self.tableTimers) ~= nil then
		for i, v in ipairs(self.tableTimers) do
			if v.leftTime and v.leftTime > 0 then
				v.leftTime = v.leftTime - 1
				if v.timeFun then
					v.obj:setString(v.timeFun(SoraDConvertSecondToString(v.leftTime)))
				else
					v.obj:setString(SoraDConvertSecondToString(v.leftTime))
				end
			else
				v.obj:setString(i18n("common_text_699"))
			end
		end
	end
end
return CommonEventView
