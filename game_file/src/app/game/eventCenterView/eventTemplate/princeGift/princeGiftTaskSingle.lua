local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
local princeGiftRead = include("princeGiftRead")
local princeGiftTaskSingle = class("princeGiftTaskSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("princeGiftTaskSingle")
	end
	return target
end)
local maxAwardNum = 3
function princeGiftTaskSingle:ctor()
	self.goldAwardList, _ENV, self.normalAwardList, _ENV = nil, nil, nil, nil
	self.imgLock = SoraDGetChildByName(self, "icon_lock_gold")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setVisible(false)
	self.normalReward = SoraDGetChildByName(self, "Node_reward_Normal")
	self.imgLightLeft = SoraDGetChildByName(self, "image_Light_Left")
	SoraDMixtureGLONE(self.imgLightLeft)
	self.leftEffectNode = SoraDGetChildByName(self, "Node_reward_Normal_Effect")
	if not self.normalActionNode then
		self.normalActionNode = SoraDCreatAnimationEx("princeGiftTaskEffect", nil, true)
		self.normalActionNode:addTo(self.leftEffectNode)
	end
	self.highReward = SoraDGetChildByName(self, "Node_reward_high")
	self.imgLightRight = SoraDGetChildByName(self, "image_Light_Right")
	SoraDMixtureGLONE(self.imgLightRight)
	self.rightEffectNode = SoraDGetChildByName(self, "Node_reward_high_Effect")
	if not self.hightActionNode then
		self.hightActionNode = SoraDCreatAnimationEx("princeGiftTaskEffect", nil, true)
		self.hightActionNode:addTo(self.rightEffectNode)
	end
	SoraDGetChildByName(self.hightActionNode, "Node_Buff"):setVisible(false)
	SoraDGetChildByName(self.normalActionNode, "Node_Buff"):setVisible(false)
	self.nodeBuff = SoraDGetChildByName(self.hightActionNode, "Node_Buff")
end
function princeGiftTaskSingle:initData(parent, index, curLv)
	self.parentView = parent
	self.index = index
	self.taskInfo = princeGiftRead.getTaskInfoByLevel(self.index)
	local lastLv = princeGiftCtrl:getLastLv()
	print("lastLv", lastLv)
	self.hightActionNode:setVisible(false)
	self.normalActionNode:setVisible(false)
	self.hightActionNode.action:gotoFrameAndPause(0)
	self.normalActionNode.action:gotoFrameAndPause(0)
	self.imgLightRight:setVisible(false)
	self.imgLightLeft:setVisible(false)
	SoraDGetChildByName(self, "icon_lock_normal"):setVisible(princeGiftCtrl:getWhichStage() == 1)
	local isBuy = princeGiftCtrl:getIsBuy()
	self.imgLock:setVisible(not isBuy)
	local isGot = princeGiftCtrl:isReceiveReward(1, index)
	local canGet = false
	if index <= curLv and not isGot and not princeGiftCtrl:isReceiveReward(1, index) then
		canGet = true
	end
	self.normalAwardList = self:initAwardNode(self.normalReward, self.normalAwardList, false, isGot, canGet)
	if canGet then
		self:playSingleAnimation(index > lastLv, false, canGet)
	end
	canGet = false
	local isGoldGot = princeGiftCtrl:isReceiveReward(2, index)
	if index <= curLv and not isGoldGot and not princeGiftCtrl:isReceiveReward(2, index) then
		canGet = true
	end
	if index == 1 then
		self.textTips:setVisible(true)
		self.textTips:setString(i18n("Payment_activity_optimization_text_28"))
		self.nodeBuff:setVisible(canGet)
	end
	self.goldAwardList = self:initAwardNode(self.highReward, self.goldAwardList, true, isGoldGot, canGet)
	if canGet then
		self:playSingleAnimation(index > lastLv, true, canGet)
	end
