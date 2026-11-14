local technologyAuxiliary = class("technologyAuxiliary")
local technologyLocalData = include("technologyLocalData")
local gametop = gModuleMgr.getObject("gametop")
function technologyAuxiliary:ctor()
	self.technologyLocalData = forceInclude("technologyLocalData")
end
function technologyAuxiliary:resetData()
	self.technologyLocalData = forceInclude("technologyLocalData")
end
function technologyAuxiliary:isProcessTech(tid)
	for technologyID, v in pairs(self.technologyLocalData.technologyTypeData.process) do
		if tonumber(technologyID) == tid then
			return true
		end
	end
	return false
end
function technologyAuxiliary:isManorTech(tid)
	for technologyID, v in pairs(self.technologyLocalData.technologyTypeData.manor) do
		if tonumber(technologyID) == tid then
			return true
		end
	end
	return false
end
function technologyAuxiliary:getNextUnlockTechId(starLv)
	print("getNextUnlockTechIdstarLv", starLv)
	local cityltCtrl = include("cityltCtrl")
	local info = cityltCtrl.getQualityByStarLv(starLv)
	if info.quality and self.technologyLocalData.processData[info.quality] then
		for _, technologyID in ipairs(self.technologyLocalData.processData[info.quality].technologyID) do
			local nextTechnologyIdStr = self:mosaicTechnologyId(technologyID, 1)
			local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
			dump(nextTechnology, "getNextUnlockTechId")
			if starLv == nextTechnology.starbuild[2] then
				return technologyID
			end
		end
	end
end
function technologyAuxiliary:getTechnologyDetailById(technologyId)
	return self.technologyLocalData.technologyData[technologyId]
end
function technologyAuxiliary:handlerTechnology(technologyData)
	local initResource = "21001"
	local initResource1 = "21002"
	local initCityDevelop = "22001"
	local initAnchor = "23001"
	local initMilitary = "24011"
	local initSpecial = "24101"
	local initSoldier = "24201"
	local initLeader = "24301"
	local initHero1 = "25001"
	local initHero2 = "25002"
	local initWarTech1_1 = "110001"
	local initWarTech1_2 = "110002"
	local initWarTech1_3 = "110003"
	local initWarTech1_4 = "110004"
	local initWarTech2 = "120001"
	local initWarTech3_1 = "130001"
	local initWarTech3_2 = "130002"
	local initWarTech4_1 = "140001"
	local initWarTech4_2 = "140002"
	local initWarTech5 = "150001"
	local initAdvancedMilitary = "160001"
	local initManorTech1 = "500000"
	local rs = self.technologyLocalData.technologyTypeData
	if technologyData and next(technologyData) ~= nil then
		for key, var in pairs(technologyData) do
			local tName = technologyLocalData.getTypeNameByID(key)
			if tName and rs[tName][key] then
				rs[tName][key].currentLevel = math.ceil(tonumber(var[2]))
				rs[tName][key].isOpened = true
			end
		end
		for key in pairs(technologyData) do
			local idType = self:getTechnologyType(key, rs)
			local post = self:getRelationPostSkill(key)
			if post and next(post) then
				for _, postV in ipairs(post) do
					print("idType,postV", idType, postV)
					if not rs[idType][postV].isOpened then
						local isFlag = self:isMeet(rs, postV)
						if isFlag then
							rs[idType][postV].isOpened = true
						end
					end
				end
			end
		end
		rs.resource[initResource].isOpened = true
		rs.resource[initResource1].isOpened = true
		rs.cityDevelop[initCityDevelop].isOpened = true
		rs.anchor[initAnchor].isOpened = true
		rs.military[initMilitary].isOpened = true
		rs.special[initSpecial].isOpened = true
		rs.soldier[initSoldier].isOpened = true
		rs.leader[initLeader].isOpened = true
		rs.wartechnology[initWarTech1_1].isOpened = true
		rs.wartechnology[initWarTech1_2].isOpened = true
		rs.wartechnology[initWarTech1_3].isOpened = true
		rs.wartechnology[initWarTech1_4].isOpened = true
		rs.warbattle[initWarTech2].isOpened = true
		rs.warcommand[initWarTech4_1].isOpened = true
		rs.warcommand[initWarTech4_2].isOpened = true
		if IsArClient then
			rs.warmilitary[initWarTech3_1].isOpened = true
			rs.warmilitary[initWarTech3_2].isOpened = true
			rs.warlight[initWarTech5].isOpened = true
			rs.advancedmilitary[initAdvancedMilitary].isOpened = true
		end
		rs.hero[initHero1].isOpened = true
		rs.hero[initHero2].isOpened = true
		rs.manor[initManorTech1].isOpened = true
	else
		rs.resource[initResource].isOpened = true
		rs.resource[initResource1].isOpened = true
		rs.cityDevelop[initCityDevelop].isOpened = true
		rs.anchor[initAnchor].isOpened = true
		rs.military[initMilitary].isOpened = true
		rs.special[initSpecial].isOpened = true
		rs.soldier[initSoldier].isOpened = true
		rs.leader[initLeader].isOpened = true
		rs.wartechnology[initWarTech1_1].isOpened = true
		rs.wartechnology[initWarTech1_2].isOpened = true
		rs.wartechnology[initWarTech1_3].isOpened = true
		rs.wartechnology[initWarTech1_4].isOpened = true
		rs.warbattle[initWarTech2].isOpened = true
		rs.warcommand[initWarTech4_1].isOpened = true
		rs.warcommand[initWarTech4_2].isOpened = true
		if IsArClient then
			rs.warmilitary[initWarTech3_1].isOpened = true
			rs.warmilitary[initWarTech3_2].isOpened = true
			rs.warlight[initWarTech5].isOpened = true
			rs.advancedmilitary[initAdvancedMilitary].isOpened = true
		end
		rs.hero[initHero1].isOpened = true
		rs.hero[initHero2].isOpened = true
		rs.manor[initManorTech1].isOpened = true
	end
	for k, v in pairs(rs.nebula) do
		v.isOpened = true
	end
	return rs
