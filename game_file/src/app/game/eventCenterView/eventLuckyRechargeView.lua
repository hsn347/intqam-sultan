local gametop = gModuleMgr.getObject("gametop")
local eventLuckyRechargeCtrl = gametop.playertop_:getModule("eventLuckyRechargeCtrl")
local eventLuckyRechargeView = class("eventLuckyRechargeView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventLuckyRechargeView")
	end
	return target
end)
function eventLuckyRechargeView:ctor()
	self:setBackGround(204.0)
	SoraDAddMessage(self, "MESSAGE_LUCKY_RECHARGE_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LUCKY_RECHARGE_REWARDBACK", handler(self, self.showRewards))
	self:bandWidget()
	local data = eventLuckyRechargeCtrl:getLuckyRechargeData()
	self:initData(data)
end
function eventLuckyRechargeView:bandWidget()
	self.labTitle = SoraDGetChildByName(self, "Text_name")
	self.labDes1 = SoraDGetChildByName(self, "Text_des1")
	self.labDes2 = SoraDGetChildByName(self, "Text_des2")
	self.labDes3 = SoraDGetChildByName(self, "Text_des3")
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.scroll:setContentSize(cc.size(450, 200))
	self.scroll:setInnerContainerSize(cc.size(450, 300))
	self.btnReceive = SoraDGetChildByName(self, "Button_receive")
	self.labReceive = SoraDGetChildByName(self, "Text_receive")
	self.image_title = SoraDGetChildByName(self, "Image_title")
	self.image_title:loadTexture(SoraDCheckPNG("bg_activity_luckyrecharge.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.node_reward = SoraDGetChildByName(self, "Node_reward")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_15")
	self.spriteIcon:setSpriteFrame("icon_recharge_gift.png")
	self.btnRecharge = SoraDGetChildByName(self, "btn_recharge")
	self.txtNormal = SoraDGetChildByName(self, "text_normal")
	self.txtNormal:setString(i18n("luckyrecharge_comment_04"))
	self.panel = SoraDGetChildByName(self, "Center_Panel_touch")
	self.panel:setPositionY(display.height / 2)
	self.labTitle:setString(i18n("luckyrecharge_comment_01"))
	self.labDes1:setString(i18n("luckyrecharge_comment_02"))
	self.labDes2:setString(i18n("$19.99"))
	self.labDes3:setString(i18n("luckyrecharge_comment_03"))
	self.labReceive:setString(i18n("common_text_854"))
	self.btnReceive:addTouchEventListener(handler(self, self.btnCallback))
	self.btnRecharge:addTouchEventListener(handler(self, self.btnjumpToCallback))
	local offsetX = 0
	offsetX = (self.labDes1:getContentSize().width - self.labDes2:getContentSize().width) / 2
	self.labDes1:setPositionX(272 + offsetX)
	self.labDes2:setPositionX(272 + offsetX)
end
function eventLuckyRechargeView:initData(data)
	self.state = data.rechargeStatus
	if self.state == gLuckyRechargeStatus.CAN_NOT_RECEIVE then
		self.labReceive:setString(i18n("common_text_2002"))
		self.btnReceive:loadTextures("btn_yellow_normal_01.png", "btn_yellow_normal_02.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
	elseif self.state == gLuckyRechargeStatus.CAN_RECEIVE then
		self.labReceive:setString(i18n("common_text_854"))
		self.btnReceive:loadTextures("btn_green_normal_01.png", "btn_green_normal_02.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
	elseif self.state == gLuckyRechargeStatus.ALREADY_RECEIVE then
		self.labReceive:setString(i18n("common_text_1892"))
		self.labReceive:setColor(display.COLOR_GREEN)
		self.btnReceive:setVisible(false)
	end
	if not data.reward then
		local _ENV, rewards = data.reward, data.reward
	end
	local dataCount = #rewards
	self.labDes2:setString(data.todayRechargeTarget and "$" .. data.todayRechargeTarget or "$19.99")
	local MAX_REWARD = 8
	dataCount = math.min(MAX_REWARD, math.floor(dataCount / 2) * 2)
	if dataCount == 0 then
		return
	end
	local MAX_COLUMN = 4
	local offsetX = 2
	local offsetY = -10
	local SINGLE_WIDTH = 120
	local SINGLE_HEIGHT = 100
	if dataCount <= MAX_COLUMN then
		offsetX = offsetX + (MAX_COLUMN - dataCount) / 2 * SINGLE_WIDTH
		offsetY = 42
	end
	local scrollMinH = 0
	local scrollH = math.max(scrollMinH, math.ceil(dataCount / MAX_COLUMN) * SINGLE_HEIGHT)
	self.scroll:setInnerContainerSize(cc.size(450, scrollH))
	local _ENV, positions = self.scroll.setInnerContainerSize, self.scroll.setInnerContainerSize
	for i = 1, MAX_REWARD do
		local column = (i - 1) % MAX_COLUMN + 1
		local row = math.ceil(i / MAX_COLUMN)
		_UPVALUE2_ = i / MAX_COLUMN
		;(i / MAX_COLUMN)[1] = offsetX + (column - 1) * SINGLE_WIDTH
		local (i / MAX_COLUMN)[2], position = offsetY + scrollH - (row - 1) * SINGLE_HEIGHT, i / MAX_COLUMN
		positions[#positions + 1] = position
	end
	if dataCount == 6 then
		for i = 1, dataCount do
			if i <= 2 then
				positions[i] = clone(positions[i + 1])
			else
				positions[i] = clone(positions[i + 2])
			end
		end
	end
	for i = 1, dataCount do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(positions[i][1], positions[i][2]))
		singleItem:addTo(self.scroll)
		singleItem:setScale(0.55)
		_ENV, _ENV = cc.p(positions[i][1], positions[i][2])
		cc.p(positions[i][1], positions[i][2]).id = rewards[i].key
		;(0.55).itemData, cc.p(positions[i][1], positions[i][2]).count = cc.p(positions[i][1], positions[i][2])
		singleItem:initData(0.55)
		singleItem:setButtonTag(rewards[i].key)
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
	if dataCount <= MAX_COLUMN * 2 then
		self.scroll:setTouchEnabled(false)
	else
		self.scroll:setTouchEnabled(true)
	end
end
function eventLuckyRechargeView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:removeItemDes(button)
	elseif type == ccui.TouchEventType.began then
		self:showItemDes(button)
	end
end
function eventLuckyRechargeView:btnCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.state == gLuckyRechargeStatus.CAN_NOT_RECEIVE then
			if GLOBAL_GAME_RECHARGE_MODE then
				uiManager:show("rechargeView")
			else
				SoraDCreatePanel("rechargeView"):show()
			end
			self:removeFromParent()
		elseif self.state == gLuckyRechargeStatus.CAN_RECEIVE then
			eventLuckyRechargeCtrl:sendReceiveReward()
			SoraDShowLoading(nil, nil, nil, nil, 3)
		end
	end
end
function eventLuckyRechargeView:btnjumpToCallback(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
		self:removeFromParent()
	end
end
function eventLuckyRechargeView:showItemDes(target)
	if self.tips then
		self.tips:removeFromParent()
		self.tips = nil
	end
	self.tips = SoraDCreatePanel("commonItemTips")
	self.tips:initData(target:getTag())
	local dt = 140
	if not SoraDFIsRA() then
		dt = -140
	end
	self.tips:setPosition(cc.p(320 + dt, 400))
	self.tips:addTo(self, 99)
end
function eventLuckyRechargeView:removeItemDes(target)
	if self.tips then
		self.tips:removeFromParent()
		self.tips = nil
	end
end
function eventLuckyRechargeView:updateView(...)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT) then
		self:removeFromParent()
		return
	end
	self.scroll:removeAllChildren()
	local data = eventLuckyRechargeCtrl:getLuckyRechargeData()
	self:initData(data)
end
function eventLuckyRechargeView:showRewards(...)
	SoraDCloseLoading()
	local data = eventLuckyRechargeCtrl:getLuckyRechargeData()
	local _ENV, itemData = eventLuckyRechargeCtrl, eventLuckyRechargeCtrl
	for i, v in ipairs(data.reward) do
		_ENV = nil
		;(nil).id = v.key
		;(nil).count = v.value
		table.insert(itemData, nil)
	end
	SoraDMailGainItems(itemData, true)
end
return eventLuckyRechargeView
