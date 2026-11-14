clientEventMgr, _ENV = nil, nil
function clientEventMgr.initialize()
	clientEventMgr.nowEventStateList, _ENV = nil, nil
	local addNormalEvent_new = function(activityID, classtype, noPage)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(activityID)
		local _classtype = classtype or param.classtype
		if noPage == nil and not activityTimeRead.getActivityBgShow(activityID, _classtype) then
			noPage = true
		end
		if not clientEventMgr.checkStartLvLimit(activityID) then
			return
		end
		if not clientEventMgr.checkBuildTypeLimit(activityID) then
			return
		end
		if activityTimeRead.checkActivityShowLevel(activityID) then
			_ENV = activityID
			activityID.eid = activityID
			activityID.name = i18n(activityTimeRead.getActivityNameByID(activityID, _classtype))
			activityID.icon = activityTimeRead.getActivityIconByID(activityID, _classtype)
			activityID.bg = activityTimeRead.getActivityBgByID(activityID, _classtype)
			activityID.noPage = noPage
			return clientEventMgr.addNormalEvent(activityID)
		end
	end
	_ENV = nil
	;(nil)[gActivityCenterUIEnum.KINGDOM_BATTLE] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		if conquestWarCtrl:getConquestWarState() ~= gConquestWarState.LOCK then
			_ENV = conquestWarCtrl:getConquestWarState()
			_ENV, conquestWarCtrl:getConquestWarState().eventID = gActivityCenterUIEnum.KINGDOM_BATTLE, gActivityCenterUIEnum.KINGDOM_BATTLE
			gActivityCenterUIEnum.KINGDOM_BATTLE.timeType = "showMsg"
			conquestWarCtrl:getConquestWarState().eventLeftTime, gActivityCenterUIEnum.KINGDOM_BATTLE.timerMsg = gActivityCenterUIEnum.KINGDOM_BATTLE, i18n("common_text_2184")
			conquestWarCtrl:getConquestWarState().eventState = gActivityState.OPEN
			conquestWarCtrl:getConquestWarState().eventName = i18n("common_text_2182")
			conquestWarCtrl:getConquestWarState().eventDes = i18n("common_text_2184")
			conquestWarCtrl:getConquestWarState().flagIcon = "icon_activity_kingdomcontend.png"
			conquestWarCtrl:getConquestWarState().pageBg = "bg_kingwawr_01.png"
			return (conquestWarCtrl:getConquestWarState())
		end
	end
	;(nil)[gActivityTimeActivityID.RUINS_WAR] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local activityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.RUINS_WAR)
		if gActivityState.OPEN == activityStatus then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RUINS_WAR)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.RUINS_WAR, _eventTime.timerNode.timer:getRemainTime())
			local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
			local seasonTitle = remainsTeamCtrl:getActivitySeasonTitle()
			local seasonTime = remainsTeamCtrl:getActivitySeasonTime()
			_ENV = remainsTeamCtrl
			remainsTeamCtrl.eventID = gActivityTimeActivityID.RUINS_WAR
			_ENV, remainsTeamCtrl.eventState = gActivityTimeActivityID.RUINS_WAR, activityStatus
			gActivityTimeActivityID.RUINS_WAR.timeType = "showMsg"
			remainsTeamCtrl.eventLeftTime, gActivityTimeActivityID.RUINS_WAR.timerMsg = gActivityTimeActivityID.RUINS_WAR, seasonTitle
			remainsTeamCtrl.eventName = i18n("activityname_23")
			remainsTeamCtrl.eventDes = seasonTime
			remainsTeamCtrl.flagIcon = "icon_activity_9001091.png"
			remainsTeamCtrl.pageBg = "bg_activity_yyzz.png"
			return remainsTeamCtrl
		end
	end
	;(nil)[gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local activityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
		if gActivityState.OPEN == activityStatus then
			local radianceWarUtil = include("radianceWarUtil")
			local _eventTime = radianceWarUtil.getWarStatusTime()
			clientEventMgr.addEventTimer(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY, _eventTime)
			local _eventStr = radianceWarUtil.getWarStatusTimeStr()
			local eventLeftTime
			if radianceWarUtil.isWarFinish() then
				activityStatus = gActivityState.CALCULATE
			end
			_ENV = gActivityState
			gActivityState.timeType = "showTime"
			_ENV, eventLeftTime, gActivityState.timerLast = gActivityState, gActivityState, _eventStr
			gActivityState.eventID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
			gActivityState.eventState = activityStatus
			gActivityState.eventLeftTime = eventLeftTime
			gActivityState.eventName = i18n("brightWar_text_21")
			gActivityState.eventDes = i18n("brightWar_text_21")
			gActivityState.flagIcon = "icon_activity_radiance.png"
			gActivityState.pageBg = "bg_activity_9001253.png"
			return gActivityState
		end
	end
	;(nil)[gActivityCenterUIEnum.PYRAMID_BATTLE] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		if not isInConquestWar and cityCtrl:getBuildMaxLv(BUILDID.CASTLE) >= CASTLE_LV15_LIMITED then
			local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
			if pyramidWarCtrl.pyramidWarOpenState == gPyramidWarOpenState.OPEN then
				local pyramidClientModule = include("pyramidClientModule")
				if pyramidWarCtrl.regularSeasonState ~= gRegularSeasonState.NOT_OPEN and pyramidWarCtrl.regularSeasonState ~= gRegularSeasonState.FINISH then
					local _des, _ticket = pyramidClientModule.getDesFromState()
					if _ticket then
						local timeFactory = function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
						clientEventMgr.addEventTimer(gActivityCenterUIEnum.PYRAMID_BATTLE, _ticket)
						_ENV = clientEventMgr.addEventTimer
						_ENV, clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.PYRAMID_BATTLE, gActivityCenterUIEnum.PYRAMID_BATTLE
						gActivityCenterUIEnum.PYRAMID_BATTLE.timeType = "showTime"
						clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE.timerFun = gActivityCenterUIEnum.PYRAMID_BATTLE, timeFactory
						clientEventMgr.addEventTimer.eventState = gActivityState.OPEN
						clientEventMgr.addEventTimer.eventName = i18n("common_text_2517")
						clientEventMgr.addEventTimer.eventDes = i18n("common_text_2517")
						clientEventMgr.addEventTimer.flagIcon = "icon_activity_show_pyramid.png"
						clientEventMgr.addEventTimer.pageBg = "bg_activity_battlefield_pyramid.png"
						return clientEventMgr.addEventTimer
					else
						function _ENV(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
						_ENV, (function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventID = gActivityCenterUIEnum.PYRAMID_BATTLE, gActivityCenterUIEnum.PYRAMID_BATTLE
						gActivityCenterUIEnum.PYRAMID_BATTLE.timeType = "showMsg"
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE.timerMsg = gActivityCenterUIEnum.PYRAMID_BATTLE, i18n(_des)
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventState = gActivityState.OPEN
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventName = i18n("common_text_2517")
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventDes = i18n("common_text_2517")
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).flagIcon = "icon_activity_show_pyramid.png"
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).pageBg = "bg_activity_battlefield_pyramid.png"
						return function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
					end
				elseif pyramidWarCtrl.pinnacleSeasonState ~= gPinnacleSeasonState.NOT_OPEN and pyramidWarCtrl.pinnacleSeasonState ~= gPinnacleSeasonState.FINISH then
					local _des, _adDes, _ticket = pyramidClientModule.getDesFromPostSeasonState()
					if _des ~= "" then
						if _adDes ~= "" then
							local timeFactory = function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des) .. "\n" .. i18n(_adDes, nil)
							end
							clientEventMgr.addEventTimer(gActivityCenterUIEnum.PYRAMID_BATTLE, _ticket)
							_ENV = clientEventMgr.addEventTimer
							_ENV, clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.PYRAMID_BATTLE, gActivityCenterUIEnum.PYRAMID_BATTLE
							gActivityCenterUIEnum.PYRAMID_BATTLE.timeType = "showTime"
							clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE.timerFun = gActivityCenterUIEnum.PYRAMID_BATTLE, timeFactory
							clientEventMgr.addEventTimer.eventState = gActivityState.OPEN
							clientEventMgr.addEventTimer.eventName = i18n("common_text_3301")
							clientEventMgr.addEventTimer.eventDes = i18n("common_text_3301")
							clientEventMgr.addEventTimer.flagIcon = "icon_activity_show_pyramid.png"
							clientEventMgr.addEventTimer.pageBg = "bg_activity_battlefield_pyramid.png"
							return clientEventMgr.addEventTimer
						elseif _ticket then
							local timeFactory = function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end
							clientEventMgr.addEventTimer(gActivityCenterUIEnum.PYRAMID_BATTLE, _ticket)
							_ENV = clientEventMgr.addEventTimer
							_ENV, clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.PYRAMID_BATTLE, gActivityCenterUIEnum.PYRAMID_BATTLE
							gActivityCenterUIEnum.PYRAMID_BATTLE.timeType = "showTime"
							clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE.timerFun = gActivityCenterUIEnum.PYRAMID_BATTLE, timeFactory
							clientEventMgr.addEventTimer.eventState = gActivityState.OPEN
							clientEventMgr.addEventTimer.eventName = i18n("common_text_3301")
							clientEventMgr.addEventTimer.eventDes = i18n("common_text_3301")
							clientEventMgr.addEventTimer.flagIcon = "icon_activity_show_pyramid.png"
							clientEventMgr.addEventTimer.pageBg = "bg_activity_battlefield_pyramid.png"
							return clientEventMgr.addEventTimer
						else
							function _ENV(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end
							_ENV, (function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end).eventID = gActivityCenterUIEnum.PYRAMID_BATTLE, gActivityCenterUIEnum.PYRAMID_BATTLE
							gActivityCenterUIEnum.PYRAMID_BATTLE.timeType = "showMsg"
							;(function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end).eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE.timerMsg = gActivityCenterUIEnum.PYRAMID_BATTLE, _des == "" and _des or i18n(_des)
							;(function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end).eventState = gActivityState.OPEN
							;(function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end).eventName = i18n("common_text_3301")
							;(function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end).eventDes = i18n("common_text_3301")
							;(function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end).flagIcon = "icon_activity_show_pyramid.png"
							;(function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end).pageBg = "bg_activity_battlefield_pyramid.png"
							return function(ticket)
								_ENV = nil
								;(nil).time = ticket
								return i18n(_des, nil)
							end
						end
					else
						function _ENV(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
						_ENV, (function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventID = gActivityCenterUIEnum.PYRAMID_BATTLE, gActivityCenterUIEnum.PYRAMID_BATTLE
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE.timeType = gActivityCenterUIEnum.PYRAMID_BATTLE, "noMsg"
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventState = gActivityState.OPEN
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventName = i18n("common_text_3301")
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventDes = i18n("common_text_3301")
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).flagIcon = "icon_activity_show_pyramid.png"
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).pageBg = "bg_activity_battlefield_pyramid.png"
						return function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
					end
				end
			end
		end
	end
	;(nil)[gActivityCenterUIEnum.PYRAMID_BATTLE_PBL] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		print("gActivityCenterUIEnum.PYRAMID_BATTLE_PBL111", isInConquestWar)
		if not isInConquestWar and cityCtrl:getBuildMaxLv(BUILDID.CASTLE) >= CASTLE_LV15_LIMITED then
			local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
			print("gActivityCenterUIEnum.PYRAMID_BATTLE_PBL 222", pyramidWarCtrl.pyramidWarOpenState)
			if pyramidWarCtrl.pyramidWarOpenState == gPyramidWarOpenState.OPEN then
				local pyramidClientModule = include("pyramidClientModule")
				print("gActivityCenterUIEnum.PYRAMID_BATTLE_PBL 333", pyramidWarCtrl.pinnacleSeasonState)
				if pyramidWarCtrl.pinnacleSeasonState ~= gPinnacleSeasonState.NOT_OPEN and pyramidWarCtrl.pinnacleSeasonState ~= gPinnacleSeasonState.NOT_OPEN_OLD then
					if pyramidWarCtrl.pinnacleSeasonState == gPinnacleSeasonState.WAIT_OPEN then
						local nowTimeLeft = pyramidWarCtrl:getLeftTime(pyramidWarCtrl.pinnacleSeasonState)
						if nowTimeLeft and 604800 < nowTimeLeft then
							return
						end
					end
					local _des, _ticket = pyramidClientModule.getDesFromPostSeasonState()
					print("gActivityCenterUIEnum.PYRAMID_BATTLE_PBL 444", _ticket)
					if _ticket then
						local timeFactory = function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
						clientEventMgr.addEventTimer(gActivityCenterUIEnum.PYRAMID_BATTLE_PBL, _ticket)
						_ENV = clientEventMgr.addEventTimer
						_ENV, clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.PYRAMID_BATTLE_PBL, gActivityCenterUIEnum.PYRAMID_BATTLE_PBL
						gActivityCenterUIEnum.PYRAMID_BATTLE_PBL.timeType = "showTime"
						clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE_PBL.timerFun = gActivityCenterUIEnum.PYRAMID_BATTLE_PBL, timeFactory
						clientEventMgr.addEventTimer.eventState = gActivityState.OPEN
						clientEventMgr.addEventTimer.eventName = i18n("mail_pyramid_05")
						clientEventMgr.addEventTimer.eventDes = i18n("mail_pyramid_05")
						clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001254.png"
						clientEventMgr.addEventTimer.pageBg = "bg_activity_9001254.png"
						return clientEventMgr.addEventTimer
					else
						function _ENV(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
						_ENV, (function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventID = gActivityCenterUIEnum.PYRAMID_BATTLE_PBL, gActivityCenterUIEnum.PYRAMID_BATTLE_PBL
						gActivityCenterUIEnum.PYRAMID_BATTLE_PBL.timeType = "showMsg"
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventLeftTime, gActivityCenterUIEnum.PYRAMID_BATTLE_PBL.timerMsg = gActivityCenterUIEnum.PYRAMID_BATTLE_PBL, i18n(_des)
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventState = gActivityState.OPEN
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventName = i18n("mail_pyramid_05")
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).eventDes = i18n("mail_pyramid_05")
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).flagIcon = "icon_activity_9001254.png"
						;(function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end).pageBg = "bg_activity_9001254.png"
						return function(ticket)
							_ENV = nil
							;(nil).time = ticket
							return i18n(_des, nil)
						end
					end
				end
			end
		end
	end
	;(nil)[gActivityCenterUIEnum.STRONGEST_LORD] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityCtrl = gametop.playertop_:getModule("activityCtrl")
		local kingsOrderTimer = activityCtrl:queryQueue(activityCtrl.activityState)
		local kingsOrderState = activityCtrl.activityState
		if gActivityState.OPEN == kingsOrderState then
			local kingsOrderRead = include("kingsOrderRead")
			_ENV = nil
			;(nil).cur = activityCtrl.curStage
			;(nil).max = activityCtrl.totalStage
			;(nil).name = i18n(kingsOrderRead.getSectionName(activityCtrl.curActivityID))
			local kingsOrderDes = i18n("common_text_628", nil)
			_ENV = "common_text_628"
			;("common_text_628").eventID = gActivityCenterUIEnum.STRONGEST_LORD
			_ENV, ("common_text_628").eventState = gActivityCenterUIEnum.STRONGEST_LORD, kingsOrderState
			gActivityCenterUIEnum.STRONGEST_LORD.timeType = "showMsg"
			;("common_text_628").eventLeftTime, gActivityCenterUIEnum.STRONGEST_LORD.timerMsg = gActivityCenterUIEnum.STRONGEST_LORD, kingsOrderDes
			;("common_text_628").eventName = i18n("common_text_605")
			;("common_text_628").eventDes = kingsOrderDes
			;("common_text_628").flagIcon = "icon_activity_match.png"
			;("common_text_628").pageBg = "bg_activity_03.png"
			return "common_text_628"
		elseif gActivityState.PREPARE == kingsOrderState or gActivityState.CLOSE == kingsOrderState then
			clientEventMgr.addEventTimer(gActivityCenterUIEnum.STRONGEST_LORD, kingsOrderTimer and kingsOrderTimer.timerNode.timer:getRemainTime() or 0)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.STRONGEST_LORD
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityCenterUIEnum.STRONGEST_LORD, kingsOrderState
			gActivityCenterUIEnum.STRONGEST_LORD.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.STRONGEST_LORD.timerLast = gActivityCenterUIEnum.STRONGEST_LORD, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("common_text_605")
			clientEventMgr.addEventTimer.eventDes = i18n("common_text_608")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_match.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_03.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityCenterUIEnum.ROME_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		local mainTimer = romeActivityCtrl:queryQueue(romeActivityCtrl.activityState)
		if mainTimer then
			local romanTimeLast = "common_text_606"
			local romanState = gActivityState.CLOSE
			if gRomeActivityState.OPEN == romeActivityCtrl.activityState then
				romanTimeLast = "common_text_607"
				romanState = gActivityState.OPEN
			end
			clientEventMgr.addEventTimer(gActivityCenterUIEnum.ROME_ACTIVITY, mainTimer.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.ROME_ACTIVITY
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityCenterUIEnum.ROME_ACTIVITY, romanState
			gActivityCenterUIEnum.ROME_ACTIVITY.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.ROME_ACTIVITY.timerLast = gActivityCenterUIEnum.ROME_ACTIVITY, romanTimeLast
			clientEventMgr.addEventTimer.eventName = i18n("common_text_1222")
			clientEventMgr.addEventTimer.eventDes = i18n("common_text_1220")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_Roman.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_roman.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityCenterUIEnum.HERO_TRIAL] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		if activityTimeRead.checkActivityShowLevel(activityID) then
			_ENV = activityTimeRead.checkActivityShowLevel(activityID)
			_ENV, activityTimeRead.checkActivityShowLevel(activityID).eventID = gActivityCenterUIEnum.HERO_TRIAL, gActivityCenterUIEnum.HERO_TRIAL
			activityTimeRead.checkActivityShowLevel(activityID).eventLeftTime, gActivityCenterUIEnum.HERO_TRIAL.timeType = gActivityCenterUIEnum.HERO_TRIAL, "noMsg"
			activityTimeRead.checkActivityShowLevel(activityID).eventState = gActivityState.OPEN
			activityTimeRead.checkActivityShowLevel(activityID).eventName = i18n("common_text_1697")
			activityTimeRead.checkActivityShowLevel(activityID).eventDes = i18n("common_text_1701")
			activityTimeRead.checkActivityShowLevel(activityID).flagIcon = "icon_activity_herotrial.png"
			activityTimeRead.checkActivityShowLevel(activityID).pageBg = "bg_activity_herotrial_01.png"
			return (activityTimeRead.checkActivityShowLevel(activityID))
		end
	end
	;(nil)[gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local _eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND)
		local _eventLast = clientEventMgr.judgeIsOnlyOpenOnShow(_eventState)
		if _eventLast and not commonCheck.CLOSE_SETTING_INVITE then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND, _eventState
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND.timeType = gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND, "noMsg"
			clientEventMgr.addEventTimer.eventName = i18n("mail_title_11")
			clientEventMgr.addEventTimer.eventDes = i18n("invite_text_01")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_show_9001084.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_show_9001084.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY
		;(nil).name = i18n("activity_name_25")
		;(nil).des = i18n("activity_name_25")
		;(nil).icon = "icon_activity_9001149.png"
		;(nil).bg = "bg_activity_9001149.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.FULL_DAY_SPRINT_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.FULL_DAY_SPRINT_ACTIVITY
		;(nil).name = i18n("spice_name_08")
		;(nil).des = i18n("common_text_3778")
		;(nil).icon = "icon_activity_9001115.png"
		;(nil).bg = "bg_activity_9001115.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.GEOCENTRIC_EXPLORATION] = function()
		local activity_9001649_Read = include("activity_9001649_Read")
		local bgName = activity_9001649_Read.getBannerName()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
		;(nil).name = i18n("activity_name_9001649")
		;(nil).des = i18n("activity_name_9001649")
		;(nil).icon = "icon_activity_9001649.png"
		;(nil).bg = bgName
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.LOGIN_GIFT] = function()
		local img = SoraDFIsRA() and "bg_activity_show_9001130_ar.png" or "bg_activity_show_9001130_en.png"
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.LOGIN_GIFT
		;(nil).name = i18n("login_name_01")
		;(nil).des = i18n("login_name_01")
		;(nil).icon = "icon_activity_9001130.png"
		;(nil).bg = img
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.EXPEDITON] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.EXPEDITON
		;(nil).name = i18n("activityname_9001133")
		;(nil).des = i18n("activityname_9001133")
		;(nil).icon = "icon_activity_9001133.png"
		;(nil).bg = "bg_activity_9001133.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
		local allianceMobState = activityShowCtrl:getStateByID(gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY)
		local playerMobilizationStatus = playerMobilizationCtrl:getActivityStatus()
		if allianceMobState == gActivityState.OPEN and (playerMobilizationStatus.status == gMobilizationActivityStatus.ACTIVITY_PREPAREING or playerMobilizationStatus.status == gMobilizationActivityStatus.ACTIVITY_OPEN) then
			local leftTime
			local playerState = gActivityState.OPEN
			local timerLast = "common_text_606"
			if playerMobilizationStatus.status == gMobilizationActivityStatus.ACTIVITY_PREPAREING then
				leftTime = playerMobilizationStatus.preparetime
				playerState = gActivityState.PREPARE
				timerLast = "common_text_606"
			elseif playerMobilizationStatus.status == gMobilizationActivityStatus.ACTIVITY_OPEN then
				leftTime = playerMobilizationStatus.calculatetime
				playerState = gActivityState.OPEN
				timerLast = "common_text_607"
			end
			clientEventMgr.addEventTimer(gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY, leftTime - serviceFunctions.systemTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY, playerState
			gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY.timerLast = gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY, timerLast
			clientEventMgr.addEventTimer.eventName = i18n("mail_text_417")
			clientEventMgr.addEventTimer.eventDes = i18n("mail_text_417")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_show_9000058.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_show_9000058.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.MONSTERPALACE_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		if activityTimeRead.checkActivityShowLevel(activityID) then
			local gametop = gModuleMgr.getObject("gametop")
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			local monsterpalaceCtrl = gametop.playertop_:getModule("monsterpalaceCtrl")
			local monsterpalaceStatus = monsterpalaceCtrl:getActivityStatus()
			local elitestatus, elitetime = monsterpalaceCtrl:getEliteChallengeStatus()
			local monsterpalaceState = activityShowCtrl:getStateByID(gActivityTimeActivityID.MONSTERPALACE_ACTIVITY)
			local monsterpalaceTimeLast = clientEventMgr.judgeIsOnShow(monsterpalaceState)
			local maintimer = monsterpalaceCtrl:getEliteQueuetimer()
			if monsterpalaceStatus and maintimer then
				if elitestatus == MONSTERPALACE_ELITE_STATUS_OPEN then
					clientEventMgr.addEventTimer(gActivityTimeActivityID.MONSTERPALACE_ACTIVITY, maintimer.timerNode.timer:getRemainTime())
					_ENV = clientEventMgr.addEventTimer
					clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.MONSTERPALACE_ACTIVITY
					_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.MONSTERPALACE_ACTIVITY, monsterpalaceState
					gActivityTimeActivityID.MONSTERPALACE_ACTIVITY.timeType = "showTime"
					clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.MONSTERPALACE_ACTIVITY.timerLast = gActivityTimeActivityID.MONSTERPALACE_ACTIVITY, "common_text_3264"
					clientEventMgr.addEventTimer.eventName = i18n("common_text_3263")
					clientEventMgr.addEventTimer.eventDes = i18n("common_text_3263")
					clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001040.png"
					clientEventMgr.addEventTimer.pageBg = "bg_activity_9001040.png"
					return clientEventMgr.addEventTimer
				elseif elitestatus == MONSTERPALACE_ELITE_STATUS_CLOSE then
					clientEventMgr.addEventTimer(gActivityTimeActivityID.MONSTERPALACE_ACTIVITY, maintimer.timerNode.timer:getRemainTime())
					_ENV = clientEventMgr.addEventTimer
					clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.MONSTERPALACE_ACTIVITY
					_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.MONSTERPALACE_ACTIVITY, monsterpalaceState
					gActivityTimeActivityID.MONSTERPALACE_ACTIVITY.timeType = "showTime"
					clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.MONSTERPALACE_ACTIVITY.timerLast = gActivityTimeActivityID.MONSTERPALACE_ACTIVITY, "common_text_3265"
					clientEventMgr.addEventTimer.eventName = i18n("common_text_3263")
					clientEventMgr.addEventTimer.eventDes = i18n("common_text_3263")
					clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001040.png"
					clientEventMgr.addEventTimer.pageBg = "bg_activity_9001040.png"
					return clientEventMgr.addEventTimer
				end
			end
		end
	end
	;(nil)[gActivityTimeActivityID.RECRUITMENT_MATERIALS] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local noviceGiftCtrl = gametop.playertop_:getModule("noviceGiftCtrl")
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local recruitmentState = activityShowCtrl:getStateByID(gActivityTimeActivityID.RECRUITMENT_MATERIALS)
		if noviceGiftCtrl:getIsEnd() then
			_ENV = noviceGiftCtrl:getIsEnd()
			_ENV, noviceGiftCtrl:getIsEnd().eventID = gActivityTimeActivityID.RECRUITMENT_MATERIALS, gActivityTimeActivityID.RECRUITMENT_MATERIALS
			noviceGiftCtrl:getIsEnd().eventLeftTime, gActivityTimeActivityID.RECRUITMENT_MATERIALS.timeType = gActivityTimeActivityID.RECRUITMENT_MATERIALS, "noMsg"
			noviceGiftCtrl:getIsEnd().eventName = i18n("activity_name_9001158")
			noviceGiftCtrl:getIsEnd().eventDes = i18n("activity_name_9001158")
			noviceGiftCtrl:getIsEnd().flagIcon = "icon_activity_9001158.png"
			noviceGiftCtrl:getIsEnd().pageBg = SoraDFIsRA() and "bg_activity_9001158_ar.png" or "bg_activity_9001158_en.png"
			return (noviceGiftCtrl:getIsEnd())
		end
	end
	;(nil)[gActivityTimeActivityID.OUTS_STANDINGS] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.OUTS_STANDINGS
		;(nil).name = i18n("activity_name_9001157")
		;(nil).des = i18n("activity_name_9001157")
		;(nil).icon = "icon_activity_9001157.png"
		;(nil).bg = "bg_activity_9001157.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.GROWUPFUND] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local growupFundCtrl = gametop.playertop_:getModule("growupFundCtrl")
		local growUpMoneyState = activityShowCtrl:getStateByID(gActivityTimeActivityID.GROWUPFUND)
		local growUpMoneyTimeLast = clientEventMgr.judgeIsOnShow(growUpMoneyState)
		if activityShowCtrl:isShowGropupFundPage() then
			local isShowGropupFundTime = activityShowCtrl:isShowGropupFundTime()
			local growUpMoneyTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GROWUPFUND)
			local isBuy = growupFundCtrl:isAlreadyBuy()
			local allReceive = growupFundCtrl:getAllReceive()
			if isBuy and not allReceive then
				if isShowGropupFundTime then
					clientEventMgr.addEventTimer(gActivityTimeActivityID.GROWUPFUND, growUpMoneyTime.timerNode.timer:getRemainTime())
					_ENV = clientEventMgr.addEventTimer
					clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.GROWUPFUND
					_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.GROWUPFUND, growUpMoneyState
					gActivityTimeActivityID.GROWUPFUND.timeType = "showTime"
					clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.GROWUPFUND.timerLast = gActivityTimeActivityID.GROWUPFUND, growUpMoneyTimeLast
					clientEventMgr.addEventTimer.eventName = i18n("common_text_2560")
					clientEventMgr.addEventTimer.eventDes = i18n("common_text_2561")
					clientEventMgr.addEventTimer.flagIcon = "icon_activity_growup.png"
					clientEventMgr.addEventTimer.pageBg = "bg_growUp_01.png"
					return clientEventMgr.addEventTimer
				else
					_ENV = clientEventMgr.addEventTimer
					clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.GROWUPFUND
					_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.GROWUPFUND, growUpMoneyState
					clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.GROWUPFUND.timeType = gActivityTimeActivityID.GROWUPFUND, "noMsg"
					clientEventMgr.addEventTimer.eventName = i18n("common_text_2560")
					clientEventMgr.addEventTimer.eventDes = i18n("common_text_2561")
					clientEventMgr.addEventTimer.flagIcon = "icon_activity_growup.png"
					clientEventMgr.addEventTimer.pageBg = "bg_growUp_01.png"
					return clientEventMgr.addEventTimer
				end
			end
		end
	end
	;(nil)[gActivityTimeActivityID.VALUE_REBATE_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local rebateState = activityShowCtrl:getStateByID(gActivityTimeActivityID.VALUE_REBATE_ACTIVITY)
		local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
		if ladderGiftCtrl:getGrowUpHasEnter() then
			_ENV = ladderGiftCtrl:getGrowUpHasEnter()
			_ENV, ladderGiftCtrl:getGrowUpHasEnter().eventID = gActivityTimeActivityID.VALUE_REBATE_ACTIVITY, gActivityTimeActivityID.VALUE_REBATE_ACTIVITY
			ladderGiftCtrl:getGrowUpHasEnter().eventLeftTime, gActivityTimeActivityID.VALUE_REBATE_ACTIVITY.timeType = gActivityTimeActivityID.VALUE_REBATE_ACTIVITY, "noMsg"
			ladderGiftCtrl:getGrowUpHasEnter().eventState = rebateState
			ladderGiftCtrl:getGrowUpHasEnter().eventName = i18n("activity_name_26")
			ladderGiftCtrl:getGrowUpHasEnter().eventDes = i18n("activity_name_26")
			ladderGiftCtrl:getGrowUpHasEnter().flagIcon = "icon_activity_growup.png"
			ladderGiftCtrl:getGrowUpHasEnter().pageBg = "bg_growUp_01.png"
			return (ladderGiftCtrl:getGrowUpHasEnter())
		end
	end
	;(nil)[gActivityCenterUIEnum.SURPRISED_DROP] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getSurprisedDropState()
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		if activityShowCtrl:isSurprisedDropOpenOrPrepare() then
			clientEventMgr.addEventTimer(gActivityCenterUIEnum.SURPRISED_DROP, activityShowCtrl:getSurprisedDropTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.SURPRISED_DROP
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityCenterUIEnum.SURPRISED_DROP, state
			gActivityCenterUIEnum.SURPRISED_DROP.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.SURPRISED_DROP.timerLast = gActivityCenterUIEnum.SURPRISED_DROP, timeLast
			clientEventMgr.addEventTimer.eventName = i18n("common_text_3530")
			clientEventMgr.addEventTimer.eventDes = i18n("common_text_3530")
			clientEventMgr.addEventTimer.flagIcon = "icon_amazingDrop_01.png"
			clientEventMgr.addEventTimer.pageBg = "bg_amazingDrop_01.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityCenterUIEnum.SNOW_DROP] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getSnowDropState()
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		if state == gActivityState.OPEN then
			clientEventMgr.addEventTimer(gActivityCenterUIEnum.SNOW_DROP, activityShowCtrl:getSnowDropTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.SNOW_DROP
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityCenterUIEnum.SNOW_DROP, state
			gActivityCenterUIEnum.SNOW_DROP.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.SNOW_DROP.timerLast = gActivityCenterUIEnum.SNOW_DROP, timeLast
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001579")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001579")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001579.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001579.png"
			return clientEventMgr.addEventTimer
		elseif state == gActivityState.PREPARE then
			_ENV = gActivityState.PREPARE
			gActivityState.PREPARE.eventID = gActivityCenterUIEnum.SNOW_DROP
			_ENV, gActivityState.PREPARE.eventState = gActivityCenterUIEnum.SNOW_DROP, state
			gActivityCenterUIEnum.SNOW_DROP.timeType = "showMsg"
			gActivityState.PREPARE.eventLeftTime, gActivityCenterUIEnum.SNOW_DROP.timerMsg = gActivityCenterUIEnum.SNOW_DROP, i18n("common_text_608")
			gActivityState.PREPARE.eventName = i18n("activity_name_9001579")
			gActivityState.PREPARE.eventDes = i18n("activity_name_9001579")
			gActivityState.PREPARE.flagIcon = "icon_activity_9001579.png"
			gActivityState.PREPARE.pageBg = "bg_activity_9001579.png"
			return gActivityState.PREPARE
		end
	end
	;(nil)[gActivityCenterUIEnum.CRAZY_DROP] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getCrazyDropState()
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		if activityShowCtrl:isCrazyDropOpenOrPrepare() then
			clientEventMgr.addEventTimer(gActivityCenterUIEnum.CRAZY_DROP, activityShowCtrl:getCrazyDropTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.CRAZY_DROP
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityCenterUIEnum.CRAZY_DROP, state
			gActivityCenterUIEnum.CRAZY_DROP.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityCenterUIEnum.CRAZY_DROP.timerLast = gActivityCenterUIEnum.CRAZY_DROP, timeLast
			clientEventMgr.addEventTimer.eventName = i18n("drop_name_01")
			clientEventMgr.addEventTimer.eventDes = i18n("drop_name_01")
			clientEventMgr.addEventTimer.flagIcon = "icon_amazingDrop_01.png"
			clientEventMgr.addEventTimer.pageBg = "bg_amazingDrop_01.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY] = function()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local cumuActiveCtrl = SoraDGetCtrl("cumuActiveCtrl")
		local rechargeltCtrl = include("rechargeltCtrl")
		local crazyData = cumuActiveCtrl:getCrazyTrioData()
		local state = activityShowCtrl:getStateByID(gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY)
		if not crazyData.receive then
			_ENV = crazyData.receive
		end
		local receiveAll = table.nums(crazyData.receive) == rechargeltCtrl.getRechargeTotalConfigNum()
		if activityShowCtrl:isActivityOpen(gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY) and not receiveAll then
			local _ENV, bgName = activityShowCtrl, SoraDFIsRA() and "bg_activity_zzkr_a.png" or userSDKManager.isKO() and "bg_activity_zzkr_ko.png" or "bg_activity_zzkr_en.png"
			_ENV, activityShowCtrl.eventID = gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY, gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY
			activityShowCtrl.eventLeftTime, gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY.timeType = gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY, "noMsg"
			activityShowCtrl.eventState = state
			activityShowCtrl.eventName = i18n("activityname_22")
			activityShowCtrl.eventDes = i18n("activityname_22")
			activityShowCtrl.flagIcon = "icon_activity_show_9001106.png"
			activityShowCtrl.pageBg = bgName
			return activityShowCtrl
		end
	end
	;(nil)[gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY] = function()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local cumuActiveCtrl = SoraDGetCtrl("cumuActiveCtrl")
		local rechargeltCtrl = include("rechargeltCtrl")
		local crazyData = cumuActiveCtrl:getCrazyTrioData()
		local state = activityShowCtrl:getStateByID(gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY)
		if not crazyData.receive then
			_ENV = crazyData.receive
		end
		local receiveAll = table.nums(crazyData.receive) == rechargeltCtrl.getRechargeTotalConfigNum()
		if activityShowCtrl:isActivityOpen(gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY) and not receiveAll then
			local _ENV, bgName = activityShowCtrl, SoraDFIsRA() and "bg_activity_zzkr_a.png" or "bg_activity_zzkr_en.png"
			_ENV, activityShowCtrl.eventID = gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY, gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY
			activityShowCtrl.eventLeftTime, gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY.timeType = gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY, "noMsg"
			activityShowCtrl.eventState = state
			activityShowCtrl.eventName = i18n("recharge_gift_config_seven_text_08")
			activityShowCtrl.eventDes = i18n("recharge_gift_config_seven_text_08")
			activityShowCtrl.flagIcon = "icon_activity_show_9001106.png"
			activityShowCtrl.pageBg = bgName
			return activityShowCtrl
		end
	end
	;(nil)[gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY] = function()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local cumuActiveCtrl = SoraDGetCtrl("cumuActiveCtrl")
		local rechargeltCtrl = include("rechargeltCtrl")
		local crazyData = cumuActiveCtrl:getCrazyTrioData()
		local state = activityShowCtrl:getStateByID(gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY)
		if not crazyData.receive then
			_ENV = crazyData.receive
		end
		local receiveAll = table.nums(crazyData.receive) == rechargeltCtrl.getRechargeTotalConfigNum()
		if activityShowCtrl:isActivityOpen(gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY) and not receiveAll then
			local _ENV, bgName = activityShowCtrl, SoraDFIsRA() and "bg_activity_zzkr_a.png" or "bg_activity_zzkr_en.png"
			_ENV, activityShowCtrl.eventID = gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY, gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY
			activityShowCtrl.eventLeftTime, gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY.timeType = gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY, "noMsg"
			activityShowCtrl.eventState = state
			activityShowCtrl.eventName = i18n("recharge_gift_config_seven_text_08")
			activityShowCtrl.eventDes = i18n("recharge_gift_config_seven_text_08")
			activityShowCtrl.flagIcon = "icon_activity_show_9001106.png"
			activityShowCtrl.pageBg = bgName
			return activityShowCtrl
		end
	end
	;(nil)[gActivityTimeActivityID.FLOWER_ACTIVITY_RANK] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.FLOWER_ACTIVITY_RANK
		;(nil).name = i18n("common_text_3430")
		;(nil).des = i18n("common_text_3430")
		;(nil).icon = "icon_activity_show_flower.png"
		;(nil).bg = "bg_activity_show_flower.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.EXCHANGE_MALL] = function()
		local canOpen = false
		for i, v in ipairs(exchangeMallActivityID) do
			local gametop = gModuleMgr.getObject("gametop")
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			local newExchangeMallRead = include("newExchangeMallRead")
			local state = activityShowCtrl:getStateByID(v)
			if state == gActivityState.OPEN and newExchangeMallRead.isReachOpenLvByID(v) then
				canOpen = true
				break
			end
			if state == gActivityState.OPEN and v == gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_STONE then
				canOpen = true
				break
			end
		end
		if canOpen then
			_ENV = ipairs(exchangeMallActivityID)
			_ENV, ipairs(exchangeMallActivityID).eventID = gActivityTimeActivityID.EXCHANGE_MALL, gActivityTimeActivityID.EXCHANGE_MALL
			ipairs(exchangeMallActivityID).eventLeftTime, gActivityTimeActivityID.EXCHANGE_MALL.timeType = gActivityTimeActivityID.EXCHANGE_MALL, "noMsg"
			ipairs(exchangeMallActivityID).eventState = gActivityState.OPEN
			ipairs(exchangeMallActivityID).eventName = i18n("common_text_1809")
			ipairs(exchangeMallActivityID).eventDes = i18n("common_text_1854")
			ipairs(exchangeMallActivityID).flagIcon = "icon_activity_exchange_01.png"
			ipairs(exchangeMallActivityID).pageBg = "bg_activity_exchange_01.png"
			return ipairs(exchangeMallActivityID)
		end
	end
	;(nil)[gActivityTimeActivityID.GROUP_BUY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GROUP_BUY
		;(nil).name = i18n("common_text_1813")
		;(nil).des = i18n("common_text_1852")
		;(nil).icon = "icon_activity_groupbuy_01.png"
		;(nil).bg = "bg_activity_groupbuy_01.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.RED_PACKAGE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.RED_PACKAGE_ACTIVITY
		;(nil).name = i18n("common_text_4097")
		;(nil).des = i18n("common_text_4098")
		;(nil).icon = "icon_activity_show_9001069.png"
		;(nil).bg = "bg_activity_show_9001069.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ABC_CLUB] = function()
		local icon = IsArClient and "icon_activity_show_wordclub.png" or "icon_activity_show_wordclub_en.png"
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ABC_CLUB
		;(nil).name = i18n("common_text_2072")
		;(nil).des = i18n("common_text_2075")
		;(nil).icon = icon
		;(nil).bg = "bg_activity_show_wordclub.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.RECHARGE_GOLD_FOR_REWARD] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local rewardList = activityShowCtrl:getRechargeGoldForReward()
		if rewardList then
			_ENV = nil
			;(nil).eid = gActivityTimeActivityID.RECHARGE_GOLD_FOR_REWARD
			;(nil).name = i18n("activity_name_9001075_ROS")
			;(nil).des = i18n("activity_name_9001075_ROS")
			;(nil).icon = "icon_activity_show_9001075.png"
			;(nil).bg = "bg_activity_show_9001075.png"
			return clientEventMgr.addNormalEvent(nil)
		end
	end
	;(nil)[gActivityTimeActivityID.TURNTABLE_ACTIVITY] = function()
		local luckyTreasureCtrl = SoraDGetCtrl("luckyTreasureCtrl")
		if luckyTreasureCtrl:checkShowActivity() then
			_ENV = luckyTreasureCtrl
			luckyTreasureCtrl.eid = gActivityTimeActivityID.TURNTABLE_ACTIVITY
			luckyTreasureCtrl.name = i18n("Lucky_treasure_title_01")
			luckyTreasureCtrl.des = " "
			luckyTreasureCtrl.icon = "icon_activity_9001109.png"
			luckyTreasureCtrl.bg = "bg_activity_show_Madeleine.png"
			return clientEventMgr.addNormalEvent(luckyTreasureCtrl)
		end
	end
	;(nil)[gActivityTimeActivityID.FRIEND_CALLBACK] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.FRIEND_CALLBACK
		;(nil).name = i18n("activity_name_9001113")
		;(nil).des = " "
		;(nil).icon = "icon_activity_9001113.png"
		;(nil).bg = "bg_activity_9001113.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CROSS_MISSION] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CROSS_MISSION
		;(nil).name = i18n("activity_name_05")
		;(nil).des = " "
		;(nil).icon = "icon_activity_9001120.png"
		;(nil).bg = "bg_activity_9001120.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.DECRYPTION_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.DECRYPTION_ACTIVITY
		;(nil).name = i18n("activity_name_05")
		;(nil).des = i18n("activity_name_05")
		;(nil).icon = "icon_activity_9001516.png"
		;(nil).bg = "bg_activity_9001120.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.FRIEND_HONORBACK] = function()
		if SoraDGetCastleLv() >= CASTLE_LV22_LIMITED then
			_ENV = CASTLE_LV22_LIMITED
			CASTLE_LV22_LIMITED.eid = gActivityTimeActivityID.FRIEND_HONORBACK
			CASTLE_LV22_LIMITED.name = i18n("activity_name_9001114")
			CASTLE_LV22_LIMITED.des = " "
			CASTLE_LV22_LIMITED.icon = "icon_activity_9001114.png"
			CASTLE_LV22_LIMITED.bg = "bg_activity_9001113_1.png"
			return clientEventMgr.addNormalEvent(CASTLE_LV22_LIMITED)
		end
	end
	;(nil)[gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local newKingActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY)
		if newKingActivityStatus == gActivityState.OPEN then
			local newKingRisesCtrl = gametop.playertop_:getModule("newKingRisesCtrl")
			local newKingActivitySubStatus = newKingRisesCtrl:getActivityStatus()
			if newKingActivitySubStatus == gKingRisesActivityStatus.CALCULATE then
				local remainEndTime = newKingRisesCtrl:getCloseQueue()
				clientEventMgr.addEventTimer(gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY, remainEndTime and remainEndTime.timerNode.timer:getRemainTime() or 0)
				_ENV = clientEventMgr.addEventTimer
				clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY
				_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY, newKingActivityStatus
				gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY.timeType = "showTime"
				clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY.timerLast = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY, "common_text_3721"
				clientEventMgr.addEventTimer.eventName = i18n("common_text_3717")
				clientEventMgr.addEventTimer.eventDes = i18n("common_text_3717")
				clientEventMgr.addEventTimer.flagIcon = "icon_activity_king_road.png"
				clientEventMgr.addEventTimer.pageBg = "bg_xwjq_01.png"
				return clientEventMgr.addEventTimer
			elseif newKingActivityStatus == gKingRisesActivityStatus.OPEN then
				local remainCalTime = newKingRisesCtrl:getRewardQueue()
				clientEventMgr.addEventTimer(gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY, remainCalTime and remainCalTime.timerNode.timer:getRemainTime() or 0)
				_ENV = clientEventMgr.addEventTimer
				clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY
				_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY, newKingActivityStatus
				gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY.timeType = "showTime"
				clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY.timerLast = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY, "common_text_607"
				clientEventMgr.addEventTimer.eventName = i18n("common_text_3717")
				clientEventMgr.addEventTimer.eventDes = i18n("common_text_3717")
				clientEventMgr.addEventTimer.flagIcon = "icon_activity_king_road.png"
				clientEventMgr.addEventTimer.pageBg = "bg_xwjq_01.png"
				return clientEventMgr.addEventTimer
			end
		end
	end
	;(nil)[gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
		;(nil).name = i18n("activity_name_9001201")
		;(nil).des = i18n("activity_name_9001201")
		;(nil).icon = "icon_activity_9001201.png"
		;(nil).bg = "bg_activity_9001201.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY
		;(nil).name = i18n("activity_name_9001314")
		;(nil).des = i18n("activity_name_9001314")
		;(nil).icon = "icon_activity_9001314.png"
		;(nil).bg = "bg_activity_9001314.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE
		;(nil).name = i18n("activity_name_22")
		;(nil).des = i18n("activity_name_22")
		;(nil).icon = "icon_activity_9001150.png"
		;(nil).bg = "bg_activity_9001150.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local newKingActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL)
		if newKingActivityStatus == gActivityState.OPEN then
			local newKingRisesCtrl = gametop.playertop_:getModule("newKingRisesCtrl")
			local newKingActivitySubStatus = newKingRisesCtrl:getActivityStatus()
			if newKingActivitySubStatus == gKingRisesActivityStatus.CALCULATE then
				local remainEndTime = newKingRisesCtrl:getCloseQueue()
				clientEventMgr.addEventTimer(gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL, remainEndTime and remainEndTime.timerNode.timer:getRemainTime() or 0)
				_ENV = clientEventMgr.addEventTimer
				clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL
				_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL, newKingActivityStatus
				gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL.timeType = "showTime"
				clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL.timerLast = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL, "common_text_3721"
				clientEventMgr.addEventTimer.eventName = i18n("common_text_3717")
				clientEventMgr.addEventTimer.eventDes = i18n("common_text_3717")
				clientEventMgr.addEventTimer.flagIcon = "icon_activity_king_road.png"
				clientEventMgr.addEventTimer.pageBg = "bg_activity_king_road.png"
				return clientEventMgr.addEventTimer
			elseif newKingActivityStatus == gKingRisesActivityStatus.OPEN then
				local remainCalTime = newKingRisesCtrl:getRewardQueue()
				clientEventMgr.addEventTimer(gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL, remainCalTime and remainCalTime.timerNode.timer:getRemainTime() or 0)
				_ENV = clientEventMgr.addEventTimer
				clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL
				_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL, newKingActivityStatus
				gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL.timeType = "showTime"
				clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL.timerLast = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL, "common_text_607"
				clientEventMgr.addEventTimer.eventName = i18n("common_text_3717")
				clientEventMgr.addEventTimer.eventDes = i18n("common_text_3717")
				clientEventMgr.addEventTimer.flagIcon = "icon_activity_king_road.png"
				clientEventMgr.addEventTimer.pageBg = "bg_activity_king_road.png"
				return clientEventMgr.addEventTimer
			end
		end
	end
	;(nil)[gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY] = function()
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			return
		end
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local status = activityShowCtrl:getStateByID(gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY)
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY)
		local curState = param.curState
		if status == gActivityState.OPEN then
			local settleTime = param.timeConfig.settleTime
			clientEventMgr.addEventTimer(gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY, math.max(0, settleTime - serviceFunctions.systemTime()))
			if curState == ACTIVITY_STATE.ACTIVE then
				_ENV = ACTIVITY_STATE.ACTIVE
				ACTIVITY_STATE.ACTIVE.eventID = gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY
				_ENV, ACTIVITY_STATE.ACTIVE.eventState = gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY, status
				gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY.timeType = "showTime"
				ACTIVITY_STATE.ACTIVE.eventLeftTime, gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY.timerLast = gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY, "common_text_607"
				ACTIVITY_STATE.ACTIVE.eventName = i18n("activity_name_9001495")
				ACTIVITY_STATE.ACTIVE.eventDes = i18n("activity_name_9001495")
				ACTIVITY_STATE.ACTIVE.flagIcon = "icon_activity_9001495.png"
				ACTIVITY_STATE.ACTIVE.pageBg = "bg_activity_9001495.png"
				return ACTIVITY_STATE.ACTIVE
			end
		elseif status == gActivityState.PREPARE and curState == ACTIVITY_STATE.PREPARE then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityState.PREPARE, gActivityState.PREPARE
			gActivityState.PREPARE.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityState.PREPARE.timerLast = gActivityState.PREPARE, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001495")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001495")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001495.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001495.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.LEGEND_LORD] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV15_LIMITED then
			return
		end
		if legendLordActivityStatus == gActivityState.OPEN then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.LEGEND_LORD, _eventTime.timerNode.timer:getRemainTime())
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
			local legendLordState = param.curState
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				_ENV = ACTIVITY_STATE.ACTIVE
				ACTIVITY_STATE.ACTIVE.eventID = gActivityTimeActivityID.LEGEND_LORD
				_ENV, ACTIVITY_STATE.ACTIVE.eventState = gActivityTimeActivityID.LEGEND_LORD, legendLordActivityStatus
				gActivityTimeActivityID.LEGEND_LORD.timeType = "showTime"
				ACTIVITY_STATE.ACTIVE.eventLeftTime, gActivityTimeActivityID.LEGEND_LORD.timerLast = gActivityTimeActivityID.LEGEND_LORD, "common_text_607"
				ACTIVITY_STATE.ACTIVE.eventName = i18n("common_text_4207")
				ACTIVITY_STATE.ACTIVE.eventDes = i18n("common_text_4207")
				ACTIVITY_STATE.ACTIVE.flagIcon = "icon_activity_legendaryking.png"
				ACTIVITY_STATE.ACTIVE.pageBg = "bg_activity_lord.png"
				return ACTIVITY_STATE.ACTIVE
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				_ENV = ACTIVITY_STATE.SETTLE
				ACTIVITY_STATE.SETTLE.eventID = gActivityTimeActivityID.LEGEND_LORD
				_ENV, ACTIVITY_STATE.SETTLE.eventState = gActivityTimeActivityID.LEGEND_LORD, legendLordActivityStatus
				ACTIVITY_STATE.SETTLE.eventLeftTime, gActivityTimeActivityID.LEGEND_LORD.timeType = gActivityTimeActivityID.LEGEND_LORD, "noMsg"
				ACTIVITY_STATE.SETTLE.eventName = i18n("common_text_4207")
				ACTIVITY_STATE.SETTLE.eventDes = i18n("common_text_4207")
				ACTIVITY_STATE.SETTLE.flagIcon = "icon_activity_legendaryking.png"
				ACTIVITY_STATE.SETTLE.pageBg = "bg_activity_lord.png"
				return ACTIVITY_STATE.SETTLE
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			local timerLast = "common_text_606"
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.LEGEND_LORD, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.LEGEND_LORD
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityState.PREPARE, gActivityState.PREPARE
			gActivityState.PREPARE.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityState.PREPARE.timerLast = gActivityState.PREPARE, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("common_text_4207")
			clientEventMgr.addEventTimer.eventDes = i18n("common_text_4207")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_legendaryking.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_lord.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.KING_STAR_BATTLE] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.KING_STAR_BATTLE)
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV15_LIMITED then
			return
		end
		local lang = SoraDGetDefaultLanguage()
		if legendLordActivityStatus == gActivityState.OPEN then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.KING_STAR_BATTLE)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.KING_STAR_BATTLE, _eventTime.timerNode.timer:getRemainTime())
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
			local legendLordState = param.curState
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				_ENV = ACTIVITY_STATE.ACTIVE
				ACTIVITY_STATE.ACTIVE.eventID = gActivityTimeActivityID.KING_STAR_BATTLE
				_ENV, ACTIVITY_STATE.ACTIVE.eventState = gActivityTimeActivityID.KING_STAR_BATTLE, legendLordActivityStatus
				gActivityTimeActivityID.KING_STAR_BATTLE.timeType = "showTime"
				ACTIVITY_STATE.ACTIVE.eventLeftTime, gActivityTimeActivityID.KING_STAR_BATTLE.timerLast = gActivityTimeActivityID.KING_STAR_BATTLE, "common_text_607"
				ACTIVITY_STATE.ACTIVE.eventName = i18n("kingstarbattle_text_19")
				ACTIVITY_STATE.ACTIVE.eventDes = i18n("kingstarbattle_text_19")
				ACTIVITY_STATE.ACTIVE.flagIcon = "icon_activity_9001438.png"
				_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
				_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
				_eventTime.timerNode.timer:getRemainTime()[2] = "en"
				ACTIVITY_STATE.ACTIVE.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
				return ACTIVITY_STATE.ACTIVE
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				_ENV = ACTIVITY_STATE.SETTLE
				ACTIVITY_STATE.SETTLE.eventID = gActivityTimeActivityID.KING_STAR_BATTLE
				_ENV, ACTIVITY_STATE.SETTLE.eventState = gActivityTimeActivityID.KING_STAR_BATTLE, legendLordActivityStatus
				ACTIVITY_STATE.SETTLE.eventLeftTime, gActivityTimeActivityID.KING_STAR_BATTLE.timeType = gActivityTimeActivityID.KING_STAR_BATTLE, "noMsg"
				ACTIVITY_STATE.SETTLE.eventName = i18n("kingstarbattle_text_24")
				ACTIVITY_STATE.SETTLE.eventDes = i18n("kingstarbattle_text_24")
				ACTIVITY_STATE.SETTLE.flagIcon = "icon_activity_9001438.png"
				_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
				_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
				_eventTime.timerNode.timer:getRemainTime()[2] = "en"
				ACTIVITY_STATE.SETTLE.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
				return ACTIVITY_STATE.SETTLE
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			local timerLast = "common_text_606"
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.KING_STAR_BATTLE)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.KING_STAR_BATTLE, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.KING_STAR_BATTLE
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityState.PREPARE, gActivityState.PREPARE
			gActivityState.PREPARE.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityState.PREPARE.timerLast = gActivityState.PREPARE, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("kingstarbattle_text_19")
			clientEventMgr.addEventTimer.eventDes = i18n("kingstarbattle_text_19")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001438.png"
			_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
			_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
			_eventTime.timerNode.timer:getRemainTime()[2] = "en"
			clientEventMgr.addEventTimer.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.LEGEND_LORD_9001646] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD_9001646)
		if SoraDGetCastleLv() < CASTLE_LV15_LIMITED then
			return
		end
		if legendLordActivityStatus == gActivityState.OPEN then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD_9001646)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.LEGEND_LORD_9001646, _eventTime.timerNode.timer:getRemainTime())
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD_9001646)
			local legendLordState = param.curState
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				_ENV = ACTIVITY_STATE.ACTIVE
				ACTIVITY_STATE.ACTIVE.eventID = gActivityTimeActivityID.LEGEND_LORD_9001646
				_ENV, ACTIVITY_STATE.ACTIVE.eventState = gActivityTimeActivityID.LEGEND_LORD_9001646, legendLordActivityStatus
				gActivityTimeActivityID.LEGEND_LORD_9001646.timeType = "showTime"
				ACTIVITY_STATE.ACTIVE.eventLeftTime, gActivityTimeActivityID.LEGEND_LORD_9001646.timerLast = gActivityTimeActivityID.LEGEND_LORD_9001646, "common_text_607"
				ACTIVITY_STATE.ACTIVE.eventName = i18n("activity_name_9001646")
				ACTIVITY_STATE.ACTIVE.eventDes = i18n("activity_name_9001646")
				ACTIVITY_STATE.ACTIVE.flagIcon = "icon_activity_9001438.png"
				_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
				_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
				_eventTime.timerNode.timer:getRemainTime()[2] = "en"
				ACTIVITY_STATE.ACTIVE.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
				return ACTIVITY_STATE.ACTIVE
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				_ENV = ACTIVITY_STATE.SETTLE
				ACTIVITY_STATE.SETTLE.eventID = gActivityTimeActivityID.LEGEND_LORD_9001646
				_ENV, ACTIVITY_STATE.SETTLE.eventState = gActivityTimeActivityID.LEGEND_LORD_9001646, legendLordActivityStatus
				ACTIVITY_STATE.SETTLE.eventLeftTime, gActivityTimeActivityID.LEGEND_LORD_9001646.timeType = gActivityTimeActivityID.LEGEND_LORD_9001646, "noMsg"
				ACTIVITY_STATE.SETTLE.eventName = i18n("kingstarbattle_text_24")
				ACTIVITY_STATE.SETTLE.eventDes = i18n("kingstarbattle_text_24")
				ACTIVITY_STATE.SETTLE.flagIcon = "icon_activity_9001438.png"
				_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
				_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
				_eventTime.timerNode.timer:getRemainTime()[2] = "en"
				ACTIVITY_STATE.SETTLE.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
				return ACTIVITY_STATE.SETTLE
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			local timerLast = "common_text_606"
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD_9001646)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.LEGEND_LORD_9001646, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.LEGEND_LORD_9001646
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityState.PREPARE, gActivityState.PREPARE
			gActivityState.PREPARE.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityState.PREPARE.timerLast = gActivityState.PREPARE, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001646")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001646")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001438.png"
			_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
			_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
			_eventTime.timerNode.timer:getRemainTime()[2] = "en"
			clientEventMgr.addEventTimer.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.LEGEND_LORD_9001647] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD_9001647)
		if SoraDGetCastleLv() < CASTLE_LV15_LIMITED then
			return
		end
		if legendLordActivityStatus == gActivityState.OPEN then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD_9001647)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.LEGEND_LORD_9001647, _eventTime.timerNode.timer:getRemainTime())
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD_9001647)
			local legendLordState = param.curState
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				_ENV = ACTIVITY_STATE.ACTIVE
				ACTIVITY_STATE.ACTIVE.eventID = gActivityTimeActivityID.LEGEND_LORD_9001647
				_ENV, ACTIVITY_STATE.ACTIVE.eventState = gActivityTimeActivityID.LEGEND_LORD_9001647, legendLordActivityStatus
				gActivityTimeActivityID.LEGEND_LORD_9001647.timeType = "showTime"
				ACTIVITY_STATE.ACTIVE.eventLeftTime, gActivityTimeActivityID.LEGEND_LORD_9001647.timerLast = gActivityTimeActivityID.LEGEND_LORD_9001647, "common_text_607"
				ACTIVITY_STATE.ACTIVE.eventName = i18n("activity_name_9001647")
				ACTIVITY_STATE.ACTIVE.eventDes = i18n("activity_name_9001647")
				ACTIVITY_STATE.ACTIVE.flagIcon = "icon_activity_9001438.png"
				_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
				_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
				_eventTime.timerNode.timer:getRemainTime()[2] = "en"
				ACTIVITY_STATE.ACTIVE.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
				return ACTIVITY_STATE.ACTIVE
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				_ENV = ACTIVITY_STATE.SETTLE
				ACTIVITY_STATE.SETTLE.eventID = gActivityTimeActivityID.LEGEND_LORD_9001647
				_ENV, ACTIVITY_STATE.SETTLE.eventState = gActivityTimeActivityID.LEGEND_LORD_9001647, legendLordActivityStatus
				ACTIVITY_STATE.SETTLE.eventLeftTime, gActivityTimeActivityID.LEGEND_LORD_9001647.timeType = gActivityTimeActivityID.LEGEND_LORD_9001647, "noMsg"
				ACTIVITY_STATE.SETTLE.eventName = i18n("kingstarbattle_text_24")
				ACTIVITY_STATE.SETTLE.eventDes = i18n("kingstarbattle_text_24")
				ACTIVITY_STATE.SETTLE.flagIcon = "icon_activity_9001438.png"
				_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
				_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
				_eventTime.timerNode.timer:getRemainTime()[2] = "en"
				ACTIVITY_STATE.SETTLE.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
				return ACTIVITY_STATE.SETTLE
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			local timerLast = "common_text_606"
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_LORD_9001647)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.LEGEND_LORD_9001647, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.LEGEND_LORD_9001647
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityState.PREPARE, gActivityState.PREPARE
			gActivityState.PREPARE.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityState.PREPARE.timerLast = gActivityState.PREPARE, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001647")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001647")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001438.png"
			_UPVALUE2_ = _eventTime.timerNode.timer:getRemainTime()
			_eventTime.timerNode.timer:getRemainTime()[1] = "ar"
			_eventTime.timerNode.timer:getRemainTime()[2] = "en"
			clientEventMgr.addEventTimer.pageBg = SoraDGetImageNameByLang("bg_activity_9001438_%s.png", _eventTime.timerNode.timer:getRemainTime())
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityCenterUIEnum.LEGEND_HEGEMON] = function()
		print("开始检测传奇霸主活动-------------------------")
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) < CASTLE_LV15_LIMITED then
			return
		end
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		local hegemonState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
		if hegemonState == gActivityState.CLOSE then
			print("活动处于关闭状态----")
			return
		elseif hegemonState == gActivityState.PREPARE then
			local leftTime = timeTbInfo.leftTime
			clientEventMgr.addEventTimer(gActivityCenterUIEnum.LEGEND_HEGEMON, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.LEGEND_HEGEMON
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityState.PREPARE, gActivityState.PREPARE
			gActivityState.PREPARE.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityState.PREPARE.timerLast = gActivityState.PREPARE, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("hegemon_name_13")
			clientEventMgr.addEventTimer.eventDes = i18n("hegemon_name_13")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_hegemon.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_lord.png"
			return clientEventMgr.addEventTimer
		elseif hegemonState == gActivityState.OPEN then
			local curState = timeTbInfo.curState
			local leftTime = timeTbInfo.leftTime
			clientEventMgr.addEventTimer(gActivityCenterUIEnum.LEGEND_HEGEMON, leftTime)
			if curState == ACTIVITY_STATE.ACTIVE then
				_ENV = ACTIVITY_STATE.ACTIVE
				ACTIVITY_STATE.ACTIVE.eventID = gActivityCenterUIEnum.LEGEND_HEGEMON
				_ENV, ACTIVITY_STATE.ACTIVE.eventState = gActivityState.OPEN, gActivityState.OPEN
				gActivityState.OPEN.timeType = "showTime"
				ACTIVITY_STATE.ACTIVE.eventLeftTime, gActivityState.OPEN.timerLast = gActivityState.OPEN, "common_text_607"
				ACTIVITY_STATE.ACTIVE.eventName = i18n("hegemon_name_13")
				ACTIVITY_STATE.ACTIVE.eventDes = i18n("hegemon_name_13")
				ACTIVITY_STATE.ACTIVE.flagIcon = "icon_activity_hegemon.png"
				ACTIVITY_STATE.ACTIVE.pageBg = "bg_activity_lord.png"
				return ACTIVITY_STATE.ACTIVE
			elseif curState == ACTIVITY_STATE.SETTLE then
				_ENV = ACTIVITY_STATE.SETTLE
				ACTIVITY_STATE.SETTLE.eventID = gActivityCenterUIEnum.LEGEND_HEGEMON
				_ENV, ACTIVITY_STATE.SETTLE.eventState = gActivityState.OPEN, gActivityState.OPEN
				ACTIVITY_STATE.SETTLE.eventLeftTime, gActivityState.OPEN.timeType = gActivityState.OPEN, "noMsg"
				ACTIVITY_STATE.SETTLE.eventName = i18n("hegemon_name_13")
				ACTIVITY_STATE.SETTLE.eventDes = i18n("hegemon_name_13")
				ACTIVITY_STATE.SETTLE.flagIcon = "icon_activity_hegemon.png"
				ACTIVITY_STATE.SETTLE.pageBg = "bg_activity_lord.png"
				return ACTIVITY_STATE.SETTLE
			end
		else
			print("霸主状态出错了-------")
		end
	end
	;(nil)[gActivityTimeActivityID.HERO_BATTLE_BOSS] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.HERO_BATTLE_BOSS
		;(nil).name = i18n("activityname_20")
		;(nil).des = i18n("activityname_20")
		;(nil).icon = "icon_activity_9001075.png"
		;(nil).bg = "bg_activity_9001075.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.KING_GROUP_BUY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.KING_GROUP_BUY_ACTIVITY
		;(nil).name = i18n("common_text_3485")
		;(nil).des = i18n("common_text_3485")
		;(nil).icon = "icon_activity_KingGroupbuy.png"
		;(nil).bg = "bg_activity_show_KingGroupbuy.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY] = function()
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local castleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
		local isOpen = kingdomLevelDataModuleAPI:isOpen()
		if not isOpen and castleLv >= CASTLE_MAXLV_WAR then
			return
		end
		local newActivityCtrl = SoraDGetCtrl("newActivityCtrl")
		local castleData = newActivityCtrl:getCastleUpgradeData()
		local isMaxLv = true
		for k, v in pairs(castleData) do
			if castleLv < v.castleLv then
				isMaxLv = false
				break
			end
		end
		if isMaxLv then
			return
		end
		_ENV = pairs(castleData)
		pairs(castleData).eid = gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY
		pairs(castleData).name = i18n("common_text_2648")
		pairs(castleData).des = i18n("common_text_2649")
		pairs(castleData).icon = "icon_activity_show_Pursue_man.png"
		pairs(castleData).bg = "bg_activity_show_Pursue_man.png"
		return clientEventMgr.addNormalEvent(pairs(castleData))
	end
	;(nil)[gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY
		;(nil).name = i18n("activityname_24")
		;(nil).des = i18n("activityname_24")
		;(nil).icon = "activity_show_9001128.png"
		;(nil).bg = "bg_activity_9001128.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY
		;(nil).name = i18n("common_text_2645")
		;(nil).des = i18n("common_text_2644")
		;(nil).icon = "icon_activity_show_Development_army.png"
		;(nil).bg = "bg_Development_army.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY
		;(nil).name = i18n("common_text_3040")
		;(nil).des = i18n("common_text_3040")
		;(nil).icon = "icon_activity_show_crazy_score.png"
		;(nil).bg = "bg_activity_show_pointrace.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.GLORIOUS_CONTEST] = function()
		local starCompetitionRead = include("starCompetitionRead")
		local maxLv = starCompetitionRead.getConfigMaxLv()
		if maxLv <= SoraDGetBuildStarLv() then
			return
		end
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GLORIOUS_CONTEST
		;(nil).name = i18n("soldier_competition_01")
		;(nil).des = i18n("soldier_competition_01")
		;(nil).icon = "icon_activity_9001256.png"
		;(nil).bg = "bg_activity_9001256.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.EQUIP_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.EQUIP_ACTIVITY
		;(nil).name = i18n("activity_name_9001258")
		;(nil).des = i18n("activity_name_9001258")
		;(nil).icon = "icon_activity_9001258.png"
		;(nil).bg = "bg_activity_9001258.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY
		;(nil).name = i18n("activity_name_9001263")
		;(nil).des = i18n("activity_name_9001263")
		;(nil).icon = "icon_activity_9001263.png"
		;(nil).bg = "bg_activity_9001263.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY] = function()
		local name = IsArClient and i18n("common_text_3953") or i18n("common_text_4189")
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local multiple = activityShowCtrl:getParamByID(gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY).multiple or 2
		_ENV = nil
		;(nil).Percent = multiple * 100
		local des = i18n("common_text_4192", nil)
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY
		;(nil).name = name
		;(nil).des = des
		;(nil).icon = multiple == 1 and "icon_activity_show_9001068.png" or string.format("icon_activity_serves_%02d.png", multiple)
		;(nil).bg = "bg_activity_9001068.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.KITS_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.KITS_ACTIVITY
		;(nil).name = i18n("kits_name_01")
		;(nil).des = i18n("kits_name_01")
		;(nil).icon = "activity_show_9001127.png"
		;(nil).bg = "bg_smjn_dt_02.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.KNIGHTS_CHARGE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.KNIGHTS_CHARGE
		;(nil).name = i18n("mail_title_40")
		;(nil).des = i18n("mail_title_40")
		;(nil).icon = "icon_activity_show_9001126.png"
		;(nil).bg = "bg_activity_9001126.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ANNIHILATION] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ANNIHILATION
		;(nil).name = i18n("activityname_9001131")
		;(nil).des = i18n("activityname_9001131")
		;(nil).icon = "icon_activity_9001131.png"
		;(nil).bg = "bg_activity_9001131.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY
		;(nil).name = i18n("devilvalley_text_01")
		;(nil).des = i18n("devilvalley_text_01")
		;(nil).icon = "icon_devil_valley_entrance_01.png"
		;(nil).bg = "bg_activity_show_mgyzz.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY
		;(nil).name = i18n("activity_name_9001271")
		;(nil).des = i18n("activity_name_9001271")
		;(nil).icon = "icon_activity_9001271.png"
		;(nil).bg = "bg_activity_9001271.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ROYAL_SUMMONS] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
		local activityType = royalSummonsCtrl:getClassType()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ROYAL_SUMMONS
		;(nil).name = i18n(activityType == 1 and "summoned_name_01" or "summoned_name_02")
		;(nil).des = i18n(activityType == 1 and "summoned_name_01" or "summoned_name_02")
		;(nil).icon = activityType == 1 and "icon_activity_9001132.png" or "icon_activity_9001132_02.png"
		;(nil).bg = activityType == 1 and "bg_activity_9001132.png" or "bg_activity_9001132_02.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PETRA_RARE_TREASURE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PETRA_RARE_TREASURE
		;(nil).name = i18n("activity_name_20")
		;(nil).des = i18n("activity_name_20")
		;(nil).icon = "icon_activity_9001142.png"
		;(nil).bg = "bg_activity_9001142.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PSD_RED_PACKAGE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PSD_RED_PACKAGE_ACTIVITY
		;(nil).name = i18n("activity_name_08")
		;(nil).des = i18n("activity_name_08")
		;(nil).icon = "icon_activity_9001135.png"
		;(nil).bg = "bg_activity_9001135.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SUPER_COMMANDER] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.SUPER_COMMANDER
		;(nil).name = i18n("activity_name_19")
		;(nil).des = i18n("activity_name_19")
		;(nil).icon = "icon_activity_9001145.png"
		;(nil).bg = "bg_activity_9001145.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE
		;(nil).name = i18n("mail_text_87")
		;(nil).des = i18n("mail_text_87")
		;(nil).icon = "icon_activity_show_cumu_recharge.png"
		;(nil).bg = "bg_activity_show_cumu_recharge.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CUMU_ACTIVITY_CONSUME] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CUMU_ACTIVITY_CONSUME
		;(nil).name = i18n("mail_text_88")
		;(nil).des = i18n("mail_text_88")
		;(nil).icon = "icon_activity_show_cumu_comsum.png"
		;(nil).bg = "bg_activity_show_cumu_comsum.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SPEND_GOLD_REBATE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.SPEND_GOLD_REBATE
		;(nil).name = i18n("gold_return_text_01")
		;(nil).des = i18n("gold_return_text_01")
		;(nil).icon = "icon_activity_gold_back.png"
		;(nil).bg = "bg_activity_gold_back.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityCenterUIEnum.GREAT_CHALLENGE] = function()
		local wonderfulState = gActivityState.CLOSE
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		for i, v in ipairs(clientEventMgr.greatChallengeId) do
			if activityShowCtrl:getStateByID(v) == gActivityState.OPEN then
				wonderfulState = gActivityState.OPEN
				break
			end
		end
		if wonderfulState == gActivityState.OPEN then
			_ENV = gActivityState.OPEN
			gActivityState.OPEN.eventID = gActivityCenterUIEnum.GREAT_CHALLENGE
			_ENV, gActivityState.OPEN.eventState = gActivityCenterUIEnum.GREAT_CHALLENGE, wonderfulState
			gActivityState.OPEN.eventLeftTime, gActivityCenterUIEnum.GREAT_CHALLENGE.timeType = gActivityCenterUIEnum.GREAT_CHALLENGE, "noMsg"
			gActivityState.OPEN.eventName = i18n("Challenge_name_title")
			gActivityState.OPEN.eventDes = i18n("Challenge_name_title")
			gActivityState.OPEN.flagIcon = "icon_challenge_hdzx.png"
			gActivityState.OPEN.pageBg = "bg_activity_show_challenge.png"
			return gActivityState.OPEN
		end
	end
	;(nil)[gActivityTimeActivityID.GEOCENTRIC_ADVENTURE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GEOCENTRIC_ADVENTURE
		;(nil).name = i18n("Exploration_comment_01")
		;(nil).des = i18n("Exploration_comment_01")
		;(nil).icon = "icon_activity_Geocentric_adventure.png"
		;(nil).bg = "bg_activity_Geocentric_adventure.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT
		;(nil).name = i18n("luckyrecharge_comment_01")
		;(nil).des = i18n("luckyrecharge_comment_01")
		;(nil).icon = "icon_activity_luckyrecharge.png"
		;(nil).bg = "bg_activity_luckyrecharge.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.MOVE_CITY_ACTIVIYT] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.MOVE_CITY_ACTIVIYT
		;(nil).name = i18n("migrate_text_01")
		;(nil).des = i18n("migrate_text_01")
		;(nil).icon = "icon_activity_show_migration.png"
		;(nil).bg = "bg_activity_show_migrate.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.UNCHARTED_ADVENTURE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.UNCHARTED_ADVENTURE
		;(nil).name = i18n("Secret_explore_text_01")
		;(nil).des = i18n("Secret_explore_text_01")
		;(nil).icon = "icon_activity_SecretExplore.png"
		;(nil).bg = "bg_activity_SecretExplore.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.UNCHARTED_HELP] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.UNCHARTED_HELP
		;(nil).name = i18n("secret_explore_assistance_text_01")
		;(nil).des = i18n("secret_explore_assistance_text_01")
		;(nil).icon = "icon_activity_9001512.png"
		;(nil).bg = "bg_activity_show_9001512.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION
		;(nil).name = i18n("christmas_tree_text_01")
		;(nil).des = i18n("christmas_tree_text_01")
		;(nil).icon = "icon_activity_christmas_tree.png"
		;(nil).bg = "bg_activity_show_9001513.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ANNIVERSARY_CELEBRATION] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ANNIVERSARY_CELEBRATION
		;(nil).name = i18n("celebration_text_01")
		;(nil).des = i18n("celebration_text_01")
		;(nil).icon = "icon_activity_9001517.png"
		;(nil).bg = "bg_activity_show_9001517.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.WEEKLY_SPECIAL] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local weeklySpecialCtrl = gametop.playertop_:getModule("weeklySpecialCtrl")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.WEEKLY_SPECIAL)
		local _eventLast = clientEventMgr.judgeIsOnShow(state)
		if _eventLast then
			local leftTime = weeklySpecialCtrl:getSpecialTodayRemainTime()
			clientEventMgr.addEventTimer(gActivityTimeActivityID.WEEKLY_SPECIAL, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.WEEKLY_SPECIAL
			clientEventMgr.addEventTimer.eventState = state
			clientEventMgr.addEventTimer.eventName = i18n("weekly_sale_text_01")
			_ENV, clientEventMgr.addEventTimer.eventDes = i18n("weekly_sale_text_01"), i18n("weekly_sale_text_01")
			clientEventMgr.addEventTimer.eventLeftTime, i18n("weekly_sale_text_01").timeType = i18n("weekly_sale_text_01"), "noMsg"
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_show_9001520.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_show_9001520.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.GOLD_PACKAGE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GOLD_PACKAGE
		;(nil).name = i18n("gold_gift_text_01")
		;(nil).des = i18n("gold_gift_text_01")
		;(nil).icon = "icon_activity_gold_gift.png"
		;(nil).bg = "bg_activity_show_gold_gift.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.COST_GOLD_FOR_GIFT] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.COST_GOLD_FOR_GIFT
		;(nil).name = i18n("consume_gold_text_01")
		;(nil).des = i18n("consume_gold_text_01")
		;(nil).icon = "icon_activity_show_consume_gold.png"
		;(nil).bg = "bg_activity_consume_gold.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SLOT_MACHINE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.SLOT_MACHINE
		;(nil).name = i18n("slot_machine_text_01")
		;(nil).des = i18n("slot_machine_text_01")
		;(nil).icon = "icon_activity_show_slotmachine.png"
		;(nil).bg = "bg_activity_show_slotmachine.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SEVEN_DAYS_SIGNIN] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.SEVEN_DAYS_SIGNIN
		;(nil).name = i18n("activityname_19")
		;(nil).des = i18n("activityname_19")
		;(nil).icon = "icon_activity_show_signin.png"
		;(nil).bg = "bg_activity_show_7signin.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PARTY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PARTY_ACTIVITY
		;(nil).name = i18n("feast_title_01")
		;(nil).des = i18n("feast_title_01")
		;(nil).icon = "icon_activity_9001511.png"
		;(nil).bg = "bg_activity_9001511.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CHRISTMAS_BATTLE] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CHRISTMAS_BATTLE
		;(nil).name = i18n("christmas_stocking_text_01")
		;(nil).des = i18n("christmas_stocking_text_01")
		;(nil).icon = "icon_activity_christmas_stocking.png"
		;(nil).bg = "bg_activity_show_9001514.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.NEW_SERVER_RANK_MATCH] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.NEW_SERVER_RANK_MATCH
		;(nil).name = i18n("kindom_competition_text_01")
		;(nil).des = i18n("kindom_competition_text_01")
		;(nil).icon = "icon_activity_show_9001518.png"
		;(nil).bg = "bg_activity_show_9001518.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.NEW_TOTAL_PAY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.NEW_TOTAL_PAY_ACTIVITY
		;(nil).name = i18n("accumulate_recharge_text_01")
		;(nil).des = i18n("accumulate_recharge_text_01")
		;(nil).icon = "icon_activity_show_9001522.png"
		;(nil).bg = "bg_activity_show_9001522.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.NEW_KING_FUND] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local newKingFundCtrl = gametop.playertop_:getModule("newKingFundCtrl")
		if newKingFundCtrl:isShowFundPage() then
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEW_KING_FUND)
			local timeLast = clientEventMgr.judgeIsOnShow(state)
			if newKingFundCtrl:isShowFundTime() then
				local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND)
				local leftTime = timer.timerNode.timer:getRemainTime()
				clientEventMgr.addEventTimer(gActivityTimeActivityID.NEW_KING_FUND, leftTime)
				_ENV = clientEventMgr.addEventTimer
				clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.NEW_KING_FUND
				_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.NEW_KING_FUND, state
				gActivityTimeActivityID.NEW_KING_FUND.timeType = "showTime"
				clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.NEW_KING_FUND.timerLast = gActivityTimeActivityID.NEW_KING_FUND, timeLast
				clientEventMgr.addEventTimer.eventName = i18n("new_lord_fund_text_01")
				clientEventMgr.addEventTimer.eventDes = i18n("new_lord_fund_text_01")
				clientEventMgr.addEventTimer.flagIcon = "icon_activity_NewLordFund.png"
				clientEventMgr.addEventTimer.pageBg = "bg_recharge_newlordfund.png"
				return clientEventMgr.addEventTimer
			else
				_ENV = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND)
				activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND).eventID = gActivityTimeActivityID.NEW_KING_FUND
				_ENV, activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND).eventState = gActivityTimeActivityID.NEW_KING_FUND, state
				activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND).eventLeftTime, gActivityTimeActivityID.NEW_KING_FUND.timeType = gActivityTimeActivityID.NEW_KING_FUND, "noMsg"
				activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND).eventName = i18n("new_lord_fund_text_01")
				activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND).eventDes = i18n("new_lord_fund_text_01")
				activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND).flagIcon = "icon_activity_NewLordFund.png"
				activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND).pageBg = "bg_recharge_newlordfund.png"
				return (activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEW_KING_FUND))
			end
		end
	end
	;(nil)[gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local crazyShoppingCtrl = gametop.playertop_:getModule("crazyShoppingCtrl")
		if crazyShoppingCtrl:isShowFundPage() then
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY)
			local timeLast = clientEventMgr.judgeIsOnShow(state)
			local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY)
			local leftTime = timer.timerNode.timer:getRemainTime()
			clientEventMgr.addEventTimer(gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY, state
			gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY.timerLast = gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY, timeLast
			clientEventMgr.addEventTimer.eventName = i18n("crazyshopping_text_01")
			clientEventMgr.addEventTimer.eventDes = i18n("crazyshopping_text_01")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_NewLordFund.png"
			clientEventMgr.addEventTimer.pageBg = "bg_recharge_newlordfund.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.ENJOY_LOTTERY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ENJOY_LOTTERY
		;(nil).name = i18n("enjoylottery_title_01")
		;(nil).des = i18n("enjoylottery_title_01")
		;(nil).icon = "icon_activity_show_9001519.png"
		;(nil).bg = "bg_activity_show_9001519.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.AMAZING_FORTUNE] = function()
		local bgName = SoraDFIsRA() and "bg_activity_9001151_ar.png" or "bg_activity_9001151_en.png"
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.AMAZING_FORTUNE
		;(nil).name = i18n("activity_name_21")
		;(nil).des = i18n("activity_name_21")
		;(nil).icon = "icon_activity_9001151.png"
		;(nil).bg = bgName
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.HERO_SECRET_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.HERO_SECRET_ACTIVITY
		;(nil).name = i18n("activity_name_24")
		;(nil).des = i18n("activity_name_24")
		;(nil).icon = "icon_activity_9001146.png"
		;(nil).bg = "bg_activity_9001146.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PLEAD_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PLEAD_ACTIVITY
		;(nil).name = i18n("activity_name_9001164")
		;(nil).des = i18n("activity_name_9001164")
		;(nil).icon = "icon_activity_9001164.png"
		;(nil).bg = "bg_activity_9001164.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.WRATH_BEAST_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.WRATH_BEAST_ACTIVITY
		;(nil).name = i18n("activity_name_9001168")
		;(nil).des = i18n("activity_name_9001168")
		;(nil).icon = "icon_activity_9001168.png"
		;(nil).bg = "bg_activity_9001168.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY
		;(nil).name = i18n("activity_name_174")
		;(nil).des = i18n("activity_name_174")
		;(nil).icon = "icon_activity_9001174.png"
		;(nil).bg = "bg_activity_9001174.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.HERO_FESTIVAL] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.HERO_FESTIVAL
		;(nil).name = i18n("activity_name_175")
		;(nil).des = i18n("activity_name_175")
		;(nil).icon = "icon_activity_9001175.png"
		;(nil).bg = "bg_activity_9001175.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY
		;(nil).name = i18n("activity_name_30")
		;(nil).des = i18n("activity_name_30")
		;(nil).icon = "icon_activity_9001176.png"
		;(nil).bg = "bg_activity_9001176.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.MANUAL_GIFT_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.MANUAL_GIFT_ACTIVITY
		;(nil).name = i18n("opt_package_text_01")
		;(nil).des = i18n("opt_package_text_01")
		;(nil).icon = "icon_activity_9001194.png"
		;(nil).bg = "bg_activity_9001194.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SPIRITUAL_GIFT] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.SPIRITUAL_GIFT
		;(nil).name = i18n("godGift_text_01")
		;(nil).des = i18n("godGift_text_01")
		;(nil).icon = "icon_activity_9001191.png"
		;(nil).bg = "bg_activity_9001191.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.TREASURE_PACKAGE] = function()
		local purchaseRebateCtrl = SoraDGetCtrl("purchaseRebateCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local isNotAllBought = purchaseRebateCtrl:isAllPackageNotBought()
		local treasureState = activityShowCtrl:getStateByID(gActivityTimeActivityID.TREASURE_PACKAGE)
		if treasureState == gActivityState.PREPARE then
			_ENV = gActivityTimeActivityID.TREASURE_PACKAGE
			gActivityTimeActivityID.TREASURE_PACKAGE.eid = gActivityTimeActivityID.TREASURE_PACKAGE
			gActivityTimeActivityID.TREASURE_PACKAGE.name = i18n("activity_name_9001199")
			gActivityTimeActivityID.TREASURE_PACKAGE.des = i18n("activity_name_9001199")
			gActivityTimeActivityID.TREASURE_PACKAGE.icon = "icon_activity_9001199.png"
			gActivityTimeActivityID.TREASURE_PACKAGE.bg = "bg_activity_9001199.png"
			return clientEventMgr.addNormalEvent(gActivityTimeActivityID.TREASURE_PACKAGE)
		elseif treasureState == gActivityState.OPEN and not isNotAllBought then
			_ENV = gActivityTimeActivityID.TREASURE_PACKAGE
			gActivityTimeActivityID.TREASURE_PACKAGE.eid = gActivityTimeActivityID.TREASURE_PACKAGE
			gActivityTimeActivityID.TREASURE_PACKAGE.name = i18n("activity_name_9001199")
			gActivityTimeActivityID.TREASURE_PACKAGE.des = i18n("activity_name_9001199")
			gActivityTimeActivityID.TREASURE_PACKAGE.icon = "icon_activity_9001199.png"
			gActivityTimeActivityID.TREASURE_PACKAGE.bg = "bg_activity_9001199.png"
			return clientEventMgr.addNormalEvent(gActivityTimeActivityID.TREASURE_PACKAGE)
		end
	end
	;(nil)[gActivityTimeActivityID.KINGDOM_FAVOR] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.KINGDOM_FAVOR
		;(nil).name = i18n("activity_name_31")
		;(nil).des = i18n("activity_name_31")
		;(nil).icon = "icon_activity_9001173.png"
		;(nil).bg = "bg_activity_9001173.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY)
		print("state···", state)
		local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY)
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		if timeLast and IsArClient then
			local leftTime = timer.timerNode.timer:getRemainTime()
			local timeFactory = function(ticket)
				local nextTime = activityShowCtrl:getGiftBagsInfo(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY)
				if activityShowCtrl:getStateByID(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY) == gActivityState.PREPARE then
					activityShowCtrl = gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY
					gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY.time = ticket
					return i18n("common_text_606", gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY)
				end
				if nextTime and nextTime > serviceFunctions.systemTime() then
					ticket = SoraDConvertSecondToStringNoDay(nextTime - serviceFunctions.systemTime())
				end
				activityShowCtrl = gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY
				gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY.time = ticket
				return i18n(nextTime and "gift_send_text_03" or "common_text_607", gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY)
			end
			clientEventMgr.addEventTimer(gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY, state
			gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY.timerFun = gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY, timeFactory
			clientEventMgr.addEventTimer.eventName = i18n("gift_send_title_01")
			clientEventMgr.addEventTimer.eventDes = i18n("gift_send_title_01")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001111.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001111_new.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.NEWKING_TRAIL] = function()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEWKING_TRAIL)
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEWKING_TRAIL)
		if timeLast then
			local newKingTrailRead = include("newKingTrailRead")
			local leftTime = timer.timerNode.timer:getRemainTime()
			local totalTime = timer and timer.totaltime or 0
			local totalStageTime = newKingTrailRead.getTotalStageTime(5)
			leftTime = leftTime - (totalTime - totalStageTime)
			leftTime = 0 < leftTime and leftTime or timer.timerNode.timer:getRemainTime()
			clientEventMgr.addEventTimer(gActivityTimeActivityID.NEWKING_TRAIL, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.NEWKING_TRAIL
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.NEWKING_TRAIL, state
			gActivityTimeActivityID.NEWKING_TRAIL.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.NEWKING_TRAIL.timerLast = gActivityTimeActivityID.NEWKING_TRAIL, timeLast
			clientEventMgr.addEventTimer.eventName = i18n("king_tri_name_01")
			clientEventMgr.addEventTimer.eventDes = i18n("king_tri_name_01")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001193.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001193.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.PUMPKIN_ACTIVITY] = function()
		if not IsArClient then
			_ENV = nil
			;(nil).eid = gActivityTimeActivityID.PUMPKIN_ACTIVITY
			;(nil).name = i18n("activity_name_9001196")
			;(nil).des = i18n("activity_name_9001196")
			;(nil).icon = "icon_activity_9001196.png"
			;(nil).bg = "bg_activity_9001196.png"
			return clientEventMgr.addNormalEvent(nil)
		end
	end
	;(nil)[gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY
		;(nil).name = i18n("activity_name_9001197")
		;(nil).des = i18n("activity_name_9001197")
		;(nil).icon = "icon_activity_9001197.png"
		;(nil).bg = "bg_activity_9001197.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.COMMUNITY_CENTER] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.COMMUNITY_CENTER)
		if eventState == gActivityState.OPEN or eventState == gActivityState.PREPARE then
			_ENV = gActivityState.PREPARE
			gActivityState.PREPARE.eventID = gActivityTimeActivityID.COMMUNITY_CENTER
			_ENV, gActivityState.PREPARE.eventState = gActivityTimeActivityID.COMMUNITY_CENTER, eventState
			gActivityState.PREPARE.eventLeftTime, gActivityTimeActivityID.COMMUNITY_CENTER.timeType = gActivityTimeActivityID.COMMUNITY_CENTER, "noMsg"
			gActivityState.PREPARE.eventName = i18n("activity_name_9001200")
			gActivityState.PREPARE.eventDes = i18n("activity_name_9001200")
			gActivityState.PREPARE.flagIcon = "icon_activity_9001200.png"
			gActivityState.PREPARE.pageBg = "bg_activity_9001200.png"
			return gActivityState.PREPARE
		end
	end
	;(nil)[gActivityTimeActivityID.WISH_TREE_ACTIVITY] = function()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		local infoData = activityTaskComponentCtrl:getActivityInitData(gActivityTimeActivityID.WISH_TREE_ACTIVITY)
		local stageInfo = activityShowCtrl:getShowDataByID(gActivityTimeActivityID.WISH_TREE_ACTIVITY)
		local sessionType = stageInfo and stageInfo.doStage
		local wishingTreeRead = include("wishingTreeRead")
		local group = infoData.group or 1
		if sessionType == 2 and 1 > wishingTreeRead.getNowStage(group, infoData and infoData.consumeGold or 0) then
		else
			_ENV = group
			group.eid = gActivityTimeActivityID.WISH_TREE_ACTIVITY
			group.name = i18n("activity_name_9001198")
			group.des = i18n("activity_name_9001198")
			group.icon = "icon_activity_9001198.png"
			group.bg = "bg_activity_9001198.png"
			return clientEventMgr.addNormalEvent(group)
		end
	end
	;(nil)[gActivityTimeActivityID.NEW_CROSS_MISSION] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.NEW_CROSS_MISSION
		;(nil).name = i18n("activity_name_9001525")
		;(nil).des = " "
		;(nil).icon = "icon_activity_9001525.png"
		;(nil).bg = "bg_activity_9001525.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.LUCKY_FLIP_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.LUCKY_FLIP_ACTIVITY
		;(nil).name = i18n("activity_name_9001203")
		;(nil).des = i18n("activity_name_9001203")
		;(nil).icon = "icon_activity_9001203.png"
		;(nil).bg = "bg_activity_9001203.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY
		;(nil).name = i18n("activity_name_9001206")
		;(nil).des = i18n("activity_name_9001206")
		;(nil).icon = "icon_activity_9001206.png"
		;(nil).bg = "bg_activity_9001206.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.JADE_STONE_MALL_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.JADE_STONE_MALL_ACTIVITY
		;(nil).name = i18n("activity_name_9001241")
		;(nil).des = i18n("activity_name_9001241")
		;(nil).icon = "icon_activity_9001241.png"
		;(nil).bg = "bg_activity_9001241.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.WAR_TREASURE_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.WAR_TREASURE_ACTIVITY)
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.WAR_TREASURE_ACTIVITY)
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		if timeLast and SoraDGetCastleLv() >= CASTLE_LV10_LIMITED then
			local leftTime = timer.timerNode.timer:getRemainTime()
			clientEventMgr.addEventTimer(gActivityTimeActivityID.WAR_TREASURE_ACTIVITY, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.WAR_TREASURE_ACTIVITY
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.WAR_TREASURE_ACTIVITY, state
			gActivityTimeActivityID.WAR_TREASURE_ACTIVITY.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.WAR_TREASURE_ACTIVITY.timerLast = gActivityTimeActivityID.WAR_TREASURE_ACTIVITY, timeLast
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001243")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001243")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001243.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001243.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY] = function()
		local lang = SoraDGetDefaultLanguage()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY)
		if state == gActivityState.OPEN or state == gActivityState.PREPARE then
			_ENV = gActivityState.PREPARE
			_ENV, gActivityState.PREPARE.eventID = gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY, gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY
			gActivityState.PREPARE.eventLeftTime, gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY.timeType = gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY, "noMsg"
			gActivityState.PREPARE.eventName = i18n("activity_name_9001342")
			gActivityState.PREPARE.eventDes = i18n("activity_name_9001342")
			gActivityState.PREPARE.flagIcon = "icon_activity_9001342.png"
			_UPVALUE2_ = nil
			;(nil)[1] = "ar"
			;(nil)[2] = "en"
			gActivityState.PREPARE.pageBg = SoraDGetImageNameByLang("bg_activity_9001342_%s.png", nil)
			return gActivityState.PREPARE
		end
	end
	;(nil)[gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY] = function()
		local lang = SoraDGetDefaultLanguage()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY)
		if SoraDGetCastleLv() >= CASTLE_LV6_LIMITED and (state == gActivityState.OPEN or state == gActivityState.PREPARE) then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			_ENV, clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY, gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY
			gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY.timerLast = gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY, "common_text_607"
			clientEventMgr.addEventTimer.eventState = state
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001347")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001347")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001347.png"
			clientEventMgr.addEventTimer.pageBg = SoraDFIsRA() and "bg_activity_9001347_ar.png" or "bg_activity_9001347_en.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001573] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001573)
		if state == gActivityState.OPEN or state == gActivityState.PREPARE then
			local endTime = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.NORMAL_ACTIVITY_9001573) - serviceFunctions.systemTime()
			clientEventMgr.addEventTimer(gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, endTime)
			_ENV = clientEventMgr.addEventTimer
			_ENV, clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, gActivityTimeActivityID.NORMAL_ACTIVITY_9001573
			gActivityTimeActivityID.NORMAL_ACTIVITY_9001573.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.NORMAL_ACTIVITY_9001573.timerLast = gActivityTimeActivityID.NORMAL_ACTIVITY_9001573, "common_text_607"
			clientEventMgr.addEventTimer.eventState = state
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001573")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001573")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001573.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001573.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
		;(nil).name = i18n("Glorious_text_01")
		;(nil).des = i18n("Glorious_text_01")
		;(nil).icon = "icon_activity_9001259.png"
		;(nil).bg = "bg_activity_9001259.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.LUXURY_REBATE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.LUXURY_REBATE_ACTIVITY
		;(nil).name = i18n("activity_name_9001264")
		;(nil).des = i18n("activity_name_9001264")
		;(nil).icon = "icon_activity_9001264.png"
		;(nil).bg = "bg_activity_9001264.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY
		;(nil).name = i18n("activity_name_9001262")
		;(nil).des = i18n("activity_name_9001262")
		;(nil).icon = "icon_activity_9001262.png"
		;(nil).bg = "bg_activity_9001262.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY] = function()
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false) then
			_ENV = clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false)
			_ENV, clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false).eventID = gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY
			clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false).eventLeftTime, gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY.timeType = gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, "noMsg"
			clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false).eventName = i18n("activity_name_9001265")
			clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false).eventDes = i18n("activity_name_9001265")
			clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false).flagIcon = "icon_activity_9001265.png"
			clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false).pageBg = "bg_activity_9001265.png"
			return (clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, false))
		end
	end
	;(nil)[gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY
		;(nil).name = i18n("activity_name_9001266")
		;(nil).des = i18n("activity_name_9001266")
		;(nil).icon = "icon_activity_9001266.png"
		;(nil).bg = "bg_activity_9001266.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT
		;(nil).name = i18n("activity_name_9001316")
		;(nil).des = i18n("activity_name_9001316")
		;(nil).icon = "icon_activity_9001316.png"
		;(nil).bg = "bg_activity_9001316.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY
		;(nil).name = i18n("download_first_name")
		;(nil).des = i18n("download_first_name")
		;(nil).icon = "icon_activity_9001322.png"
		;(nil).bg = "bg_activity_9001322.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.RAIDERS_LOST_ARK] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.RAIDERS_LOST_ARK
		;(nil).name = i18n("activity_name_9001270")
		;(nil).des = i18n("activity_name_9001270")
		;(nil).icon = "icon_activity_9001270.png"
		;(nil).bg = "bg_activity_9001270.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.CANYON_TREASURE_HUNT] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CANYON_TREASURE_HUNT
		;(nil).name = i18n("Canyon_Treasur_text_01")
		;(nil).des = i18n("Canyon_Treasur_text_01")
		;(nil).icon = "icon_activity_9001274.png"
		;(nil).bg = "bg_activity_9001274.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.TONGTIAN_TOWER_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.TONGTIAN_TOWER_ACTIVITY
		;(nil).name = i18n("activity_name_9001273")
		;(nil).des = i18n("activity_name_9001273")
		;(nil).icon = "icon_activity_9001273.png"
		;(nil).bg = "bg_activity_9001273.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PRECIOUS_TREASURE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PRECIOUS_TREASURE_ACTIVITY
		;(nil).name = i18n("activity_name_9001272")
		;(nil).des = i18n("activity_name_9001272")
		;(nil).icon = "icon_activity_9001272.png"
		;(nil).bg = "bg_activity_9001272.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.HERO_AWAKE_ACTIVTY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.HERO_AWAKE_ACTIVTY
		;(nil).name = i18n("activity_name_9001303")
		;(nil).des = i18n("activity_name_9001303")
		;(nil).icon = "icon_activity_9001303.png"
		;(nil).bg = "bg_activity_9001303.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY
		;(nil).name = i18n("activity_name_9001365")
		;(nil).des = i18n("activity_name_9001365")
		;(nil).icon = "icon_activity_9001365.png"
		;(nil).bg = "bg_activity_9001365.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityCenterUIEnum.FIVE_ANNIVERSARY] = function()
		local eid = gActivityCenterUIEnum.FIVE_ANNIVERSARY
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(eid)
		if activityShowCtrl:isActivityOpen(eid) then
			_ENV = activityShowCtrl:isActivityOpen(eid)
			activityShowCtrl:isActivityOpen(eid).eventID = eid
			_ENV, activityShowCtrl:isActivityOpen(eid).eventState = activityShowCtrl, state
			activityShowCtrl:isActivityOpen(eid).eventLeftTime, activityShowCtrl.timeType = activityShowCtrl, "noMsg"
			activityShowCtrl:isActivityOpen(eid).eventName = i18n("activity_name_8001017")
			activityShowCtrl:isActivityOpen(eid).eventDes = i18n("activity_name_8001017")
			activityShowCtrl:isActivityOpen(eid).flagIcon = "icon_activity_8001017.png"
			activityShowCtrl:isActivityOpen(eid).pageBg = "bg_activity_8001017.png"
			return (activityShowCtrl:isActivityOpen(eid))
		end
	end
	;(nil)[gActivityCenterUIEnum.SULTAN_BACK] = function()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityCenterUIEnum.SULTAN_BACK)
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		if timeLast then
			_ENV = state
			state.eventID = gActivityCenterUIEnum.SULTAN_BACK
			state.eventState = state
			state.eventName = i18n("activity_name_9001289")
			_ENV, state.eventDes = i18n("activity_name_9001289"), i18n("activity_name_9001289")
			state.eventLeftTime, i18n("activity_name_9001289").timeType = i18n("activity_name_9001289"), "noMsg"
			state.flagIcon = "icon_activity_9001289.png"
			state.pageBg = "bg_activity_9001289.png"
			return state
		end
	end
	;(nil)[gActivityTimeActivityID.RECHARGE_NEW_USER] = function()
		local newFeedbackWeekCtrl = SoraDGetCtrl("newFeedbackWeekCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.RECHARGE_NEW_USER)
		local timeFactory = function(ticket)
			if state == gActivityState.PREPARE then
				state = nil
				;(nil).time = ticket
				return i18n("common_text_606", nil)
			end
			local nextTime = newFeedbackWeekCtrl:getNextResetTime()
			if nextTime and nextTime > serviceFunctions.systemTime() then
				ticket = SoraDConvertSecondToString(nextTime - serviceFunctions.systemTime())
			end
			state = nil
			;(nil).time = ticket
			return i18n(nextTime > serviceFunctions.systemTime() and "common_text_607" or "common_text_606", nil)
		end
		local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.RECHARGE_NEW_USER)
		if timer then
			clientEventMgr.addEventTimer(gActivityTimeActivityID.RECHARGE_NEW_USER, timer.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityCenterUIEnum.RECHARGE_NEW_USER
			clientEventMgr.addEventTimer.eventState = state
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001294")
			_ENV, clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001294"), " "
			i18n("activity_name_9001294").timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, i18n("activity_name_9001294").timerFun = i18n("activity_name_9001294"), timeFactory
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001294.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001294.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local State = activityShowCtrl:getStateByID(gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY)
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY)
		local isOpen = false
		local leftTime = 0
		dump("馈赠好礼", State)
		if gActivityState.OPEN == State or gActivityState.PREPARE == State then
			isOpen = true
		end
		local lastFunc = function()
			print("馈赠好礼时间到")
			_ENV = "馈赠好礼时间到"
			;("馈赠好礼时间到").msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			;("馈赠好礼时间到").eventID = gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY
			SoraDSendMessage("馈赠好礼时间到")
		end
		if 0 < leftTime then
			_ENV = nil
			;(nil).lastFun = lastFunc
			clientEventMgr.addEventTimer(gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY, leftTime, nil)
		end
		print("馈赠好礼", isOpen, leftTime)
		local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY)
		if isOpen and eventTime then
			clientEventMgr.addEventTimer(gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY, eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			_ENV, clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY, gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY
			gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY.timeType = "showTime"
			gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY.timerLast = "common_text_607"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY.lastFun = gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY, lastFunc
			clientEventMgr.addEventTimer.eventState = State
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001293")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001293")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001293.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001293.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.TRAIN_POWER_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local State = activityShowCtrl:getStateByID(gActivityTimeActivityID.TRAIN_POWER_ACTIVITY)
		dump("养精蓄锐", State)
		if gActivityState.OPEN == State then
			_ENV = "养精蓄锐"
			;("养精蓄锐").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			;("养精蓄锐").eventID = gActivityTimeActivityID.TRAIN_POWER_ACTIVITY
			SoraDSendMessage("养精蓄锐")
			_ENV = SoraDSendMessage
			_ENV, SoraDSendMessage.eventID = gActivityTimeActivityID.TRAIN_POWER_ACTIVITY, gActivityTimeActivityID.TRAIN_POWER_ACTIVITY
			SoraDSendMessage.eventLeftTime, gActivityTimeActivityID.TRAIN_POWER_ACTIVITY.timeType = gActivityTimeActivityID.TRAIN_POWER_ACTIVITY, "noMsg"
			SoraDSendMessage.eventState = State
			SoraDSendMessage.eventName = i18n("activity_name_9001300")
			SoraDSendMessage.eventDes = ""
			SoraDSendMessage.flagIcon = "icon_activity_9001300.png"
			SoraDSendMessage.pageBg = "bg_activity_9001300.png"
			return SoraDSendMessage
		end
	end
	;(nil)[gActivityTimeActivityID.LOST_RUINS_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.LOST_RUINS_ACTIVITY
		;(nil).name = i18n("activity_name_9001301")
		;(nil).des = i18n("activity_name_9001301")
		;(nil).icon = "icon_activity_9001301.png"
		;(nil).bg = "bg_activity_9001301.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.MAGICAL_DOMINO] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.MAGICAL_DOMINO
		;(nil).name = i18n("activity_name_9001302")
		;(nil).des = ""
		;(nil).icon = "icon_activity_9001302.png"
		;(nil).bg = "bg_activity_9001302.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ORIENT_PRINCE_GIFT] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
		local princeGiftStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
		if princeGiftStatus == gActivityState.OPEN then
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.ORIENT_PRINCE_GIFT, _eventTime.timerNode.timer:getRemainTime())
			if param.phase == 2 then
				_ENV = param.phase
				param.phase.eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
				_ENV, param.phase.eventState = gActivityTimeActivityID.ORIENT_PRINCE_GIFT, princeGiftStatus
				gActivityTimeActivityID.ORIENT_PRINCE_GIFT.timeType = "showTime"
				param.phase.eventLeftTime, gActivityTimeActivityID.ORIENT_PRINCE_GIFT.timerLast = gActivityTimeActivityID.ORIENT_PRINCE_GIFT, "common_text_607"
				param.phase.eventName = i18n("Wisdom_of_oriental_prince_text_01")
				param.phase.eventDes = i18n("Wisdom_of_oriental_prince_text_01")
				param.phase.flagIcon = "icon_activity_9001317.png"
				param.phase.pageBg = "bg_activity_9001317.png"
				return param.phase
			elseif param.phase == 1 then
				_ENV = param.phase
				param.phase.eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
				_ENV, param.phase.eventState = gActivityTimeActivityID.ORIENT_PRINCE_GIFT, princeGiftStatus
				param.phase.eventLeftTime, gActivityTimeActivityID.ORIENT_PRINCE_GIFT.timeType = gActivityTimeActivityID.ORIENT_PRINCE_GIFT, "noMsg"
				param.phase.eventName = i18n("Wisdom_of_oriental_prince_text_01")
				param.phase.eventDes = i18n("Wisdom_of_oriental_prince_text_01")
				param.phase.flagIcon = "icon_activity_9001317.png"
				param.phase.pageBg = "bg_activity_9001317.png"
				return param.phase
			end
		elseif princeGiftStatus == gActivityState.PREPARE then
			local timerLast = "common_text_606"
			local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ORIENT_PRINCE_GIFT)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.ORIENT_PRINCE_GIFT, _eventTime.timerNode.timer:getRemainTime())
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityState.PREPARE, gActivityState.PREPARE
			gActivityState.PREPARE.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityState.PREPARE.timerLast = gActivityState.PREPARE, "common_text_606"
			clientEventMgr.addEventTimer.eventName = i18n("Wisdom_of_oriental_prince_text_01")
			clientEventMgr.addEventTimer.eventDes = i18n("Wisdom_of_oriental_prince_text_01")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001317.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001317.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.CHANGE_DAY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.CHANGE_DAY_ACTIVITY
		;(nil).name = i18n("activity_name_9001320")
		;(nil).des = i18n("activity_name_9001320")
		;(nil).icon = "icon_activity_9001320.png"
		;(nil).bg = "bg_activity_9001320.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local planThoroughCtrl = gametop.playertop_:getModule("planThoroughCtrl")
		local Status = activityShowCtrl:getStateByID(gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY)
		local planThoroughCtrlStatus = planThoroughCtrl:getActivityStatus()
		if planThoroughCtrlStatus == gKingRisesActivityStatus.OPEN then
			local remainEndTime = planThoroughCtrl:getCloseTime()
			clientEventMgr.addEventTimer(gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY, remainEndTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY
			_ENV, clientEventMgr.addEventTimer.eventState = gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY, Status
			gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY.timerLast = gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY, "common_text_607"
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001319")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001319")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001319.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001319.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY
		;(nil).name = i18n("activity_name_9001337")
		;(nil).des = i18n("activity_name_9001337")
		;(nil).icon = "icon_activity_9001337.png"
		;(nil).bg = "bg_activity_9001337.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.STAR_MOON_TREASURE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.STAR_MOON_TREASURE_ACTIVITY
		;(nil).name = i18n("activity_name_9001341")
		;(nil).des = i18n("activity_name_9001341")
		;(nil).icon = "icon_activity_9001341.png"
		;(nil).bg = "bg_activity_9001341.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.ATLANTIS_PRIVILEGE_ACTIVITY] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.ATLANTIS_PRIVILEGE_ACTIVITY
		;(nil).name = i18n("activity_name_9001350")
		;(nil).des = i18n("activity_name_9001350")
		;(nil).icon = "icon_activity_9001350.png"
		;(nil).bg = "bg_activity_9001350.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS] = function(activityID)
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local info = activityShowCtrl:getActivityData(activityID)
		local castleLv = info.castleLv or 0
		if castleLv <= SoraDGetCastleLv() then
			return addNormalEvent_new(activityID)
		end
	end
	;(nil)[gActivityTimeActivityID.BUBBLE_REWARD_ACTIVITY] = function(activityID)
		return addNormalEvent_new(activityID, nil, true)
	end
	;(nil)[gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY] = function(activityID)
		local activityStatus = SoraDGetCtrl("activityShowCtrl"):getStateByID(gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY)
		if gActivityState.OPEN == activityStatus then
			local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
			local curState = atlantisActivityCtrl:getActivityCurState()
			local _eventTime = atlantisActivityCtrl:getStageEndTime() - serviceFunctions.systemTime()
			print("_eventTime", _eventTime, curState)
			clientEventMgr.addEventTimer(gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY, _eventTime)
			local season = atlantisActivityCtrl:getSeason()
			local eventName = "S" .. season .. i18n("activity_name_9001366")
			_ENV = season
			season.eventID = gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY
			_ENV, season.eventState = gActivityState.OPEN, gActivityState.OPEN
			gActivityState.OPEN.timeType = "showTime"
			_ENV = nil
			;(nil).var = season
			season.eventLeftTime, gActivityState.OPEN.timerLast = gActivityState.OPEN, i18n("atlantiswar_text_0035", nil)
			season.eventName = eventName
			season.eventDes = eventName
			season.flagIcon = "icon_activity_9001366.png"
			season.pageBg = "bg_activity_9001366.png"
			return season
		end
	end
	;(nil)[gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY] = function()
		local bgName = SoraDFIsRA() and "bg_activity_9001425_ar.png" or "bg_activity_9001425_en.png"
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY
		;(nil).name = i18n("activity_name_9001425")
		;(nil).des = i18n("activity_name_9001425")
		;(nil).icon = "icon_activity_9001425.png"
		;(nil).bg = bgName
		return clientEventMgr.addNormalEvent(nil)
	end
	;(nil)[gActivityTimeActivityID.IRON_BLOOD_ACTIVITY] = function()
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.IRON_BLOOD_ACTIVITY)
		if state == gActivityState.OPEN then
			_ENV = gActivityState.OPEN
			_ENV, gActivityState.OPEN.eventID = gActivityTimeActivityID.IRON_BLOOD_ACTIVITY, gActivityTimeActivityID.IRON_BLOOD_ACTIVITY
			gActivityState.OPEN.eventLeftTime, gActivityTimeActivityID.IRON_BLOOD_ACTIVITY.timeType = gActivityTimeActivityID.IRON_BLOOD_ACTIVITY, "noMsg"
			gActivityState.OPEN.eventState = state
			gActivityState.OPEN.eventName = i18n("activity_name_9001355")
			gActivityState.OPEN.eventDes = i18n("activity_name_9001355")
			gActivityState.OPEN.flagIcon = "icon_activity_9001355.png"
			gActivityState.OPEN.pageBg = "bg_activity_9001355.png"
			return gActivityState.OPEN
		end
	end
	;(nil)[gActivityTimeActivityID.WISE_TUTOR_ACTIVITY] = function(activityID)
		local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
		local state, time = wiseTutorCtrl:getStateInfo()
		if state == gActivityState.OPEN then
			clientEventMgr.addEventTimer(activityID, time)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = activityID
			_ENV, clientEventMgr.addEventTimer.eventState = activityID, state
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerLast = activityID, "common_text_607"
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001368")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001368")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001368.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001368.png"
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY] = function()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY)
		print(state, "ARMYEXCHANGE_ACTIVITY")
		local timeLast = clientEventMgr.judgeIsOnShow(state)
		if timeLast then
			_ENV = state
			state.eventID = gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY
			state.eventState = state
			state.eventName = i18n("armyExchange_text_025")
			_ENV, state.eventDes = i18n("armyExchange_text_025"), i18n("armyExchange_text_025")
			state.eventLeftTime, i18n("armyExchange_text_025").timeType = i18n("armyExchange_text_025"), "noMsg"
			state.flagIcon = "icon_activity_bzzh.png"
			state.pageBg = "bg_bzzh_ditu.png"
			return state
		end
	end
	;(nil)[gActivityTimeActivityID.FROSTY_MARKET] = function(activityID)
		local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
		local skin = activity_9001678_Ctrl:getSkin()
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(activityID)
		if state ~= gActivityState.CLOSE then
			local _eventTime = activityShowCtrl:getTimeInfoByID(activityID)
			clientEventMgr.addEventTimer(activityID, _eventTime.timerNode.timer:getRemainTime())
			local _eventLast = clientEventMgr.judgeIsOnShow(state)
			_ENV = state
			_ENV, state.eventID = _eventTime.timerNode.timer:getRemainTime()
			_eventTime.timerNode.timer:getRemainTime().timeType = "showTime"
			state.eventLeftTime, _eventTime.timerNode.timer:getRemainTime().timerLast = _eventTime.timerNode.timer:getRemainTime()
			state.eventState = state
			state.eventName = skin == 2 and i18n("activity_name_9001714") or i18n("activity_name_9001678")
			state.eventDes = skin == 2 and i18n("activity_name_9001714") or i18n("activity_name_9001678")
			state.flagIcon = skin == 2 and "icon_activity_9001714.png" or "icon_activity_9001678.png"
			state.pageBg = skin == 2 and "bg_activity_9001714.png" or "bg_activity_9001678.png"
			return state
		end
	end
	;(nil)[gActivityTimeActivityID.DEADLY_HUNTING_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local _eventState = activityShowCtrl:getStateByID(activityID)
		local param = activityShowCtrl:getParamByID(activityID)
		local _classtype = param.classtype
		if _eventState == gActivityState.OPEN then
			_ENV = gActivityState.OPEN
			_ENV, gActivityState.OPEN.eventID = nil, activityID
			gActivityState.OPEN.eventLeftTime, (nil).timeType = nil, "noMsg"
			gActivityState.OPEN.eventState = _eventState
			gActivityState.OPEN.eventName = i18n(activityTimeRead.getActivityNameByID(activityID, _classtype))
			gActivityState.OPEN.eventDes = activityTimeRead.getActivityDesByID(activityID, _classtype)
			gActivityState.OPEN.flagIcon = activityTimeRead.getActivityIconByID(activityID, _classtype)
			gActivityState.OPEN.pageBg = activityTimeRead.getActivityBgByID(activityID, _classtype)
			return gActivityState.OPEN
		end
	end
	;(nil)[gActivityTimeActivityID.BLACK_GHOST_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local _eventState = activityShowCtrl:getStateByID(activityID)
		local param = activityShowCtrl:getParamByID(activityID)
		local _classtype = param.classtype
		if _eventState == gActivityState.OPEN then
			_ENV = gActivityState.OPEN
			_ENV, gActivityState.OPEN.eventID = nil, activityID
			gActivityState.OPEN.eventLeftTime, (nil).timeType = nil, "noMsg"
			gActivityState.OPEN.eventState = _eventState
			gActivityState.OPEN.eventName = i18n(activityTimeRead.getActivityNameByID(activityID, _classtype))
			gActivityState.OPEN.eventDes = activityTimeRead.getActivityDesByID(activityID, _classtype)
			gActivityState.OPEN.flagIcon = activityTimeRead.getActivityIconByID(activityID, _classtype)
			gActivityState.OPEN.pageBg = activityTimeRead.getActivityBgByID(activityID, _classtype)
			return gActivityState.OPEN
		end
	end
	;(nil)[gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY] = function(activityID)
		local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(activityID)
		local _eventState = activityShowCtrl:getStateByID(activityID)
		if _eventState == gActivityState.OPEN and (not (not (SoraDGetCastleLv() >= param.limitMinLevel) or artisanHouseCtrl:isMaxLevel()) or artisanHouseCtrl:isActOpen()) then
			return addNormalEvent_new(activityID)
		end
	end
	;(nil)[gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY] = function(activityID)
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		if newStartMainCtrl:checkIsInherit() then
			return addNormalEvent_new(activityID)
		end
	end
	;(nil)[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local activityStatus = activityShowCtrl:getStateByID(activityID)
		if gActivityState.CLOSE ~= activityStatus then
			local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
			local curState = nebulaActivityCtrl:getActivityCurState()
			local remainTime = 0
			local timerLast = ""
			if activityStatus == gActivityState.PREPARE and curState == NEBULA_REGION_STATE.FINISH then
				local _eventTime = activityShowCtrl:getTimeInfoByID(activityID)
				remainTime = _eventTime.timerNode.timer:getRemainTime()
				timerLast = "common_text_606"
			else
				local nebulaWarUtil = include("nebulaWarUtil")
				local endTime = nebulaWarUtil.getStateEndTime(curState)
				remainTime = endTime - serviceFunctions.systemTime()
				local stateName = nebulaWarUtil.getEventCenterStateName(curState)
				timerLast = stateName .. "%{time}"
			end
			clientEventMgr.addEventTimer(activityID, remainTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = activityID
			_ENV, clientEventMgr.addEventTimer.eventState = activityID, activityStatus
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerLast = activityID, timerLast
			clientEventMgr.addEventTimer.eventName = i18n(activityTimeRead.getActivityNameByID(activityID))
			clientEventMgr.addEventTimer.eventDes = activityTimeRead.getActivityDesByID(activityID)
			clientEventMgr.addEventTimer.flagIcon = activityTimeRead.getActivityIconByID(activityID)
			clientEventMgr.addEventTimer.pageBg = activityTimeRead.getActivityBgByID(activityID)
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY] = function(activityID)
		local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(activityID)
		local _eventState = activityShowCtrl:getStateByID(activityID)
		if (_eventState == gActivityState.OPEN or _eventState == gActivityState.PREPARE) and (not (not (SoraDGetBuildStarLv() >= param.limitMinLevel) or radiantDecreeCtrl:isMaxLevel()) or radiantDecreeCtrl:isActOpen()) then
			return addNormalEvent_new(activityID)
		end
	end
	;(nil)[gActivityTimeActivityID.SUPREMACY_ROAD_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local nebulaWarUtil = include("nebulaWarUtil")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local _eventState = activityShowCtrl:getStateByID(activityID)
		local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
		if _eventLast then
			local _eventTime = nebulaWarUtil.getSupremacyRoadRemainTime()
			clientEventMgr.addEventTimer(activityID, _eventTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = activityID
			_ENV, clientEventMgr.addEventTimer.eventState = activityID, _eventState
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerLast = activityID, _eventLast
			clientEventMgr.addEventTimer.eventName = i18n(activityTimeRead.getActivityNameByID(activityID))
			clientEventMgr.addEventTimer.flagIcon = activityTimeRead.getActivityIconByID(activityID)
			clientEventMgr.addEventTimer.pageBg = activityTimeRead.getActivityBgByID(activityID)
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.NEBULA_KING_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		if not activityTimeRead.checkActivityShowLevel(activityID) then
			return
		end
		local activityData = activityShowCtrl:getActivityData(activityID)
		local state = activityShowCtrl:getStateByID(activityID)
		local _eventLast
		local leftTime = 100
		local stageName
		local curTime = serviceFunctions.systemTime()
		local _eventState = state
		if gActivityState.PREPARE == state then
			_eventLast = "common_text_606"
			leftTime = activityData.begintime - curTime
		elseif gActivityState.OPEN == state then
			if activityData.doStage < #activityData.stagetimes then
				local nebulaKingCtrl = SoraDGetCtrl("nebulaKingCtrl")
				stageName = i18n(nebulaKingCtrl:getCurrentStageName())
				_eventLast = "Nebulaking_text_20"
				local _, stageEndTime = nebulaKingCtrl:getStageTime()
				leftTime = stageEndTime - curTime
			else
				_eventState = gActivityState.CALCULATE
				_eventLast = "Nebulaking_text_21"
				leftTime = activityData.endtime - curTime
			end
		end
		if _eventLast then
			clientEventMgr.addEventTimer(activityID, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = activityID
			_ENV, clientEventMgr.addEventTimer.eventState = activityID, _eventState
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerFun = activityID, function(tick)
				_ENV = nil
				;(nil).name = stageName
				;(nil).time = tick
				return i18n(_eventLast, nil)
			end
			clientEventMgr.addEventTimer.eventName = i18n(activityTimeRead.getActivityNameByID(activityID))
			clientEventMgr.addEventTimer.flagIcon = activityTimeRead.getActivityIconByID(activityID)
			clientEventMgr.addEventTimer.pageBg = activityTimeRead.getActivityBgByID(activityID)
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		if not activityTimeRead.checkActivityShowLevel(activityID) then
			return
		end
		local activityData = activityShowCtrl:getActivityData(activityID)
		local state = activityShowCtrl:getStateByID(activityID)
		local _eventLast
		local leftTime = 100
		local stageName
		local curTime = serviceFunctions.systemTime()
		local _eventState = state
		if gActivityState.PREPARE == state then
			_eventLast = "common_text_606"
			leftTime = activityData.begintime - curTime
		elseif gActivityState.OPEN == state then
			if activityData.doStage < #activityData.stagetimes then
				local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
				stageName = i18n(nebulaCompetitionCtrl:getCurrentStageName())
				_eventLast = "Nebulaking_text_20"
				local _, stageEndTime = nebulaCompetitionCtrl:getStageTime()
				leftTime = stageEndTime - curTime
			else
				_eventState = gActivityState.CALCULATE
				_eventLast = "Nebulaking_text_21"
				leftTime = activityData.endtime - curTime
			end
		end
		if _eventLast then
			clientEventMgr.addEventTimer(activityID, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = activityID
			_ENV, clientEventMgr.addEventTimer.eventState = activityID, _eventState
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerFun = activityID, function(tick)
				_ENV = nil
				;(nil).name = stageName
				;(nil).time = tick
				return i18n(_eventLast, nil)
			end
			clientEventMgr.addEventTimer.eventName = i18n(activityTimeRead.getActivityNameByID(activityID))
			clientEventMgr.addEventTimer.flagIcon = activityTimeRead.getActivityIconByID(activityID)
			clientEventMgr.addEventTimer.pageBg = activityTimeRead.getActivityBgByID(activityID)
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001577] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		if not activityTimeRead.checkActivityShowLevel(activityID) then
			return
		end
		local activityData = activityShowCtrl:getActivityData(activityID)
		local state = activityShowCtrl:getStateByID(activityID)
		local _eventLast
		local leftTime = 100
		local stageName
		local curTime = serviceFunctions.systemTime()
		local _eventState = state
		if gActivityState.PREPARE == state then
			_eventLast = "common_text_606"
			leftTime = activityData.begintime - curTime
		elseif gActivityState.OPEN == state then
			if activityData.doStage < #activityData.stagetimes then
				local activity_9001577_Ctrl = SoraDGetCtrl("activity_9001577_Ctrl")
				stageName = i18n(activity_9001577_Ctrl:getCurrentStageName())
				_eventLast = "Nebulaking_text_20"
				local _, stageEndTime = activity_9001577_Ctrl:getStageTime()
				leftTime = stageEndTime - curTime
			else
				_eventState = gActivityState.CALCULATE
				_eventLast = "Nebulaking_text_21"
				leftTime = activityData.endtime - curTime
			end
		end
		if _eventLast then
			clientEventMgr.addEventTimer(activityID, leftTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = activityID
			_ENV, clientEventMgr.addEventTimer.eventState = activityID, _eventState
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerFun = activityID, function(tick)
				_ENV = nil
				;(nil).name = stageName
				;(nil).time = tick
				return i18n(_eventLast, nil)
			end
			clientEventMgr.addEventTimer.eventName = i18n(activityTimeRead.getActivityNameByID(activityID))
			clientEventMgr.addEventTimer.flagIcon = activityTimeRead.getActivityIconByID(activityID)
			clientEventMgr.addEventTimer.pageBg = activityTimeRead.getActivityBgByID(activityID)
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.COMMAND_HALL_ACTIVITY] = function(activityID)
		local ret = addNormalEvent_new(activityID)
		if ret then
			addNormalEvent_new = activityID
			ret.eventLeftTime, activityID.timeType = activityID, "noMsg"
		end
		return ret
	end
	;(nil)[gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY] = function(activityID)
		local footballKingCtrl = SoraDGetCtrl("footballKingCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local curDay = footballKingCtrl:getCurDay()
		local _eventTime = activityShowCtrl:getTimeInfoByID(activityID)
		local State = activityShowCtrl:getStateByID(activityID)
		print("curDay-1", curDay, State, activityID)
		if gActivityState.OPEN == State then
			local lastTime = activityShowCtrl:getEndTimeSecond(activityID) - serviceFunctions.systemTime()
			clientEventMgr.addEventTimer(activityID, lastTime)
			_ENV = clientEventMgr.addEventTimer
			clientEventMgr.addEventTimer.eventID = activityID
			_ENV, clientEventMgr.addEventTimer.eventState = activityID, State
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerLast = activityID, "common_text_4415"
			clientEventMgr.addEventTimer.eventName = i18n("activity_name_9001472")
			clientEventMgr.addEventTimer.eventDes = i18n("activity_name_9001472")
			clientEventMgr.addEventTimer.flagIcon = "icon_activity_9001472.png"
			clientEventMgr.addEventTimer.pageBg = "bg_activity_9001472.png"
			return clientEventMgr.addEventTimer
		else
			return addNormalEvent_new(activityID)
		end
	end
	;(nil)[gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		if not activityTimeRead.checkActivityShowLevel(activityID) then
			return
		end
		local _eventState = activityShowCtrl:getStateByID(activityID)
		local _eventLast
		local leftTime = 0
		if gActivityState.PREPARE == _eventState then
			_eventLast = "common_text_606"
			local beginTime = activityShowCtrl:getBeginTimeSecond(activityID)
			leftTime = beginTime - serviceFunctions.systemTime()
			local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
			if activity_9001479_Ctrl:checkIsSpecial() then
				leftTime = activity_9001479_Ctrl:getStageRemainTime(5)
			end
		elseif gActivityState.OPEN == _eventState then
			local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
			local curRound = activity_9001479_Ctrl:getCurRound()
			if curRound <= 0 then
				_eventLast = "common_text_606"
			elseif 4 < curRound then
				_eventLast = "common_text_607"
			else
				_eventLast = "camp_integral_27"
			end
			leftTime = activity_9001479_Ctrl:getStageRemainTime()
			if activity_9001479_Ctrl:checkIsSpecial() and curRound <= 1 then
				_eventLast = "common_text_606"
				_eventState = gActivityState.PREPARE
				leftTime = activity_9001479_Ctrl:getStageRemainTime(5)
			end
		end
		if _eventLast then
			clientEventMgr.addEventTimer(activityID, leftTime)
			_ENV = clientEventMgr.addEventTimer
			_ENV, clientEventMgr.addEventTimer.eventID = activityID, activityID
			activityID.timeType = "showTime"
			clientEventMgr.addEventTimer.eventLeftTime, activityID.timerLast = activityID, _eventLast
			clientEventMgr.addEventTimer.eventState = _eventState
			clientEventMgr.addEventTimer.eventName = i18n(activityTimeRead.getActivityNameByID(activityID))
			clientEventMgr.addEventTimer.flagIcon = activityTimeRead.getActivityIconByID(activityID)
			clientEventMgr.addEventTimer.pageBg = activityTimeRead.getActivityBgByID(activityID)
			return clientEventMgr.addEventTimer
		end
	end
	;(nil)[gActivityTimeActivityID.EXTREMELY_SKILLFUIL] = function(activityID)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local limitLevel = activityShowCtrl:getParamByID(activityID)
		local nowLv = SoraDGetCastleLv()
		if limitLevel and nowLv >= (limitLevel.limitMinLevel or 9999) and nowLv <= (limitLevel.limitMaxLevel or 0) then
			return addNormalEvent_new(activityID)
		end
	end
	;(nil)[gActivityTimeActivityID.NEBULA_EMPEROR_SHOW_ACTIVITY] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(activityID)
		local _classtype = param.classtype
		local _eventState = activityShowCtrl:getStateByID(activityID)
		local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
		if _eventLast then
			_ENV = _eventState
			_ENV, _eventState.eventID = nil, activityID
			;(nil).timeType = "showMsg"
			_eventState.eventLeftTime, (nil).timerMsg = nil, i18n("Community_text_0011")
			_eventState.eventState = _eventState
			_eventState.eventName = i18n(activityTimeRead.getActivityNameByID(activityID, _classtype))
			_eventState.eventDes = i18n("Community_text_0011")
			_eventState.flagIcon = activityTimeRead.getActivityIconByID(activityID, _classtype)
			_eventState.pageBg = activityTimeRead.getActivityBgByID(activityID, _classtype)
			return _eventState
		end
	end
	;(nil)[gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY] = function(activityID)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local cfg = addNormalEvent_new(activityID)
		if not cfg then
			return
		end
		local _eventLeftTime
		local curState = activityShowCtrl:getParamCurState(activityID)
		if curState == ACTIVITY_STATE.PREPARE then
			_ENV = ACTIVITY_STATE.PREPARE
			ACTIVITY_STATE.PREPARE.timeType = "showTime"
			_eventLeftTime, ACTIVITY_STATE.PREPARE.timerLast = ACTIVITY_STATE.PREPARE, "common_text_606"
		elseif curState == ACTIVITY_STATE.ACTIVE then
			_ENV = ACTIVITY_STATE.ACTIVE
			ACTIVITY_STATE.ACTIVE.timeType = "showTime"
			_eventLeftTime, ACTIVITY_STATE.ACTIVE.timerLast = ACTIVITY_STATE.ACTIVE, "nebulaemperor_text_1"
		elseif curState == ACTIVITY_STATE.SETTLE then
			_ENV = ACTIVITY_STATE.SETTLE
			ACTIVITY_STATE.SETTLE.timeType = "showTime"
			_eventLeftTime, ACTIVITY_STATE.SETTLE.timerLast = ACTIVITY_STATE.SETTLE, "common_text_4415"
			cfg.eventName = i18n("nebulaemperor_text_23")
		end
		if _eventLeftTime then
			cfg.eventLeftTime = _eventLeftTime
		end
		return cfg
	end
	;(nil)[gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY] = function(activityID)
		local ret = addNormalEvent_new(activityID)
		if ret then
			addNormalEvent_new = activityID
			ret.eventLeftTime, activityID.timeType = activityID, "noMsg"
		end
		local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
		if beastCanyonCtrl:checkActivityShow(activityID) then
			return ret
		end
	end
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001650] = function(activityID)
		local ret = addNormalEvent_new(activityID)
		if ret then
			addNormalEvent_new = activityID
			ret.eventLeftTime, activityID.timeType = activityID, "noMsg"
		end
		local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
		if beastCanyonCtrl:checkActivityShow(activityID) then
			return ret
		end
	end
	;(nil)[gActivityTimeActivityID.NEBULA_SURPRISED_DROP] = function(activityID)
		local activityTimeRead = include("activityTimeRead")
		if not activityTimeRead.checkActivityShowLevel(activityID) then
			return
		end
		local storeActivityID = gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local _eventState = activityShowCtrl:getStateByID(storeActivityID)
		local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
		if _eventLast then
			local remainTime = activityShowCtrl:getRemainTime(storeActivityID)
			clientEventMgr.addEventTimer(activityID, remainTime)
			local cfg = activityTimeRead.getNormalEventConfig(activityID)
			_ENV = activityID
			activityID.eventID = activityID
			_ENV, activityID.eventState = remainTime, _eventState
			remainTime.timeType = "showTime"
			activityID.eventLeftTime, remainTime.timerLast = remainTime, _eventLast
			activityID.eventName = cfg.name
			activityID.eventDes = cfg.des
			activityID.flagIcon = cfg.icon
			activityID.pageBg = cfg.bg
			activityID.flipBg = cfg.flipBg
			activityID.noPage = cfg.noPage
			return activityID
		end
	end
	;(nil)[gActivityTimeActivityID.PHOENIX_ARRIVAL] = function(activityID)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local activityData = activityShowCtrl:getActivityData(activityID)
		local doStage = activityData.doStage
		if not doStage or doStage ~= 0 then
			return
		end
		local cfg = addNormalEvent_new(activityID)
		if not cfg then
			return
		end
		local _eventState = activityShowCtrl:getStateByID(activityID)
		local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
		cfg.eventLeftTime.timerLast = _eventLast
		return cfg
	end
	;(nil)[gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY] = function(activityID)
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local curState = roaringFlameWarCtrl:getCurState()
		print("curState=====", curState)
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
		if not timerLast then
			return
		end
		local cfg = addNormalEvent_new(activityID)
		if not cfg then
			return
		end
		if not cfg.eventLeftTime then
			local _ENV, eventLeftTime = cfg.eventLeftTime, cfg.eventLeftTime
		end
		eventLeftTime.timerLast = timerLast
		local remainTime = roaringFlameWarCtrl:getStateRemainTime(curState)
		if 0 < remainTime and curState < ROARING_FLAME_WAR_STATE.FINISH then
			clientEventMgr.addEventTimer(activityID, remainTime)
		end
		return cfg
	end
	;(nil)[gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716] = function()
		_ENV = nil
		;(nil).eid = gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716
		;(nil).name = i18n("activity_name_9001716")
		;(nil).des = i18n("activity_name_9001716")
		;(nil).icon = "icon_activity_9001716.png"
		;(nil).bg = "activity_bg_9001716.png"
		return clientEventMgr.addNormalEvent(nil)
	end
	_UPVALUE42_, clientEventMgr.eventFuncList, (nil)[gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY] = clientEventMgr, nil, function(activityID)
		if not commonCheck.SIMULATED_DRILL then
			return
		end
		local constantRead = include("constantRead")
		local serviceDay = constantRead.getConstValue("SIMULATED_DRILL_SWITCH_SERVICE_TIME", 90)
		local serviceTime = serviceDay * 3600 * 24
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		local passTime = kingdomMapCtrl:getKingdomPassTime()
		if serviceTime > passTime then
			return
		end
		local activityTimeRead = include("activityTimeRead")
		if not activityTimeRead.checkActivityShowLevel(activityID) then
			return
		end
		local cfg = activityTimeRead.getNormalEventConfig(activityID)
		_ENV = activityID
		activityID.eventID = activityID
		_ENV, activityID.eventState = gActivityState.OPEN, gActivityState.OPEN
		activityID.eventLeftTime, gActivityState.OPEN.timeType = gActivityState.OPEN, "noMsg"
		activityID.eventName = cfg.name
		activityID.flagIcon = cfg.icon
		activityID.pageBg = cfg.bg
		activityID.noPage = cfg.noPage
		return activityID
	end
	clientEventMgr[1] = gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY
	clientEventMgr[2] = gActivityTimeActivityID.STAR_RHAPSODY
	clientEventMgr[3] = gActivityTimeActivityID.RAMADAN_RHAPSODY
	clientEventMgr[4] = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	clientEventMgr[5] = gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	clientEventMgr[6] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001695
	clientEventMgr[7] = gActivityTimeActivityID.GLORY_ROAD_ACTIVITY
	clientEventMgr[8] = gActivityTimeActivityID.GROOM_HORSES_AND_TROOPS
	clientEventMgr[9] = gActivityTimeActivityID.SINBAD_TREASURE
	clientEventMgr[10] = gActivityTimeActivityID.LUCKY_FALCON
	clientEventMgr[11] = gActivityTimeActivityID.MERCHANT_OF_SERICA
	clientEventMgr[12] = gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597
	clientEventMgr[13] = gActivityTimeActivityID.KOH_MIGRATE
	clientEventMgr[14] = gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY
	clientEventMgr[15] = gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY
	clientEventMgr[16] = gActivityTimeActivityID.GOLD_SOUK_ACTIVITY
	clientEventMgr[17] = gActivityTimeActivityID.STARLIGHT_PAVILION_ACTIVITY
	clientEventMgr[18] = gActivityTimeActivityID.SIGN_REWARD_9001576_ACTIVITY
	clientEventMgr[19] = gActivityTimeActivityID.SHEEP_RUN_ACTIVITY
	clientEventMgr[20] = gActivityTimeActivityID.SMELT_ACTIVITY
	clientEventMgr[21] = gActivityTimeActivityID.MERMAID_GIFT_ACTIVITY
	clientEventMgr[22] = gActivityTimeActivityID.EARTH_TREASURE_ACTIVITY
	clientEventMgr[23] = gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY
	clientEventMgr[24] = gActivityTimeActivityID.DESERT_TREASURE_ACTIVITY
	clientEventMgr[25] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001654
	clientEventMgr[26] = gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY
	clientEventMgr[27] = gActivityTimeActivityID.WASTELAND
	clientEventMgr[28] = gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY
	clientEventMgr[29] = gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY
	clientEventMgr[30] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001602
	clientEventMgr[31] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
	clientEventMgr[32] = gActivityTimeActivityID.MAGIC_LAMP_SKILL_SHELTER_ACTIVITY
	clientEventMgr[33] = gActivityTimeActivityID.HERO_ADVANCE_SKILL_CRIT_ACTIVITY
	clientEventMgr[34] = gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE
	clientEventMgr[35] = gActivityTimeActivityID.NEBULA_SIGN_ACTIVITY
	clientEventMgr[36] = gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY
	clientEventMgr[37] = gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY
	clientEventMgr[38] = gActivityTimeActivityID.STARRY_NIGHT_JOURNEY
	clientEventMgr[39] = gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL
	clientEventMgr[40] = gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY
	clientEventMgr[41] = gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY
	clientEventMgr[42] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001628
	clientEventMgr[43] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001629
	clientEventMgr[44] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001624
	clientEventMgr[45] = gActivityTimeActivityID.NEBULA_DISNEYLADN
	clientEventMgr[46] = gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY
	clientEventMgr[47] = gActivityTimeActivityID.NEBULA_PRIVILEGE
	clientEventMgr[48] = gActivityTimeActivityID.DESERT_UNDERGROUND_CITY_ACTIVITY
	clientEventMgr[49] = gActivityTimeActivityID.MONSTER_INVASION_ACTIVITY
	clientEventMgr[50] = gActivityTimeActivityID.STAR_TREASURY_ACTIVITY
	clientEventMgr[51] = gActivityTimeActivityID.STAR_LAMP_CEREMONY_ACTIVITY
	clientEventMgr[52] = gActivityTimeActivityID.ALLIANCE_DINNER_ACTIVITY
	clientEventMgr[53] = gActivityTimeActivityID.MAGIC_FLIP_ACTIVITY
	clientEventMgr[54] = gActivityTimeActivityID.ROCKET_RUSH
	clientEventMgr[55] = gActivityTimeActivityID.LUCKY_WRETCH_ACTIVITY
	clientEventMgr[56] = gActivityTimeActivityID.SERICA_SHOP_ACTIVITY
	clientEventMgr[57] = gActivityTimeActivityID.SULTAN_COIN_REBATE_ACTIVITY
	clientEventMgr[58] = gActivityTimeActivityID.LORD_OF_DESSERT_ACTIVITY
	clientEventMgr[59] = gActivityTimeActivityID.EID_SIGN_ACTIVITY
	clientEventMgr[60] = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546
	clientEventMgr[61] = gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY
	clientEventMgr[62] = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545
	clientEventMgr[63] = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544
	clientEventMgr[64] = gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604
	clientEventMgr[65] = gActivityTimeActivityID.STAR_LIGHT_LAMP_ACTIVITY
	clientEventMgr[66] = gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY
	clientEventMgr[67] = gActivityTimeActivityID.BRIGHT_FIREWORKS_ACTIVITY
	clientEventMgr[68] = gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY
	clientEventMgr[69] = gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY
	clientEventMgr[70] = gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1
	clientEventMgr[71] = gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_2
	clientEventMgr[72] = gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3
	clientEventMgr[73] = gActivityTimeActivityID.STELLAR_ODYSSEY_ACTIVITY
	clientEventMgr[74] = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001563
	clientEventMgr[75] = gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY
	clientEventMgr[76] = gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	clientEventMgr[77] = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001564
	clientEventMgr[78] = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588
	clientEventMgr[79] = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001571
	clientEventMgr[80] = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	clientEventMgr[81] = gActivityTimeActivityID.RAMADAN_SURPRISED_DROP
	clientEventMgr[82] = gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001662
	clientEventMgr[83] = gActivityTimeActivityID.SIGN_REWARD_ACTIVITY
	clientEventMgr[84] = gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY
	clientEventMgr[85] = gActivityTimeActivityID.RAMADAN_BUILD_SALYUT_ACTIVITY
	clientEventMgr[86] = gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY
	clientEventMgr[87] = gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY
	clientEventMgr[88] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001601
	clientEventMgr[89] = gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY
	clientEventMgr[90] = gActivityTimeActivityID.END_OF_RAMADAN_ADVANCE
	clientEventMgr[91] = gActivityTimeActivityID.GATHERING_FEAST_2024
	clientEventMgr[92] = gActivityTimeActivityID.PREPARING_FEAST_2024
	clientEventMgr[93] = gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY
	clientEventMgr[94] = gActivityTimeActivityID.CORBAN_MARKET_ACTIVITY
	clientEventMgr[95] = gActivityTimeActivityID.PHOENIX_CHALLENGE
	clientEventMgr[96] = gActivityTimeActivityID.EID_CELEBRATION_ACTIVITY
	clientEventMgr[97] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001638
	clientEventMgr[98] = gActivityTimeActivityID.CELEBRATE_CORBAN
	clientEventMgr[99] = gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY
	clientEventMgr[100] = gActivityTimeActivityID.NEW_STAR_MOON_TREASURE_ACTIVITY
	clientEventMgr[101] = gActivityTimeActivityID.MERGE_SERVER_ACTIVITY
	clientEventMgr[102] = gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY
	clientEventMgr[103] = gActivityTimeActivityID.SIGN_REWARD_9001687_ACTIVITY
	clientEventMgr[104] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001665
	clientEventMgr[105] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	clientEventMgr[106] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001699
	clientEventMgr[107] = gActivityTimeActivityID.BUBBLE_CARNIVAL
	clientEventMgr[108] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001664
	clientEventMgr[109] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001666
	clientEventMgr[110] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001705
	clientEventMgr[111] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001676
	clientEventMgr[112] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
	clientEventMgr[113] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001691
	clientEventMgr[114] = gActivityTimeActivityID.RECHARGE_INTERFACE_ACTIVITY
	clientEventMgr[115] = gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY
	clientEventMgr[116] = gActivityTimeActivityID.WEAPON_SPECIAL_BOX
	clientEventMgr[117] = gActivityTimeActivityID.DONATE_METERIAL_ACTIVITY
	clientEventMgr[118] = gActivityTimeActivityID.DAILY_SALUTE
	clientEventMgr[119] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001692
	clientEventMgr[120] = gActivityTimeActivityID.DAILY_SALUTE_BRIBE
	clientEventMgr[121] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001701
	clientEventMgr[122] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001700
	clientEventMgr[123] = gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY
	clientEventMgr[124] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	clientEventMgr[125] = gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY
	clientEventMgr[126] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702
	clientEventMgr[127] = gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY
	clientEventMgr[128] = gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708
	clientEventMgr[129] = gActivityTimeActivityID.KOH_MIGRATE_HELP_9001709
	clientEventMgr[130] = gActivityTimeActivityID.NEBULA_EQUIPMENT_ACTIVITY
	clientEventMgr[131] = gActivityTimeActivityID.MAGIC_CARPET
	clientEventMgr[132] = gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716
	clientEventMgr[133] = gActivityTimeActivityID.LAMP_WISH_ACTIVITY
	clientEventMgr[134] = gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720
	clientEventMgr[135] = gActivityTimeActivityID.ANNIVERSARY_SHOP_2025
	clientEventMgr[136] = gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY
	clientEventMgr[137] = gActivityTimeActivityID.FANTASY_LAND
	clientEventMgr[138] = gActivityTimeActivityID.ANNIVERSARY_2025_9001723
	clientEventMgr[139] = gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY
	clientEventMgr[140] = gActivityTimeActivityID.ALBARQ_DECREE_ACTIVITY
	clientEventMgr[141] = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
	clientEventMgr[142] = gActivityTimeActivityID.FLYING_CHESS_ACTIVITY
	clientEventMgr[143] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001732
	clientEventMgr[144] = gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY
	clientEventMgr[145] = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
	clientEventMgr[146] = gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY
	clientEventMgr[147] = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
	clientEventMgr[148] = gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY
	clientEventMgr[149] = gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
	local clientEventMgr[150], commonActivityIDList = gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY, clientEventMgr
	for __, _activityID in ipairs(commonActivityIDList) do
		clientEventMgr.eventFuncList[_activityID] = function(activityID)
			return addNormalEvent_new(activityID)
		end
	end
	_UPVALUE8_ = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[1] = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[2] = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[3] = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[4] = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[5] = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[6] = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[7] = ipairs(commonActivityIDList)
	clientEventMgr.greatChallengeId, ipairs(commonActivityIDList)[8] = ipairs(commonActivityIDList)
	_ENV = ipairs(commonActivityIDList)
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.STRONGEST_LORD] = true
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.ROME_ACTIVITY] = true
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.EXPEDITON] = true
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.ANNIHILATION] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.MAGIC_CARPET] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY] = true
	clientEventMgr.eventNotInWarShowList, ipairs(commonActivityIDList)[gActivityTimeActivityID.FLYING_CHESS_ACTIVITY] = ipairs(commonActivityIDList)
	_ENV = ipairs(commonActivityIDList)
	ipairs(commonActivityIDList)[gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.RECHARGE_GOLD_FOR_REWARD] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.COST_GOLD_FOR_GIFT] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.SURPRISED_DROP] = true
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.GREAT_CHALLENGE] = true
	clientEventMgr.eventNotInRemainWarShowList, ipairs(commonActivityIDList)[gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY] = ipairs(commonActivityIDList)
	_ENV = ipairs(commonActivityIDList)
	ipairs(commonActivityIDList)[gActivityTimeActivityID.FULL_DAY_SPRINT_ACTIVITY] = true
	clientEventMgr.eventNotInRadianceWarShowList, ipairs(commonActivityIDList)[gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY] = ipairs(commonActivityIDList)
	_ENV = ipairs(commonActivityIDList)
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.PYRAMID_BATTLE] = true
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.KINGDOM_BATTLE] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.HERO_SECRET_ACTIVITY] = true
	ipairs(commonActivityIDList)[gActivityTimeActivityID.LEGEND_LORD] = gKingdomClassType.legendLord
	ipairs(commonActivityIDList)[gActivityTimeActivityID.KING_STAR_BATTLE] = gKingdomClassType.legendLord
	ipairs(commonActivityIDList)[gActivityTimeActivityID.LEGEND_LORD_9001646] = gKingdomClassType.legendLord
	ipairs(commonActivityIDList)[gActivityTimeActivityID.LEGEND_LORD_9001647] = gKingdomClassType.legendLord
	ipairs(commonActivityIDList)[gActivityCenterUIEnum.LEGEND_HEGEMON] = gKingdomClassType.legendLord
	ipairs(commonActivityIDList)[gActivityTimeActivityID.RUINS_WAR] = gKingdomClassType.remains
	ipairs(commonActivityIDList)[gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY] = gKingdomClassType.radiance
	ipairs(commonActivityIDList)[gActivityTimeActivityID.ATLANTIS_PRIVILEGE_ACTIVITY] = gKingdomClassType.atlantis
	ipairs(commonActivityIDList)[gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY] = gKingdomClassType.atlantis
	ipairs(commonActivityIDList)[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY] = gKingdomClassType.nebula
	ipairs(commonActivityIDList)[gActivityTimeActivityID.NEBULA_PRIVILEGE] = gKingdomClassType.nebula
	ipairs(commonActivityIDList)[gActivityTimeActivityID.NEBULA_KING_ACTIVITY] = gKingdomClassType.nebula
	ipairs(commonActivityIDList)[gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY] = gKingdomClassType.nebula
	ipairs(commonActivityIDList)[gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY] = gKingdomClassType.nebulaEmperor
	clientEventMgr.eventMutualList, ipairs(commonActivityIDList)[gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY] = ipairs(commonActivityIDList)
	_ENV = ipairs(commonActivityIDList)
	_ENV = "DECRYPTION_ACTIVITY"
	ipairs(commonActivityIDList)[gActivityTimeActivityID.DECRYPTION_ACTIVITY], ("DECRYPTION_ACTIVITY").name = "DECRYPTION_ACTIVITY", i18n("activity_name_05")
	_ENV = "NEW_SERVER_RANK_MATCH"
	ipairs(commonActivityIDList)[gActivityTimeActivityID.NEW_SERVER_RANK_MATCH], ("NEW_SERVER_RANK_MATCH").name = "NEW_SERVER_RANK_MATCH", i18n("kindom_competition_text_01")
	_ENV = "ANNIVERSARY_CELEBRATION"
	ipairs(commonActivityIDList)[gActivityTimeActivityID.ANNIVERSARY_CELEBRATION], ("ANNIVERSARY_CELEBRATION").name = "ANNIVERSARY_CELEBRATION", i18n("celebration_text_01")
	_ENV = "ROYAL_SUMMONS"
	ipairs(commonActivityIDList)[gActivityTimeActivityID.ROYAL_SUMMONS], ("ROYAL_SUMMONS").name = "ROYAL_SUMMONS", i18n("summoned_name_01")
	_ENV = "PARTY_ACTIVITY"
	ipairs(commonActivityIDList)[gActivityTimeActivityID.PARTY_ACTIVITY], ("PARTY_ACTIVITY").name = "PARTY_ACTIVITY", i18n("mail_feast_theme_01")
	_ENV = "KING_STAR_BATTLE"
	ipairs(commonActivityIDList)[gActivityTimeActivityID.KING_STAR_BATTLE], ("KING_STAR_BATTLE").name = "KING_STAR_BATTLE", i18n("kingstarbattle_text_19")
	_ENV = "LEGEND_LORD_9001646"
	ipairs(commonActivityIDList)[gActivityTimeActivityID.LEGEND_LORD_9001646], ("LEGEND_LORD_9001646").name = "LEGEND_LORD_9001646", i18n("activity_name_9001646")
	_ENV = "LEGEND_LORD_9001647"
	clientEventMgr.eventNameList, ipairs(commonActivityIDList)[gActivityTimeActivityID.LEGEND_LORD_9001647], ("LEGEND_LORD_9001647").name = ipairs(commonActivityIDList)
