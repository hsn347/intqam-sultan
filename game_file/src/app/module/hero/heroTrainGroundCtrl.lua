local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local armyltCtrl = include("armyltCtrl")
local heroTrainGroundCtrl = class("heroTrainGroundCtrl", gamemodulec)
function heroTrainGroundCtrl:initReq(...)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_TRAIN_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_HERO_TRAIN_INIT, gCmd.REQ_HERO_TRAIN_INIT, gCmd.REQ_HERO_TRAIN_INIT
	local msg
	serverproxy:SendMsg(msg)
end
function heroTrainGroundCtrl:goTrainReq(heroID, position, soldiers)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_TRAIN_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_TRAIN_TRAIN, gCmd.REQ_HERO_TRAIN_TRAIN
	gCmd.REQ_HERO_TRAIN_TRAIN.heroID = heroID
	gCmd.REQ_HERO_TRAIN_TRAIN.position = position
	;(nil).data, gCmd.REQ_HERO_TRAIN_TRAIN.soldiers = gCmd.REQ_HERO_TRAIN_TRAIN, soldiers
	local msg
	serverproxy:SendMsg(msg)
end
function heroTrainGroundCtrl:speedUpReq(position, costItemID, costCount)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_TRAIN_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_TRAIN_SPEED, gCmd.REQ_HERO_TRAIN_SPEED
	gCmd.REQ_HERO_TRAIN_SPEED.position = position
	gCmd.REQ_HERO_TRAIN_SPEED.costItemID = costItemID
	;(nil).data, gCmd.REQ_HERO_TRAIN_SPEED.costCount = gCmd.REQ_HERO_TRAIN_SPEED, costCount
	local msg
	serverproxy:SendMsg(msg)
end
function heroTrainGroundCtrl:stopTrainReq(position)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_TRAIN_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_TRAIN_STOP, gCmd.REQ_HERO_TRAIN_STOP
	;(nil).data, gCmd.REQ_HERO_TRAIN_STOP.position = gCmd.REQ_HERO_TRAIN_STOP, position
	local msg
	serverproxy:SendMsg(msg)
