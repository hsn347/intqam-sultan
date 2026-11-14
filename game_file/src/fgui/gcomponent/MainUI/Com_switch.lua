local gametop = gModuleMgr.getObject("gametop")
local funUnlockRead = include("funUnlockRead")
local mainUIDef = include("mainUIDef")
local baseComponent = require("fgui.base.baseComponent")
local Com_switch = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_switch", Com_switch)
_ENV, _ENV = "ui://MainUI/Com_switch", fgui.register_extension
;("ui://MainUI/Com_switch").index = 1
;("ui://MainUI/Com_switch").name = "Btn_pyramidBattle"
_ENV, fgui.register_extension[1], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 1
;("ui://MainUI/Com_switch").index = 3
;("ui://MainUI/Com_switch").name = "Btn_cityUnlockBuild"
_ENV, fgui.register_extension[3], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 3
;("ui://MainUI/Com_switch").index = 4
;("ui://MainUI/Com_switch").name = "Btn_newPlayerBuff"
_ENV, fgui.register_extension[4], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 4
;("ui://MainUI/Com_switch").index = 5
;("ui://MainUI/Com_switch").name = "Btn_princeGiftNewBuff"
_ENV, fgui.register_extension[5], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 5
;("ui://MainUI/Com_switch").index = 6
;("ui://MainUI/Com_switch").name = "Btn_princeGiftBuff"
_ENV, fgui.register_extension[6], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 6
;("ui://MainUI/Com_switch").index = 8
;("ui://MainUI/Com_switch").name = "Btn_kingdomManager"
_ENV, fgui.register_extension[8], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 8
;("ui://MainUI/Com_switch").index = 9
;("ui://MainUI/Com_switch").name = "Btn_legendKingManager"
_ENV, fgui.register_extension[9], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 9
;("ui://MainUI/Com_switch").index = 10
;("ui://MainUI/Com_switch").name = "Btn_hegemonManager"
_ENV, fgui.register_extension[10], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 10
;("ui://MainUI/Com_switch").index = 11
;("ui://MainUI/Com_switch").name = "Btn_hegemonBattle"
_ENV, fgui.register_extension[11], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 11
;("ui://MainUI/Com_switch").index = 14
;("ui://MainUI/Com_switch").name = "Btn_romanSoul"
_ENV, fgui.register_extension[14], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 14
;("ui://MainUI/Com_switch").index = 15
;("ui://MainUI/Com_switch").name = "Btn_replay"
_ENV, fgui.register_extension[15], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 15
;("ui://MainUI/Com_switch").index = 16
;("ui://MainUI/Com_switch").name = "Btn_luckyRecharge"
_ENV, fgui.register_extension[16], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 16
;("ui://MainUI/Com_switch").index = 17
;("ui://MainUI/Com_switch").name = "Btn_goldPackage"
_ENV, fgui.register_extension[17], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 17
;("ui://MainUI/Com_switch").index = 18
;("ui://MainUI/Com_switch").name = "Btn_monthCard"
_ENV, fgui.register_extension[18], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 18
;("ui://MainUI/Com_switch").index = 19
;("ui://MainUI/Com_switch").name = "Btn_crazyTrio"
_ENV, fgui.register_extension[19], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 19
;("ui://MainUI/Com_switch").index = 23
;("ui://MainUI/Com_switch").name = "Btn_communityCenter"
_ENV, fgui.register_extension[23], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 23
;("ui://MainUI/Com_switch").index = 27
;("ui://MainUI/Com_switch").name = "Btn_harvestSeason"
_ENV, fgui.register_extension[27], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 27
;("ui://MainUI/Com_switch").index = 28
;("ui://MainUI/Com_switch").name = "Btn_questionnaire"
_ENV, fgui.register_extension[28], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 28
;("ui://MainUI/Com_switch").index = 29
;("ui://MainUI/Com_switch").name = "Btn_payBack"
_ENV, fgui.register_extension[29], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 29
;("ui://MainUI/Com_switch").index = 30
;("ui://MainUI/Com_switch").name = "Btn_downloadPre"
_ENV, fgui.register_extension[30], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 30
;("ui://MainUI/Com_switch").index = 31
;("ui://MainUI/Com_switch").name = "Btn_commonWar"
_ENV, fgui.register_extension[31], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 31
;("ui://MainUI/Com_switch").index = 36
;("ui://MainUI/Com_switch").name = "Btn_kingStarManager"
_ENV, fgui.register_extension[36], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 9.1
;("ui://MainUI/Com_switch").index = 38
;("ui://MainUI/Com_switch").name = "Btn_commandHall"
;("ui://MainUI/Com_switch").sort = 34
_ENV, fgui.register_extension[38], ("ui://MainUI/Com_switch").btnName = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", "Btn_commandHall"
;("ui://MainUI/Com_switch").index = 43
;("ui://MainUI/Com_switch").name = "Btn_ramadanCalendar"
_ENV, fgui.register_extension[43], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", "ui://MainUI/Com_switch", 32
;("ui://MainUI/Com_switch").index = 44
;("ui://MainUI/Com_switch").name = "Btn_dj"
fgui.register_extension[44], ("ui://MainUI/Com_switch").sort = "ui://MainUI/Com_switch", 0
local switchDef = fgui.register_extension
function Com_switch:addButtonDJ(...)
	local djCtrl = SoraDGetCtrl("djCtrl")
	local isLiving = false
	local djList = djCtrl:getDJTimeList()
	for _, v in ipairs(djList) do
		if v.anchorLiving and v.uid ~= SoraDGetPlayerID() then
			isLiving = true
			break
		end
	end
	if IsArClient and djCtrl:isChatDJChannelOpen() and isLiving then
		_ENV = v.uid
		self:addOneChild(44, nil, nil, v.uid)
	else
		self:delOneChild(44)
	end
