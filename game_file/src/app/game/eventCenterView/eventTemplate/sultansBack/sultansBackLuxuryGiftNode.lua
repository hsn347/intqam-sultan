local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackLuxuryGiftNode = class("sultansBackLuxuryGiftNode", function(target)
	local target = SoraDCreateBasePanel("sultansBackLuxuryGiftNode")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackLuxuryGiftNode:onEnterPanel()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
function sultansBackLuxuryGiftNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.SULTAN_BACK_LUXURYGIFT_ACTIVITY
	self:initWidget()
	SoraDCreatAnimation(self.__cname, self, true)
	local amount = math.max(0.99, sultansBackRead.getBackFirstRechargeAmount())
	self.price = "US $" .. amount
end
function sultansBackLuxuryGiftNode:reqInitData(...)
	sultansBackCtrl:reqLuxuryGiftInit()
	SoraDShowLoading(self.parentView)
end
function sultansBackLuxuryGiftNode:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.Button_receive:addTouchEventListener(handler(self, self.btnReceiveClick))
	local effectNode = SoraDCreatAnimation("sultansBackLuxuryGift_up")
	effectNode:setPosition(cc.p(365, -576))
	self.Node_box:addChild(effectNode)
	local particle = SoraDGetChildByName(effectNode, "Particle_1")
	particle:setVisible(false)
	local effectNode = SoraDCreatAnimation("sultansBackLuxuryGift_down")
	effectNode:setPosition(cc.p(365, -576))
	self.Node_box:addChild(effectNode, -1)
	if display.height < 1000 then
		if display.height < 860 then
			self.Node_box:setPositionY(self.Node_box:getPositionY() - 40)
		end
		self.bg_hghl_ipad1:setVisible(false)
		self.bg_hghl_ipad2:setVisible(false)
	elseif display.height > 1136 then
		local offsety = display.height - 1136
		local iSize = self.Image_back:getContentSize()
		self.Image_back:setContentSize(cc.size(iSize.width, iSize.height + offsety))
		self.Node_box:setPositionY(self.Node_box:getPositionY() + offsety / 2)
	end
end
function sultansBackLuxuryGiftNode:initData()
	self:initActivityTime()
	_ENV = nil
	;(nil).price = self.price
	self.Text_des:setString(i18n("back_first_charge_text01", nil))
	local rewards = sultansBackRead.getBackFirstRechargeRewards()
	for i, v in ipairs(rewards) do
		local award = SoraDCreatePanel("commonItemAward")
		award:addTo(self.Node_rewards)
		award:setOwnView(self.parentView)
		award:initData(v.id, v.count)
		award:setPosition(0, 0)
		award:setScale(0.8)
	end
	SoraDToCenter(self.Node_rewards, 110, SoraDFIsRA())
	self:refreshBtnState()
end
function sultansBackLuxuryGiftNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_LUXURYGIFT_REFRESH", function()
		SoraDCloseLoading(self.parentView)
		self:refreshBtnState()
	end)
end
function sultansBackLuxuryGiftNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, nil, SoraDFIsRA())
	else
		self.Node_time:setVisible(false)
	end
end
function sultansBackLuxuryGiftNode:btnReceiveClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.state == 2 then
			return
		end
		if self.state == 1 then
			sultansBackCtrl:reqLuxuryGiftReward()
			SoraDShowLoading(self.parentView)
			return
		end
		_ENV = nil
		;(nil).price = self.price
		local showMsg = i18n("back_first_charge_text02", nil)
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
				paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
			end
		end)
	end
end
function sultansBackLuxuryGiftNode:setParentView(parent)
	self.parentView = parent
end
function sultansBackLuxuryGiftNode:refreshBtnState(...)
	local data = sultansBackCtrl:getActivityData(self.activityID)
	self.state = data.reward or 0
	self.Button_receive:setTouchEnabled(true)
	self.G_dh_Tex_hghl_002:setVisible(false)
	if self.state == 0 then
		self.Button_receive:setTitleText(i18n("common_text_1146"))
	elseif self.state == 1 then
		self.Button_receive:setTitleText(i18n("back_first_charge_text07"))
		self.G_dh_Tex_hghl_002:setVisible(true)
	elseif self.state == 2 then
		self.Button_receive:setTitleText(i18n("common_text_1892"))
		self.Button_receive:setTouchEnabled(false)
	end
end
return sultansBackLuxuryGiftNode
