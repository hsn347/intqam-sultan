local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityCommonBubbleCtrl = class("activityCommonBubbleCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activityCommonBubbleCtrl:ctor(properties)
	activityCommonBubbleCtrl.super.ctor(self, properties)
	activityCommonBubbleCtrl.super.ctor.colorList, activityCommonBubbleCtrl, activityCommonBubbleCtrl.super.ctor.bubbleMap, activityCommonBubbleCtrl, activityCommonBubbleCtrl, self.activityData, activityCommonBubbleCtrl = self, self, self, self, activityCommonBubbleCtrl.super.ctor, activityCommonBubbleCtrl.super.ctor, activityCommonBubbleCtrl.super.ctor
	activityCommonBubbleCtrl.super.ctor.freeReceiveTime = 0
	activityCommonBubbleCtrl.super.ctor.level = 0
	activityCommonBubbleCtrl.super.ctor.guide = false
	activityCommonBubbleCtrl.super.ctor.stageMark, activityCommonBubbleCtrl, activityCommonBubbleCtrl.super.ctor.point = self, self, 0
	activityCommonBubbleCtrl.super.ctor.buyCount = 0
	activityCommonBubbleCtrl.super.ctor.buyTime = 0
	self.defaultData, activityCommonBubbleCtrl.super.ctor.guide = activityCommonBubbleCtrl.super.ctor, false
	self:resetData()
end
function activityCommonBubbleCtrl:EnterGame()
	_ENV = nil
	_ENV = nil
	;(nil).module = gCmd.CMD_USER_ACTIVITY_MODULE
	;(nil).init = gCmd.REQ_BOBBLE_ADVENTURE_INIT
	;(nil).shoot = gCmd.REQ_BOBBLE_ADVENTURE_SHOOT
	;(nil).free = gCmd.REQ_BOBBLE_ADVENTURE_RECEIVE_FREE_REWARD
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001664], (nil).guide = nil, gCmd.REQ_BOBBLE_ADVENTURE_GUIDE
	_ENV = nil
	;(nil).module = gCmd.CMD_USER_ACTIVITY_MODULE
	;(nil).init = gCmd.REQ_PUZZLE_BOBBLE_INIT
	;(nil).buy = gCmd.REQ_PUZZLE_BOBBLE_BUY
	;(nil).shoot = gCmd.REQ_PUZZLE_BOBBLE_SHOOT
	;(nil).free = gCmd.REQ_PUZZLE_BOBBLE_RECEIVE_FREE_REWARD
	;(nil).stage = gCmd.REQ_PUZZLE_BOBBLE_RECEIVE_STAGE_REWARD
	self.cmdConfig, (nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001638], (nil).guide = nil, nil, gCmd.REQ_PUZZLE_BOBBLE_GUIDE
	local constantRead = include("constantRead")
	local cfg = self.cmdConfig[gActivityTimeActivityID.NORMAL_ACTIVITY_9001664]
	msgCtrl = nil
	;(nil)[1] = 869702
	local value = constantRead.getConstValueArray("DESSERT_FIGHT_DAILY_REWARD", nil)
	cfg.itemID2 = value[1]
	local cfg = self.cmdConfig[gActivityTimeActivityID.NORMAL_ACTIVITY_9001664]
	msgCtrl = nil
	;(nil)[1] = 869702
	local value = constantRead.getConstValueArray("BUBBLE_FIGHT_DAILY_REWARD", nil)
	cfg.itemID = value[1]
	local cfg = self.cmdConfig[gActivityTimeActivityID.NORMAL_ACTIVITY_9001638]
	msgCtrl = nil
	;(nil)[1] = 869701
	local value = constantRead.getConstValueArray("EDIAL_BUBBLE_BOBBLE_DAILY_REWARD", nil)
	cfg.itemID = value[1]
	cfg.buyMax = constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_SALE", 3)
	_ENV, cfg.buyPrice = constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100), constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100)
	constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100).init = handler(self, self.reqInitRsp)
	constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100).buy = handler(self, self.reqBuyRsp)
	constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100).shoot = handler(self, self.reqShootRsp)
	constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100).free = handler(self, self.reqFreeRewardRsp)
	constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100).stage = handler(self, self.reqStageRewardRsp)
	local constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100).guide, config = handler(self, self.reqGuideRsp), constantRead.getConstValue("EDIAL_BUBBLE_BOBBLE_ITEM_PRICE", 100)
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		local cmd_module = cmdCfg.module
		for key, cmd_req in pairs(cmdCfg) do
			if key ~= "module" and config[key] then
				msgCtrl.register(cmd_module, cmd_req, config[key])
			end
		end
	end
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
end
function activityCommonBubbleCtrl:Logout()
	activityCommonBubbleCtrl.super.Logout(self)
	self:resetData()
end
function activityCommonBubbleCtrl:resetData(activityID)
	if activityID then
		self.activityData[activityID], _UPVALUE0_ = nil, nil
	else
		self.activityData, _UPVALUE0_ = self.activityData, self.activityData
	end