end
function clientEventMgr.tryCall(fun, eid)
	if device.platform ~= "mac" then
		xpcall(function()
			print("加载活动eid=", eid)
			fun()
		end, function()
			print("活动出错 eid=", eid)
			print(debug.traceback(2))
		end)
	else
		fun()
	end
end
function clientEventMgr.conditionFilter(eventID)
	local gametop = gModuleMgr.getObject("gametop")
	local worldMapDefine = include("worldMapDefine")
	local checkInConquestWar = function()
		return worldMapDefine.isInKingdomBattle()
	end
	local checkInPyramidWar = function()
		return worldMapDefine.isInPyramid()
	end
	local checkInLegendLord = function(eventID)
		local mapid = gametop.playertop_:getMapID()
		if eventID == gActivityTimeActivityID.KING_STAR_BATTLE or eventID == gActivityTimeActivityID.LEGEND_LORD_9001646 or eventID == gActivityTimeActivityID.LEGEND_LORD_9001647 then
			return worldMapDefine.isInLegendLord() and worldMapDefine.isKingStarMapId(mapid)
		else
			return worldMapDefine.isInLegendLord() and not worldMapDefine.isKingStarMapId(mapid)
		end
	end
	local checkInRemains = function()
		return worldMapDefine.isInRemains()
	end
	local checkInRadiance = function()
		return worldMapDefine.isInRadiance()
	end
	local checkInWar = function()
		return checkInConquestWar() or worldMapDefine.isInWar() or checkInPyramidWar()
	end
	local checkIsEmenyShow = function(eid)
		local activityTimeRead = include("activityTimeRead")
		return activityTimeRead.getActivityEnemyShowByID(eid)
	end
	if eventID then
		local notNeedEmpty = true
		if clientEventMgr.eventNotInRemainWarShowList[eventID] and checkInRemains() then
			notNeedEmpty = nil
		elseif clientEventMgr.eventNotInRadianceWarShowList[eventID] and checkInRadiance() then
			notNeedEmpty = nil
		elseif not clientEventMgr.eventNotInWarShowList[eventID] and not clientEventMgr.eventMutualList[eventID] and not checkIsEmenyShow(eventID) and checkInWar() then
			notNeedEmpty = nil
		elseif clientEventMgr.eventNotInWarShowList[eventID] and checkInWar() then
			notNeedEmpty = nil
		elseif clientEventMgr.eventMutualList[eventID] and checkInWar() then
			if gActivityCenterUIEnum.PYRAMID_BATTLE == eventID then
				notNeedEmpty = nil
			elseif gActivityCenterUIEnum.KINGDOM_BATTLE == eventID and not checkInConquestWar() then
				notNeedEmpty = nil
			end
			local worldMapWarDef = include("worldMapWarDef")
			local mapClassType = clientEventMgr.eventMutualList[eventID]
			if type(mapClassType) == "number" then
				if mapClassType == gKingdomClassType.legendLord then
					if not checkInLegendLord(eventID) then
						notNeedEmpty = nil
					end
				elseif not worldMapWarDef.isInMapClassType(mapClassType) then
					notNeedEmpty = nil
				end
			end
		end
		return notNeedEmpty
	end