end
function heroTrainGroundCtrl:gainExpReq(position, heroID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_TRAIN_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_HERO_TRAIN_RECEIVE, gCmd.REQ_HERO_TRAIN_RECEIVE
	gCmd.REQ_HERO_TRAIN_RECEIVE.position = position
	;(nil).data, gCmd.REQ_HERO_TRAIN_RECEIVE.heroID = gCmd.REQ_HERO_TRAIN_RECEIVE, heroID
	local msg
	serverproxy:SendMsg(msg)
end
function heroTrainGroundCtrl:initRsp(content)
	dump(content, "heroTrainGroundCtrl:initRsp", 10)
	if content.err == gErrDef.Err_None then
		self.trainInfo = content.rspdata.trainInfo
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROTRAIN_INIT"
		SoraDSendMessage(gErrDef.Err_None)
	else
	end
end
function heroTrainGroundCtrl:goTrainRsp(content)
	dump(content, "heroTrainGroundCtrl:goTrainRsp", 10)
	if content.err == gErrDef.Err_None then
		self.trainInfo = content.rspdata.trainInfo
		local pid = content.data.position
		_ENV = "heroTrainGroundCtrl:goTrainRsp"
		;("heroTrainGroundCtrl:goTrainRsp").msg = "MESSAGE_SERVER_HEROTRAIN_TRAINSUCCESS"
		;("heroTrainGroundCtrl:goTrainRsp").position = pid
		SoraDSendMessage("heroTrainGroundCtrl:goTrainRsp")
	else
		if gErrDef.Err_HERO_TRAIN_SOLIDERS_PARAM_ERROR == content.err then
			SoraDShowMsgTip(i18n("hero_text_82"))
		elseif gErrDef.Err_HERO_TRAIN_HERO_LEADER_POINT_LIMIT == content.err then
			SoraDShowMsgTip(i18n("herotrain_text_20"))
		end
		_ENV = i18n("herotrain_text_20")
		i18n("herotrain_text_20").msg = "MESSAGE_SERVER_HEROTRAIN_TRAINFAIL"
		SoraDSendMessage(i18n("herotrain_text_20"))
	end
end
function heroTrainGroundCtrl:speedUpRsp(content)
	dump(content, "heroTrainGroundCtrl:speedUpRsp", 10)
	if content.err == gErrDef.Err_None then
		self.trainInfo = content.rspdata.trainInfo
		local pid = content.data.position
		_ENV = "heroTrainGroundCtrl:speedUpRsp"
		;("heroTrainGroundCtrl:speedUpRsp").msg = "MESSAGE_SERVER_HEROTRAIN_SPEEDSUCCESS"
		;("heroTrainGroundCtrl:speedUpRsp").position = pid
		SoraDSendMessage("heroTrainGroundCtrl:speedUpRsp")
	else
	end
end
function heroTrainGroundCtrl:stopTrainRsp(content)
	dump(content, "heroTrainGroundCtrl:stopTrainRsp", 10)
	if content.err == gErrDef.Err_None then
		self.trainInfo = content.rspdata.trainInfo
		local pid = content.data.position
		_ENV = "heroTrainGroundCtrl:stopTrainRsp"
		;("heroTrainGroundCtrl:stopTrainRsp").msg = "MESSAGE_SERVER_HEROTRAIN_STOPSUCCESS"
		;("heroTrainGroundCtrl:stopTrainRsp").position = pid
		SoraDSendMessage("heroTrainGroundCtrl:stopTrainRsp")
	else
	end
end
function heroTrainGroundCtrl:gainExpRsp(content)
	dump(content, "heroTrainGroundCtrl:gainExpRsp", 10)
	if content.err == gErrDef.Err_None then
		local pid = content.data.position
		local heroID = self.trainInfo[pid] and self.trainInfo[pid].heroID or 0
		local gainPoint = self.trainInfo[pid] and self.trainInfo[pid].leaderPoint or 0
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroName = i18n(heroltCtrl.getHeroInfo(heroID).herName)
		_ENV = nil
		;(nil).hero = heroName
		;(nil).num = gainPoint
		SoraDShowMsgTip(i18n("hero_text_79", nil))
		self.trainInfo = content.rspdata.trainInfo
		if self.trainInfo[pid] then
			self.trainInfo[pid].heroID = heroID
		end
		self.curSoldiers = content.rspdata.curSoldiers
		_ENV = i18n("hero_text_79", nil)
		i18n("hero_text_79", nil).msg = "MESSAGE_SERVER_HEROTRAIN_GAINSUCCESS"
		i18n("hero_text_79", nil).position = pid
		i18n("hero_text_79", nil).isGain = true
		SoraDSendMessage(i18n("hero_text_79", nil))
		local heroCtrl = gametop.playertop_:getModule("heroCtrl")
		local heroInfo = heroCtrl:getHeroInfoByID(heroID)
		local limitLv = heroltCtrl.getLimitHeroLv(heroInfo.isAwake)
		if heroInfo and limitLv <= heroInfo.level then
			SoraDShowMsgTip(i18n("herotrain_text_15"))
		end
	else
		if gErrDef.Err_HERO_TRAIN_HERO_STATUS_ERROR == content.err then
			local heroCtrl = gametop.playertop_:getModule("heroCtrl")
			local heroID = content.data.heroID
			local state = heroCtrl:getHeroInfoByID(heroID).state
			if gHeroState.HERO_STATE_CAPTURED == state then
				SoraDShowMsgTip(i18n("herotrain_text_14"))
			elseif gHeroState.HERO_STATE_DEAD == state then
				SoraDShowMsgTip(i18n("herotrain_text_13"))
			elseif gHeroState.HERO_STATE_BATTLE == state or gHeroState.HERO_STATE_ESCAPE == state then
				SoraDShowMsgTip(i18n("herotrain_text_14"))
			end
		end
		_ENV = content.data.heroID
		content.data.heroID.msg = "MESSAGE_SERVER_HEROTRAIN_COMMONFAIL"
		SoraDSendMessage(content.data.heroID)
	end
end
function heroTrainGroundCtrl:getPositionTrainTime(pid)
	if self.trainInfo[pid] and self.trainInfo[pid].status == gHeroTrainGroundStatus.TRAINING then
		local totaltime = self.trainInfo[pid].totaltime or self.trainInfo[pid].endtime - self.trainInfo[pid].begintime
		return self.trainInfo[pid].endtime - serviceFunctions.systemTime(), totaltime
	end
end
function heroTrainGroundCtrl:getTrainInfo(...)
	return self.trainInfo
end
function heroTrainGroundCtrl:getTrainInfoByPosition(pid)
	return self.trainInfo[pid]
end
function heroTrainGroundCtrl:getTrainNumState(...)
	local total = #self.trainInfo
	local cur = 0
	for _, v in ipairs(self.trainInfo) do
		if v.status == gHeroTrainGroundStatus.TRAINING then
			cur = cur + 1
		end
	end
	return cur, total
end
function heroTrainGroundCtrl:getTrainFinishTime(...)
	local _ENV, ret, info = nil, false, nil
	local nowTime = serviceFunctions.systemTime()
	for _, v in pairs(self.trainInfo) do
		if v.status == gHeroTrainGroundStatus.TRAINING then
			ret = true
			_ENV = nil
			;(nil).hid = v.heroID
			;(nil).time = v.endtime - nowTime
			table.insert(info, nil)
		end
	end
	return ret, info
end
function heroTrainGroundCtrl:getTrainUnlockSiteNum(...)
	return #self.trainInfo
end
function heroTrainGroundCtrl:getCanTrainHeroList(...)
	local _ENV, removeList
	for _, v in pairs(self.trainInfo) do
		if v.totaltime and v.totaltime > 0 then
			removeList[v.heroID] = true
		end
	end
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local _ENV, ret = gametop.playertop_, gametop.playertop_
	for _, v in pairs(heroCtrl:getHaveHerosList()) do
		if not removeList[tonumber(v)] then
			table.insert(ret, v)
		end
	end
	return ret
end
function heroTrainGroundCtrl:getTrainArmyList(...)
	local _ENV, retTbl
	local mergeArmyList = function(tbl1, tbl2)
		local _ENV, ret
		for k, v in pairs(tbl1) do
			ret[k] = v
			if tbl2[k] then
				ret[k] = ret[k] + tbl2[k]
				tbl2[k] = nil
			end
		end
		for k, v in pairs(tbl2) do
			if not ret[k] then
				ret[k] = v
			end
		end
		return ret
	end
	for k, v in pairs(self.trainInfo) do
		if gHeroTrainGroundStatus.TRAINING == v.status then
			local itsArmyList = clone(v.trainSoldier)
			retTbl = mergeArmyList(retTbl, itsArmyList)
		end
	end
	return retTbl
end
function heroTrainGroundCtrl:isHaveTrainning(...)
	local have = false
	for _, v in ipairs(self.trainInfo) do
		if v.status == gHeroTrainGroundStatus.TRAINING then
			have = true
			break
		end
	end
	return have
end
function heroTrainGroundCtrl:isExclamationOrisZZZ(...)
	local isExclamation = 0
	local ZZZ = 0
	for _, v in ipairs(self.trainInfo) do
		if v.status == gHeroTrainGroundStatus.TRAIN_FINISH or v.status == gHeroTrainGroundStatus.STOP_TRAIN then
			isExclamation = isExclamation + 1
		elseif v.status == gHeroTrainGroundStatus.NO_TRAIN then
			ZZZ = ZZZ + 1
		end
	end
	return 0 < isExclamation, ZZZ >= #self.trainInfo
end
function heroTrainGroundCtrl.serverState2clientState(state)
	_ENV = nil
	;(nil)[gHeroTrainGroundStatus.NO_TRAIN] = gHeroTrainSingleStyle.idle
	;(nil)[gHeroTrainGroundStatus.TRAINING] = gHeroTrainSingleStyle.trainning
	;(nil)[gHeroTrainGroundStatus.STOP_TRAIN] = gHeroTrainSingleStyle.done
	local (nil)[gHeroTrainGroundStatus.TRAIN_FINISH], transDict = gHeroTrainSingleStyle.done, nil
	if state then
		return transDict[state]
	else
		return gHeroTrainSingleStyle.lock
	end
end
function heroTrainGroundCtrl:getBuildAdd(attr)
	local bid = BUILDID.HERO_TRAIN_GROUND
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local blv = cityCtrl:getBuildMaxLv(bid)
	local buildLogic = include("buildLogic")
	return buildLogic.getBuildBaseValue(bid, attr)
end
function heroTrainGroundCtrl:getArmyPoint(soldiers)
	local point = 0
	if type(soldiers) == "table" and next(soldiers) then
		for armyID, armyCount in pairs(soldiers) do
			local tmpPoint = armyltCtrl.armyAttr(armyID, ARMY_ATTR.TRAINPOINT)
			point = point + tmpPoint * armyCount
		end
	end
	return point
end
local my_math_log = function(x, base)
	return math.log(x) / math.log(base)
end
function heroTrainGroundCtrl:getHourLeaderPoint(soldiers)
	local buildBaseExp = self:getBuildAdd(BUILD_LVINFO.BASEEXP)
	local point = self:getArmyPoint(soldiers)
	local armyExp = 0
	if 1 <= point then
		armyExp = (1.5 ^ my_math_log(6000 / point, 2) * 0.3333333333333333 * point - 34) * 0.8
		armyExp = math.floor(armyExp)
	end
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local technoAdd = technologyCtrl:getTechnologyPower(gTechnologyType.TRAIN_HERO_LEADER_POINT_ADD)
	local buildAdd = self:getBuildAdd(BUILD_LVINFO.TRAINEXPBONUS) or 0
	buildAdd = buildAdd / 1000
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	local buff = buffCtrl:getBuffEffect(gBuffEffect.HERO_TRAIN_GROUND_EXP_PLUS) or 0
	_ENV, buff = buffCtrl, buff / 1000
	buffCtrl.base = buildBaseExp + armyExp
	buffCtrl.technoAdd = technoAdd
	buffCtrl.buildAdd = buildAdd
	buffCtrl.add = technoAdd + buildAdd
	local buffCtrl.total, ret = (buildBaseExp + armyExp) * (1 + technoAdd + buildAdd + buff), buffCtrl
	return ret
end
function heroTrainGroundCtrl:getCostTime(soldiers)
	local buildBaseTime = self:getBuildAdd(BUILD_LVINFO.BUILDTIME)
	local point = self:getArmyPoint(soldiers)
	local armyTime = 0
	if 1 <= point then
		armyTime = math.floor(1.5 ^ my_math_log(6000 / point, 2) * 0.25 * point - 25) * 60
	end
	local ret = buildBaseTime + armyTime
	return ret
end
function heroTrainGroundCtrl:getCurSoldiers()
	return self.curSoldiers
end
function heroTrainGroundCtrl:ctor(properties)
	heroTrainGroundCtrl.super.ctor(self, properties)
	self:resetData()
end
function heroTrainGroundCtrl:EnterGame()
	heroTrainGroundCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_HERO_TRAIN_MODULE, gCmd.REQ_HERO_TRAIN_INIT, handler(self, self.initRsp))
	msgCtrl.register(gCmd.CMD_HERO_TRAIN_MODULE, gCmd.REQ_HERO_TRAIN_TRAIN, handler(self, self.goTrainRsp))
	msgCtrl.register(gCmd.CMD_HERO_TRAIN_MODULE, gCmd.REQ_HERO_TRAIN_SPEED, handler(self, self.speedUpRsp))
	msgCtrl.register(gCmd.CMD_HERO_TRAIN_MODULE, gCmd.REQ_HERO_TRAIN_STOP, handler(self, self.stopTrainRsp))
	msgCtrl.register(gCmd.CMD_HERO_TRAIN_MODULE, gCmd.REQ_HERO_TRAIN_RECEIVE, handler(self, self.gainExpRsp))