end
function princeGiftTaskSingle:initAwardNode(parent, nodeList, isGold, isGot, canGet)
	local showCanGetEffect = true
	local _ENV, awardList
	if isGold then
		if self.index == 1 then
			_ENV, _ENV = nil, self.index
			;(nil).id = 554
			awardList, self.index[1], (nil).count = self.index, nil, 1
			showCanGetEffect = false
		else
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			awardList = serviceFunctions.tableFormat(self.taskInfo.gift_2, nil)
		end
	else
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		awardList = serviceFunctions.tableFormat(self.taskInfo.gift_1, nil)
	end
	for i = 1, math.min(#awardList, maxAwardNum) do
		local single = nodeList[i]
		if not single then
			single = include("princeGiftTaskRewardSingle").new()
			single:setOwnView(self.parentView)
			single:setPosition(0, 0)
			single:addTo(parent)
			table.insert(nodeList, single)
		end
		single:initData(awardList[i], isGot, canGet, showCanGetEffect)
		single:setVisible(true)
	end
	for i = maxAwardNum + 1, #nodeList do
		nodeList[i]:setVisible(false)
	end
	SoraDToCenter(parent, 85, SoraDFIsRA())
	return nodeList
end
function princeGiftTaskSingle:playSingleAnimation(isfirst, ishigh, canGet)
	if ishigh then
		if isfirst then
			self.imgLightRight:setVisible(false)
			SoraDGetChildByName(self.hightActionNode, "Node_Effect_dfwz02_002"):setVisible(true)
			SoraDGetChildByName(self.hightActionNode, "Node_Effect_dfwz02_003"):setVisible(true)
			self:updateGoldAwardEffect(true)
		else
			self.imgLightRight:setVisible(true)
			SoraDGetChildByName(self.hightActionNode, "Node_Effect_dfwz02_002"):setVisible(false)
			SoraDGetChildByName(self.hightActionNode, "Node_Effect_dfwz02_003"):setVisible(false)
			self:updateGoldAwardEffect(false)
		end
		self.hightActionNode:setVisible(true)
		self.hightActionNode.action:gotoFrameAndPlay(0, true)
		self.hightActionNode.action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			if frameEvent and frameEvent == "EndShow" and canGet then
				self.imgLightRight:setVisible(true)
				SoraDGetChildByName(self.hightActionNode, "Node_Effect_dfwz02_002"):setVisible(false)
				SoraDGetChildByName(self.hightActionNode, "Node_Effect_dfwz02_003"):setVisible(false)
				self:updateGoldAwardEffect(false)
			end
		end)
	else
		if isfirst then
			self.imgLightLeft:setVisible(false)
			SoraDGetChildByName(self.normalActionNode, "Node_Effect_dfwz02_002"):setVisible(true)
			SoraDGetChildByName(self.normalActionNode, "Node_Effect_dfwz02_003"):setVisible(true)
			self:updateNormalAwardEffect(true)
		else
			self.imgLightLeft:setVisible(true)
			SoraDGetChildByName(self.normalActionNode, "Node_Effect_dfwz02_002"):setVisible(false)
			SoraDGetChildByName(self.normalActionNode, "Node_Effect_dfwz02_003"):setVisible(false)
			self:updateNormalAwardEffect(false)
		end
		self.normalActionNode:setVisible(true)
		self.normalActionNode.action:gotoFrameAndPlay(0, true)
		self.normalActionNode.action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			if frameEvent and frameEvent == "EndShow" and canGet then
				self.imgLightLeft:setVisible(true)
				SoraDGetChildByName(self.normalActionNode, "Node_Effect_dfwz02_002"):setVisible(false)
				SoraDGetChildByName(self.normalActionNode, "Node_Effect_dfwz02_003"):setVisible(false)
				self:updateNormalAwardEffect(false)
			end
		end)
	end
end
function princeGiftTaskSingle:updateNormalAwardEffect(isVisible)
	for i, v in ipairs(self.normalAwardList) do
		v:updateFirstEffect(isVisible)
	end
end
function princeGiftTaskSingle:updateGoldAwardEffect(isVisible)
	for i, v in ipairs(self.goldAwardList) do
		v:updateFirstEffect(isVisible)
	end
end
return princeGiftTaskSingle