end
function technologyAuxiliary:getRelationPostSkill(technologyId)
	local relationTechnology = self.technologyLocalData.technologyRelationData
	if not relationTechnology[technologyId] then
		_UPVALUE0_ = relationTechnology[technologyId]
	end
	return relationTechnology[technologyId]
end
function technologyAuxiliary:getRelationFontSkill(technologyId)
	local _ENV, front
	local relationTechnology = self.technologyLocalData.technologyCascadeData
	for k, var in pairs(relationTechnology) do
		if k == technologyId and type(var) == "table" then
			for _, var in ipairs(var) do
				table.insert(front, var)
			end
		end
	end
	return front
end
function technologyAuxiliary:isMeet(rs, postV)
	local isFlag = true
	local tid = self:mosaicTechnologyId(postV, 1)
	local data = self:getTechnologyDetailById(tid)
	if data and next(data) ~= nil then
		local build = data.technologyBuild
		_UPVALUE2_ = nil
		;(nil)[1] = "technologyPreposeID"
		;(nil)[2] = "technologyPreposeLevel"
		local prepose = serviceFunctions.tableFormat(data.technologyPrepose, nil)
		for k, v in ipairs(prepose) do
			if v.technologyPreposeID > 0 and v.technologyPreposeLevel > 0 then
				local id = self:getTechIdPrefix(v.technologyPreposeID, 0, 5)
				local idType = self:getTechnologyType(id, rs)
				if rs[idType][id].currentLevel < v.technologyPreposeLevel then
					isFlag = false
					break
				end
			end
		end
	end
	return isFlag
end
function technologyAuxiliary:getTechnologyDetails(technologyId, level, technologyData, originData)
	local _ENV, rs
	local tempData = self:getTechnologyById(technologyId)
	local maxLevel = -1
	if tempData and next(tempData) ~= nil then
		maxLevel = tempData.maxLevel or -1
	end
	local standard = -1
	local status = -1
	if level == 0 then
		standard = tonumber(level) + 1
		status = 1
	elseif level >= maxLevel then
		standard = maxLevel
		status = 2
	elseif level < maxLevel then
		standard = level
		status = 3
	end
	local technologyIdStr = self:mosaicTechnologyId(technologyId, standard)
	local technologyIdDetails = self.technologyLocalData.technologyData[technologyIdStr]
	if technologyIdDetails then
		_ENV = technologyId
		if technologyIdDetails ~= technologyId then
			rs.currentLevel = level
			rs.technologyMaxLevel = maxLevel
			rs.technologyID = technologyId
			rs.currentLevelEffect = self:handlerTechnologyPower(status, standard, technologyIdDetails, technologyId, 1)
			rs.nextLevelEffect = self:handlerTechnologyPower(status, standard, technologyIdDetails, technologyId, 2)
			local _
			_, rs.technologyTime = self:getUpgradeTime(status, standard, technologyIdDetails, technologyId)
			rs.upgradeIngTechnology = self:getUpgradeIngTechnology(technologyId)
			rs.resources = self:getUpgradeResources(status, standard, technologyIdDetails, technologyId, originData)
			rs.build = self:getTechnologyBuild(status, standard, technologyIdDetails, technologyId)
			rs.starbuild = self:getTechnologyStarBuild(status, standard, technologyIdDetails, technologyId)
			rs.tech = self:getTechTable(status, standard, technologyIdDetails, technologyId, technologyData)
			rs.wartool = self:getUpgradeTools(status, standard, technologyIdDetails, technologyId)
			rs.curPower, rs.nextPower = self:getFightingData(status, standard, technologyIdDetails, technologyId)
			local total = self:getTechnologyCost(rs.resources, rs.wartool)
			local basetime = rs.technologyTime
			local finaltime = self:getResearchTime(basetime, self:getQueueTypeByTechnologyId(technologyId), originData)
			total = self:immediatelyUpgrade(total, finaltime)
			rs.cost = total
		end
	end
	return rs
