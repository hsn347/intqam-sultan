local _ENV, commandHallUtil
function commandHallUtil.getShowFightingPos(...)
	return cc.p(5572, 1665)
end
function commandHallUtil.jumpToShowFighting(...)
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	if not commandHallCtrl:getIsShowFighting() then
		return
	end
	local mainCityView = SoraDCurrentSceneShowView("mainCityView")
	if mainCityView then
		local pos = commandHallUtil.getShowFightingPos()
		local realOffset = mainCityView:getContainerOffsetWhenPosPoint(pos, cc.p(display.width / 2, display.height / 2), false, true)
		mainCityView.viewScrollView:setContentOffsetInDuration(realOffset, 0)
		_ENV = mainCityView.viewScrollView
		mainCityView.viewScrollView.msg = "MESSAGE_MAINCITYVIEW_SHOW_COMMANDHALL_NPC"
		SoraDSendMessage(mainCityView.viewScrollView)
	else
		_ENV = mainCityView:getContainerOffsetWhenPosPoint(pos, cc.p(display.width / 2, display.height / 2), false, true)
		mainCityView:getContainerOffsetWhenPosPoint(pos, cc.p(display.width / 2, display.height / 2), false, true).msg = "MESSAGE_MAINSCEN_ONSHOW"
		mainCityView:getContainerOffsetWhenPosPoint(pos, cc.p(display.width / 2, display.height / 2), false, true).viewType = VIEW_TYPE_CITY
		SoraDSendMessage((mainCityView:getContainerOffsetWhenPosPoint(pos, cc.p(display.width / 2, display.height / 2), false, true)))
	end
end
local tileSize = cc.size(50, 50)
function commandHallUtil.tilePos2MapPos(tilePos)
	local tileX = tilePos.x + 0.5
	local tileY = tilePos.y + 0.5
	return cc.p(tileX * tileSize.width, tileY * tileSize.height)
end
function commandHallUtil.mapPos2TilePos(mapPos)
	return cc.p(math.floor(mapPos.x / tileSize.width), math.floor(mapPos.y / tileSize.height))
end
function commandHallUtil.getTilePosKey(tilePos)
	return tilePos.x .. "," .. tilePos.y
end
function commandHallUtil.getCommandHallNpcQueueData()
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	local task = commandHallCtrl:getArmyGroupTaskData()
	if not task or not next(task) then
		return
	end
	if task.statue == gCommandHallTaskStatue.FINISH then
		return
	end
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local selfPoint = cityCtrl:getCurCityPos()
	selfPoint.x = tonumber(selfPoint.x)
	selfPoint.y = tonumber(selfPoint.y)
	local gametop = gModuleMgr.getObject("gametop")
	local myKindomID = gametop.playertop_:getKingdomID()
	local startTime = task.createTime
	local moveEndTime = task.moveEndTime
	local totalTime = moveEndTime - startTime
	_ENV = nil
	;(nil).status = gMapMoveLineStatusType.moveLineStatusTypeMoving
	_ENV, (nil).id = gMapMoveLineStatusType.moveLineStatusTypeMoving, "11"
	gMapMoveLineStatusType.moveLineStatusTypeMoving.x = 600
	gMapMoveLineStatusType.moveLineStatusTypeMoving.y = 600
	_ENV, (nil).from, gMapMoveLineStatusType.moveLineStatusTypeMoving.army = gMapMoveLineStatusType.moveLineStatusTypeMoving, gMapMoveLineStatusType.moveLineStatusTypeMoving, commandHallUtil.getTroopsMatrixArmyData2()
	gMapMoveLineStatusType.moveLineStatusTypeMoving.x = selfPoint.x
	gMapMoveLineStatusType.moveLineStatusTypeMoving.y = selfPoint.y
	;(nil).to, gMapMoveLineStatusType.moveLineStatusTypeMoving.type = gMapMoveLineStatusType.moveLineStatusTypeMoving, gMapObjTypeDef.mapObjTypePlayer
	;(nil).kingdomId = myKindomID
	_ENV, commandHallUtil, (nil).statusStartTime = gMapObjTypeDef.mapObjTypePlayer, gMapMoveLineStatusType.moveLineStatusTypeMoving, startTime
	gMapObjTypeDef.mapObjTypePlayer.distancePrecent = 1
	gMapObjTypeDef.mapObjTypePlayer.time = totalTime
	;(nil).moveTimeSpan, gMapMoveLineStatusType.moveLineStatusTypeMoving[1] = gMapMoveLineStatusType.moveLineStatusTypeMoving, gMapObjTypeDef.mapObjTypePlayer
	;(nil).matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCommandHall
	;(nil).client_queue = true
	;(nil).moveLineColor = gMapMoveLineColor.moveLineColorRed
	local (nil).commandHallTaskType, queueData = gCommandHallTaskType.REBEL_ARMY_GROUP_TASK, nil
	if moveEndTime <= serviceFunctions.systemTime() then
		queueData.status = gMapMoveLineStatusType.moveLineStatusTypeWorking
	end
	return queueData
