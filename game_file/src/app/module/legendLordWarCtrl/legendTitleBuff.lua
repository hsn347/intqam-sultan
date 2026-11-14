local legendKingRead = include("legendKingRead")
local legendTitleBuff = include("aAReadClass").new()
function legendTitleBuff:initialize()
	legendTitleBuff:defineValue("buff", function()
		legendTitleBuff.buff, legendTitleBuff = nil, nil
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		local allBuffList = legendKingRead.getAllBuffList()
		for title, buffs in pairs(allBuffList) do
			local legendTitleBuff, buffList
			for _, buffID in ipairs(buffs) do
				local buffType = buffltCtrl:getEffectType(buffID)
				local buffValue = buffltCtrl:getEffect(buffID)
				if buffType then
					buffList[buffType] = buffValue
				end
			end
			legendTitleBuff.buff[title] = buffList
		end
		return legendTitleBuff.buff
	end)
	legendTitleBuff:defineValue("buff_KS", function()
		legendTitleBuff.buff_KS, legendTitleBuff = nil, nil
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		for mapid, activityID in pairs(worldMapDefine.LLW_MAPID_ACTID) do
			if worldMapDefine.isKingStarMapId(mapid) then
				local allBuffList = legendKingRead.getAllBuffList(mapid)
				local legendTitleBuff, _ret = mapid, mapid
				for title, buffs in pairs(allBuffList) do
					local legendTitleBuff, buffList
					for _, buffID in ipairs(buffs) do
						local buffType = buffltCtrl:getEffectType(buffID)
						local buffValue = buffltCtrl:getEffect(buffID)
						if buffType then
							buffList[buffType] = buffValue
						end
					end
					_ret[title] = buffList
				end
				legendTitleBuff.buff_KS[activityID] = _ret
			end
		end
		return legendTitleBuff.buff_KS
	end)
end
function legendTitleBuff:getTitleBuff(title, buffType, mapid)
	if not title or not buffType then
		return
	end
	if worldMapDefine.isKingStarMapId(mapid) then
		if not legendTitleBuff.buff_KS then
			return
		end
		local activityID = worldMapDefine.getKingStarActivityID(mapid)
		if not legendTitleBuff.buff_KS[activityID] then
			local _ENV, config = legendTitleBuff.buff_KS[activityID], legendTitleBuff.buff_KS[activityID]
		end
		return config[title] and config[title][buffType]
	else
		if not legendTitleBuff.buff then
			return
		end
		return legendTitleBuff.buff[title] and legendTitleBuff.buff[title][buffType]
	end
end
function legendTitleBuff:notifyBuffChange(title, mapid)
	if not title then
		return
	end
	local _ENV, config
	if worldMapDefine.isKingStarMapId(mapid) then
		if not legendTitleBuff.buff_KS then
			return
		end
		local activityID = worldMapDefine.getKingStarActivityID(mapid)
		config, _ENV = legendTitleBuff.buff_KS[activityID], legendTitleBuff.buff_KS[activityID]
		config = legendTitleBuff.buff_KS[activityID] or nil
	else
		if not legendTitleBuff.buff then
			return
		end
		config = legendTitleBuff.buff
	end
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	if not config[title] then
		local _ENV, buffList = config[title], config[title]
	end
	for buffType, _ in pairs(buffList) do
		buffCtrl:dispatchBuffEvent(buffType, gBuffSource.LEGEND_TITLE)
	end
end
legendTitleBuff:initialize()
return legendTitleBuff