end
function technologyAuxiliary:immediatelyUpgrade(total, technologyTime)
	total = total + serviceFunctions.timeConvertToGold(technologyTime, false)
	return total
end
function technologyAuxiliary:getUpgradeIngTechnology(technologyId)
	technologyId = tonumber(technologyId)
	local queueType = self:getQueueTypeByTechnologyId(technologyId)
	local _ENV, rs = self, self
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queueData = queueCtrl:queryQueue(queueType)
	if queueData then
		local data = clone(queueData.data)
		for key, var in pairs(data) do
			if tonumber(key) == technologyId then
				rs = data[key]
				table.insert(rs, true)
			end
		end
	end
	return rs
end
function technologyAuxiliary:getTechTable(status, standard, technologyIdDetails, technologyId, technologyData)
	local _UPVALUE0_, techs
	if status == 1 then
		techs = self:handlerTechTable(techs, technologyIdDetails, technologyData)
	elseif status == 2 then
		techs, _UPVALUE0_ = self:handlerTechTable(techs, technologyIdDetails, technologyData), self:handlerTechTable(techs, technologyIdDetails, technologyData)
	elseif status == 3 then
		local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, standard + 1)
		local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
		if nextTechnology then
			techs = self:handlerTechTable(techs, nextTechnology, technologyData)
		end
	end
	return techs
end
function technologyAuxiliary:handlerTechTable(techs, technologyIdDetails, technologyData)
	_UPVALUE2_ = nil
	;(nil)[1] = "technologyPreposeID"
	;(nil)[2] = "technologyPreposeLevel"
	local technologyPrepose = serviceFunctions.tableFormat(technologyIdDetails.technologyPrepose, nil)
	for k, v in ipairs(technologyPrepose) do
		if v.technologyPreposeID > 0 and v.technologyPreposeLevel > 0 then
			local technologyId = self:getTechIdPrefix(tostring(v.technologyPreposeID), 0, 5)
			local currentLevel = tonumber(self:getTechnologyAttribute(technologyId, technologyData).currentLevel)
			local isContentmented = currentLevel >= v.technologyPreposeLevel
			_ENV = technologyData
			technologyData.tid = technologyId
			technologyData.currentLevel = currentLevel
			technologyData.consumeLevel = v.technologyPreposeLevel
			technologyData.isContentmented = isContentmented
			table.insert(techs, technologyData)
		end
	end
	return techs
end
function technologyAuxiliary:getUpgradeResources(status, standard, technologyIdDetails, technologyId, originData)
	local _UPVALUE0_, resources
	if status == 1 then
		local technologyResource = technologyIdDetails.technologyResource
		resources = self:mosaicResource(resources, technologyResource, technologyId, originData)
	elseif status == 2 then
		resources, _UPVALUE0_ = technologyIdDetails.technologyResource, technologyIdDetails.technologyResource
	elseif status == 3 then
		local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, standard + 1)
		local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
		if nextTechnology then
			local technologyResource = nextTechnology.technologyResource
			resources = self:mosaicResource(resources, technologyResource, technologyId, originData)
		end
	end
	return resources
end
function technologyAuxiliary:getUpgradeTools(status, standard, technologyIdDetails, technologyId)
	local _UPVALUE0_, tools
	if status == 1 then
		local technologyWEs = technologyIdDetails.technologyWEs
		tools = self:mosaicTools(tools, technologyWEs)
	elseif status == 2 then
		tools, _UPVALUE0_ = technologyIdDetails.technologyWEs, technologyIdDetails.technologyWEs
	elseif status == 3 then
		local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, standard + 1)
		local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
		if nextTechnology then
			local technologyWEs = nextTechnology.technologyWEs
			tools = self:mosaicTools(tools, technologyWEs)
		end
	end
	return tools
end
function technologyAuxiliary:getFightingData(status, standard, technologyIdDetails, technologyId)
	local fighting1 = 0
	local fighting2 = 0
	if status == 1 then
		fighting1 = 0
		fighting2 = technologyIdDetails.fighting
	elseif status == 2 then
		fighting1 = technologyIdDetails.fighting
		fighting2 = fighting1
	elseif status == 3 then
		fighting1 = technologyIdDetails.fighting
		local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, standard + 1)
		local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
		if nextTechnology then
			fighting2 = nextTechnology.fighting
		end
	end
	return fighting1, fighting2
