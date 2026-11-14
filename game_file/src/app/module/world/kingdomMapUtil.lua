local _ENV, kingdomMapUtil
local gametop = gModuleMgr.getObject("gametop")
local gSplitId
if MClass and MClass.splitMapId then
	gSplitId = MClass.splitMapId
else
	local pattern = "[^-]+"
	local gmatch, insert, tonumber = string.gmatch, table.insert, tonumber
	local split_lite = function(value)
		local gmatch, splits
		for str in gmatch(value, pattern) do
			insert(splits, str)
		end
		return splits
	end
	function gSplitId(mapObjId)
		local arr = split_lite(mapObjId)
		if 5 <= #arr then
			return tonumber(arr[1]), tonumber(arr[2]), tonumber(arr[3]), tonumber(arr[4]), tonumber(arr[5])
		end
	end
end
kingdomMapUtil.gSplitId = gSplitId
function kingdomMapUtil.splitMapObjId(mapObj)
	if not mapObj.x or not mapObj.y then
		mapObj.x, mapObj.y, mapObj.type, mapObj.subMapType, mapObj.objId = gSplitId(mapObj.id)
		mapObj.x = mapObj.x - gPointClientPointPlus
		mapObj.y = mapObj.y - gPointClientPointPlus
		mapObj.class = mapObj.objId
	end
	if mapObj.type == gMapObjTypeDef.mapObjTypeBattlefieldSite or mapObj.type == gMapObjTypeDef.mapObjTypeFortress or mapObj.type == gMapObjTypeDef.mapObjNewTrialCity or mapObj.type == gMapObjTypeDef.mapObjTypeLegendLord or mapObj.type == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		mapObj.class = mapObj.subMapType
	end
	if mapObj.type == gMapObjTypeDef.mapObjTypeSuperResource and mapObj.id then
		local arr = serviceFunctions.split(mapObj.id, "_")
		if 3 <= #arr then
			mapObj.class = tonumber(arr[2])
		end
	end
end
function kingdomMapUtil.isInRang(x, y, rang)
	if x >= rang.startX and x <= rang.endX and y >= rang.startY and y <= rang.endY then
		return true
	else
		return false
	end
end
function kingdomMapUtil.checkMapRang(startX, startY, endX, endY)
	if type(startX) ~= "number" or type(startY) ~= "number" or type(endX) ~= "number" or type(endY) ~= "number" then
		return false
	end
	if startX < 0 or startX > gMapMaxCoordinate or startY < 0 or startY > gMapMaxCoordinate or endX < 0 or endX > gMapMaxCoordinate or endY < 0 or endY > gMapMaxCoordinate then
		return false
	end
	return true
end
function kingdomMapUtil.noticeClientQueueMsg(noticeId, battleResult)
	local name
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local baseInfo = lordInfoCtrl:getBaseInfo()
	if baseInfo then
		name = baseInfo.nickName
	end
	local msgNotice = include("msgNotice")
	local iconType = gNoticeIconTypeDef.ICON_ARMY
	gametop = nil
	;(nil).name = name
	;(nil).string = battleResult
	msgNotice.notice(noticeId, nil, iconType)
end
function kingdomMapUtil.noticeClientHeroBackQueueMsg(noticeId, queue)
	local heros = queue:getFromHero()
	local heroID = heros[1].heroID
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroName = i18n(heroltCtrl.getHeroInfo(heroID).herName)
	local msgNotice = include("msgNotice")
	local iconType = gNoticeIconTypeDef.ICON_ARMY
	_ENV = nil
	;(nil).hero = heroName
	msgNotice.notice(noticeId, nil, iconType)