end
function activityCommonBubbleCtrl:initClientData(activityID, userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(activityID)]
	if activityData and next(activityData) then
		dump(activityData, "==activityCommonBubbleCtrl:initClientData==", 10)
		self.activityData[activityID] = activityData
	end
end
function activityCommonBubbleCtrl:activityInitRsp(target, event)
	local activityID = event.activityID
	if self.cmdConfig[activityID] then
		dump(event, "==activityCommonBubbleCtrl:activityInitRsp==", 10)
		self.activityData[activityID] = event.initData
		_ENV = event.initData
		event.initData.msg = "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE"
		event.initData.activityID = activityID
		event.initData.subMsg = "init"
		SoraDSendMessage(event.initData)
	end
end
function activityCommonBubbleCtrl:sendReqInitDataMsg(activityID)
	self:reqInit(activityID)
end
function activityCommonBubbleCtrl:reqInit(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.init, nil, nil)
end
function activityCommonBubbleCtrl:reqInitRsp(content)
	dump(content, "activityCommonBubbleCtrl:reqInitRsp(content)", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local activityID = content.clientData.activityID
	self.activityData[activityID] = content.rspdata
	_ENV = content.rspdata
	content.rspdata.msg = "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE"
	content.rspdata.activityID = activityID
	content.rspdata.subMsg = "init"
	SoraDSendMessage(content.rspdata)
end
function activityCommonBubbleCtrl:reqBuy(activityID, count)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).count = nil, count
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.buy, nil, nil)
end
function activityCommonBubbleCtrl:reqBuyRsp(content)
	dump(content, "activityCommonBubbleCtrl:reqBuyRsp(content)", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local activityID = content.clientData.activityID
	self.activityData[activityID] = content.rspdata
	if not content.rspdata.rewards then
		_ENV = content.rspdata.rewards
	end
	SoraDMailGainItems(content.rspdata.rewards, true)
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE"
	content.rspdata.rewards.activityID = activityID
	content.rspdata.rewards.subMsg = "buy"
	SoraDSendMessage(content.rspdata.rewards)
end
function activityCommonBubbleCtrl:reqShoot(activityID, x, y, color, count)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	;(nil).x = x
	;(nil).y = y
	;(nil).color = color
	local (nil).count, data = count, nil
	serverproxy = nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.shoot, data, nil)