end
function Com_switch:addSwitchActivityBtn(activityID)
	local cfg = mainUIDef.activityCfg[activityID]
	local info = clientEventMgr.getEventInfoByeid(activityID)
	if info then
		if cfg.extraCondition and not cfg.extraCondition() then
			self:delActivityBtn(activityID)
		else
			self:addActivityBtn(activityID)
		end
	else
		self:delActivityBtn(activityID)
	end
end
function Com_switch:addActivityBtn(activityID)
	local isAdded = false
	for k, v in ipairs(self.childList) do
		if v.activityID == activityID then
			_ENV = k - 1
			;(k - 1).activityID = activityID
			self.fields.List:getChildAt(k - 1):initData(k - 1)
			isAdded = true
			break
		end
	end
	if not isAdded then
		local data = mainUIDef.activityCfg[activityID]
		data.activityID = activityID
		table.insert(self.childList, data)
		table.sort(self.childList, function(a, b)
			return a.sort < b.sort
		end)
		self.fields.List:setNumItems(#self.childList)
		self:updateContainer()
	end
end
function Com_switch:delActivityBtn(activityID)
	for k, v in ipairs(self.childList) do
		if v.activityID == activityID then
			table.remove(self.childList, k)
		end
	end
	table.sort(self.childList, function(a, b)
		return a.sort < b.sort
	end)
	self.fields.List:setNumItems(#self.childList)
	self:updateContainer()
end
function Com_switch:addButtonActivity9001566(...)
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		return
	end
	local activity_9001566_Ctrl = SoraDGetCtrl("activity_9001566_Ctrl")
	local activityID = activity_9001566_Ctrl:getActivityIDInWar()
	if activityID and clientEventMgr.judgeIsOpen(activityID) then
		local num = activity_9001566_Ctrl:getRedPointNum(activityID)
		_ENV = nil
		;(nil).activityID = activityID
		self:addOneChild(43, num, nil, nil)
	else
		self:delOneChild(43)
	end
end
function Com_switch:btnCommandHallChek(...)
	local commandHallUtil = include("commandHallUtil")
	if not commandHallUtil.checkOpenLv() then
		return
	end
	if worldMapDefine.inInCrossWar() then
		self:delOneChild(38)
		return
	end
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.COMMAND_HALL_ACTIVITY
	self:addOneChild(38, 0, nil, nil)
	local commandHallUtil = include("commandHallUtil")
	commandHallUtil.checkShowWarning()
end
function Com_switch:btnKingStarManagerCheck()
	local isShow = false
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	local isLegendKing = kingStarCtrl:getIsSelfLegendKing()
	if isLegendKing and not worldMapDefine.isInRemains() and not worldMapDefine.isLegendMapId(gametop.playertop_:getMapID()) then
		isShow = true
	end
	if isShow then
		local activityID = kingStarCtrl:getTitleActivityId()
		print("btnKingStarManagerCheck activityID======", activityID)
		gametop = gametop.playertop_:getMapID()
		gametop.playertop_:getMapID().activityID = activityID
		self:addOneChild(36, nil, nil, gametop.playertop_:getMapID())
	else
		self:delOneChild(36)
	end
end
function Com_switch:addEightButton()
	if SoraDGetCastleLv() < CASTLE_LV110_LIMITED then
		return
	end
	local shiftingstarsRead = include("shiftingstarsRead")
	local isInWar = worldMapDefine.inInCrossWar()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY) and not isInWar then
		local activityCenterUICtrl = gametop.playertop_:getModule("activityCenterUICtrl")
		local newF = activityCenterUICtrl:isHaveNewFlag(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
		_ENV = nil
		;(nil).new = newF
		self:addOneChild(34, nil, nil, nil)
	else
		self:delOneChild(34)
	end
end
function Com_switch:refreshBattleOpenBtn()
	local _ENV, openList
	if worldMapDefine.isInWar() then
		self:delOneChild(31)
		return
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	local remainsTeamCtrl = SoraDGetCtrl("remainsTeamCtrl")
	local isInConquestWar = conquestWarCtrl:getConquestWarState() == gConquestWarState.OPENING
	local warStatus = worldMapDefine.kingWarStatus
	if not isInConquestWar and warStatus == gKingdomWarStatusType.inWar then
		local coolQueue = queueCtrl:queryQueue(gQueueTypeDef.world_resource_cool, gWorldResourceCoolQueueId)
		if coolQueue then
			_ENV = gWorldResourceCoolQueueId
			gWorldResourceCoolQueueId.ctype = 1
			table.insert(openList, gWorldResourceCoolQueueId)
		end
	end
	if isInConquestWar then
		local castle_limited = _G.CASTLE_LV16_LIMITED
		if castle_limited <= SoraDGetCastleLv() then
			_ENV = gWorldResourceCoolQueueId
			gWorldResourceCoolQueueId.ctype = 2
			table.insert(openList, gWorldResourceCoolQueueId)
		end
	end
	if remainsTeamCtrl:isActiveOpen() and (remainsTeamCtrl:isWarMatchBegin() or remainsTeamCtrl:isTeamCanInWar() and remainsTeamCtrl:isHasTeam()) then
		local castle_limited = _G.CASTLE_LV27_LIMITED
		if castle_limited <= SoraDGetCastleLv() then
			_ENV = gWorldResourceCoolQueueId
			gWorldResourceCoolQueueId.ctype = 3
			table.insert(openList, gWorldResourceCoolQueueId)
		end
	end
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY) then
		local newTrialRead = include("newTrialRead")
		local castle_limited = newTrialRead.getCastleCondition(1) or 0
		if castle_limited <= SoraDGetCastleLv() then
			_ENV = nil
			;(nil).ctype = 4
			table.insert(openList, nil)
		end
	end
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LEGEND_LORD) then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			local castle_limited = _G.CASTLE_LV50_LIMITED
			if castle_limited <= SoraDGetCastleLv() then
				_ENV = nil
				;(nil).ctype = 5
				table.insert(openList, nil)
			end
		end
	end
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KING_STAR_BATTLE) then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			local castle_limited = _G.CASTLE_LV50_LIMITED
			if castle_limited <= SoraDGetCastleLv() then
				_ENV = nil
				;(nil).ctype = 7
				table.insert(openList, nil)
			end
		end
	end
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY) then
		local atlantisState = SoraDGetCtrl("atlantisActivityCtrl"):getActivityCurState()
		if atlantisState == ATLANTIS_WAR_STATE.BATTLE then
			_ENV = table.insert
			table.insert.ctype = 6
			table.insert(openList, table.insert)
		end
	end
	dump(openList, "openList====")
	if #openList == 0 then
		self:delOneChild(31)
		return
	end
	_ENV = nil
	;(nil).list = openList
	self:addOneChild(31, nil, nil, nil)
