local amazingFortuneCtrl = SoraDGetCtrl("amazingFortuneCtrl")
local amazingFortuneRewardsPopView = class("amazingFortuneRewardsPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("amazingFortuneRewardsPopView")
	end
	return target
end)
function amazingFortuneRewardsPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	self:initData()
end
function amazingFortuneRewardsPopView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("decrypt_text_03"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE2_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	;("Center_Node")[2] = "ScrollView_rewards"
	self.scroll = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_des_up"
	self.Text_des_up = SoraDGetChildByFullPath(self.scroll, "Center_Node")
	self.Text_des_up:setString(i18n("valueTreasure_text_15"))
	_UPVALUE1_ = i18n("valueTreasure_text_15")
	i18n("valueTreasure_text_15")[1] = "Node_rewards_up"
	self.Node_rewards_up = SoraDGetChildByFullPath(self.scroll, i18n("valueTreasure_text_15"))
	_UPVALUE1_ = i18n("valueTreasure_text_15")
	i18n("valueTreasure_text_15")[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.scroll, i18n("valueTreasure_text_15"))
	self.Text_des:setString(i18n("valueTreasure_text_16"))
	_UPVALUE1_ = i18n("valueTreasure_text_16")
	i18n("valueTreasure_text_16")[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.scroll, i18n("valueTreasure_text_16"))
end
function amazingFortuneRewardsPopView:initData()
	local config = require_data("recharge_onecoin", true)
	local rechargeID = amazingFortuneCtrl:getRechargeID()
	if not config.data[rechargeID] or not config.data[rechargeID].result then
		local _ENV, result = config.data[rechargeID].result, config.data[rechargeID].result
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewards_up = serviceFunctions.tableFormat(result, nil)
	if rewards_up then
		for k, v in ipairs(rewards_up) do
			local single = SoraDCreatePanel("commonItemAward")
			single:addTo(self.Node_rewards_up)
			single:setScale(0.88)
			single:setOwnView(self)
			single:initData(v.id, v.count)
		end
		local align = SoraDFIsRA() and 2 or 0
		SoraDautoSortPos(self.Node_rewards_up, 4, align, cc.size(112, 103))
	end
	local rewards = amazingFortuneCtrl:getRewardsList()
	if rewards then
		for k, v in ipairs(rewards) do
			local single = SoraDCreatePanel("commonItemAward")
			single:addTo(self.Node_rewards)
			single:setScale(0.88)
			single:setOwnView(self)
			single:initData(v.id, v.count)
			if v.isActive then
				local sprite = display.newSprite("#dh_zengsong_button_04.png")
				sprite:addTo(single, 1)
			end
		end
		local align = SoraDFIsRA() and 2 or 0
		SoraDautoSortPos(self.Node_rewards, 4, align, cc.size(112, 103))
	end
	local count1 = math.ceil(#rewards_up / 4)
	local count2 = math.ceil(#rewards / 4)
	local cellH = 103
	local scrollH = 65 + count1 * cellH + 15 + 50 + count2 * cellH + 10
	scrollH = math.max(scrollH, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	scrollH = scrollH - 15
	self.Text_des_up:setPositionY(scrollH)
	scrollH = scrollH - 50 - count1 * cellH / 2
	self.Node_rewards_up:setPositionY(scrollH)
	scrollH = scrollH - count1 * cellH / 2 - 15
	self.Text_des:setPositionY(scrollH)
	scrollH = scrollH - 50 - count2 * cellH / 2
	self.Node_rewards:setPositionY(scrollH)
end
return amazingFortuneRewardsPopView