end
function clientEventMgr.getCommonEventList(eid)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local commonEventRead = include("commonEventRead")
	local commonEventIDList = activityShowCtrl:getActivityIDAry()
	local getEventInfo = function(v)
		local eventInfo = commonEventRead.getInfoByEID(v)
		if eventInfo then
			local state = activityShowCtrl:getStateByID(v)
			local timer = activityShowCtrl:getTimeInfoByID(v)
			local timerLast = "common_text_699"
			if state ~= gActivityState.CLOSE then
				timerLast = "common_text_606"
				if gActivityState.OPEN == state then
					timerLast = "common_text_607"
				end
			end
			clientEventMgr.nowEventStateList[v] = clientEventMgr.addEventTimer(v, timer.timerNode.timer:getRemainTime())
			if clientEventMgr.conditionFilter(v) then
				commonEventRead = clientEventMgr.conditionFilter(v)
				clientEventMgr.conditionFilter(v).eventID = v
				clientEventMgr.conditionFilter(v).eventState = state
				commonEventRead, clientEventMgr.conditionFilter(v).eventType = v, 1
				v.timeType = "showTime"
				clientEventMgr.conditionFilter(v).eventLeftTime, v.timerLast = v, timerLast
				clientEventMgr.conditionFilter(v).eventName = i18n(eventInfo.name)
				clientEventMgr.conditionFilter(v).eventDes = i18n(eventInfo.des)
				clientEventMgr.conditionFilter(v).flagIcon = eventInfo.icon
				commonEventRead, clientEventMgr.conditionFilter(v).pageBg = eventInfo.image, eventInfo.image
				clientEventMgr.conditionFilter(v).otherData, eventInfo.image.timerLast = eventInfo.image, timerLast
			end
			clientEventMgr.nowEventStateList[v] = clientEventMgr.conditionFilter(v)
			return clientEventMgr.nowEventStateList[v]
		end
	end
	if eid then
		for i, v in ipairs(commonEventIDList) do
			if v == eid then
				return getEventInfo(v)
			end
		end
	else
		for i, v in ipairs(commonEventIDList) do
			getEventInfo(v)
		end
		return clientEventMgr.nowEventStateList
	end
