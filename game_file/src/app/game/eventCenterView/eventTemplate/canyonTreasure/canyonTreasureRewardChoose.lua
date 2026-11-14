local canyonTreasureHuntRead = include("canyonTreasureHuntRead")
local canyonTreasureCtrl = SoraDGetCtrl("canyonTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local canyonTreasureRewardChoose = class("canyonTreasureRewardChoose", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("canyonTreasureRewardChoose")
	end
	return target
end)
local CHOOSE_MAX_NUM = 3
function canyonTreasureRewardChoose:ctor()
	self.pastList, _UPVALUE0_, self.imageList, _UPVALUE0_, self.choosList, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
	self:initWidget()
end
function canyonTreasureRewardChoose:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function canyonTreasureRewardChoose:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Canyon_Treasur_text_07"))
	self.Text_name:setString(i18n("Canyon_Treasur_text_11"))
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Text_hunt1:setString(i18n("common_text_1417"))
	self.Button_ok:addTouchEventListener(handler(self, self.btnOkCallback))
	self.Button_change:addTouchEventListener(handler(self, self.btnChangeCallback))
	SoraDAutoSizeButtonTextByContent(self.Button_ok)
	self.activityID = gActivityTimeActivityID.CANYON_TREASURE_HUNT
	self.Image_gold1:setScale(0.8)
end
function canyonTreasureRewardChoose:initData(data)
	self.type = data.type
	self.config = canyonTreasureHuntRead.getCtrConfigByType(self.type, gcanyonTreasureRewardType.OPTIONAL)
	for i, v in ipairs(self.config) do
		local singe = self.Node_single:clone()
		singe:addTo(self.Node_rewards)
		singe:setPosition(cc.p(0, 0))
		local item = SoraDCreatePanel("commonItemAward")
		item:addTo(singe, -1)
		item:setPosition(cc.p(0, 0))
		item:setOwnView(self)
		item:initData(v.item, v.num)
		item:setScale(0.88)
		item.Button_item:setTag(v.ID)
		self.imageList[v.ID] = SoraDGetChildByName(singe, "Image_g")
		self.imageList[v.ID]:setVisible(false)
		local clickImage = SoraDGetChildByName(singe, "Image_2")
		clickImage:setTag(v.ID)
		clickImage:addTouchEventListener(handler(self, self.singleClickBack))
	end
	if #self.config > 8 then
		SoraDautoSortPos(self.Node_rewards, 5, 0, cc.size(100, 105), not SoraDFIsRA())
	else
		SoraDautoSortPos(self.Node_rewards, 4, 0, cc.size(110, 105), not SoraDFIsRA())
	end
	local optionalRewards = canyonTreasureCtrl:getOptinalRewardsByType(self.type)
	if optionalRewards and next(optionalRewards) then
		for i, v in ipairs(optionalRewards) do
			self:selectItem(v)
			table.insert(self.pastList, v)
		end
	end
	local optTimes = canyonTreasureCtrl:getOpTimesByType(self.type)
	local goldCost = canyonTreasureHuntRead.getGoldCostByTimes(optTimes)
	self.Button_ok:setVisible(optTimes <= 0)
	self.Button_change:setVisible(0 < optTimes)
	self.Text_gold1:setString(goldCost)
	local isChanged = self:isChooseListChanged()
	self.Button_change:setEnabled(isChanged)
	self.Button_change:setBright(isChanged)
end
function canyonTreasureRewardChoose:isChooseListChanged()
	local isChanged = false
	if next(self.choosList) then
		dump(self.pastList, "wkjerwehrkwejhr")
		dump(self.choosList, "wkjerwehrkwejhr222")
		for i, v in ipairs(self.choosList) do
			if v ~= self.pastList[i] then
				isChanged = true
				break
			end
		end
	else
		isChanged = true
	end
	return isChanged
end
function canyonTreasureRewardChoose:btnOkCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if #self.choosList == CHOOSE_MAX_NUM then
			table.sort(self.choosList)
			canyonTreasureCtrl:reqOptionalReward(self.type, self.choosList)
			SoraDShowLoading(SoraDSearchPanelFromManagerByName("canyonTreasureHuntView"))
			self:removeFromParent()
		else
			SoraDShowMsgTip(i18n("Canyon_Treasur_text_12"))
		end
	end
end
function canyonTreasureRewardChoose:btnChangeCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local optTimes = canyonTreasureCtrl:getOpTimesByType(self.type)
		local goldCost = canyonTreasureHuntRead.getGoldCostByTimes(optTimes)
		local ownGold = lordInfoCtrl:getBaseInfo().gold
		if goldCost > ownGold then
			SoraDShowMsgTip(i18n("Canyon_Treasur_text_13"))
			return
		end
		_ENV = i18n("Canyon_Treasur_text_13")
		i18n("Canyon_Treasur_text_13").num = goldCost
		local msgBoxPanel = SoraDShowMsgBox(i18n("Canyon_Treasur_text_19", i18n("Canyon_Treasur_text_13")), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				if #self.choosList == CHOOSE_MAX_NUM then
					table.sort(self.choosList)
					canyonTreasureCtrl:reqOptionalReward(self.type, self.choosList)
					SoraDShowLoading(SoraDSearchPanelFromManagerByName("canyonTreasureHuntView"))
					self:removeFromParent()
				else
					SoraDShowMsgTip(i18n("Canyon_Treasur_text_12"))
				end
			end
		end)
	end
end
function canyonTreasureRewardChoose:btnCancelCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function canyonTreasureRewardChoose:singleClickBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local index = button:getTag()
		self:selectItem(index)
		local isChanged = self:isChooseListChanged()
		self.Button_change:setEnabled(isChanged)
		self.Button_change:setBright(isChanged)
		if not self.imageList[index]:isVisible() and #self.choosList + 1 > CHOOSE_MAX_NUM then
			SoraDShowMsgTip(i18n("Canyon_Treasur_text_11"))
			return
		end
	end
end
function canyonTreasureRewardChoose:selectItem(index)
	local hasFind = false
	for i, v in ipairs(self.choosList) do
		if v == index then
			table.remove(self.choosList, i)
			self.imageList[index]:setVisible(false)
			hasFind = true
			break
		else
		end
	end
	if not hasFind and #self.choosList < CHOOSE_MAX_NUM then
		self.imageList[index]:setVisible(true)
		table.insert(self.choosList, index)
	end
	table.sort(self.choosList, function(left, right)
		return left < right
	end)
end
function canyonTreasureRewardChoose:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return canyonTreasureRewardChoose
