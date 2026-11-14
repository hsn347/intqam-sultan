local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventSevenDays = class("eventSevenDays", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventSevenDays")
	end
	return target
end)
function eventSevenDays:ctor()
	self.isAddToPopManager = true
	local title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	title:setTitle(i18n("common_text_3789"))
	title:setTitleWidthHeight(cc.size(450, 100))
	self.nodeTime = SoraDGetChildByName(self, "Top_Node_time")
	self.text_time = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.text_time:setTimeEndListener(function()
		self:judgeClose()
	end)
	self.node_info_1 = SoraDGetChildByName(self, "Node_Info_1")
	self.node_info_2 = SoraDGetChildByName(self, "Node_Info_2")
	self.node_info_3 = SoraDGetChildByName(self, "Node_Info_3")
	local text_tip = SoraDGetChildByName(self, "Text_tip")
	text_tip:setString(i18n("common_text_3792"))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_SEVENDAYS", handler(self, self.updateData))
	self:adjustPos()
	self:bind()
	self:initData()
	self:addFireEffect()
	local rechargeGiftDataModuleAPI = include("rechargeGiftDataModuleAPI")
	rechargeGiftDataModuleAPI:updateSaveTime()
end
function eventSevenDays:judgeClose()
	local rechargeGiftDataModuleAPI = include("rechargeGiftDataModuleAPI")
	if not rechargeGiftDataModuleAPI:isSevenDaysOpen() then
		self:removeFromParent()
	end
end
function eventSevenDays:addFireEffect()
	local fireLeft = SoraDGetChildByName(self, "fire_left")
	local fireRight = SoraDGetChildByName(self, "fire_right")
	SoraDCreateFireEffectNode(fireLeft, fireRight)
end
function eventSevenDays:adjustPos()
	local content = SoraDGetChildByName(self, "Top_Size_baseBg")
	local height = (content:getContentSize().height - 130) / 3
	height = math.min(height, 400)
	self:adjustPosNode(self.node_info_1, height, 1)
	self:adjustPosNode(self.node_info_2, height, 2)
	self:adjustPosNode(self.node_info_3, height, 3)
end
function eventSevenDays:adjustPosNode(node, height, index)
	local posY = -height * index
	node:setPositionY(posY)
	local size = node:getContentSize()
	size.height = height
	node:setContentSize(size)
	local divide_top = SoraDGetChildByName(node, "Image_divide_top")
	if divide_top then
		divide_top:setPositionY(height)
	end
	local node_tip = SoraDGetChildByName(node, "node_tip")
	if node_tip then
		node_tip:setPositionY(height)
	end
end
function eventSevenDays:bind()
	self:bindNode(self.node_info_1, 1)
	self:bindNode(self.node_info_2, 2)
	self:bindNode(self.node_info_3, 3)
end
function eventSevenDays:bindNode(node, tag)
	local btnBuy = SoraDGetChildByName(node, "btn_box")
	btnBuy:setTag(tag)
	btnBuy:setTouchEnabled(false)
	btnBuy:addTouchEventListener(handler(self, self.btnClickCallBack))
	local img = SoraDGetChildByName(node, "img_box")
	img:setTag(tag)
	img:setTouchEnabled(false)
	img:addTouchEventListener(handler(self, self.imgClickCallBack))
end
function eventSevenDays:initData()
	local rechargeGiftDataModuleAPI = include("rechargeGiftDataModuleAPI")
	local data = rechargeGiftDataModuleAPI:getGiftListOf7d()
	self.rechargeData = clone(data)
	table.sort(self.rechargeData, function(a, b)
		if a.alreadyBuy ~= b.alreadyBuy then
			return b.alreadyBuy
		end
		if a.canBuy ~= b.canBuy then
			return a.canBuy
		end
		local acondition = a.condition[gRechargeGiftCondType.CASTLE_LEVEL]
		local bcondition = b.condition[gRechargeGiftCondType.CASTLE_LEVEL]
		if acondition and bcondition and acondition.aim ~= bcondition.aim then
			return acondition.aim < bcondition.aim
		end
		return a.rid < b.rid
	end)
	self:setNodeInfo(self.node_info_1, 1)
	self:setNodeInfo(self.node_info_2, 2)
	self:setNodeInfo(self.node_info_3, 3)
	local leftTime = rechargeGiftDataModuleAPI:get7DLeftTime()
	if leftTime then
		self.nodeTime:setVisible(true)
		self.text_time:beginTime(leftTime)
	else
		self.nodeTime:setVisible(false)
	end
