local luckyFalconGetRewardView = class("luckyFalconGetRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("luckyFalconGetRewardView")
	end
	return target
end)
function luckyFalconGetRewardView:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_confirm:setTitleText(i18n("common_text_054"))
	self.Text_title:setString(i18n("Promise_Summit_text_29"))
	self:setOpacity(100)
	self.frame_xyly_pattern_01_1_0:setOpacity(204.0)
	self.frame_xyly_pattern_01_1:setOpacity(204.0)
	self.Button_confirm:addTouchEventListener(handler(self, self.buttonConfirmCallBack))
end
function luckyFalconGetRewardView:initYumaoEffect()
	local effectym = SoraDCreatAnimation("xingyunlieyingjiangli", nil, false)
	effectym:setPosition(cc.p(0, 0))
	self.Center_Node:addChild(effectym, 10)
end
function luckyFalconGetRewardView:playCircleEffect(isPlay, parent)
	if isPlay then
		if parent.effectDropGold then
			SoraDResetEffectNode(parent.effectDropGold)
			parent.effectDropGold:setVisible(true)
			parent.effectDropGold.action:gotoFrameAndPlay(0, 98, true)
		else
			parent.effectDropGold = SoraDCreatAnimationEx("lieyingjiangli_single_2", nil, true)
			parent.effectDropGold:setScale(1.1)
			parent.effectDropGold:setPosition(cc.p(-2, -5))
			parent.effectDropGold:addTo(parent, 11)
		end
	elseif parent.effectDropGold then
		parent.effectDropGold:setVisible(false)
	end
