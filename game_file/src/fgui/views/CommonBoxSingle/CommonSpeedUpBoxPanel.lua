local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonSpeedUpBoxPanel = class("CommonSpeedUpBoxPanel", baseFguiPanel)
function CommonSpeedUpBoxPanel:ctor(...)
	CommonSpeedUpBoxPanel.super.ctor(self, ...)
	print("CommonSpeedUpBoxPanel:ctor", self.viewName)
end
function CommonSpeedUpBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CommonSpeedUpBoxPanel:onInit()
	print("=======CommonSpeedUpBoxPanel:onInit")
	self.timer = nil
	self.callBackHandle = nil
	self.isAllianceTech = false
	self.isArmy = false
	self.isMaterialFactory = false
	self.speedUpBySelf = true
	self.tableQueueData, _ENV, self.isFree = print, print, false
	self:initData(self.proxy.param)
	self.fields.Button_Speed:setString(i18n("common_text_018"))
	self.fields.Button_Speed:addClickListener(handler(self, self.btnClickCallBack))
end
function CommonSpeedUpBoxPanel:onShow()
	print("=======CommonSpeedUpBoxPanel:onShow")
end
function CommonSpeedUpBoxPanel:initData(queueData)
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
				self.fields.Button_Speed:setString(queueData.tableArgv.speedUpName)
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
		self.fields.Text_msg:setString(msgDes)
		self.timer = SoradCreateTimer(self, handlerEx(self, self.openTimeUp))
		self:openTimeUp()
	else
		self:removeFromParent()
	end
end
function CommonSpeedUpBoxPanel:openTimeUp(dt)
	local leftTime = self:getLeftTime()
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.fields.Text_Time:setString(i18n("common_text_766", nil))
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
		self.fields.Button_Speed:setCost(gIDDef.GOLD, 0)
	else
		goldPay = self:getTimeCastGold()
		self.fields.Button_Speed:setCost(gIDDef.GOLD, goldPay)
	end
	if leftTime <= 0 or self.tableQueueData == nil then
		self:buildTimerEnd()
	end
end
function CommonSpeedUpBoxPanel:getLeftTime()
	local leftTime = 0
	if self.timeCallBack then
		leftTime = self.timeCallBack()
	elseif self.tableQueueData and self.tableQueueData.timerNode then
		leftTime = self.tableQueueData and self.tableQueueData.timerNode.timer:getRemainTime() or 0
	end
	return leftTime
end
function CommonSpeedUpBoxPanel:buildTimerEnd()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self:runActClose()
end
function CommonSpeedUpBoxPanel:getTimeCastGold()
	local leftTime = self:getLeftTime()
	if self.goldCallBack then
		return self.goldCallBack(leftTime)
	else
		return serviceFunctions.timeConvertToGold(leftTime, self.isArmy, self.isAllianceTech, self.isMaterialFactory)
	end
end
function CommonSpeedUpBoxPanel:runActClose()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.01)
	;(nil)[2] = ffa.callFunc(function()
		self:exitView(MSGBOX_CALLBACK_TIME_END)
		self:close()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:exitView(MSGBOX_CALLBACK_TIME_END)
		self:close()
	end)
	self:runAction(ffa.seq(nil))
end
function CommonSpeedUpBoxPanel:exitView(exitType, button, type)
	if self.callBackHandle then
		self.callBackHandle(exitType)
	end
end
function CommonSpeedUpBoxPanel:btnClickCallBack()
	SoraDPlaySound()
	local leftTime = self:getLeftTime()
	if self.isFree then
		if self.speedUpBySelf then
			queueCtrl:speedUpQueueReq(self.tableQueueData.qtype, SPEEDUP_TYPE.FREE)
		end
		self:exitView(MSGBOX_CALLBACK_SPEEDUP)
		self:close()
	elseif SoraDEnoughGold(self:getTimeCastGold()) then
		if self.speedUpBySelf then
			queueCtrl:speedUpQueueReq(self.tableQueueData.qtype, SPEEDUP_TYPE.GOLD)
		end
		self:exitView(MSGBOX_CALLBACK_SPEEDUP)
		self:close()
	end
end
function CommonSpeedUpBoxPanel:setSpeedUpType(isBySelf)
	self.speedUpBySelf = isBySelf
end
function CommonSpeedUpBoxPanel:setAllianceScienceDonateType(isAllianceTech)
	self.isAllianceTech = isAllianceTech
end
function CommonSpeedUpBoxPanel:setArmy(isArmy)
	self.isArmy = isArmy
end
function CommonSpeedUpBoxPanel:onMsgUpdateQueue(target, event)
	if event.qtype == self.tableQueueData.qtype then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return CommonSpeedUpBoxPanel
