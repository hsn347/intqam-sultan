local publicRead = include("publicRead")
local summerPrayersShopBuy = class("summerPrayersShopBuy", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("summerPrayersShopBuy")
end)
function summerPrayersShopBuy:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.panelTouch = SoraDGetChildByName(self.node, "Panel_touch")
	self.textName = SoraDGetChildByName(self.panelTouch, "Text_name")
	self.textNotice = SoraDGetChildByName(self.panelTouch, "Text_notice")
	self.textDes = SoraDGetChildByName(self.panelTouch, "Text_des")
	self.btnBuy = SoraDGetChildByName(self.panelTouch, "Button_Buy")
	self.btnBuy:setTouchEnabled(true)
	self.btnBuy:setTitleText(i18n("common_text_1889"))
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.nodeCost = SoraDGetChildByName(self.btnBuy, "Node_Cost")
	self.textNeedPay = SoraDGetChildByName(self.nodeCost, "Text_needPay")
	self.imgGold = SoraDGetChildByName(self.nodeCost, "Image_gold")
	self.nodeCost2 = SoraDGetChildByName(self.btnBuy, "Node_Cost_2")
	self.textNeedPay2 = SoraDGetChildByName(self.nodeCost2, "Text_needPay")
	self.imgGold2 = SoraDGetChildByName(self.nodeCost2, "Image_gold")
	self.nodeCommonSlider = SoraDGetExtendChildFromCCSByName(self.panelTouch, "CCS_commonSlider_slider")
	self.nodeNext = SoraDGetChildByName(self.panelTouch, "Node_next")
	self.textNext = SoraDGetChildByName(self.nodeNext, "Text_next")
	self.textCur = SoraDGetChildByName(self.nodeNext, "Text_cur")
	self.textResTotal = SoraDGetChildByName(self.panelTouch, "Text_resTotal")
	self.nodeCommonItems = SoraDGetExtendChildFromCCSByName(self.panelTouch, "CCS_commonItems_item")
	self.textResNotice = SoraDGetChildByName(self.panelTouch, "Text_resNotice")
	SoraDGetChildByName(self, "frame_arrow"):setVisible(false)
end
function summerPrayersShopBuy:onMessageListener()
end
function summerPrayersShopBuy:initData(target, data)
end
function summerPrayersShopBuy:initExchangeData(infoData)
	local targetID = infoData.targetID
	self.textName:setString(publicRead.getName(targetID))
	self.textDes:setString(publicRead.getDes(targetID))
	publicRead = publicRead.getDes(targetID)
	publicRead.getDes(targetID).itemID = targetID
	publicRead.getDes(targetID).itemCount = huntCount
	self.nodeCommonItems:initData(publicRead.getDes(targetID))
	local exchangeInfo = infoData.exchangeInfo
	local exchangeInfo_1 = exchangeInfo[1]
	self.singCount1 = exchangeInfo_1.singCount
	if table.nums(exchangeInfo) == 1 then
		self.nodeCost2:setVisible(false)
		self.nodeCost:setPositionX(108)
	else
		local exchangeInfo_2 = exchangeInfo[2]
		self.singCount2 = exchangeInfo_2.singCount
		self.nodeCost2:setVisible(true)
		self.nodeCost:setPositionX(73)
		self.imgGold2:loadTexture(publicRead.getIcon(exchangeInfo_2.exchangeID), ccui.TextureResType.plistType)
		SoraDToCenter(self.nodeCost2, 5)
	end
	SoraDToCenter(self.nodeCost, 5)
	self.imgGold:loadTexture(publicRead.getIcon(exchangeInfo_1.exchangeID), ccui.TextureResType.plistType)
	if huntCount then
	end
	publicRead = publicRead.getIcon(exchangeInfo_1.exchangeID)
	publicRead.getIcon(exchangeInfo_1.exchangeID).maxValue = infoData.curNum
	publicRead.getIcon(exchangeInfo_1.exchangeID).minValue = 1
	publicRead.getIcon(exchangeInfo_1.exchangeID).curValue = 1
	self.nodeCommonSlider:initData((publicRead.getIcon(exchangeInfo_1.exchangeID)))
	self:exChangeUpdate(1)
	self.nodeCommonSlider:setSliderCallBack(handler(self, self.exChangeUpdate))
end
function summerPrayersShopBuy:exChangeUpdate(exChangeCount)
	self.textNeedPay:setString(string.formatnumberthousands(self.singCount1 * exChangeCount))
	if self.singCount2 then
		self.textNeedPay2:setString(string.formatnumberthousands(self.singCount2 * exChangeCount))
		SoraDToCenter(self.nodeCost2, 5)
	end
	SoraDToCenter(self.nodeCost, 5)
end
function summerPrayersShopBuy:btnBuyClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		if self.exchangeHandler then
			self.exchangeHandler(self.nodeCommonSlider:getSliderCurValue())
		end
		self:removeFromParent()
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
function summerPrayersShopBuy:msgCallBack(target, data)
end
function summerPrayersShopBuy:setExchangeHandler(handle)
	self.exchangeHandler = handle
end
function summerPrayersShopBuy:setActionData(fromPos)
	_ENV = nil
	;(nil).x = self.nodeCommonItems:getPositionX()
	self.oldPos, (nil).y = nil, self.nodeCommonItems:getPositionY()
	fromPos = self.nodeCommonItems:getParent():convertToNodeSpace(fromPos)
	self.nodeCommonItems:setPosition(fromPos)
	self.nodeCommonItems:setScale(0.5)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(0.3, 1)
	;(nil)[2] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[3] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[4] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	;(nil)[5] = cca.moveTo(0.3, self.oldPos.x, self.oldPos.y)
	self.nodeCommonItems:runAction(cca.spawn(nil))
end
return summerPrayersShopBuy
