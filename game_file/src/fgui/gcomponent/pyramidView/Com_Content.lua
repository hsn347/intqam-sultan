local pyramidCtrl = SoraDGetCtrl("pyramidCtrl")
local easeFunctions = include("easeFunctions")
local baseComponent = require("fgui.base.baseComponent")
local Com_Content = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://pyramidView/Com_Content", Com_Content)
function Com_Content:onInit()
	self.numMax = 30
	self.actTime = 1.0
	self.itemDatas, _UPVALUE0_, self.awardList, _UPVALUE0_, self.runTime = nil, nil, nil, nil, 2.0
	self:setStaticData()
end
function Com_Content:onShow()
end
function Com_Content:setStaticData()
	_UPVALUE6_ = nil
	;(nil)[1] = "5"
	;(nil)[2] = "10"
	;(nil)[3] = "15"
	;(nil)[4] = "20"
	;(nil)[5] = "25"
	local (nil)[6], scoreArray = "MAX", nil
	for i = 1, 6 do
		self.fields["com_BarPoint" .. i - 1]:setString(scoreArray[i])
		local awardList = self.fields["awardList" .. i - 1]
		table.insert(self.awardList, awardList)
		awardList:setItemRenderer(handlerEx(self, self.onItemRender, i))
	end
end
function Com_Content:initWithData(actionEnabled)
	self.actionEnabled = actionEnabled
	if actionEnabled == true then
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_PYRAMID_SHOW_LOADING"
		;(nil).isShow = true
		SoraDSendMessage(nil)
	end
	self.itemDatas, _ENV = SoraDSendMessage, SoraDSendMessage
	for k, listItem in ipairs(self.awardList) do
		if listItem then
			local floorItems = pyramidCtrl:getItemByFloor(k)
			table.insert(self.itemDatas, floorItems)
			listItem:setNumItems(table.nums(floorItems))
		end
	end
end
function Com_Content:onItemRender(k, index, target)
	local data = self.itemDatas[k][index + 1]
	if self.actionEnabled then
		self:showNodesAction(target, k, data, #self.awardList)
	else
		target:initData(data.itemid, data.itemnum)
		target:showCoolSquare(pyramidCtrl:isNeedShowCoolSquare(data.itemid))
	end
end
function Com_Content:showNodesAction(target, line, data, len)
	_UPVALUE5_ = nil
	;(nil)[1] = ffa.delay(line * 0.05)
	;(nil)[2] = ffa.scaleTo(0.25, 1, 0)
	;(nil)[3] = ffa.callFunc(function()
		target:initData(data.itemid, data.itemnum)
		target:showCoolSquare(pyramidCtrl:isNeedShowCoolSquare(data.itemid))
	end)
	;(nil)[4] = ffa.scaleTo(0.25, 1, 1)
	;(nil)[5] = ffa.delay(0.1)
	;(nil)[6] = ffa.callFunc(function()
		if line == len then
			line = len
			len.msg = "MESSAGE_UI_PYRAMID_SHOW_LOADING"
			len.isShow = false
			SoraDSendMessage(len)
		end
	end)
	;(nil)[7] = ffa.callFunc(function()
		if line == len then
			line = len
			len.msg = "MESSAGE_UI_PYRAMID_SHOW_LOADING"
			len.isShow = false
			SoraDSendMessage(len)
		end
	end)
	target:runAction(ffa.seq(nil))
end
function Com_Content:setBarPercent(score, isAct)
	self.score = math.min(score, self.numMax)
	if isAct then
		local barAction = function()
			self.fields.com_Bar:tweenValue(self.score, 1)
		end
		_UPVALUE2_ = self.numMax
		self.numMax[1] = ffa.callFunc(barAction)
		self.numMax[2] = ffa.delay(self.actTime)
		self.numMax[3] = ffa.callFunc(function()
			self:showRewardAnimation()
		end)
		self.numMax[4] = ffa.callFunc(function()
			self:showRewardAnimation()
		end)
		local action = ffa.seq(self.numMax)
		self:runAction(action)
	else
		self.fields.com_Bar:setValue(self.score)
	end
end
function Com_Content:showRewardAnimation(isNoAct)
	local totalCircle = 3
	local curFloor = pyramidCtrl:getFloor()
	local award = pyramidCtrl:getAwardItemIDAndNum()
	local finalIndex = 1
	for k, data in ipairs(self.itemDatas[curFloor]) do
		if data.itemid == award.itemid and data.itemnum == award.itemnum then
			finalIndex = k
			break
		end
	end
	local lineTotal = self.awardList[curFloor]:getNumItems()
	local nextIndex = 1
	local oriIndex = 1
	local accuTime = 0
	if isNoAct then
		SoraDPlaySound("pyramid", 6)
		self:checkState()
		local single = self.awardList[curFloor]:getChildAt(finalIndex - 1)
		local pos = single:localToGlobal(cc.p(35, 35))
		pos = self:globalToLocal(cc.p(pos.x, pos.y))
		self.fields.lightBorder:setPosition(cc.p(pos.x, pos.y))
		self.fields.lightBorder:setVisible(true)
	elseif not self.timer then
		self.isShowingRewardAnimation = true
		self.timer = SoradCreateTimer(self, function(dt)
			local easeFunc = easeFunctions.inOutQuad or easeFunctions.linear
			local timeFactor = easeFunc(accuTime, 0, self.runTime, self.runTime)
			local _percent = timeFactor / self.runTime
			if 1 <= _percent and nextIndex == finalIndex then
				SoraDPlaySound("pyramid", 6)
				self:stopTimer()
				self:checkState()
				return
			end
			if nextIndex == 0 then
			end
			local single = self.awardList[curFloor]:getChildAt(nextIndex - 1)
			local pos = single:localToGlobal(cc.p(35, 35))
			pos = self:globalToLocal(cc.p(pos.x, pos.y))
			self.fields.lightBorder:setPosition(cc.p(pos.x, pos.y))
			self.fields.lightBorder:setVisible(true)
			if oriIndex ~= nextIndex then
				SoraDPlaySound("pyramid", 3)
			end
		end, true)
	end
end
function Com_Content:resetScore()
	self.fields.lightBorder:setVisible(false)
	self:setBarPercent(0)
end
function Com_Content:checkState()
	_UPVALUE5_ = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.fadeTo(0.05, 0.2)
	;(nil)[3] = ffa.fadeTo(0.05, 1)
	;(nil)[4] = ffa.fadeTo(0.05, 0.1)
	;(nil)[5] = ffa.fadeTo(0.05, 1)
	;(nil)[6] = ffa.callFunc(function()
		self.isShowingRewardAnimation = false
		self = nil
		;(nil).msg = "MESSAGE_UI_PYRAMID_SHOW_ITEM_REWARD"
		SoraDSendMessage(nil)
	end)
	;(nil)[7] = ffa.callFunc(function()
		self.isShowingRewardAnimation = false
		self = nil
		;(nil).msg = "MESSAGE_UI_PYRAMID_SHOW_ITEM_REWARD"
		SoraDSendMessage(nil)
	end)
	local seq = ffa.seq(nil)
	self.fields.lightBorder:runAction(seq)
end
function Com_Content:stopTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
return Com_Content
