local baseComponent = require("fgui.base.baseComponent")
local Com_WHV_ownCounter = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWarHall/Com_WHV_ownCounter", Com_WHV_ownCounter)
local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
function Com_WHV_ownCounter:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
	self.data, _ENV = self.fixChildrenPos, self.fixChildrenPos
	self.fields.btnRefresh:addClickEventListener(handler(self, self.btnRefeshClickCallBack))
	self.fields.btnTop:addClickEventListener(handler(self, self.btnTopClickCallBack))
	self.fields.btnDel:addClickEventListener(handler(self, self.btnDelClickCallBack))
	self.fields.imgBg:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchBegin))
	self.fields.imgBg:addEventListener(fgui.UIEventType.TouchMove, handler(self, self.onTouchMove))
	self.fields.imgBg:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
end
function Com_WHV_ownCounter:onShow()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_COUNTER_LIST_TOUCH", function(...)
		if self.isOpen then
			self:changeSingleType(false)
		end
	end)
end
function Com_WHV_ownCounter:initData(data, type, index)
	self.data = data
	self.dataType = type
	self.fields.nodeHead:setHeadSprite(self.data.iconID, self.data.avatar)
	self.fields.labelIndex:setString(tostring(index))
	if self.data.abbr and self.data.abbr ~= "" then
		_ENV = tostring(index)
		tostring(index).abbr = self.data.abbr
		tostring(index).name = self.data.nickName
		self.fields.labelName:setString(i18n("common_text_186", tostring(index)))
	else
		self.fields.labelName:setString(self.data.nickName)
	end
	_ENV = i18n("common_text_186", tostring(index))
	i18n("common_text_186", tostring(index)).num = string.formatnumberthousands(self.data.hostile)
	self.fields.labelPoint:setString(i18n("CounterSystem_text_14", i18n("common_text_186", tostring(index))))
	if self.dataType == 2 then
		if self.data.isTop then
			self.fields.btnTop:setIcon("icon_qxzd.png")
			self.controllers.c1:setSelectedIndex(1)
		else
			self.fields.btnTop:setIcon("icon_zd.png")
			self.controllers.c1:setSelectedIndex(0)
		end
		self.fields.spriteRed:setVisible(false)
		_ENV = i18n("CounterSystem_text_14", i18n("common_text_186", tostring(index)))
		i18n("CounterSystem_text_14", i18n("common_text_186", tostring(index))).num = string.formatnumberthousands(self.data.attackTimes)
		self.fields.labelPro:setString(i18n("CounterSystem_text_22", i18n("CounterSystem_text_14", i18n("common_text_186", tostring(index)))))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.spriteRed:setVisible(allianceCounterSysCtrl:checkNewPoint(self.data.uid))
		_ENV = allianceCounterSysCtrl:checkNewPoint(self.data.uid)
		allianceCounterSysCtrl:checkNewPoint(self.data.uid).num1 = string.formatnumberthousands(self.data.completedPower)
		allianceCounterSysCtrl:checkNewPoint(self.data.uid).num2 = string.formatnumberthousands(self.data.targetPower)
		self.fields.labelPro:setString(i18n("CounterSystem_text_15", allianceCounterSysCtrl:checkNewPoint(self.data.uid)))
	end
	self.isOpen = false
	self:stopAllActions()
	self:setPositionX(0)
	self.curPos = allianceCounterSysCtrl:checkCanUpdate(self.data.uid, self.dataType)
	if self.curPos and (self.curPos.x ~= self.data.coordinate.x or self.curPos.y ~= self.data.coordinate.y) then
		self.fields.btnRefresh:setVisible(true)
	else
		self.fields.btnRefresh:setVisible(false)
	end
end
function Com_WHV_ownCounter:setScroll(scroll)
	self.scroll = scroll
end
function Com_WHV_ownCounter:btnDelClickCallBack(button, type)
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("CounterSystem_text_25"), i18n("common_text_204"), nil, function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			allianceCounterSysCtrl:delPersonalEnemy(self.data.uid)
			SoraDShowLoading()
		end
		self:changeSingleType(false)
	end)
end
function Com_WHV_ownCounter:btnTopClickCallBack(button, type)
	SoraDPlaySound()
	allianceCounterSysCtrl:topPersonalEnemy(self.data.uid)
	self:changeSingleType(false)
	SoraDShowLoading()
end
function Com_WHV_ownCounter:btnRefeshClickCallBack(button, type)
	SoraDPlaySound()
	allianceCounterSysCtrl:updateEnemyPos(self.data.uid, self.dataType, self.curPos)
	self.fields.btnRefresh:setVisible(false)
end
function Com_WHV_ownCounter:onTouchBegin(eventContext)
	self.beganPosX = self:getPositionX()
	self.touchBeginPos = eventContext:getInput():getPosition()
	self.isMoveV = false
	self.isMoveH = false
	self.fields.imgBg:setSwallowTouches(false)
	_ENV = self.fields.imgBg
	self.fields.imgBg.msg = "MESSAGE_ALLIANCE_COUNTER_LIST_TOUCH"
	SoraDSendMessage(self.fields.imgBg)
	if eventContext.CaptureTouch then
		eventContext:CaptureTouch()
	elseif eventContext.captureTouch then
		eventContext:captureTouch()
	end
