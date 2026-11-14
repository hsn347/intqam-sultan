local gameGuideData = require("app." .. LocalTblPath .. ".config_client.gameGuideDescribe")
_ENV = "app." .. LocalTblPath .. ".config_client.gameGuideDescribe"
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").hidGirl = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").showGirlIntoAction = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").resetOpacityNow = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").showNoticeBgAction = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").needIphoneX = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isSwallow = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isAutoNext = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isStopGuide = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isMaskEnable = true
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isCleanPanel = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").waitMsgEndStep = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").keepRect = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").needMove = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").needTarget = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isFinger = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isBorder = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isOnlyShow = false
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isSDKLog = true
_ENV, ("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").isEndStepSDKLog = LocalTblPath, false
LocalTblPath.run = true
LocalTblPath.round = true
LocalTblPath.x = 0
;("app." .. LocalTblPath .. ".config_client.gameGuideDescribe").fingerData, LocalTblPath.y = LocalTblPath, 0
local tableDefault = "app." .. LocalTblPath .. ".config_client.gameGuideDescribe"
function SoradGameGuide_GetStepDelayTime(stepIndex)
	if gameGuideData[stepIndex] == nil then
		return 0
	end
	local stepData = gameGuideData[stepIndex]
	return stepData.delayTime
end
function SoradGameGuide_IsStopGuideAfterStep(stepIndex)
	if gameGuideData[stepIndex] == nil or gameGuideData[stepIndex].parameters.isStopGuide == nil then
		return false
	end
	local stepData = gameGuideData[stepIndex]
	return stepData.parameters.isStopGuide
end
function SoradGameGuide_IsStopGuideNeedUpdate(stepIndex)
	if gameGuideData[stepIndex] == nil or gameGuideData[stepIndex].parameters.isStopGuideNeedUpdate == nil then
		return true
	end
	local stepData = gameGuideData[stepIndex]
	return stepData.parameters.isStopGuideNeedUpdate
end
function SoradGameGuide_GetStepGetDataByKey(stepIndex, key)
	if gameGuideData[stepIndex] == nil then
		return nil
	end
	local stepData = gameGuideData[stepIndex]
	if stepData[key] ~= nil then
		return stepData[key]
	elseif stepData.parameters[key] ~= nil then
		return stepData.parameters[key]
	else
		return tableDefault[key]
	end
end
function SoradGameGuide_isOnlyGirl(stepIndex)
	if gameGuideData[stepIndex] == nil or gameGuideData[stepIndex].parameters.girl == nil or gameGuideData[stepIndex].parameters.girl.only == nil then
		return false
	end
	local stepData = gameGuideData[stepIndex]
	local onlyGirl = stepData.parameters.girl.only
	return onlyGirl
end
function SoradGameGuide_isOnlyShowAction(stepIndex)
	if gameGuideData[stepIndex] == nil or SoradGameGuide_GetStepGetDataByKey(stepIndex, "action") == nil or SoradGameGuide_GetStepGetDataByKey(stepIndex, "action").only == nil then
		return false
	end
	local stepData = gameGuideData[stepIndex]
	return stepData.parameters.action.only
end
function SoradGameGuide_isAutoNextStep(stepIndex)
	if gameGuideData[stepIndex] == nil then
		return false
	end
	return SoradGameGuide_GetStepGetDataByKey(stepIndex, "isAutoNext")
end
function SoradGameGuide_getNextStep(stepIndex)
	if gameGuideData[stepIndex] == nil then
		return false
	end
	return SoradGameGuide_GetStepGetDataByKey(stepIndex, "nextStep")
end
function SoradGameGuide_getFingerData(stepIndex, key)
	local fingerData = SoradGameGuide_GetStepGetDataByKey(stepIndex, "fingerData")
	if fingerData == nil or fingerData[key] == nil then
		_ENV = fingerData[key]
		fingerData[key].run = true
		fingerData[key].round = true
		fingerData[key].x = 0
		fingerData[key].y = 0
		fingerData[key].beginX = 0
		fingerData, fingerData[key].beginY = fingerData[key], 0
	end
	return fingerData[key]