end
function Com_switch:checkPreDownloadStatus()
	local preDownloadUtil = include("preDownloadUtil")
	local isShow = preDownloadUtil.isShowPreDownloadWidget()
	if isShow then
		self:addOneChild(30)
	else
		self:delOneChild(30)
	end
end
function Com_switch:btnPayBackCheck()
	local payBackCtrl = SoraDGetCtrl("payBackCtrl")
	local price = payBackCtrl:getPrice()
	if 0 < price then
		self:addOneChild(29, nil, i18n("PayBack_Text_01"))
	else
		self:delOneChild(29)
	end
end
function Com_switch:updateQuestionnaireButton()
	local questionnaireCtrl = SoraDGetCtrl("questionnaireCtrl")
	local num = questionnaireCtrl:getReceiveStatusAndNum()
	if num == 0 or worldMapDefine.inInCrossWar() then
		self:delOneChild(28)
	else
		self:addOneChild(28, num)
	end
end
function Com_switch:addHarvestSeasonButton()
	if not IsArClient then
		return
	end
	local _ENV, actIDList = IsArClient, IsArClient
	local newFlag = false
	local config = require("app." .. LocalTblPath .. ".config_server.act_common_config")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local activityCenterUICtrl = gametop.playertop_:getModule("activityCenterUICtrl")
	local remainTime = 0
	for actID, v in pairs(config) do
		if clientEventMgr.judgeIsOpen(actID) then
			local newF = activityCenterUICtrl:isHaveNewFlag(actID)
			if newF then
				newFlag = true
			end
			table.insert(actIDList, actID)
			local eventTime = activityShowCtrl:getTimeInfoByID(actID)
			if eventTime then
				local tmp = eventTime.timerNode.timer:getRemainTime()
				if remainTime < tmp then
					remainTime = tmp
				end
			end
		end
	end
	if 0 < remainTime then
		_ENV = activityCenterUICtrl:isHaveNewFlag(actID)
		activityCenterUICtrl:isHaveNewFlag(actID).actIDList = actIDList
		self:addOneChild(27, newFlag and 1 or 0, nil, (activityCenterUICtrl:isHaveNewFlag(actID)))
	else
		self:delOneChild(27)
	end