end
function eventSevenDays:setNodeInfo(node, tag)
	local data = self.rechargeData[tag]
	if not data then
		print("eventSevenDays data error", tag)
		return
	end
	local id = data.rid
	if not id then
		print("eventSevenDays id error", tag)
		return
	end
	local rechargeRead = include("rechargeRead")
	local info = rechargeRead.getPageViewData(id)
	if not info then
		print("eventSevenDays info error", tag)
		return
	end
	local img = SoraDGetChildByName(node, "img_box")
	img:setTouchEnabled(true)
	img:loadTexture(SoraDCheckPNG(info.activeBg, gDefaultPNG.RECHARGE_PAGEBG), ccui.TextureResType.plistType)
	local txt_level = SoraDGetChildByName(node, "text_level")
	local limitLv, level = self:checkLevelLimit(data)
	if limitLv and level then
		data.limitLv = level
		txt_level:setVisible(true)
		_ENV = nil
		;(nil).level = level
		txt_level:setString(i18n("common_text_3790", nil))
	else
		txt_level:setVisible(false)
	end
	local price
	local rechargeGiftDataModuleAPI = include("rechargeGiftDataModuleAPI")
	local sevenDayData = rechargeGiftDataModuleAPI:getRechargeInfo(id)
	if sevenDayData then
		local showPrice, isGetPrice = paymentManager.judgePrice(id, sevenDayData.price)
		price = showPrice
	end
	if price then
		data.showPrice = price
	end
	local btnBuy = SoraDGetChildByName(node, "btn_box")
	if data.alreadyBuy then
		btnBuy:setTouchEnabled(false)
		btnBuy:setBright(false)
		btnBuy:setTitleText(i18n("common_text_3833"))
	elseif data.canBuy and not limitLv then
		btnBuy:setTouchEnabled(true)
		btnBuy:setBright(true)
		btnBuy:setTitleText(price)
	else
		btnBuy:setBright(false)
		btnBuy:setTouchEnabled(false)
		btnBuy:setTitleText(price)
	end
	local text_tip = SoraDGetChildByName(node, "text_tip")
	if info.activeExplain ~= "" then
		if 1 == tag then
			SoraDSetTextWidthHeight(text_tip, cc.size(510, 50))
		else
			SoraDSetTextWidthHeight(text_tip, cc.size(600, 50))
		end
		text_tip:setString(i18n(info.activeExplain))
	else
		text_tip:setString("")
	end
end
function eventSevenDays:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		local data = self.rechargeData[tag]
		if data then
			local id = data.rid
			if id then
				paymentManager.normalGiftBuyClassify(id)
				paymentManager.OnemtReadyBuy(id, gRechargeActiveFromEnum.ROAD12, false)
			end
		end
	end
end
function eventSevenDays:imgClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		local data = self.rechargeData[tag]
		if data then
			local id = data.rid
			if id then
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).id = id
					_ENV, (nil).fromCenter = gRechargeActiveFromEnum.ROAD12, gRechargeActiveFromEnum.ROAD12
					;(nil).otherInfo, gRechargeActiveFromEnum.ROAD12.info = gRechargeActiveFromEnum.ROAD12, data
					uiManager:show("rechargePopView", nil)
				else
					local panel = SoraDCreatePanel("rechargePopView")
					_ENV = nil
					;(nil).info = data
					panel:initData(id, gRechargeActiveFromEnum.ROAD12, nil, nil)
					panel:show()
				end
			end
		end
	end
end
function eventSevenDays:updateData()
	self:initData()
end
function eventSevenDays:checkLevelLimit(data)
	if data.condition then
		local condition = data.condition[gRechargeGiftCondType.CASTLE_LEVEL]
		if condition then
			return not condition.state, condition.aim
		end
	end
	return false
end
return eventSevenDays
