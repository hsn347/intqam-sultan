local publicRead = include("publicRead")
local eventPersonStageReward = class("eventPersonStageReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventPersonStageReward")
	end
	return target
end)
function eventPersonStageReward:ctor()
	self:bindBtnClose()
	self.text_title = SoraDGetChildByName(self, "Text_title")
	self.node_tip = SoraDGetChildByName(self, "Node_tip")
	self.text_toGet = SoraDGetChildByName(self.node_tip, "Text_toGet")
	self.text_canGet = SoraDGetChildByName(self.node_tip, "Text_canGet")
	self.text_reward = SoraDGetChildByName(self, "Text_reward")
	self.text_reward:setString(i18n("common_text_2708"))
	self.text_num = SoraDGetChildByName(self, "Text_num")
	self.text_num:setString(i18n("common_text_2709"))
	self.rewardSingle = SoraDGetChildByName(self, "Image_single")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_reward")
	SoraDGetChildByName(self, "Size_Tile_bg"):setFillType(1)
end
function eventPersonStageReward:initData(data, activityID)
	_ENV = nil
	;(nil).stage = data.stage
	self.text_title:setString(i18n("common_text_2710", nil))
	if activityID == gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY then
		_ENV = i18n("common_text_2710", nil)
		i18n("common_text_2710", nil).stage = data.stage
		self.text_title:setString(i18n("common_text_2728", i18n("common_text_2710", nil)))
	end
	_ENV = i18n("common_text_2728", i18n("common_text_2710", nil))
	i18n("common_text_2728", i18n("common_text_2710", nil)).point = data.needscore
	self.text_toGet:setString(i18n("common_text_2711", i18n("common_text_2728", i18n("common_text_2710", nil))))
	self.text_canGet:setString(i18n("common_text_2712"))
	SoraDToCenter(self.node_tip, 0)
	self:initReward(data.reward)
end
function eventPersonStageReward:initReward(tabReward)
	local scrollH = math.max(self.scroll:getContentSize().height, 80 * #tabReward)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	for i = 1, #tabReward do
		local itemID = tabReward[i].id
		local count = tabReward[i].count
		local reward
		if i == 1 then
			reward = self.rewardSingle
		else
			reward = self.rewardSingle:clone()
			reward:addTo(self.scroll)
		end
		if reward then
			local item = SoraDGetExtendChildFromCCSByName(reward, "CCS_commonItemAward")
			item:setScale(0.7)
			item:setBaseScale(1.0)
			item:setOwnView(self)
			item:initData(itemID)
			SoraDGetChildByName(reward, "Text_itemDes"):setString(publicRead.getName(itemID))
			SoraDGetChildByName(reward, "Text_itemNum"):setString("x" .. count)
			reward:setPosition(cc.p(0, scrollH - 80 * i))
		end
	end
end
return eventPersonStageReward