end
function clientEventMgr.getEventStateInfo(eid)
	if eid then
		eid = tonumber(eid)
		if clientEventMgr.eventFuncList and clientEventMgr.eventFuncList[eid] then
			local reInfo
			clientEventMgr.tryCall(function()
			end, eid)
			clientEventMgr.nowEventStateList[eid] = reInfo
			return clientEventMgr.nowEventStateList[eid]
		else
			return clientEventMgr.getCommonEventList(eid)
		end
	else
		clientEventMgr.nowEventStateList, _ENV = eid, eid
		if not clientEventMgr.eventFuncList then
			_ENV = clientEventMgr.eventFuncList
		end
		for k, v in pairs(clientEventMgr.eventFuncList) do
			clientEventMgr.tryCall(function()
				clientEventMgr.nowEventStateList[k] = clientEventMgr.conditionFilter(k) and v(k)
			end, k)
		end
		clientEventMgr.getCommonEventList()
		return clientEventMgr.nowEventStateList
	end
end
function clientEventMgr.getEventOriginalInfo(eid)
	if eid then
		eid = tonumber(eid)
		return clientEventMgr.eventFuncList[eid]
	end
end
function clientEventMgr.getSortTblByCeHua(oriKeys, isFromUpdate, keysTb)
	if isFromUpdate and keysTb then
		return keysTb
	end
	local _ENV, powerTbl
	if oriKeys and next(oriKeys) then
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local activityCenterUICtrl = gametop.playertop_:getModule("activityCenterUICtrl")
		local eventSortTbl = activityShowCtrl:getActivityOrder()
		local commonEventRead = include("commonEventRead")
		for k, v in pairs(oriKeys) do
			if clientEventMgr.nowEventStateList and clientEventMgr.nowEventStateList[v] then
				local oriPow = 0
				if gActivityState.OPEN == clientEventMgr.nowEventStateList[v].eventState then
					oriPow = oriPow + (eventSortTbl[v] and eventSortTbl[v].beginorde or 0) + 2000
				elseif gActivityState.PREPARE == clientEventMgr.nowEventStateList[v].eventState then
					oriPow = oriPow + (eventSortTbl[v] and eventSortTbl[v].prepareorder or 0)
				end
				if gSpiceFeastActivityStatus.CALCULATE == clientEventMgr.nowEventStateList[v].eventState then
					oriPow = oriPow + (eventSortTbl[v] and eventSortTbl[v].beginorde or 0) + 20000
				end
				if gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY == v and gActivityState.OPEN == clientEventMgr.nowEventStateList[v].eventState then
					oriPow = oriPow + 1000000
				end
				local isNew = activityCenterUICtrl:isHaveNewFlag(v)
				if isNew then
					oriPow = oriPow + 40000
				end
				_ENV = nil
				;(nil).eid = v
				;(nil).pow = oriPow
				table.insert(powerTbl, nil)
			end
		end
	end
	table.sort(powerTbl, function(l, r)
		return l.pow > r.pow
	end)
	return powerTbl