end
function SoradGameGuide_getGrayStyle(stepIndex, key)
	local gray = SoradGameGuide_GetStepGetDataByKey(stepIndex, "gray")
	if gray == nil or gray[key] == nil then
		_ENV = gray[key]
		gray[key].delay = false
		gray[key].action = false
		gray[key].normal = false
		gray, gray[key].girl = gray[key], true
	end
	return gray[key]
end
function SoradGameGuide_tipsDataCheck(data)
	_ENV = nil
	;(nil).arr = "left"
	;(nil).size = cc.size(220, 70)
	;(nil).notice = ""
	local (nil).offset, tips = cc.p(0, 0), nil
	for k, v in pairs(tips) do
		if data[k] == nil then
			data[k] = v
		end
	end
	return data
end
function SoradGameGuide_GetStepDataInfo(stepIndex, otherItemName)
	if gameGuideData[stepIndex] == nil then
		return nil, nil
	end
	local targetView, targetClass
	local stepData = gameGuideData[stepIndex]
	if not stepData then
		return nil, nil
	end
	if stepData.className == "worldMapView" then
		targetView = SoraDCurrentSceneShowView(stepData.className)
	elseif stepData.className == "mainCityView" then
		targetView = SoraDCurrentSceneShowView(stepData.className)
	elseif stepData.className == "mainUI" then
		targetView = SoraDCurrentMainUI()
	elseif stepData.className == "gameGuideView" then
		targetView = display.getRunningScene():getChildByName(stepData.className)
	else
		targetView = SoraDSearchPanelFromManagerByName(stepData.className)
		if targetView == nil then
			dump(stepData.className, "SoradGameGuide_GetStepDataInfo  stepData")
			if stepData.parameters.classEndStep then
				gameGuideData = stepData.className
				stepData.className.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
				stepData.className.step = stepData.parameters.classEndStep
				SoraDSendMessage(stepData.className)
			end
		end
	end
	if targetView and stepData.itemName then
		if otherItemName then
			targetClass = targetView:gameGuide_getTarget(otherItemName, stepData.parameters)
		else
			targetClass = targetView:gameGuide_getTarget(stepData.itemName, stepData.parameters)
		end
	end
	return targetView, targetClass
end
function SoradGameGuide_GetNoticeKey(key, str)
	local ret = str
	if ret == "lordName" then
		ret = gModuleMgr.getObject("gametop").playertop_:getModule("lordInfoCtrl"):getLordInfo().base.nickName
	elseif ret == "unlockPet" then
		local gametop = gModuleMgr.getObject("gametop")
		local petCtrl = gametop.playertop_:getModule("petCtrl")
		local hasCanUnlock, retList = petCtrl:getHasCanUnlockPet()
		return include("petDesRead").getName(retList[1])
	elseif ret == "unlockHero" then
		local gametop = gModuleMgr.getObject("gametop")
		local heroCtrl = gametop.playertop_:getModule("heroCtrl")
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local noHaveHeros = heroCtrl:getNoHaveHerosListByRule()
		for k, v in pairs(noHaveHeros) do
			local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(v)
			if needNum <= itemNum then
				return i18n(heroltCtrl.getHeroInfo(v).herName)
			end
		end
	elseif ret == "canUpHero" then
		local gametop = gModuleMgr.getObject("gametop")
		local heroCtrl = gametop.playertop_:getModule("heroCtrl")
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local _2, heroName = heroltCtrl:getUpgradeGuideInfo()
		return i18n(heroName)
	elseif ret == "nebulaWarRound" then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		return nebulaActivityCtrl:getCurRound()
	else
		ret = i18n(tostring(str))
	end
	return ret
end
