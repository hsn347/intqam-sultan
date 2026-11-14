local cityltCtrl = include("cityltCtrl")
local _ENV, buildMoreInfoRead = "cityltCtrl", "cityltCtrl"
local buildMoreInfoRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	buildMoreInfoRead = nil
	;(nil)[1] = "buildMoreInfoTable"
	buildMoreInfoRead:defineValue("tableBuildDes", nil)
	buildMoreInfoRead:defineValue("iconRefInfo", function()
		_UPVALUE0_, _UPVALUE8_ = nil, nil
		;(nil).icon = "icon_small_food.png"
		;(nil).name = "common_text_021"
		_UPVALUE0_, (nil).des = nil, "common_text_021"
		;(nil).icon = "icon_small_wood.png"
		;(nil).name = "common_text_022"
		_UPVALUE0_, (nil).des = nil, "common_text_022"
		;(nil).icon = "icon_small_iron.png"
		;(nil).name = "common_text_023"
		_UPVALUE0_, (nil).des = nil, "common_text_023"
		;(nil).icon = "icon_small_silver.png"
		;(nil).name = "common_text_024"
		_UPVALUE0_, (nil).des = nil, "common_text_024"
		;(nil).icon = "icon_small_crystal.png"
		;(nil).name = "common_text_3865"
		_UPVALUE0_, (nil).des = nil, "common_text_3865"
		;(nil).icon = "1620.png"
		;(nil).name = "Soldiers_armor_text_43"
		_UPVALUE0_, (nil).des = nil, "Soldiers_armor_text_43"
		;(nil).icon = "icon_castle_defence_life.png"
		;(nil).name = "Glory_text_54"
		_UPVALUE0_, (nil).des = nil, "Glory_text_54"
		;(nil).icon = "icon_lord_kill.png"
		;(nil).name = "common_text_090"
		;(nil).des = "common_text_090"
		;(nil)[1] = nil
		;(nil)[2] = nil
		;(nil)[3] = nil
		;(nil)[4] = nil
		;(nil)[5] = nil
		;(nil)[6] = nil
		;(nil)[7] = nil
		;(nil)[8] = nil
		return nil
	end)
end
init()
function buildMoreInfoRead.getInfoByIconName(iconName)
	for k, v in ipairs(buildMoreInfoRead.iconRefInfo) do
		if v.icon == iconName then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(buildMoreInfoRead.iconRefInfo)
end
function buildMoreInfoRead.getResTitle(bid, key, outTable, mergeInfo, isStar)
	local resDesRead = include("resDesRead")
	local tableRes = cityltCtrl.buildLvInfo(bid, cityltCtrl.buildAttr(bid, isStar and BUILD_ATTR.MAXSTARLV or BUILD_ATTR.MAXLV), "capacity", isStar)
	for i, v in ipairs(tableRes) do
		if i % 2 == 1 then
			if mergeInfo ~= nil then
				local isInMerge = false
				for index = 1, #mergeInfo do
					if mergeInfo[index] == v then
						isInMerge = true
					end
				end
				if isInMerge then
					if v == mergeInfo[1] then
						local strTitle = resDesRead.getName(v)
						for index = 2, #mergeInfo do
							strTitle = strTitle .. "/" .. resDesRead.getName(mergeInfo[index])
						end
						_UPVALUE2_ = 1
						;(1)[1] = strTitle
						;(1)[2] = "string"
						table.insert(outTable, 1)
					end
				elseif v ~= gIDDef.METEOR_CRYSTAL or not not SoraDResIsLock(v) then
					_UPVALUE2_ = outTable
					outTable[1] = resDesRead.getName(v)
					outTable[2] = "string"
					table.insert(outTable, outTable)
				end
			elseif bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
				_UPVALUE2_ = outTable
				outTable[1] = resDesRead.getIcon(v)
				outTable[2] = "image"
				table.insert(outTable, outTable)
			else
				_UPVALUE2_ = outTable
				outTable[1] = resDesRead.getName(v)
				outTable[2] = "string"
				table.insert(outTable, outTable)
			end
		end
	end
end
function buildMoreInfoRead.getResValue(redTable, outTable, mergeInfo, bid)
	for i, v in ipairs(redTable) do
		if i % 2 == 0 then
			local resid = redTable[i - 1]
			if mergeInfo ~= nil then
				local isInMerge = false
				for index = 1, #mergeInfo do
					if mergeInfo[index] == resid then
						isInMerge = true
					end
				end
				if isInMerge then
					if resid == mergeInfo[1] then
						_UPVALUE2_ = 1
						;(1)[1] = string.formatnumberthousands(v)
						;(1)[2] = "number"
						table.insert(outTable, 1)
					end
				elseif resid ~= gIDDef.METEOR_CRYSTAL or not not SoraDResIsLock(resid) then
					_UPVALUE2_ = 1
					;(1)[1] = string.formatnumberthousands(v)
					;(1)[2] = "number"
					table.insert(outTable, 1)
				end
			elseif bid and bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
				_UPVALUE2_ = outTable
				outTable[1] = SoraDConvertNumberWithUnit(v)
				outTable[2] = "number"
				table.insert(outTable, outTable)
			else
				_UPVALUE2_ = outTable
				outTable[1] = string.formatnumberthousands(v)
				outTable[2] = "number"
				table.insert(outTable, outTable)
			end
		end
	end
