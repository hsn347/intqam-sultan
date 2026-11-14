local gametop = gModuleMgr.getObject("gametop")
local knightsChargeCtrl = gametop.playertop_:getModule("knightsChargeCtrl")
local knightsChargeRewardPop = class("knightsChargeRewardPop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("knightsChargeRewardPop")
	end
	return target
end)
function knightsChargeRewardPop:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_059"))
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeItem = SoraDGetChildByName(self, "Node_item")
	self.btnGet = SoraDGetChildByName(self, "Button_get")
	self.btnGet:addTouchEventListener(handler(self, self.btnGetClick))
	SoraDTestButton(self, function(...)
		self:doneBack()
	end)
end
function knightsChargeRewardPop:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_KNIGHTSCHARGE_ALLREFRESH", function(...)
		self:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_KNIGHTSCHARGE_REWARD", function(...)
		self:removeFromParent()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_KNIGHTSCHARGE_ERRBACK", function(...)
		SoraDCloseLoading(self)
	end)
end
function knightsChargeRewardPop:doneBack(...)
	self.knightData = knightsChargeCtrl:getKnightsChargeData()
	self:initView()
end
function knightsChargeRewardPop:initData(idx)
	self.boxData = knightsChargeCtrl.localClass.getBoxData(idx)
	self.knightData = knightsChargeCtrl:getKnightsChargeData()
	self:initView()
end
function knightsChargeRewardPop:initView(...)
	if not self.firstListItems then
		local publicRead = include("publicRead")
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local award = serviceFunctions.tableFormat(self.boxData.reward, nil)
		local perDis = 110
		local sPosX = -#award * perDis / 2
		for i, v in ipairs(award) do
			local item = self.nodeItem:clone()
			item:setScale(0.85)
			item:addTo(self.nodeReward)
			item:setPosition(sPosX + (i - 1) * perDis + perDis / 2, 0)
			local itemAward = SoraDGetExtendChildFromCCSByName(item, "CCS_commonItemAward")
			itemAward:setBaseScale(1.0)
			itemAward:setOwnView(self)
			itemAward:initData(v.id)
			local itemName = item:getChildByName("Text_itemName")
			itemName:setString(publicRead.getName(v.id))
		end
		self.firstListItems = true
	end
	local myNumStr = self.boxData.num
	if self.knightData.rewardFlag[tostring(myNumStr)] then
		self.myState = 1
		self.btnGet:setBright(false)
		self.btnGet:setTitleText(i18n("common_text_1892"))
	elseif myNumStr <= self.knightData.killNum then
		self.myState = 2
		self.btnGet:setBright(true)
		self.btnGet:setTitleText(i18n("common_text_1146"))
	else
		self.myState = 3
		self.btnGet:setBright(true)
		self.btnGet:setTitleText(i18n("common_text_054"))
	end
end
function knightsChargeRewardPop:btnGetClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.myState == 1 then
			SoraDShowMsgTip(i18n("common_text_1892"))
		elseif self.myState == 2 then
			knightsChargeCtrl:reqReward(self.boxData.num)
		elseif self.myState == 3 then
			self:removeFromParent()
		end
	end
end
return knightsChargeRewardPop
