local HeroEscapeQueueSingle = class("heroEscapeQueueSingle", function(target)
	local targetType = type(target)
	if targetType == "nil" then
		return SoraDCreateBasePanel("heroEscapeQueueSingle")
	elseif targetType == "userdata" then
		return SoraDCreateCloneBasePanel(target, "heroEscapeQueueSingle")
	else
		return target
	end
end)
function HeroEscapeQueueSingle:ctor()
	self.handle = nil
	self.singleIsMoved = false
	self.heroHead = SoraDGetExtendChildFromCCSByName(self, "CCS_heroEscapeItem_head")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_loadBar")
	self.txtLoadBar = SoraDGetChildByName(self, "Text_loadBar")
	self.txtLoadBar = SoraDCreateTimerLabel(self, self.txtLoadBar)
	self.btnSpeed = SoraDGetChildByName(self, "Button_speed")
	self.btnSpeed:setTitleText(i18n("common_text_018"))
	self.txtState = SoraDGetChildByName(self, "Text_state")
	self.btnSpeed:addTouchEventListener(handler(self, self.btnSpeedClick))
	self.btnPanel = SoraDGetChildByName(self, "Panel_single")
	self.btnPanel:setSwallowTouches(false)
	self.btnPanel:addTouchEventListener(handler(self, self.btnPanelClick))
end
function HeroEscapeQueueSingle:setHandle(handle)
	self.handle = handle
end
function HeroEscapeQueueSingle:setScroll(scroll)
	self.scroll = scroll
end
function HeroEscapeQueueSingle:initData(queue)
	self.myQueue = queue
	self.heroInfo = self.myQueue:getFrom().heroInfo[1]
	self:initView()
end
function HeroEscapeQueueSingle:initView(...)
	local total, cur = self.myQueue:getOrgStatusTotalTime(), self.myQueue:getStatusRemainTime()
	self.txtLoadBar:setTimeLast(function(time, ticket)
		self.loadingBar:setPercent((total - ticket) / total * 100)
		return time
	end)
	self.txtLoadBar:beginTime(math.floor(cur))
	self.heroHead:initData(self.heroInfo)
	if gHeroReturnQueueTyep.ESCAPE == self.heroInfo.escapeType then
		self.txtState:setString(i18n("hero_text_35"))
	elseif gHeroReturnQueueTyep.RELEASE == self.heroInfo.escapeType then
		self.txtState:setString(i18n("hero_text_36"))
	end
end
function HeroEscapeQueueSingle:btnPanelClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if not worldMapDefine.checkCurrentKingdomIsMyKingdom() then
			return
		end
		if self.myQueue:getEventType() == gMapEventTypeDef.mapEventTypeMapInstance then
			SoraDGotoWorldMapPoint(cc.p(self.myQueue:getToX(), self.myQueue:getToY()), true)
		elseif self.myQueue:isWorking() then
			SoraDGotoWorldMoveLine(self.myQueue:getMainId() or self.myQueue:getId())
		else
			SoraDGotoWorldMoveLine(self.myQueue:getId())
		end
		if self.handle then
			self.handle()
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function HeroEscapeQueueSingle:btnSpeedClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local troopID = self.myQueue:getId()
		print("troopID = ", troopID)
		_ENV = "troopID = "
		;("troopID = ").msg = "MESSAGE_WORLD_MAP_HEROQUEUE_SPEED_OUT"
		SoraDSendMessage("troopID = ")
		local panel = SoraDCreatePanel("speedUpReCallBuyPopView")
		_ENV = nil
		;(nil).troopsID = troopID
		panel:initData(gItemType.MARCH_SPEED_UP, nil)
		panel:show()
	end
end
return HeroEscapeQueueSingle
