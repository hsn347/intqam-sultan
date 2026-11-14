local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local questionnaireCtrl = SoraDGetCtrl("questionnaireCtrl")
local questionnaireView = class("questionnaireView", function(target)
	return target or SoraDCreateTouchPanel("questionnaireView")
end)
function questionnaireView:ctor(properties)
	SoraDDeviceFitOffset(self)
	self.canClick = true
	self.awardArray, _ENV, self.chooseIndex = SoraDDeviceFitOffset, SoraDDeviceFitOffset, 1
	self.nodeOut = SoraDGetChildByName(self, "Node_Center_Out")
	self.posCneterY = self.nodeOut:getPositionY()
	self.textTipsOut = SoraDGetChildByName(self.nodeOut, "Text_Tips")
	self.textNameOut = SoraDGetChildByName(self.nodeOut, "Text_Name")
	self.nodeAwardOut = SoraDGetChildByName(self.nodeOut, "Node_Award")
	self.textMoreOut = SoraDGetChildByName(self.nodeOut, "Text_More")
	self.textMoreOut = SoraDChangeTextToHtml(self.textMoreOut)
	self.textMoreOut:setTouchEnabled(true)
	_ENV = nil
	_ENV, _ENV, (nil).name = "common_text_486", i18n("common_text_486"), i18n("common_text_486")
	;("common_text_486").u = "true"
	i18n("common_text_486").name, ("common_text_486").c = "common_text_486", "true"
	self.textMoreOut:setString(i18n_html("common_text_035", nil, (i18n("common_text_486"))))
	self.textMoreOut:setTag(1)
	self.textMoreOut:addTouchEventListener(handler(self, self.btnTextMoreClick))
	self.btnLookOut = SoraDGetChildByName(self.nodeOut, "Button_Look")
	self.btnLookOut:setTitleText(i18n("common_text_678"))
	self.btnLookOut:addTouchEventListener(handler(self, self.btnLookClick))
	self.nodeShow = SoraDGetChildByName(self, "Node_Center_Show")
	self.textTipsShow = SoraDGetChildByName(self.nodeShow, "Text_Tips")
	self.textNameShow = SoraDGetChildByName(self.nodeShow, "Text_Name")
	self.nodeAwardShow = SoraDGetChildByName(self.nodeShow, "Node_Award")
	self.textMoreShow = SoraDGetChildByName(self.nodeShow, "Text_More")
	self.textMoreShow = SoraDChangeTextToHtml(self.textMoreShow)
	self.textMoreShow:setTouchEnabled(true)
	_ENV = handler(self, self.btnLookClick)
	_ENV, _ENV, handler(self, self.btnLookClick).name = "common_text_486", i18n("common_text_486"), i18n("common_text_486")
	;("common_text_486").u = "true"
	i18n("common_text_486").name, ("common_text_486").c = "common_text_486", "true"
	self.textMoreShow:setString(i18n_html("common_text_035", handler(self, self.btnLookClick)))
	self.textMoreShow:setTag(1)
	self.textMoreShow:addTouchEventListener(handler(self, self.btnTextMoreClick))
	self.btnLookShow = SoraDGetChildByName(self.nodeShow, "Button_Look")
	self.btnLookShow:setTitleText(i18n("common_text_678"))
	self.btnLookShow:addTouchEventListener(handler(self, self.btnLookClick))
	self.btnLeft = SoraDGetChildByName(self, "Button_Left")
	self.btnLeft:addTouchEventListener(handlerEx(self, self.btnChangeClick, -1))
	self.btnRight = SoraDGetChildByName(self, "Button_Right")
	self.btnRight:addTouchEventListener(handlerEx(self, self.btnChangeClick, 1))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.scrollAward = SoraDGetChildByName(self.nodeAward, "ScrollView_Award")
	self.scrollAward = include("commonAutoScrollList").new(self.scrollAward)
	self.scrollAward:setSingleCreate(handler(self, self.createSingle))
	self.scrollAward:setSingleRefresh(handler(self, self.refreshSingle))
	self.panelSize = SoraDGetChildByName(self, "Panel_Size")
	self.panelSize:setTag(2)
	self.panelSize:addTouchEventListener(handler(self, self.btnTextMoreClick))
	self.nodeAward:setVisible(false)
	self.panelSize:setVisible(false)
	self.textTipsShow:setString(i18n("questnaire_text_01"))
	self.textTipsOut:setString(i18n("questnaire_text_01"))
	SoraDCreateTimerEx(self, handler(self, self.updateTimeCall), 60)
	self:updateTimeCall()
end
function questionnaireView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_QUESTIONNAIRE_REFRESH", handler(self, self.initData))
end
function questionnaireView:initData()
	SoraDCloseLoading(self)
	self.totalNum = questionnaireCtrl:getReceiveStatusAndNum()
	if self.chooseIndex > self.totalNum or self.chooseIndex < 1 then
		self.chooseIndex = 1
	end
	if self.totalNum == 0 then
		self:close(self, ccui.TouchEventType.ended)
		return
	elseif self.totalNum == 1 then
		self.btnLeft:setVisible(false)
		self.btnRight:setVisible(false)
	end
	self.chooseID = questionnaireCtrl:getDataByIndexAndKey(self.chooseIndex, "id")
	print("questionnaireView:initDat", self.chooseID, self.chooseIndex)
	if not self.chooseID then
		self:close(self, ccui.TouchEventType.ended)
		return
	end
	self:setAward(self.nodeAwardShow)
	local name = i18n(questionnaireCtrl:getDataByIndexAndKey(self.chooseIndex, "name"))
	self.textNameShow:setString(name)
	_ENV = name
	name.id = self.chooseID
	name.title = name
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_question, name)
	self:startTimer()