end
function technologyAuxiliary:mosaicResource(resources, technologyResource, technologyId, originData)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	if technologyResource then
		gametop = gametop.playertop_
		if technologyResource ~= gametop.playertop_ then
			local reduceBuildMastery = 0
			local technologyIdStr = self:mosaicTechnologyId(technologyId, 1)
			local technologyDetails = self.technologyLocalData.technologyData[technologyIdStr]
			local technologyType = technologyDetails and technologyDetails.technologyType
			local gametop, technologyType2BuffID = 1, 1
			technologyType2BuffID[gTechnologyConfigType.ANCHOR] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_1
			technologyType2BuffID[gTechnologyConfigType.MILITARY] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_1
			technologyType2BuffID[gTechnologyConfigType.SOLDIER] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_1
			technologyType2BuffID[gTechnologyConfigType.SPECIAL] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_2
			technologyType2BuffID[gTechnologyConfigType.LEADER] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_2
			technologyType2BuffID[gTechnologyConfigType.HERO] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_2
			technologyType2BuffID[gTechnologyConfigType.RESOURCE] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_3
			technologyType2BuffID[gTechnologyConfigType.CITYDEVELOP] = gBuffEffect.RESEARCH_RESOURCE_REDUCE_3
			local buffType
			if technologyType then
				buffType = technologyType2BuffID[technologyType]
				if buffType then
					local buffCtrl = gametop.playertop_:getModule("buffCtrl")
					reduceBuildMastery = buffCtrl:getBuffEffect(buffType) or 0
					reduceBuildMastery = reduceBuildMastery / 1000
				end
			end
			for index, var in ipairs(technologyResource) do
				if index % 2 ~= 0 then
					local species = technologyResource[index]
					local consumeResource = technologyResource[index + 1] or 0
					local consumeResourceOri = consumeResource
					local isContentmented = false
					local isLuckyContentmented = false
					local currentResource = 0
					if species == gIDDef.FOOD then
						currentResource = cityCtrl:getResCount(gIDDef.FOOD)
					elseif species == gIDDef.IRON then
						currentResource = cityCtrl:getResCount(gIDDef.IRON)
					elseif species == gIDDef.WOOD then
						currentResource = cityCtrl:getResCount(gIDDef.WOOD)
					elseif species == gIDDef.MITHRIL then
						currentResource = cityCtrl:getResCount(gIDDef.MITHRIL)
					elseif species == gIDDef.STEEL then
						currentResource = cityCtrl:getResCount(gIDDef.STEEL)
					elseif species == gIDDef.GOLD then
						currentResource = cityCtrl:getResCount(gIDDef.GOLD)
					elseif species == gIDDef.CRYSTAL then
						currentResource = cityCtrl:getResCount(gIDDef.CRYSTAL)
					elseif BUILD_STAR_COSTITEM[species] then
						currentResource = backpackCtrl:getItemCount(species)
					end
					local buff_add = 0
					local buffCtrl = gametop.playertop_:getModule("buffCtrl")
					if technologyId then
						local tp = string.sub(tostring(technologyId), 1, 2)
						buff_add = buffCtrl:getBuffEffect(gBuffEffect.STUDY_RESOURCE_REDUCE) or 0
						buff_add = buff_add / 1000
						local pet_add = buffCtrl:getBuffEffect(gBuffEffect.STUDY_RESOURCE_REDUCE, gBuffSource.PET) or 0
						pet_add = pet_add / 1000
						if tp == "21" or tp == "22" or tp == "23" then
						else
							buff_add = buff_add - pet_add
						end
					end
					local warTechReduce = self:getTechCostReduce(technologyId, originData)
					local hegemonReduce = buffCtrl:getBuffEffect(gBuffEffect.SCIENCE_RESOURCE_REDUCE, gBuffSource.HEGEMON_TITLE) or 0
					hegemonReduce = hegemonReduce / 1000
					consumeResource = math.ceil(consumeResource * (1 - buff_add - warTechReduce - hegemonReduce - reduceBuildMastery))
					if consumeResource < 0 then
						consumeResource = 0
					end
					if currentResource >= consumeResource then
						isContentmented = true
					else
						local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
						local luckyData = luckyBlessCtrl:getLuckyData()
						local ret = luckyData.curEffectType == gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH
						if ret and (species == gIDDef.FOOD or species == gIDDef.IRON or species == gIDDef.WOOD or species == gIDDef.MITHRIL) then
							local luckyBlessResource = luckyBlessCtrl:getResult(consumeResource)
							isLuckyContentmented = currentResource >= luckyBlessResource
						end
					end
					if 0 < consumeResource then
						gametop = true
						;(true).rid = species
						;(true).currentResource = currentResource
						;(true).consumeResourceOri = consumeResourceOri
						;(true).consumeResource = consumeResource
						;(true).isContentmented = isContentmented
						;(true).isLuckyContentmented = isLuckyContentmented
						table.insert(resources, true)
					end
				end
			end
		end
	end
	return resources
end
function technologyAuxiliary:mosaicTools(tools, technologyTools)
	if technologyTools then
		for index, var in ipairs(technologyTools) do
			if index % 2 ~= 0 then
				local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
				local species = technologyTools[index]
				local consumeResource = technologyTools[index + 1]
				local isContentmented = false
				local currentResource = backpackCtrl:getItemCount(tonumber(species))
				if consumeResource <= currentResource then
					isContentmented = true
				end
				if 0 < consumeResource then
					_ENV = tonumber(species)
					tonumber(species).rid = species
					tonumber(species).currentResource = currentResource
					tonumber(species).consumeResource = consumeResource
					tonumber(species).isContentmented = isContentmented
					table.insert(tools, tonumber(species))
				end
			end
		end
	end
	return tools