end
function buildMoreInfoRead.getInfoData(bid, iid)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildLogic = include("buildLogic")
	local armyLogic = include("armyLogic")
	local buffDesRead = include("buffDesRead")
	bid = tonumber(bid)
	iid = tonumber(iid)
	local _ENV, tableData = tonumber(iid), tonumber(iid)
	local _ENV, tableKey = iid, iid
	local buildDesConfig = buildMoreInfoRead.tableBuildDes[tonumber(bid)]
	for i, v in ipairs(buildDesConfig.key) do
		table.insert(tableKey, v)
	end
	local maxLv = tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV))
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	local blv = tonumber(buildCell.info.lv)
	local slv = tonumber(buildCell.info.starLv)
	if blv <= CASTLE_MAXLV_NOWAR and bid == BUILDID.HERO_PRISON then
		for i, v in ipairs(tableKey) do
			if v == "heronum" then
				table.remove(tableKey, i)
				break
			end
		end
	end
	if bid == BUILDID.STAR_BRAVE_STATUE then
		tableKey, _ENV = BUILDID.STAR_BRAVE_STATUE, BUILDID.STAR_BRAVE_STATUE
		if 0 < slv then
			table.insert(tableKey, "kingdomPoint")
		end
		if SoraDIsBrave8Level() then
			if 0 < cityltCtrl.buildStarLvInfo(bid, slv, "capacity") then
				table.insert(tableKey, "capacity")
			end
			if 0 < cityltCtrl.buildStarLvInfo(bid, slv, "trainspeed") then
				table.insert(tableKey, "trainspeed")
			end
		end
	end
	for i, v in ipairs(tableKey) do
		local lvInfo = cityltCtrl.buildLvInfo(bid, blv, v) or 0
		local slvInfo = cityltCtrl.buildStarLvInfo(bid, slv, v)
		_ENV = bid
		bid.key = v
		bid.moreInfoType = 0
		bid.infoDesType = 0
		bid.title = ""
		bid.value = ""
		local bid.plusValue, tableValue = nil, bid
		local _moreInfoType = buildDesConfig.moreInfoType[i]
		local _infoCopyType = buildDesConfig.infoCopyType[i]
		local _infoSpecialType = buildDesConfig.infoSpecialType[i]
		local _infoDesType = buildDesConfig.infoDesType[i]
		tableValue.moreInfoType = _moreInfoType
		tableValue.infoDesType = _infoDesType
		if _infoCopyType == 0 then
			if _moreInfoType ~= 4 then
				if _moreInfoType == 1 then
					lvInfo = lvInfo + (slvInfo or 0)
					lvInfo = tostring(lvInfo / 10) .. "%"
					if bid == BUILDID.MARKET then
						tableValue.plusValue = "-" .. tostring(buildLogic.getMarketRate().add / 10) .. "%"
					elseif bid == BUILDID.HERO_TRAIN_GROUND and i == 2 then
						local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
						_ENV = cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV)
						tableValue.plusValue = "+" .. tostring(heroTrainGroundCtrl:getHourLeaderPoint(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV)).technoAdd * 100) .. "%"
					end
					tableValue.title = i18n(buildDesConfig.title[i])
				elseif _moreInfoType == 2 then
					lvInfo = lvInfo + (slvInfo or 0)
					lvInfo = "+" .. tostring(lvInfo / 10) .. "%"
					tableValue.title = i18n(buildDesConfig.title[i])
					if bid == BUILDID.TURRET then
						tableValue.plusValue = "+" .. tostring(buildLogic.getTurretSpeed(buildCell).add / 10) .. "%"
					end
				elseif _moreInfoType == 3 then
					local toblv = blv
					local toslv = slv
					if _infoSpecialType == 2 then
						for i = 1, tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV)) - blv do
							lvInfo = cityltCtrl.buildLvInfo(bid, blv + i, v)
							if lvInfo ~= 0 then
								toblv = blv + i
								break
							end
						end
					end
					if lvInfo and lvInfo ~= 0 then
						local armyDesRead = include("armyDesRead")
						local warLv = buildLogic.transformBuildLvToWarLv(toblv)
						if 0 <= warLv and toblv > CASTLE_MAXLV_NOWAR then
							if maxLv > blv then
								local toWarLv = buildLogic.transformBuildLvToWarLv(math.min(blv + 10, maxLv))
								local _ENV, warData = math.min(blv + 10, maxLv)
								local curWarLv = buildLogic.transformBuildLvToWarLv(blv)
								if 1 <= curWarLv then
									warData.title = i18n("bulidDyf_title_" .. tostring(bid) .. tostring(curWarLv * 10 + 30))
								else
									_ENV = tostring(bid)
									_ENV = math.min(blv + 10, maxLv)
									math.min(blv + 10, maxLv).lv = toWarLv
									tostring(bid).lv = i18n("common_text_1948", math.min(blv + 10, maxLv))
									tostring(bid).army = armyDesRead.getArmyTpyeName(bid)
									tostring(bid).star = toWarLv
									warData.title = i18n("common_text_1994", (tostring(bid)))
								end
								warData.infoDesType = tableValue.infoDesType
								warData.moreInfoType = tableValue.moreInfoType
								table.insert(tableData, warData)
							end
							_ENV = buildLogic.transformBuildLvToWarLv(blv)
							buildLogic.transformBuildLvToWarLv(blv).lv = warLv
							toblv = i18n("common_text_1948", (buildLogic.transformBuildLvToWarLv(blv)))
						end
						_ENV = buildLogic.transformBuildLvToWarLv(blv)
						buildLogic.transformBuildLvToWarLv(blv).army = armyDesRead.getName(lvInfo)
						buildLogic.transformBuildLvToWarLv(blv).lv = toblv
						lvInfo = i18n("common_text_1218", (buildLogic.transformBuildLvToWarLv(blv)))
					else
						print("瞭望塔详情不会出现")
					end
					tableValue.title = lvInfo
					lvInfo = nil
				else
					lvInfo = lvInfo + (slvInfo or 0)
					lvInfo = string.formatnumberthousands(lvInfo)
					tableValue.title = i18n(buildDesConfig.title[i])
					if bid == BUILDID.HALL_OF_WAR then
						tableValue.plusValue = buildLogic.getHallofwarCapacity().add
					elseif bid == BUILDID.EMBASSY then
						if i == 1 then
							tableValue.plusValue = 0
						elseif i == 2 then
							tableValue.plusValue = buildLogic.getAllianceHelpCountAndDescTime().reduceTime.add
						elseif i == 3 then
							tableValue.plusValue = buildLogic.getEmbassyReinforcements().add
						end
					elseif bid == BUILDID.MARKET then
						tableValue.plusValue = buildLogic.getMarketWeight().add
					elseif bid == BUILDID.DRILL_GROUDS then
						tableValue.plusValue = buildLogic.getExpArmyCount().add
					elseif bid == BUILDID.WALLS then
						if i == 1 then
							tableValue.plusValue = armyLogic.getTotalTrapCapacity().add
						elseif i == 2 then
							tableValue.plusValue = buildLogic.getWallsDef().add
						end
					elseif bid == BUILDID.FARM or bid == BUILDID.SAWMILL or bid == BUILDID.IRON_MINE or bid == BUILDID.STEEL or bid == BUILDID.CRYSTAL_MINE then
						if i == 1 then
							tableValue.plusValue = buildLogic.getResOutputHour(bid, blv, iid).totaladd
						elseif i == 2 then
							tableValue.plusValue = buildLogic.getResOututMaxCount(bid, blv, iid).add
						end
					elseif bid == BUILDID.TURRET then
						tableValue.plusValue = buildLogic.getTurretAtk(buildCell).add
					elseif bid == BUILDID.ELITE_PALACE then
						if i == 1 then
							tableValue.plusValue = include("elitePalaceAPI"):getDailyElitePointLimitInfo().add
						elseif i == 2 then
							local limit, vip_add = include("elitePalaceAPI"):getEliteSoldierLimit()
							tableValue.plusValue = vip_add
						end
					elseif bid == BUILDID.HERO_PRISON then
						if i == 1 then
							tableValue.plusValue = buildLogic.getHeroJailCapacity().add
						elseif i == 2 then
							tableValue.plusValue = buildLogic.getHeroJailReduceSpeedTime().add
						end
					end
					if _infoSpecialType == 1 then
						tableValue.infoDesType = 0
						tableValue.value = tostring(lvInfo)
						table.insert(tableData, tableValue)
						_ENV = table.insert
						table.insert.moreInfoType = _moreInfoType
						table.insert.infoDesType = _infoDesType
						table.insert.title = ""
						table.insert.value = 0
						tableValue, table.insert.plusValue = table.insert, nil
						if bid == BUILDID.MILITARY_TENT then
							lvInfo = armyLogic.getMaxTrainCount().base
							tableValue.plusValue = armyLogic.getMaxTrainCount().add
							tableValue.title = i18n("common_text_747")
						elseif bid == BUILDID.HOSTPITAL then
							lvInfo = buildLogic.getHostpitalTotalCapacity()
							tableValue.title = i18n("common_text_746")
							tableValue.plusValue = armyLogic.getHostpitalMaxCapacity().add
						end
						lvInfo = string.formatnumberthousands(lvInfo)
					end
				end
				tableValue.value = lvInfo
				table.insert(tableData, tableValue)
			else
				if not slvInfo then
					slvInfo, _ENV = table.insert, table.insert
				end
				for i = 1, #lvInfo / 2 do
					if SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]) then
						_ENV = SoraDResIsLock(lvInfo[(i - 1) * 2 + 1])
						SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).moreInfoType = _moreInfoType
						SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).infoDesType = _infoDesType
						SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).title = ""
						SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).value = ""
						local SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).plusValue, tableRes = nil, SoraDResIsLock(lvInfo[(i - 1) * 2 + 1])
						tableRes.title = lvInfo[(i - 1) * 2 + 1]
						tableRes.value = string.formatnumberthousands(lvInfo[i * 2] + (slvInfo[i * 2] or 0))
						if bid == BUILDID.DEPOT then
							tableRes.plusValue = buildLogic.getWarehouseProtectCount()[tostring(lvInfo[(i - 1) * 2 + 1])].add
						end
						table.insert(tableData, tableRes)
					end
				end
			end
		end
	end
	if 0 < slv then
		buildMoreInfoRead.addStarUnlockedSoldier(tableData, bid, slv)
		buildMoreInfoRead.addStarBuff(tableData, bid, slv)
		if BUILDID.MIRACLE ~= bid or not not IsArClient then
			buildMoreInfoRead.addStarUnlockedEnchantment(tableData, bid, slv)
		end
	end
	if bid == BUILDID.EMBASSY then
		buildMoreInfoRead.addHeroAppointBuff(tableData, bid, gBuffEffect.SUPER_CRYSTAL_GATHER_SPEED_BOOST)
	end
	if bid == BUILDID.HALL_OF_WAR then
		buildMoreInfoRead.addHeroAppointBuff(tableData, bid, gBuffEffect.MARCH_MONSTER_SPEED_BOOST)
	end
	if bid == BUILDID.COLLEGE then
		buildMoreInfoRead.addHeroAppointBuff(tableData, bid, gBuffEffect.RESEARCH_SPEED_BOOST)
	end
	return tableData
