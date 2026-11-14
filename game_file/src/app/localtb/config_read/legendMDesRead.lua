local legendMDesRead = include("aAReadClass").new()
function legendMDesRead.init()
	legendMDesRead:defineValue("PageType", function()
		_UPVALUE0_ = nil
		;(nil).COVER = 1
		;(nil).STORY = 2
		;(nil).STORYDETAIL = 3
		;(nil).KINGS = 4
		;(nil).KINGDETAIL = 5
		;(nil).KINGDOM_BATTLE = 6
		;(nil).SERVER_BATTLE = 7
		;(nil).SERVERROAD = 8
		;(nil).ALLIANCEROAD = 9
		;(nil).MILESTONE = 10
		return nil
	end)
	legendMDesRead:defineValue("coverIndex2PageType", function()
		legendMDesRead = nil
		;(nil)[1] = legendMDesRead.PageType.STORY
		;(nil)[2] = legendMDesRead.PageType.KINGS
		;(nil)[3] = legendMDesRead.PageType.KINGDOM_BATTLE
		;(nil)[4] = legendMDesRead.PageType.SERVER_BATTLE
		;(nil)[5] = legendMDesRead.PageType.SERVERROAD
		;(nil)[6] = legendMDesRead.PageType.ALLIANCEROAD
		;(nil)[7] = legendMDesRead.PageType.MILESTONE
		return nil
	end)
	legendMDesRead:defineValue("zOrder", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	function _ENV()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[1] = "history_alliance_info"
	legendMDesRead:defineValue("allianceRoadCfg", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	function _ENV()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[1] = "history_server_info"
	legendMDesRead:defineValue("serverRoadCfg", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	function _ENV()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[1] = "history_chapter_des"
	legendMDesRead:defineValue("chapterCfg", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	function _UPVALUE2_()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[1] = "history_chapter_reward"
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[2] = true
	legendMDesRead:defineValue("chapterServerCfg", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	function _ENV()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[1] = "history_main_setting"
	legendMDesRead:defineValue("coverCfg", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	function _UPVALUE2_()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[1] = "history_kingdom_milestone"
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[2] = true
	legendMDesRead:defineValue("mileStoneCfg", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	function _ENV()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)[1] = "history_milestone_config"
	legendMDesRead:defineValue("mileStoneClientCfg", function()
		_UPVALUE0_ = nil
		;(nil).zPagePrev = 2
		;(nil).zPageNext = 3
		;(nil).zPageMiddle = 4
		;(nil).zPageBack = 5
		;(nil).zTouchPanel = 30
		;(nil).zTopNode = 35
		return nil
	end)
	local createData = function(name)
		legendMDesRead.tbId2Index_serverRoad, legendMDesRead, legendMDesRead.typeServerRoadCfg, legendMDesRead = nil, nil, nil, nil
		local legendMDesRead, filterListA
		local index = 1
		for i, v in ipairs(legendMDesRead.serverRoadCfg) do
			legendMDesRead.tbId2Index_serverRoad[v.achievementID] = i
			local achievementType = v.achievementType
			if not filterListA[achievementType] then
				filterListA[achievementType], legendMDesRead = filterListA[achievementType], filterListA[achievementType]
				filterListA[achievementType] = index
				legendMDesRead.typeServerRoadCfg[index], legendMDesRead = nil, nil
				index = index + 1
			end
			local idx = filterListA[achievementType]
			table.insert(legendMDesRead.typeServerRoadCfg[idx], v)
		end
		if name == "typeServerRoadCfg" then
			return legendMDesRead.typeServerRoadCfg
		elseif name == "tbId2Index_serverRoad" then
			return legendMDesRead.tbId2Index_serverRoad
		end
	end
	legendMDesRead:defineValue("typeServerRoadCfg", createData)
	legendMDesRead:defineValue("tbId2Index_serverRoad", createData)
	local createData2 = function(name)
		legendMDesRead.tbId2Index_allianceRoad, legendMDesRead, legendMDesRead.typeAllianceRoadCfg, legendMDesRead = nil, nil, nil, nil
		local legendMDesRead, filterListA
		local index = 1
		for i, v in ipairs(legendMDesRead.allianceRoadCfg) do
			legendMDesRead.tbId2Index_allianceRoad[v.achievementID] = i
			local achievementType = v.achievementType
			if not filterListA[achievementType] then
				filterListA[achievementType], legendMDesRead = filterListA[achievementType], filterListA[achievementType]
				filterListA[achievementType] = index
				legendMDesRead.typeAllianceRoadCfg[index], legendMDesRead = nil, nil
				index = index + 1
			end
			local idx = filterListA[achievementType]
			table.insert(legendMDesRead.typeAllianceRoadCfg[idx], v)
		end
		if name == "typeAllianceRoadCfg" then
			return legendMDesRead.typeAllianceRoadCfg
		elseif name == "tbId2Index_allianceRoad" then
			return legendMDesRead.tbId2Index_allianceRoad
		end
	end
	legendMDesRead:defineValue("typeAllianceRoadCfg", createData2)
	legendMDesRead:defineValue("tbId2Index_allianceRoad", createData2)
end
function legendMDesRead.getCoverCfg()
	return legendMDesRead.coverCfg
end
function legendMDesRead.getServerRoadCfg()
	return legendMDesRead.serverRoadCfg
end
function legendMDesRead.getServerRoadBuffCfg()
	local _ENV, buffList
	if IsArClient then
		for k, v in ipairs(legendMDesRead.serverRoadCfg) do
			for _, buff in ipairs(v.buff) do
				if not SoraDisInList(buff, buffList) then
					_ENV = buffList
					buffList.buff = buff
					buffList.achieveID = v.achievementID
					table.insert(buffList, buffList)
				end
			end
		end
	end
	return buffList
end
function legendMDesRead.getTypeServerRoadCfg()
	return legendMDesRead.typeServerRoadCfg
end
function legendMDesRead.getChapterCfg()
	return legendMDesRead.chapterCfg
end
function legendMDesRead.getChapterServerCfgByIndex(index)
	return legendMDesRead.chapterServerCfg[index]
end
function legendMDesRead.getAllianceRoadCfg()
	return legendMDesRead.allianceRoadCfg
end
function legendMDesRead.getTypeAllianceRoadCfg()
	return legendMDesRead.typeAllianceRoadCfg
end
function legendMDesRead.getMileStoneCfg()
	return legendMDesRead.mileStoneCfg
end
function legendMDesRead.getMileStoneUnlockCfg(index)
	return legendMDesRead.mileStoneCfg[index].unlock
end
function legendMDesRead.getMileStoneInfo(id)
	return legendMDesRead.mileStoneClientCfg[id]
end
function legendMDesRead.getSingleCoverCfgByIndex(index)
	return legendMDesRead.coverCfg[index]
end
function legendMDesRead.getSingleChapterCfgByIndex(index)
	return legendMDesRead.chapterCfg[index]
end
function legendMDesRead.getSingleServerRoadCfgById(srid)
	local index = legendMDesRead.tbId2Index_serverRoad[srid]
	if index then
		return legendMDesRead.getSingleServerRoadCfgByIndex(index)
	end
end
function legendMDesRead.getSingleAllianceRoadCfgById(arid)
	local index = legendMDesRead.tbId2Index_allianceRoad[arid]
	if index then
		return legendMDesRead.getSingleAllianceRoadCfgByIndex(index)
	end
end
function legendMDesRead.getSingleServerRoadCfgByIndex(index)
	return legendMDesRead.serverRoadCfg[index]
end
function legendMDesRead.getSingleAllianceRoadCfgByIndex(index)
	return legendMDesRead.allianceRoadCfg[index]
end
function legendMDesRead.getCanUnlokChapter(chapterNum, unlockData)
	local chapterData = legendMDesRead.chapterServerCfg[chapterNum]
	local needCastleLv = chapterData.unlock[2]
	local preCondition = chapterNum - 1
	if 0 < preCondition and not unlockData[tostring(preCondition)] then
		return false, needCastleLv, preCondition
	end
	local curCastleLevel = SoraDGetCastleLv()
	if needCastleLv > curCastleLevel then
		return false, needCastleLv
	end
	return true
end
function legendMDesRead.getKingDes(serverData)
	local setType
	setType = serverData.setType
	local strTip
	if serverData.activeContent then
		strTip = serverData.activeContent
		return strTip
	end
	local mailFunctions = include("mailFunctions")
	local strName = mailFunctions:getWrappedName(serverData.userInfo.allianceAbbr, serverData.userInfo.nickName)
	local strAlliance = mailFunctions:getWrappedName(serverData.userInfo.allianceAbbr, serverData.userInfo.alliance)
	if setType == gKingBiographyType.king then
		local strServer = SoraDGetKingdomName(serverData.sourceKid)
		_ENV = nil
		;(nil).name = strName
		;(nil).server = strServer
		;(nil).allianceName = strAlliance
		;(nil).allianceName1 = strAlliance
		strTip = i18n("history_text_01", nil)
	elseif setType == gKingBiographyType.legend then
		strTip = i18n("history_text_03")
	elseif setType == gKingBiographyType.starking then
		strTip = i18n("kingstarbattle_text_72")
	elseif setType >= gKingBiographyType.hegemon1 and setType <= gKingBiographyType.hegemon6 then
		strTip = i18n("history_text_02")
	end
	return strTip
end
function legendMDesRead.getKeyByIndex(index)
	_ENV = nil
	;(nil)[1] = gFunBuildKey.KINGDOM_STORY
	;(nil)[2] = gFunBuildKey.SULTAN_BIOGRAPHY
	;(nil)[3] = gFunBuildKey.CIVILWAR_SUMMARY
	;(nil)[4] = gFunBuildKey.KINGWAR_SUMMARY
	;(nil)[5] = gFunBuildKey.KINGDOM_ROAD
	;(nil)[6] = gFunBuildKey.GREAT_ALLIANCE
	local (nil)[7], _keyCfg = gFunBuildKey.MONUMENT, nil
	return _keyCfg[index]
end
legendMDesRead.init()
return legendMDesRead
