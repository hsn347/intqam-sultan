local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local endlessTreasureCtrl = SoraDGetCtrl("endlessTreasureCtrl")
local endlessTreasureRead = include("endlessTreasureRead")
local digItemID = 510701
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EndlessTreasureDigViewPanel = class("EndlessTreasureDigViewPanel", baseFguiPanel)
function EndlessTreasureDigViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("EndlessTreasureDigViewPanel:ctor", self.viewName)
end
function EndlessTreasureDigViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EndlessTreasureDigViewPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
	print("=======EndlessTreasureDigViewPanel:onInit")
	self.index = 1
	self.status = gEndlessTreasureStatus.NONE
	self.data = nil
	self.isReward = false
	self.isSelected = false
	self.selectIndex = 0
	self.awardNode, _ENV, self.isJoin = gEndlessTreasureStatus.NONE, gEndlessTreasureStatus.NONE, true
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_pTime = fguiHelper.get_fields(self.fields.progress_speed).txt_title
	self.Text_pTime = SoraDCreateTimerLabel(self, self.Text_pTime)
	self.Text_tTime = fguiHelper.get_fields(self.fields.progress_tspeed).txt_title
	self.Text_tTime = SoraDCreateTimerLabel(self, self.Text_tTime)
	self.fields.Button_delete:addClickEventListener(handler(self, self.btnDeleteClick))
	self.fields.Button_dig:addClickEventListener(handler(self, self.btnDigClick))
	self.fields.Button_toSpeed:setTitle(i18n("common_text_018"))
	self.fields.Button_toSpeed:addClickEventListener(handler(self, self.btnSpeedClick))
	self.fields.Button_join:addClickEventListener(handler(self, self.btnJoinClick))
	self.fields.Button_speed:setTitle(i18n("common_text_018"))
	self.fields.Button_speed:addClickEventListener(handler(self, self.btnSpeedClick))
	self.fields.btn_stop:addClickEventListener(handler(self, self.btnStopClick))
	self.fields.btn_stop_speed:addClickEventListener(handler(self, self.btnStopClick))
end
function EndlessTreasureDigViewPanel:onShow()
	print("=======EndlessTreasureDigViewPanel:onShow")
end
function EndlessTreasureDigViewPanel:updateData(target, data)
	SoraDCloseLoading(self:displayObject())
	if data and data.isReward then
		self:close()
		return
	end
	local status = endlessTreasureCtrl:getTreasureStatus(self.index)
	local data = endlessTreasureCtrl:getTreasureInfoByIndex(self.index)
	if data and data.isReward then
		self:close()
		return
	end
	self:initData(self.index, status, data)
end
function EndlessTreasureDigViewPanel:initData(index, status, data)
	self.index = index
	self.status = status
	self.data = data
	self.isReward = self.status == gEndlessTreasureStatus.REWARD
	self.isUnableDig = endlessTreasureCtrl:isUnableDig(self.index)
	self.isUnableQueue = endlessTreasureCtrl:isUnableQueue(self.index)
	self:suitView()
	self:initView()
end
function EndlessTreasureDigViewPanel:suitView()
	local shortModel = function()
	end
	local longModel = function()
	end
	if self.status == gEndlessTreasureStatus.READY then
		if self.isUnableDig then
			self.controllers.c1:setSelectedIndex(2)
		else
			self.controllers.c1:setSelectedIndex(1)
		end
	elseif self.status == gEndlessTreasureStatus.REWARD then
		self.controllers.c1:setSelectedIndex(1)
	elseif self.status == gEndlessTreasureStatus.DIG then
		self.controllers.c1:setSelectedIndex(0)
	elseif self.status == gEndlessTreasureStatus.QUEUE then
		self.controllers.c1:setSelectedIndex(2)
	end
end
function EndlessTreasureDigViewPanel:setNodeSpeedInfo()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
	if queue then
		self.Text_pTime:setTimeUpdateListener(function(timeNumber)
			local percent = (queue.totaltime - timeNumber) / queue.totaltime
			self.fields.progress_speed:setPercent(percent)
		end)
		self.Text_pTime:setTimeEndListener(function()
			self:updateData()
		end)
		self.Text_pTime:beginTime(queue.timerNode.timer:getRemainTime())
	end
	queueCtrl = queue.timerNode.timer:getRemainTime()
	queue.timerNode.timer:getRemainTime().name = endlessTreasureRead.getTreasureName(self.data.tID)
	self.fields.Text_digging:setString(i18n("endless_treasures_text_20", queue.timerNode.timer:getRemainTime()))
end
function EndlessTreasureDigViewPanel:setNodeDiggingInfo()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
	if queue then
		self.Text_tTime:setTimeUpdateListener(function(timeNumber)
			local percent = (queue.totaltime - timeNumber) / queue.totaltime
			self.fields.progress_tspeed:setPercent(percent)
		end)
		self.Text_tTime:setTimeEndListener(function()
			self:updateData()
		end)
		self.Text_tTime:beginTime(queue.timerNode.timer:getRemainTime())
	end
	local digData = endlessTreasureCtrl:getDigTreasureInfo()
	queueCtrl = queue.timerNode.timer:getRemainTime()
	queue.timerNode.timer:getRemainTime().name = endlessTreasureRead.getTreasureName(digData.tID)
	self.fields.Text_tDigging:setString(i18n("endless_treasures_text_20", queue.timerNode.timer:getRemainTime()))
	self.fields.Image_treasure:setURL(endlessTreasureRead.getTreasureIcon(digData.tID))