end
function activityCommonBubbleCtrl:reqShootRsp(content)
	dump(content, "activityCommonBubbleCtrl:reqShootRsp(content)", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local activityID = content.clientData.activityID
	self.activityData[activityID] = content.rspdata
	if not content.rspdata.rewards then
		_ENV = content.rspdata.rewards
	end
	SoraDMailGainItems(content.rspdata.rewards, true)
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE"
	content.rspdata.rewards.activityID = activityID
	content.rspdata.rewards.subMsg = "shoot"
	SoraDSendMessage(content.rspdata.rewards)
end
function activityCommonBubbleCtrl:reqFreeReward(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.free, nil, nil)
end
function activityCommonBubbleCtrl:reqFreeRewardRsp(content)
	dump(content, "activityCommonBubbleCtrl:reqFreeRewardRsp(content)", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local activityID = content.clientData.activityID
	self.activityData[activityID] = content.rspdata
	if not content.rspdata.rewards then
		_ENV = content.rspdata.rewards
	end
	SoraDMailGainItems(content.rspdata.rewards, true)
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE"
	content.rspdata.rewards.activityID = activityID
	content.rspdata.rewards.subMsg = "free"
	SoraDSendMessage(content.rspdata.rewards)
end
function activityCommonBubbleCtrl:reqStageReward(activityID, index)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).index = nil, index
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.stage, nil, nil)
end
function activityCommonBubbleCtrl:reqStageRewardRsp(content)
	dump(content, "activityCommonBubbleCtrl:reqStageRewardRsp(content)", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local activityID = content.clientData.activityID
	self.activityData[activityID] = content.rspdata
	if not content.rspdata.rewards then
		_ENV = content.rspdata.rewards
	end
	SoraDMailGainItems(content.rspdata.rewards, true)
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE"
	content.rspdata.rewards.activityID = activityID
	content.rspdata.rewards.subMsg = "stage"
	SoraDSendMessage(content.rspdata.rewards)
end
function activityCommonBubbleCtrl:reqGuide(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.guide, nil, nil)
end
function activityCommonBubbleCtrl:reqGuideRsp(content)
	dump(content, "activityCommonBubbleCtrl:reqGuideRsp(content)", 10)
	if content.err ~= gErrDef.Err_None then
		return
	end
	local activityID = content.clientData.activityID
	local activityData = self:getActivityData(activityID)
	activityData.guide = true
	_ENV = activityID
	activityID.msg = "MESSAGE_ACTIVITY_COMMON_BUBBLE_UPDATE"
	activityID.activityID = activityID
	activityID.subMsg = "guide"
	SoraDSendMessage(activityID)
end
function activityCommonBubbleCtrl:getItemID(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		if self:getSkin(activityID) == 2 then
			return cmdCfg.itemID2
		else
			return cmdCfg.itemID
		end
	end
	return cmdCfg.itemID
end
function activityCommonBubbleCtrl:getBuyMax(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	return cmdCfg.buyMax
end
function activityCommonBubbleCtrl:getBuyPrice(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	return cmdCfg.buyPrice
end
function activityCommonBubbleCtrl:getActivityData(activityID)
	if not self.activityData[activityID] then
		self.activityData[activityID] = clone(self.defaultData)
	end
	return self.activityData[activityID]
end
function activityCommonBubbleCtrl:getLevel(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.level or 0
end
function activityCommonBubbleCtrl:getBubbleMap(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.bubbleMap then
		_UPVALUE0_ = activityData.bubbleMap
	end
	return activityData.bubbleMap
end
function activityCommonBubbleCtrl:getColorList(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.colorList then
		_UPVALUE0_ = activityData.colorList
	end
	return activityData.colorList
end
function activityCommonBubbleCtrl:getGuide(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.guide or false
end
function activityCommonBubbleCtrl:checkGuide(activityID)
	if not self:getGuide(activityID) then
		local activityCommonBubbleRead = include("activityCommonBubbleRead")
		local guideStep = activityCommonBubbleRead.getGuideStep(activityID)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		;(nil).step = guideStep
		SoraDSendMessage(nil)
		self:reqGuide(activityID)
	end
end
function activityCommonBubbleCtrl:getScore(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.point or 0
end
function activityCommonBubbleCtrl:getBuyCount(activityID)
	local activityData = self:getActivityData(activityID)
	local buyTime = activityData.buyTime or 0
	if buyTime == 0 or not serviceFunctions.isSameDay(buyTime) then
		return 0
	else
		return activityData.buyCount or 0
	end
end
function activityCommonBubbleCtrl:getBuyCountAndMax(activityID)
	local buyMax = self:getBuyMax(activityID)
	return self:getBuyCount(activityID), buyMax
end
function activityCommonBubbleCtrl:checkBuyCount(activityID)
	local buyCount, buyMax = self:getBuyCountAndMax(activityID)
	return buyCount < buyMax
end
function activityCommonBubbleCtrl:jumpToBuyItem(activityID)
	if not self:checkBuyCount(activityID) then
		return
	end
	local buyCount, buyMax = self:getBuyCountAndMax(activityID)
	local buyPrice = self:getBuyPrice(activityID)
	_ENV = self
	self.id = self:getItemID(activityID)
	self.price = buyPrice
	self.originalPrice = buyPrice
	local self.cur, itemData = math.max(0, buyMax - buyCount), self
	_ENV = nil
	;(nil).itemData = itemData
	;(nil).buyHandle = function(buyCount)
		if SoraDEnoughGold(buyCount * buyPrice) then
			self:reqBuy(activityID, buyCount)
		end
	end
	uiManager:show("newShopSingleBuy", nil)
end
function activityCommonBubbleCtrl:checkStageMark(activityID, stage)
	local activityData = self:getActivityData(activityID)
	if not activityData.stageMark then
		local _ENV, stageMark = activityData.stageMark, activityData.stageMark
	end
	return stageMark[tostring(stage)] == 1
end
function activityCommonBubbleCtrl:checkFreeReceiveTime(activityID)
	local activityData = self:getActivityData(activityID)
	local freeTime = activityData.freeReceiveTime or 0
	if freeTime == 0 or not serviceFunctions.isSameDay(freeTime) then
		return true
	else
		return false
	end
end
function activityCommonBubbleCtrl:getBoxState(activityID, stage)
	if self:checkStageMark(activityID, stage) then
		return gBtnTargetStatusDef.GOT
	end
	local activityCommonBubbleRead = include("activityCommonBubbleRead")
	local targetScore = activityCommonBubbleRead.getStagePoint(activityID, stage)
	if targetScore <= self:getScore(activityID) then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activityCommonBubbleCtrl:getReceiveStatusAndNum(activityID)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return false, 0
	end
	local num = 0
	if self:checkFreeReceiveTime(activityID) then
		num = num + 1
	end
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001638 then
		if self:checkBuyCount(activityID) then
			num = num + 1
		end
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemID = self:getItemID(activityID)
		local itemCount = backpackCtrl:getItemCount(itemID)
		if 0 < itemCount then
			num = num + itemCount
		end
		local activityCommonBubbleRead = include("activityCommonBubbleRead")
		local config = activityCommonBubbleRead.getStageRewardConfig(activityID)
		for stage, __ in ipairs(config) do
			local state = self:getBoxState(activityID, stage)
			if state == gBtnTargetStatusDef.GET then
				num = num + 1
			end
		end
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemID = self:getItemID(activityID)
		local itemCount = backpackCtrl:getItemCount(itemID)
		if 0 < itemCount then
			num = num + 1
		end
	end
	return 0 < num, num
end
function activityCommonBubbleCtrl:getSkin(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		return math.floor(classType / 10) + 1
	else
		return classType
	end
end
return activityCommonBubbleCtrl
