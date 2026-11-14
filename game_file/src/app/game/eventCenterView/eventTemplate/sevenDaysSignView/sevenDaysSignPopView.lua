local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local sevenDaysSignCtrl = gametop.playertop_:getModule("sevenDaysSignCtrl")
local sevenDaysSignPopView = class("sevenDaysSignPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sevenDaysSignPopView")
	end
	return target
end)
function sevenDaysSignPopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	SoraDAddMessage(self, "MESSAGE_SEVENDAYSSIGN_SIGN_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:refreshBtnState()
		self:showRewards()
		self:removeFromParent()
	end)
end
function sevenDaysSignPopView:showRewards(...)
	SoraDCloseLoading()
	local reward = sevenDaysSignCtrl:getRewardInfo(self.signDay)
	local _ENV, itemData = sevenDaysSignCtrl, sevenDaysSignCtrl
	local itemCount = math.floor(#reward / 2)
	for i = 1, itemCount do
		_ENV = nil
		;(nil).id = reward[i * 2 - 1]
		;(nil).count = reward[i * 2]
		table.insert(itemData, nil)
	end
	SoraDMailGainItems(itemData, true)
end
function sevenDaysSignPopView:bandWidget()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	sevenDaysSignCtrl = "Center_Node"
	;("Center_Node")[1] = "Button_normal"
	self.Button_normal = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	self.Button_normal:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if sevenDaysSignCtrl:checkHasSign(self.signDay) then
				SoraDShowMsgTip(i18n("common_text_2874"))
				self:refreshBtnState()
			else
				local curDay = sevenDaysSignCtrl:getCurDay()
				if curDay > self.signDay then
					SoraDShowMsgTip(i18n("common_text_3070_ROS"))
					self:refreshBtnState()
				elseif curDay < self.signDay then
					SoraDShowMsgTip(i18n("common_text_3070"))
					self:refreshBtnState()
				elseif self.signDay == curDay then
					SoraDShowLoading(self)
					sevenDaysSignCtrl:sendReqSign()
				end
			end
		end
	end)
end
function sevenDaysSignPopView:initData(data)
	self.signDay = data.day
	local reward = sevenDaysSignCtrl:getRewardInfo(self.signDay)
	local itemCount = math.floor(#reward / 2)
	local offsetx = (itemCount - 1) * 130 / 2
	for i = 1, itemCount do
		local singleItem = include("itemSingleView").new()
		singleItem:addTo(self.Center_Node)
		singleItem:setScale(0.65)
		singleItem:setPosition(cc.p(270 + 130 * (i - 1) - offsetx, 95))
		singleItem:setItemClickCallback(handler(self, self.showDetail))
		sevenDaysSignCtrl, sevenDaysSignCtrl = handler(self, self.showDetail)
		handler(self, self.showDetail).id = reward[i * 2 - 1]
		handler(self, self.showDetail).itemData, handler(self, self.showDetail).count = handler(self, self.showDetail)
		singleItem:initData(handler(self, self.showDetail))
		singleItem:setButtonTag(reward[i * 2 - 1])
	end
	self:refreshBtnState()
end
function sevenDaysSignPopView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		button:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy + 240))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy + 240))
			self.tips:addTo(self, 99)
		end)
		button:runAction(cca.seq(nil))
	end
end
function sevenDaysSignPopView:refreshBtnState()
	local hasSign = sevenDaysSignCtrl:checkHasSign(self.signDay)
	if hasSign then
		self.Button_normal:setBright(false)
		self.Button_normal:setTitleText(i18n("common_text_2874"))
	else
		self.Button_normal:setTitleText(i18n("common_text_2873"))
		if self.signDay == sevenDaysSignCtrl:getCurDay() then
			self.Button_normal:setBright(true)
		else
			self.Button_normal:setBright(false)
		end
	end
end
function sevenDaysSignPopView:begin2Action(...)
	self.Center_Node:setScale(0.1)
end
function sevenDaysSignPopView:setFromAction(pos)
	local fromPos = self:convertToNodeSpace(pos)
	local toPos = cc.p(self.Center_Node:getPositionX(), self.Center_Node:getPositionY())
	self.Center_Node:setPosition(fromPos)
	_UPVALUE1_ = self.Center_Node:getPositionY()
	self.Center_Node:getPositionY()[1] = cca.scaleTo(0.3, 1)
	self.Center_Node:getPositionY()[2] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.Center_Node:getPositionY()[3] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.Center_Node:getPositionY()[4] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.Center_Node:getPositionY()[5] = cca.moveTo(0.3, toPos.x, toPos.y)
	self.Center_Node:runAction(cca.spawn(self.Center_Node:getPositionY()))
end
return sevenDaysSignPopView
