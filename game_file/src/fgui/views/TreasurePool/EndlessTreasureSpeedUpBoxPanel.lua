local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EndlessTreasureSpeedUpBoxPanel = class("EndlessTreasureSpeedUpBoxPanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local endlessTreasureRead = include("endlessTreasureRead")
local endlessTreasureCtrl = SoraDGetCtrl("endlessTreasureCtrl")
local publicRead = include("publicRead")
local itemID = 510701
function EndlessTreasureSpeedUpBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("EndlessTreasureSpeedUpBoxPanel:ctor", self.viewName)
end
function EndlessTreasureSpeedUpBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EndlessTreasureSpeedUpBoxPanel:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.slider:setInpuBoxFixPos(50, 140, 150)
	end
	print("=======EndlessTreasureSpeedUpBoxPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("endless_treasures_text_01"))
	self.Text_timer = fguiHelper.get_fields(self.fields.nodeQueueBar).txt_title
	self.Text_timer = SoraDCreateTimerLabel(self, self.Text_timer)
	self.fields.slider:setSliderCallBack(handler(self, self.updateUseCount))
	self.fields.Text_des:setString(i18n("common_text_772"))
	self.fields.Button_use:setTitleText(i18n("common_text_314"))
	self.fields.Button_use:addTouchEventListener(handler(self, self.btnUseClick))
	self:initData()
end
function EndlessTreasureSpeedUpBoxPanel:onShow()
	print("=======EndlessTreasureSpeedUpBoxPanel:onShow")
end
function EndlessTreasureSpeedUpBoxPanel:initData(target, data)
	SoraDCloseLoading(self:displayObject())
	local count = backpackCtrl:getItemCount(itemID)
	if data and data.msg == "MESSAGE_ITEM_SPEED_UP_BACK" then
		_ENV = itemID
		itemID.msg = "MESSAGE_TREVIFOUNTAIN_ENDLESSTREASURE_REFRESH"
		SoraDSendMessage(itemID)
		if count < 1 then
			self.isColse = true
		end
		self:showMsgTip()
		if self.isColse then
			self:close()
			return
		end
	end
	self.data = endlessTreasureCtrl:getDigTreasureInfo()
	self.fields.ccs_item:initData(itemID, count)
	self.fields.text_itemName:setString(publicRead.getName(itemID))
	self.fields.ccs_item:setCanSelected(true)
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
	if self.queue then
		self.Text_timer:setTimeUpdateListener(function(timeNumber)
			local percent = (self.queue.totaltime - timeNumber) / self.queue.totaltime
			self.fields.nodeQueueBar:setPercent(percent)
		end)
		self.Text_timer:setTimeEndListener(function()
			self:removeFromParent()
		end)
		self.Text_timer:beginTime(self.queue.timerNode.timer:getRemainTime())
		local result = backpackltCtrl:getResult(itemID).value
		local needNum = math.floor(self.queue.timerNode.timer:getRemainTime() / result)
		local bestNum = math.min(count, needNum)
		local maxValue = math.min(math.min(needNum + 1, count), backpackltCtrl:getUseMax(itemID))
		_ENV = backpackltCtrl:getUseMax(itemID)
		backpackltCtrl:getUseMax(itemID).maxValue = maxValue
		backpackltCtrl:getUseMax(itemID).minValue = 1
		backpackltCtrl:getUseMax(itemID).curValue = bestNum
		self.fields.slider:initData(backpackltCtrl:getUseMax(itemID))
	else
		self:close()
	end
end
function EndlessTreasureSpeedUpBoxPanel:updateUseCount(count)
	local speedTime = backpackltCtrl:getResult(itemID).value * count
	backpackltCtrl = nil
	;(nil).time = SoraDConvertSecondToString(speedTime)
	self.fields.labelSpeedTime:setString(i18n("common_text_1161", nil))
end
function EndlessTreasureSpeedUpBoxPanel:showMsgTip()
	local name = endlessTreasureRead.getTreasureName(self.data.tID)
	endlessTreasureRead = nil
	;(nil).name = name
	;(nil).time = SoraDConvertSecondToString(self.spTime)
	SoraDShowMsgTip(i18n("endless_treasures_text_12", nil))
end
function EndlessTreasureSpeedUpBoxPanel:btnUseClick(button, event)
	SoraDPlaySound()
	if self.queue == nil then
		self:close()
		return
	end
	local speedTime = backpackltCtrl:getResult(itemID).value
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	local useCount = self.fields.slider:getSliderCurValue()
	if leftTime < speedTime * useCount then
		SoraDShowMsgBox(i18n("common_text_1435"), i18n("common_text_204"), nil, function(event)
			if event == MSGBOX_CALLBACK_YES then
				_ENV, _ENV = nil, MSGBOX_CALLBACK_YES
				;(nil).id = itemID
				MSGBOX_CALLBACK_YES[1], (nil).count = nil, useCount
				local items = MSGBOX_CALLBACK_YES
				queueCtrl:speedUpQueueReq(gQueueTypeDef.endless_treasure_queue, SPEEDUP_TYPE.TOOLS, items)
				self.spTime = speedTime * useCount
				self.isColse = true
			end
		end)
	else
		_ENV, _ENV = i18n("common_text_1435"), SoraDShowMsgBox
		i18n("common_text_1435").id = itemID
		SoraDShowMsgBox[1], i18n("common_text_1435").count = i18n("common_text_1435"), useCount
		local items = SoraDShowMsgBox
		queueCtrl:speedUpQueueReq(gQueueTypeDef.endless_treasure_queue, SPEEDUP_TYPE.TOOLS, items)
		self.spTime = speedTime * useCount
		SoraDShowLoading(self:displayObject())
	end
end
return EndlessTreasureSpeedUpBoxPanel