end
function buildMoreInfoRead.addHeroAppointBuff(tableData, bid, buffType)
	local heroAppointCtrl = SoraDGetCtrl("heroAppointCtrl")
	local buffDesRead = include("buffDesRead")
	if heroAppointCtrl:getAppointHero(bid) then
		local isBuff = false
		for k, v in ipairs(tableData) do
			if v.buffID and v.buffID == buffType then
				isBuff = true
				v.plusValue = "+" .. tostring(heroAppointCtrl:getBuffVale(buffType) / 10) .. "%"
			end
		end
		if not isBuff then
			_ENV = ipairs(tableData)
			ipairs(tableData).key = ""
			ipairs(tableData).moreInfoType = 3
			ipairs(tableData).infoDesType = 0
			ipairs(tableData).title = buffDesRead.getTitleBase(buffType)
			ipairs(tableData).value = "+0%"
			ipairs(tableData).plusValue = "+" .. tostring(heroAppointCtrl:getBuffVale(buffType) / 10) .. "%"
			table.insert(tableData, ipairs(tableData))
		end
	end
end
function buildMoreInfoRead.addStarUnlockedSoldier(tableData, bid, slv)
	local buildLogic = include("buildLogic")
	local key = "unlockedSoldier"
	local slvInfo = cityltCtrl.buildStarLvInfo(bid, slv, key)
	if slvInfo then
		_ENV = bid
		bid.key = key
		bid.moreInfoType = 3
		bid.infoDesType = 0
		bid.title = ""
		bid.value = ""
		local bid.plusValue, tableValue = nil, bid
		local toslv = slv
		for i = 1, tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV)) - slv do
			local unlockLv = cityltCtrl.buildStarLvInfo(BUILDID.CASTLE, slv + i, BUILD_LVINFO.KINGDOMLV)
			if not buildLogic.checkKingdomLevel(unlockLv) then
				break
			end
			slvInfo = cityltCtrl.buildStarLvInfo(bid, slv + i, key)
			if slvInfo ~= 0 then
				toslv = slv + i
				break
			end
		end
		if slvInfo and slvInfo ~= 0 then
			local armyDesRead = include("armyDesRead")
			_ENV = cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV)
			cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV).lv = toslv
			toslv = i18n("Glory_text_26", cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV))
			local armyLv = string.sub(tostring(slvInfo), -2, -1)
			if tonumber(armyLv) < 13 then
				local armyID = string.sub(tostring(slvInfo), 3, -1)
				_ENV = -1
				;(-1).name1 = armyDesRead.getName(armyID)
				;(-1).name2 = armyDesRead.getName(slvInfo)
				;(-1).lv = toslv
				slvInfo = i18n("Glory_text_02", -1)
			else
				_ENV = "Glory_text_02"
				;("Glory_text_02").army = armyDesRead.getName(slvInfo)
				;("Glory_text_02").lv = toslv
				slvInfo = i18n("common_text_1218", "Glory_text_02")
			end
			local _ENV, starData = i18n("common_text_1218", "Glory_text_02"), i18n("common_text_1218", "Glory_text_02")
			starData.title = slvInfo
			starData.infoDesType = tableValue.infoDesType
			starData.moreInfoType = tableValue.moreInfoType
			table.insert(tableData, starData)
		end
	end
end
function buildMoreInfoRead.addStarBuff(tableData, bid, slv)
	if not cityltCtrl.buildStarLvInfo(bid, slv, "buff") then
		local cityltCtrl, buff = cityltCtrl.buildStarLvInfo(bid, slv, "buff"), cityltCtrl.buildStarLvInfo(bid, slv, "buff")
	end
	local buffDesRead = include("buffDesRead")
	for i = 1, #buff, 2 do
		cityltCtrl = nil
		;(nil).key = ""
		;(nil).moreInfoType = 0
		;(nil).infoDesType = 0
		;(nil).title = ""
		;(nil).buffID = buff[i]
		;(nil).buffValue = buff[i + 1] / 10
		;(nil).value = ""
		local (nil).plusValue, tableValue
		tableValue.title = buffDesRead.getTitleBase(buff[i])
		if not (1 <= slv) or bid == BUILDID.EMBASSY and buff[i] == 62 then
		elseif bid == BUILDID.CRYSTAL_MINE and buff[i] == 555 then
			tableValue.title = i18n("buff_text_35")
			tableValue.infoDesType = 1
			tableValue.key = "legendSoldiers"
		elseif bid == BUILDID.STEEL and buff[i] == 556 then
			tableValue.title = i18n("buff_text_36")
			tableValue.infoDesType = 1
			tableValue.key = "legendSoldiers"
		elseif bid == BUILDID.IRON_MINE and buff[i] == 557 then
			tableValue.title = i18n("buff_text_37")
			tableValue.infoDesType = 1
			tableValue.key = "legendSoldiers"
		elseif bid == BUILDID.SAWMILL and buff[i] == 558 then
			tableValue.title = i18n("buff_text_38")
			tableValue.infoDesType = 1
			tableValue.key = "legendSoldiers"
		elseif bid == BUILDID.FARM and buff[i] == 559 then
			tableValue.title = i18n("buff_text_39")
			tableValue.infoDesType = 1
			tableValue.key = "legendSoldiers"
		end
		tableValue.value = buffDesRead.getTitleValueWithValue(buff[i], buff[i + 1] / 10, true)
		table.insert(tableData, tableValue)
	end
end
function buildMoreInfoRead.addStarUnlockedEnchantment(tableData, bid, slv)
	local buildLogic = include("buildLogic")
	local key = "unlockedenchantment"
	local slvInfo = cityltCtrl.buildStarLvInfo(bid, slv, key)
	if slvInfo then
		_ENV = bid
		bid.key = key
		bid.moreInfoType = 3
		bid.infoDesType = 0
		bid.title = ""
		bid.value = ""
		local bid.plusValue, tableValue = nil, bid
		local toslv = slv
		for i = 1, tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV)) - slv do
			local unlockLv = cityltCtrl.buildStarLvInfo(BUILDID.CASTLE, slv + i, BUILD_LVINFO.KINGDOMLV)
			if not buildLogic.checkKingdomLevel(unlockLv) then
				break
			end
			slvInfo = cityltCtrl.buildStarLvInfo(bid, slv + i, key)
			if slvInfo ~= 0 then
				toslv = slv + i
				break
			end
		end
		if slvInfo and slvInfo ~= 0 then
			local armyDesRead = include("armyDesRead")
			_ENV = cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV)
			cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV).level = toslv
			cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV).lv = slvInfo
			slvInfo = i18n("Glory_text_42", cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV))
			local _ENV, starData = i18n("Glory_text_42", cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV)), i18n("Glory_text_42", cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV))
			starData.title = slvInfo
			starData.infoDesType = tableValue.infoDesType
			starData.moreInfoType = tableValue.moreInfoType
			table.insert(tableData, starData)
		end
	end
