local _ENV, NoticeModule
function NoticeModule.checkTime(time)
	local aDay = 86400
	local nowTime = os.time()
	local dTime = nowTime + time
	if SoraDConfigGet("System:GameMessageView:NoDisturb~bool") then
		local rsTime, reTime = SoraDTimeToDate(dTime), SoraDTimeToDate(dTime)
		local sTime = SoraDTimeToDate(SoraDConfigGet("System:GameMessageView:NoDisturbStart~integer"))
		local eTime = SoraDTimeToDate(SoraDConfigGet("System:GameMessageView:NoDisturbEnd~integer"))
		rsTime.hour = sTime.hour
		rsTime.min = sTime.min
		reTime.hour = eTime.hour
		reTime.min = eTime.min
		if SoraDDateToTime(rsTime) > SoraDDateToTime(reTime) then
			if nowTime <= SoraDDateToTime(reTime) then
				rsTime = SoraDTimeToDate(SoraDDateToTime(rsTime) - aDay)
			else
				reTime = SoraDTimeToDate(SoraDDateToTime(reTime) + aDay)
			end
		elseif SoraDDateToTime(rsTime) < SoraDDateToTime(reTime) and nowTime >= SoraDDateToTime(reTime) then
			rsTime = SoraDTimeToDate(SoraDDateToTime(rsTime) + aDay)
			reTime = SoraDTimeToDate(SoraDDateToTime(reTime) + aDay)
		end
		if dTime >= SoraDDateToTime(rsTime) and dTime <= SoraDDateToTime(reTime) then
			time = SoraDDateToTime(reTime) - nowTime
		end
	end
	return time
end
function NoticeModule.reFutureDayTheTime(days, hour, min, sec)
	local sNowTime = os.time() + 86400 * (days or 1)
	local nextTime = SoraDTimeToDate(sNowTime)
	nextTime.hour = hour or 0
	nextTime.min = min or 0
	nextTime.sec = sec or 0
	return SoraDDateToTime(nextTime) - os.time()