end
function commandHallUtil.getTroopsMatrixArmyData()
	_UPVALUE0_, _UPVALUE4_, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil
	;(nil).id = 401
	_UPVALUE0_, (nil).num = nil, 1000
	;(nil).id = 501
	_UPVALUE0_, (nil).num = nil, 1000
	;(nil).id = 601
	_UPVALUE0_, (nil).num = nil, 1000
	;(nil).id = 710
	;(nil).num = 1000
	_UPVALUE0_, _UPVALUE1_, (nil).armyList, (nil)[1] = nil, nil, nil, nil
	_UPVALUE0_, _UPVALUE1_, (nil).armyList, (nil)[2] = nil, nil, nil, nil
	_UPVALUE0_, _UPVALUE1_, (nil).armyList, (nil)[3] = nil, nil, nil, nil
	_UPVALUE0_, _UPVALUE1_, (nil).armyList, (nil)[4] = nil, nil, nil, nil
	;(nil).heroID = 1705
	;(nil)[1], (nil).heroInfo, (nil)[1] = nil, nil, nil
	local armyData
	return armyData
end
function commandHallUtil.getTroopsMatrixArmyData2()
	_UPVALUE0_, _UPVALUE4_, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil
	;(nil).id = 401
	_UPVALUE0_, (nil).num = nil, 10000
	;(nil).id = 501
	_UPVALUE0_, (nil).num = nil, 10000
	;(nil).id = 601
	_UPVALUE0_, (nil).num = nil, 10000
	;(nil).id = 710
	;(nil).num = 10000
	;(nil)[1], (nil).armyList, (nil)[1] = nil, nil, nil
	;(nil)[1], (nil).armyList, (nil)[2] = nil, nil, nil
	;(nil)[1], (nil).armyList, (nil)[3] = nil, nil, nil
	;(nil)[1], (nil).armyList, (nil)[4] = nil, nil, nil
	local armyData
	return armyData
end
function commandHallUtil.checkTaskTypeNeedArmy(taskType)
	_ENV = nil
	;(nil)[gCommandHallTaskType.RESCUE_TASK] = true
	;(nil)[gCommandHallTaskType.SNIPE_HUNTER_TASK] = true
	local (nil)[gCommandHallTaskType.DIALOGUE_TASK], config = true, nil
	return not config[taskType]
end
function commandHallUtil.checkTaskTypeShowNpc(taskType)
	_ENV = nil
	;(nil)[gCommandHallTaskType.REBEL_ARMY_PIONEER_TASK] = true
	local (nil)[gCommandHallTaskType.BATTLE_TASK], config = true, nil
	return config[taskType]