end
function buildMoreInfoRead.getUpgradeInfoData(bid, iid, isStar)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	bid = tonumber(bid)
	iid = tonumber(iid)
	local _ENV, tableData = tonumber(iid), tonumber(iid)
	local _ENV, tableKey = iid, iid
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].key) do
		table.insert(tableKey, v)
	end
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	local blv = tonumber(buildCell.info.lv)
	if isStar then
		blv = tonumber(buildCell.info.starLv)
	end
	local toblv = blv + 1
	if toblv <= CASTLE_MAXLV_NOWAR and bid == BUILDID.HERO_PRISON then
		for i, v in ipairs(tableKey) do
			if v == "heronum" then
				table.remove(tableKey, i)
				break
			end
		end
	end
	for i, v in ipairs(tableKey) do
		local lvInfo = cityltCtrl.buildLvInfo(bid, blv, v, isStar)
		local tolvInfo = cityltCtrl.buildLvInfo(bid, toblv, v, isStar)
		_ENV = bid
		bid.title = ""
		bid.value = nil
		local bid.plusValue, tableValue = nil, bid
		local _moreInfoType = buildMoreInfoRead.tableBuildDes[bid].moreInfoType[i]
		if _moreInfoType ~= 4 then
			tolvInfo = tolvInfo - lvInfo
			local isPlus = 0 <= tolvInfo
			if _moreInfoType == 1 or _moreInfoType == 2 then
				tolvInfo = tostring(tolvInfo / 10) .. "%"
				lvInfo = tostring(lvInfo / 10) .. "%"
			elseif _moreInfoType == 0 then
				tolvInfo = string.formatnumberthousands(tolvInfo)
				lvInfo = string.formatnumberthousands(lvInfo)
			else
				print("无法显示")
				lvInfo = nil
				tolvInfo = nil
			end
			if isPlus then
				tolvInfo = "+" .. tolvInfo
			end
			tableValue.title = i18n(buildMoreInfoRead.tableBuildDes[bid].title[i])
			tableValue.value = lvInfo
			tableValue.plusValue = tolvInfo
			if tableValue.value and tableValue.plusValue then
				table.insert(tableData, tableValue)
			end
		else
			for i = 1, #lvInfo / 2 do
				if SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]) then
					_ENV = SoraDResIsLock(lvInfo[(i - 1) * 2 + 1])
					SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).title = ""
					SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).value = nil
					local SoraDResIsLock(lvInfo[(i - 1) * 2 + 1]).plusValue, tableRes = nil, SoraDResIsLock(lvInfo[(i - 1) * 2 + 1])
					tableRes.title = i18n("bulidDyf_title_" .. tostring(lvInfo[(i - 1) * 2 + 1]))
					tableRes.value = string.formatnumberthousands(lvInfo[i * 2])
					tableRes.plusValue = "+" .. string.formatnumberthousands(tolvInfo[i * 2] - lvInfo[i * 2])
					table.insert(tableData, tableRes)
				end
			end
		end
	end
	return tableData
end
function buildMoreInfoRead.getUpgradeStarInfoData(bid, iid)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local armyDesRead = include("armyDesRead")
	bid = tonumber(bid)
	iid = tonumber(iid)
	local _ENV, tableData = tonumber(iid), tonumber(iid)
	local _ENV, tableKey = iid, iid
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].key) do
		table.insert(tableKey, v)
	end
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	local blv = tonumber(buildCell.info.lv)
	local slv = tonumber(buildCell.info.starLv)
	if bid == BUILDID.STAR_BRAVE_STATUE then
		if not SoraDIsBrave8Level() then
			tableKey, _ENV = SoraDIsBrave8Level(), SoraDIsBrave8Level()
			table.insert(tableKey, "kingdomPoint")
		end
		table.insert(tableKey, "power")
	end
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	local blv = tonumber(buildCell.info.starLv)
	local toblv = blv + 1
	for i, v in ipairs(tableKey) do
		local lvInfo = cityltCtrl.buildLvInfo(bid, blv, v, true)
		local _ENV, tolvInfo = bid, cityltCtrl.buildLvInfo(bid, toblv, v, true) or 0
		bid.title = ""
		bid.value = nil
		local bid.nextValue, tableValue = nil, bid
		local _moreInfoType = buildMoreInfoRead.tableBuildDes[bid].moreInfoType[i]
		if _moreInfoType == 4 then
			if not lvInfo then
				lvInfo, _ENV = v, v
			end
			for i = 1, #tolvInfo / 2 do
				if SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]) then
					_ENV = SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1])
					SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]).title = ""
					SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]).value = nil
					local SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]).nextValue, tableRes = nil, SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1])
					local resID = tolvInfo[(i - 1) * 2 + 1]
					tableRes.title = i18n("bulidDyf_title_" .. tostring(resID))
					if resID == gIDDef.STEEL then
						tableRes.title = i18n("common_text_025")
					end
					local curVlue = lvInfo[i * 2] or 0
					tableRes.value = string.formatnumberthousands(curVlue)
					local nextValue = tolvInfo[i * 2] or 0
					tableRes.nextValue = string.formatnumberthousands(nextValue)
					tableRes.isPlus = curVlue < nextValue
					table.insert(tableData, tableRes)
				end
			end
		elseif _moreInfoType == 3 then
			if tableKey[i] == "unlockedSoldier" and 10000000 < tolvInfo then
				local armyLv = string.sub(tostring(tolvInfo), -2, -1)
				local value
				if tonumber(armyLv) < 13 then
					local armyID = string.sub(tostring(tolvInfo), 3, -1)
					_ENV = -1
					;(-1).name1 = armyDesRead.getName(armyID)
					;(-1).name2 = armyDesRead.getName(tolvInfo)
					value = i18n("Glory_text_51", -1)
				else
					_ENV = "Glory_text_51"
					;("Glory_text_51").army = armyDesRead.getName(tolvInfo)
					value = i18n("common_text_848", "Glory_text_51")
				end
				tableValue.title = i18n(buildMoreInfoRead.tableBuildDes[bid].title[i])
				tableValue.value = value
				tableValue.nextValue = nil
				table.insert(tableData, tableValue)
			end
		else
			lvInfo = lvInfo or 0
			if _moreInfoType == 1 or _moreInfoType == 2 then
				tableValue.isPlus = tolvInfo > lvInfo
				tolvInfo = tostring(tolvInfo / 10) .. "%"
				lvInfo = tostring(lvInfo / 10) .. "%"
			elseif _moreInfoType == 0 then
				tableValue.isPlus = tolvInfo > lvInfo
				tolvInfo = string.formatnumberthousands(tolvInfo)
				lvInfo = string.formatnumberthousands(lvInfo)
			end
			tableValue.title = i18n(buildMoreInfoRead.tableBuildDes[bid].title[i])
			tableValue.value = lvInfo
			tableValue.nextValue = tolvInfo
			if tableValue.value and tableValue.nextValue then
				table.insert(tableData, tableValue)
			end
		end
	end
	if not cityltCtrl.buildStarLvInfo(bid, blv, "buff") then
		local _ENV, lvInfo = cityltCtrl.buildStarLvInfo(bid, blv, "buff"), cityltCtrl.buildStarLvInfo(bid, blv, "buff")
	end
	if not cityltCtrl.buildStarLvInfo(bid, toblv, "buff") then
		local _ENV, tolvInfo = cityltCtrl.buildStarLvInfo(bid, toblv, "buff"), cityltCtrl.buildStarLvInfo(bid, toblv, "buff")
	end
	local buffDesRead = include("buffDesRead")
	for i = 1, #tolvInfo, 2 do
		_ENV = bid
		bid.title = ""
		bid.value = nil
		local bid.nextValue, tableValue = nil, bid
		tableValue.title = buffDesRead.getTitleBase(tolvInfo[i])
		local curVlue = lvInfo[i + 1] or 0
		tableValue.value = buffDesRead.getTitleValueWithValue(tolvInfo[i], curVlue / 10, true)
		local nextValue = tolvInfo[i + 1] or 0
		tableValue.nextValue = buffDesRead.getTitleValueWithValue(tolvInfo[i], nextValue / 10, true)
		tableValue.isPlus = curVlue < nextValue
		table.insert(tableData, tableValue)
	end
	local key = "unlockedenchantment"
	local tolvInfo = cityltCtrl.buildStarLvInfo(bid, toblv, key) or 0
	if 0 < tolvInfo then
		_ENV = bid
		bid.title = ""
		bid.value = nil
		local bid.nextValue, tableValue = nil, bid
		tableValue.title = i18n("common_text_740")
		_ENV = 0
		;(0).lv = tolvInfo
		tableValue.value = i18n("gemEnchant_text_36", 0)
		tableValue.nextValue = nil
		table.insert(tableData, tableValue)
	end
	return tableData
