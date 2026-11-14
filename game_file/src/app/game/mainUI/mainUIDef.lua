local _ENV, _ENV, mainUIDef
;(nil).head = 1000
;(nil).main = 1005
;(nil).animation = 1010
;(nil).text = 1020
;(nil).other = 1025
_ENV, mainUIDef.newGroupID, (nil).mainTop = nil, nil, 1035
;(nil).group_topText = 1101
;(nil).group_normal_view_1 = 2001
;(nil).group_normal_view_2 = 2002
_ENV, mainUIDef.uiGroupID, (nil).group_award_item = nil, nil, 2100
_ENV = nil
;(nil).msg = "MESSAGE_SULTANSBACK_WELCOME_REFRESH"
;(nil).onClick = function()
	SoraDCreatePanel("sultansBackWelBackView"):show()
end
;(nil)[gActivityTimeActivityID.SULTAN_BACK_WELCOME_ACTIVITY], (nil).sort = nil, 7
_ENV = nil
;(nil)[gActivityTimeActivityID.TRAIN_POWER_ACTIVITY], (nil).sort = nil, 12
_ENV = nil
;(nil).msg = "MESSAGE_LOST_RUINS_REFRESH"
;(nil).png = "btn_common_record.png"
;(nil).title = i18n("lost_ruins_text_23")
;(nil).showRed = function()
	local num = SoraDGetCtrl("lostRuinsCtrl"):getNewSurveyNum()
	return 0 < num, num
end
;(nil).extraCondition = function()
	local recordList = SoraDGetCtrl("lostRuinsCtrl"):getRecordList()
	return 0 < #recordList
end
;(nil).onClick = function()
	SoraDCreatePanel("lostRuinsRecordView"):show()
end
;(nil)[gActivityTimeActivityID.LOST_RUINS_ACTIVITY], (nil).sort = nil, 20
_ENV = nil
;(nil).msg = "MESSAGE_SNOWWOLF_LOST_REFRESH"
;(nil).png = "btn_common_record.png"
;(nil).title = i18n("lost_ruins_text_23")
;(nil).showRed = function()
	local num = SoraDGetCtrl("snowWolfLostCtrl"):getNewSurveyNum()
	return 0 < num, num
end
;(nil).extraCondition = function()
	local recordList = SoraDGetCtrl("snowWolfLostCtrl"):getRecordList()
	return not worldMapDefine.isInKingdomBattle() and 0 < #recordList
end
;(nil).onClick = function()
	uiManager:show("SnowWolfRecord")
end
;(nil)[gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY], (nil).sort = nil, 22
_ENV = nil
;(nil).sort = 24
;(nil)[gActivityTimeActivityID.ENJOY_LOTTERY], (nil).extraCondition = nil, function()
	return not worldMapDefine.isInRemains()
end
_ENV = nil
;(nil).extraCondition = function()
	return not worldMapDefine.inInCrossWar() and SoraDGetCastleLv() >= CASTLE_LV110_LIMITED
end
;(nil)[gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY], (nil).sort = nil, -1
_ENV = nil
;(nil).msg = "MESSAGE_NEBULAWAR_SCORE_REWARD_UPDATE"
;(nil).showRed = function()
	return SoraDGetCtrl("nebulaActivityCtrl"):getScoreStatusAndNum()
end
;(nil).extraCondition = function()
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	return clientEventMgr.nowEventStateList[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY] and nebulaActivityCtrl:isNebulaActivityOpen()
end
;(nil)[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY], (nil).sort = nil, 30
_ENV = nil
;(nil).msg = "MESSAGE_EXTREMELY_SKILLFUL_REFRESH"
;(nil).extraCondition = function()
	return SoraDGetCtrl("ExtremelySkillfulCtrl"):isActivityOpen()
end
;(nil)[gActivityTimeActivityID.EXTREMELY_SKILLFUIL], (nil).sort = nil, 3
_ENV = nil
;(nil).msg = "MESSAGE_NEBULA_EMPEROR_UI_BTN"
;(nil).extraCondition = function()
	return not worldMapDefine.inInCrossWar()
end
;(nil)[gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY], (nil).sort = nil, 35
_ENV = nil
;(nil).msg = "MESSAGE_LEGEND_OF_PEGASUS_REFRESH"
;(nil).png = "btn_common_record.png"
;(nil).title = i18n("lost_ruins_text_23")
;(nil).showRed = function()
	local num = SoraDGetCtrl("legendOfPegasusCtrl"):getNewSurveyNum()
	return 0 < num, num
end
;(nil).extraCondition = function()
	local recordList = SoraDGetCtrl("legendOfPegasusCtrl"):getRecordList()
	return not worldMapDefine.isInKingdomBattle() and 0 < #recordList
end
;(nil).onClick = function()
	uiManager:show("LegendOfPegasusRecord")
end
;(nil)[gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY], (nil).sort = nil, 22
_ENV = nil
;(nil).extraCondition = function()
	return SoraDGetCastleLv() >= CASTLE_LV6_LIMITED and not worldMapDefine.inInCrossWar()
