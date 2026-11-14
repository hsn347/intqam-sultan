local watchTowerFilter = class("watchTowerFilter")
function watchTowerFilter:ctor()
	self.watchTowerAuthData = nil
end
function watchTowerFilter:filter(queueData)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local watchTowerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
	local authData = self:getWatchTowerAuth(watchTowerLv)
	return self:filterArmy(queueData, authData, allianceMgr:getOwnTeamID())
end
function watchTowerFilter:filterArmy(queueData, authData, aid)
	if authData[gWatchTowerAuthType.target] then
	end
	if authData[gWatchTowerAuthType.targetPos] and (queueData.isMainQueue or queueData.alliance == aid) or queueData.moveLineType == gMapMoveLineType.moveLineTypeRomanSoul then
	else
		queueData.from.x = nil
		queueData.from.y = nil
	end
	if authData[gWatchTowerAuthType.reciveTime] and (queueData.isMainQueue or queueData.alliance == aid) then
	else
		queueData.statusEndTime = nil
		queueData.moveTimeSpan = nil
	end
	if authData[gWatchTowerAuthType.totalArmy] then
	else
		queueData.from.totalCount = nil
	end
	if authData[gWatchTowerAuthType.heroAll] then
	elseif authData[gWatchTowerAuthType.heroType] then
		queueData.from.heroInfo = self:getHeroType(queueData.from.heroInfo)
	elseif authData[gWatchTowerAuthType.heroNum] then
		queueData.from.heroInfo = self:getHeroCount(queueData.from.heroInfo)
	else
		queueData.from.heroInfo = nil
	end
	if authData[gWatchTowerAuthType.godArms_march] then
	else
		queueData.from.armsInfo = nil
	end
	if authData[gWatchTowerAuthType.divineBeast] then
	else
		queueData.from.divineBeastInfo = nil
	end
	if authData[gWatchTowerAuthType.allLordLevel] or queueData.moveLineType == gMapMoveLineType.moveLineTypeRomanSoul then
	elseif queueData.from then
		queueData.from.level = nil
	end
	if authData[gWatchTowerAuthType.detailArmy] then
	elseif authData[gWatchTowerAuthType.armyType] then
		queueData.from.army = self:getArmyId(queueData.from.army)
	else
		queueData.from.army = nil
	end
	if authData[gWatchTowerAuthType.tech] and queueData.isMainQueue then
	else
		queueData.from.technology = nil
	end
	if authData[gWatchTowerAuthType.skill] and queueData.isMainQueue then
	else
		queueData.from.ability = nil
	end
	return queueData
end
function watchTowerFilter:getArmyId(army)
	if army then
		for _, v in pairs(army) do
			v.num = -1
		end
	end
	return army
end
function watchTowerFilter:getHeroCount(heroInfo)
	local _ENV, ret
	if type(heroInfo) == "table" then
		for i, v in ipairs(heroInfo) do
			_ENV = nil
			;(nil).exp = v.exp
			table.insert(ret, nil)
		end
	end
	return ret
end
function watchTowerFilter:getHeroType(heroInfo)
	local _ENV, ret
	if type(heroInfo) == "table" then
		for i, v in ipairs(heroInfo) do
			_ENV = nil
			;(nil).exp = v.exp
			;(nil).heroID = v.heroID
			table.insert(ret, nil)
		end
	end
	return ret
end
function watchTowerFilter:getWatchTowerAuth(lv)
	if not self.watchTowerAuthData then
		self:genWatchTowerAuthData()
	end
	return self.watchTowerAuthData[lv]
end
function watchTowerFilter:genWatchTowerAuthData()
	local cityltCtrl = include("cityltCtrl")
	local watchTowerMaxLv = cityltCtrl.buildAttr(BUILDID.WATCH_TOWER, BUILD_ATTR.MAXLV)
	self.watchTowerAuthData, _ENV = BUILDID.WATCH_TOWER, BUILDID.WATCH_TOWER
	for lvIndex = 1, watchTowerMaxLv do
		self.watchTowerAuthData[lvIndex], _ENV = nil, nil
		for i = #gWatchTowerSetting, 1, -1 do
			local lv, auth = gWatchTowerSetting[i].lv, gWatchTowerSetting[i].auth
			if lvIndex >= lv then
				self.watchTowerAuthData[lvIndex][auth] = auth
			end
		end
	end
end
return watchTowerFilter