end
function buildMoreInfoRead.getUpgradeStatueBraveInfoData(bid, iid)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local armyDesRead = include("armyDesRead")
	bid = tonumber(bid)
	iid = tonumber(iid)
	local _ENV, tableData = tonumber(iid), tonumber(iid)
	local _ENV, tableKey = iid, iid
	local _ENV, tableTitle
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].key) do
		table.insert(tableKey, v)
	end
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[bid].title) do
		table.insert(tableTitle, v)
	end
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	local blv = tonumber(buildCell.info.lv)
	local slv = tonumber(buildCell.info.starLv)
	if bid == BUILDID.STAR_BRAVE_STATUE then
		if not SoraDIsBrave8Level() then
			tableTitle, _ENV, tableKey, _ENV = SoraDIsBrave8Level(), SoraDIsBrave8Level(), SoraDIsBrave8Level(), SoraDIsBrave8Level()
			table.insert(tableKey, "kingdomPoint")
			table.insert(tableTitle, "common_text_3953")
		end
		table.insert(tableKey, "power")
		table.insert(tableTitle, "common_text_090")
	end
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	local blv = tonumber(buildCell.info.starLv)
	local toblv = blv + 1
	for i, v in ipairs(tableKey) do
		local lvInfo = cityltCtrl.buildLvInfo(bid, blv, v, true)
		local _ENV, tolvInfo = bid, cityltCtrl.buildLvInfo(bid, toblv, v, true) or 0
		bid.title = ""
		bid.value = nil
		local bid.addValue, tableValue = nil, bid
		local _moreInfoType = buildMoreInfoRead.tableBuildDes[bid].moreInfoType[i]
		if _moreInfoType == 4 then
			if not lvInfo then
				lvInfo, _ENV = v, v
			end
			for i = 1, #tolvInfo / 2 do
				if SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]) then
					_ENV = SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1])
					SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]).title = ""
					SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]).value = nil
					local SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1]).addValue, tableRes = nil, SoraDResIsLock(tolvInfo[(i - 1) * 2 + 1])
					tableRes.title = i18n("bulidDyf_title_" .. tostring(resID))
					local resID = tolvInfo[(i - 1) * 2 + 1]
					if resID == gIDDef.STEEL then
						tableRes.title = i18n("common_text_025")
					end
					local curVlue = lvInfo[i * 2] or 0
					local nextValue = tolvInfo[i * 2] or 0
					local isPlus = curVlue < nextValue
					local fuhao = isPlus and "+" or ""
					tableRes.addValue = fuhao .. string.formatnumberthousands(nextValue - curVlue)
					tableRes.value = string.formatnumberthousands(curVlue)
					table.insert(tableData, tableRes)
				end
			end
		elseif _moreInfoType == 3 then
			if tableKey[i] == "unlockedSoldier" and 10000000 < tolvInfo then
				local armyLv = string.sub(tostring(tolvInfo), -2, -1)
				if tonumber(armyLv) < 13 then
					local armyID = string.sub(tostring(lvInfo), 3, -1)
					_ENV = -1
					;(-1).name1 = armyDesRead.getName(armyID)
					;(-1).name2 = armyDesRead.getName(tolvInfo)
					tableValue.value = i18n("Glory_text_51", -1)
				else
					_ENV = "Glory_text_51"
					;("Glory_text_51").army = armyDesRead.getName(tolvInfo)
					tableValue.value = i18n("common_text_848", "Glory_text_51")
				end
				tableValue.title = i18n(tableTitle[i])
				table.insert(tableData, tableValue)
			end
		else
			lvInfo = lvInfo or 0
			local isPlus
			local value = ""
			if _moreInfoType == 1 or _moreInfoType == 2 then
				isPlus = tolvInfo > lvInfo
				value = tostring((tolvInfo - lvInfo) / 10) .. "%"
				tableValue.value = tostring(lvInfo / 10) .. "%"
			elseif _moreInfoType == 0 then
				isPlus = tolvInfo > lvInfo
				print("tolvInfo", lvInfo, tolvInfo)
				value = string.formatnumberthousands(tolvInfo - lvInfo) or 0
				tableValue.value = string.formatnumberthousands(lvInfo) or 0
			end
			tableValue.title = i18n(tableTitle[i])
			local fuhao = isPlus and "+" or ""
			tableValue.addValue = fuhao .. value
			table.insert(tableData, tableValue)
		end
	end
	if not cityltCtrl.buildStarLvInfo(bid, blv, "buff") then
		local _ENV, lvInfo = cityltCtrl.buildStarLvInfo(bid, blv, "buff"), cityltCtrl.buildStarLvInfo(bid, blv, "buff")
	end
	if not cityltCtrl.buildStarLvInfo(bid, toblv, "buff") then
		local _ENV, tolvInfo = cityltCtrl.buildStarLvInfo(bid, toblv, "buff"), cityltCtrl.buildStarLvInfo(bid, toblv, "buff")
	end
	local buffDesRead = include("buffDesRead")
	for i = 1, #tolvInfo, 2 do
		_ENV = bid
		bid.title = ""
		bid.value = nil
		local bid.addValue, tableValue = nil, bid
		tableValue.title = buffDesRead.getTitleBase(tolvInfo[i])
		local curVlue = lvInfo[i + 1] or 0
		local nextValue = tolvInfo[i + 1] or 0
		tableValue.addValue = buffDesRead.getTitleValueWithValue(tolvInfo[i], (nextValue - curVlue) / 10, true)
		tableValue.value = buffDesRead.getTitleValueWithValue(tolvInfo[i], curVlue / 10, true)
		local isPlus = curVlue < nextValue
		local fuhao = isPlus and "+" or ""
		tableValue.addValue = fuhao .. tableValue.addValue
		table.insert(tableData, tableValue)
	end
	if bid == BUILDID.STAR_BRAVE_STATUE then
		_ENV = BUILDID.STAR_BRAVE_STATUE
		BUILDID.STAR_BRAVE_STATUE.title = ""
		BUILDID.STAR_BRAVE_STATUE.value = nil
		local BUILDID.STAR_BRAVE_STATUE.addValue, tableValue = nil, BUILDID.STAR_BRAVE_STATUE
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		local techId = technologyCtrl:getNextUnlockTechId(slv + 1)
		if techId then
			local collegeDesRead = include("collegeDesRead")
			_ENV = 0
			;(0).name = collegeDesRead.getName(techId)
			tableValue.title = i18n("Soldiers_armor_text_62", 0)
			table.insert(tableData, tableValue)
		end
	end
	return tableData