end
function clientEventMgr.getActivityInfo(eid)
	local gametop = gModuleMgr.getObject("gametop")
	local activityCenterUICtrl = gametop.playertop_:getModule("activityCenterUICtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _isNew = activityCenterUICtrl:isHaveNewFlag(eid)
	local redPoint = 0
	if clientEventMgr.getEventInfoByeid(eid) then
		local ret, retNum = activityShowCtrl:getReceiveStatusAndNum(eid)
		if ret then
			redPoint = retNum
		end
	end
	_ENV = ret
	activityShowCtrl:getReceiveStatusAndNum(eid).eid = eid
	activityShowCtrl:getReceiveStatusAndNum(eid).isNew = _isNew
	activityShowCtrl:getReceiveStatusAndNum(eid).redPoint = redPoint
	return activityShowCtrl:getReceiveStatusAndNum(eid)
end
function clientEventMgr.getNewInfo(eid)
	if eid then
		return clientEventMgr.getActivityInfo(eid)
	else
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local _ENV, retTbl = gametop.playertop_, gametop.playertop_
		for k, v in pairs(clientEventMgr.nowEventStateList) do
			local classifyTable = activityShowCtrl:getActivityClassifyByID(v.eventID)
			local classify = 1
			if type(classifyTable) ~= "number" then
				classify = classifyTable[1]
			else
				classify = classifyTable
			end
			local info = clientEventMgr.getActivityInfo(v.eventID)
			if not clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.ACTIVITY_CENTER_TAG_1) then
				if classify ~= 6 and info.isNew then
					table.insert(retTbl, info)
					break
				end
			elseif classify ~= 2 and info.isNew then
				table.insert(retTbl, info)
				break
			end
		end
		return retTbl
	end
end
function clientEventMgr.getRedPointInfo(eid)
	if eid then
		return clientEventMgr.getActivityInfo(eid)
	else
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local _ENV, retTbl = gametop.playertop_, gametop.playertop_
		for k, v in pairs(clientEventMgr.nowEventStateList) do
			local classifyTable = activityShowCtrl:getActivityClassifyByID(v.eventID)
			local classify = 1
			if type(classifyTable) ~= "number" then
				classify = classifyTable[1]
			else
				classify = classifyTable
			end
			local info = clientEventMgr.getActivityInfo(v.eventID)
			if not clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.ACTIVITY_CENTER_TAG_1) then
				if classify ~= 6 and info.redPoint ~= 0 then
					table.insert(retTbl, info)
					break
				end
			elseif classify ~= 2 and info.redPoint ~= 0 then
				table.insert(retTbl, info)
				break
			end
		end
		return retTbl
	end
end
function clientEventMgr.getNewAndRedPointInfo(eid)
	local gametop = gModuleMgr.getObject("gametop")
	local activityCenterUICtrl = gametop.playertop_:getModule("activityCenterUICtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local getInfo = function(eid)
		local _isNew = activityCenterUICtrl:isHaveNewFlag(eid)
		local redPoint = 0
		if clientEventMgr.getEventInfoByeid(eid) then
			local ret, retNum = activityShowCtrl:getReceiveStatusAndNum(eid)
			if ret then
				redPoint = retNum
			end
		end
		activityCenterUICtrl = ret
		activityShowCtrl:getReceiveStatusAndNum(eid).eid = eid
		activityShowCtrl:getReceiveStatusAndNum(eid).isNew = _isNew
		activityShowCtrl:getReceiveStatusAndNum(eid).redPoint = redPoint
		return activityShowCtrl:getReceiveStatusAndNum(eid)
	end
	if eid then
		return getInfo(eid)
	else
		local _ENV, retTbl = getInfo, getInfo
		for k, v in pairs(clientEventMgr.nowEventStateList) do
			local classifyTable = activityShowCtrl:getActivityClassifyByID(v.eventID)
			local classify = 1
			if type(classifyTable) ~= "number" then
				classify = classifyTable[1]
			else
				classify = classifyTable
			end
			if not clientEventMgr.judgeIsOpen(gActivityCenterUIEnum.ACTIVITY_CENTER_TAG_1) then
				if classify ~= 6 then
					table.insert(retTbl, getInfo(v.eventID))
				end
			elseif classify ~= 2 then
				table.insert(retTbl, getInfo(v.eventID))
			end
		end
		return retTbl
	end
end
_ENV, _ENV, clientEventMgr.addNormalEvent = function(infoTbl)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	local activityData = activityShowCtrl:getActivityData(infoTbl.eid)
	if activityData.doStage and activityData.stagetimes then
		return clientEventMgr.addNormalEvent_Stage(infoTbl)
	end
	local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
	if _eventLast then
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, _eventLast
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		clientEventMgr.addEventTimer.flipBg = infoTbl.flipBg
		clientEventMgr.addEventTimer.noPage = infoTbl.noPage
		return clientEventMgr.addEventTimer
	end
end, clientEventMgr, function(infoTbl)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	local activityData = activityShowCtrl:getActivityData(infoTbl.eid)
	if activityData.doStage and activityData.stagetimes then
		return clientEventMgr.addNormalEvent_Stage(infoTbl)
	end
	local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
	if _eventLast then
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, _eventLast
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		clientEventMgr.addEventTimer.flipBg = infoTbl.flipBg
		clientEventMgr.addEventTimer.noPage = infoTbl.noPage
		return clientEventMgr.addEventTimer
	end
end
;(function(infoTbl)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	local activityData = activityShowCtrl:getActivityData(infoTbl.eid)
	if activityData.doStage and activityData.stagetimes then
		return clientEventMgr.addNormalEvent_Stage(infoTbl)
	end
	local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
	if _eventLast then
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, _eventLast
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		clientEventMgr.addEventTimer.flipBg = infoTbl.flipBg
		clientEventMgr.addEventTimer.noPage = infoTbl.noPage
		return clientEventMgr.addEventTimer
	end
end)[1] = "palace_text_01"
;(function(infoTbl)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	local activityData = activityShowCtrl:getActivityData(infoTbl.eid)
	if activityData.doStage and activityData.stagetimes then
		return clientEventMgr.addNormalEvent_Stage(infoTbl)
	end
	local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
	if _eventLast then
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, _eventLast
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		clientEventMgr.addEventTimer.flipBg = infoTbl.flipBg
		clientEventMgr.addEventTimer.noPage = infoTbl.noPage
		return clientEventMgr.addEventTimer
	end
end)[2] = "palace_text_02"
clientEventMgr[1], (function(infoTbl)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	local activityData = activityShowCtrl:getActivityData(infoTbl.eid)
	if activityData.doStage and activityData.stagetimes then
		return clientEventMgr.addNormalEvent_Stage(infoTbl)
	end
	local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
	if _eventLast then
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, _eventLast
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		clientEventMgr.addEventTimer.flipBg = infoTbl.flipBg
		clientEventMgr.addEventTimer.noPage = infoTbl.noPage
		return clientEventMgr.addEventTimer
	end
end)[3] = function(infoTbl)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	local activityData = activityShowCtrl:getActivityData(infoTbl.eid)
	if activityData.doStage and activityData.stagetimes then
		return clientEventMgr.addNormalEvent_Stage(infoTbl)
	end
	local _eventLast = clientEventMgr.judgeIsOnShow(_eventState)
	if _eventLast then
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, _eventLast
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		clientEventMgr.addEventTimer.flipBg = infoTbl.flipBg
		clientEventMgr.addEventTimer.noPage = infoTbl.noPage
		return clientEventMgr.addEventTimer
	end
end, "palace_text_03"
_ENV = nil
;(nil)[1] = "pray_text_21"
clientEventMgr[gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY], (nil)[2] = nil, "pray_text_22"
_ENV = nil
;(nil)[1] = "common_text_607"
clientEventMgr[gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY], (nil)[2] = nil, "datepalm_tree_text53"
_ENV = nil
;(nil)[1] = "ramadan_commemoration_text5"
clientEventMgr[gActivityTimeActivityID.END_OF_RAMADAN_ADVANCE], (nil)[2] = nil, "common_text_607"
_ENV = nil
;(nil)[1] = "warmongering_text10"
clientEventMgr[gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY], (nil)[2] = nil, "common_text_607"
_ENV = nil
;(nil)[1] = "Sultan_present_text_13"
clientEventMgr[gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY], (nil)[2] = nil, "Sultan_present_text_14"
_ENV = nil
;(nil)[1] = "end_time_text"
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001702], (nil)[2] = nil, "Eidal_celebration_text_04"
_ENV = nil
;(nil)[1] = "palace_text_01"
clientEventMgr[gActivityTimeActivityID.FANTASY_LAND], (nil)[2] = nil, "palace_text_02"
_ENV = nil
_UPVALUE1_, (nil)[1] = nil, "football_match_text_080"
;(nil).num = 1
_UPVALUE1_, (nil)[2], (nil)[1] = nil, nil, "football_match_text_081"
;(nil).num = 2
_UPVALUE1_, (nil)[3], (nil)[1] = nil, nil, "football_match_text_081"
;(nil).num = 3
_UPVALUE1_, (nil)[4], (nil)[1] = nil, nil, "football_match_text_081"
;(nil).num = 4
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736], (nil)[5], (nil)[1] = nil, nil, "football_match_text_081"
local _stageDesTbl = clientEventMgr
function clientEventMgr.getStageTimeStr(doStage, eid)
	if not eid or not _stageDesTbl[eid] then
		eid = 1
	end
	return _stageDesTbl[eid][doStage + 1] or "clientEventMgr.getStageTimeStr(doStage) undefined "
end
function clientEventMgr.addNormalEvent_Stage(infoTbl)
	print("addNormalEvent_Stage ------------")
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	if _eventState ~= gActivityState.CLOSE then
		local strTime = "common_text_606"
		local activityData = activityShowCtrl:getActivityData(infoTbl.eid)
		if gActivityState.OPEN == _eventState then
			strTime = clientEventMgr.getStageTimeStr(activityData.doStage, infoTbl.eid)
		end
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, strTime
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		return clientEventMgr.addEventTimer
	end
end
function clientEventMgr.addNormalOnlyOpenEvent(infoTbl)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local _eventState = activityShowCtrl:getStateByID(infoTbl.eid)
	local _eventLast = clientEventMgr.judgeIsOnlyOpenOnShow(_eventState)
	if _eventLast then
		local _eventTime = activityShowCtrl:getTimeInfoByID(infoTbl.eid)
		clientEventMgr.addEventTimer(infoTbl.eid, _eventTime.timerNode.timer:getRemainTime())
		_ENV = clientEventMgr.addEventTimer
		clientEventMgr.addEventTimer.eventID = infoTbl.eid
		_ENV, clientEventMgr.addEventTimer.eventState = infoTbl.eid, _eventState
		infoTbl.eid.timeType = "showTime"
		clientEventMgr.addEventTimer.eventLeftTime, infoTbl.eid.timerLast = infoTbl.eid, _eventLast
		clientEventMgr.addEventTimer.eventName = infoTbl.name
		clientEventMgr.addEventTimer.eventDes = infoTbl.des
		clientEventMgr.addEventTimer.flagIcon = infoTbl.icon
		clientEventMgr.addEventTimer.pageBg = infoTbl.bg
		return clientEventMgr.addEventTimer
	end
end
function clientEventMgr.judgeIsOnShow(state)
	if state ~= gActivityState.CLOSE then
		local timerLast = "common_text_606"
		if gActivityState.OPEN == state then
			timerLast = "common_text_607"
		end
		return timerLast
	else
		return false
	end
end
function clientEventMgr.judgeIsOnlyOpenOnShow(state)
	if state == gActivityState.OPEN then
		local timerLast = "common_text_607"
		return timerLast
	else
		return false
	end
end
function clientEventMgr.returnEventState(state)
	_ENV = nil
	;(nil)[1] = i18n("common_text_2486")
	;(nil)[2] = i18n("common_text_608")
	local (nil)[3], stateList = i18n("common_text_1516"), nil
	return stateList[state] or stateList[1]
end
function clientEventMgr.judgeIsOpen(eid, popTip)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(eid)
	if eventState == gActivityState.OPEN then
		return true
	else
		if popTip then
			if eventState == gActivityState.PREPARE then
				SoraDShowMsgTip(i18n("common_text_608"))
			elseif eventState == gActivityState.CLOSE then
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		end
		return false
	end
end
function clientEventMgr.getEventInfoByeid(eid)
	return clientEventMgr.nowEventStateList[eid]
end
_ENV, clientEventMgr.getActivityCfg = clientEventMgr, function(activityID)
	local _ENV, cfg
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
	local activityTimeRead = include("activityTimeRead")
	cfg.name = i18n(activityTimeRead.getActivityNameByID(activityID, param.classtype))
	cfg.icon = activityTimeRead.getActivityIconByID(activityID, param.classtype)
	return cfg
