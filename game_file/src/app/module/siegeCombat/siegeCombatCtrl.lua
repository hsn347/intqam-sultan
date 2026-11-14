local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local siegeCombatCtrl = class("siegeCombatCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local crypt = require("crypt")
function siegeCombatCtrl:ctor(properties)
	siegeCombatCtrl.super.ctor(self, properties)
	self.dataTable, siegeCombatCtrl = siegeCombatCtrl.super.ctor, siegeCombatCtrl.super.ctor
	self.rndText = ""
	self.cryptCode = ""
end
function siegeCombatCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_ENTER, handler(self, self.getEnterRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_OPEN_PAGE, handler(self, self.getOpenPageRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_PLUS_STEP, handler(self, self.getPlusStepRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_DOUBLE, handler(self, self.getDoubleRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_KO, handler(self, self.getKORsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_USE_DOUBLE, handler(self, self.getUseDoubleRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_SHARE, handler(self, self.getShareRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_COMBAT_ALLIANCE_SHARE, handler(self, self.getAllianceShareRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_USE_STEP, handler(self, self.getUseStepRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_DAMAGE_LIST, handler(self, self.getDamageListRsp))
	msgCtrl.register(gCmd.CMD_SIEGE_COMBAT_MODULE, gCmd.REQ_SIEGE_ATTACK_DETAIL, handler(self, self.getAttackDetailRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.SIEGECOMBAT, handler(self, self.noitfyDataRsp))
end
function siegeCombatCtrl:getTicketCost()
	if self.dataTable and self.dataTable.need then
		return self.dataTable.need
	end
	return nil
end
function siegeCombatCtrl:getSteps()
	if self.dataTable and self.dataTable.stepsCount then
		return self.dataTable.stepsCount
	end
	return nil
end
function siegeCombatCtrl:getStepsCost()
	if self.dataTable and self.dataTable.stepsCost then
		return self.dataTable.stepsCost
	end
	return nil
end
function siegeCombatCtrl:getIsDayLimit()
	if self.dataTable and nil ~= self.dataTable.dayLimit then
		return self.dataTable.dayLimit
	end
	return false
end
function siegeCombatCtrl:getDoubles()
	if self.dataTable and self.dataTable.doublesCount then
		return self.dataTable.doublesCount
	end
	return nil
end
function siegeCombatCtrl:getDoublesCost()
	if self.dataTable and self.dataTable.doublesCost then
		return self.dataTable.doublesCost
	end
	return nil
end
function siegeCombatCtrl:getCurDoubles()
	if self.dataTable and self.dataTable.curDoubles then
		return self.dataTable.curDoubles
	end
	return nil
end
function siegeCombatCtrl:getTotalUseStep()
	if self.dataTable and self.dataTable.totalUsedSteps then
		return self.dataTable.totalUsedSteps
	end
	return 0
end
function siegeCombatCtrl:getTotalUseDouble()
	if self.dataTable and self.dataTable.totalUsedDoubles then
		return self.dataTable.totalUsedDoubles
	end
	return 0
end
function siegeCombatCtrl:makeRndText()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 6)))
	local tmpStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEF"
	local tmpLen = string.len(tmpStr)
	local retStr = ""
	for i = 1, 6 do
		local tmpRndIndex = math.random(1, tmpLen)
		local tmpSubStr = string.sub(tmpStr, tmpRndIndex, tmpRndIndex)
		retStr = retStr .. tmpSubStr
	end
	return retStr
end
function siegeCombatCtrl:makeCrypt(mPrefix, mValue, mRndText, mSuffix)
	if type(mValue) ~= "number" or nil == mRndText or nil == mPrefix then
		serviceFunctions.printInfo("siegeCombatCtrl:makeCrypt error")
		return
	end
	local originText
	if mSuffix then
		originText = string.format("siege_combat_%s_%s_%s_%s", mPrefix, tostring(mValue), mRndText, mSuffix)
	else
		originText = string.format("siege_combat_%s_%s_%s", mPrefix, tostring(mValue), mRndText)
	end
	local tmpPwd = "LTZD3600_GOOD_GUYS_DO_IT"
	local c = crypt.hmac_sha1(tmpPwd, originText)
	return originText, crypt.hexencode(c)
end
function siegeCombatCtrl:sendEnter(mType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_SIEGE_COMBAT_ENTER, gCmd.REQ_SIEGE_COMBAT_ENTER, gCmd.REQ_SIEGE_COMBAT_ENTER
	local msg
	msg.data.type = mType
	serverproxy:SendMsg(msg)
end
function siegeCombatCtrl:sendOpenPage()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
	local (nil).subcmd, msg = gCmd.REQ_SIEGE_COMBAT_OPEN_PAGE, nil
	serverproxy:SendMsg(msg)
end
function siegeCombatCtrl:sendPlusStep(mLeftSteps)
	local mSteps = self:getSteps() + 1
	if not mSteps then
		print("siegeCombatCtrl:sendPlusStep error mSteps is nil")
		return
	end
	local originText, mCode = self:makeCrypt("stepsCount", mSteps, self.rndText)
	print("req reqPlusStep = ", mCode, mSteps, self.rndText)
	if mCode then
		_ENV = print
		print.cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
		_ENV, print.subcmd = gCmd.REQ_SIEGE_COMBAT_PLUS_STEP, gCmd.REQ_SIEGE_COMBAT_PLUS_STEP
		gCmd.REQ_SIEGE_COMBAT_PLUS_STEP.code = mCode
		print.data, gCmd.REQ_SIEGE_COMBAT_PLUS_STEP.leftsteps = gCmd.REQ_SIEGE_COMBAT_PLUS_STEP, mLeftSteps
		local msg = print
		serverproxy:SendMsg(msg)
	end
end
function siegeCombatCtrl:sendDouble()
	local mDoubles = self:getDoubles() + 1
	if not mDoubles then
		print("siegeCombatCtrl:sendDouble error mDoubles is nil")
		return
	end
	local originText, mCode = self:makeCrypt("doublesCount", mDoubles, self.rndText)
	if mCode then
		_ENV = "doublesCount"
		;("doublesCount").cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
		_ENV, ("doublesCount").subcmd = gCmd.REQ_SIEGE_COMBAT_DOUBLE, gCmd.REQ_SIEGE_COMBAT_DOUBLE
		;("doublesCount").data, gCmd.REQ_SIEGE_COMBAT_DOUBLE.code = gCmd.REQ_SIEGE_COMBAT_DOUBLE, mCode
		local msg = "doublesCount"
		serverproxy:SendMsg(msg)
	end
end
function siegeCombatCtrl:sendUseDouble()
	local mDoubles = self.dataTable.curDoubles
	if not mDoubles then
		print("siegeCombatCtrl:sendDouble error mDoubles is nil")
		return
	end
	local originText, mCode = self:makeCrypt("curDoubles", mDoubles, self.rndText)
	if mCode then
		_ENV = "curDoubles"
		;("curDoubles").cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
		_ENV, ("curDoubles").subcmd = gCmd.REQ_SIEGE_COMBAT_USE_DOUBLE, gCmd.REQ_SIEGE_COMBAT_USE_DOUBLE
		;("curDoubles").data, gCmd.REQ_SIEGE_COMBAT_USE_DOUBLE.code = gCmd.REQ_SIEGE_COMBAT_USE_DOUBLE, mCode
		local msg = "curDoubles"
		serverproxy:SendMsg(msg)
	end
end
function siegeCombatCtrl:sendKO(mLevel)
	local originText, mCode = self:makeCrypt("level", mLevel, self.rndText)
	print("siegeCombatCtrl:sendKO==", mCode, mLevel, self.rndText)
	if mCode then
		_ENV = print
		print.cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
		_ENV, print.subcmd = gCmd.REQ_SIEGE_COMBAT_KO, gCmd.REQ_SIEGE_COMBAT_KO
		gCmd.REQ_SIEGE_COMBAT_KO.code = mCode
		print.data, gCmd.REQ_SIEGE_COMBAT_KO.level = gCmd.REQ_SIEGE_COMBAT_KO, mLevel
		local msg = print
		serverproxy:SendMsg(msg)
	end
end
function siegeCombatCtrl:sendShare()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
	local (nil).subcmd, msg = gCmd.REQ_SIEGE_COMBAT_SHARE, nil
	serverproxy:SendMsg(msg)
end
function siegeCombatCtrl:sendAllianceShare()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
	local (nil).subcmd, msg = gCmd.REQ_SIEGE_COMBAT_ALLIANCE_SHARE, nil
	serverproxy:SendMsg(msg)
end
function siegeCombatCtrl:sendUseStep()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
	local (nil).subcmd, msg = gCmd.REQ_SIEGE_USE_STEP, nil
	serverproxy:SendMsg(msg)
end
function siegeCombatCtrl:sendDamageList(damages)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SIEGE_DAMAGE_LIST, gCmd.REQ_SIEGE_DAMAGE_LIST
	;(nil).data, gCmd.REQ_SIEGE_DAMAGE_LIST.damages = gCmd.REQ_SIEGE_DAMAGE_LIST, damages
	local msg
	serverproxy:SendMsg(msg)
end
function siegeCombatCtrl:sendAttackDetail(atkDetail)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SIEGE_COMBAT_MODULE
	;(nil).subcmd = gCmd.REQ_SIEGE_ATTACK_DETAIL
	local (nil).data, msg = atkDetail, nil
	serverproxy:SendMsg(msg)
end
function siegeCombatCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
end
function siegeCombatCtrl:noitfyDataRsp(respone)
	if respone.data[1] and next(respone.data[1]) then
		self.dataTable = respone.data[1]
	end
end
function siegeCombatCtrl:isOpen()
	local isOpen = false
	if self.dataTable and self.dataTable.isOpen then
		isOpen = self.dataTable.isOpen
	end
	return isOpen
end
function siegeCombatCtrl:initClientData(mData)
	self.dataTable = mData
	self.rndText = self.dataTable.rnd
end
function siegeCombatCtrl:Logout()
	siegeCombatCtrl.super.Logout(self)
	self.dataTable, siegeCombatCtrl = siegeCombatCtrl.super.Logout, siegeCombatCtrl.super.Logout
	self.rndText = ""
	self.cryptCode = ""
end
function siegeCombatCtrl:getEnterRsp(content)
	if gErrDef.Err_None == content.err then
		self.cryptCode = content.cryptCode
		self.dataTable = content.result
	elseif gErrDef.Err_SIEGE_COMBAT_SHORTAGE_ERROR == content.err then
		SoraDShowMsgTip(i18n("common_text_2512"))
	else
		SoraDShowMsgTip(i18n("common_text_699"))
	end
	_ENV = i18n("common_text_699")
	i18n("common_text_699").msg = "MESSAGE_SERVER_ELIMINATEGAME_ENTER"
	i18n("common_text_699").errCode = content.err
	SoraDSendMessage(i18n("common_text_699"))
end
function siegeCombatCtrl:getOpenPageRsp(content)
	if gErrDef.Err_None == content.err then
		self.rndText = content.rnd
		self.dataTable = content.result
	else
	end
end
function siegeCombatCtrl:getPlusStepRsp(content)
	local step
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		step = self.dataTable.mysteps
	elseif gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR == content.err then
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_STEP"
	content.err.step = step
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function siegeCombatCtrl:getDoubleRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	elseif gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR == content.err then
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_DOUBLE"
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function siegeCombatCtrl:getUseDoubleRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	elseif gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR == content.err then
	end
end
function siegeCombatCtrl:getKORsp(content)
	local rewards
	if gErrDef.Err_None == content.err then
		self.rndText = content.rnd
		self.dataTable = content.result
		rewards = content.rewards
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_KO"
	content.err.rewards = rewards
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function siegeCombatCtrl:getShareRsp(content)
	if gErrDef.Err_None == content.err then
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_SHARE"
	content.err.rewards = rewards
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function siegeCombatCtrl:getAllianceShareRsp(content)
	if gErrDef.Err_None == content.err then
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_SHARE_ALLIANCE"
	content.err.rewards = rewards
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function siegeCombatCtrl:getUseStepRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_USESTEP"
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function siegeCombatCtrl:getDamageListRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_OLD_DAMAGE"
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function siegeCombatCtrl:getAttackDetailRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		if content.rnd then
			self.rndText = content.rnd
		end
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_HURT"
		content.err.errCode = content.err
		content.err.rewards = content.rewards
		content.err.killSum = content.killSum
		content.err.curDoubles = self.dataTable.curDoubles
		SoraDSendMessage(content.err)
	else
		SoraDRemoveAllPanelFromManager()
		SoraDShowMsgTip(i18n("notice_0026"))
	end
end
function siegeCombatCtrl:getReceiveStatusAndNum(activityID)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local isOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.SIEGE_COMBAT)
	if not isOpen then
		return false, 0
	end
	if self.dataTable.freeCount ~= nil then
		local freeTimes = self.dataTable.freeCount
		return 0 < freeTimes, freeTimes
	else
		local freeTimes = self.dataTable.need == 0 and 1 or 0
		return 0 < freeTimes, freeTimes
	end
end
return siegeCombatCtrl