end
;(nil)[gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY], (nil).sort = nil, -1
_ENV = nil
;(nil).msg = "MESSAGE_ACTIVITY_9001642_UPDATE"
;(nil).extraCondition = function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
	return allianceMgr:hasJoinAlliance() and activity_9001642_Ctrl:getPhoenixStatus() == 2
end
;(nil).remainTime = function()
	local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
	return activity_9001642_Ctrl:getPhoenixLeftTime()
end
;(nil).onClick = function()
	local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
	local mapObj = activity_9001642_Ctrl:getPhoenixObj()
	if mapObj and next(mapObj) then
		SoraDGotoWorldMapPoint(cc.p(mapObj.x, mapObj.y), true)
		SoraDRemoveAllPanelFromManager()
	end
end
;(nil)[gActivityTimeActivityID.PHOENIX_CHALLENGE], (nil).sort = nil, 49
_ENV = nil
;(nil).extraCondition = function()
	return not worldMapDefine.isInWar() or worldMapDefine.isInRoaringFlame()
end
;(nil).timelast = function()
	local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
	local curState = roaringFlameWarCtrl:getCurState()
	local timerLast
	if curState == ROARING_FLAME_WAR_STATE.MATCH then
		timerLast = "CombineServers_7"
	elseif curState == ROARING_FLAME_WAR_STATE.RESULT then
		timerLast = "flames_dunes_text2"
	elseif curState == ROARING_FLAME_WAR_STATE.BATTLE then
		timerLast = "common_text_4530"
	elseif curState == ROARING_FLAME_WAR_STATE.SETTLE then
		timerLast = "datepalm_tree_text53"
	end
	return timerLast
end
;(nil).remainTime = function()
	local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
	local curState = roaringFlameWarCtrl:getCurState()
	return roaringFlameWarCtrl:getStateRemainTime(curState)
end
;(nil)[gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY], (nil).sort = nil, 52
_ENV = nil
;(nil).msg = "MESSAGE_FIREDRAGON_OF_ANGER_REFRESH"
;(nil).png = "btn_common_record.png"
;(nil).title = i18n("lost_ruins_text_23")
;(nil).showRed = function()
	local num = SoraDGetCtrl("activity_9001602_Ctrl"):getNewSurveyNum()
	return 0 < num, num
end
;(nil).extraCondition = function()
	local recordList = SoraDGetCtrl("activity_9001602_Ctrl"):getRecordList()
	return not worldMapDefine.isInKingdomBattle() and 0 < #recordList
end
;(nil).onClick = function()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001602
	uiManager:show("Activity_9001602_Record", nil)
end
;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602], (nil).sort = nil, 22
_ENV = nil
;(nil).msg = "MESSAGE_FIREDRAGON_OF_ANGER_REFRESH"
;(nil).png = "btn_common_record.png"
;(nil).title = i18n("lost_ruins_text_23")
;(nil).showRed = function()
	local num = SoraDGetCtrl("activity_9001696_Ctrl"):getNewSurveyNum()
	return 0 < num, num
end
;(nil).extraCondition = function()
	local recordList = SoraDGetCtrl("activity_9001696_Ctrl"):getRecordList()
	return not worldMapDefine.isInKingdomBattle() and 0 < #recordList
end
;(nil).onClick = function()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
	uiManager:show("Activity_9001602_Record", nil)
end
;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], (nil).sort = nil, 22
_ENV = nil
;(nil).extraCondition = function()
	return SoraDGetCastleLv() >= CASTLE_LV6_LIMITED
end
;(nil)[gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY], (nil).sort = nil, 47
_ENV = nil
;(nil).extraCondition = function()
	return SoraDGetCastleLv() >= CASTLE_LV6_LIMITED
end
;(nil)[gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY], (nil).sort = nil, 54
_ENV = nil
;(nil).showRed = function()
	local ret = SoraDGetCtrl("activity_9001700_Ctrl"):getLetOffRedNum()
	return ret, 1
end
;(nil).onClick = function()
	local activity_9001700_Read = include("activity_9001700_Read")
	activity_9001700_Read.singleClickEvent()
end
;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001700], (nil).sort = nil, 55
_ENV = nil
;(nil).msg = "MESSAGE_ACTIVITY_9001717_UPDATE"
;(nil).extraCondition = function()
	return SoraDGetCtrl("activity_9001717_Ctrl"):checkPartyTime()
end
;(nil).remainTime = function()
	return SoraDGetCtrl("activity_9001717_Ctrl"):getPartyRemainTime()
end
;(nil)[gActivityTimeActivityID.FANTASY_LAND], (nil).sort = nil, 56
_ENV = nil
;(nil).hideTime = true
;(nil)[gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY], (nil).sort = nil, 33
_ENV = nil
;(nil)[gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708], (nil).sort = nil, 56
_ENV = nil
mainUIDef.activityCfg, (nil)[gActivityTimeActivityID.KOH_MIGRATE_HELP_9001709], (nil).sort = nil, nil, 57
return mainUIDef