end
function commandHallUtil.createTaskNode(...)
	local taskNode = display.newNode()
	local bgSprite = display.newSprite("#img_commandhall_sign_01.png")
	bgSprite:addTo(taskNode)
	local iconSprite = display.newSprite("#bg_transparent.png")
	iconSprite:addTo(taskNode)
	iconSprite:setPosition(cc.p(0, 5))
	function taskNode.setTaskID(target, taskID)
		local commandHallRead = include("commandHallRead")
		local quality = commandHallRead.getTaskQuality(taskID)
		local bgImage = commandHallRead.getQualityBgImage(quality)
		bgSprite:setSpriteFrame(bgImage)
		local taskType = commandHallRead.getTaskType(taskID)
		local taskIcon = commandHallRead.getTaskIcon(taskType)
		iconSprite:setSpriteFrame(taskIcon)
	end
	return taskNode
end
function commandHallUtil.checkFinishGuide(...)
	local guideStep = SoraDIsGameGuide()
	if guideStep then
		print("==commandHallUtil.checkFinishGuide==", guideStep)
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		if 910100 <= guideStep and guideStep <= 910150 then
			guideCtrl:CompleteGuideStep(nil, gGuideStep.COMMAND_HALL_STEP_1)
			_ENV = guideCtrl
			guideCtrl.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(guideCtrl)
		end
		if 920100 <= guideStep and guideStep <= 920150 then
			guideCtrl:CompleteGuideStep(nil, gGuideStep.COMMAND_HALL_STEP_2)
			_ENV = guideCtrl
			guideCtrl.msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(guideCtrl)
		end
	end
end
function commandHallUtil.getConfigShowWarning(...)
	_ENV = nil
	;(nil).byUID = true
	local showWarning = SoraDConfigGet("Game:CommandHallWarnSetting:showWarning~bool", nil)
	if showWarning == false then
		return false
	else
		return true
	end
end
function commandHallUtil.setConfigShowWarning(showWarning)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:CommandHallWarnSetting:showWarning~bool", showWarning, nil)
end
function commandHallUtil.getShowWarning(...)
	if not commandHallUtil.getConfigShowWarning() then
		return false
	end
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	local task = commandHallCtrl:getArmyGroupTaskData()
	if task and task.statue and task.statue ~= gCommandHallTaskStatue.FINISH and commandHallUtil.checkShowFlashRed(task.armyGroupID) then
		return true
	end
	return false
