local gametop = gModuleMgr.getObject("gametop")
local activity_9001615_Read = include("activity_9001615_Read")
local publicRead = include("publicRead")
local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
local longActTag = 100
local longEventTime = 0.5
local spaceTime = 0.15
local baseComponent = require("fgui.base.baseComponent")
local Com_9001615_use = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001615/Com_9001615_use", Com_9001615_use)
function Com_9001615_use:onInit()
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
function Com_9001615_use:onShow()
end
function Com_9001615_use:setHandle(handle)
	self.handle = handle
end
function Com_9001615_use:setLabelHandle(handle)
	self.labelHandle = handle
end
function Com_9001615_use:sliderCallBack(value)
	self.curValue = value
	self:refreshView()
end
function Com_9001615_use:updateView(btnUse)
	self.btnUse = btnUse
	self.maxRound = activity_9001615_Ctrl:getMaxRound()
	self.curRound = activity_9001615_Ctrl:getCurRound()
	self.nextCost = activity_9001615_Ctrl:getNextStageCost(self.curRound)
	self.maxCost = activity_9001615_Ctrl:getMaxRoundCost(self.curRound)
	local items = activity_9001615_Read:getItems()
	_ENV = activity_9001615_Read
	activity_9001615_Read, self.itemIDs, activity_9001615_Read[1] = activity_9001615_Read, activity_9001615_Read, items[1].itemID
	activity_9001615_Read, self.itemIDs, activity_9001615_Read[2] = activity_9001615_Read, activity_9001615_Read, items[2].itemID
	self.itemNums, activity_9001615_Read[1] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[1])
	self.itemNums, activity_9001615_Read[2] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[3] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[4] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[5] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[6] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[7] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[8] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[9] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[10] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[11] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	self.itemNums, activity_9001615_Read[12] = activity_9001615_Read, activity_9001615_Ctrl:getItemCount(self.itemIDs[2])
	dump(self.itemNums, "self.itemNums")
	self.itemAwards, activity_9001615_Ctrl, self.itemCfgs = dump, dump, items
	for i, v in ipairs(self.itemIDs) do
		local newItem = SoraDGetChildByName(self, "Node_Item_" .. i)
		newItem:fixPos()
		newItem:setScale(1.0)
		local item = SoraDGetChildByName(newItem, "Item")
		if not newItem.item then
			newItem.item = item
			item:forbidLongPress()
			item:addEventListener(fgui.UIEventType.TouchBegin, function()
				self:onItemTouch(item, ccui.TouchEventType.began)
			end)
			item:addEventListener(fgui.UIEventType.TouchEnd, function()
				self:onItemTouch(item, ccui.TouchEventType.ended)
			end)
			item:setTag(i)
		end
		item:initData(v, self.itemNums[i])
		item:setNumColor(self.itemNums[i] > 0 and cc.c3b(255, 255, 255) or cc.c3b(255, 1, 1))
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
function Com_9001615_use:setItemIndex(index, isIgnorTip)
	if self.itemNums[index] <= 0 then
		if not isIgnorTip then
			if index == 1 then
				uiManager:show("Activity_9001615_TaskPopView")
			else
				local packageList = activity_9001615_Ctrl:getPackageList()
				if 0 < #packageList then
					_ENV = nil
					;(nil).group = packageList
					;(nil).fromCenter = gRechargeActiveFromEnum.ROAD01
					;(nil).isPageTurn = false
					;(nil).isHideRechargeCenter = true
					uiManager:show("rechargePopView", nil)
				else
					SoraDShowMsgTip(i18n("Player_Return_test02"))
				end
			end
		end
		return false
	end
	self.showIndex = index
	for i, v in ipairs(self.itemIDs) do
		SoraDGetChildByName(self.itemAwards[i], "Image_light"):setVisible(false)
	end
	return true
end
function Com_9001615_use:refreshView()
end
function Com_9001615_use:btnClickCallBack()
	SoraDPlaySound()
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
	local curValue = activity_9001615_Ctrl:getValue()
	if self.curGetValue + curValue > self.maxCost then
		if curValue >= self.maxCost then
			return
		end
		local showMsg = i18n("Smelt_text_26")
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				activity_9001615_Ctrl:reqSmelt(self.itemIDs[self.showIndex], self.curValue)
			end
		end)
	elseif self.curRound == 1 and self.curGetValue + curValue > self.nextCost then
		local willGetRound = activity_9001615_Ctrl:getWillGetRound(self.curRound, curValue, self.curGetValue)
		_ENV = curValue
		curValue.num = willGetRound
		local showMsg = i18n("Smelt_text_27", curValue)
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				activity_9001615_Ctrl:reqSmelt(self.itemIDs[self.showIndex], self.curValue)
			end
		end)
	else
		activity_9001615_Ctrl:reqSmelt(self.itemIDs[self.showIndex], self.curValue)
		self.itemNums[self.showIndex] = self.itemNums[self.showIndex] - self.curValue
		activity_9001615_Ctrl.msgData.value = activity_9001615_Ctrl.msgData.value + self.curGetValue
	end
end
function Com_9001615_use:continueLongPress()
	if self.showIndex and self:setItemIndex(self.showIndex, true) and self.isLong then
		self.curValueIndex = self.curValueIndex + 1
		self.curValueIndex = self.curValueIndex >= 10 and 10 or self.curValueIndex
		if self.itemNums[self.showIndex] < self.curValueNums[self.curValueIndex] then
			self.curValueIndex = 1
		end
		self:runLongPress(spaceTime)
	end
end
function Com_9001615_use:onItemTouch(target, event)
	if event == ccui.TouchEventType.began then
		local tag = target:getTag()
		self.showIndex = tag
		if not self:setItemIndex(self.showIndex, true) then
			return
		end
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
function Com_9001615_use:runLongPress(dt)
	self.stop = true
	longActTag = nil
	;(nil)[1] = ffa.delay(dt)
	;(nil)[2] = ffa.callFunc(function()
		self.isLong = true
		self:btnClickCallBack()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isLong = true
		self:btnClickCallBack()
	end)
	local seqLong = ffa.seq(nil)
	seqLong:setTag(longActTag)
	self:runAction(seqLong)
end
return Com_9001615_use
