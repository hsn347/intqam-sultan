local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local radianceWarBuffNode = class("radianceWarBuffNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarBuffNode")
	end
	return target
end)
function radianceWarBuffNode:ctor()
	self.buff, _ENV, self.buffList, _ENV = nil, nil, nil, nil
	self.timeEndHandle = nil
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_touch:addTouchEventListener(handler(self, self.onBuffTouchClick))
	self.Node_tip = SoraDGetChildByName(self, "Node_tip")
	self.Node_tip:setVisible(false)
	self.Text_ghzy = SoraDGetChildByName(self, "Text_ghzy")
	self.Text_ghzy:setString(i18n("activity_name_9001263"))
	self.Text_buff = SoraDGetChildByName(self, "Text_buff")
	self.buffList[1] = self.Text_buff
end
function radianceWarBuffNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW", function(target, data)
		if data and data.eventID == gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY then
			self:setBuffInfo()
		end
	end)
end
function radianceWarBuffNode:setTimeEndHandle(handle)
	print("设置倒计时结束刷新===========")
	self.timeEndHandle = handle
end
function radianceWarBuffNode:initData(buffList)
	self.buff = buffList
	self:setBuffInfo()
end
function radianceWarBuffNode:setBuffInfo()
	local isActive = lightShiningCtrl:isBuffActive()
	print("isActive======", isActive)
	if isActive then
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		local buffDesRead = include("buffDesRead")
		local buffData = lightShiningCtrl:getBuffList()
		for k, v in ipairs(self.buffList) do
			v:setVisible(false)
		end
		local lightShiningCtrl, showBuffList = (for generator), ipairs(self.buffList)
		for k, v in ipairs(self.buff) do
			if SoraDisInList(v, buffData) then
				table.insert(showBuffList, v)
			end
		end
		local Image_buffBg = SoraDGetChildByName(self.Node_tip, "Image_buffBg")
		local realBuffH = 0
		local lightShiningCtrl, autoH = "Image_buffBg", "Image_buffBg"
		dump(showBuffList, "showBuffList===")
		for k, v in ipairs(showBuffList) do
			if not self.buffList[k] then
				self.buffList[k] = self.buffList[1]:clone()
				self.buffList[k]:addTo(self.Node_tip)
			end
			self.buffList[k]:setVisible(true)
			self.buffList[k] = SoraDCreateTimerLabel(self, self.buffList[k])
			local buffType = buffltCtrl:getEffectType(v)
			local buffValue = buffltCtrl:getEffect(v)
			self.buffList[k]:setTimeLast(function(ticket)
				buffDesRead = nil
				buffDesRead = nil
				;(nil).time = ticket
				;(nil).abbr = i18n("common_text_766", nil)
				;(nil).name = ""
				return buffDesRead.getTitleWithValue(buffType, buffValue) .. i18n("common_text_186", nil)
			end)
			self.buffList[k]:setTimeEndListener(function()
				if self.timeEndHandle then
					print("radianceWarBuffNode倒计时结束刷新===========")
					self.timeEndHandle()
				end
			end)
			local remainTime = buffCtrl:getRemainTimeByBuffID(v)
			if remainTime then
				self.buffList[k]:beginTime(remainTime)
			end
			local bHeight = SoraDGetAutoHeightLabel(self.buffList[k], 296)
			autoH[k] = bHeight
			realBuffH = realBuffH + bHeight
		end
		local bgHeight = realBuffH + 60 + (#showBuffList - 1) * 10
		Image_buffBg:setContentSize(cc.size(Image_buffBg:getContentSize().width, bgHeight))
		self.Text_ghzy:setPositionY(bgHeight / 2 - 15)
		local beginH = bgHeight - 20
		local add = 0
		for k, v in ipairs(showBuffList) do
			self.buffList[k]:setPositionY(beginH / 2 - 30 - autoH[k] / 2 - add)
			add = add + autoH[k] + 10
		end
	end
end
function radianceWarBuffNode:onBuffTouchClick(target, event)
	if event == ccui.TouchEventType.ended then
		self.Node_tip:setVisible(false)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self.Node_tip:setVisible(false)
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
		SoraDPlaySound()
		self.Node_tip:setVisible(true)
	end
end
return radianceWarBuffNode