end
function luckyFalconGetRewardView:initData(rewardList, isFirstLottery)
	if not rewardList then
		return
	end
	self.isFirstLottery = isFirstLottery
	self.rewardList = rewardList
	self.Image_1:setVisible(false)
	self.Image_3:setVisible(false)
	_UPVALUE2_ = self.Image_3
	self.Image_3[1] = cca.callFunc(function()
		self:initYumaoEffect()
	end)
	self.Image_3[2] = cca.delay(0.7833333333333333)
	self.Image_3[3] = cca.callFunc(function()
		self.Image_1:setVisible(true)
		self.Image_3:setVisible(true)
		local effect = SoraDCreatAnimation("Node_Effect_hjjm02", nil, false)
		effect:addTo(self.Image_1)
		effect:setPosition(0, 200)
		if #rewardList == 1 then
			local node = SoraDGetChildByName(effect, "Node_1")
			local cell = include("commonItemAward").new()
			cell:initData(rewardList[1].id, rewardList[1].count)
			cell:setOwnView(self)
			cell:setPosition(cc.p(23, 23))
			cell:addTo(SoraDGetChildByName(node, "wupin_4"))
			cell:setCascadeOpacityEnabled(true)
			_UPVALUE3_ = cell
			cell[1] = cca.delay(0.5)
			cell[2] = cca.callFunc(function()
				local effectSqure = SoraDCreatAnimation("lieyingjiangli_single", nil, false)
				effectSqure:addTo(cell, 10)
				effectSqure:setPosition(-2, -3)
			end)
			cell[3] = cca.delay(0.1)
			cell[4] = cca.callFunc(function()
			end)
			cell[5] = cca.callFunc(function()
			end)
			cell[6] = cca.callFunc(function()
			end)
			cell[7] = cca.callFunc(function()
			end)
			cell[8] = cca.callFunc(function()
			end)
			cell[9] = cca.callFunc(function()
			end)
			cell[10] = cca.callFunc(function()
			end)
			local seq = cca.seq(cell)
			self:runAction(seq)
		else
			for i, v in ipairs(rewardList) do
				local node = SoraDGetChildByName(effect, "Node_" .. i)
				local cell = include("commonItemAward").new()
				cell:setScale(0.75)
				cell:setBaseScale(1.0)
				cell:setOwnView(self)
				cell:initData(v.id, v.count)
				if i < 6 then
					node:setPosition(120 + (i - 1) * 100, 30)
				else
					node:setPosition(120 + (i - 6) * 100, -70)
				end
				cell:setPosition(cc.p(23, 23))
				cell:addTo(SoraDGetChildByName(node, "wupin_4"))
				cell:setCascadeOpacityEnabled(true)
				_UPVALUE3_ = cell
				cell[1] = cca.delay(0.5)
				cell[2] = cca.callFunc(function()
					local effectSqure = SoraDCreatAnimation("lieyingjiangli_single", nil, false)
					effectSqure:addTo(cell, 10)
					effectSqure:setPosition(-2, -3)
				end)
				cell[3] = cca.delay(0.1)
				cell[4] = cca.callFunc(function()
				end)
				cell[5] = cca.callFunc(function()
				end)
				local seq = cca.seq(cell)
				self:runAction(seq)
			end
		end
		if table.nums(rewardList) == 1 then
			effect:setPosition(100, 190)
		else
			self.nodeList, self = effect.setPosition, effect.setPosition
			for i = 1, 10 do
				local node = SoraDGetChildByName(effect, "Node_" .. i)
				if node then
					self.nodeList[i] = node
				end
			end
		end
		for i = #rewardList + 1, 10 do
			local node = SoraDGetChildByName(effect, "Node_" .. i)
			if node then
				node:setVisible(false)
			end
		end
	end)
	self.Image_3[4] = cca.callFunc(function()
		self.Image_1:setVisible(true)
		self.Image_3:setVisible(true)
		local effect = SoraDCreatAnimation("Node_Effect_hjjm02", nil, false)
		effect:addTo(self.Image_1)
		effect:setPosition(0, 200)
		if #rewardList == 1 then
			local node = SoraDGetChildByName(effect, "Node_1")
			local cell = include("commonItemAward").new()
			cell:initData(rewardList[1].id, rewardList[1].count)
			cell:setOwnView(self)
			cell:setPosition(cc.p(23, 23))
			cell:addTo(SoraDGetChildByName(node, "wupin_4"))
			cell:setCascadeOpacityEnabled(true)
			_UPVALUE3_ = cell
			cell[1] = cca.delay(0.5)
			cell[2] = cca.callFunc(function()
				local effectSqure = SoraDCreatAnimation("lieyingjiangli_single", nil, false)
				effectSqure:addTo(cell, 10)
				effectSqure:setPosition(-2, -3)
			end)
			cell[3] = cca.delay(0.1)
			cell[4] = cca.callFunc(function()
			end)
			cell[5] = cca.callFunc(function()
			end)
			cell[6] = cca.callFunc(function()
			end)
			cell[7] = cca.callFunc(function()
			end)
			cell[8] = cca.callFunc(function()
			end)
			cell[9] = cca.callFunc(function()
			end)
			cell[10] = cca.callFunc(function()
			end)
			local seq = cca.seq(cell)
			self:runAction(seq)
		else
			for i, v in ipairs(rewardList) do
				local node = SoraDGetChildByName(effect, "Node_" .. i)
				local cell = include("commonItemAward").new()
				cell:setScale(0.75)
				cell:setBaseScale(1.0)
				cell:setOwnView(self)
				cell:initData(v.id, v.count)
				if i < 6 then
					node:setPosition(120 + (i - 1) * 100, 30)
				else
					node:setPosition(120 + (i - 6) * 100, -70)
				end
				cell:setPosition(cc.p(23, 23))
				cell:addTo(SoraDGetChildByName(node, "wupin_4"))
				cell:setCascadeOpacityEnabled(true)
				_UPVALUE3_ = cell
				cell[1] = cca.delay(0.5)
				cell[2] = cca.callFunc(function()
					local effectSqure = SoraDCreatAnimation("lieyingjiangli_single", nil, false)
					effectSqure:addTo(cell, 10)
					effectSqure:setPosition(-2, -3)
				end)
				cell[3] = cca.delay(0.1)
				cell[4] = cca.callFunc(function()
				end)
				cell[5] = cca.callFunc(function()
				end)
				local seq = cca.seq(cell)
				self:runAction(seq)
			end
		end
		if table.nums(rewardList) == 1 then
			effect:setPosition(100, 190)
		else
			self.nodeList, self = effect.setPosition, effect.setPosition
			for i = 1, 10 do
				local node = SoraDGetChildByName(effect, "Node_" .. i)
				if node then
					self.nodeList[i] = node
				end
			end
		end
		for i = #rewardList + 1, 10 do
			local node = SoraDGetChildByName(effect, "Node_" .. i)
			if node then
				node:setVisible(false)
			end
		end
	end)
	local seq = cca.seq(self.Image_3)
	self:runAction(seq)
end
function luckyFalconGetRewardView:buttonConfirmCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isFirstLottery then
			uiManager:show("luckyFalconAdditionalView")
		end
		if self.rewardList then
			SoraDMailGainItems(self.rewardList, true)
		end
		self:removeFromParent()
	end
end
function luckyFalconGetRewardView:initScroll()
end
return luckyFalconGetRewardView
