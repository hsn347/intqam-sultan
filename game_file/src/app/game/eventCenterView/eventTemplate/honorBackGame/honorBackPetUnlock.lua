local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
local friendsCallbackRead = include("friendsCallbackRead")
local honorBackPetUnlock = class("honorBackPetUnlock", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("honorBackPetUnlock")
	end
	return target
end)
function honorBackPetUnlock:ctor()
	local rewardConfing = friendsCallbackRead.getReturnCatRewardConfig()
	self.rechargeID = 13669
	paymentManager.OnemtOpenGiftUI(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
	self:initWidget()
	self:initData()
end
function honorBackPetUnlock:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("return_lcks_text_030"))
	self.Text_name1:setString(i18n("pet_name_14"))
	self.Text_name2:setString(i18n("pet_name_13"))
	self.Text_reward1:setString(i18n("return_lcks_text_031"))
	self.Text_des1:setString(i18n("return_lcks_text_032"))
	self.Text_des2:setString(i18n("return_lcks_text_033"))
	self.Text_reward2:setString(i18n("return_lcks_text_034"))
	self.Text_lockCondi:setString(i18n("return_lcks_text_014"))
	self.Text_unlock:setString(i18n("return_lcks_text_030"))
	self.Button_unlock:addTouchEventListener(handler(self, self.onClickUnlock))
	if SoraDFIsRA() then
		self.Sprite_bg:setFlippedX(true)
		self.Text_name1:setString(i18n("pet_name_13"))
		self.Text_name2:setString(i18n("pet_name_14"))
		self.Text_des1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.Text_des2:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	end
end
function honorBackPetUnlock:initData()
	self.curPetLv = friendPetCtrl:getInitData().curPetLv
	local config = self:getRewardConfig()
	for i, v in ipairs(config) do
		local node = v.widget
		for m, n in ipairs(v.reward) do
			if 5 < m then
				break
			end
			local single = SoraDCreatePanel("commonItemAward")
			single:addTo(node)
			single:setScale(0.7)
			single:setOwnView(self)
			single:initData(n.id, n.count)
			single:setPosition(0, 0)
			if v.needCoolSquare then
				single:showCoolSquare()
			end
		end
		local itemSize = cc.size(84, 84)
		local align = v.align
		if align == 1 then
			SoraDToCenter(node, itemSize.width, SoraDFIsRA())
		else
			SoraDautoSortPos(node, 6, align, itemSize)
		end
		node:setPositionY(node:getPositionY() - itemSize.height / 2 - 15)
	end
	if self.curPetLv > 2 then
		self.Button_unlock:setVisible(false)
		self.Text_lockCondi:setVisible(true)
	else
		self.Button_unlock:setVisible(true)
		self.Text_lockCondi:setVisible(false)
		local info = paymentManager.getPaymentBullets(self.rechargeID)
		local priceStr, __ = paymentManager.getRealPrice(info and info.pid, 19.99)
		self.Text_price:setString(priceStr)
		friendPetCtrl, _ENV = priceStr, self.Text_price
		priceStr.rechargeID = self.rechargeID
		self.Text_price[1] = priceStr
		SoraDCreateRechargeGiftNode(self.Text_price, SoraDGetChildByName(self, "Node_bottom"), cc.p(SoraDFPosX(-190, 0), 8))
	end
end
function honorBackPetUnlock:onClickUnlock(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD13)
		paymentManager.normalGiftBuyClassify(self.rechargeID)
	end
end
function honorBackPetUnlock:getRewardConfig(...)
	local expConfig = friendsCallbackRead.getReturnCatExpConfig()
	local friendsCallbackRead, allReward
	local friendsCallbackRead, curReward
	local friendsCallbackRead, tempTab
	for i, v in ipairs(expConfig) do
		if not v.highReward then
			friendsCallbackRead = v.highReward
		end
		for m, n in ipairs(v.highReward) do
			local index = tempTab[tostring(n.id)]
			if index then
				allReward[index].count = allReward[index].count + n.count
				if v.lv <= self.curPetLv then
					curReward[index].count = curReward[index].count + n.count
				end
			else
				friendsCallbackRead = n.count
				n.count.id = n.id
				n.count.count = n.count
				table.insert(allReward, n.count)
				if v.lv <= self.curPetLv then
					friendsCallbackRead = n.count
					n.count.id = n.id
					n.count.count = n.count
					table.insert(curReward, n.count)
				end
				tempTab[tostring(n.id)] = #allReward
			end
		end
	end
	local rewardConfing = friendsCallbackRead.getReturnCatRewardConfig()
	local highWalkReward = rewardConfing.highWalkReward
	friendsCallbackRead, friendsCallbackRead = nil, ipairs(expConfig)
	;(nil).widget = self.Node_reward1
	;(nil).reward = allReward
	;(nil).align = SoraDFIsRA() and 2 or 0
	friendsCallbackRead, ipairs(expConfig)[1], (nil).needCoolSquare = nil, nil, true
	;(nil).widget = self.Node_reward2
	;(nil).reward = highWalkReward
	;(nil).align = SoraDFIsRA() and 2 or 0
	friendsCallbackRead, ipairs(expConfig)[2], (nil).needCoolSquare = nil, nil, false
	;(nil).widget = self.Node_reward
	;(nil).reward = curReward
	;(nil).align = 1
	ipairs(expConfig)[3], (nil).needCoolSquare = nil, true
	local config = ipairs(expConfig)
	return config
end
return honorBackPetUnlock