end
_ENV = nil
;(nil).viewName = "Activity_9001734_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001737_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001735_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001732_Main"
;(nil).isFgui = true
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001732], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001736_Main"
;(nil).isFgui = true
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001731_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.FLYING_CHESS_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001727_Main"
;(nil).isFgui = true
clientEventMgr[gActivityTimeActivityID.ALBARQ_DECREE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001721_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001712_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001720_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001718_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LAMP_WISH_ACTIVITY], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001716_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001719_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.MAGIC_CARPET], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001722_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.NEBULA_EQUIPMENT_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001710_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY], (nil).checkCastleStarLv = nil, 1
_ENV = nil
;(nil).viewName = "Activity_9001703_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001706_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001596_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.RAMADAN_BUILD_SALYUT_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001597_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001673_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.RECHARGE_INTERFACE_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001588_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "Activity_9001564_Main"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001564], (nil).checkCastleLv = nil, CASTLE_LV110_LIMITED
_ENV = nil
;(nil).viewName = "BraqueTestMain"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.WAR_ORDER_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "WarHornMain"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "earthTreasureMainView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.EARTH_TREASURE_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
clientEventMgr[gActivityCenterUIEnum.ATLANTIS_PRIVILEGE_ACTIVITY], (nil).viewName = nil, "atlantisPrivilegeView"
_ENV = nil
;(nil).viewName = "starsTreasureHuntView"
clientEventMgr[gActivityCenterUIEnum.STAR_MOON_TREASURE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001655"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityCenterUIEnum.NEW_STAR_MOON_TREASURE_ACTIVITY], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001663_main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.BUBBLE_CARNIVAL], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001678_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.FROSTY_MARKET], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001685_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.WEAPON_SPECIAL_BOX], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001684_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.DONATE_METERIAL_ACTIVITY], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001688_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.DAILY_SALUTE], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001689_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.DAILY_SALUTE_BRIBE], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "bubbleRewardPopView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityCenterUIEnum.BUBBLE_REWARD_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "eggCarnivalMainView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityCenterUIEnum.PAINTED_EGG_CRAZY_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV10_LIMITED
_ENV = nil
;(nil).viewName = "newDayTaskView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityCenterUIEnum.CHANGE_DAY_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV6_LIMITED
_ENV = nil
;(nil).viewName = "lostRuinsMainView"
clientEventMgr[gActivityCenterUIEnum.LOST_RUINS_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "sultansBackView"
clientEventMgr[gActivityCenterUIEnum.SULTAN_BACK], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "preciousTreasurePopView"
clientEventMgr[gActivityTimeActivityID.PRECIOUS_TREASURE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "babelTowerMainView"
clientEventMgr[gActivityTimeActivityID.TONGTIAN_TOWER_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "PopupWindow"
_ENV, (nil).isFgui = CASTLE_LV6_LIMITED, true
;(nil).param, CASTLE_LV6_LIMITED.activityID = CASTLE_LV6_LIMITED, gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY
clientEventMgr[gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "PopupWindow"
_ENV, (nil).isFgui = CASTLE_LV6_LIMITED, true
;(nil).param, CASTLE_LV6_LIMITED.activityID = CASTLE_LV6_LIMITED, gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT
clientEventMgr[gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "taskRushActivityView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "Activity_9001695_Main"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001695], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "preDownloadActivity"
clientEventMgr[gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "kingCityUpgradeView"
clientEventMgr[gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "lightGuardianMainView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV40_LIMITED
_ENV = nil
;(nil).viewName = "warTreasureMainView"
;(nil).checkIsOpen = true
;(nil).checkCastleLv = CASTLE_LV10_LIMITED
clientEventMgr[gActivityTimeActivityID.WAR_TREASURE_ACTIVITY], (nil).checkHasJoinAlliance = nil, true
_ENV = nil
;(nil).viewName = "RomanSoulNew"
clientEventMgr[gActivityCenterUIEnum.ROME_ACTIVITY], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "kingdomBattleReady"
clientEventMgr[gActivityCenterUIEnum.KINGDOM_BATTLE], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "gameInvite"
clientEventMgr[gActivityTimeActivityID.GAME_SETTINGINV_ITEFRIEND], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "ExchangeShopMain"
clientEventMgr[gActivityTimeActivityID.EXCHANGE_MALL], (nil).isFgui = nil, true
_ENV = nil
;(nil).viewName = "groupBuyView"
clientEventMgr[gActivityTimeActivityID.GROUP_BUY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventRedPackage"
clientEventMgr[gActivityTimeActivityID.RED_PACKAGE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "letterClubView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.ABC_CLUB], (nil).isFgui = nil, true
_ENV = nil
clientEventMgr[gActivityTimeActivityID.GROWUPFUND], (nil).viewName = nil, "eventGrowupFund"
_ENV = nil
clientEventMgr[gActivityTimeActivityID.VALUE_REBATE_ACTIVITY], (nil).viewName = nil, "eventRebateView"
_ENV = nil
;(nil).viewName = "eventFlowerView"
clientEventMgr[gActivityTimeActivityID.FLOWER_ACTIVITY_RANK], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "pyramidTreasureView"
clientEventMgr[gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventEpicCommander"
clientEventMgr[gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "newKingRiseView"
clientEventMgr[gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "newKingRiseView"
clientEventMgr[gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY_NORMAL], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "friendsCallbackView"
clientEventMgr[gActivityTimeActivityID.FRIEND_CALLBACK], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventDevelopCastle"
clientEventMgr[gActivityTimeActivityID.CASTLE_UPGRADE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "kingdomGroupBuyView"
clientEventMgr[gActivityTimeActivityID.KING_GROUP_BUY_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventHeroWarView"
clientEventMgr[gActivityTimeActivityID.HERO_BATTLE_BOSS], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "redEnvelopeView"
clientEventMgr[gActivityTimeActivityID.PSD_RED_PACKAGE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "superCommanderView"
clientEventMgr[gActivityTimeActivityID.SUPER_COMMANDER], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventRechargeGoldForRewardView"
clientEventMgr[gActivityTimeActivityID.RECHARGE_GOLD_FOR_REWARD], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "CommonTaskActivity"
;(nil).checkIsOpen = true
_ENV, (nil).isFgui = CASTLE_LV10_LIMITED, true
clientEventMgr[gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY], (nil).param, CASTLE_LV10_LIMITED.activityID = nil, CASTLE_LV10_LIMITED, gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY
_ENV = nil
;(nil).viewName = "eventLoginGiftView"
clientEventMgr[gActivityTimeActivityID.LOGIN_GIFT], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "secretBagMainView"
clientEventMgr[gActivityTimeActivityID.KITS_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "knightsChargeMainView"
clientEventMgr[gActivityTimeActivityID.KNIGHTS_CHARGE], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "petraRareTreasureActivity"
clientEventMgr[gActivityTimeActivityID.PETRA_RARE_TREASURE], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventSpandGoldRebateView"
clientEventMgr[gActivityTimeActivityID.SPEND_GOLD_REBATE], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventLuckyRechargeView"
clientEventMgr[gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "weeklySpecialView"
clientEventMgr[gActivityTimeActivityID.WEEKLY_SPECIAL], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "eventGoldPackageView"
clientEventMgr[gActivityTimeActivityID.GOLD_PACKAGE], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "totalPayActivityView"
clientEventMgr[gActivityTimeActivityID.NEW_TOTAL_PAY_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "crazyShoppingView"
clientEventMgr[gActivityTimeActivityID.CRAZY_SHOPPING_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
clientEventMgr[gActivityTimeActivityID.NEW_KING_FUND], (nil).viewName = nil, "newKingFundView"
_ENV = nil
;(nil).viewName = "ActivityStarCompetition"
;(nil).isFgui = true
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.GLORIOUS_CONTEST], (nil).checkCastleLv = nil, CASTLE_LV80_LIMITED
_ENV = nil
;(nil).viewName = "equipActivityMainView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.EQUIP_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV15_LIMITED
_ENV = nil
;(nil).viewName = "eventLightShiningView"
;(nil).checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY], (nil).checkCastleLv = nil, CASTLE_LV40_LIMITED
_ENV = nil
;(nil).viewName = "enjoyLotteryView"
clientEventMgr[gActivityTimeActivityID.ENJOY_LOTTERY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "amazingFortuneView"
clientEventMgr[gActivityTimeActivityID.AMAZING_FORTUNE], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "heroSecretView"
clientEventMgr[gActivityTimeActivityID.HERO_SECRET_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "devoutEntreatView"
clientEventMgr[gActivityTimeActivityID.PLEAD_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "spiritualGiftView"
clientEventMgr[gActivityTimeActivityID.SPIRITUAL_GIFT], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "giftBagsInfoView"
clientEventMgr[gActivityTimeActivityID.GIFT_PACKAGE_ACTIVITY], (nil).checkIsOpen = nil, true
_ENV = nil
;(nil).viewName = "newKingTrailView"
clientEventMgr[gActivityTimeActivityID.NEWKING_TRAIL], (nil).checkIsOpen = nil, true
_ENV = "ENDLESS_TRIALS_ACTIVITY"
;("ENDLESS_TRIALS_ACTIVITY").viewName = "endlessTrialsView"
clientEventMgr[gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY], ("ENDLESS_TRIALS_ACTIVITY").checkIsOpen = "ENDLESS_TRIALS_ACTIVITY", true
_ENV = "COMMUNITY_CENTER"
;("COMMUNITY_CENTER").viewName = "communityCenterNewView"
clientEventMgr[gActivityTimeActivityID.COMMUNITY_CENTER], ("COMMUNITY_CENTER").checkIsOpen = "COMMUNITY_CENTER", true
_ENV = "WISH_TREE_ACTIVITY"
;("WISH_TREE_ACTIVITY").viewName = "wishingTreeView"
clientEventMgr[gActivityTimeActivityID.WISH_TREE_ACTIVITY], ("WISH_TREE_ACTIVITY").checkIsOpen = "WISH_TREE_ACTIVITY", true
_ENV = "LUCKY_FLIP_ACTIVITY"
;("LUCKY_FLIP_ACTIVITY").viewName = "luckyFlopMainView"
clientEventMgr[gActivityTimeActivityID.LUCKY_FLIP_ACTIVITY], ("LUCKY_FLIP_ACTIVITY").checkIsOpen = "LUCKY_FLIP_ACTIVITY", true
_ENV = "COLLECT_SALARY_ACTIVITY"
;("COLLECT_SALARY_ACTIVITY").viewName = "collectSalaryMainView"
clientEventMgr[gActivityTimeActivityID.COLLECT_SALARY_ACTIVITY], ("COLLECT_SALARY_ACTIVITY").checkIsOpen = "COLLECT_SALARY_ACTIVITY", true
_ENV = "JADE_STONE_MALL_ACTIVITY"
;("JADE_STONE_MALL_ACTIVITY").viewName = "treasureCourtView"
;("JADE_STONE_MALL_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.JADE_STONE_MALL_ACTIVITY], ("JADE_STONE_MALL_ACTIVITY").checkCastleLv = "JADE_STONE_MALL_ACTIVITY", CASTLE_LV15_LIMITED
_ENV = "CRAZY_TRIO_ACTIVITY"
;("CRAZY_TRIO_ACTIVITY").viewName = "eventCrazyTrio"
clientEventMgr[gActivityCenterUIEnum.CRAZY_TRIO_ACTIVITY], ("CRAZY_TRIO_ACTIVITY").checkIsOpen = "CRAZY_TRIO_ACTIVITY", true
_ENV = "CRAZY_SEPTET_ACTIVITY"
;("CRAZY_SEPTET_ACTIVITY").viewName = "eventCrazyTrioNew"
clientEventMgr[gActivityCenterUIEnum.CRAZY_SEPTET_ACTIVITY], ("CRAZY_SEPTET_ACTIVITY").checkIsOpen = "CRAZY_SEPTET_ACTIVITY", true
_ENV = "NEW_CRAZY_SEPTET_ACTIVITY"
;("NEW_CRAZY_SEPTET_ACTIVITY").viewName = "eventCrazyTrioSevenNew"
clientEventMgr[gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY], ("NEW_CRAZY_SEPTET_ACTIVITY").checkIsOpen = "NEW_CRAZY_SEPTET_ACTIVITY", true
_ENV = "HERO_TRIAL"
;("HERO_TRIAL").viewName = "heroTrialView"
;("HERO_TRIAL").showTipIcon = "#icon_activity_herotrial.png"
;("HERO_TRIAL").limit = true
clientEventMgr[gActivityCenterUIEnum.HERO_TRIAL], ("HERO_TRIAL").isFgui = "HERO_TRIAL", true
_ENV = "ANCIENT_TREASURE_ACTIVITY"
;("ANCIENT_TREASURE_ACTIVITY").viewName = "eventAncientSecretView"
;("ANCIENT_TREASURE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY], ("ANCIENT_TREASURE_ACTIVITY").checkIsOpen = "ANCIENT_TREASURE_ACTIVITY", true
_ENV = "CROSS_MISSION"
;("CROSS_MISSION").viewName = "decryptionView"
;("CROSS_MISSION").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CROSS_MISSION], ("CROSS_MISSION").checkIsOpen = "CROSS_MISSION", true
_ENV = "DECRYPTION_ACTIVITY"
;("DECRYPTION_ACTIVITY").viewName = "decryptionView_ros"
;("DECRYPTION_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.DECRYPTION_ACTIVITY], ("DECRYPTION_ACTIVITY").checkIsOpen = "DECRYPTION_ACTIVITY", true
_ENV = "FRIEND_HONORBACK"
;("FRIEND_HONORBACK").viewName = "honorBackView"
;("FRIEND_HONORBACK").checkCastleLv = CASTLE_LV22_LIMITED
clientEventMgr[gActivityTimeActivityID.FRIEND_HONORBACK], ("FRIEND_HONORBACK").checkIsOpen = "FRIEND_HONORBACK", true
_ENV = "RUINS_WAR"
;("RUINS_WAR").viewName = "remainsWarActivity"
;("RUINS_WAR").checkCastleLv = _G.CASTLE_LV27_LIMITED
clientEventMgr[gActivityTimeActivityID.RUINS_WAR], ("RUINS_WAR").checkIsOpen = "RUINS_WAR", true
_ENV = "RADIANCE_WAR_ACTIVITY"
;("RADIANCE_WAR_ACTIVITY").viewName = "radianceWarMainView"
;("RADIANCE_WAR_ACTIVITY").checkCastleLv = _G.CASTLE_LV40_LIMITED
clientEventMgr[gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY], ("RADIANCE_WAR_ACTIVITY").checkIsOpen = "RADIANCE_WAR_ACTIVITY", true
_ENV = "LUCKY_BLESSING_ACTIVITY"
;("LUCKY_BLESSING_ACTIVITY").viewName = "Activity_9001128_Main"
;("LUCKY_BLESSING_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("LUCKY_BLESSING_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY], ("LUCKY_BLESSING_ACTIVITY").isFgui = "LUCKY_BLESSING_ACTIVITY", true
_ENV = "SIGN_REWARD_ACTIVITY"
;("SIGN_REWARD_ACTIVITY").viewName = "Activity_9001038_Main"
;("SIGN_REWARD_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("SIGN_REWARD_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.SIGN_REWARD_ACTIVITY], ("SIGN_REWARD_ACTIVITY").isFgui = "SIGN_REWARD_ACTIVITY", true
_ENV = "SIGN_REWARD_9001576_ACTIVITY"
;("SIGN_REWARD_9001576_ACTIVITY").viewName = "Activity_9001576_main"
;("SIGN_REWARD_9001576_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("SIGN_REWARD_9001576_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.SIGN_REWARD_9001576_ACTIVITY], ("SIGN_REWARD_9001576_ACTIVITY").isFgui = "SIGN_REWARD_9001576_ACTIVITY", true
_ENV = "OUTS_STANDINGS"
;("OUTS_STANDINGS").viewName = "Activity_9001157_Main"
;("OUTS_STANDINGS").checkCastleLv = CASTLE_LV6_LIMITED
;("OUTS_STANDINGS").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.OUTS_STANDINGS], ("OUTS_STANDINGS").isFgui = "OUTS_STANDINGS", true
_ENV = "EXPEDITON"
;("EXPEDITON").viewName = "eventExpedtionView"
;("EXPEDITON").checkCastleLv = CASTLE_LV6_LIMITED
;("EXPEDITON").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.EXPEDITON], ("EXPEDITON").showTipIcon = "EXPEDITON", "#icon_activity_9001133.png"
_ENV = "ANNIHILATION"
;("ANNIHILATION").viewName = "totalSweepView"
;("ANNIHILATION").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.ANNIHILATION], ("ANNIHILATION").checkIsOpen = "ANNIHILATION", true
_ENV = "ROYAL_SUMMONS"
;("ROYAL_SUMMONS").viewName = "royalSummonsMainView"
;("ROYAL_SUMMONS").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.ROYAL_SUMMONS], ("ROYAL_SUMMONS").checkIsOpen = "ROYAL_SUMMONS", true
_ENV = "ANCIENT_REEL_ACTIVITY"
;("ANCIENT_REEL_ACTIVITY").viewName = "ancientReelMainView"
;("ANCIENT_REEL_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY], ("ANCIENT_REEL_ACTIVITY").checkIsOpen = "ANCIENT_REEL_ACTIVITY", true
_ENV = "STAR_RHAPSODY"
;("STAR_RHAPSODY").viewName = "starRhapsodyActivity"
;("STAR_RHAPSODY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.STAR_RHAPSODY], ("STAR_RHAPSODY").checkIsOpen = "STAR_RHAPSODY", true
_ENV = "RAMADAN_RHAPSODY"
;("RAMADAN_RHAPSODY").viewName = "Activity_9001619_Main"
;("RAMADAN_RHAPSODY").checkCastleLv = CASTLE_LV6_LIMITED
;("RAMADAN_RHAPSODY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.RAMADAN_RHAPSODY], ("RAMADAN_RHAPSODY").isFgui = "RAMADAN_RHAPSODY", true
_ENV = "GEOCENTRIC_ADVENTURE"
;("GEOCENTRIC_ADVENTURE").viewName = "eventGeocentricAdventureView"
;("GEOCENTRIC_ADVENTURE").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GEOCENTRIC_ADVENTURE], ("GEOCENTRIC_ADVENTURE").checkIsOpen = "GEOCENTRIC_ADVENTURE", true
_ENV = "MOVE_CITY_ACTIVIYT"
;("MOVE_CITY_ACTIVIYT").viewName = "LegendaryMoveCityView"
;("MOVE_CITY_ACTIVIYT").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.MOVE_CITY_ACTIVIYT], ("MOVE_CITY_ACTIVIYT").checkIsOpen = "MOVE_CITY_ACTIVIYT", true
_ENV = "UNCHARTED_HELP"
;("UNCHARTED_HELP").viewName = "exchangeUnchartedCoinsView"
;("UNCHARTED_HELP").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.UNCHARTED_HELP], ("UNCHARTED_HELP").checkIsOpen = "UNCHARTED_HELP", true
_ENV = "CHRISTMAS_TREE_PRODUCTION"
;("CHRISTMAS_TREE_PRODUCTION").viewName = "christmasTreeProductionView"
;("CHRISTMAS_TREE_PRODUCTION").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION], ("CHRISTMAS_TREE_PRODUCTION").checkIsOpen = "CHRISTMAS_TREE_PRODUCTION", true
_ENV = "ANNIVERSARY_CELEBRATION"
;("ANNIVERSARY_CELEBRATION").viewName = "anniversaryCelebrationView"
;("ANNIVERSARY_CELEBRATION").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.ANNIVERSARY_CELEBRATION], ("ANNIVERSARY_CELEBRATION").checkIsOpen = "ANNIVERSARY_CELEBRATION", true
_ENV = "COST_GOLD_FOR_GIFT"
;("COST_GOLD_FOR_GIFT").viewName = "costGoldForGiftView"
;("COST_GOLD_FOR_GIFT").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.COST_GOLD_FOR_GIFT], ("COST_GOLD_FOR_GIFT").checkIsOpen = "COST_GOLD_FOR_GIFT", true
_ENV = "SLOT_MACHINE"
;("SLOT_MACHINE").viewName = "oneArmBanditMainView"
;("SLOT_MACHINE").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SLOT_MACHINE], ("SLOT_MACHINE").checkIsOpen = "SLOT_MACHINE", true
_ENV = "SEVEN_DAYS_SIGNIN"
;("SEVEN_DAYS_SIGNIN").viewName = "sevenDaysSignView"
;("SEVEN_DAYS_SIGNIN").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SEVEN_DAYS_SIGNIN], ("SEVEN_DAYS_SIGNIN").checkIsOpen = "SEVEN_DAYS_SIGNIN", true
_ENV = "CHRISTMAS_BATTLE"
;("CHRISTMAS_BATTLE").viewName = "ChristmasBattleView"
;("CHRISTMAS_BATTLE").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CHRISTMAS_BATTLE], ("CHRISTMAS_BATTLE").checkIsOpen = "CHRISTMAS_BATTLE", true
_ENV = "NEW_SERVER_RANK_MATCH"
;("NEW_SERVER_RANK_MATCH").viewName = "kingCompetitionView"
;("NEW_SERVER_RANK_MATCH").checkCastleLv = CASTLE_LV5_LIMITED
clientEventMgr[gActivityTimeActivityID.NEW_SERVER_RANK_MATCH], ("NEW_SERVER_RANK_MATCH").checkIsOpen = "NEW_SERVER_RANK_MATCH", true
_ENV = "EQUIPMENT_REMAKE_ACTIVITY"
;("EQUIPMENT_REMAKE_ACTIVITY").viewName = "scouringBonusView"
;("EQUIPMENT_REMAKE_ACTIVITY").checkCastleLv = CASTLE_LV10_LIMITED
clientEventMgr[gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY], ("EQUIPMENT_REMAKE_ACTIVITY").checkIsOpen = "EQUIPMENT_REMAKE_ACTIVITY", true
_ENV = "HERO_FESTIVAL"
;("HERO_FESTIVAL").viewName = "heroFestivalView"
;("HERO_FESTIVAL").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.HERO_FESTIVAL], ("HERO_FESTIVAL").checkIsOpen = "HERO_FESTIVAL", true
_ENV = "NORMAL_ACTIVITY_9001628"
;("NORMAL_ACTIVITY_9001628").viewName = "Activity_9001628_View"
;("NORMAL_ACTIVITY_9001628").checkIsOpen = true
;("NORMAL_ACTIVITY_9001628").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001628], ("NORMAL_ACTIVITY_9001628").isFgui = "NORMAL_ACTIVITY_9001628", true
_ENV = "NORMAL_ACTIVITY_9001624"
;("NORMAL_ACTIVITY_9001624").viewName = "Activity_9001624_Main"
;("NORMAL_ACTIVITY_9001624").checkIsOpen = true
;("NORMAL_ACTIVITY_9001624").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001624], ("NORMAL_ACTIVITY_9001624").isFgui = "NORMAL_ACTIVITY_9001624", true
_ENV = "CELEBRATE_CORBAN"
;("CELEBRATE_CORBAN").viewName = "Activity_9001624_Main"
;("CELEBRATE_CORBAN").checkIsOpen = true
;("CELEBRATE_CORBAN").checkCastleLv = CASTLE_LV6_LIMITED
_ENV, ("CELEBRATE_CORBAN").isFgui = CASTLE_LV6_LIMITED, true
clientEventMgr[gActivityTimeActivityID.CELEBRATE_CORBAN], ("CELEBRATE_CORBAN").param, CASTLE_LV6_LIMITED.activityID = "CELEBRATE_CORBAN", CASTLE_LV6_LIMITED, gActivityTimeActivityID.CELEBRATE_CORBAN
_ENV = "NORMAL_ACTIVITY_9001629"
;("NORMAL_ACTIVITY_9001629").viewName = "Activity_9001629_Main"
;("NORMAL_ACTIVITY_9001629").checkIsOpen = true
;("NORMAL_ACTIVITY_9001629").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001629], ("NORMAL_ACTIVITY_9001629").isFgui = "NORMAL_ACTIVITY_9001629", true
_ENV = "NEBULA_DISNEYLADN"
;("NEBULA_DISNEYLADN").viewName = "Activity_9001630_Main"
;("NEBULA_DISNEYLADN").checkIsOpen = true
;("NEBULA_DISNEYLADN").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_DISNEYLADN], ("NEBULA_DISNEYLADN").isFgui = "NEBULA_DISNEYLADN", true
_ENV = "GEOCENTRIC_EXPLORATION"
;("GEOCENTRIC_EXPLORATION").viewName = "Activity_9001649_Main"
;("GEOCENTRIC_EXPLORATION").checkIsOpen = true
;("GEOCENTRIC_EXPLORATION").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GEOCENTRIC_EXPLORATION], ("GEOCENTRIC_EXPLORATION").isFgui = "GEOCENTRIC_EXPLORATION", true
_ENV = "MANUAL_GIFT_ACTIVITY"
;("MANUAL_GIFT_ACTIVITY").viewName = "optionalPackageView"
;("MANUAL_GIFT_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.MANUAL_GIFT_ACTIVITY], ("MANUAL_GIFT_ACTIVITY").checkIsOpen = "MANUAL_GIFT_ACTIVITY", true
_ENV = "TREASURE_PACKAGE"
;("TREASURE_PACKAGE").viewName = "treasurePackageView"
;("TREASURE_PACKAGE").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.TREASURE_PACKAGE], ("TREASURE_PACKAGE").checkIsOpen = "TREASURE_PACKAGE", true
_ENV = "KINGDOM_FAVOR"
;("KINGDOM_FAVOR").viewName = "kingdomGraceView"
;("KINGDOM_FAVOR").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.KINGDOM_FAVOR], ("KINGDOM_FAVOR").checkIsOpen = "KINGDOM_FAVOR", true
_ENV = "PUMPKIN_ACTIVITY"
;("PUMPKIN_ACTIVITY").viewName = "pumpkinLanternView"
;("PUMPKIN_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.PUMPKIN_ACTIVITY], ("PUMPKIN_ACTIVITY").checkIsOpen = "PUMPKIN_ACTIVITY", true
_ENV = "DEVELOP_ARMAMENT_ACTIVITY"
;("DEVELOP_ARMAMENT_ACTIVITY").viewName = "eventDevelopArmyView"
;("DEVELOP_ARMAMENT_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("DEVELOP_ARMAMENT_ACTIVITY").checkIsOpen = true
;("DEVELOP_ARMAMENT_ACTIVITY").showTipIcon = "#icon_activity_show_Development_army.png"
clientEventMgr[gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY], ("DEVELOP_ARMAMENT_ACTIVITY").limit = "DEVELOP_ARMAMENT_ACTIVITY", true
_ENV = "CRAZY_GET_POINT_ACTIVITY"
;("CRAZY_GET_POINT_ACTIVITY").viewName = "crazyIntegralMainView"
;("CRAZY_GET_POINT_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("CRAZY_GET_POINT_ACTIVITY").checkIsOpen = true
;("CRAZY_GET_POINT_ACTIVITY").showTipIcon = "#icon_activity_show_9001039.png"
clientEventMgr[gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY], ("CRAZY_GET_POINT_ACTIVITY").limit = "CRAZY_GET_POINT_ACTIVITY", true
_ENV = "MONSTERPALACE_ACTIVITY"
;("MONSTERPALACE_ACTIVITY").viewName = "evilPalaceReadyView"
;("MONSTERPALACE_ACTIVITY").showTipIcon = "#icon_activity_9001040.png"
;("MONSTERPALACE_ACTIVITY").limit = true
;("MONSTERPALACE_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.MONSTERPALACE_ACTIVITY], ("MONSTERPALACE_ACTIVITY").isFgui = "MONSTERPALACE_ACTIVITY", true
_ENV = "ANGRY_SNOW_WOLF_KING_ACTIVITY"
;("ANGRY_SNOW_WOLF_KING_ACTIVITY").viewName = "angerMapView"
;("ANGRY_SNOW_WOLF_KING_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("ANGRY_SNOW_WOLF_KING_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY], ("ANGRY_SNOW_WOLF_KING_ACTIVITY").isFgui = "ANGRY_SNOW_WOLF_KING_ACTIVITY", true
_ENV = "WRATH_BEAST_ACTIVITY"
clientEventMgr[gActivityTimeActivityID.WRATH_BEAST_ACTIVITY], ("WRATH_BEAST_ACTIVITY").viewName = "WRATH_BEAST_ACTIVITY", "wrathBeastMainView"
_ENV = "RECRUITMENT_MATERIALS"
;("RECRUITMENT_MATERIALS").viewName = "CommonTaskActivity"
_ENV, ("RECRUITMENT_MATERIALS").isFgui = "wrathBeastMainView", true
clientEventMgr[gActivityTimeActivityID.RECRUITMENT_MATERIALS], ("RECRUITMENT_MATERIALS").param, ("wrathBeastMainView").activityID = "RECRUITMENT_MATERIALS", "wrathBeastMainView", gActivityTimeActivityID.RECRUITMENT_MATERIALS
_ENV = "RIDES_EXCHANGE_MALL"
;("RIDES_EXCHANGE_MALL").viewName = "ExchangeEventPage"
_ENV, ("RIDES_EXCHANGE_MALL").isFgui = "ExchangeEventPage", true
;("RIDES_EXCHANGE_MALL").param, ("ExchangeEventPage").id = "ExchangeEventPage", gActivityTimeActivityID.RIDES_EXCHANGE_MALL
clientEventMgr[gActivityTimeActivityID.RIDES_EXCHANGE_MALL], ("RIDES_EXCHANGE_MALL").checkIsOpen = "RIDES_EXCHANGE_MALL", true
_ENV = "EXCHANGE_MALL_RED_GEM"
;("EXCHANGE_MALL_RED_GEM").viewName = "ExchangeEventPage"
_ENV, ("EXCHANGE_MALL_RED_GEM").isFgui = "ExchangeEventPage", true
;("EXCHANGE_MALL_RED_GEM").param, ("ExchangeEventPage").id = "ExchangeEventPage", gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM
clientEventMgr[gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM], ("EXCHANGE_MALL_RED_GEM").checkIsOpen = "EXCHANGE_MALL_RED_GEM", true
_ENV = "FULL_DAY_SPRINT_ACTIVITY"
;("FULL_DAY_SPRINT_ACTIVITY").viewName = "eventFullStrengthRush"
;("FULL_DAY_SPRINT_ACTIVITY").initFuncName = "initActivity"
;("FULL_DAY_SPRINT_ACTIVITY").param = gActivityTimeActivityID.FULL_DAY_SPRINT_ACTIVITY
clientEventMgr[gActivityTimeActivityID.FULL_DAY_SPRINT_ACTIVITY], ("FULL_DAY_SPRINT_ACTIVITY").checkIsOpen = "FULL_DAY_SPRINT_ACTIVITY", true
_ENV = "DAILY_DISCOUNT_GIFT_ACTIVITY"
;("DAILY_DISCOUNT_GIFT_ACTIVITY").viewName = "rechargeView"
;("DAILY_DISCOUNT_GIFT_ACTIVITY").initFuncName = "expect2SelectTab"
;("DAILY_DISCOUNT_GIFT_ACTIVITY").param = gRechargeCenterCategory.DAILYADISCOUNT
;("DAILY_DISCOUNT_GIFT_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY], ("DAILY_DISCOUNT_GIFT_ACTIVITY").checkIsOpen = "DAILY_DISCOUNT_GIFT_ACTIVITY", true
_ENV = "PARTY_ACTIVITY"
;("PARTY_ACTIVITY").viewName = "partyView"
;("PARTY_ACTIVITY").initFuncName = "update"
;("PARTY_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.PARTY_ACTIVITY], ("PARTY_ACTIVITY").checkIsOpen = "PARTY_ACTIVITY", true
_ENV = "CUMU_ACTIVITY_RECHARGE"
;("CUMU_ACTIVITY_RECHARGE").viewName = "totalActivityView"
;("CUMU_ACTIVITY_RECHARGE").initFuncName = "initData"
;("CUMU_ACTIVITY_RECHARGE").param = gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE
clientEventMgr[gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE], ("CUMU_ACTIVITY_RECHARGE").checkIsOpen = "CUMU_ACTIVITY_RECHARGE", true
_ENV = "CUMU_ACTIVITY_CONSUME"
;("CUMU_ACTIVITY_CONSUME").viewName = "totalActivityView"
;("CUMU_ACTIVITY_CONSUME").initFuncName = "initData"
;("CUMU_ACTIVITY_CONSUME").param = gActivityTimeActivityID.CUMU_ACTIVITY_CONSUME
clientEventMgr[gActivityTimeActivityID.CUMU_ACTIVITY_CONSUME], ("CUMU_ACTIVITY_CONSUME").checkIsOpen = "CUMU_ACTIVITY_CONSUME", true
_ENV = "CASTLE_REWARD_ACTIVITY"
;("CASTLE_REWARD_ACTIVITY").viewName = "castleRewardView"
clientEventMgr[gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY], ("CASTLE_REWARD_ACTIVITY").checkIsOpen = "CASTLE_REWARD_ACTIVITY", true
_ENV = "KING_OF_GLORY_ACTIVITY"
;("KING_OF_GLORY_ACTIVITY").viewName = "kingOfGloryView"
;("KING_OF_GLORY_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY], ("KING_OF_GLORY_ACTIVITY").checkCastleLv = "KING_OF_GLORY_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "KING_OF_GLORY_ACTIVITY"
;("KING_OF_GLORY_ACTIVITY").viewName = "summerPrayersMainView"
;("KING_OF_GLORY_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY], ("KING_OF_GLORY_ACTIVITY").checkCastleLv = "KING_OF_GLORY_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "GLORIOUS_STAR_LAMP_ACTIVITY"
;("GLORIOUS_STAR_LAMP_ACTIVITY").viewName = "shiningStarLightMainView"
;("GLORIOUS_STAR_LAMP_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY], ("GLORIOUS_STAR_LAMP_ACTIVITY").checkCastleLv = "GLORIOUS_STAR_LAMP_ACTIVITY", CASTLE_LV40_LIMITED
_ENV = "LUXURY_REBATE_ACTIVITY"
;("LUXURY_REBATE_ACTIVITY").viewName = "luxuryRebateActivity"
;("LUXURY_REBATE_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.LUXURY_REBATE_ACTIVITY], ("LUXURY_REBATE_ACTIVITY").checkCastleLv = "LUXURY_REBATE_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "RAIDERS_LOST_ARK"
;("RAIDERS_LOST_ARK").viewName = "raidersLostArkView"
;("RAIDERS_LOST_ARK").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.RAIDERS_LOST_ARK], ("RAIDERS_LOST_ARK").checkCastleLv = "RAIDERS_LOST_ARK", CASTLE_LV16_LIMITED
_ENV = "CANYON_TREASURE_HUNT"
;("CANYON_TREASURE_HUNT").viewName = "canyonTreasureHuntView"
;("CANYON_TREASURE_HUNT").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.CANYON_TREASURE_HUNT], ("CANYON_TREASURE_HUNT").checkCastleLv = "CANYON_TREASURE_HUNT", CASTLE_LV6_LIMITED
_ENV = "PRESENT_GIFT_ACTIVITY"
;("PRESENT_GIFT_ACTIVITY").viewName = "presentGiftMainPopView"
clientEventMgr[gActivityTimeActivityID.PRESENT_GIFT_ACTIVITY], ("PRESENT_GIFT_ACTIVITY").checkIsOpen = "PRESENT_GIFT_ACTIVITY", true
_ENV = "RECHARGE_NEW_USER"
;("RECHARGE_NEW_USER").viewName = "newFeedbackWeekView"
clientEventMgr[gActivityTimeActivityID.RECHARGE_NEW_USER], ("RECHARGE_NEW_USER").checkIsOpen = "RECHARGE_NEW_USER", true
_ENV = "TRAIN_POWER_ACTIVITY"
;("TRAIN_POWER_ACTIVITY").viewName = "trainPowerView"
clientEventMgr[gActivityTimeActivityID.TRAIN_POWER_ACTIVITY], ("TRAIN_POWER_ACTIVITY").checkIsOpen = "TRAIN_POWER_ACTIVITY", true
_ENV = "MAGICAL_DOMINO"
;("MAGICAL_DOMINO").viewName = "petCarnivalView"
clientEventMgr[gActivityTimeActivityID.MAGICAL_DOMINO], ("MAGICAL_DOMINO").checkIsOpen = "MAGICAL_DOMINO", true
_ENV = "HERO_AWAKE_ACTIVTY"
;("HERO_AWAKE_ACTIVTY").viewName = "PopupWindow"
_ENV, ("HERO_AWAKE_ACTIVTY").isFgui = "petCarnivalView", true
;("HERO_AWAKE_ACTIVTY").param, ("petCarnivalView").activityID = "petCarnivalView", gActivityTimeActivityID.HERO_AWAKE_ACTIVTY
clientEventMgr[gActivityTimeActivityID.HERO_AWAKE_ACTIVTY], ("HERO_AWAKE_ACTIVTY").checkIsOpen = "HERO_AWAKE_ACTIVTY", true
_ENV = "HERO_AWAKE_CRIT_ACTIVTY"
;("HERO_AWAKE_CRIT_ACTIVTY").viewName = "PopupWindow"
_ENV, ("HERO_AWAKE_CRIT_ACTIVTY").isFgui = "petCarnivalView", true
;("HERO_AWAKE_CRIT_ACTIVTY").param, ("petCarnivalView").activityID = "petCarnivalView", gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY
clientEventMgr[gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY], ("HERO_AWAKE_CRIT_ACTIVTY").checkIsOpen = "HERO_AWAKE_CRIT_ACTIVTY", true
_ENV = "PLAN_THOROUGH_ACTIVITY"
;("PLAN_THOROUGH_ACTIVITY").viewName = "CommonTaskActivity"
;("PLAN_THOROUGH_ACTIVITY").checkIsOpen = true
_ENV, ("PLAN_THOROUGH_ACTIVITY").isFgui = "petCarnivalView", true
clientEventMgr[gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY], ("PLAN_THOROUGH_ACTIVITY").param, ("petCarnivalView").activityID = "PLAN_THOROUGH_ACTIVITY", "petCarnivalView", gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY
_ENV = "GLORY_ROAD_ACTIVITY"
;("GLORY_ROAD_ACTIVITY").viewName = "RoadToGlory"
;("GLORY_ROAD_ACTIVITY").checkIsOpen = true
;("GLORY_ROAD_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GLORY_ROAD_ACTIVITY], ("GLORY_ROAD_ACTIVITY").isFgui = "GLORY_ROAD_ACTIVITY", true
_ENV = "LUCKY_FALCON"
;("LUCKY_FALCON").viewName = "luckyFalconView"
;("LUCKY_FALCON").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.LUCKY_FALCON], ("LUCKY_FALCON").checkCastleLv = "LUCKY_FALCON", CASTLE_LV6_LIMITED
_ENV = "MERCHANT_OF_SERICA"
;("MERCHANT_OF_SERICA").viewName = "merchantOfSericaView"
;("MERCHANT_OF_SERICA").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.MERCHANT_OF_SERICA], ("MERCHANT_OF_SERICA").checkCastleLv = "MERCHANT_OF_SERICA", CASTLE_LV6_LIMITED
_ENV = "SULTAN_BACK_CALL_FRIENDS"
;("SULTAN_BACK_CALL_FRIENDS").viewName = "sultansBackCallFriendsBackView"
clientEventMgr[gActivityTimeActivityID.SULTAN_BACK_CALL_FRIENDS], ("SULTAN_BACK_CALL_FRIENDS").checkIsOpen = "SULTAN_BACK_CALL_FRIENDS", true
_ENV = "GROOM_HORSES_AND_TROOPS"
;("GROOM_HORSES_AND_TROOPS").viewName = "groomHorsesAndTroops"
;("GROOM_HORSES_AND_TROOPS").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.GROOM_HORSES_AND_TROOPS], ("GROOM_HORSES_AND_TROOPS").checkCastleLv = "GROOM_HORSES_AND_TROOPS", CASTLE_LV6_LIMITED
_ENV = "SINBAD_TREASURE"
;("SINBAD_TREASURE").viewName = "sinbadTreasureView"
clientEventMgr[gActivityTimeActivityID.SINBAD_TREASURE], ("SINBAD_TREASURE").checkIsOpen = "SINBAD_TREASURE", true
_ENV = "ATLANTIS_WAR_ACTIVITY"
;("ATLANTIS_WAR_ACTIVITY").viewName = "atlantisWarActivity"
;("ATLANTIS_WAR_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY], ("ATLANTIS_WAR_ACTIVITY").isFgui = "ATLANTIS_WAR_ACTIVITY", true
_ENV = "CAVALRY_RISE_ACTIVITY"
;("CAVALRY_RISE_ACTIVITY").viewName = "cavalryRiseMainView"
;("CAVALRY_RISE_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY], ("CAVALRY_RISE_ACTIVITY").checkCastleLv = "CAVALRY_RISE_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "SHEEP_RUN_ACTIVITY"
;("SHEEP_RUN_ACTIVITY").viewName = "sheepRunMainView"
;("SHEEP_RUN_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.SHEEP_RUN_ACTIVITY], ("SHEEP_RUN_ACTIVITY").checkCastleLv = "SHEEP_RUN_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "COFFEE_CRAFTSMAN_ACTIVITY"
;("COFFEE_CRAFTSMAN_ACTIVITY").viewName = "CoffeeCraftsmanActivity"
;("COFFEE_CRAFTSMAN_ACTIVITY").checkIsOpen = true
;("COFFEE_CRAFTSMAN_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY], ("COFFEE_CRAFTSMAN_ACTIVITY").isFgui = "COFFEE_CRAFTSMAN_ACTIVITY", true
_ENV = "GOLD_SOUK_ACTIVITY"
;("GOLD_SOUK_ACTIVITY").viewName = "TheBazaar"
;("GOLD_SOUK_ACTIVITY").checkIsOpen = true
;("GOLD_SOUK_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GOLD_SOUK_ACTIVITY], ("GOLD_SOUK_ACTIVITY").isFgui = "GOLD_SOUK_ACTIVITY", true
_ENV = "STARLIGHT_PAVILION_ACTIVITY"
;("STARLIGHT_PAVILION_ACTIVITY").viewName = "StarsTowerMain"
;("STARLIGHT_PAVILION_ACTIVITY").checkIsOpen = true
;("STARLIGHT_PAVILION_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.STARLIGHT_PAVILION_ACTIVITY], ("STARLIGHT_PAVILION_ACTIVITY").isFgui = "STARLIGHT_PAVILION_ACTIVITY", true
_ENV = "LOUDLY_DRESSED_ACTIVITY"
;("LOUDLY_DRESSED_ACTIVITY").viewName = "ThemTakeUI"
;("LOUDLY_DRESSED_ACTIVITY").checkIsOpen = true
;("LOUDLY_DRESSED_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY], ("LOUDLY_DRESSED_ACTIVITY").isFgui = "LOUDLY_DRESSED_ACTIVITY", true
_ENV = "IRON_BLOOD_ACTIVITY"
;("IRON_BLOOD_ACTIVITY").viewName = "bloodyHeroesView"
clientEventMgr[gActivityTimeActivityID.IRON_BLOOD_ACTIVITY], ("IRON_BLOOD_ACTIVITY").checkIsOpen = "IRON_BLOOD_ACTIVITY", true
_ENV = "SMELT_ACTIVITY"
;("SMELT_ACTIVITY").viewName = "smeltMainView"
;("SMELT_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.SMELT_ACTIVITY], ("SMELT_ACTIVITY").checkCastleLv = "SMELT_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "MERMAID_GIFT_ACTIVITY"
;("MERMAID_GIFT_ACTIVITY").viewName = "mermaidGiftMainView"
clientEventMgr[gActivityTimeActivityID.MERMAID_GIFT_ACTIVITY], ("MERMAID_GIFT_ACTIVITY").checkIsOpen = "MERMAID_GIFT_ACTIVITY", true
_ENV = "CAVE_EXPLORE_ACTIVITY"
;("CAVE_EXPLORE_ACTIVITY").viewName = "CaveExploreActivity"
;("CAVE_EXPLORE_ACTIVITY").checkIsOpen = true
;("CAVE_EXPLORE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY], ("CAVE_EXPLORE_ACTIVITY").isFgui = "CAVE_EXPLORE_ACTIVITY", true
_ENV = "WISE_TUTOR_ACTIVITY"
;("WISE_TUTOR_ACTIVITY").viewName = "wiseTutorMain"
;("WISE_TUTOR_ACTIVITY").checkIsOpen = true
;("WISE_TUTOR_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.WISE_TUTOR_ACTIVITY], ("WISE_TUTOR_ACTIVITY").checkCastleLv = "WISE_TUTOR_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "EXOTIC_PAVILION_ACTIVITY"
;("EXOTIC_PAVILION_ACTIVITY").viewName = "ForeignPavilionActivity"
;("EXOTIC_PAVILION_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY], ("EXOTIC_PAVILION_ACTIVITY").isFgui = "EXOTIC_PAVILION_ACTIVITY", true
_ENV = "DESERT_TREASURE_ACTIVITY"
;("DESERT_TREASURE_ACTIVITY").viewName = "DesertSecretTreasure"
;("DESERT_TREASURE_ACTIVITY").checkIsOpen = true
;("DESERT_TREASURE_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.DESERT_TREASURE_ACTIVITY], ("DESERT_TREASURE_ACTIVITY").checkCastleLv = "DESERT_TREASURE_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "NORMAL_ACTIVITY_9001654"
;("NORMAL_ACTIVITY_9001654").viewName = "Activity_9001654_Main"
;("NORMAL_ACTIVITY_9001654").checkIsOpen = true
;("NORMAL_ACTIVITY_9001654").isFgui = true
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001654], ("NORMAL_ACTIVITY_9001654").checkCastleLv = "NORMAL_ACTIVITY_9001654", CASTLE_LV6_LIMITED
_ENV = "NORMAL_ACTIVITY_9001654"
;("NORMAL_ACTIVITY_9001654").viewName = "Activity_9001656_Main"
;("NORMAL_ACTIVITY_9001654").checkIsOpen = true
;("NORMAL_ACTIVITY_9001654").isFgui = true
clientEventMgr[gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY], ("NORMAL_ACTIVITY_9001654").checkCastleLv = "NORMAL_ACTIVITY_9001654", CASTLE_LV6_LIMITED
_ENV = "WASTELAND"
;("WASTELAND").viewName = "wasteland"
;("WASTELAND").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.WASTELAND], ("WASTELAND").isFgui = "WASTELAND", true
_ENV = "ARMYEXCHANGE_ACTIVITY"
;("ARMYEXCHANGE_ACTIVITY").viewName = "troopsExchangeMain"
clientEventMgr[gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY], ("ARMYEXCHANGE_ACTIVITY").isFgui = "ARMYEXCHANGE_ACTIVITY", true
_ENV = "BATTLEFIELD_TRAINING"
;("BATTLEFIELD_TRAINING").viewName = "troopsExchangeTask"
clientEventMgr[gActivityTimeActivityID.BATTLEFIELD_TRAINING], ("BATTLEFIELD_TRAINING").isFgui = "BATTLEFIELD_TRAINING", true
_ENV = "SNOWWOLF_LOST_ACTIVITY"
;("SNOWWOLF_LOST_ACTIVITY").viewName = "SnowWolfLost"
;("SNOWWOLF_LOST_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY], ("SNOWWOLF_LOST_ACTIVITY").checkIsOpen = "SNOWWOLF_LOST_ACTIVITY", true
_ENV = "LEGEND_OF_PEGASUS_ACTIVITY"
;("LEGEND_OF_PEGASUS_ACTIVITY").viewName = "LegendOfPegasusMain"
;("LEGEND_OF_PEGASUS_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY], ("LEGEND_OF_PEGASUS_ACTIVITY").checkIsOpen = "LEGEND_OF_PEGASUS_ACTIVITY", true
_ENV = "NORMAL_ACTIVITY_9001602"
;("NORMAL_ACTIVITY_9001602").viewName = "Activity_9001602_Main"
;("NORMAL_ACTIVITY_9001602").isFgui = true
_ENV, ("NORMAL_ACTIVITY_9001602").checkIsOpen = "Activity_9001602_Main", true
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602], ("NORMAL_ACTIVITY_9001602").param, ("Activity_9001602_Main").activityID = "NORMAL_ACTIVITY_9001602", "Activity_9001602_Main", gActivityTimeActivityID.NORMAL_ACTIVITY_9001602
_ENV = "NORMAL_ACTIVITY_9001696"
;("NORMAL_ACTIVITY_9001696").viewName = "Activity_9001602_Main"
;("NORMAL_ACTIVITY_9001696").isFgui = true
_ENV, ("NORMAL_ACTIVITY_9001696").checkIsOpen = "Activity_9001602_Main", true
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], ("NORMAL_ACTIVITY_9001696").param, ("Activity_9001602_Main").activityID = "NORMAL_ACTIVITY_9001696", "Activity_9001602_Main", gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
_ENV = "HERO_ADVANCE_SKILL_CRIT_ACTIVITY"
;("HERO_ADVANCE_SKILL_CRIT_ACTIVITY").viewName = "PopupWindow"
_ENV, ("HERO_ADVANCE_SKILL_CRIT_ACTIVITY").isFgui = "Activity_9001602_Main", true
;("HERO_ADVANCE_SKILL_CRIT_ACTIVITY").param, ("Activity_9001602_Main").activityID = "Activity_9001602_Main", gActivityTimeActivityID.HERO_ADVANCE_SKILL_CRIT_ACTIVITY
clientEventMgr[gActivityTimeActivityID.HERO_ADVANCE_SKILL_CRIT_ACTIVITY], ("HERO_ADVANCE_SKILL_CRIT_ACTIVITY").checkIsOpen = "HERO_ADVANCE_SKILL_CRIT_ACTIVITY", true
_ENV = "DEADLY_HUNTING_ACTIVITY"
;("DEADLY_HUNTING_ACTIVITY").viewName = "DeadlyHunting"
;("DEADLY_HUNTING_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.DEADLY_HUNTING_ACTIVITY], ("DEADLY_HUNTING_ACTIVITY").checkIsOpen = "DEADLY_HUNTING_ACTIVITY", true
_ENV = "BLACK_GHOST_ACTIVITY"
;("BLACK_GHOST_ACTIVITY").viewName = "BlackGhost"
;("BLACK_GHOST_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.BLACK_GHOST_ACTIVITY], ("BLACK_GHOST_ACTIVITY").checkIsOpen = "BLACK_GHOST_ACTIVITY", true
_ENV = "ARTISAN_HOUSE_ACTIVITY"
;("ARTISAN_HOUSE_ACTIVITY").viewName = "ArtisanHouseMain"
;("ARTISAN_HOUSE_ACTIVITY").checkIsOpen = true
;("ARTISAN_HOUSE_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY], ("ARTISAN_HOUSE_ACTIVITY").checkCastleLv = "ARTISAN_HOUSE_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "RAMADAN_ACCUMULATE_RECHARGE"
;("RAMADAN_ACCUMULATE_RECHARGE").viewName = "RamadanAccuRecharge"
;("RAMADAN_ACCUMULATE_RECHARGE").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE], ("RAMADAN_ACCUMULATE_RECHARGE").isFgui = "RAMADAN_ACCUMULATE_RECHARGE", true
_ENV = "NEBULA_SIGN_ACTIVITY"
;("NEBULA_SIGN_ACTIVITY").viewName = "NebulaRegionSign"
;("NEBULA_SIGN_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.NEBULA_SIGN_ACTIVITY], ("NEBULA_SIGN_ACTIVITY").isFgui = "NEBULA_SIGN_ACTIVITY", true
_ENV = "SHIFTING_STARS_ACTIVITY"
;("SHIFTING_STARS_ACTIVITY").viewName = "Shiftingstars"
;("SHIFTING_STARS_ACTIVITY").checkIsOpen = true
;("SHIFTING_STARS_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
clientEventMgr[gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY], ("SHIFTING_STARS_ACTIVITY").isFgui = "SHIFTING_STARS_ACTIVITY", true
_ENV = "CALENDAR_9001575_ACTIVITY"
;("CALENDAR_9001575_ACTIVITY").viewName = "IceShimmer"
;("CALENDAR_9001575_ACTIVITY").checkIsOpen = true
;("CALENDAR_9001575_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY], ("CALENDAR_9001575_ACTIVITY").isFgui = "CALENDAR_9001575_ACTIVITY", true
_ENV = "STARRY_NIGHT_JOURNEY"
;("STARRY_NIGHT_JOURNEY").viewName = "StarryNightJourney"
;("STARRY_NIGHT_JOURNEY").checkIsOpen = true
;("STARRY_NIGHT_JOURNEY").checkCastleLv = CASTLE_LV110_LIMITED
clientEventMgr[gActivityTimeActivityID.STARRY_NIGHT_JOURNEY], ("STARRY_NIGHT_JOURNEY").isFgui = "STARRY_NIGHT_JOURNEY", true
_ENV = "NEBULA_TREASURE_ACTIVITY"
;("NEBULA_TREASURE_ACTIVITY").viewName = "NebulaTreasure"
;("NEBULA_TREASURE_ACTIVITY").checkIsOpen = true
;("NEBULA_TREASURE_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY], ("NEBULA_TREASURE_ACTIVITY").isFgui = "NEBULA_TREASURE_ACTIVITY", true
_ENV = "STARRY_NIGHT_CARNIVAL"
;("STARRY_NIGHT_CARNIVAL").viewName = "StarryNightCarnival"
;("STARRY_NIGHT_CARNIVAL").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL], ("STARRY_NIGHT_CARNIVAL").isFgui = "STARRY_NIGHT_CARNIVAL", true
_ENV = "NEBULA_WONDERLAND_ACTIVITY"
;("NEBULA_WONDERLAND_ACTIVITY").viewName = "NebulaWonderland"
;("NEBULA_WONDERLAND_ACTIVITY").checkIsOpen = true
;("NEBULA_WONDERLAND_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
;("NEBULA_WONDERLAND_ACTIVITY").checkCastleLv_en = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY], ("NEBULA_WONDERLAND_ACTIVITY").isFgui = "NEBULA_WONDERLAND_ACTIVITY", true
_ENV = "RADIANT_DECREE_ACTIVITY"
;("RADIANT_DECREE_ACTIVITY").viewName = "RadiantDecreeMain"
;("RADIANT_DECREE_ACTIVITY").checkIsOpen = true
;("RADIANT_DECREE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY], ("RADIANT_DECREE_ACTIVITY").isFgui = "RADIANT_DECREE_ACTIVITY", true
_ENV = "NEBULA_KING_ACTIVITY"
;("NEBULA_KING_ACTIVITY").viewName = "NebulaKing"
;("NEBULA_KING_ACTIVITY").checkIsOpen = true
;("NEBULA_KING_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_KING_ACTIVITY], ("NEBULA_KING_ACTIVITY").isFgui = "NEBULA_KING_ACTIVITY", true
_ENV = "NEBULA_COMPETITION_ACTIVITY"
;("NEBULA_COMPETITION_ACTIVITY").viewName = "NebulaCompetition"
;("NEBULA_COMPETITION_ACTIVITY").checkIsOpen = true
;("NEBULA_COMPETITION_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY], ("NEBULA_COMPETITION_ACTIVITY").isFgui = "NEBULA_COMPETITION_ACTIVITY", true
_ENV = "FESTIVAL_ACTIVITY_9001577"
;("FESTIVAL_ACTIVITY_9001577").viewName = "Activity_9001577_Main"
;("FESTIVAL_ACTIVITY_9001577").checkIsOpen = true
;("FESTIVAL_ACTIVITY_9001577").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001577], ("FESTIVAL_ACTIVITY_9001577").isFgui = "FESTIVAL_ACTIVITY_9001577", true
_ENV = "NEBULA_EXPLORATION_ACTIVITY"
;("NEBULA_EXPLORATION_ACTIVITY").viewName = "NebulaTreasureUI"
;("NEBULA_EXPLORATION_ACTIVITY").checkIsOpen = true
;("NEBULA_EXPLORATION_ACTIVITY").checkCastleLv = IsArClient and CASTLE_LV110_LIMITED or CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY], ("NEBULA_EXPLORATION_ACTIVITY").isFgui = "NEBULA_EXPLORATION_ACTIVITY", true
_ENV = "SUPREMACY_ROAD_ACTIVITY"
;("SUPREMACY_ROAD_ACTIVITY").viewName = "SupremacyRoad"
;("SUPREMACY_ROAD_ACTIVITY").checkIsOpen = true
;("SUPREMACY_ROAD_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
clientEventMgr[gActivityTimeActivityID.SUPREMACY_ROAD_ACTIVITY], ("SUPREMACY_ROAD_ACTIVITY").isFgui = "SUPREMACY_ROAD_ACTIVITY", true
_ENV = "NEBULA_PRIVILEGE"
;("NEBULA_PRIVILEGE").viewName = "NebulaActivity"
;("NEBULA_PRIVILEGE").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.NEBULA_PRIVILEGE], ("NEBULA_PRIVILEGE").isFgui = "NEBULA_PRIVILEGE", true
_ENV = "DESERT_UNDERGROUND_CITY_ACTIVITY"
;("DESERT_UNDERGROUND_CITY_ACTIVITY").viewName = "DesertUnderCity"
;("DESERT_UNDERGROUND_CITY_ACTIVITY").checkIsOpen = true
;("DESERT_UNDERGROUND_CITY_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.DESERT_UNDERGROUND_CITY_ACTIVITY], ("DESERT_UNDERGROUND_CITY_ACTIVITY").checkCastleLv = "DESERT_UNDERGROUND_CITY_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "COMMAND_HALL_ACTIVITY"
;("COMMAND_HALL_ACTIVITY").viewName = "CommandHallMain"
;("COMMAND_HALL_ACTIVITY").checkCastleLvKey = "COMMANDHALL_OPEN_LV"
;("COMMAND_HALL_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.COMMAND_HALL_ACTIVITY], ("COMMAND_HALL_ACTIVITY").checkInCrossWar = "COMMAND_HALL_ACTIVITY", true
_ENV = "FOOTBALL_KING_ACTIVITY"
;("FOOTBALL_KING_ACTIVITY").viewName = "FootballKingRoad"
;("FOOTBALL_KING_ACTIVITY").checkIsOpen = true
;("FOOTBALL_KING_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY], ("FOOTBALL_KING_ACTIVITY").isFgui = "FOOTBALL_KING_ACTIVITY", true
_ENV = "MAGIC_LAMP_SKILL_SHELTER_ACTIVITY"
;("MAGIC_LAMP_SKILL_SHELTER_ACTIVITY").viewName = "SanctuaryDivine"
;("MAGIC_LAMP_SKILL_SHELTER_ACTIVITY").isFgui = true
;("MAGIC_LAMP_SKILL_SHELTER_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.MAGIC_LAMP_SKILL_SHELTER_ACTIVITY], ("MAGIC_LAMP_SKILL_SHELTER_ACTIVITY").checkCastleLv = "MAGIC_LAMP_SKILL_SHELTER_ACTIVITY", CASTLE_LV110_LIMITED
_ENV = "MONSTER_INVASION_ACTIVITY"
;("MONSTER_INVASION_ACTIVITY").viewName = "SunnyLaneMain"
;("MONSTER_INVASION_ACTIVITY").isFgui = true
;("MONSTER_INVASION_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.MONSTER_INVASION_ACTIVITY], ("MONSTER_INVASION_ACTIVITY").checkCastleLv = "MONSTER_INVASION_ACTIVITY", CASTLE_LV110_LIMITED
_ENV = "DICTATORSHIPS_ACTIVITY"
;("DICTATORSHIPS_ACTIVITY").viewName = "Activity_9001486_Main"
;("DICTATORSHIPS_ACTIVITY").isFgui = true
_ENV, ("DICTATORSHIPS_ACTIVITY").checkIsOpen = "Activity_9001486_Main", true
;("DICTATORSHIPS_ACTIVITY").param, ("Activity_9001486_Main").activityID = "Activity_9001486_Main", gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY
clientEventMgr[gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY], ("DICTATORSHIPS_ACTIVITY").checkCastleLv = "DICTATORSHIPS_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "NEW_DICTATORSHIPS_ACTIVITY"
;("NEW_DICTATORSHIPS_ACTIVITY").viewName = "Activity_9001486_Main"
;("NEW_DICTATORSHIPS_ACTIVITY").isFgui = true
_ENV, ("NEW_DICTATORSHIPS_ACTIVITY").checkIsOpen = "Activity_9001486_Main", true
;("NEW_DICTATORSHIPS_ACTIVITY").param, ("Activity_9001486_Main").activityID = "Activity_9001486_Main", gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY
clientEventMgr[gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY], ("NEW_DICTATORSHIPS_ACTIVITY").checkCastleLv = "NEW_DICTATORSHIPS_ACTIVITY", CASTLE_LV6_LIMITED
_ENV = "GREAT_ARMOR_ACTIVITY_1"
;("GREAT_ARMOR_ACTIVITY_1").viewName = "Activity_9001487_Main"
_ENV, ("GREAT_ARMOR_ACTIVITY_1").checkIsOpen = "Activity_9001487_Main", true
;("GREAT_ARMOR_ACTIVITY_1").param, ("Activity_9001487_Main").activityID = "Activity_9001487_Main", gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1
;("GREAT_ARMOR_ACTIVITY_1").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1], ("GREAT_ARMOR_ACTIVITY_1").isFgui = "GREAT_ARMOR_ACTIVITY_1", true
_ENV = "GREAT_ARMOR_ACTIVITY_2"
;("GREAT_ARMOR_ACTIVITY_2").viewName = "Activity_9001487_Main"
_ENV, ("GREAT_ARMOR_ACTIVITY_2").checkIsOpen = "Activity_9001487_Main", true
;("GREAT_ARMOR_ACTIVITY_2").param, ("Activity_9001487_Main").activityID = "Activity_9001487_Main", gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_2
;("GREAT_ARMOR_ACTIVITY_2").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_2], ("GREAT_ARMOR_ACTIVITY_2").isFgui = "GREAT_ARMOR_ACTIVITY_2", true
_ENV = "GREAT_ARMOR_ACTIVITY_3"
;("GREAT_ARMOR_ACTIVITY_3").viewName = "Activity_9001487_Main"
_ENV, ("GREAT_ARMOR_ACTIVITY_3").checkIsOpen = "Activity_9001487_Main", true
;("GREAT_ARMOR_ACTIVITY_3").param, ("Activity_9001487_Main").activityID = "Activity_9001487_Main", gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3
;("GREAT_ARMOR_ACTIVITY_3").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_3], ("GREAT_ARMOR_ACTIVITY_3").isFgui = "GREAT_ARMOR_ACTIVITY_3", true
_ENV = "EXTREMELY_SKILLFUIL"
;("EXTREMELY_SKILLFUIL").viewName = "ExtremelySkillfulMain"
;("EXTREMELY_SKILLFUIL").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.EXTREMELY_SKILLFUIL], ("EXTREMELY_SKILLFUIL").isFgui = "EXTREMELY_SKILLFUIL", true
_ENV = "STAR_LIGHT_LAMP_ACTIVITY"
;("STAR_LIGHT_LAMP_ACTIVITY").viewName = "Activity_9001492_Main"
;("STAR_LIGHT_LAMP_ACTIVITY").checkIsOpen = true
;("STAR_LIGHT_LAMP_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.STAR_LIGHT_LAMP_ACTIVITY], ("STAR_LIGHT_LAMP_ACTIVITY").isFgui = "STAR_LIGHT_LAMP_ACTIVITY", true
_ENV = "BUILD_THRIVING_ACTIVITY"
;("BUILD_THRIVING_ACTIVITY").viewName = "Activity_9001496_Main"
;("BUILD_THRIVING_ACTIVITY").checkIsOpen = true
;("BUILD_THRIVING_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY], ("BUILD_THRIVING_ACTIVITY").isFgui = "BUILD_THRIVING_ACTIVITY", true
_ENV = "STAR_TREASURY_ACTIVITY"
;("STAR_TREASURY_ACTIVITY").viewName = "StarTreasuryMain"
;("STAR_TREASURY_ACTIVITY").checkIsOpen = true
;("STAR_TREASURY_ACTIVITY").checkCastleStarLv = include("constantRead").getConstValue("UNLOCK_9001497")
clientEventMgr[gActivityTimeActivityID.STAR_TREASURY_ACTIVITY], ("STAR_TREASURY_ACTIVITY").isFgui = "STAR_TREASURY_ACTIVITY", true
_ENV = "STAR_LAMP_CEREMONY_ACTIVITY"
;("STAR_LAMP_CEREMONY_ACTIVITY").viewName = "StarLampCeremonyMain"
;("STAR_LAMP_CEREMONY_ACTIVITY").checkIsOpen = true
;("STAR_LAMP_CEREMONY_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.STAR_LAMP_CEREMONY_ACTIVITY], ("STAR_LAMP_CEREMONY_ACTIVITY").isFgui = "STAR_LAMP_CEREMONY_ACTIVITY", true
_ENV = "ALLIANCE_DINNER_ACTIVITY"
;("ALLIANCE_DINNER_ACTIVITY").viewName = "AllianceDinnerMain"
;("ALLIANCE_DINNER_ACTIVITY").checkIsOpen = true
;("ALLIANCE_DINNER_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("ALLIANCE_DINNER_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.ALLIANCE_DINNER_ACTIVITY], ("ALLIANCE_DINNER_ACTIVITY").checkHasJoinAlliance = "ALLIANCE_DINNER_ACTIVITY", true
_ENV = "MAGIC_FLIP_ACTIVITY"
;("MAGIC_FLIP_ACTIVITY").viewName = "MagicLampActivity"
;("MAGIC_FLIP_ACTIVITY").checkIsOpen = true
;("MAGIC_FLIP_ACTIVITY").checkCastleStarLv = include("constantRead").getConstValue("UNLOCK_CONDITION")
clientEventMgr[gActivityTimeActivityID.MAGIC_FLIP_ACTIVITY], ("MAGIC_FLIP_ACTIVITY").isFgui = "MAGIC_FLIP_ACTIVITY", true
_ENV = "ROCKET_RUSH"
;("ROCKET_RUSH").viewName = "SkyrocketView"
;("ROCKET_RUSH").checkIsOpen = true
;("ROCKET_RUSH").checkCastleLv = CASTLE_LV7_LIMITED
clientEventMgr[gActivityTimeActivityID.ROCKET_RUSH], ("ROCKET_RUSH").isFgui = "ROCKET_RUSH", true
_ENV = "BEACH_TREASURE_ACTIVITY"
;("BEACH_TREASURE_ACTIVITY").viewName = "BeachHuntView"
;("BEACH_TREASURE_ACTIVITY").checkIsOpen = true
;("BEACH_TREASURE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.BEACH_TREASURE_ACTIVITY], ("BEACH_TREASURE_ACTIVITY").isFgui = "BEACH_TREASURE_ACTIVITY", true
_ENV = "LUCKY_WRETCH_ACTIVITY"
;("LUCKY_WRETCH_ACTIVITY").viewName = "LuckyWretchMain"
;("LUCKY_WRETCH_ACTIVITY").checkIsOpen = true
;("LUCKY_WRETCH_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LUCKY_WRETCH_ACTIVITY], ("LUCKY_WRETCH_ACTIVITY").isFgui = "LUCKY_WRETCH_ACTIVITY", true
_ENV = "SERICA_SHOP_ACTIVITY"
;("SERICA_SHOP_ACTIVITY").viewName = "SiriusMerchant"
;("SERICA_SHOP_ACTIVITY").checkIsOpen = true
;("SERICA_SHOP_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SERICA_SHOP_ACTIVITY], ("SERICA_SHOP_ACTIVITY").isFgui = "SERICA_SHOP_ACTIVITY", true
_ENV = "BRIGHT_FIREWORKS_ACTIVITY"
;("BRIGHT_FIREWORKS_ACTIVITY").viewName = "Activity_9001531_Main"
;("BRIGHT_FIREWORKS_ACTIVITY").checkIsOpen = true
;("BRIGHT_FIREWORKS_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.BRIGHT_FIREWORKS_ACTIVITY], ("BRIGHT_FIREWORKS_ACTIVITY").isFgui = "BRIGHT_FIREWORKS_ACTIVITY", true
_ENV = "SULTAN_COIN_REBATE_ACTIVITY"
;("SULTAN_COIN_REBATE_ACTIVITY").viewName = "SultanCoinGiftMain"
;("SULTAN_COIN_REBATE_ACTIVITY").checkIsOpen = true
;("SULTAN_COIN_REBATE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SULTAN_COIN_REBATE_ACTIVITY], ("SULTAN_COIN_REBATE_ACTIVITY").isFgui = "SULTAN_COIN_REBATE_ACTIVITY", true
_ENV = "NEBULA_EMPEROR_SHOW_ACTIVITY"
;("NEBULA_EMPEROR_SHOW_ACTIVITY").viewName = "NebulaEmperor"
;("NEBULA_EMPEROR_SHOW_ACTIVITY").checkIsOpen = true
;("NEBULA_EMPEROR_SHOW_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_EMPEROR_SHOW_ACTIVITY], ("NEBULA_EMPEROR_SHOW_ACTIVITY").isFgui = "NEBULA_EMPEROR_SHOW_ACTIVITY", true
_ENV = "LORD_OF_DESSERT_ACTIVITY"
;("LORD_OF_DESSERT_ACTIVITY").viewName = "DessertsKingMain"
;("LORD_OF_DESSERT_ACTIVITY").checkIsOpen = true
;("LORD_OF_DESSERT_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LORD_OF_DESSERT_ACTIVITY], ("LORD_OF_DESSERT_ACTIVITY").isFgui = "LORD_OF_DESSERT_ACTIVITY", true
_ENV = "EID_SIGN_ACTIVITY"
;("EID_SIGN_ACTIVITY").viewName = "DashainGiftingMain"
;("EID_SIGN_ACTIVITY").checkIsOpen = true
;("EID_SIGN_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.EID_SIGN_ACTIVITY], ("EID_SIGN_ACTIVITY").isFgui = "EID_SIGN_ACTIVITY", true
_ENV = "SWEET_MEAT_ROBBER_ACTIVITY"
;("SWEET_MEAT_ROBBER_ACTIVITY").viewName = "DessertThiefMain"
;("SWEET_MEAT_ROBBER_ACTIVITY").checkIsOpen = true
;("SWEET_MEAT_ROBBER_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
;("SWEET_MEAT_ROBBER_ACTIVITY").isFgui = true
clientEventMgr[gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY], ("SWEET_MEAT_ROBBER_ACTIVITY").checkHasJoinAlliance = "SWEET_MEAT_ROBBER_ACTIVITY", true
_ENV = "LOTTERY_ACTIVITY_9001546"
;("LOTTERY_ACTIVITY_9001546").viewName = "OpenSesameView"
;("LOTTERY_ACTIVITY_9001546").checkIsOpen = true
;("LOTTERY_ACTIVITY_9001546").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546], ("LOTTERY_ACTIVITY_9001546").isFgui = "LOTTERY_ACTIVITY_9001546", true
_ENV = "LOTTERY_ACTIVITY_9001545"
;("LOTTERY_ACTIVITY_9001545").viewName = "DesertMiningView"
;("LOTTERY_ACTIVITY_9001545").checkIsOpen = true
;("LOTTERY_ACTIVITY_9001545").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545], ("LOTTERY_ACTIVITY_9001545").isFgui = "LOTTERY_ACTIVITY_9001545", true
_ENV = "LOTTERY_ACTIVITY_9001544"
;("LOTTERY_ACTIVITY_9001544").viewName = "HappyEggView"
;("LOTTERY_ACTIVITY_9001544").checkIsOpen = true
;("LOTTERY_ACTIVITY_9001544").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544], ("LOTTERY_ACTIVITY_9001544").isFgui = "LOTTERY_ACTIVITY_9001544", true
_ENV = "FESTIVAL_ACTIVITY_9001604"
;("FESTIVAL_ACTIVITY_9001604").viewName = "Activity_9001604_Main"
;("FESTIVAL_ACTIVITY_9001604").checkIsOpen = true
;("FESTIVAL_ACTIVITY_9001604").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604], ("FESTIVAL_ACTIVITY_9001604").isFgui = "FESTIVAL_ACTIVITY_9001604", true
_ENV = "DIVINE_BEAST_CANYON_ACTIVITY"
;("DIVINE_BEAST_CANYON_ACTIVITY").viewName = "BeastCanyonMain"
_ENV, ("DIVINE_BEAST_CANYON_ACTIVITY").checkIsOpen = "BeastCanyonMain", true
;("DIVINE_BEAST_CANYON_ACTIVITY").param, ("BeastCanyonMain").activityID = "BeastCanyonMain", gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
;("DIVINE_BEAST_CANYON_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY], ("DIVINE_BEAST_CANYON_ACTIVITY").isFgui = "DIVINE_BEAST_CANYON_ACTIVITY", true
_ENV = "NORMAL_ACTIVITY_9001650"
;("NORMAL_ACTIVITY_9001650").viewName = "BeastCanyonMain"
_ENV, ("NORMAL_ACTIVITY_9001650").checkIsOpen = "BeastCanyonMain", true
;("NORMAL_ACTIVITY_9001650").param, ("BeastCanyonMain").activityID = "BeastCanyonMain", gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
;("NORMAL_ACTIVITY_9001650").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001650], ("NORMAL_ACTIVITY_9001650").isFgui = "NORMAL_ACTIVITY_9001650", true
_ENV = "STELLAR_ODYSSEY_ACTIVITY"
;("STELLAR_ODYSSEY_ACTIVITY").viewName = "Activity_9001558_Main"
;("STELLAR_ODYSSEY_ACTIVITY").checkIsOpen = true
;("STELLAR_ODYSSEY_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.STELLAR_ODYSSEY_ACTIVITY], ("STELLAR_ODYSSEY_ACTIVITY").isFgui = "STELLAR_ODYSSEY_ACTIVITY", true
_ENV = "LOTTERY_ACTIVITY_9001563"
;("LOTTERY_ACTIVITY_9001563").viewName = "Activity_9001563_Main"
;("LOTTERY_ACTIVITY_9001563").checkIsOpen = true
;("LOTTERY_ACTIVITY_9001563").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001563], ("LOTTERY_ACTIVITY_9001563").isFgui = "LOTTERY_ACTIVITY_9001563", true
_ENV = "MAGIC_LAMP_ORDER_ACTIVITY"
;("MAGIC_LAMP_ORDER_ACTIVITY").viewName = "Activity_9001565_Main"
_ENV, ("MAGIC_LAMP_ORDER_ACTIVITY").checkIsOpen = "Activity_9001565_Main", true
;("MAGIC_LAMP_ORDER_ACTIVITY").param, ("Activity_9001565_Main").activityID = "Activity_9001565_Main", gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY
;("MAGIC_LAMP_ORDER_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY], ("MAGIC_LAMP_ORDER_ACTIVITY").isFgui = "MAGIC_LAMP_ORDER_ACTIVITY", true
_ENV = "MAGIC_LAMP_HATCH_ORDER_ACTIVITY"
;("MAGIC_LAMP_HATCH_ORDER_ACTIVITY").viewName = "Activity_9001565_Main"
;("MAGIC_LAMP_HATCH_ORDER_ACTIVITY").checkIsOpen = true
_ENV, ("MAGIC_LAMP_HATCH_ORDER_ACTIVITY").isFgui = "Activity_9001565_Main", true
;("MAGIC_LAMP_HATCH_ORDER_ACTIVITY").param, ("Activity_9001565_Main").activityID = "Activity_9001565_Main", gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY
_ENV = gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY
gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY[BUILD_ENUM.MAGIC_LAMP] = 201
clientEventMgr[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY], ("MAGIC_LAMP_HATCH_ORDER_ACTIVITY").checkBuildLv, gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY[BUILD_ENUM.MAGIC_LAMP_HATCH] = "MAGIC_LAMP_HATCH_ORDER_ACTIVITY", gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY, 14
_ENV = "NORMAL_ACTIVITY_9001701"
;("NORMAL_ACTIVITY_9001701").viewName = "Activity_9001565_Main"
;("NORMAL_ACTIVITY_9001701").checkIsOpen = true
_ENV, ("NORMAL_ACTIVITY_9001701").isFgui = "Activity_9001565_Main", true
;("NORMAL_ACTIVITY_9001701").param, ("Activity_9001565_Main").activityID = "Activity_9001565_Main", gActivityTimeActivityID.NORMAL_ACTIVITY_9001701
_UPVALUE1_ = gActivityTimeActivityID.NORMAL_ACTIVITY_9001701
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], ("NORMAL_ACTIVITY_9001701").checkBuildLock, gActivityTimeActivityID.NORMAL_ACTIVITY_9001701[1] = "NORMAL_ACTIVITY_9001701", gActivityTimeActivityID.NORMAL_ACTIVITY_9001701, BUILD_ENUM.TWO_MAGIC_LAMP
_ENV = "NORMAL_ACTIVITY_9001573"
;("NORMAL_ACTIVITY_9001573").viewName = "Activity_9001573_Main"
;("NORMAL_ACTIVITY_9001573").checkIsOpen = true
;("NORMAL_ACTIVITY_9001573").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001573], ("NORMAL_ACTIVITY_9001573").isFgui = "NORMAL_ACTIVITY_9001573", true
_ENV = "RAMADAN_SURPRISED_DROP"
;("RAMADAN_SURPRISED_DROP").viewName = "eventRamadanHarvest"
;("RAMADAN_SURPRISED_DROP").checkIsOpen = true
;("RAMADAN_SURPRISED_DROP").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.RAMADAN_SURPRISED_DROP], ("RAMADAN_SURPRISED_DROP").isFgui = "RAMADAN_SURPRISED_DROP", true
_ENV = "FESTIVAL_ACTIVITY_9001662"
;("FESTIVAL_ACTIVITY_9001662").viewName = "eventRamadanHarvest"
;("FESTIVAL_ACTIVITY_9001662").checkIsOpen = true
_ENV, ("FESTIVAL_ACTIVITY_9001662").checkCastleLv = CASTLE_LV6_LIMITED, CASTLE_LV6_LIMITED
;("FESTIVAL_ACTIVITY_9001662").param, CASTLE_LV6_LIMITED.activityID = CASTLE_LV6_LIMITED, gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001662
clientEventMgr[gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001662], ("FESTIVAL_ACTIVITY_9001662").isFgui = "FESTIVAL_ACTIVITY_9001662", true
_ENV = "FESTIVAL_ACTIVITY_9001662"
;("FESTIVAL_ACTIVITY_9001662").viewName = "Activity_9001594_Main"
;("FESTIVAL_ACTIVITY_9001662").checkIsOpen = true
;("FESTIVAL_ACTIVITY_9001662").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY], ("FESTIVAL_ACTIVITY_9001662").isFgui = "FESTIVAL_ACTIVITY_9001662", true
_ENV = "CALENDAR_9001593_ACTIVITY"
;("CALENDAR_9001593_ACTIVITY").viewName = "Activity_9001593_Main"
;("CALENDAR_9001593_ACTIVITY").checkIsOpen = true
;("CALENDAR_9001593_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY], ("CALENDAR_9001593_ACTIVITY").isFgui = "CALENDAR_9001593_ACTIVITY", true
_ENV = "CALENDAR_9001690_ACTIVITY"
;("CALENDAR_9001690_ACTIVITY").viewName = "Activity_9001690_Main"
;("CALENDAR_9001690_ACTIVITY").checkIsOpen = true
;("CALENDAR_9001690_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY], ("CALENDAR_9001690_ACTIVITY").isFgui = "CALENDAR_9001690_ACTIVITY", true
_ENV = "NORMAL_ACTIVITY_9001601"
;("NORMAL_ACTIVITY_9001601").viewName = "Activity_9001601_Main"
;("NORMAL_ACTIVITY_9001601").checkIsOpen = true
;("NORMAL_ACTIVITY_9001601").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001601], ("NORMAL_ACTIVITY_9001601").isFgui = "NORMAL_ACTIVITY_9001601", true
_ENV = "SIGN_REWARD_9001623_ACTIVITY"
;("SIGN_REWARD_9001623_ACTIVITY").viewName = "Activity_9001623_Main"
;("SIGN_REWARD_9001623_ACTIVITY").checkIsOpen = true
;("SIGN_REWARD_9001623_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY], ("SIGN_REWARD_9001623_ACTIVITY").isFgui = "SIGN_REWARD_9001623_ACTIVITY", true
_ENV = "SIGN_REWARD_9001623_ACTIVITY"
;("SIGN_REWARD_9001623_ACTIVITY").viewName = "Activity_9001622_Main"
;("SIGN_REWARD_9001623_ACTIVITY").checkIsOpen = true
;("SIGN_REWARD_9001623_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.END_OF_RAMADAN_ADVANCE], ("SIGN_REWARD_9001623_ACTIVITY").isFgui = "SIGN_REWARD_9001623_ACTIVITY", true
_ENV = "GATHERING_FEAST_2024"
;("GATHERING_FEAST_2024").viewName = "Activity_9001625_Main"
;("GATHERING_FEAST_2024").checkIsOpen = true
;("GATHERING_FEAST_2024").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GATHERING_FEAST_2024], ("GATHERING_FEAST_2024").isFgui = "GATHERING_FEAST_2024", true
_ENV = "PREPARING_FEAST_2024"
;("PREPARING_FEAST_2024").viewName = "Activity_9001631_Main"
;("PREPARING_FEAST_2024").checkIsOpen = true
;("PREPARING_FEAST_2024").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.PREPARING_FEAST_2024], ("PREPARING_FEAST_2024").isFgui = "PREPARING_FEAST_2024", true
_ENV = "SIGN_REWARD_9001636_ACTIVITY"
;("SIGN_REWARD_9001636_ACTIVITY").viewName = "Activity_9001636_Main"
;("SIGN_REWARD_9001636_ACTIVITY").checkIsOpen = true
;("SIGN_REWARD_9001636_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY], ("SIGN_REWARD_9001636_ACTIVITY").isFgui = "SIGN_REWARD_9001636_ACTIVITY", true
_ENV = "CORBAN_MARKET_ACTIVITY"
;("CORBAN_MARKET_ACTIVITY").viewName = "Activity_9001639_Main"
;("CORBAN_MARKET_ACTIVITY").checkIsOpen = true
;("CORBAN_MARKET_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CORBAN_MARKET_ACTIVITY], ("CORBAN_MARKET_ACTIVITY").isFgui = "CORBAN_MARKET_ACTIVITY", true
_ENV = "PHOENIX_ARRIVAL"
;("PHOENIX_ARRIVAL").viewName = "Activity_9001640_Main"
;("PHOENIX_ARRIVAL").checkIsOpen = true
;("PHOENIX_ARRIVAL").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.PHOENIX_ARRIVAL], ("PHOENIX_ARRIVAL").isFgui = "PHOENIX_ARRIVAL", true
_ENV = "PHOENIX_CHALLENGE"
;("PHOENIX_CHALLENGE").viewName = "Activity_9001642_Main"
;("PHOENIX_CHALLENGE").checkIsOpen = true
;("PHOENIX_CHALLENGE").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.PHOENIX_CHALLENGE], ("PHOENIX_CHALLENGE").isFgui = "PHOENIX_CHALLENGE", true
_ENV = "EID_CELEBRATION_ACTIVITY"
;("EID_CELEBRATION_ACTIVITY").viewName = "Activity_9001643_main"
;("EID_CELEBRATION_ACTIVITY").checkIsOpen = true
;("EID_CELEBRATION_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.EID_CELEBRATION_ACTIVITY], ("EID_CELEBRATION_ACTIVITY").isFgui = "EID_CELEBRATION_ACTIVITY", true
_ENV = "NORMAL_ACTIVITY_9001638"
;("NORMAL_ACTIVITY_9001638").viewName = "Activity_9001638_Main"
;("NORMAL_ACTIVITY_9001638").checkIsOpen = true
;("NORMAL_ACTIVITY_9001638").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001638], ("NORMAL_ACTIVITY_9001638").isFgui = "NORMAL_ACTIVITY_9001638", true
_ENV = "NEBULA_FURNACE_ACTIVITY"
;("NEBULA_FURNACE_ACTIVITY").viewName = "Activity_9001651_Main"
;("NEBULA_FURNACE_ACTIVITY").checkIsOpen = true
;("NEBULA_FURNACE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY], ("NEBULA_FURNACE_ACTIVITY").isFgui = "NEBULA_FURNACE_ACTIVITY", true
_ENV = "MERGE_SERVER_ACTIVITY"
;("MERGE_SERVER_ACTIVITY").viewName = "Activity_9001657_Main"
;("MERGE_SERVER_ACTIVITY").checkIsOpen = true
clientEventMgr[gActivityTimeActivityID.MERGE_SERVER_ACTIVITY], ("MERGE_SERVER_ACTIVITY").isFgui = "MERGE_SERVER_ACTIVITY", true
_ENV = "SIGN_REWARD_9001659_ACTIVITY"
;("SIGN_REWARD_9001659_ACTIVITY").viewName = "Activity_9001659_Main"
;("SIGN_REWARD_9001659_ACTIVITY").checkIsOpen = true
;("SIGN_REWARD_9001659_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY], ("SIGN_REWARD_9001659_ACTIVITY").isFgui = "SIGN_REWARD_9001659_ACTIVITY", true
_ENV = "SIGN_REWARD_9001687_ACTIVITY"
;("SIGN_REWARD_9001687_ACTIVITY").viewName = "Activity_9001687_Main"
;("SIGN_REWARD_9001687_ACTIVITY").checkIsOpen = true
;("SIGN_REWARD_9001687_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.SIGN_REWARD_9001687_ACTIVITY], ("SIGN_REWARD_9001687_ACTIVITY").isFgui = "SIGN_REWARD_9001687_ACTIVITY", true
_ENV = "NORMAL_ACTIVITY_9001665"
;("NORMAL_ACTIVITY_9001665").viewName = "Activity_9001665_Main"
;("NORMAL_ACTIVITY_9001665").checkIsOpen = true
;("NORMAL_ACTIVITY_9001665").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001665], ("NORMAL_ACTIVITY_9001665").isFgui = "NORMAL_ACTIVITY_9001665", true
_ENV = "NORMAL_ACTIVITY_9001669"
;("NORMAL_ACTIVITY_9001669").viewName = "Activity_9001669_Main"
;("NORMAL_ACTIVITY_9001669").checkIsOpen = true
;("NORMAL_ACTIVITY_9001669").isFgui = true
_ENV, ("NORMAL_ACTIVITY_9001669").checkCastleLv = CASTLE_LV6_LIMITED, CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001669], ("NORMAL_ACTIVITY_9001669").param, CASTLE_LV6_LIMITED.activityID = "NORMAL_ACTIVITY_9001669", CASTLE_LV6_LIMITED, gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
_ENV = "NORMAL_ACTIVITY_9001699"
;("NORMAL_ACTIVITY_9001699").viewName = "Activity_9001699_Main"
;("NORMAL_ACTIVITY_9001699").checkIsOpen = true
;("NORMAL_ACTIVITY_9001699").isFgui = true
_ENV, ("NORMAL_ACTIVITY_9001699").checkCastleLv = CASTLE_LV6_LIMITED, CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001699], ("NORMAL_ACTIVITY_9001699").param, CASTLE_LV6_LIMITED.activityID = "NORMAL_ACTIVITY_9001699", CASTLE_LV6_LIMITED, gActivityTimeActivityID.NORMAL_ACTIVITY_9001699
_ENV = "NORMAL_ACTIVITY_9001664"
;("NORMAL_ACTIVITY_9001664").viewName = "Activity_9001664_Main"
;("NORMAL_ACTIVITY_9001664").checkIsOpen = true
;("NORMAL_ACTIVITY_9001664").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001664], ("NORMAL_ACTIVITY_9001664").isFgui = "NORMAL_ACTIVITY_9001664", true
_ENV = "NORMAL_ACTIVITY_9001666"
;("NORMAL_ACTIVITY_9001666").viewName = "Activity_9001666_Main"
;("NORMAL_ACTIVITY_9001666").checkIsOpen = true
;("NORMAL_ACTIVITY_9001666").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001666], ("NORMAL_ACTIVITY_9001666").isFgui = "NORMAL_ACTIVITY_9001666", true
_ENV = "NORMAL_ACTIVITY_9001705"
;("NORMAL_ACTIVITY_9001705").viewName = "Activity_9001705_Main"
;("NORMAL_ACTIVITY_9001705").checkIsOpen = true
;("NORMAL_ACTIVITY_9001705").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001705], ("NORMAL_ACTIVITY_9001705").isFgui = "NORMAL_ACTIVITY_9001705", true
_ENV = "NORMAL_ACTIVITY_9001676"
;("NORMAL_ACTIVITY_9001676").viewName = "Activity_9001676_Main"
;("NORMAL_ACTIVITY_9001676").checkIsOpen = true
;("NORMAL_ACTIVITY_9001676").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001676], ("NORMAL_ACTIVITY_9001676").isFgui = "NORMAL_ACTIVITY_9001676", true
_ENV = "NORMAL_ACTIVITY_9001680"
;("NORMAL_ACTIVITY_9001680").viewName = "Activity_9001680_Main"
;("NORMAL_ACTIVITY_9001680").checkIsOpen = true
;("NORMAL_ACTIVITY_9001680").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001680], ("NORMAL_ACTIVITY_9001680").isFgui = "NORMAL_ACTIVITY_9001680", true
_ENV = "NORMAL_ACTIVITY_9001691"
;("NORMAL_ACTIVITY_9001691").viewName = "Activity_9001691_Main"
;("NORMAL_ACTIVITY_9001691").checkIsOpen = true
;("NORMAL_ACTIVITY_9001691").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001691], ("NORMAL_ACTIVITY_9001691").isFgui = "NORMAL_ACTIVITY_9001691", true
_ENV = "ROARING_FLAME_WAR_ACTIVITY"
;("ROARING_FLAME_WAR_ACTIVITY").viewName = "RoaringFlame_Main"
;("ROARING_FLAME_WAR_ACTIVITY").checkIsOpen = false
;("ROARING_FLAME_WAR_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
clientEventMgr[gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY], ("ROARING_FLAME_WAR_ACTIVITY").isFgui = "ROARING_FLAME_WAR_ACTIVITY", true
_ENV = "NORMAL_ACTIVITY_9001692"
;("NORMAL_ACTIVITY_9001692").viewName = "Activity_9001692_Main"
;("NORMAL_ACTIVITY_9001692").checkIsOpen = true
;("NORMAL_ACTIVITY_9001692").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001692], ("NORMAL_ACTIVITY_9001692").isFgui = "NORMAL_ACTIVITY_9001692", true
_ENV = "NORMAL_ACTIVITY_9001700"
;("NORMAL_ACTIVITY_9001700").viewName = "Activity_9001700_Main"
;("NORMAL_ACTIVITY_9001700").checkIsOpen = true
;("NORMAL_ACTIVITY_9001700").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001700], ("NORMAL_ACTIVITY_9001700").isFgui = "NORMAL_ACTIVITY_9001700", true
_ENV = "NORMAL_ACTIVITY_9001704"
;("NORMAL_ACTIVITY_9001704").viewName = "Activity_9001704_Main"
;("NORMAL_ACTIVITY_9001704").checkIsOpen = true
;("NORMAL_ACTIVITY_9001704").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001704], ("NORMAL_ACTIVITY_9001704").isFgui = "NORMAL_ACTIVITY_9001704", true
_ENV = "NORMAL_ACTIVITY_9001704"
;("NORMAL_ACTIVITY_9001704").viewName = "Activity_9001702_Main"
;("NORMAL_ACTIVITY_9001704").checkIsOpen = true
;("NORMAL_ACTIVITY_9001704").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.NORMAL_ACTIVITY_9001702], ("NORMAL_ACTIVITY_9001704").isFgui = "NORMAL_ACTIVITY_9001704", true
_ENV = "KOH_MIGRATE_HELP_9001708"
;("KOH_MIGRATE_HELP_9001708").viewName = "Activity_9001708_Main"
;("KOH_MIGRATE_HELP_9001708").checkIsOpen = true
;("KOH_MIGRATE_HELP_9001708").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708], ("KOH_MIGRATE_HELP_9001708").isFgui = "KOH_MIGRATE_HELP_9001708", true
_ENV = "KOH_MIGRATE_HELP_9001709"
;("KOH_MIGRATE_HELP_9001709").viewName = "Activity_9001709_Main"
;("KOH_MIGRATE_HELP_9001709").checkIsOpen = true
;("KOH_MIGRATE_HELP_9001709").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.KOH_MIGRATE_HELP_9001709], ("KOH_MIGRATE_HELP_9001709").isFgui = "KOH_MIGRATE_HELP_9001709", true
_ENV = "ANNIVERSARY_SHOP_2025"
;("ANNIVERSARY_SHOP_2025").viewName = "Activity_9001713_Main"
;("ANNIVERSARY_SHOP_2025").checkIsOpen = true
;("ANNIVERSARY_SHOP_2025").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.ANNIVERSARY_SHOP_2025], ("ANNIVERSARY_SHOP_2025").isFgui = "ANNIVERSARY_SHOP_2025", true
_ENV = "ANNIVERSARY_SHOP_2025"
;("ANNIVERSARY_SHOP_2025").viewName = "Activity_9001717_Main"
;("ANNIVERSARY_SHOP_2025").checkIsOpen = true
;("ANNIVERSARY_SHOP_2025").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.FANTASY_LAND], ("ANNIVERSARY_SHOP_2025").isFgui = "ANNIVERSARY_SHOP_2025", true
_ENV = "ANNIVERSARY_2025_9001723"
;("ANNIVERSARY_2025_9001723").viewName = "Activity_9001723_Main"
;("ANNIVERSARY_2025_9001723").checkIsOpen = true
;("ANNIVERSARY_2025_9001723").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.ANNIVERSARY_2025_9001723], ("ANNIVERSARY_2025_9001723").isFgui = "ANNIVERSARY_2025_9001723", true
_ENV = "CRESCENT_TREASURE_ACTIVITY"
;("CRESCENT_TREASURE_ACTIVITY").viewName = "Activity_9001729_View"
;("CRESCENT_TREASURE_ACTIVITY").checkIsOpen = true
;("CRESCENT_TREASURE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY], ("CRESCENT_TREASURE_ACTIVITY").isFgui = "CRESCENT_TREASURE_ACTIVITY", true
_ENV = "FOOTBALL_TREASURE_ACTIVITY"
;("FOOTBALL_TREASURE_ACTIVITY").viewName = "Activity_9001733_View"
;("FOOTBALL_TREASURE_ACTIVITY").checkIsOpen = true
;("FOOTBALL_TREASURE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY], ("FOOTBALL_TREASURE_ACTIVITY").isFgui = "FOOTBALL_TREASURE_ACTIVITY", true
_ENV = "UNDERWATER_TREASURE_ACTIVITY"
;("UNDERWATER_TREASURE_ACTIVITY").viewName = "Activity_9001746_View"
;("UNDERWATER_TREASURE_ACTIVITY").checkIsOpen = true
;("UNDERWATER_TREASURE_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY], ("UNDERWATER_TREASURE_ACTIVITY").isFgui = "UNDERWATER_TREASURE_ACTIVITY", true
_ENV = "GREEN_GRASS_FLIP_ACTIVITY"
;("GREEN_GRASS_FLIP_ACTIVITY").viewName = "Activity_9001738_View"
;("GREEN_GRASS_FLIP_ACTIVITY").checkIsOpen = true
;("GREEN_GRASS_FLIP_ACTIVITY").checkCastleLv = CASTLE_LV6_LIMITED
clientEventMgr[gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY], ("GREEN_GRASS_FLIP_ACTIVITY").isFgui = "GREEN_GRASS_FLIP_ACTIVITY", true
local singleClickEventConfig = clientEventMgr
function clientEventMgr.getSingleClickEventConfig(eid)
	if eid then
		return singleClickEventConfig[eid]
	else
		return singleClickEventConfig
	end
end
function clientEventMgr.checkCastleLvByActivityID(eid)
	local config = clientEventMgr.getSingleClickEventConfig(eid)
	if config and config.checkCastleLv and SoraDGetCastleLv() < config.checkCastleLv then
		return false
	else
		return true
	end
end
function clientEventMgr.checkCastleStarLvByActivityID(eid)
	local config = clientEventMgr.getSingleClickEventConfig(eid)
	if config and config.checkCastleStarLv and SoraDGetBuildStarLv() < config.checkCastleStarLv then
		return false
	else
		return true
	end
end
function clientEventMgr.singleClickEvent(eid, entrance)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local classify = activityShowCtrl:getActivityClassifyByID(eid)
	_ENV = nil
	;(nil).position = entrance
	;(nil).eventid = eid
	;(nil).label = classify
	userSDKManager.logEvent(gSDKDef.TDonEvent.events_title, nil)
	local trigger = true
	local limit = false
	if commonCheck.MOVE_CITY_ACTIVIYT and SoraDGetCtrl("kingdomCtrl", gametop):getCanMoveOut(gametop.playertop_:getKingdomID()) and (eid == gActivityCenterUIEnum.PYRAMID_BATTLE or eid == gActivityCenterUIEnum.PYRAMID_BATTLE_PBL or eid == gActivityCenterUIEnum.STRONGEST_LORD or eid == gActivityCenterUIEnum.ROME_ACTIVITY or eid == gActivityCenterUIEnum.KINGDOM_BATTLE or eid == gActivityCenterUIEnum.SALESROOM_ACTIVITY or eid == gActivityCenterUIEnum.HERO_TRIAL) then
		SoraDShowMsgTip(i18n("migrate_notice_05"))
		SoraDGetCtrl("activityCenterUICtrl", gametop):sendClearNewMsg(eid)
		return trigger, limit
	end
	if eid == gActivityCenterUIEnum.STRONGEST_LORD then
		local gametop = gModuleMgr.getObject("gametop")
		local activityCtrl = gametop.playertop_:getModule("activityCtrl")
		if activityCtrl.activityState == gActivityState.CLOSE or activityCtrl.activityState == gActivityState.PREPARE then
			uiManager:show("Activity_9001061_Ready")
		elseif activityCtrl.activityState == gActivityState.OPEN then
			uiManager:show("Activity_9001061_Main")
		end
	elseif eid == gActivityTimeActivityID.TURNTABLE_ACTIVITY then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.TURNTABLE_ACTIVITY, true) then
			local gametop = gModuleMgr.getObject("gametop")
			local luckyTreasureCtrl = gametop.playertop_:getModule("luckyTreasureCtrl")
			if luckyTreasureCtrl:getTurnId() then
				SoraDCreatePanel("luckyTreasureView"):show()
			else
				SoraDShowMsgTip(i18n("common_text_608"))
			end
		end
	elseif eid == gActivityCenterUIEnum.CRAZY_DROP then
		if SoraDGetCtrl("activityShowCtrl"):isCrazyDropOpenOrPrepare(true) then
			SoraDCreatePanel("eventCrazyDropView"):show()
		else
			SoraDShowMsgTip(i18n("common_text_608"))
		end
	elseif eid == gActivityCenterUIEnum.SURPRISED_DROP then
		if SoraDGetCtrl("activityShowCtrl"):isSurprisedDropOpenOrPrepare() then
			uiManager:show("eventSurpriseHarvest")
		end
	elseif eid == gActivityCenterUIEnum.SNOW_DROP then
		if SoraDGetCtrl("activityShowCtrl"):isSnowDropOpenOrPrepare() then
			uiManager:show("eventSnowHarvest")
		end
	elseif eid == gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY, true) then
			local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
			local isUnlock = kingdomLevelDataModuleAPI:isUnlock()
			if not isUnlock then
				SoraDShowMsgTip(i18n("common_text_3968"))
			else
				uiManager:show("WorldKingdomLv")
			end
		end
	elseif eid == gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY then
		local eventState = SoraDGetCtrl("activityShowCtrl"):getStateByID(eid)
		if gActivityState.PREPARE == eventState or gActivityState.OPEN == eventState then
			local newTrialRead = include("newTrialRead")
			local lvLimit = newTrialRead.getCastleCondition(1) or 0
			if lvLimit <= SoraDGetCastleLv() then
				SoraDCreatePanel("newTrialMainView"):show()
			else
				_ENV = i18n("common_text_3968")
				i18n("common_text_3968").num = lvLimit
				SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_3968")))
			end
		end
	elseif eid == gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY, true) then
			if SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
				if SoraDGetCtrl("salesRoomAgCtrl"):checkOpenCond() then
					_ENV = SoraDShowMsgTip
					SoraDShowMsgTip.tag = 2
					uiManager:show("tradeBoardView", SoraDShowMsgTip)
				end
			else
				_ENV = SoraDShowMsgTip
				SoraDShowMsgTip.num = CASTLE_LV6_LIMITED
				SoraDShowMsgTip(i18n("common_text_1795", SoraDShowMsgTip))
			end
		end
	elseif eid == gActivityTimeActivityID.NORMAL_ACTIVITY_9001680 then
		if clientEventMgr.judgeIsOpen(eid, true) then
			local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
			local constantRead = include("constantRead")
			local needStepLv = constantRead.getConstValue("GLODMINER_OPEN_TARGET", 25)
			if needStepLv <= divineBeastCtrl:getHighestStepLv() then
				uiManager:show("Activity_9001680_Main")
			else
				_ENV = i18n("common_text_1795", SoraDShowMsgTip)
				i18n("common_text_1795", SoraDShowMsgTip).num = needStepLv
				SoraDShowMsgTip(i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip)))
			end
		end
	elseif eid == gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY then
		local gametop = gModuleMgr.getObject("gametop")
		local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
		local activityStatus = playerMobilizationCtrl:getActivityStatus()
		if activityStatus.status == gMobilizationActivityStatus.ACTIVITY_PREPAREING then
			local ret, status, time = playerMobilizationCtrl:getShowTime()
			_ENV = i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip))
			i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip)).time = SoraDConvertSecondToString(time)
			SoraDShowMsgTip(i18n("common_text_3556", i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip))))
		elseif activityStatus.status == gMobilizationActivityStatus.ACTIVITY_OPEN then
			do
				local umastatus = playerMobilizationCtrl:getUserMobiAliStatus()
				print("umastatus======", umastatus)
				if umastatus == gMobilizationAliStatus.STATUS_ALLIANCE_UNORGANIZED then
					_ENV = i18n("common_text_3556", i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip)))
					i18n("common_text_3556", i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip))).num = MOBILIZATION_MEMBER_NEED
					SoraDShowMsgTip(i18n("common_text_3558", i18n("common_text_3556", i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip)))))
				elseif umastatus == gMobilizationAliStatus.STATUS_NOT_ORIGIN_ALLIANCE or umastatus == gMobilizationAliStatus.STATUS_NOT_ORIGIN_ALLIANCE_AND_NO_ALI then
					local mailFunctions = include("mailFunctions")
					local personalMissionData = playerMobilizationCtrl:getPersonalMissionData()
					local allianceInfo = personalMissionData.allianceinfo
					local allianceName = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name)
					_ENV = i18n("common_text_3558", i18n("common_text_3556", i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip))))
					i18n("common_text_3558", i18n("common_text_3556", i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip)))).abbr = allianceName
					SoraDShowMsgTip(i18n("common_text_3559", i18n("common_text_3558", i18n("common_text_3556", i18n("minecraft_text_40", i18n("common_text_1795", SoraDShowMsgTip))))))
				elseif umastatus == gMobilizationAliStatus.STATUS_NOT_CASTLE_NOTENOUGH then
					_ENV = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name)
					mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name).level = MOBILIZATION_CASTLE_NEED
					SoraDShowMsgTip(i18n("common_text_3587", (mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name))))
				elseif umastatus == gMobilizationAliStatus.STATUS_NOT_JOIN_WHEN_START then
					SoraDShowMsgTip(i18n("common_text_3557"))
				else
					if umastatus == gMobilizationAliStatus.STATUS_NORMAL then
						if GLOBAL_GAME_ALLIANCE_MODE then
							uiManager:show("allianceMobView")
						else
							SoraDCreatePanel("allianceMobView"):show()
						end
					else
					end
				end
			end
		end
	elseif eid == gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY then
		local config = singleClickEventConfig[eid]
		if clientEventMgr.judgeIsOpen(eid, true) and clientEventMgr.checkActivityCastleLv(config) then
			local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
			local newStartIdx = IsArClient and 2 or 4
			if newStartIdx >= coffeeCraftsmanRead:getGroup() then
				uiManager:show("CoffeeCraftsmanActivity")
			else
				uiManager:show("DessertMasterActivity")
			end
		end
	elseif eid == gActivityTimeActivityID.SINBAD_TREASURE then
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local sinbadActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.SINBAD_TREASURE)
		if sinbadActivityStatus == gActivityState.PREPARE then
			SoraDCreatePanel("sinbadTreasurePrepareView"):show()
		elseif sinbadActivityStatus == gActivityState.OPEN then
			local activityData = activityShowCtrl:getActivityData(gActivityTimeActivityID.SINBAD_TREASURE)
			if activityData.doStage == 0 then
				SoraDCreatePanel("sinbadTreasureView"):show()
			elseif activityData.doStage == 1 then
				SoraDCreatePanel("sinbadTreasureStageTwoView"):show()
			elseif activityData.doStage == 2 then
				SoraDCreatePanel("sinbadTreasureStageThreeView"):show()
			end
		end
	elseif eid == gActivityTimeActivityID.NEBULA_PRIVILEGE then
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local sinbadActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEBULA_PRIVILEGE)
		if sinbadActivityStatus == gActivityState.PREPARE then
			uiManager:show("NebulaActivity")
		elseif sinbadActivityStatus == gActivityState.OPEN then
			local nebulaWarUtil = include("nebulaWarUtil")
			nebulaWarUtil.openOfficerView()
		end
	elseif eid == gActivityTimeActivityID.LEGEND_LORD then
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local legendLordActivityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.LEGEND_LORD)
		if legendLordActivityStatus == gActivityState.PREPARE then
			SoraDCreatePanel("legendaryKingActivity"):show()
		elseif legendLordActivityStatus == gActivityState.OPEN then
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
			local legendLordState = param.curState
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				SoraDCreatePanel("legendaryKingActivity"):show()
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				local legendaryKingViewNode = SoraDCreatePanel("legendaryKingView")
				legendaryKingViewNode:show()
				_ENV = i18n("common_text_3557")
				i18n("common_text_3557").viewType = 1
				legendaryKingViewNode:init(i18n("common_text_3557"))
			end
		end
	elseif eid == gActivityTimeActivityID.KING_STAR_BATTLE or eid == gActivityTimeActivityID.LEGEND_LORD_9001646 or eid == gActivityTimeActivityID.LEGEND_LORD_9001647 then
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local legendLordActivityStatus = activityShowCtrl:getStateByID(eid)
		if legendLordActivityStatus == gActivityState.PREPARE then
			_ENV = legendaryKingViewNode.init
			legendaryKingViewNode.init.activityID = eid
			uiManager:show("KingStarActivity", legendaryKingViewNode.init)
		elseif legendLordActivityStatus == gActivityState.OPEN then
			local param = activityShowCtrl:getParamByID(eid)
			local legendLordState = param.curState
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				_ENV = i18n("common_text_3557")
				i18n("common_text_3557").activityID = eid
				uiManager:show("KingStarActivity", i18n("common_text_3557"))
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				_ENV = i18n("common_text_3557")
				i18n("common_text_3557").viewType = 1
				i18n("common_text_3557").activityID = eid
				uiManager:show("KingStarBattle", i18n("common_text_3557"))
			end
		end
	elseif eid == gActivityCenterUIEnum.LEGEND_HEGEMON then
		print("----点击了传奇霸主--------------")
		local gametop = gModuleMgr.getObject("gametop")
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		local hegemonState, timeTbInfo = hegemonCtrl:getHegemonActivityStatus()
		if hegemonState == gActivityState.CLOSE then
			SoraDShowMsgTip(i18n("common_text_2486"))
		elseif hegemonState == gActivityState.PREPARE then
			SoraDCreatePanel("hegemonPrepare"):show()
		elseif hegemonState == gActivityState.OPEN then
			SoraDCreatePanel("hegemonActivity"):show()
		end
	elseif eid == gActivityCenterUIEnum.GREAT_CHALLENGE then
		local wonderfulState = gActivityState.CLOSE
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		for i, v in ipairs(clientEventMgr.greatChallengeId) do
			if activityShowCtrl:getStateByID(v) == gActivityState.OPEN then
				wonderfulState = gActivityState.OPEN
				break
			end
		end
		if wonderfulState == gActivityState.OPEN then
			SoraDCreatePanel("wonderfulChallengeView"):show()
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	elseif eid == gActivityTimeActivityID.UNCHARTED_ADVENTURE then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.UNCHARTED_ADVENTURE, true) then
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local timeCtrl = gametop.playertop_:getModule("timeCtrl")
			local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
			local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.UNCHARTED_ADVENTURE)
			local serverTime = timeCtrl:getServerTime()
			local lastDays = (param[1] - serverTime) / 86400
			if lastDays <= 0 then
				SoraDCreatePanel("unchartedStoreView"):show()
			elseif cityCtrl:getBuildMaxLv(BUILDID.CASTLE) >= CASTLE_LV6_LIMITED then
				SoraDCreatePanel("unchartedView"):show()
			else
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").num = CASTLE_LV6_LIMITED
				SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_2486")))
			end
		end
	elseif eid == gActivityTimeActivityID.NEW_CROSS_MISSION then
		if clientEventMgr.judgeIsOpen(eid, true) then
			if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
				_ENV = gametop.playertop_:getModule("activityShowCtrl")
				gametop.playertop_:getModule("activityShowCtrl").num = CASTLE_LV6_LIMITED
				SoraDShowMsgTip(i18n("common_text_1795", (gametop.playertop_:getModule("activityShowCtrl"))))
			else
				local panel = include("decryptionViewNew").new("decryptionViewNew", eid)
				panel:show()
			end
		end
	elseif eid == gActivityCenterUIEnum.PYRAMID_BATTLE then
		local pyramidClientModule = include("pyramidClientModule")
		pyramidClientModule.popSelectMenu()
	elseif eid == gActivityCenterUIEnum.PYRAMID_BATTLE_PBL then
		local pyramidClientModule = include("pyramidClientModule")
		pyramidClientModule.popPBLView()
	elseif math.floor(eid / 1000) * 1000 == 9000000 then
		local panel = SoraDCreatePanel("commonEventView")
		panel:initData(eid)
		panel:show()
	elseif eid == gActivityTimeActivityID.ORIENT_PRINCE_GIFT then
		if clientEventMgr.judgeIsOpen(eid, true) then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local param = activityShowCtrl:getParamByID(eid)
			if param.phase == 1 then
				SoraDCreatePanel("princeGiftView"):show()
			else
				SoraDCreatePanel("princeGiftTaskView"):show()
			end
		end
	elseif eid == gActivityTimeActivityID.KOH_MIGRATE then
		local gametop = gModuleMgr.getObject("gametop")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local status = activityShowCtrl:getStateByID(gActivityTimeActivityID.KOH_MIGRATE)
		if status == gActivityState.PREPARE then
			uiManager:show("kohMigratePreView")
		elseif clientEventMgr.judgeIsOpen(eid, true) then
			if worldMapDefine.inInCrossWar() then
				SoraDShowMsgTip(i18n("common_text_3302"))
			else
				local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
				local checkCastleLv = kohMigrateCtrl:getLvLimit()
				if not kohMigrateCtrl:isShowPrivilegeBtn() and checkCastleLv > SoraDGetCastleLv() then
					local buildLogic = include("buildLogic")
					_ENV = i18n("common_text_3302")
					i18n("common_text_3302").num = buildLogic.getBuildLvStr(checkCastleLv)
					SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_3302")))
				else
					uiManager:show("kohMigrateView")
				end
			end
		end
	elseif SoraDisInList(eid, exchangeMallActivityID) then
		if clientEventMgr.judgeIsOpen(eid, true) then
			_ENV = SoraDGetCtrl("kohMigrateCtrl")
			SoraDGetCtrl("kohMigrateCtrl").id = eid
			uiManager:show("ExchangeEventPage", (SoraDGetCtrl("kohMigrateCtrl")))
		end
	elseif actExchangeMallActivityID[eid] then
		if clientEventMgr.judgeIsOpen(eid, true) then
			_ENV = SoraDGetCtrl("kohMigrateCtrl")
			SoraDGetCtrl("kohMigrateCtrl").id = eid
			uiManager:show("ActExchangePageNew", (SoraDGetCtrl("kohMigrateCtrl")))
		end
	elseif eid == gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY then
		if clientEventMgr.judgeIsOpen(eid, true) then
			local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
			newStartMainCtrl:openView()
		end
	elseif activityShowCtrl:getActivityGroup(gActivityCenterUIEnum.NEWSERVERBACK_ACTIVITY)[eid] then
		if clientEventMgr.judgeIsOpen(eid, true) then
			local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
			newStartMainCtrl:jumpToActivity(eid)
		end
	elseif eid == gActivityTimeActivityID.FROSTY_MARKET then
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			_ENV = eid
			eid.num = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1795", eid))
			return
		end
		if clientEventMgr.judgeIsOpen(eid, true) then
			local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
			local skin = activity_9001678_Ctrl:getSkin()
			if skin == 1 then
				uiManager:show("Activity_9001678_Main")
			elseif skin == 2 then
				uiManager:show("Activity_9001714_Main")
			end
		end
	elseif eid == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local curState = activityShowCtrl:getParamCurState(eid)
		if curState == ACTIVITY_STATE.PREPARE or curState == ACTIVITY_STATE.ACTIVE then
			uiManager:show("NebulaEmperorMain")
		elseif curState == ACTIVITY_STATE.SETTLE then
			uiManager:show("NebulaEmperorOfficer")
		end
	elseif eid == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		if nebulaActivityCtrl:isNebulaActivityOpen() then
			local dailyRemindManager = include("dailyRemindManager")
			local ctype = dailyRemindManager.REMIND_TYPE.nebulaWarEnterAction
			if dailyRemindManager.checkNeedRemindOnce(ctype, eid) then
				local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
				local openCount = activityShowCtrl:getOpenCount(eid)
				dailyRemindManager.addRemindToManager(ctype, openCount)
				_ENV = i18n("common_text_1795", eid)
				i18n("common_text_1795", eid).handler = function()
					uiManager:show("NebulaWarActivity")
				end
				uiManager:show("NebulaWarEnterAction", i18n("common_text_1795", eid))
			else
				uiManager:show("NebulaWarActivity")
			end
		else
			SoraDShowMsgTip(i18n("common_text_608"))
		end
	elseif eid == gActivityTimeActivityID.NEBULA_KING_ACTIVITY then
		local nebulaKingCtrl = SoraDGetCtrl("nebulaKingCtrl")
		nebulaKingCtrl:markOpened()
		local config = singleClickEventConfig[eid]
		if config.checkCastleLv and SoraDGetCastleLv() < config.checkCastleLv then
			local buildLogic = include("buildLogic")
			local warLv = buildLogic.transformBuildLvToWarLv(config.checkCastleLv)
			if 0 < warLv then
				_ENV = i18n("common_text_608")
				i18n("common_text_608").lv = warLv
				local lv = i18n("common_text_1948", i18n("common_text_608"))
				_ENV = i18n("common_text_608")
				i18n("common_text_608").num = lv
				SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_608")), config.showTipIcon)
			else
				_ENV = config.showTipIcon
				config.showTipIcon.num = config.checkCastleLv
				SoraDShowMsgTip(i18n("common_text_1795", config.showTipIcon), config.showTipIcon)
			end
		else
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local state = activityShowCtrl:getStateByID(eid)
			if nebulaKingCtrl:isActivityOpen() or nebulaKingCtrl:isActivityCalc() then
				uiManager:show("NebulaKingMain")
			elseif nebulaKingCtrl:isActivityPrepare() then
				uiManager:show("NebulaKingPreview")
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		end
	elseif eid == gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY then
		local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
		nebulaCompetitionCtrl:markOpened()
		local config = singleClickEventConfig[eid]
		if config.checkCastleLv and SoraDGetCastleLv() < config.checkCastleLv then
			local buildLogic = include("buildLogic")
			local warLv = buildLogic.transformBuildLvToWarLv(config.checkCastleLv)
			if 0 < warLv then
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").lv = warLv
				local lv = i18n("common_text_1948", i18n("common_text_2486"))
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").num = lv
				SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_2486")), config.showTipIcon)
			else
				_ENV = config.showTipIcon
				config.showTipIcon.num = config.checkCastleLv
				SoraDShowMsgTip(i18n("common_text_1795", config.showTipIcon), config.showTipIcon)
			end
		else
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local state = activityShowCtrl:getStateByID(eid)
			if nebulaCompetitionCtrl:isActivityOpen() or nebulaCompetitionCtrl:isActivityCalc() then
				uiManager:show("NebulaCompetitionMain")
			elseif nebulaCompetitionCtrl:isActivityPrepare() then
				uiManager:show("NebulaCompetitionPreview")
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		end
	elseif eid == gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001577 then
		local activity_9001577_Ctrl = SoraDGetCtrl("activity_9001577_Ctrl")
		activity_9001577_Ctrl:markOpened()
		local config = singleClickEventConfig[eid]
		if config.checkCastleLv and SoraDGetCastleLv() < config.checkCastleLv then
			local buildLogic = include("buildLogic")
			local warLv = buildLogic.transformBuildLvToWarLv(config.checkCastleLv)
			if 0 < warLv then
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").lv = warLv
				local lv = i18n("common_text_1948", i18n("common_text_2486"))
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").num = lv
				SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_2486")), config.showTipIcon)
			else
				_ENV = config.showTipIcon
				config.showTipIcon.num = config.checkCastleLv
				SoraDShowMsgTip(i18n("common_text_1795", config.showTipIcon), config.showTipIcon)
			end
		else
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local state = activityShowCtrl:getStateByID(eid)
			if activity_9001577_Ctrl:isActivityOpen() then
				uiManager:show("Activity_9001577_Main")
			elseif activity_9001577_Ctrl:isActivityCalc() then
				uiManager:show("Activity_9001577_Rank")
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		end
	elseif eid == gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL then
		if clientEventMgr.judgeIsOpen(eid, true) then
			clientEventMgr.showActWithSpCastleLv(eid, 1, "STARLIT_NIGHT_ACCEPT_CASTLE_LV")
		end
	elseif eid == gActivityTimeActivityID.NEBULA_SIGN_ACTIVITY then
		if clientEventMgr.judgeIsOpen(eid, true) then
			clientEventMgr.showActWithSpCastleLv(eid, 1, "Nebula_sign_unlock_lv")
		end
	elseif eid == gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY then
		if clientEventMgr.judgeIsOpen(eid, true) then
			clientEventMgr.showActWithSpCastleLv(eid, 2)
		end
	elseif eid == gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY then
		_ENV = "NEBULA_CAMP_INTEGRAL_ACTIVITY"
		;("NEBULA_CAMP_INTEGRAL_ACTIVITY").checkCastleLv = CASTLE_LV110_LIMITED
		if clientEventMgr.checkActivityCastleLv("NEBULA_CAMP_INTEGRAL_ACTIVITY") then
			local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
			local curRound = activity_9001479_Ctrl:getCurRound()
			if activity_9001479_Ctrl:checkIsSpecial() and curRound <= 1 then
				uiManager:show("Activity_9001479_Preview")
			elseif curRound <= 0 then
				uiManager:show("Activity_9001479_Preview")
			else
				uiManager:show("Activity_9001479_Main")
			end
		end
	elseif eid == gActivityTimeActivityID.MAGIC_LAMP_SKILL_SHELTER_ACTIVITY then
		if clientEventMgr.judgeIsOpen(eid, true) then
			local gLv = include("constantRead").getConstValue("DIVINE_PROTECTION_LV_LIMIT", 0)
			if gLv > SoraDGetBuildStarLv() then
				_ENV = "Activity_9001479_Main"
				;("Activity_9001479_Main").var = gLv
				SoraDShowMsgTip(i18n("Soldiers_armor_text_1", "Activity_9001479_Main"))
			else
				uiManager:show("SanctuaryDivine")
			end
		end
	elseif SoraDGetCtrl("activity_9001566_Ctrl"):isItemRebateActivityID(eid) then
		if clientEventMgr.judgeIsOpen(eid, true) then
			_ENV = "SanctuaryDivine"
			;("SanctuaryDivine").activityID = eid
			uiManager:show("Activity_9001566_main", "SanctuaryDivine")
		end
	elseif eid == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001571 then
		if clientEventMgr.judgeIsOpen(eid, true) then
			if 0 < SoraDGetCtrl("activity_9001571_Ctrl"):getGroupID() then
				uiManager:show("Activity_9001571_Main")
			else
				uiManager:show("Activity_9001571_Choose")
			end
		end
	elseif eid == gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY then
		if clientEventMgr.judgeIsOpen(eid, true) then
			_ENV = eid
			eid.checkCastleLv = CASTLE_LV6_LIMITED
			if clientEventMgr.checkActivityCastleLv(eid) then
				local summerPrayRead = include("summerPrayRead")
				summerPrayRead.openActivityView()
			end
		end
	elseif eid == gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604 then
		local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
		local constantRead = include("constantRead")
		local castleLvLmit = constantRead.getConstValue("RAMADAN_MOBILIZE_CASTLE_LIMIT", 10)
		_ENV = 10
		;(10).checkCastleLv = castleLvLmit
		if not clientEventMgr.checkActivityCastleLv(10) then
			_ENV = i18n("Soldiers_armor_text_1", "Activity_9001479_Main")
			i18n("Soldiers_armor_text_1", "Activity_9001479_Main").lv = castleLvLmit
			SoraDShowMsgTip(i18n("Ramadan_League_text_04", i18n("Soldiers_armor_text_1", "Activity_9001479_Main")))
			return true
		end
		local status = activity_9001604_Ctrl:getActivityStage()
		if status == activity_9001604_Ctrl.STATUS.PREPARE or status == activity_9001604_Ctrl.STATUS.DATA_PREPARE then
			uiManager:show("Activity_9001604_Main")
			return true
		end
		local initAid = activity_9001604_Ctrl:getInitAid()
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local aid = allianceMgr:hasJoinAlliance(true)
		_UPVALUE2_ = true
		;(true)[1] = aid
		;(true)[2] = initAid
		dump(true, "aid,initAid")
		if aid ~= nil and aid ~= initAid and initAid ~= 0 or aid == nil and initAid ~= nil and initAid ~= -1 and initAid ~= 0 then
			SoraDShowMsgTip(i18n("Ramadan_League_text_03"))
		elseif aid == nil or initAid == -1 or initAid == nil then
			SoraDShowMsgTip(i18n("Ramadan_League_text_01"))
		elseif initAid == 0 then
			SoraDShowMsgTip(i18n("Ramadan_League_text_02"))
		else
			uiManager:show("Activity_9001604_Main")
		end
	elseif eid == gActivityTimeActivityID.NEBULA_SURPRISED_DROP then
		local storeActivityID = gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE
		if clientEventMgr.judgeIsOpen(storeActivityID, true) then
			_ENV = storeActivityID
			storeActivityID.checkCastleLv = CASTLE_LV6_LIMITED
			if clientEventMgr.checkActivityCastleLv(storeActivityID) then
				uiManager:show("Activity_9001627_Main")
			end
		end
	elseif eid == gActivityTimeActivityID.NORMAL_ACTIVITY_9001664 then
		local config = singleClickEventConfig[eid]
		if clientEventMgr.showPanelNormal(eid, config, true) then
			local activityCommonBubbleCtrl = SoraDGetCtrl("activityCommonBubbleCtrl")
			local skin = activityCommonBubbleCtrl:getSkin(eid)
			print("==skin==", skin)
			if skin == 2 then
				uiManager:show("Activity_9001693_Main")
			else
				uiManager:show("Activity_9001664_Main")
			end
		end
	elseif eid == gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716 then
		if clientEventMgr.judgeIsOpen(eid, true) then
			_ENV = uiManager.show
			uiManager.show.activityID = eid
			uiManager:show("Activity_9001716_Main", uiManager.show)
		end
	elseif eid == gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY then
		local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
		local room = simulatedDrillCtrl:getSelfRoom()
		if room then
			uiManager:show("SimulatedDrillRoom")
		else
			uiManager:show("SimulatedDrillRoomList")
		end
	else
		local config = singleClickEventConfig[eid]
		if config then
			if not clientEventMgr.showPanelNormal(eid, config) and config.limit then
				limit = config.limit
			end
		else
			trigger = false
		end
	end
	do
		local gametop = gModuleMgr.getObject("gametop")
		local activityCenterUICtrl = gametop.playertop_:getModule("activityCenterUICtrl")
		if eid == gActivityCenterUIEnum.LEGEND_HEGEMON then
			eid = gActivityTimeActivityID.LEGEND_HEGEMON_6
		end
		activityCenterUICtrl:sendClearNewMsg(eid)
	end
	return trigger, limit