end
function Com_switch:updateCommunityButton()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
	local commnutiInfo = activityShowCtrl:getCommunityInfo(gActivityTimeActivityID.COMMUNITY_CENTER_MAIN_UI)
	if commnutiInfo.param and commnutiInfo.param.show then
		if commnutiInfo.param.type == 1 then
			self:addOneChild(23, nil, nil, commnutiInfo)
		elseif commnutiInfo.param.type == 0 and activityCenterUICtrl:isHaveNewFlag(gActivityTimeActivityID.COMMUNITY_CENTER_MAIN_UI) then
			self:addOneChild(23, nil, nil, commnutiInfo)
		end
	end
end
function Com_switch:addCrazyTrioButton()
	local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
	local rechargeltCtrl = include("rechargeltCtrl")
	local crazyData = cumuActiveCtrl:getCrazyTrioData()
	local receiveNum = table.nums(crazyData.receive)
	if cumuActiveCtrl:getActivityID() ~= gActivityTimeActivityID.CRAZY_TRIO_ACTIVITY and 2 <= receiveNum then
		gametop = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:eventCrazyTrioNew:isShowInDown~bool", true, nil)
	end
	if clientEventMgr.judgeIsOpen(cumuActiveCtrl:getActivityID()) then
		gametop = cumuActiveCtrl:getActivityID()
		cumuActiveCtrl:getActivityID().byUID = true
		if SoraDConfigGet("Game:eventCrazyTrioNew:isShowInDown~bool", cumuActiveCtrl:getActivityID()) and receiveNum < rechargeltCtrl.getRechargeTotalConfigNum() then
			local _, num = cumuActiveCtrl:getInitialReceiveState()
			self:addOneChild(19, num)
	end
	else
		self:delOneChild(19)
	end
