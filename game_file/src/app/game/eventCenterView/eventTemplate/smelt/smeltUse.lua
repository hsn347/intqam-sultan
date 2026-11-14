local gametop = gModuleMgr.getObject("gametop")
local smeltRead = include("smeltRead")
local publicRead = include("publicRead")
local smeltUse = class("smeltUse", function(target)
	return target
end)
local smeltCtrl = SoraDGetCtrl("smeltCtrl")
local longActTag = 100
local longEventTime = 0.5
local spaceTime = 0.15
function smeltUse:ctor()
	_UPVALUE10_, self.needResCount = nil, nil
	self.curValueNums, (nil)[1] = nil, 1
	self.curValueNums, (nil)[2] = nil, 2
	self.curValueNums, (nil)[3] = nil, 3
	self.curValueNums, (nil)[4] = nil, 4
	self.curValueNums, (nil)[5] = nil, 5
	self.curValueNums, (nil)[6] = nil, 6
	self.curValueNums, (nil)[7] = nil, 7
	self.curValueNums, (nil)[8] = nil, 8
	self.curValueNums, (nil)[9] = nil, 9
	self.curValueNums, (nil)[10] = nil, 10
	self.btnUse = SoraDGetChildByName(self, "Button_receive")
end
function smeltUse:setHandle(handle)
	self.handle = handle
end
function smeltUse:setLabelHandle(handle)
	self.labelHandle = handle
end
function smeltUse:sliderCallBack(value)
	self.curValue = value
	self:refreshView()
end
function smeltUse:updateView(btnUse)
	self.btnUse = btnUse
	self.maxRound = smeltCtrl:getMaxRound()
	self.curRound = smeltCtrl:getCurRound()
	self.nextCost = smeltCtrl:getNextStageCost(self.curRound)
	self.maxCost = smeltCtrl:getMaxRoundCost(self.curRound)
	local items = smeltRead:getItems()
	_ENV = smeltRead
	smeltRead, self.itemIDs, smeltRead[1] = smeltRead, smeltRead, items[1].itemID
	smeltRead, self.itemIDs, smeltRead[2] = smeltRead, smeltRead, items[2].itemID
	self.itemNums, smeltRead[1] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[1])
	self.itemNums, smeltRead[2] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[3] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[4] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[5] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[6] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[7] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[8] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[9] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[10] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[11] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemNums, smeltRead[12] = smeltRead, smeltCtrl:getItemCount(self.itemIDs[2])
	self.itemAwards, smeltCtrl, self.itemCfgs = smeltRead, smeltRead, items
	for i, v in ipairs(self.itemIDs) do
		local newItem = SoraDGetChildByName(self, "Node_Item_" .. i)
		newItem:setScale(1.0)
		local item = SoraDGetChildByName(newItem, "Item")
		if not item.initData then
			item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
			item:setBaseScale(1)
			item:setOwnView(self)
			local buttonItem = SoraDGetChildByName(item, "Button_item")
			buttonItem:addTouchEventListener(handler(self, self.onItemTouch))
			buttonItem:setTag(i)
		end
		item:initData(v, self.itemNums[i])
		item:setTextColor(self.itemNums[i] > 0 and cc.c3b(255, 255, 255) or cc.c3b(255, 1, 1))
		SoraDGetChildByName(newItem, "Image_light"):setVisible(false)
		local grayPanel = SoraDGetChildByName(newItem, "Panel_gray")
		grayPanel:setVisible(self.itemNums[i] <= 0)
		grayPanel:setTouchEnabled(false)
		local itemDetailNode = SoraDGetChildByName(newItem, "item_detail_node")
		SoraDGetChildByName(newItem, "Text_item_name"):setString(publicRead.getName(v))
		SoraDGetChildByName(newItem, "txt_add_num"):setString("+" .. self.itemCfgs[i].num)
		SoraDToCenter(itemDetailNode, 5, SoraDFIsRA())
		table.insert(self.itemAwards, newItem)
	end
	local isSetItemIndex = false
	if not isSetItemIndex then
		self:refreshView()
	end
end
function smeltUse:setItemIndex(index, isIgnorTip)
	if self.itemNums[index] <= 0 then
		if not isIgnorTip then
			_ENV = nil
			;(nil).itemID = self.itemIDs[index]
			uiManager:show("CommonSourceGuide", nil)
		end
		return false
	end
	self.showIndex = index
	for i, v in ipairs(self.itemIDs) do
		SoraDGetChildByName(self.itemAwards[i], "Image_light"):setVisible(false)
	end
	return true
end
function smeltUse:refreshView()
end
function smeltUse:btnClickCallBack()
	if not self:setItemIndex(self.showIndex) then
		return
	end
	self.curValue = self.curValueNums[self.curValueIndex]
	local curItemCfg = self.itemCfgs[self.showIndex]
	local value = curItemCfg.num * self.curValue
	self.curGetValue = value
	_ENV = nil
	;(nil).msg = "MESSAGE_UPDATE_SMELT_UPDATE_BOX"
	SoraDSendMessage(nil)
	local curValue = smeltCtrl:getValue()
	if self.curGetValue + curValue > self.maxCost then
		if curValue >= self.maxCost then
			return
		end
		local showMsg = i18n("Smelt_text_26")
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				smeltCtrl:reqSmelt(self.itemIDs[self.showIndex], self.curValue)
			end
		end)
	elseif self.curRound == 1 and self.curGetValue + curValue > self.nextCost then
		local willGetRound = smeltCtrl:getWillGetRound(self.curRound, curValue, self.curGetValue)
		_ENV = curValue
		curValue.num = willGetRound
		local showMsg = i18n("Smelt_text_27", curValue)
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				smeltCtrl:reqSmelt(self.itemIDs[self.showIndex], self.curValue)
			end
		end)
	else
		smeltCtrl:reqSmelt(self.itemIDs[self.showIndex], self.curValue)
		self.itemNums[self.showIndex] = self.itemNums[self.showIndex] - self.curValue
		smeltCtrl.msgData.value = smeltCtrl.msgData.value + self.curGetValue
	end
end
function smeltUse:continueLongPress()
	if self.showIndex and self:setItemIndex(self.showIndex, true) and self.isLong then
		self.curValueIndex = self.curValueIndex + 1
		self.curValueIndex = self.curValueIndex >= 10 and 10 or self.curValueIndex
		if self.itemNums[self.showIndex] < self.curValueNums[self.curValueIndex] then
			self.curValueIndex = 1
		end
		self:runLongPress(spaceTime)
	end
end
function smeltUse:onItemTouch(target, event)
	if event == ccui.TouchEventType.began then
		local tag = target:getTag()
		self.showIndex = tag
		self.curValueIndex = 1
		self.isLong = false
		self:runLongPress(longEventTime)
	elseif event == ccui.TouchEventType.ended then
		self:stopActionByTag(longActTag)
		if not self.isLong then
			self:btnClickCallBack()
		end
		self.isLong = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self:stopActionByTag(longActTag)
		end
	elseif event == ccui.TouchEventType.canceled then
		self:stopActionByTag(longActTag)
	end
end
function smeltUse:runLongPress(dt)
	self.stop = true
	longActTag = nil
	;(nil)[1] = cca.delay(dt)
	;(nil)[2] = cca.callFunc(function()
		self.isLong = true
		self:btnClickCallBack()
	end)
	;(nil)[3] = cca.callFunc(function()
		self.isLong = true
		self:btnClickCallBack()
	end)
	local seqLong = cca.seq(nil)
	seqLong:setTag(longActTag)
	self:runAction(seqLong)
end
return smeltUse