end
function EndlessTreasureDigViewPanel:initView()
	self.fields.Text_name:setString(endlessTreasureRead.getTreasureName(self.data.tID))
	self.fields.Button_dig:setTitle(self.isReward and i18n("common_text_1146") or i18n("endless_treasures_text_27"))
	self.fields.Image_box:setURL(endlessTreasureRead.getTreasureIcon(self.data.tID))
	self.fields.Button_delete:setVisible(self.status == gEndlessTreasureStatus.READY or self.status == gEndlessTreasureStatus.QUEUE)
	self.fields.Node_time:setVisible(self.status == gEndlessTreasureStatus.READY or self.status == gEndlessTreasureStatus.QUEUE)
	self.fields.Text_status:setVisible(self.status == gEndlessTreasureStatus.DIG)
	self.fields.Image_treasureQueue:setURL("icon_wjbz_bz_01.png")
	self.fields.Image_treasureQueue:setGrayed(true)
	if self.status == gEndlessTreasureStatus.READY then
		self.fields.Text_timeOpen:setString(i18n("common_text_942"))
		local time = endlessTreasureRead.getTreasureTime(self.data.tID)
		self.fields.Text_time:setString(SoraDConvertSecondToString(time))
		self.fields.Button_join:setTitle(i18n("endless_treasures_text_31"))
		self.fields.Text_des:setString(i18n("endless_treasures_text_25"))
		self.isJoin = true
		self.fields.Text_other:setVisible(false)
		if self.isUnableDig then
			if self.isUnableQueue then
				self.isJoin = false
				self.fields.Button_join:setTitle(i18n("endless_treasures_text_34"))
				local queueBox, index = endlessTreasureCtrl:getQueueTreasureInfo()
				endlessTreasureRead = i18n("endless_treasures_text_34")
				i18n("endless_treasures_text_34").name = endlessTreasureRead.getTreasureName(queueBox.tID)
				self.fields.Text_des:setString(i18n("endless_treasures_text_33", i18n("endless_treasures_text_34")) .. "\n" .. i18n("common_text_942") .. SoraDConvertSecondToString(endlessTreasureRead.getTreasureTime(queueBox.tID)))
				self.fields.Image_treasureQueue:setURL(endlessTreasureRead.getTreasureIcon(queueBox.tID))
				self.fields.Image_treasureQueue:setGrayed(false)
				self.fields.Text_other:setString(i18n("endless_treasures_text_46"))
				self.fields.Text_other:setVisible(true)
			end
			self.fields.Text_tip:setString(i18n("endless_treasures_text_08"))
			self.fields.Button_dig:setVisible(false)
			self:setNodeDiggingInfo()
		else
			self.fields.Text_tip:setString(i18n("endless_treasures_text_08"))
			self.fields.Button_dig:setVisible(true)
			self.fields.Button_dig:setTouchEnabled(true)
			self.fields.Button_dig:setTitleColor(cc.c3b(255, 255, 255))
		end
	elseif self.status == gEndlessTreasureStatus.DIG then
		self.fields.Text_other:setVisible(false)
		self.fields.Button_dig:setVisible(false)
		self:setNodeSpeedInfo()
		self.fields.Text_tip:setString(i18n("endless_treasures_text_08"))
		self.fields.Text_status:setString(i18n("endless_treasures_text_03"))
	elseif self.status == gEndlessTreasureStatus.QUEUE then
		self.fields.Text_other:setVisible(true)
		self.fields.Text_other:setString(i18n("endless_treasures_text_19"))
		self.fields.Button_dig:setVisible(false)
		self.fields.Button_join:setTitle(i18n("endless_treasures_text_34"))
		self.fields.Text_des:setString(i18n("endless_treasures_text_22"))
		self.isJoin = false
		self.fields.Text_tip:setString(i18n("endless_treasures_text_08"))
		endlessTreasureRead = i18n("endless_treasures_text_08")
		i18n("endless_treasures_text_08").time = ""
		self.fields.Text_timeOpen:setString(i18n("endless_treasures_text_18", i18n("endless_treasures_text_08")))
		local time = endlessTreasureRead.getTreasureTime(self.data.tID)
		self.fields.Text_time:setString(SoraDConvertSecondToString(time))
		self:setNodeDiggingInfo()
		local queueBox, index = endlessTreasureCtrl:getQueueTreasureInfo()
		self.fields.Image_treasureQueue:setURL(endlessTreasureRead.getTreasureIcon(queueBox.tID))
		self.fields.Image_treasureQueue:setGrayed(false)
	elseif self.status == gEndlessTreasureStatus.REWARD then
		self.fields.Text_other:setVisible(false)
		self.fields.Text_tip:setString(i18n("endless_treasures_text_38"))
		self.fields.Button_dig:setVisible(true)
		self.fields.Button_dig:setBright(self.isSelected)
		self.fields.Button_dig:setTouchEnabled(self.isSelected)
		self.fields.Button_dig:setTitleColor(self.isSelected and cc.c3b(255, 255, 255) or cc.c3b(165, 165, 165))
	end
	self.awardList = endlessTreasureRead.getTreasureAward(self.data.tID)
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.scroll:setNumItems(#self.awardList)
end
function EndlessTreasureDigViewPanel:onItemRenderer(index, obj)
	local objFields = fguiHelper.get_fields(obj)
	local awardData = self.awardList[index + 1]
	obj:setTouchEnabled(false)
	if self.status == gEndlessTreasureStatus.REWARD then
		obj:setTouchEnabled(true)
		obj:setTag(index + 1)
		if not obj.isAddClick then
			obj.isAddClick = true
			obj:addClickEventListener(handler(self, self.btnChooseClick))
		end
	end
	for k = 1, 3 do
		local cfg = awardData[k]
		local itemNode = objFields.scroll:getChildAt(k - 1)
		if not SoraDFIsRA() then
			itemNode:fixChildrenPos()
		end
		local itemFields = fguiHelper.get_fields(itemNode)
		itemFields.itemName:setString(publicRead.getName(cfg.id))
		itemFields.item:initData(cfg.id, cfg.count)
	end
end
function EndlessTreasureDigViewPanel:btnChooseClick(target)
	SoraDPlaySound()
	self.isSelected = true
	if self.selectIndex == target:getTag() then
		return
	end
	self.selectIndex = target:getTag()
	self.fields.Button_dig:setBright(self.isSelected)
	self.fields.Button_dig:setTouchEnabled(self.isSelected)
	self.fields.Button_dig:setTitleColor(cc.c3b(255, 255, 255))
	for i = 1, 3 do
		local obj = self.fields.scroll:getChildAt(i - 1)
		obj:setSelected(self.selectIndex == i)
	end
end
function EndlessTreasureDigViewPanel:btnSpeedClick()
	SoraDPlaySound()
	local digItemCount = backpackCtrl:getItemCount(digItemID)
	if 0 < digItemCount then
		uiManager:show("EndlessTreasureSpeedUpBox")
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PRECIOUS_TREASURE_ACTIVITY) then
		SoraDShowMsgBox(i18n("endless_treasures_text_40"), i18n("Secret_explore_text_14"), nil, function(backType)
			if backType == MSGBOX_CALLBACK_YES then
				_UPVALUE4_ = MSGBOX_CALLBACK_YES
				MSGBOX_CALLBACK_YES[1] = 13934
				MSGBOX_CALLBACK_YES[2] = 13935
				MSGBOX_CALLBACK_YES[3] = 13936
				local MSGBOX_CALLBACK_YES[4], giftArray = 13937, MSGBOX_CALLBACK_YES
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = 13937
					;(13937).rechargeIDList = giftArray
					uiManager:show("rechargeView", 13937)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:jumpToLimitNodeByList(12, giftArray)
					panel:show()
				end
			end
		end)
	else
		SoraDShowMsgTip(i18n("endless_treasures_text_40"))
	end