end
function Com_switch:updateMonthCardButton()
	if not IsArClient then
		local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
		local hasGift, hasBuy, hasGot = rechargeActivityCtrl:getMonthlyCard()
		if hasGift and not hasBuy then
			self:addOneChild(18)
		else
			self:delOneChild(18)
		end
	end
end
function Com_switch:addGoldPackageButton()
	if worldMapDefine.isInRemains() or not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GOLD_PACKAGE) then
		self:delOneChild(17)
	else
		self:addOneChild(17)
	end
end
function Com_switch:updateBtnLuckyRecharge()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT) or worldMapDefine.inInCrossWar() then
		self:delOneChild(16)
		return
	end
	local eventLuckyRechargeCtrl = gametop.playertop_:getModule("eventLuckyRechargeCtrl")
	local luckyRechargeData = eventLuckyRechargeCtrl:getLuckyRechargeData()
	local state = luckyRechargeData.rechargeStatus
	if state then
		if state == gLuckyRechargeStatus.CAN_NOT_RECEIVE then
			local rtarget = luckyRechargeData.todayRechargeTarget or 0
			_ENV = rtarget
			rtarget.index = 0
			self:addOneChild(16, nil, "$" .. rtarget, rtarget)
		elseif state == gLuckyRechargeStatus.CAN_RECEIVE then
			_ENV = "$" .. rtarget
			;("$" .. rtarget).index = 1
			self:addOneChild(16, nil, nil, "$" .. rtarget)
		else
			self:delOneChild(16)
		end
	else
		self:delOneChild(16)
	end
end
function Com_switch:startRecordScreen()
	self:addOneChild(15)
end
function Com_switch:stopRecording()
	_ENV = nil
	;(nil).type = 2
	;(nil).times = gSDKDef.GAME_RECORD_TIME
	userSDKManager.logEvent(gSDKDef.TDonEvent.screen_recording_log, nil)
	gSDKDef.GAME_RECORD_TIME = 0
	userSDKManager.stopRecording()
	self:delOneChild(15)
end
function Com_switch:checkRomanSoul()
	local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
	local isRomanEvent = false
	if romeActivityCtrl.state == gAllianceRomeActivityState.RUNNING and not worldMapDefine.isInRemains() then
		isRomanEvent = true
	end
	if isRomanEvent then
		self:addOneChild(14)
	else
		self:delOneChild(14)
	end
	return isRomanEvent
end
function Com_switch:btnHegemonBattleCheck()
	local worldMapDefine = include("worldMapDefine")
	local isShow = false
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	if SoraDGetCastleLv() < 30 or worldMapDefine.isInRemains() then
		isShow = false
	else
		local joinBid = hegemonCtrl:getJoinBid()
		if not joinBid then
			isShow = false
		elseif worldMapDefine.isInLegendLord() then
			isShow = false
		else
			local hegemonRead = include("hegemonRead")
			local activityID = hegemonRead.getActivityIdByBuildID(joinBid)
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			local param = activityShowCtrl:getParamByID(activityID)
			if param then
				local curState = param.curState
				if curState == ACTIVITY_STATE.ACTIVE then
					local settleTime = param.timeConfig.settleTime
					local leftTime = settleTime - serviceFunctions.systemTime()
					if 0 < leftTime then
						isShow = true
						self:addOneChild(11)
					else
						isShow = false
					end
				end
			end
		end
	end
	if not isShow then
		self:delOneChild(11)
	end
end
function Com_switch:btnHegemonManagerCheck()
	local isShow = false
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	local isHegemon = hegemonCtrl:getIsSelfHegemon()
	if isHegemon and not worldMapDefine.isInRemains() then
		isShow = true
	end
	if isShow then
		self:addOneChild(10)
	else
		self:delOneChild(10)
	end