end
function NoticeModule.addNotice(...)
	local gametop = gModuleMgr.getObject("gametop")
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local configLevelTrain = SoraDConfigGet("System:GameMessageView:LevelTrain~bool")
	_ENV = "System:GameMessageView:LevelTrain~bool"
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.free_build_queue] = configLevelTrain and "NOTIFICATION_LOCAL_BUILDHAMMERONE" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.charge_build_queue] = configLevelTrain and "NOTIFICATION_LOCAL_BUILDHAMMERTWO" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.chariot_plant_queue] = configLevelTrain and "NOTIFICATION_LOCAL_TRAIN_CHARIOT" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.stables_queue] = configLevelTrain and "NOTIFICATION_LOCAL_TRAIN_STABLES" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.range_queue] = configLevelTrain and "NOTIFICATION_LOCAL_TRAIN_RANGE" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.barracks_queue] = configLevelTrain and "NOTIFICATION_LOCAL_TRAIN_BARRACKS" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.frotress_queue] = configLevelTrain and "NOTIFICATION_LOCAL_TRAIN_FROTRESS" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.elite_queue] = configLevelTrain and "NOTIFICATION_LOCAL_TRAIN_ELITE" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.technology_upgrade_queue] = configLevelTrain and "NOTIFICATION_LOCAL_TECHNOLOGY" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.war_tech_research] = configLevelTrain and "NOTIFICATION_LOCAL_WAR_TECHNOLOGY" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.time_reward] = SoraDConfigGet("System:GameMessageView:Price~bool") and "NOTIFICATION_LOCAL_BUILD_MATOU" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.construction_drawing] = "NOTIFICATION_LOCAL_MASTERY_RECEIVE"
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.build_star_queue] = configLevelTrain and "NOTIFICATION_LOCAL_BUILDSTAR_QUEUE" or nil
	;("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.glorious_upgrade] = configLevelTrain and "NOTIFICATION_LOCAL_STATUE_BRAVE_QUEUE" or nil
	local ("System:GameMessageView:LevelTrain~bool")[gQueueTypeDef.nebula_palace_technology], queueTypeList = configLevelTrain and "NOTIFICATION_LOCAL_NEBULA_TECHNOLOGY_QUEUE" or nil, "System:GameMessageView:LevelTrain~bool"
	local worldMapWarDef = include("worldMapWarDef")
	local hospitalQueues = worldMapWarDef.getHospitalQueues()
	for queueType, __ in pairs(hospitalQueues) do
		queueTypeList[queueType] = configLevelTrain and "NOTIFICATION_LOCAL_HOSPITAL" or nil
	end
	dump(queueTypeList, "偷窥")
	for k, v in pairs(queueTypeList) do
		local timer = queueCtrl:queryQueue(k)
		if timer then
			local leftTime = timer.timerNode.timer:getRemainTime()
			SoraDAddNotice(leftTime, v, NoticeModule.getContent(k), true, false)
		end
	end
	if SoraDConfigGet("System:GameMessageView:Event~bool") then
		local storesCtrl = gametop.playertop_:getModule("storesCtrl")
		if storesCtrl:isStoreOpen() then
			local merchanteRefreshTime = storesCtrl:getRefreshRemainTime()
			SoraDAddNotice(merchanteRefreshTime, "NOTIFICATION_LOCAL_MERCHANTE", i18n("common_text_999"), true, false)
		end
	end
	local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
	if SoraDGetCastleLv() >= CASTLE_LV7_LIMITED and not epicWarCtrl:isExplorePointFull() then
		local epicWarTime = epicWarCtrl:getAllExploreRecoverTime()
		SoraDAddNotice(epicWarTime, "NOTIFICATION_LOCAL_EPIC_WAR", i18n("epicbattle_text_24"), true, false)
	end
	local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
	do
		local remainsWarTimeArray = remainsTeamCtrl:checkActivityMatchTime()
		if remainsWarTimeArray and next(remainsWarTimeArray) then
			do
				local addNoticeTime = function(status, key)
					local remainsWarTime = remainsWarTimeArray[status]
					if remainsWarTime and 0 < remainsWarTime then
						SoraDAddNotice(remainsWarTime, key, i18n("mail_text_516"), true, false)
					end
				end
				local RUINS_WAR_STATE = _G.RUINS_WAR_STATE
				addNoticeTime(RUINS_WAR_STATE.MATCH1, "NOTIFICATION_LOCAL_REMAINS_WAR_ACTIVIEY_MATCH1")
				addNoticeTime(RUINS_WAR_STATE.MATCH2, "NOTIFICATION_LOCAL_REMAINS_WAR_ACTIVIEY_MATCH2")
				addNoticeTime(RUINS_WAR_STATE.MATCH3, "NOTIFICATION_LOCAL_REMAINS_WAR_ACTIVIEY_MATCH3")
			end
		end
	end
	if SoraDConfigGet("Game:heroJail:heroCanExecute~bool") then
		local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
		local executeTime = heroJailCtrl:isAnyCanExecute()
		if executeTime then
			SoraDAddNotice(executeTime, "NOTIFICATION_LOCAL_HERO_CANEXECUTE", i18n("hero_text_94"), true, false)
		end
	end
	if SoraDConfigGet("Game:heroTrain:heroTrainFinish~bool") then
		local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
		local ret, info = heroTrainGroundCtrl:getTrainFinishTime()
		if ret then
			for _, v in ipairs(info) do
				SoraDAddNotice(v.time, "NOTIFICATION_LOCAL_HERO_TRAINFINISH", i18n("herotrain_text_27"), false, false)
			end
		end
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if activityShowCtrl:isShowGropupFundPage() then
		local growupFundCtrl = gametop.playertop_:getModule("growupFundCtrl")
		local ok = growupFundCtrl:getReceiveStatusAndNum()
		if ok then
			local time = NoticeModule.reFutureDayTheTime(0, 10, 30)
			if time < 0 then
				time = NoticeModule.reFutureDayTheTime(1, 10, 30)
			end
			SoraDAddNotice(time, "NOTIFICATION_LOCAL_GROWUPFUND", i18n("common_text_3471"), true, false)
		end
	end
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	local monthData = rechargeActivityCtrl:getMonthActivityList()
	local monthID = 11485
	if monthData and monthData[tostring(monthID)] and monthData[tostring(monthID)].isbuy then
		local monthSec = rechargeActivityCtrl:getRechargeLeftTime(monthID)
		if 0 < monthSec then
			local monthDays, leftTicket = SoraDConverSecondToDayAndHours(monthSec)
			if 1 <= monthDays then
				local leftDays = monthDays - 1
				local leftDaySecs = 0 < leftDays and NoticeModule.reFutureDayTheTime(leftDays) or 0
				local leftTimes = leftDaySecs + leftTicket
				SoraDAddNotice(leftTimes, "NOTIFICATION_LOCAL_RECHARGEWEEKLY_NOTICE", i18n("common_text_4181"), true, false)
			end
		end
	end
	if SoraDConfigGet("System:GameMessageView:Resource~bool") then
		local buildLogic = include("buildLogic")
		local harvestTime = buildLogic.getLongHarvestTime()
		if 0 < harvestTime then
			SoraDAddNotice(harvestTime, "NOTIFICATION_LOCAL_HARVESTTIME", i18n("common_text_1010"), true, false)
		end
	end
	SoraDAddNotice(NoticeModule.reFutureDayTheTime(3, 18), "NOTIFICATION_LOCAL_NOTICE_TREEDAY", i18n("common_text_1013"), true, false)
	SoraDAddNotice(NoticeModule.reFutureDayTheTime(7, 18), "NOTIFICATION_LOCAL_NOTICE_SEVENDAY", i18n("common_text_1015"), true, false)
	SoraDAddNotice(NoticeModule.reFutureDayTheTime(15, 18), "NOTIFICATION_LOCAL_NOTICE_FIFTEENDAY", i18n("common_text_1016"), true, false)
end
function NoticeModule.getContent(qid)
	_ENV, qid = tonumber(qid), tonumber(qid)
	tonumber(qid)[gQueueTypeDef.free_build_queue] = i18n("common_text_1001")
	tonumber(qid)[gQueueTypeDef.charge_build_queue] = i18n("common_text_1001")
	tonumber(qid)[gQueueTypeDef.chariot_plant_queue] = i18n("common_text_1002")
	tonumber(qid)[gQueueTypeDef.stables_queue] = i18n("common_text_1002")
	tonumber(qid)[gQueueTypeDef.range_queue] = i18n("common_text_1002")
	tonumber(qid)[gQueueTypeDef.barracks_queue] = i18n("common_text_1002")
	tonumber(qid)[gQueueTypeDef.frotress_queue] = i18n("common_text_1003")
	tonumber(qid)[gQueueTypeDef.elite_queue] = i18n("common_text_1002")
	tonumber(qid)[gQueueTypeDef.technology_upgrade_queue] = i18n("common_text_1004")
	tonumber(qid)[gQueueTypeDef.nebula_palace_technology] = i18n("common_text_1004")
	tonumber(qid)[gQueueTypeDef.war_tech_research] = i18n("common_text_1004")
	tonumber(qid)[gQueueTypeDef.time_reward] = i18n("common_text_997")
	tonumber(qid)[gQueueTypeDef.construction_drawing] = i18n("system_push_01")
	tonumber(qid)[gQueueTypeDef.build_star_queue] = i18n("Glory_text_38")
	local tonumber(qid)[gQueueTypeDef.glorious_upgrade], queueTypeList = i18n("Soldiers_armor_text_61"), tonumber(qid)
	local worldMapWarDef = include("worldMapWarDef")
	local hospitalQueues = worldMapWarDef.getHospitalQueues()
	for queueType, __ in pairs(hospitalQueues) do
		queueTypeList[queueType] = i18n("common_text_1005")
	end
	return queueTypeList[qid]
end
return NoticeModule