end
function buildMoreInfoRead.getMoreInfoData(bid)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildLogic = include("buildLogic")
	bid = tonumber(bid)
	local buildMoreInfoRead, _ENV, tableData = bid, tonumber(bid), tonumber(bid)
	local bid[1], tableKey = "blv", bid
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].key) do
		table.insert(tableKey, v)
	end
	if bid ~= BUILDID.WISHING_WELL then
		table.insert(tableKey, "power")
	end
	cityltCtrl, buildMoreInfoRead = tableKey, table.insert
	tableKey[1] = i18n("common_text_748")
	tableKey[2] = "string"
	local table.insert[1], tableTitle = tableKey, table.insert
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title) do
		if buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i] == 4 then
			if (bid == BUILDID.WISHING_WELL or bid == BUILDID.DEPOT) and tableKey[i + 1] == "capacity" then
				cityltCtrl = tableKey[i + 1]
				tableKey[i + 1][1] = gIDDef.FOOD
				local tableKey[i + 1][2], mergeInfo = gIDDef.WOOD, tableKey[i + 1]
				if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
					mergeInfo = nil
				end
				buildMoreInfoRead.getResTitle(bid, tableKey[i + 1], tableTitle, mergeInfo)
			else
				buildMoreInfoRead.getResTitle(bid, tableKey[i + 1], tableTitle)
			end
		elseif bid == BUILDID.HERO_PRISON and tableKey[i + 1] == "heronum" then
		else
			cityltCtrl = tableKey[i + 1]
			tableKey[i + 1][1] = i18n(v)
			tableKey[i + 1][2] = "string"
			table.insert(tableTitle, tableKey[i + 1])
		end
	end
	if bid ~= BUILDID.WISHING_WELL then
		if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
			cityltCtrl = ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)
			ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[1] = "icon_lord_kill.png"
			ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[2] = "image"
			table.insert(tableTitle, ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title))
		else
			cityltCtrl = ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)
			ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[1] = i18n("common_text_090")
			ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[2] = "string"
			table.insert(tableTitle, ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title))
		end
	end
	table.insert(tableData, tableTitle)
	local maxLv = tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV))
	local initLv = tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.INITLV))
	if bid == BUILDID.MIRACLE then
		table.remove(tableData)
		initLv = initLv + 1
	end
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	for curlv = initLv, maxLv do
		local _ENV, tableValue = cityltCtrl.buildAttr(bid, BUILD_ATTR.INITLV)
		if curlv <= CASTLE_MAXLV_NOWAR or curlv % 10 == 0 then
			if not kingdomLevelDataModuleAPI:isOpen() and 80 < curlv then
				break
			end
			if curlv == 40 then
				cityltCtrl, buildMoreInfoRead = kingdomLevelDataModuleAPI, kingdomLevelDataModuleAPI:isOpen()
				kingdomLevelDataModuleAPI[1] = i18n("common_text_310")
				kingdomLevelDataModuleAPI[2] = "string"
				local kingdomLevelDataModuleAPI:isOpen()[1], tableTitle = kingdomLevelDataModuleAPI, kingdomLevelDataModuleAPI:isOpen()
				for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title) do
					if buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i] == 4 then
						if (bid == BUILDID.WISHING_WELL or bid == BUILDID.DEPOT) and tableKey[i + 1] == "capacity" then
							cityltCtrl = tableKey[i + 1]
							tableKey[i + 1][1] = gIDDef.FOOD
							local tableKey[i + 1][2], mergeInfo = gIDDef.WOOD, tableKey[i + 1]
							if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
								mergeInfo = nil
							end
							buildMoreInfoRead.getResTitle(bid, tableKey[i + 1], tableTitle, mergeInfo)
						else
							buildMoreInfoRead.getResTitle(bid, tableKey[i + 1], tableTitle)
						end
					else
						if v == "bulidDyf_title_UnlockCharacter" then
							v = "common_text_1961"
						end
						cityltCtrl = tableKey[i + 1]
						tableKey[i + 1][1] = i18n(v)
						tableKey[i + 1][2] = "string"
						table.insert(tableTitle, tableKey[i + 1])
					end
				end
				if bid ~= BUILDID.WISHING_WELL then
					if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
						cityltCtrl = ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)
						ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[1] = "icon_lord_kill.png"
						ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[2] = "image"
						table.insert(tableTitle, ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title))
					else
						cityltCtrl = ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)
						ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[1] = i18n("common_text_090")
						ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[2] = "string"
						table.insert(tableTitle, ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title))
					end
				end
				if bid == BUILDID.MIRACLE then
					cityltCtrl = ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)
					ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[1] = i18n("common_text_740")
					ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title)[2] = "string"
					table.insert(tableTitle, ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title))
				end
				table.insert(tableData, tableTitle)
			end
			for i, v in ipairs(tableKey) do
				local moreInfoType = buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i - 1]
				local lvInfo = cityltCtrl.buildLvInfo(bid, curlv, v)
				if v == "blv" and lvInfo > CASTLE_MAXLV_NOWAR then
					lvInfo = buildLogic.transformBuildLvToWarLv(lvInfo)
				end
				if bid == BUILDID.HERO_PRISON and v == "heronum" and curlv <= CASTLE_MAXLV_NOWAR then
				elseif moreInfoType ~= 4 then
					if moreInfoType == 1 then
						cityltCtrl = CASTLE_MAXLV_NOWAR
						lvInfo, CASTLE_MAXLV_NOWAR[1] = CASTLE_MAXLV_NOWAR, tostring(lvInfo / 10) .. "%"
						lvInfo, CASTLE_MAXLV_NOWAR[2] = CASTLE_MAXLV_NOWAR, "number"
					elseif moreInfoType == 2 then
						cityltCtrl = CASTLE_MAXLV_NOWAR
						lvInfo, CASTLE_MAXLV_NOWAR[1] = CASTLE_MAXLV_NOWAR, "+" .. tostring(lvInfo / 10) .. "%"
						lvInfo, CASTLE_MAXLV_NOWAR[2] = CASTLE_MAXLV_NOWAR, "number"
					elseif moreInfoType == 3 then
						if lvInfo == 0 or 10000000 < lvInfo then
							if curlv > CASTLE_MAXLV_NOWAR and (bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.BARRACKS) then
								local soldierId = lvInfo
								cityltCtrl = "+" .. tostring(lvInfo / 10) .. "%"
								;("+" .. tostring(lvInfo / 10) .. "%")[1] = i18n("bulidDyf_title_" .. tostring(bid) .. tostring(curlv))
								local ("+" .. tostring(lvInfo / 10) .. "%")[2], skillInfo = "string", "+" .. tostring(lvInfo / 10) .. "%"
								if tableKey[i] == "unlockedSoldier" and 10000000 < soldierId then
									cityltCtrl = tableKey[i]
									_ENV = tostring(curlv)
									tostring(curlv).army = i18n("armyName_" .. tostring(soldierId))
									cityltCtrl, tableKey[i][1] = i18n("common_text_848", (tostring(curlv))), i18n("common_text_848", (tostring(curlv)))
									local cityltCtrl, tableKey[i][2], unLockInfo = i18n("common_text_848", (tostring(curlv))), "string", tableKey[i]
									lvInfo, i18n("common_text_848", (tostring(curlv)))[1] = i18n("common_text_848", (tostring(curlv))), unLockInfo[1] .. "\n" .. skillInfo[1]
									lvInfo, i18n("common_text_848", (tostring(curlv)))[2] = i18n("common_text_848", (tostring(curlv))), "string"
								else
									lvInfo = skillInfo
								end
							else
								cityltCtrl = lvInfo
								lvInfo, lvInfo[1] = lvInfo, ""
								lvInfo, lvInfo[2] = lvInfo, "string"
							end
						elseif 400 < lvInfo and lvInfo <= 910 then
							if math.floor(lvInfo / 100) == 8 then
								local trapType = math.floor(lvInfo / 10) % 10
								local lang = "armyName_801"
								if trapType == 0 then
									lang = "armyName_801"
								elseif trapType == 1 then
									lang = "armyName_811"
								elseif trapType == 2 then
									lang = "armyName_821"
								end
								cityltCtrl = "string"
								_ENV = "string"
								_ENV = tostring(soldierId)
								tostring(soldierId).num = lvInfo % 10
								;("string").army = i18n(lang, (tostring(soldierId)))
								lvInfo, ("string")[1] = "string", i18n("common_text_848", "string")
								lvInfo, ("string")[2] = "string", "string"
							else
								cityltCtrl = math.floor(lvInfo / 10) % 10
								_ENV = i18n("common_text_848", "string")
								i18n("common_text_848", "string").army = i18n("armyName_" .. tostring(lvInfo))
								lvInfo, (math.floor(lvInfo / 10) % 10)[1] = math.floor(lvInfo / 10) % 10, i18n("common_text_848", (i18n("common_text_848", "string")))
								lvInfo, (math.floor(lvInfo / 10) % 10)[2] = math.floor(lvInfo / 10) % 10, "string"
							end
						else
							cityltCtrl = math.floor(lvInfo / 10) % 10
							lvInfo, (math.floor(lvInfo / 10) % 10)[1] = math.floor(lvInfo / 10) % 10, i18n("bulidDyf_title_" .. tostring(lvInfo))
							lvInfo, (math.floor(lvInfo / 10) % 10)[2] = math.floor(lvInfo / 10) % 10, "string"
						end
					else
						cityltCtrl = math.floor(lvInfo / 10) % 10
						lvInfo, (math.floor(lvInfo / 10) % 10)[1] = math.floor(lvInfo / 10) % 10, string.formatnumberthousands(lvInfo)
						lvInfo, (math.floor(lvInfo / 10) % 10)[2] = math.floor(lvInfo / 10) % 10, "number"
					end
					table.insert(tableValue, lvInfo)
				elseif (bid == BUILDID.WISHING_WELL or bid == BUILDID.DEPOT) and tableKey[i] == "capacity" then
					cityltCtrl = tableKey[i]
					tableKey[i][1] = gIDDef.FOOD
					local tableKey[i][2], mergeInfo = gIDDef.WOOD, tableKey[i]
					if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
						mergeInfo = nil
					end
					buildMoreInfoRead.getResValue(lvInfo, tableValue, mergeInfo, bid)
				else
					buildMoreInfoRead.getResValue(lvInfo, tableValue)
				end
			end
			if bid == BUILDID.MIRACLE then
				local unlockDescribe = cityltCtrl.buildLvInfo(bid, curlv, "unlockDescribe")
				local strUnlockDescribe = ""
				if unlockDescribe and 0 < #unlockDescribe then
					for i, v11 in ipairs(unlockDescribe) do
						if 0 < string.len(strUnlockDescribe) then
							strUnlockDescribe = strUnlockDescribe .. "\n"
						end
						strUnlockDescribe = strUnlockDescribe .. i18n(v11)
					end
					print("unlockDecribe！！！！！！", strUnlockDescribe)
				end
				cityltCtrl = strUnlockDescribe
				strUnlockDescribe[1] = strUnlockDescribe
				strUnlockDescribe[2] = "string"
				table.insert(tableValue, strUnlockDescribe)
			end
			table.insert(tableData, tableValue)
		end
	end
	return tableData