end
function Com_switch:btnLegendKingManagerCheck()
	local isShow = false
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	local isLegendKing = legendLordCtrl:getIsSelfLegendKing()
	dump(legendLordCtrl:getIsSelfLegendKing(), "legendLordCtrl:getIsSelfLegendKing()")
	if isLegendKing and not worldMapDefine.isInRemains() and not worldMapDefine.isKingStarMapId(gametop.playertop_:getMapID()) then
		isShow = true
	end
	if isShow then
		self:addOneChild(9)
	else
		self:delOneChild(9)
	end
end
function Com_switch:btnKingdomManagerCheck()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local myRank = kingdomMapCtrl:getKingWarRank()
	local isShow = false
	if not worldMapDefine.isInWar() then
		if SoraDIsSelfKing() or SoraDIsSelfQueen() then
			isShow = true
			gametop = nil
			;(nil).index = 0
			self:addOneChild(8, nil, nil, nil)
		elseif myRank and myRank >= ALLIANCE_GIFT_MAX_RANK and myRank <= ALLIANCE_GIFT_MIN_RANK then
			isShow = true
			local leftTime = kingdomMapCtrl:getKingWarPackLeftTime()
			if 0 < leftTime then
				gametop = nil
				;(nil).time = leftTime
				;(nil).index = 1
				self:addOneChild(8, nil, nil, nil)
			end
		end
	end
	if not isShow then
		self:delOneChild(8)
	end
end
function Com_switch:addPrinceGiftBuffButton(target, data)
	local princeGiftCtrl = gametop.playertop_:getModule("princeGiftCtrl")
	if data and data.isRelogin then
		princeGiftCtrl:reqInitInfo()
	end
	local remainTime = princeGiftCtrl:getBuffEndTime() - serviceFunctions.systemTime()
	if 0 < remainTime then
		gametop = nil
		;(nil).time = remainTime
		self:addOneChild(6, nil, nil, nil)
	else
		self:delOneChild(6)
	end
end
function Com_switch:addPrinceGiftNewBuffButton(target, data)
	local princeGiftNewCtrl = gametop.playertop_:getModule("princeGiftNewCtrl")
	if data and data.isRelogin then
		princeGiftNewCtrl:reqInitInfo()
	end
	local remainTime = princeGiftNewCtrl:getBuffEndTime() - serviceFunctions.systemTime()
	if 0 < remainTime then
		gametop = nil
		;(nil).time = remainTime
		self:addOneChild(5, nil, nil, nil)
	else
		self:delOneChild(5)
	end
end
function Com_switch:btnNewPlayerBuffCheck()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local isNewPlayer = buffCtrl:isNewPlayerBuffOpen()
	local remainTime = buffCtrl:getRemainTimeByBuffID(5451) or 0
	if isNewPlayer and 0 < remainTime then
		gametop = nil
		;(nil).time = remainTime
		self:addOneChild(4, nil, nil, nil)
	else
		self:delOneChild(4)
	end
end
function Com_switch:btnCityUnlockCheck()
	local maincityDesRead = include("maincityDesRead")
	local lv = SoraDGetCastleLv()
	local data = maincityDesRead.getUnlockInfoByLv(lv, false)
	if 0 < #data then
		_ENV = nil
		;(nil).level = data[1].unlocklevel
		_ENV = "common_text_427"
		;("common_text_427").icon = maincityDesRead.getUnlockIconByLv(lv)
		self:addOneChild(3, nil, i18n("common_text_427", nil), "common_text_427")
	else
		self:delOneChild(3)
	end
end
function Com_switch:btnPyramidBattleCheck()
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local canShow, leftTime = pyramidWarCtrl:isShowEnterPyramidWar()
	canShow = canShow and not worldMapDefine.isInWar()
	if canShow then
		gametop = nil
		;(nil).time = leftTime or 0
		self:addOneChild(1, nil, nil, nil)
	else
		self:delOneChild(1)
	end
end
function Com_switch:onInit()
	self.childList, _ENV, self.isOpen = nil, nil, true
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_switch:addClickListener(handler(self, self.onBtnClick))
end
function Com_switch:onItemRenderer(index, obj)
	obj:initData(self.childList[index + 1])
