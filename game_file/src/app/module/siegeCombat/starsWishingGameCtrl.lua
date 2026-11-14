local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local activity_9001629_Read = include("activity_9001629_Read")
local starsWishingGameCtrl = class("starsWishingGameCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local crypt = require("crypt")
function starsWishingGameCtrl:ctor(properties)
	starsWishingGameCtrl.super.ctor(self, properties)
	self.dataTable, starsWishingGameCtrl = starsWishingGameCtrl.super.ctor, starsWishingGameCtrl.super.ctor
	self.rndText = ""
	self.cryptCode = ""
end
function starsWishingGameCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_ENTER, handler(self, self.getEnterRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_OPEN_PAGE, handler(self, self.getOpenPageRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_PLUS_STEP, handler(self, self.getPlusStepRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_DOUBLE, handler(self, self.getDoubleRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_NEW_DAY_PLUS_STEP, handler(self, self.onNewDayPlusStepRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_USE_DOUBLE, handler(self, self.getUseDoubleRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_SHARE, handler(self, self.getShareRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_ALLIANCE_SHARE, handler(self, self.getAllianceShareRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_USE_STEP, handler(self, self.getUseStepRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_DAMAGE_LIST, handler(self, self.getDamageListRsp))
	msgCtrl.register(gCmd.CMD_STARS_WISHING_GAME_MODULE, gCmd.REQ_STARS_WISHING_GAME_ATTACK_DETAIL, handler(self, self.getAttackDetailRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.STARS_WISHING_GAME, handler(self, self.noitfyDataRsp))
end
function starsWishingGameCtrl:getTicketCost()
	if self.dataTable and self.dataTable.need then
		return self.dataTable.need
	end
	return nil
end
function starsWishingGameCtrl:getSteps()
	if self.dataTable and self.dataTable.stepsCount then
		return self.dataTable.stepsCount
	end
	return nil
end
function starsWishingGameCtrl:getStepsCost()
	if self.dataTable and self.dataTable.stepsCost then
		return self.dataTable.stepsCost
	end
	return nil
end
function starsWishingGameCtrl:getIsDayLimit()
	if self.dataTable and nil ~= self.dataTable.dayLimit then
		return self.dataTable.dayLimit
	end
	return false
end
function starsWishingGameCtrl:getDoubles()
	if self.dataTable and self.dataTable.doublesCount then
		return self.dataTable.doublesCount
	end
	return nil
end
function starsWishingGameCtrl:getDoublesCost()
	if self.dataTable and self.dataTable.doublesCost then
		return self.dataTable.doublesCost
	end
	return nil
end
function starsWishingGameCtrl:getCurDoubles()
	if self.dataTable and self.dataTable.curDoubles then
		return self.dataTable.curDoubles
	end
	return nil
end
function starsWishingGameCtrl:getTotalUseStep()
	return self:getUseStep()
end
function starsWishingGameCtrl:getMySteps()
	return self.dataTable.mysteps or 0
end
function starsWishingGameCtrl:getUseStep()
	return self.usedSteps
end
function starsWishingGameCtrl:getCurUsedDoubles()
	return self.curUsedDoubles
end
function starsWishingGameCtrl:getTotalUseDouble()
	return self:getCurUsedDoubles()
end
function starsWishingGameCtrl:makeRndText()
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
function starsWishingGameCtrl:makeCrypt(mPrefix, mValue, mRndText, mSuffix)
	if type(mValue) ~= "number" or nil == mRndText or nil == mPrefix then
		serviceFunctions.printInfo("starsWishingGameCtrl:makeCrypt error")
		return
	end
	local originText
	if mSuffix then
		originText = string.format("stars_wishing_game_%s_%s_%s_%s", mPrefix, tostring(mValue), mRndText, mSuffix)
	else
		originText = string.format("stars_wishing_game_%s_%s_%s", mPrefix, tostring(mValue), mRndText)
	end
	local tmpPwd = "LTZD3600_GOOD_GUYS_DO_IT"
	local c = crypt.hmac_sha1(tmpPwd, originText)
	return originText, crypt.hexencode(c)
end
function starsWishingGameCtrl:sendEnter(mType)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_STARS_WISHING_GAME_ENTER, gCmd.REQ_STARS_WISHING_GAME_ENTER, gCmd.REQ_STARS_WISHING_GAME_ENTER
	local msg
	msg.data.type = mType
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:sendOpenPage()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	local (nil).subcmd, msg = gCmd.REQ_STARS_WISHING_GAME_OPEN_PAGE, nil
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:sendPlusStep(mLeftSteps)
	local mSteps = self:getSteps() + 1
	if not mSteps then
		print("starsWishingGameCtrl:sendPlusStep error mSteps is nil")
		return
	end
	local originText, mCode = self:makeCrypt("stepsCount", mSteps, self.rndText)
	print("req reqPlusStep = ", mCode, mSteps, self.rndText)
	if mCode then
		_ENV = print
		print.cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
		_ENV, print.subcmd = gCmd.REQ_STARS_WISHING_GAME_PLUS_STEP, gCmd.REQ_STARS_WISHING_GAME_PLUS_STEP
		gCmd.REQ_STARS_WISHING_GAME_PLUS_STEP.code = mCode
		print.data, gCmd.REQ_STARS_WISHING_GAME_PLUS_STEP.leftsteps = gCmd.REQ_STARS_WISHING_GAME_PLUS_STEP, mLeftSteps
		local msg = print
		serverproxy:SendMsg(msg)
	end
end
function starsWishingGameCtrl:sendNewDayPlusStep()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_STARS_WISHING_GAME_NEW_DAY_PLUS_STEP, gCmd.REQ_STARS_WISHING_GAME_NEW_DAY_PLUS_STEP, gCmd.REQ_STARS_WISHING_GAME_NEW_DAY_PLUS_STEP
	local msg
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:sendDouble()
	local mDoubles = self:getDoubles() + 1
	if not mDoubles then
		print("starsWishingGameCtrl:sendDouble error mDoubles is nil")
		return
	end
	local originText, mCode = self:makeCrypt("doublesCount", mDoubles, self.rndText)
	if mCode then
		_ENV = "doublesCount"
		;("doublesCount").cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
		_ENV, ("doublesCount").subcmd = gCmd.REQ_STARS_WISHING_GAME_DOUBLE, gCmd.REQ_STARS_WISHING_GAME_DOUBLE
		;("doublesCount").data, gCmd.REQ_STARS_WISHING_GAME_DOUBLE.code = gCmd.REQ_STARS_WISHING_GAME_DOUBLE, mCode
		local msg = "doublesCount"
		serverproxy:SendMsg(msg)
	end
end
function starsWishingGameCtrl:sendUseDouble()
	local mDoubles = self.dataTable.curDoubles
	if not mDoubles then
		print("starsWishingGameCtrl:sendDouble error mDoubles is nil")
		return
	end
	local originText, mCode = self:makeCrypt("curDoubles", mDoubles, self.rndText)
	if mCode then
		_ENV = "curDoubles"
		;("curDoubles").cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
		_ENV, ("curDoubles").subcmd = gCmd.REQ_STARS_WISHING_GAME_USE_DOUBLE, gCmd.REQ_STARS_WISHING_GAME_USE_DOUBLE
		;("curDoubles").data, gCmd.REQ_STARS_WISHING_GAME_USE_DOUBLE.code = gCmd.REQ_STARS_WISHING_GAME_USE_DOUBLE, mCode
		local msg = "curDoubles"
		serverproxy:SendMsg(msg)
	end
end
function starsWishingGameCtrl:sendShare()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	local (nil).subcmd, msg = gCmd.REQ_STARS_WISHING_GAME_SHARE, nil
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:sendAllianceShare()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	local (nil).subcmd, msg = gCmd.REQ_STARS_WISHING_GAME_ALLIANCE_SHARE, nil
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:sendUseStep()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	local (nil).subcmd, msg = gCmd.REQ_STARS_WISHING_GAME_USE_STEP, nil
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:sendDamageList(damages)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_STARS_WISHING_GAME_DAMAGE_LIST, gCmd.REQ_STARS_WISHING_GAME_DAMAGE_LIST
	;(nil).data, gCmd.REQ_STARS_WISHING_GAME_DAMAGE_LIST.damages = gCmd.REQ_STARS_WISHING_GAME_DAMAGE_LIST, damages
	local msg
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:sendAttackDetail(atkDetail)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_STARS_WISHING_GAME_MODULE
	;(nil).subcmd = gCmd.REQ_STARS_WISHING_GAME_ATTACK_DETAIL
	local (nil).data, msg = atkDetail, nil
	serverproxy:SendMsg(msg)
end
function starsWishingGameCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
	self.usedSteps = 0
	self.curUsedDoubles = 0
	self.lastNewDayPlusStepTime = nil
end
function starsWishingGameCtrl:noitfyDataRsp(respone)
	if respone.data[1] and next(respone.data[1]) then
		self.dataTable = respone.data[1]
	end
end
function starsWishingGameCtrl:isOpen()
	local isOpen = false
	if self.dataTable and self.dataTable.isOpen then
		isOpen = self.dataTable.isOpen
	end
	return isOpen
end
function starsWishingGameCtrl:initClientData(mData)
	dump(mData, "starsWishingGameCtrl:initClientData=", 5)
	if mData ~= nil then
		self.dataTable = mData
		self.rndText = self.dataTable.rnd
		self.lastNewDayPlusStepTime = self.dataTable.lastNewDayPlusStepTime
	end
end
function starsWishingGameCtrl:Logout()
	starsWishingGameCtrl.super.Logout(self)
	self.dataTable, starsWishingGameCtrl = starsWishingGameCtrl.super.Logout, starsWishingGameCtrl.super.Logout
	self.rndText = ""
	self.cryptCode = ""
end
function starsWishingGameCtrl:getEnterRsp(content)
	dump(content, "getEnterRsp content", 5)
	if gErrDef.Err_None == content.err then
		self.cryptCode = content.cryptCode
		self.dataTable = content.result
		uiManager:show("EliminateGameView")
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
function starsWishingGameCtrl:getOpenPageRsp(content)
	if gErrDef.Err_None == content.err then
		self.rndText = content.rnd
		self.dataTable = content.result
	else
	end
end
function starsWishingGameCtrl:getPlusStepRsp(content)
	dump(content, "getPlusStepRsp content", 5)
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
function starsWishingGameCtrl:onNewDayPlusStepRsp(content)
	dump(content, "getPlusStepRsp content", 5)
	local step
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		step = self.dataTable.mysteps
		self.lastNewDayPlusStepTime = self.dataTable.lastNewDayPlusStepTime
	elseif gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR == content.err then
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_STEP"
	content.err.step = step
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function starsWishingGameCtrl:getDoubleRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	elseif gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR == content.err then
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_DOUBLE"
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function starsWishingGameCtrl:getUseDoubleRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	elseif gErrDef.Err_SIEGE_COMBAT_CHECK_ERROR == content.err then
	end
end
function starsWishingGameCtrl:getShareRsp(content)
	if gErrDef.Err_None == content.err then
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_SHARE"
	content.err.rewards = rewards
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function starsWishingGameCtrl:getAllianceShareRsp(content)
	if gErrDef.Err_None == content.err then
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_SHARE_ALLIANCE"
	content.err.rewards = rewards
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function starsWishingGameCtrl:getUseStepRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
		self.usedSteps = self.dataTable.usedSteps
		self.curUsedDoubles = self.dataTable.curUsedDoubles
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_USESTEP"
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function starsWishingGameCtrl:getDamageListRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_ELIMINATEGAME_OLD_DAMAGE"
	content.err.errCode = content.err
	SoraDSendMessage(content.err)
end
function starsWishingGameCtrl:getAttackDetailRsp(content)
	dump(content, "getAttackDetailRsp content", 5)
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
function starsWishingGameCtrl:getReceiveStatusAndNum(activityID)
	return false, 0
end
function starsWishingGameCtrl:getIsMaxLevel()
	if self.levelConfig == nil then
		self.levelConfig = activity_9001629_Read.getLevelList()
	end
	if self.dataTable.level > #self.levelConfig then
		return true
	end
	return false
end
function starsWishingGameCtrl:getIsHaveFreePlusTimes()
	if self.lastNewDayPlusStepTime == nil or not serviceFunctions.isSameDay(self.lastNewDayPlusStepTime, serviceFunctions.systemTime()) then
		return true
	end
end
return starsWishingGameCtrl