end
function questionnaireView:createSingle(single, data)
	local single = display.newNode()
	local item = SoraDCreatePanel("commonItemAward")
	item:setName("item")
	item:addTo(single)
	item:setPosition(45, 45)
	item:setScale(0.85)
	item:setOwnView(self)
	return single
end
function questionnaireView:refreshSingle(single, data)
	local item = single:getChildByName("item")
	item:initData(data.id, data.num)
end
function questionnaireView:startTimer()
	self:stopTimer()
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
end
function questionnaireView:stopTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
	end
	self.timer = nil
	self.time = 0
end
function questionnaireView:btnLookClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		local redirect = questionnaireCtrl:getDataByIndexAndKey(self.chooseIndex, "redirect")
		local strTbl = SoraDStringSplit(redirect.link, "\"")
		dump(strTbl)
		local url = string.gsub(strTbl[4], "\\", "")
		print("url...", url)
		if device.platform == "mac" then
			device.openURL(url)
		else
			userSDKManager.openSDKLink(url)
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function questionnaireView:btnChangeClick(param, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local tag = target:getTag()
		if self.canClick then
			SoraDPlaySound()
			self.time = 0
			self.canClick = false
			self.chooseIndex = self.chooseIndex + param * 1
			if self.chooseIndex < 1 then
				self.chooseIndex = self.chooseIndex + self.totalNum
			elseif self.chooseIndex > self.totalNum then
				self.chooseIndex = self.chooseIndex - self.totalNum
			end
			self.chooseID = questionnaireCtrl:getDataByIndexAndKey(self.chooseIndex, "id")
			self.textNameOut:setString(i18n(questionnaireCtrl:getDataByIndexAndKey(self.chooseIndex, "name")))
			self:setAward(self.nodeAwardOut)
			self.nodeOut:setPosition(320 + param * 640, self.posCneterY)
			self.nodeOut:setVisible(true)
			transition.execute(self.nodeOut, cca.moveTo(0.2, 320, self.posCneterY))
			_ENV = 0.2
			;(0.2).onComplete = function()
				self.nodeOut, self.nodeShow = self.nodeShow, self.nodeOut
				self.textNameOut, self.textNameShow = self.textNameShow, self.textNameOut
				self.nodeAwardOut, self.nodeAwardShow = self.nodeAwardShow, self.nodeAwardOut
				self.textMoreOut, self.textMoreShow = self.textMoreShow, self.textMoreOut
				self.nodeOut:setVisible(false)
			end
			transition.execute(self.nodeShow, cca.moveTo(0.2, 320 - param * 640, self.posCneterY), 0.2)
			_ENV = 0.2
			;(0.2).delay = 0.2
			;(0.2).onComplete = function()
				self.canClick = true
			end
			transition.execute(self, nil, 0.2)
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function questionnaireView:setAward(parent, array)
	local reward = questionnaireCtrl:getDataByIndexAndKey(self.chooseIndex, "rewards")
	local realNum = #reward
	local num = realNum < 6 and realNum or 6
	local questionnaireCtrl, array = "rewards", "rewards"
	parent:removeAllChildren()
	for i = 1, 6 do
		if not array[i] then
			array[i] = include("commonItemAward").new()
			array[i]:setScale(0.8)
			array[i]:setPosition(0, 0)
			array[i]:setOwnView(self)
			array[i]:addTo(parent)
		end
		if array[i] then
			if i <= realNum then
				array[i]:initData(reward[i].id, reward[i].num)
			end
			array[i]:setVisible(i <= realNum)
		end
	end
	SoraDautoSortPos(parent, 3, 1, cc.size(90, 90), not SoraDFIsRA())
	questionnaireCtrl = not SoraDFIsRA()
	;(not SoraDFIsRA()).scroll = self.scrollAward
	;(not SoraDFIsRA()).view = self
	self.scrollAward:updateScrollView(cc.size(100, 95), reward, 5, not SoraDFIsRA())
end
function questionnaireView:btnTextMoreClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("显示奖励")
		local tag = target:getTag()
		if tag == 1 then
			self:stopTimer()
			self.panelSize:setVisible(true)
			self.nodeAward:setVisible(true)
		else
			self:startTimer()
			self.panelSize:setVisible(false)
			self.nodeAward:setVisible(false)
		end
	end
end
function questionnaireView:openTimeUp(dt)
	if self.totalNum <= 1 then
		return
	end
	self.time = self.time + dt
	if self.time >= 5 and self.totalNum >= 2 then
		if SoraDFIsRA() then
			self:btnChangeClick(-1, self.btnLeft, ccui.TouchEventType.ended)
		else
			self:btnChangeClick(1, self.btnRight, ccui.TouchEventType.ended)
		end
	end
end
function questionnaireView:updateTimeCall(dt)
	SoraDShowLoading(self)
	questionnaireCtrl:reqGetQuestData()
end
return questionnaireView