end
function Com_switch:onShow()
end
function Com_switch:isAddedChild(sType)
	for k, v in ipairs(self.childList) do
		if v.index == sType then
			return true
		end
	end
	return false
end
function Com_switch:addOneChild(sType, num, title, extra)
	if not self:isAddedChild(sType) then
		local data = switchDef[sType]
		if num then
			data.num = num
		end
		if title then
			data.title = title
		end
		if extra then
			data.extra = extra
		end
		table.insert(self.childList, data)
		table.sort(self.childList, function(a, b)
			return a.sort < b.sort
		end)
		self.fields.List:setNumItems(#self.childList)
		self:updateContainer()
	else
		for k, v in ipairs(self.childList) do
			if v.index == sType then
				v.num = num
				v.title = title
				v.extra = extra
				self:getTargetByType(sType):initData(v)
				break
			end
		end
	end
end
function Com_switch:updateChildNum(sType, num)
	local btn = self:getTargetByType(sType)
	if btn and btn.setRed then
		btn:setRed(num)
	end
end
function Com_switch:delOneChild(sType)
	local isIn = false
	local _ENV, newList
	for k, v in ipairs(self.childList) do
		if v.index ~= sType then
			table.insert(newList, v)
		end
	end
	if #newList == #self.childList then
		return
	end
	self.childList = newList
	table.sort(self.childList, function(a, b)
		return a.sort < b.sort
	end)
	self.fields.List:setNumItems(#self.childList)
	self:updateContainer()
end
function Com_switch:clearChildren()
	self.childList, _UPVALUE0_ = nil, nil
	self.fields.List:setNumItems(#self.childList)
	self:updateContainer()
end
function Com_switch:updateContainer()
	if worldMapDefine.isInNewTrial() or worldMapDefine.isInSimulatedDrill() then
		self:setVisible(false)
		return
	end
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FUN_OPEN_PREVIEW)
	if unlockLv <= SoraDGetCastleLv() then
		if self.isOpen then
			local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
			local isShowBtn = meteorMagicCtrl:isShowSkillBtn()
			local maxCount = math.min(isShowBtn and 3 or 4, math.floor((display.height / 2 - 200) / 70))
			local height = math.max(70, math.min(#self.childList * 70, maxCount * 70))
			if #self.childList > 0 then
				self.fields.List:setContentSize(cc.size(120, height))
				self.controllers.c1:setSelectedIndex(0)
				self:setVisible(not worldMapDefine.isInNewTrial())
			else
				self:setVisible(false)
			end
		else
			self.controllers.c1:setSelectedIndex(1)
			self:setVisible(not worldMapDefine.isInNewTrial() and #self.childList > 0)
		end
	else
		self:setVisible(false)
	end
end
function Com_switch:updateView()
	if self.isOpen then
		self.fields.Button_switch:initData(0, 0)
		self:updateContainer()
	else
		self.fields.List:setContentSize(cc.size(120, 0))
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_switch:initData(1, #self.childList)
	end
end
function Com_switch:getTarget(name)
	if not self.childList then
		_ENV = self.childList
	end
	for k, v in ipairs(self.childList) do
		if v.btnName and v.btnName == name or v.name == name then
			return self.fields.List:getChildAt(k - 1), k - 1
		end
	end
end
function Com_switch:getTargetByType(sType)
	if not self.childList then
		_ENV = self.childList
	end
	for k, v in ipairs(self.childList) do
		if v.index == sType then
			return self.fields.List:getChildAt(k - 1)
		end
	end
end
function Com_switch:getChildNum()
	return #self.childList
end
function Com_switch:onBtnClick()
	SoraDPlaySound()
	self.isOpen = not self.isOpen
	self:updateView()
end
function Com_switch:gameGuide_getTarget(itemName)
	if not self.isOpen then
		self.isOpen = true
		self:updateView()
	end
	local target, index = self:getTarget(itemName)
	if index then
		self.fields.List:scrollToView(index)
	end
	return target and target.btnNode or nil
end
return Com_switch