end
function kingdomMapUtil.noticeQueueReturnMsg(queue)
	if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeReturn and queue:getStatus() >= gMapMoveLineStatusType.moveLineStatusTypeMoving then
		queue.isNoticeWorking = true
		if queue.isHeroReturn then
			kingdomMapUtil.noticeClientHeroBackQueueMsg("hero_text_100", queue)
		else
			if queue.orgQueueType == gMapMoveLineServerType.moveLineTypeEscortRob then
				local battleResult
				if queue.isAttackWin then
					battleResult = i18n("common_text_152")
				else
					battleResult = i18n("common_text_153")
				end
				kingdomMapUtil.noticeClientQueueMsg("remains_text_197", battleResult)
			elseif queue.orgQueueType == gMapMoveLineServerType.moveLineTypeAnnCampfire then
				kingdomMapUtil.noticeClientQueueMsg("anniversary_fire_text_40")
			elseif queue.orgQueueType == gMapMoveLineServerType.moveLineTypeRamadanFeast then
				if queue.finishFeast then
					kingdomMapUtil.noticeClientQueueMsg("activity_feast_toDinner_complete_desc")
				else
					kingdomMapUtil.noticeClientQueueMsg("notice_0129")
				end
			else
				kingdomMapUtil.noticeClientQueueMsg("notice_0129")
			end
			_ENV = "notice_0129"
			;("notice_0129").msg = "MESSAGE_UI_PANDECT_MARCH"
			SoraDSendMessage("notice_0129")
		end
	end
end
function kingdomMapUtil.noticeQueueArrivedMsg(queue)
	if queue:getMoveLineType() ~= gMapMoveLineType.moveLineTypeReturn and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking and not queue.isNoticeWorking then
		queue.isNoticeWorking = true
		if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeAnnCampfire then
			kingdomMapUtil.noticeClientQueueMsg("anniversary_fire_text_39")
		else
			kingdomMapUtil.noticeClientQueueMsg("notice_0128")
		end
		_ENV = "notice_0128"
		_ENV, ("notice_0128").msg = nil, "MESSAGE_ARMY_WORLDMAPCONTROL_CLOSEWINDOW"
		;("notice_0128").data, (nil).id = nil, queue:getId()
		SoraDSendMessage("notice_0128")
		local gametop = gModuleMgr.getObject("gametop")
		local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) and lordInfoCtrl:getSourceKid() <= 0 then
			local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl", gametop)
			local mapClassType = kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
			if mapClassType == gKingdomClassType.normal then
				christmasTreeCtrl:sendAllianceListMsg()
			end
		end
		_ENV = gKingdomClassType.normal
		gKingdomClassType.normal.msg = "MESSAGE_UI_PANDECT_MARCH"
		SoraDSendMessage(gKingdomClassType.normal)
		if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeCommandHallNpc and SoraDIsGameGuide() then
			print("==MESSAGE_SERVER_GUIDE_STEP_END=1=", SoraDIsGameGuide())
			_ENV = "==MESSAGE_SERVER_GUIDE_STEP_END=1="
			;("==MESSAGE_SERVER_GUIDE_STEP_END=1=").msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			;("==MESSAGE_SERVER_GUIDE_STEP_END=1=").step = SoraDIsGameGuide()
			;("==MESSAGE_SERVER_GUIDE_STEP_END=1=").reload = false
			SoraDSendMessage("==MESSAGE_SERVER_GUIDE_STEP_END=1=")
		end
	end
end
function kingdomMapUtil.getTargetAid(targetData, fromAid, selfAid)
	local mapType = targetData.mapType
	local mapObjUtil = include("mapObjUtil")
	if mapObjUtil.isNotChangeTargetAid(mapType) then
		if fromAid ~= selfAid and (mapType == gMapObjTypeDef.mapTypeRadianceWarBeacon or mapType == gMapObjTypeDef.mapTypeRadianceWarGate) then
			return selfAid
		end
		return 0
	end
	return targetData.aid
end
function kingdomMapUtil.getArmyCount(armyData)
	local num = 0
	if armyData then
		for _, army in pairs(armyData) do
			for _, v in pairs(army.armyList) do
				num = num + v.num
			end
		end
	end
	return num
end
return kingdomMapUtil