end
function EndlessTreasureDigViewPanel:btnJoinClick()
	SoraDPlaySound()
	SoraDShowLoading(self:displayObject())
	if self.isJoin then
		endlessTreasureCtrl:reqJoin(self.index)
	else
		local queueBox, index = endlessTreasureCtrl:getQueueTreasureInfo()
		endlessTreasureCtrl:reqCancel(index)
	end
end
function EndlessTreasureDigViewPanel:btnStopClick(button, type)
	SoraDPlaySound()
	local digData, digIndex = endlessTreasureCtrl:getDigTreasureInfo()
	_ENV = nil
	;(nil).var = endlessTreasureRead.getTreasureName(digData.tID)
	local comStr = i18n("Treasure_text_4", nil) .. "\n" .. i18n("Treasure_text_5")
	SoraDShowMsgBox(comStr, i18n("common_text_204"), nil, function(backType)
		if backType == MSGBOX_CALLBACK_YES and digIndex then
			endlessTreasureCtrl:reqStopDig(digIndex)
		end
	end)
end
function EndlessTreasureDigViewPanel:btnDigClick()
	SoraDPlaySound()
	if self.isReward then
		SoraDShowLoading(self:displayObject())
		endlessTreasureCtrl:reqReward(self.index, self.selectIndex)
	else
		SoraDShowLoading(self:displayObject())
		endlessTreasureCtrl:reqDig(self.index)
	end
end
function EndlessTreasureDigViewPanel:btnDeleteClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).name = endlessTreasureRead.getTreasureName(self.data.tID)
	SoraDShowMsgBox(i18n("endless_treasures_text_15", nil), i18n("common_text_204"), nil, function(backType)
		if backType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
			endlessTreasureCtrl:reqRemove(self.index)
			self:removeFromParent()
		end
	end)
end
return EndlessTreasureDigViewPanel