end
function commandHallUtil.checkShowWarning(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
	;(nil).isVisible = commandHallUtil.getShowWarning()
	;(nil).sType = 0
	;(nil).sortIdx = gWarningSortIdx.commandHall_task
	SoraDSendMessage(nil)
end
function commandHallUtil.checkShowFlashRed(armyGroupID)
	local constantRead = include("constantRead")
	local COMMANDHALL_FLASH_RED = constantRead.getConstValue("COMMANDHALL_FLASH_RED", 0)
	if armyGroupID < COMMANDHALL_FLASH_RED then
		return false
	else
		return true
	end
end
function commandHallUtil.checkShowCountDown(armyGroupID)
	local constantRead = include("constantRead")
	local COMMANDHALL_COUNT_DOWN = constantRead.getConstValue("COMMANDHALL_COUNT_DOWN", 0)
	if armyGroupID < COMMANDHALL_COUNT_DOWN then
		return false
	else
		return true
	end
end
function commandHallUtil.checkShowHeroGuide(armyGroupID)
	local constantRead = include("constantRead")
	local COMMANDHALL_HERO_GUIDE = constantRead.getConstValue("COMMANDHALL_HERO_GUIDE", 0)
	return armyGroupID == COMMANDHALL_HERO_GUIDE
end
function commandHallUtil.getConfigShowAttack(...)
	_ENV = nil
	;(nil).byUID = true
	local showAttack = SoraDConfigGet("Game:CommandHallWarnSetting:showAttack~bool", nil)
	if showAttack == false then
		return false
	else
		return true
	end
end
function commandHallUtil.setConfigShowAttack(showAttack)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:CommandHallWarnSetting:showAttack~bool", showAttack, nil)
end
function commandHallUtil.checkRecommend(taskID, armyData)
	local commandHallRead = include("commandHallRead")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local armyltCtrl = include("armyltCtrl")
	if not armyData.heroInfo then
		local _ENV, heroInfo = armyData.heroInfo, armyData.heroInfo
	end
	if not armyData.armyList then
		local _ENV, armyList = armyData.armyList, armyData.armyList
	end
	local heroPower = 0
	for i, v in ipairs(heroInfo) do
		heroPower = heroPower + heroCtrl:getHeroPower(v.heroID)
	end
	local recommendHero = commandHallRead.getRecommendHero(taskID)
	local armyPower = armyltCtrl.getArmyBasePower(armyList)
	local recommendArmy = commandHallRead.getRecommendArmy(taskID)
	local isEnough = heroPower >= recommendHero and armyPower >= recommendArmy
	_ENV = heroCtrl:getHeroPower(v.heroID)
	heroCtrl:getHeroPower(v.heroID).heroPower = heroPower
	heroCtrl:getHeroPower(v.heroID).recommendHero = recommendHero
	heroCtrl:getHeroPower(v.heroID).armyPower = armyPower
	heroCtrl:getHeroPower(v.heroID).recommendArmy = recommendArmy
	return isEnough, (heroCtrl:getHeroPower(v.heroID))
end
function commandHallUtil.getMonsterLevel(armyGroupID)
	local commandHallRead = include("commandHallRead")
	local monsterLv = 0
	if armyGroupID and 0 < armyGroupID then
		local taskID = commandHallRead.getTaskIDByOrder(armyGroupID)
		if commandHallRead.checkTaskIsCirculate(taskID) then
			monsterLv = armyGroupID - 1
		else
			monsterLv = armyGroupID
		end
	end
	return monsterLv
end
function commandHallUtil.getArmyGroupIDStr(armyGroupID)
	local commandHallRead = include("commandHallRead")
	local ret = ""
	if armyGroupID and 0 < armyGroupID then
		local taskID = commandHallRead.getTaskIDByOrder(armyGroupID)
		if commandHallRead.checkTaskIsCirculate(taskID) then
			ret = tostring(armyGroupID - 1) .. "+"
		else
			ret = tostring(armyGroupID)
		end
	end
	return ret
end
function commandHallUtil.checkOpenLv(...)
	local constantRead = include("constantRead")
	local COMMANDHALL_OPEN_LV = constantRead.getConstValue("COMMANDHALL_OPEN_LV", 1)
	if COMMANDHALL_OPEN_LV <= SoraDGetCastleLv() then
		return true
	else
		return false
	end
end
function commandHallUtil.checkTaskPanelShowBtnGo(...)
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	if not SoraDIsGameGuide() then
		local task = commandHallCtrl:getArmyPioneerTaskData()
		if task and next(task) then
			return true, gCommandHallTaskType.REBEL_ARMY_PIONEER_TASK
		end
	end
	local task = commandHallCtrl:getTaskByType(gCommandHallTaskType.SNIPE_HUNTER_TASK)
	if task and next(task) then
		return true, gCommandHallTaskType.SNIPE_HUNTER_TASK
	end
	return false
end
function commandHallUtil.getRebelArmyMarchTime(...)
	local constantRead = include("constantRead")
	local COMMANDHALL_REBEL_ARMY_MARCH_TIME = constantRead.getConstValue("COMMANDHALL_REBEL_ARMY_MARCH_TIME", 5)
	return math.floor(COMMANDHALL_REBEL_ARMY_MARCH_TIME)
end
function commandHallUtil.getCommonTaskMarchTime(...)
	local constantRead = include("constantRead")
	return constantRead.getConstValue("COMMANDHALL_COMMON_TASK_MARCH_TIME", 2)
end
function commandHallUtil.getRandomNotFinishTask(...)
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	local taskList = commandHallCtrl:getTaskList()
	local _ENV, temp = commandHallCtrl, commandHallCtrl
	for __, task in ipairs(taskList) do
		if task.type ~= gCommandHallTaskType.REBEL_ARMY_GROUP_TASK and task.statue ~= gCommandHallTaskStatue.FINISH then
			table.insert(temp, task.index)
		end
	end
	if 0 < #temp then
		local taskIndex = temp[math.random(1, #temp)]
		return taskIndex
	end
end
return commandHallUtil