end
function technologyAuxiliary:getTechnologyById(technologyId)
	local _ENV, rs
	if self.technologyLocalData.technologyTypeData.resource[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.resource[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.cityDevelop[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.cityDevelop[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.anchor[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.anchor[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.military[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.military[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.special[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.special[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.soldier[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.soldier[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.leader[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.leader[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.hero[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.hero[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.wartechnology[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.wartechnology[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.warbattle[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.warbattle[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.warmilitary[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.warmilitary[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.warcommand[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.warcommand[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.warlight[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.warlight[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.advancedmilitary[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.advancedmilitary[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.process[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.process[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.nebula[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.nebula[tostring(technologyId)]
	elseif self.technologyLocalData.technologyTypeData.manor[tostring(technologyId)] then
		rs = self.technologyLocalData.technologyTypeData.manor[tostring(technologyId)]
	end
	return rs
end
function technologyAuxiliary:getUpgradeTime(status, level, technologyIdDetails, technologyId)
	local originalTime, transformationTime
	if status == 1 then
		originalTime = technologyIdDetails.technologyTime
		transformationTime = self:transformationTime(originalTime)
	elseif status == 2 then
		originalTime = 0
		transformationTime = ""
	elseif status == 3 then
		local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, level + 1)
		local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
		if nextTechnology then
			originalTime = nextTechnology.technologyTime
			transformationTime = self:transformationTime(originalTime)
		end
	end
	return transformationTime, originalTime
end
function technologyAuxiliary:transformationTime(times)
	local hours = math.floor(times / 3600)
	local minutes = math.floor(times % 3600 / 60)
	local seconds = math.floor(times % 60)
	if string.len(hours) == 1 then
		hours = "0" .. hours
	end
	if string.len(minutes) == 1 then
		minutes = "0" .. minutes
	end
	if string.len(seconds) == 1 then
		seconds = "0" .. seconds
	end
	return hours .. ":" .. minutes .. ":" .. seconds
end
function technologyAuxiliary:handlerTechnologyPower(status, level, technologyIdDetails, technologyId, type)
	local power = ""
	local showStr = technologyIdDetails.buffNumType == 1 and "%" or ""
	if type == 1 then
		if status == 1 then
			power = 0 .. showStr
		elseif status == 2 or status == 3 then
			power = technologyIdDetails.powerNum
			if technologyIdDetails.buffNumType == 1 then
				power = technologyIdDetails.powerNum / 1000 * 100 .. showStr
			else
				if self:isSpecialType(technologyIdDetails.buffType) then
					power = power / 1000
				end
				power = string.formatnumberthousands(power)
			end
		end
	elseif type == 2 then
		if status == 1 then
			power = technologyIdDetails.powerNum
			if technologyIdDetails.buffNumType == 1 then
				power = technologyIdDetails.powerNum / 1000 * 100 .. showStr
			else
				if self:isSpecialType(technologyIdDetails.buffType) then
					power = power / 1000
				end
				power = string.formatnumberthousands(power)
			end
		elseif status == 3 then
			local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, level + 1)
			local nextTechnologyIdDetails = self.technologyLocalData.technologyData[nextTechnologyIdStr]
			if nextTechnologyIdDetails then
				power = nextTechnologyIdDetails.powerNum
				if nextTechnologyIdDetails.buffNumType == 1 then
					power = nextTechnologyIdDetails.powerNum / 1000 * 100 .. showStr
				else
					if self:isSpecialType(technologyIdDetails.buffType) then
						power = power / 1000
					end
					power = string.formatnumberthousands(power)
				end
			end
		end
	end
	return power
end
function technologyAuxiliary:isSpecialType(buffType)
	if gTechnologyType.INFANTRY_BASE_DEFENSE == buffType or gTechnologyType.SOLDIER_BASE_ATTACK == buffType or gTechnologyType.INFANTRY_BASE_HP == buffType or gTechnologyType.CAVALRY_BASE_HP == buffType or gTechnologyType.ARCHER_BASE_DEFENSE == buffType or gTechnologyType.SOLDIER_ALL_ATTR == buffType or gTechnologyType.INFANTRY_BASE_ATTACK == buffType or gTechnologyType.ARCHER_BASE_ATTACK == buffType or gTechnologyType.CAVALRY_BASE_ATTACK == buffType or gTechnologyType.CAVALRY_BASE_DEFENSE == buffType or gTechnologyType.ARCHER_BASE_HP == buffType then
		return true
	end
end
function technologyAuxiliary:getTechnologyCost(resources, tools)
	local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
	local total = 0
	if resources then
		gametop = "luckyBlessCtrl"
		if resources ~= "luckyBlessCtrl" then
			for i, var in ipairs(resources) do
				if var and type(var) == "table" then
					gametop = type(var)
					if var ~= type(var) and var.isContentmented == false then
						local currentResource = var.currentResource
						local consumeResource = var.consumeResource
						if luckyBlessCtrl:getLuckyData().curEffectType == gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH then
							consumeResource = math.max(currentResource, luckyBlessCtrl:getResult(consumeResource))
						end
						local resource = consumeResource - currentResource
						total = total + serviceFunctions.resConvertToGold(var.rid, resource)
					end
				end
			end
		end
	end
	if tools then
		for k, var in pairs(tools) do
			if var and type(var) == "table" and var.isContentmented == false then
				local currentResource = var.currentResource
				local consumeResource = var.consumeResource
				local resource = consumeResource - currentResource
				local tmpConvertGold = 0
				if tonumber(var.rid) == gBadgeItemID.COMMON_BADGE_ID or tonumber(var.rid) == gBadgeItemID.ADVANCED_BADGE_ID then
					local badgeExchangeCtrl = gametop.playertop_:getModule("badgeExchangeCtrl")
					tmpConvertGold = badgeExchangeCtrl:getCostGoldByCount(resource, tonumber(var.rid))
				end
				total = total + tmpConvertGold
			end
		end
	end
	return total
end
function technologyAuxiliary:getTechnologyBuild(status, standard, technologyIdDetails, technologyId)
	local _UPVALUE0_, builds
	if status == 1 then
		local technologyBuild = technologyIdDetails.technologyBuild
		builds = self:mosaicBuilds(builds, technologyBuild)
	elseif status == 2 then
		builds, _UPVALUE0_ = technologyIdDetails.technologyBuild, technologyIdDetails.technologyBuild
	elseif status == 3 then
		local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, standard + 1)
		local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
		if nextTechnology then
			local technologyBuild = nextTechnology.technologyBuild
			builds = self:mosaicBuilds(builds, technologyBuild)
		end
	end
	return builds
end
function technologyAuxiliary:getTechnologyStarBuild(status, standard, technologyIdDetails, technologyId)
	local _UPVALUE0_, builds
	if status == 1 then
		local starbuild = technologyIdDetails.starbuild
		builds = self:mosaicStarBuilds(builds, starbuild)
	elseif status == 2 then
		builds, _UPVALUE0_ = technologyIdDetails.starbuild, technologyIdDetails.starbuild
	elseif status == 3 then
		local nextTechnologyIdStr = self:mosaicTechnologyId(technologyId, standard + 1)
		local nextTechnology = self.technologyLocalData.technologyData[nextTechnologyIdStr]
		if nextTechnology then
			local starbuild = nextTechnology.starbuild
			builds = self:mosaicStarBuilds(builds, starbuild)
		end
	end
	return builds
end
function technologyAuxiliary:mosaicStarBuilds(builds, technologyBuild)
	if technologyBuild then
		_ENV = nil
		if technologyBuild ~= nil then
			for index, var in ipairs(technologyBuild) do
				if index % 2 ~= 0 then
					local currentLevel = 0
					local bid = technologyBuild[index]
					local consumeLevel = technologyBuild[index + 1]
					if consumeLevel then
						local isContentmented = false
						currentLevel = SoraDGetBuildStarLv(bid)
						if consumeLevel <= currentLevel then
							isContentmented = true
						end
						_ENV = nil
						;(nil).bid = bid
						;(nil).currentLevel = currentLevel
						;(nil).consumeLevel = consumeLevel
						;(nil).isContentmented = isContentmented
						table.insert(builds, nil)
					end
				end
			end
		end
	end
	return builds
end
function technologyAuxiliary:mosaicBuilds(builds, technologyBuild)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	if technologyBuild then
		gametop = "manorCityCtrl"
		if technologyBuild ~= "manorCityCtrl" then
			for index, var in ipairs(technologyBuild) do
				if index % 2 ~= 0 then
					local currentLevel = 0
					local bid = technologyBuild[index]
					local consumeLevel = technologyBuild[index + 1]
					local isContentmented = false
					local bcell = cityCtrl:getBuildCell(bid, 0)
					if bcell ~= nil then
						currentLevel = tonumber(cityCtrl:getBuildCell(bid, 0).info.lv)
					end
					if currentLevel == 0 then
						currentLevel = manorCityCtrl:getBuildLvByBid(bid)
					end
					if consumeLevel <= currentLevel then
						isContentmented = true
					end
					gametop = bid
					bid.bid = bid
					bid.currentLevel = currentLevel
					bid.consumeLevel = consumeLevel
					bid.isContentmented = isContentmented
					table.insert(builds, bid)
				end
			end
		end
	end
	return builds
end
function technologyAuxiliary:mosaicTechnologyId(technologyId, level)
	return string.format("%d%02d", technologyId, level)
end
function technologyAuxiliary:getTechnologyAttribute(technologyId, technologyData)
	local tName = technologyLocalData.getTypeNameByID(technologyId)
	return technologyData[tName][tostring(technologyId)]
end
function technologyAuxiliary:getTechnologyType(technologyId, technologyData)
	return technologyLocalData.getTypeNameByID(technologyId)
end
function technologyAuxiliary:handlerUpdateRs(rs, data, type)
	local _ENV, updateRs
	local technologyId = data[1]
	local currentLevel
	if type == TECHNOLOGY_RESEARCH.research then
		currentLevel = data[2] - 1
	else
		currentLevel = data[2]
	end
	local technologytype = self:getTechnologyType(technologyId, rs)
	local post = self:getRelationPostSkill(tostring(technologyId))
	if post then
		_ENV = self
		if post ~= self then
			for _, postV in ipairs(post) do
				local postType = self:getTechnologyType(postV, rs)
				local isFlag = self:isMeet(rs, postV)
				if isFlag then
					rs[postType][postV].isOpened = true
					updateRs[postV] = rs[postType][postV]
				end
			end
		end
	end
	updateRs[tostring(technologyId)] = rs[technologytype][tostring(technologyId)]
	if type == TECHNOLOGY_RESEARCH.instantResearch then
		updateRs[tostring(technologyId)].currentLevel = currentLevel
	end
	return updateRs
end
function technologyAuxiliary:isContent()
end
function technologyAuxiliary:studyingTechnology(queueType, technologyData)
	queueType = queueType or gQueueTypeDef.technology_upgrade_queue
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queueData = queueCtrl:queryQueue(queueType)
	local technologyId
	if queueData then
		local data = queueData.data
		for key, var in pairs(data) do
			if type(var) == "table" then
				technologyId = key
			end
		end
	end
	if technologyId ~= nil then
		local level = self:getTechnologyAttribute(technologyId, technologyData).currentLevel
		return self:getTechnologyDetails(technologyId, level, technologyData), self:getTechnologyType(technologyId, technologyData)
	else
		return nil, nil
	end
end
function technologyAuxiliary:isTechActive(battleGround, bg)
	if battleGround == 0 then
		return true
	end
	local ground = bg or self:transGround()
	if battleGround and battleGround ~= ground then
		return false
	end
	return true
end
function technologyAuxiliary:transGround()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local ground = lordInfoCtrl:getPlayerBattleGround()
	return ground
end
technologyAuxiliary.transGround = SoraDCacheByFrame(technologyAuxiliary.transGround)
function technologyAuxiliary:getTechDataByType(data, buffType)
	local _ENV, ret
	local collegeDesRead = include("collegeDesRead")
	local cfg = collegeDesRead.getTechCfgByBuffType(buffType)
	for _, v in ipairs(cfg) do
		local id = math.floor(v.technologyID / 100)
		if v.technologyLevel == 1 then
			local lv = data[tostring(id)] and data[tostring(id)][2] or 1
			_ENV = nil
			;(nil).id = tonumber(id)
			;(nil).lv = lv
			;(nil).maxLv = v.technologyMaxLevel
			;(nil).isUnlock = data[tostring(id)] and true or false
			table.insert(ret, nil)
		end
	end
	return ret
end
function technologyAuxiliary:getTechnologyPower(data, tType, bg, isEffective)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queueData = queueCtrl:queryQueue(gQueueTypeDef.technology_upgrade_queue)
	local rs = 0
	if data == nil or next(data) == nil then
		return rs
	end
	for _, v in pairs(data) do
		local id = v[1]
		local level = v[2]
		local technologyIdStr = self:mosaicTechnologyId(id, level)
		local technologyDetails = self:getTechnologyDetailById(technologyIdStr)
		if technologyDetails and next(technologyDetails) ~= nil then
			local tempType = technologyDetails.buffType
			local isAreanNoActive = technologyDetails.isEffective == 1 or technologyDetails.isEffective == 0 and isEffective ~= true
			if isAreanNoActive and tempType == tType then
				for ki, vi in pairs(technologyDetails.battle) do
					if self:isTechActive(vi, bg) then
						local cardinal = technologyDetails.buffNumType == 1 and 1000 or 1
						if self:isSpecialType(technologyDetails.buffType) then
							cardinal = 1000
						end
						rs = rs + technologyDetails.powerNum / cardinal
					end
				end
			end
		end
	end
	return rs
end
technologyAuxiliary.getTechnologyPower = SoraDCacheByFrame(technologyAuxiliary.getTechnologyPower)
function technologyAuxiliary:cancleTechnology(queueType)
	queueType = queueType or gQueueTypeDef.technology_upgrade_queue
	local ret = false
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queueData = queueCtrl:queryQueue(queueType)
	if queueData then
		ret = true
		queueCtrl:removeQueue(queueType)
	end
	return ret
end
function technologyAuxiliary:getResearchTime(basetime, queueType, data)
	if basetime then
		if queueType == gQueueTypeDef.nebula_palace_technology then
			return basetime
		end
		local addPercent = 0
		if queueType == gQueueTypeDef.craft_study then
			addPercent = self:getCraftStudyResearchTimeAddPercent()
		elseif queueType == gQueueTypeDef.garden_technology then
			local buffCtrl = SoraDGetCtrl("buffCtrl")
			local buffValue = buffCtrl:getBuffEffect(gBuffEffect.GARDEN_TECHNOLOGY_SPEED_UP, gBuffSource.GARDEN)
			addPercent = buffValue / 1000 or 0
		else
			addPercent = self:getResearchTimeAddPercent(queueType, data)
		end
		local ret = math.floor(basetime * (1 / (1 + addPercent)))
		return ret
	else
		return 0
	end
end
function technologyAuxiliary:getCraftStudyResearchTimeAddPercent()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.CRAFT_STUDY_SPEED_UP)
	buffValue = buffValue and buffValue / 1000 or 0
	return buffValue
end
function technologyAuxiliary:getResearchTimeAddPercent(queueType, data)
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local add_alliancesci = allianceScience:getScienceAddValue(gAScienceType.TECH_RESEARCH_SPEED)
	local add_skill = lordInfoCtrl:getTechnologyPower(gLordTechnologyType.ACCELERATED)
	local buffValue = buffCtrl:getBuffEffect(gBuffEffect.RESEARCH_SPEED_BOOST)
	buffValue = buffValue and buffValue / 1000 or 0
	local warTechAdd = self:getTechnologyPower(data, gTechnologyType.TECH_RESEARCH_SPEED_BOOST) or 0
	local deBuffValue = buffCtrl:getBuffEffect(gBuffEffect.STUDY_SPEED_REDUCE)
	deBuffValue = deBuffValue and deBuffValue / 1000 or 0
	local attributeSystem = include("attributeSystem")
	local attr = attributeSystem.query(gAttributeEnum.RESEARCH_TECHNOLOGY_SPEED_RATE)
	if 0 ~= attr then
		attr = attr / 10000
	end
	local ret = add_alliancesci + add_skill + warTechAdd + buffValue - deBuffValue + attr
	return ret
end
function technologyAuxiliary:getTechIdPrefix(IdStr)
	return string.sub(tostring(IdStr), 1, -3)
end
function technologyAuxiliary:getTechIdLevel(IdStr)
	return string.sub(tostring(IdStr), -2)
end
function technologyAuxiliary:getQueueTypeByTechnologyId(techId)
	_UPVALUE2_, _ENV = nil, nil
	_UPVALUE2_, (nil)[1], (nil)[1] = nil, nil, 110000
	_UPVALUE2_, (nil)[1], (nil)[2] = nil, nil, 119999
	_UPVALUE2_, (nil)[2], (nil)[1] = nil, nil, 120000
	_UPVALUE2_, (nil)[2], (nil)[2] = nil, nil, 129999
	_UPVALUE2_, (nil)[3], (nil)[1] = nil, nil, 130000
	_UPVALUE2_, (nil)[3], (nil)[2] = nil, nil, 139999
	_UPVALUE2_, (nil)[4], (nil)[1] = nil, nil, 140000
	_UPVALUE2_, (nil)[4], (nil)[2] = nil, nil, 149999
	;(nil)[5], (nil)[1] = nil, 150000
	;(nil)[5], (nil)[2] = nil, 159999
	local array
	techId = tonumber(techId)
	for _, value in pairs(array) do
		if techId and techId >= value[1] and techId <= value[2] then
			return gQueueTypeDef.war_tech_research
		end
	end
	if techId and 170000 <= techId and techId <= 179999 then
		return gQueueTypeDef.craft_study
	elseif techId and (300000 <= techId and techId <= 399999 or 400000 <= techId and techId <= 499999) then
		return gQueueTypeDef.nebula_palace_technology
	elseif techId and 500000 <= techId and techId <= 599999 then
		return gQueueTypeDef.garden_technology
	else
		return gQueueTypeDef.technology_upgrade_queue
	end
end
function technologyAuxiliary:getTechCostReduce(technologyId, data)
	local warTechReduce = 0
	if technologyId and self:getQueueTypeByTechnologyId(technologyId) == gQueueTypeDef.technology_upgrade_queue then
		local tp = string.sub(tostring(technologyId), 1, 2)
		if tp == "21" then
			warTechReduce = self:getTechnologyPower(data, gTechnologyType.RESOURCE_TECH_COST_REDUCE) or 0
		elseif tp == "22" then
			warTechReduce = self:getTechnologyPower(data, gTechnologyType.CITY_DEVELOP_TECH_COST_REDUCE) or 0
		elseif tp == "23" then
			warTechReduce = self:getTechnologyPower(data, gTechnologyType.ANCHOR_TECH_COST_REDUCE) or 0
		elseif tp == "24" then
			tp = string.sub(tostring(technologyId), 1, 3)
			if tp == "240" then
				warTechReduce = self:getTechnologyPower(data, gTechnologyType.MILITARY_TECH_COST_REDUCE) or 0
			elseif tp == "241" then
				warTechReduce = self:getTechnologyPower(data, gTechnologyType.SPECIAL_TECH_COST_REDUCE) or 0
			elseif tp == "242" then
				warTechReduce = self:getTechnologyPower(data, gTechnologyType.SOLDIER_TECH_COST_REDUCE) or 0
			elseif tp == "243" then
				warTechReduce = self:getTechnologyPower(data, gTechnologyType.LEADER_TECH_COST_REDUCE) or 0
			end
		end
	end
	return warTechReduce
end
return technologyAuxiliary