end
function Com_WHV_ownCounter:onTouchMove(eventContext)
	local touchBeganPoint = self.touchBeginPos
	local touchMovePoint = eventContext:getInput():getPosition()
	local distance = cc.pGetDistance(touchBeganPoint, touchMovePoint)
	print("Com_WHV_ownCounter:onTouchMove", distance)
	if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
		self.singleIsMoved = true
		if self.dataType == 2 then
			local deltaX = touchMovePoint.x - touchBeganPoint.x
			local deltaY = touchMovePoint.y - touchBeganPoint.y
			print("deltaX,deltaY", deltaX, deltaY)
			if math.abs(deltaY) > TOUCH_MOVED_ERROR_VALUE then
				self.isMoveV = true
			end
			if not self.isMoveV then
				if SoraDFIsRA() and deltaX > TOUCH_MOVED_ERROR_VALUE or self.beganPosX > 0 and deltaX < TOUCH_MOVED_ERROR_VALUE then
					self.isMoveH = true
					self.fields.imgBg:setSwallowTouches(true)
				elseif deltaX < -TOUCH_MOVED_ERROR_VALUE or self.beganPosX < 0 and deltaX > TOUCH_MOVED_ERROR_VALUE then
					self.isMoveH = true
					self.fields.imgBg:setSwallowTouches(true)
				end
			end
			if self.isMoveH then
				local posX = SoraDFIsRA() and math.min(179, math.max(self.beganPosX + deltaX, 0)) or math.max(-179, math.min(self.beganPosX + deltaX, 0))
				self:setPositionX(posX)
			end
		end
	end
end
function Com_WHV_ownCounter:onTouchEnd(eventContext)
	if self.singleIsMoved then
		self:updateSingleType()
		self.singleIsMoved = false
		return
	end
	SoraDPlaySound()
	local panel
	if self.dataType == 1 then
		panel = uiManager:show("allianceCounterInfoView").view
		panel:initData(self.data)
		allianceCounterSysCtrl:readPointByUid(self.data.uid)
		self.fields.spriteRed:setVisible(false)
	else
		if self.isOpen then
			return
		end
		panel = uiManager:show("allianceOwnCounterInfoView").view
		panel:initData(self.data)
	end
end
function Com_WHV_ownCounter:updateSingleType()
	self.fields.imgBg:setSwallowTouches(false)
	local curPosX = self:getPositionX()
	_UPVALUE2_ = false
	;(false)[1] = self.isOpen
	;(false)[2] = curPosX
	dump(false, "self.isOpen,curPosX")
	if self.isOpen then
		if SoraDFIsRA() and curPosX < 140 or not SoraDFIsRA() and -140 < curPosX then
			self:changeSingleType(false)
		else
			self:changeSingleType(true)
		end
	elseif SoraDFIsRA() and 50 < curPosX or not SoraDFIsRA() and curPosX < -50 then
		self:changeSingleType(true)
	else
		self:changeSingleType(false)
	end
end
function Com_WHV_ownCounter:changeSingleType(toOpen)
	if toOpen then
		SoraDConfigSet("Game:Guide:allianceCounterSys~bool", false)
		_ENV = "Game:Guide:allianceCounterSys~bool"
		;("Game:Guide:allianceCounterSys~bool").msg = "MESSAGE_ALLIANCE_COUNTER_LIST_MOVE"
		SoraDSendMessage("Game:Guide:allianceCounterSys~bool")
		self:stopAllActions()
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.moveTo(0.1, SoraDFIsRA() and 179 or -179, self:getPositionY())
		;(nil)[2] = ffa.callFunc(function(...)
			self.isOpen = true
		end)
		;(nil)[3] = ffa.callFunc(function(...)
			self.isOpen = true
		end)
		;(nil)[4] = ffa.callFunc(function(...)
			self.isOpen = true
		end)
		;(nil)[5] = ffa.callFunc(function(...)
			self.isOpen = true
		end)
		self:runAction(ffa.seq(nil))
	else
		self:stopAllActions()
		_UPVALUE1_ = ffa.seq(nil)
		ffa.seq(nil)[1] = ffa.moveTo(0.1, 0, self:getPositionY())
		ffa.seq(nil)[2] = ffa.callFunc(function(...)
			self.isOpen = false
		end)
		ffa.seq(nil)[3] = ffa.callFunc(function(...)
			self.isOpen = false
		end)
		ffa.seq(nil)[4] = ffa.callFunc(function(...)
			self.isOpen = false
		end)
		ffa.seq(nil)[5] = ffa.callFunc(function(...)
			self.isOpen = false
		end)
		self:runAction(ffa.seq(ffa.seq(nil)))
	end
end
function Com_WHV_ownCounter:onHide()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
return Com_WHV_ownCounter
