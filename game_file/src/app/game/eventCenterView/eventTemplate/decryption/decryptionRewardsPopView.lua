local decryptionCtrl = SoraDGetCtrl("decryptionCtrl")
local decryptionRead = include("decryptionRead")
local decryptionRewardsPopView = class("decryptionRewardsPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("decryptionRewardsPopView_ros")
	end
	return target
end)
function decryptionRewardsPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
end
function decryptionRewardsPopView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("anniversary_uncover_text_04"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Button_receive"
	self.Button_receive = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	self.Button_receive:addTouchEventListener(handler(self, self.btnReceiveCallback))
end
function decryptionRewardsPopView:initData(data)
	self.index = data.index
	local rewards = decryptionRead.getBoxReward(self.index)
	local dataCount = 4
	for i = 1, dataCount do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(100 * i - 290, 40))
		singleItem:addTo(self.Node_rewards)
		singleItem:setScale(0.55)
		decryptionRead, decryptionRead = cc.p(100 * i - 290, 40)
		cc.p(100 * i - 290, 40).id = rewards[i].id
		;(0.55).itemData, cc.p(100 * i - 290, 40).count = cc.p(100 * i - 290, 40)
		singleItem:initData(0.55)
		singleItem:setButtonTag(rewards[i].id)
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
	if not decryptionCtrl:checkBoxState(self.index) then
		self.Button_receive:setTitleText(i18n("common_text_2139"))
		self.Button_receive:setBright(false)
	end
end
function decryptionRewardsPopView:btnReceiveCallback(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if decryptionCtrl:checkBoxState(self.index) then
			decryptionCtrl:sendReqGetReward(2, self.index)
			self:removeFromParent()
		end
	end
end
function decryptionRewardsPopView:showDetail(target, etype)
	if etype == ccui.TouchEventType.ended or etype == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif etype == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			if self.tips then
				self.tips:removeFromParent()
				self.tips = nil
			end
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(target:getTag())
			self.tips:setPosition(cc.p(180, display.cy + 210))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			if self.tips then
				self.tips:removeFromParent()
				self.tips = nil
			end
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(target:getTag())
			self.tips:setPosition(cc.p(180, display.cy + 210))
			self.tips:addTo(self, 99)
		end)
		self:runAction(cca.seq(nil))
	end
end
return decryptionRewardsPopView