end
function heroTrainGroundCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_TRAIN, handler(self, self.noitfyDataRsp))
end
function heroTrainGroundCtrl:noitfyDataRsp(content)
	dump(content, "noitfyDataRsp@@@@", 10)
	local loopData = content.data
	for i, notifyMsg in ipairs(loopData) do
		local revcDataType = notifyMsg.notifyType
		local revcData = notifyMsg.trainInfo
		self.trainInfo = revcData
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_HEROTRAIN_NOTIFY"
		;(nil).noticeType = revcDataType
		SoraDSendMessage(nil)
	end
	_ENV = ipairs(loopData)
	ipairs(loopData).msg = "MESSAGE_UI_PANDECT_HEROTRAIN"
	SoraDSendMessage(ipairs(loopData))
end
function heroTrainGroundCtrl:resetData()
	self.trainInfo, _UPVALUE0_ = nil, nil
	self.curSoldiers = nil
end
function heroTrainGroundCtrl:Logout()
	heroTrainGroundCtrl.super.Logout(self)
	self:resetData()
end
function heroTrainGroundCtrl:initClientData(data)
	if nil == data then
		return
	end
	if not data.trainInfo then
		_UPVALUE0_ = data.trainInfo
	end
	self.trainInfo = data.trainInfo
	self:registerNotify()
end
return heroTrainGroundCtrl
