local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local CommonSpeedUpBox = class("commonSpeedUpBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonSpeedUpBox")
	end
	return target
end)
function CommonSpeedUpBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self:openMsgBoxMode()
	self.btnSpeedUp = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_speedUp")
	_ENV = "CCS_commonGoldNormalBtn_speedUp"
	;("CCS_commonGoldNormalBtn_speedUp").title = i18n("common_text_018")
	self.btnSpeedUp:initData("CCS_commonGoldNormalBtn_speedUp", 1)
	self.labelMsg = SoraDGetChildByName(self, "Text_msg")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.timer = nil
	self.callBackHandle = nil
	self.isAllianceTech = false
	self.isArmy = false
	self.isMaterialFactory = false
	self.speedUpBySelf = true
	self.isFree = false
	self.btnSpeedUp:addTouchEventListener(handler(self, self.btnClickCallBack))
	self:setCloseCallBack(handler(self, self.exitView))
	self.tableQueueData, _ENV = self.setCloseCallBack, self.setCloseCallBack
end
function CommonSpeedUpBox:initData(queueData)
	local armyLogic = include("armyLogic")
	if not queueData.data then
		_ENV = queueData.data
	end
	self.tableQueueData = queueData.data
	self.callBackHandle = queueData.handle
	if queueData.tableArgv and queueData.tableArgv.timeHandler then
		self.timeCallBack = queueData.tableArgv.timeHandler
	end
	if queueData.tableArgv and queueData.tableArgv.goldHandler then
		self.goldCallBack = queueData.tableArgv.goldHandler
	end
	local msgDes
	if self.tableQueueData then
		self.tableQueueData.qtype = tonumber(self.tableQueueData.qtype)
		if self.tableQueueData.qtype == gQueueTypeDef.charge_build_queue or self.tableQueueData.qtype == gQueueTypeDef.free_build_queue then
			msgDes = i18n("common_text_743")
		else
			msgDes = i18n("common_text_765")
		end
		if armyLogic.isArmyQueueType(self.tableQueueData.qtype) then
			self.isArmy = true
		end
		if queueData.msg then
			msgDes = queueData.msg
		end
		if queueData.tableArgv and next(queueData.tableArgv) then
			if queueData.tableArgv.speedUpName then
				self.btnSpeedUp:setTitleStr(queueData.tableArgv.speedUpName)
			end
			if queueData.tableArgv.isBySelf ~= nil then
				self.speedUpBySelf = queueData.tableArgv.isBySelf
			end
			if queueData.tableArgv.isAllianceTech ~= nil then
				self.isAllianceTech = queueData.tableArgv.isAllianceTech
			end
			if queueData.tableArgv.isMaterialFactory ~= nil then
				self.isMaterialFactory = queueData.tableArgv.isMaterialFactory
			end
		end
		self.labelMsg:setString(msgDes)
		self.timer = SoradCreateTimer(self, handlerEx(self, self.openTimeUp))
		self:openTimeUp()
	else
		self:removeFromParent()
	end
end
function CommonSpeedUpBox:openTimeUp(dt)
	local leftTime = self:getLeftTime()
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelTime:setString(i18n("common_text_766", nil))
	local goldPay = 99999
	if self.tableQueueData then
		if self.tableQueueData.qtype == gAbbrSpeedUpType.BUILD_UPGRADE then
			local buildLogic = include("buildLogic")
			local freeSpeedUpTime = buildLogic.getFreeSpeedUpTime()
			self.isFree = leftTime <= freeSpeedUpTime
		elseif self.tableQueueData.qtype == gAbbrSpeedUpType.TECH then
			local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
			local freeSpeedUpTime = technologyCtrl:getFreeSpeedUpTime(self.tableQueueData.qtype)
			self.isFree = leftTime <= freeSpeedUpTime
		end
	end
	if self.isFree then
		self.btnSpeedUp:setGoldText(i18n("common_text_049"))
		self.btnSpeedUp:setEnouhGold(true)
	else
		goldPay = self:getTimeCastGold()
		self.btnSpeedUp:setGoldText(string.formatnumberthousands(math.floor(goldPay)))
		self.btnSpeedUp:setEnouhGold(SoraDEnoughGold(math.floor(goldPay), true))
	end
	if leftTime <= 0 or self.tableQueueData == nil then
		self:buildTimerEnd()
	end
end
function CommonSpeedUpBox:getLeftTime()
	local leftTime = 0
	if self.timeCallBack then
		leftTime = self.timeCallBack()
	else
		leftTime = self.tableQueueData and self.tableQueueData.timerNode.timer:getRemainTime() or 0
	end
	return leftTime
end
function CommonSpeedUpBox:setHandle(handle)
	self.callBackHandle = handle
end
function CommonSpeedUpBox:buildTimerEnd()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self:runActClose()
end
function CommonSpeedUpBox:runActClose()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.01)
	;(nil)[2] = cca.callFunc(function()
		self:exitView(MSGBOX_CALLBACK_TIME_END)
		self:close(nil, ccui.TouchEventType.ended)
	end)
	;(nil)[3] = cca.callFunc(function()
		self:exitView(MSGBOX_CALLBACK_TIME_END)
		self:close(nil, ccui.TouchEventType.ended)
	end)
	self:runAction(cca.seq(nil))
end
function CommonSpeedUpBox:setSpeedUpType(isBySelf)
	self.speedUpBySelf = isBySelf
end
function CommonSpeedUpBox:setAllianceScienceDonateType(isAllianceTech)
	self.isAllianceTech = isAllianceTech
end
function CommonSpeedUpBox:setArmy(isArmy)
	self.isArmy = isArmy
end
function CommonSpeedUpBox:getTimeCastGold()
	local leftTime = self:getLeftTime()
	if self.goldCallBack then
		return self.goldCallBack(leftTime)
	else
		return serviceFunctions.timeConvertToGold(leftTime, self.isArmy, self.isAllianceTech, self.isMaterialFactory)
	end
end
function CommonSpeedUpBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local leftTime = self:getLeftTime()
		if self.isFree then
			button:setTouchEnabled(false)
			if self.speedUpBySelf then
				queueCtrl:speedUpQueueReq(self.tableQueueData.qtype, SPEEDUP_TYPE.FREE)
			end
			self:exitView(MSGBOX_CALLBACK_SPEEDUP)
			self:close(button, type)
		elseif SoraDEnoughGold(self:getTimeCastGold()) then
			button:setTouchEnabled(false)
			if self.speedUpBySelf then
				queueCtrl:speedUpQueueReq(self.tableQueueData.qtype, SPEEDUP_TYPE.GOLD)
			end
			self:exitView(MSGBOX_CALLBACK_SPEEDUP)
			self:close(button, type)
		end
	end
end
function CommonSpeedUpBox:exitView(exitType, button, type)
	if self.callBackHandle then
		self.callBackHandle(exitType)
	end
end
return CommonSpeedUpBox