end
function clientEventMgr.showActWithSpCastleLv(eid, type, constantName)
	local config = singleClickEventConfig[eid]
	local limitLv = 6
	if type == 1 then
		local constantRead = include("constantRead")
		limitLv = constantRead.getConstValue(constantName, CASTLE_LV110_LIMITED)
	elseif type == 2 then
		limitLv = IsArClient and config.checkCastleLv or config.checkCastleLv_en
	end
	if limitLv <= SoraDGetCastleLv() then
		uiManager:show(config.viewName, config.param)
	else
		local config = singleClickEventConfig[eid]
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(limitLv)
		if 0 < warLv then
			singleClickEventConfig = nil
			;(nil).lv = warLv
			local lv = i18n("common_text_1948", nil)
			singleClickEventConfig = nil
			;(nil).num = lv
			SoraDShowMsgTip(i18n("common_text_1795", nil), config.showTipIcon)
		else
			singleClickEventConfig = config.showTipIcon
			config.showTipIcon.num = limitLv
			SoraDShowMsgTip(i18n("common_text_1795", config.showTipIcon), config.showTipIcon)
		end
	end
end
clientEventMgr.timerMgr = class("clientEventMgrTimerMgr")
clientEventMgr.timerMgrInstance = nil
function clientEventMgr.timerMgr:getInstance()
	if clientEventMgr.timerMgrInstance == nil then
		clientEventMgr.timerMgrInstance = clientEventMgr.timerMgr.new()
	end
	return clientEventMgr.timerMgrInstance