end
function buildMoreInfoRead.getStarMoreInfoData(bid)
	bid = tonumber(bid)
	local buildMoreInfoRead, _ENV, tableData = bid, tonumber(bid), tonumber(bid)
	local bid[1], tableKey = "starlv", bid
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].key) do
		if bid ~= BUILDID.STAR_BRAVE_STATUE or SoraDIsBrave8Level() or v == "kingdomPoint" then
			table.insert(tableKey, v)
		end
	end
	if bid ~= BUILDID.WISHING_WELL then
		table.insert(tableKey, "power")
	end
	cityltCtrl, buildMoreInfoRead = tableKey, table.insert
	tableKey[1] = i18n("common_text_748")
	tableKey[2] = "string"
	local table.insert[1], tableTitle = tableKey, table.insert
	for i, v in ipairs(buildMoreInfoRead.tableBuildDes[tonumber(bid)].title) do
		if buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i] == 4 then
			if (bid == BUILDID.WISHING_WELL or bid == BUILDID.DEPOT) and tableKey[i + 1] == "capacity" then
				cityltCtrl = tableKey[i + 1]
				tableKey[i + 1][1] = gIDDef.FOOD
				local tableKey[i + 1][2], mergeInfo = gIDDef.WOOD, tableKey[i + 1]
				if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
					mergeInfo = nil
				end
				buildMoreInfoRead.getResTitle(bid, tableKey[i + 1], tableTitle, mergeInfo, true)
			else
				buildMoreInfoRead.getResTitle(bid, tableKey[i + 1], tableTitle, nil, true)
			end
		elseif bid ~= BUILDID.STAR_BRAVE_STATUE or SoraDIsBrave8Level() or tableKey[i + 1] == "kingdomPoint" then
			cityltCtrl = tableKey[i + 1]
			tableKey[i + 1][1] = i18n(v)
			tableKey[i + 1][2] = "string"
			table.insert(tableTitle, tableKey[i + 1])
		end
	end
	local key = "unlockedenchantment"
	local slvInfo = cityltCtrl.buildStarLvInfo(bid, 1, key)
	if slvInfo then
		cityltCtrl = key
		key[1] = i18n("common_text_740")
		key[2] = "string"
		table.insert(tableTitle, key)
	end
	if not cityltCtrl.buildStarLvInfo(bid, 1, "buff") then
		local _ENV, buff = cityltCtrl.buildStarLvInfo(bid, 1, "buff"), cityltCtrl.buildStarLvInfo(bid, 1, "buff")
	end
	local buffDesRead = include("buffDesRead")
	for i = 1, #buff, 2 do
		if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
			cityltCtrl = true
			;(true)[1] = "icon_castle_defence_life.png"
			;(true)[2] = "image"
			table.insert(tableTitle, true)
		else
			cityltCtrl = true
			;(true)[1] = buffDesRead.getTitleBase(buff[i])
			;(true)[2] = "string"
			table.insert(tableTitle, true)
		end
	end
	if bid ~= BUILDID.WISHING_WELL then
		if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
			cityltCtrl = 2
			;(2)[1] = "icon_lord_kill.png"
			;(2)[2] = "image"
			table.insert(tableTitle, 2)
		else
			cityltCtrl = 2
			;(2)[1] = i18n("common_text_090")
			;(2)[2] = "string"
			table.insert(tableTitle, 2)
		end
	end
	table.insert(tableData, tableTitle)
	local maxLv = tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXSTARLV))
	local initLv = 1
	if bid == BUILDID.STAR_BRAVE_STATUE then
		maxLv = cityltCtrl.getShowMaxLv(bid)
	end
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local armyDesRead = include("armyDesRead")
	local buildLogic = include("buildLogic")
	for curlv = initLv, maxLv do
		local unlockLv = cityltCtrl.buildStarLvInfo(BUILDID.CASTLE, curlv, BUILD_LVINFO.KINGDOMLV)
		print("getStarMoreInfoData", unlockLv, curlv, buildLogic.checkKingdomLevel(unlockLv))
		if not buildLogic.checkKingdomLevel(unlockLv) and bid ~= BUILDID.STAR_BRAVE_STATUE then
			break
		end
		local _ENV, tableValue = BUILDID.STAR_BRAVE_STATUE, BUILDID.STAR_BRAVE_STATUE
		for i, v in ipairs(tableKey) do
			local moreInfoType = buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i - 1]
			local lvInfo = cityltCtrl.buildStarLvInfo(bid, curlv, v)
			if bid == BUILDID.STAR_BRAVE_STATUE and v == "starlv" then
				local info = cityltCtrl.getQualityByStarLv(lvInfo)
				cityltCtrl = lvInfo
				_ENV = buildLogic.checkKingdomLevel(unlockLv)
				buildLogic.checkKingdomLevel(unlockLv).lv = info.level
				lvInfo, lvInfo[1] = lvInfo, cityltCtrl.getStatueBraveQualityName(info.quality) .. i18n("common_text_101", buildLogic.checkKingdomLevel(unlockLv))
				lvInfo, lvInfo[2] = lvInfo, "string"
				table.insert(tableValue, lvInfo)
			elseif moreInfoType ~= 4 then
				if moreInfoType == 1 and lvInfo ~= 0 then
					cityltCtrl = cityltCtrl.getQualityByStarLv(lvInfo)
					lvInfo, cityltCtrl.getQualityByStarLv(lvInfo)[1] = cityltCtrl.getQualityByStarLv(lvInfo), tostring(lvInfo / 10) .. "%"
					lvInfo, cityltCtrl.getQualityByStarLv(lvInfo)[2] = cityltCtrl.getQualityByStarLv(lvInfo), "number"
				elseif moreInfoType == 2 and lvInfo ~= 0 then
					cityltCtrl = cityltCtrl.getQualityByStarLv(lvInfo)
					lvInfo, cityltCtrl.getQualityByStarLv(lvInfo)[1] = cityltCtrl.getQualityByStarLv(lvInfo), "+" .. tostring(lvInfo / 10) .. "%"
					lvInfo, cityltCtrl.getQualityByStarLv(lvInfo)[2] = cityltCtrl.getQualityByStarLv(lvInfo), "number"
				elseif moreInfoType == 3 then
					if tableKey[i] == "unlockedSoldier" and 10000000 < lvInfo then
						local armyLv = string.sub(tostring(lvInfo), -2, -1)
						if tonumber(armyLv) < 13 then
							local armyID = string.sub(tostring(lvInfo), 3, -1)
							cityltCtrl = tostring(lvInfo)
							_ENV = buildLogic.checkKingdomLevel(unlockLv)
							buildLogic.checkKingdomLevel(unlockLv).name1 = armyDesRead.getName(armyID)
							buildLogic.checkKingdomLevel(unlockLv).name2 = armyDesRead.getName(lvInfo)
							lvInfo, tostring(lvInfo)[1] = tostring(lvInfo), i18n("Glory_text_51", buildLogic.checkKingdomLevel(unlockLv))
							lvInfo, tostring(lvInfo)[2] = tostring(lvInfo), "string"
						else
							cityltCtrl = string.sub(tostring(lvInfo), 3, -1)
							_ENV = "string"
							;("string").army = armyDesRead.getName(lvInfo)
							lvInfo, string.sub(tostring(lvInfo), 3, -1)[1] = string.sub(tostring(lvInfo), 3, -1), i18n("common_text_848", "string")
							lvInfo, string.sub(tostring(lvInfo), 3, -1)[2] = string.sub(tostring(lvInfo), 3, -1), "string"
						end
					else
						cityltCtrl = string.sub(tostring(lvInfo), -2, -1)
						lvInfo, string.sub(tostring(lvInfo), -2, -1)[1] = string.sub(tostring(lvInfo), -2, -1), ""
						lvInfo, string.sub(tostring(lvInfo), -2, -1)[2] = string.sub(tostring(lvInfo), -2, -1), "string"
					end
				elseif lvInfo ~= 0 then
					if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
						cityltCtrl = SoraDIsBrave8Level()
						lvInfo, SoraDIsBrave8Level()[1] = SoraDIsBrave8Level(), SoraDConvertNumberWithUnit(lvInfo)
						lvInfo, SoraDIsBrave8Level()[2] = SoraDIsBrave8Level(), "number"
					else
						cityltCtrl = SoraDIsBrave8Level()
						lvInfo, SoraDIsBrave8Level()[1] = SoraDIsBrave8Level(), string.formatnumberthousands(lvInfo)
						lvInfo, SoraDIsBrave8Level()[2] = SoraDIsBrave8Level(), "number"
					end
				else
					cityltCtrl = SoraDIsBrave8Level()
					lvInfo, SoraDIsBrave8Level()[1] = SoraDIsBrave8Level(), ""
					lvInfo, SoraDIsBrave8Level()[2] = SoraDIsBrave8Level(), "string"
				end
				table.insert(tableValue, lvInfo)
			elseif (bid == BUILDID.WISHING_WELL or bid == BUILDID.DEPOT) and tableKey[i] == "capacity" then
				cityltCtrl = tableKey[i]
				tableKey[i][1] = gIDDef.FOOD
				local tableKey[i][2], mergeInfo = gIDDef.WOOD, tableKey[i]
				if bid == BUILDID.DEPOT and SoraDIsBrave8Level() then
					mergeInfo = nil
				end
				buildMoreInfoRead.getResValue(lvInfo, tableValue, mergeInfo, bid)
			else
				buildMoreInfoRead.getResValue(lvInfo, tableValue, nil, bid)
			end
		end
		local key = "unlockedenchantment"
		local slvInfo = cityltCtrl.buildStarLvInfo(bid, curlv, key)
		if slvInfo then
			if 0 < slvInfo and (BUILDID.MIRACLE ~= bid or not not IsArClient) then
				cityltCtrl = not IsArClient
				_ENV = buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i - 1]
				buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i - 1].lv = slvInfo
				slvInfo, (not IsArClient)[1] = not IsArClient, i18n("gemEnchant_text_36", buildMoreInfoRead.tableBuildDes[tonumber(bid)].moreInfoType[i - 1])
				slvInfo, (not IsArClient)[2] = not IsArClient, "string"
			else
				cityltCtrl = not IsArClient
				slvInfo, (not IsArClient)[1] = not IsArClient, ""
				slvInfo, (not IsArClient)[2] = not IsArClient, "string"
			end
			if bid ~= BUILDID.WISHING_WELL then
				table.insert(tableValue, #tableValue, slvInfo)
			else
				table.insert(tableValue, slvInfo)
			end
		end
		if not cityltCtrl.buildStarLvInfo(bid, curlv, "buff") then
			local _ENV, buff = cityltCtrl.buildStarLvInfo(bid, curlv, "buff"), cityltCtrl.buildStarLvInfo(bid, curlv, "buff")
		end
		for i = 1, #buff, 2 do
			local value = buffDesRead.getTitleValueWithValue(buff[i], buff[i + 1] / 10, true)
			cityltCtrl = buff[i]
			buff[i][1] = value
			local buff[i][2], lvInfo = "number", buff[i]
			if bid ~= BUILDID.WISHING_WELL then
				table.insert(tableValue, #tableValue, lvInfo)
			else
				table.insert(tableValue, lvInfo)
			end
		end
		table.insert(tableData, tableValue)
	end
	return tableData
end
function buildMoreInfoRead.getNextUnlockedInfo(bid, blv)
	bid = tonumber(bid)
	blv = tonumber(blv)
	local maxLv = tonumber(cityltCtrl.buildAttr(bid, BUILD_ATTR.MAXLV))
	if maxLv >= blv + 1 then
		local key
		if bid == BUILDID.CASTLE then
			key = "unlockedBuild"
		elseif bid == BUILDID.COLLEGE then
			key = "unlockedTechnology"
		elseif bid == BUILDID.ELITE_PALACE or bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.BARRACKS or bid == BUILDID.FORTRESS then
			key = "unlockedSoldier"
		end
		if key then
			for i = blv + 1, maxLv do
				local unlockedID = cityltCtrl.buildLvInfo(bid, i, key)
				if unlockedID and 0 < unlockedID then
					return unlockedID, i
				end
			end
		end
	end
	return nil
end
return buildMoreInfoRead