end
function clientEventMgr.timerMgr:ctor()
	self.queue, _UPVALUE0_ = nil, nil
end
function clientEventMgr.timerMgr:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local queuetype = tostring(queuetype)
	local curqueue = self:queryQueue(queuetype)
	if curqueue then
		self:removeQueue(queuetype)
	end
	local dispatchQueueEvent = function()
		self.queue[queuetype] = nil
		if data and data.lastFun then
			data.lastFun()
		end
	end
	local _ENV, queue = self, self
	queue.qtype = queuetype
	queue.starttime = starttime
	queue.totaltime = totaltime
	local timerList = gModuleMgr.getObject("timerList")
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function clientEventMgr.timerMgr:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		local timerList = gModuleMgr.getObject("timerList")
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function clientEventMgr.timerMgr:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function clientEventMgr.getEventTimeString(timeObj, fun1, fun2, fun3)
	if timeObj and next(timeObj) then
		local timeType = timeObj.timeType
		if "showTime" == timeType then
			if timeObj.timerLast then
				local timefun = function(ticket)
					_ENV = nil
					;(nil).time = ticket
					return i18n(timeObj.timerLast, nil)
				end
				if fun1 then
					return fun1(timefun)
				end
			elseif timeObj.timerFun then
				if fun1 then
					return fun1(timeObj.timerFun)
				end
			elseif fun1 then
				return fun1()
			end
		elseif "showMsg" == timeType then
			if fun2 then
				return fun2(timeObj.timerMsg)
			end
		elseif "noMsg" == timeType and fun3 then
			return fun3()
		end
	end
end
function clientEventMgr.addEventTimer(eid, leftTime, otherData)
	clientEventMgr.timerMgr:getInstance():addQueue(tostring(eid), nil, nil, leftTime, otherData)
end
function clientEventMgr.getEventTimer(eid)
	return clientEventMgr.timerMgr:getInstance():queryQueue(tostring(eid))
end
function clientEventMgr.getEventNameById(eid)
	return clientEventMgr.eventNameList[eid] and clientEventMgr.eventNameList[eid].name or ""
end
_ENV, clientEventMgr.checkActivityCastleLv = clientEventMgr, function(config)
	if SoraDGetCastleLv() >= config.checkCastleLv then
		return true
	end
	local buildLogic = include("buildLogic")
	local warLv = buildLogic.transformBuildLvToWarLv(config.checkCastleLv)
	if 0 < warLv then
		_ENV = nil
		;(nil).lv = warLv
		local lv = i18n("common_text_1948", nil)
		_ENV = nil
		;(nil).num = lv
		SoraDShowMsgTip(i18n("common_text_1795", nil), config.showTipIcon)
	else
		_ENV = config.showTipIcon
		config.showTipIcon.num = config.checkCastleLv
		SoraDShowMsgTip(i18n("common_text_1795", config.showTipIcon), config.showTipIcon)
	end
	return false
end
clientEventMgr[gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY] = 0
clientEventMgr[gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY] = 54
local _ENV, clientEventMgr[gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY], activityID2starLvLimit = gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY, 1, clientEventMgr
local gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY[gActivityTimeActivityID.GLORIOUS_CONTEST], activityID2starLvLimit2 = 70, gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY
function clientEventMgr.checkStartLvLimit(activityID)
	local starLvLimit = activityID2starLvLimit[activityID]
	if starLvLimit and starLvLimit > SoraDGetBuildStarLv() then
		return
	end
	local starLvLimit2 = activityID2starLvLimit2[activityID]
	if starLvLimit2 and starLvLimit2 <= SoraDGetBuildStarLv() then
		return
	end
	return true
end
function clientEventMgr.checkBuildTypeLimit(activityID)
	local activityTimeRead = include("activityTimeRead")
	local buildType = activityTimeRead.getBuildType(activityID)
	if buildType and SoraDGetNowLvByBuffType(buildType[1]) < buildType[2] then
		return false
	end
	return true
end
local starLvLimitActivityIDList
function clientEventMgr.getStarLvLimitActivityIDList(...)
	if not starLvLimitActivityIDList then
		for activityID, __ in pairs(activityID2starLvLimit2) do
			table.insert(starLvLimitActivityIDList, activityID)
		end
	end
	return starLvLimitActivityIDList
end
function clientEventMgr.showPanelNormal(eid, config, onlyCheck)
	if not config.checkCastleLv and config.checkCastleLvKey then
		local constantRead = include("constantRead")
		config.checkCastleLv = constantRead.getConstValue(config.checkCastleLvKey, 1)
	end
	if config.checkIsOpen and not clientEventMgr.judgeIsOpen(eid, true) then
		return false
	end
	local activityTimeRead = include("activityTimeRead")
	local isCfg, showLevel, unlockLevel = activityTimeRead.getShowUnlockLv(eid)
	local checkCastleLv = config.checkCastleLv or showLevel
	if checkCastleLv and checkCastleLv > SoraDGetCastleLv() then
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(checkCastleLv)
		if 0 < warLv then
			_ENV = nil
			;(nil).lv = warLv
			local lv = i18n("common_text_1948", nil)
			_ENV = nil
			;(nil).num = lv
			SoraDShowMsgTip(i18n("common_text_1795", nil), config.showTipIcon)
		else
			_ENV = config.showTipIcon
			config.showTipIcon.num = checkCastleLv
			SoraDShowMsgTip(i18n("common_text_1795", config.showTipIcon), config.showTipIcon)
		end
		return false
	end
	if config.checkCastleStarLv and SoraDGetBuildStarLv() < config.checkCastleStarLv then
		_ENV = i18n("common_text_1795", config.showTipIcon)
		i18n("common_text_1795", config.showTipIcon).lv = config.checkCastleStarLv
		SoraDShowMsgTip(i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon))))
		return false
	end
	local activityTimeRead = include("activityTimeRead")
	local isCfg, showLevel, unlockLevel = activityTimeRead.getShowUnlockLv(eid)
	if isCfg and unlockLevel > SoraDGetCastleLv() then
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(unlockLevel)
		if 0 < warLv then
			_ENV = i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon)))
			i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon))).lv = warLv
			local lv = i18n("common_text_1948", i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon))))
			_ENV = i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon)))
			i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon))).num = lv
			SoraDShowMsgTip(i18n("common_text_1795", i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon)))))
		else
			_ENV = i18n("common_text_1795", i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon))))
			i18n("common_text_1795", i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon)))).num = unlockLevel
			SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_1795", i18n("build_thriving_5", (i18n("common_text_1795", config.showTipIcon))))))
		end
		return false
	end
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if config.checkHasJoinAlliance and not allianceMgr:hasJoinAlliance(true) then
		SoraDShowMsgTip(i18n("notice_0066"))
		return false
	end
	if config.checkInCrossWar and worldMapDefine.inInCrossWar() then
		if eid == gActivityTimeActivityID.COMMAND_HALL_ACTIVITY then
			SoraDShowMsgTip(i18n("commandhall_text_67"))
		else
			SoraDShowMsgTip(i18n("common_text_3302"))
		end
		return false
	end
	if not config.checkBuildLv then
		local _ENV, checkBuildLv = config.checkBuildLv, config.checkBuildLv
	end
	local checkJinnLv = checkBuildLv[BUILD_ENUM.MAGIC_LAMP]
	local checkHatchLv = checkBuildLv[BUILD_ENUM.MAGIC_LAMP_HATCH]
	if checkJinnLv and checkHatchLv then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
		local jinnLv = magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
		local hatchLv = magicLampHatchCtrl:getHatchLv(gJinnType.JINN_ONE)
		if checkJinnLv > jinnLv or checkHatchLv > hatchLv then
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").lv = checkJinnLv
			i18n("common_text_3302").lv2 = checkHatchLv
			SoraDShowMsgTip(i18n("HatchDecree_text_01", i18n("common_text_3302")))
			return false
		end
	end
	if not config.checkBuildLock then
		local _ENV, checkBuildLock = config.checkBuildLock, config.checkBuildLock
	end
	for __, buildType in ipairs(checkBuildLock) do
		if buildType == BUILD_ENUM.TWO_MAGIC_LAMP then
			local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
			if not magicLampCtrl:getIsJinnUnlock(gJinnType.JINN_TWO) then
				SoraDShowMsgTip(i18n("AnilaDecree_text_01"))
				return false
			end
		end
	end
	if onlyCheck then
		return true
	end
	if config.isFgui then
		uiManager:show(config.viewName, config.param)
		return
	end
	if config.viewName == "rechargeView" then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = config.param
			config.param.toCategory = config.param
			uiManager:show("rechargeView", config.param)
		else
			local panel = SoraDCreatePanel("rechargeView")
			if config.initFuncName then
				panel[config.initFuncName](panel, config.param)
			end
			panel:show()
		end
	else
		local panel
		if config.needFileName then
			panel = SoraDCreatePanelByFixName(config.viewName)
		else
			panel = SoraDCreatePanel(config.viewName)
		end
		if config.initFuncName then
			panel[config.initFuncName](panel, config.param)
		end
		panel:show()
	end
	return true
end
