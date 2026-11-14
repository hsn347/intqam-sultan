local lordAuxiliary = class("lordAuxiliary")
local lordLocalData = include("lordLocalData")
local gametop = gModuleMgr.getObject("gametop")
local vipLocalData = include("vipLocalData")
local timerList = gModuleMgr.getObject("timerList")
function lordAuxiliary:ctor()
	self.lordLocalData = clone(lordLocalData)
end
function lordAuxiliary:strtrim(str)
	return string.match(str, "%s*(.-)%s*$")
end
function lordAuxiliary:validateImageId(imageId)
	local err = gErrDef.Err_None
	imageId = self:strtrim(imageId)
	if imageId == nil or #imageId == 0 then
		err = gErrDef.Err_IMAGEID_EMPTY
	elseif self.lordLocalData.headData[tostring(imageId)] == nil then
		err = gErrDef.Err_IMAGEID_NOT_EXITS
	end
	return err
end
function lordAuxiliary:getUpperValue(data)
	if self.lordLocalData == nil then
		self.lordLocalData = lordLocalData
	end
	local leve = data.base.level
	leve = leve < lordLocalData.getRealMaxLordLevel() and leve or lordLocalData.getRealMaxLordLevel()
	local physicalUpper = self.lordLocalData.rankData[leve].physical
	local expUpper = self.lordLocalData.rankData[leve].Exp
	data.physicalUpper = physicalUpper
	data.expUpper = expUpper
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local levelMax = lordInfoCtrl:getMaxLordLev()
	data.base.isReachFullExp = leve >= levelMax
	return data
end
function lordAuxiliary:getAllianceInfo(uid)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local aid = ""
	local abbr = ""
	local allianceId = allianceMgr:getOwnAid()
	if allianceId ~= nil then
		aid = allianceId
		local alliance = allianceMgr:getAlliance(allianceId)
		if alliance ~= nil then
			abbr = alliance:getProperty("abbr")
		end
	end
	return aid, abbr
end
function lordAuxiliary:setMaxExp(data)
	local leve = data.base.level
	local expUpper = self.lordLocalData.rankData[leve].Exp
	data.base.expUpper = expUpper
	return data
end
function lordAuxiliary:getLordBaseInfo(data)
	local lordLocalData, rs
	if data then
		lordLocalData = nil
		if data ~= nil then
			local leve = data.base.level
			leve = leve < lordLocalData.getRealMaxLordLevel() and leve or lordLocalData.getRealMaxLordLevel()
			local physical = data.base.health
			local physicalUpper = self.lordLocalData.rankData[leve].physical
			local exp = data.base.exp
			local expUpper = self.lordLocalData.rankData[leve].Exp
			local imageId = data.base.imageId
			local avatar = data.base.avatar
			local nickName = data.base.nickName
			local totalFc = data.fcInfo.totalFc
			local partition = data.base.partition
			local gold = data.base.gold
			local isSrcKingWarEnabled = data.base.isSrcKingWarEnabled
			local isSrcKingdomWarEnabled = data.base.isSrcKingdomWarEnabled
			local hasBindAccountReward = data.base.hasBindAccountReward
			local receiveBindPhone = data.base.receiveBindPhone
			local lordLocalData = include("lordLocalData")
			local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
			local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
			local maxLordLev = lordLocalData.getMaxLordLev(kingdomLev)
			local levelMax = maxLordLev
			rs.leve = leve
			rs.physical = physical
			rs.physicalUpper = physicalUpper
			rs.exp = exp
			rs.expUpper = expUpper
			rs.imageId = imageId
			rs.avatar = avatar
			rs.nickName = nickName
			rs.totalFc = totalFc
			rs.partition = partition
			rs.gold = gold
			rs.isSrcKingWarEnabled = isSrcKingWarEnabled
			rs.isSrcKingdomWarEnabled = isSrcKingdomWarEnabled
			rs.hasBindAccountReward = hasBindAccountReward
			rs.receiveBindPhone = receiveBindPhone
			rs.isReachFullExp = leve >= levelMax
		end
	end
	return rs
end
function lordAuxiliary:validateNickNameLegality(nickName)
	local err = "0"
	local __err
	local name = self:strtrim(nickName)
	if nickName and string.utf8len(name) > 0 then
		if string.utf8len(name) > MAX_NICKNAME_LEN then
			err = gErrDef.Err_NICKNAME
		elseif string.utf8len(name) < MIN_NICKNAME_LEN then
			err = gErrDef.Err_NICKNAME_MIN_SIZE
		elseif string.sub(name, 1, 1) == "(" then
			err = gErrDef.Err_NICKNAME_BRACKET
		elseif string.match(name, "$SoarDragon&") then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			__err = "It's your dad"
		elseif not gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameLegality(name) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		elseif not SoraDIsUtf8String(name) then
			err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
		end
	else
		err = gErrDef.Err_NICKNAME_MIN_SIZE
	end
	return err, __err
end
function lordAuxiliary:handleSkill(skillTable)
	local initBattle = "11001"
	local initDevelop = "12001"
	local initAuxiliary = "13001"
	local rs = self.lordLocalData.skillType
	local skillBasic = skillTable.skillBasic
	if skillBasic then
		_ENV = nil
		if skillBasic ~= nil then
			local type, maxLevel, battlePoints, developPoints, auxiliaryPoints = nil, nil, 0, 0, 0
			for key, var in pairs(skillBasic) do
				if rs.battle[key] then
					type = "battle"
					maxLevel = rs.battle[key].maxLevel
					battlePoints = battlePoints + math.ceil(tonumber(var[2]))
					rs.battle[key].currentLevel = math.ceil(tonumber(var[2]))
					rs.battle[key].isOpened = true
				elseif rs.develop[key] then
					type = "develop"
					maxLevel = rs.develop[key].maxLevel
					developPoints = developPoints + math.ceil(tonumber(var[2]))
					rs.develop[key].currentLevel = math.ceil(tonumber(var[2]))
					rs.develop[key].isOpened = true
				elseif rs.auxiliary[key] then
					type = "auxiliary"
					maxLevel = rs.auxiliary[key].maxLevel
					auxiliaryPoints = auxiliaryPoints + math.ceil(tonumber(var[2]))
					rs.auxiliary[key].currentLevel = math.ceil(tonumber(var[2]))
					rs.auxiliary[key].isOpened = true
				end
				local post = self:getRelationPostSkill(key)
				if post then
					_ENV = self
					if post ~= self then
						for _, postV in ipairs(post) do
							local front = self:getRelationFontSkill(postV)
							local isFlag = self:isMeet(rs, front, type)
							if isFlag then
								rs[type][postV].isOpened = true
							end
						end
					end
				end
			end
			rs.battlePoints = battlePoints
			rs.developPoints = developPoints
			rs.auxiliaryPoints = auxiliaryPoints
			rs.skillPoints = skillTable.skillPoints
			rs.battle[initBattle].isOpened = true
			rs.develop[initDevelop].isOpened = true
			rs.auxiliary[initAuxiliary].isOpened = true
	end
	else
		rs.battle[initBattle].isOpened = true
		rs.develop[initDevelop].isOpened = true
		rs.auxiliary[initAuxiliary].isOpened = true
		rs.skillPoints = skillTable.skillPoints
		rs.battlePoints = 0
		rs.developPoints = 0
		rs.auxiliaryPoints = 0
	end
	return rs
end
function lordAuxiliary:getResetSkillData(skillTable)
	local initBattle = "11001"
	local initDevelop = "12001"
	local initAuxiliary = "13001"
	local rs = self.lordLocalData.skillType
	rs.battle[initBattle].isOpened = true
	rs.develop[initDevelop].isOpened = true
	rs.auxiliary[initAuxiliary].isOpened = true
	rs.skillPoints = skillTable.skillPoints
	rs.battlePoints = 0
	rs.developPoints = 0
	rs.auxiliaryPoints = 0
	for k, _ in pairs(rs.battle) do
		if k ~= initBattle then
			rs.battle[k].isOpened = false
		end
		rs.battle[k].currentLevel = 0
	end
	for k, _ in pairs(rs.develop) do
		if k ~= initDevelop then
			rs.develop[k].isOpened = false
		end
		rs.develop[k].currentLevel = 0
	end
	for k, _ in pairs(rs.auxiliary) do
		if k ~= initAuxiliary then
			rs.auxiliary[k].isOpened = false
		end
		rs.auxiliary[k].currentLevel = 0
	end
	return rs
end
function lordAuxiliary:isMeet(rs, front, type)
	local isFlag = false
	if front then
		_ENV = nil
		if front ~= nil then
			for _, fontV in ipairs(front) do
				if rs[type][fontV].maxLevel == rs[type][fontV].currentLevel then
					isFlag = true
					break
				end
			end
		end
	end
	return isFlag
end
function lordAuxiliary:handleSkillUpdate(rsData, modifyData)
	local rs = self.lordLocalData.skillType
	local _ENV, updateRs
	if modifyData then
		_ENV = nil
		if modifyData ~= nil then
			local skillID = modifyData[1]
			local currentLevel = rsData.skillBasic[tostring(skillID)][2]
			local type
			if rs.battle[tostring(skillID)] then
				type = "battle"
				updateRs[tostring(skillID)] = rs.battle[tostring(skillID)]
			elseif rs.develop[tostring(skillID)] then
				type = "develop"
				updateRs[tostring(skillID)] = rs.develop[tostring(skillID)]
			elseif rs.auxiliary[tostring(skillID)] then
				type = "auxiliary"
				updateRs[tostring(skillID)] = rs.auxiliary[tostring(skillID)]
			end
			updateRs[tostring(skillID)].currentLevel = currentLevel
			updateRs[tostring(skillID)].isOpened = true
			local post = self:getRelationPostSkill(tostring(skillID))
			if post then
				_ENV = self
				if post ~= self then
					for _, postV in ipairs(post) do
						local front = self:getRelationFontSkill(postV)
						local isFlag = self:isMeet(rs, front, type)
						if isFlag then
							updateRs[tostring(postV)] = rs[type][tostring(skillID)]
							updateRs[tostring(postV)].isOpened = true
						end
					end
				end
			end
		end
	end
	return updateRs
end
function lordAuxiliary:getSkillDataByType(skillData, attr)
	local _ENV, rs
	if attr == LORD_ATTR.Auxiliary then
		rs.auxiliary = skillData.auxiliary
		rs.auxiliaryPoints = skillData.auxiliaryPoints
	elseif attr == LORD_ATTR.Develop then
		rs.develop = skillData.develop
		rs.developPoints = skillData.developPoints
	elseif attr == LORD_ATTR.Battle then
		rs.battle = skillData.battle
		rs.battlePoints = skillData.battlePoints
	end
	rs.skillPoints = skillData.skillPoints
	return rs
end
function lordAuxiliary:getRelationPostSkill(skillID)
	local _ENV, post
	local relationSkill = self.lordLocalData.skillCascade
	for k, var in pairs(relationSkill) do
		if type(var) == "table" then
			for _, v in ipairs(var) do
				if v == skillID then
					table.insert(post, k)
				end
			end
		end
	end
	return post
end
function lordAuxiliary:getRelationFontSkill(skillID)
	local _ENV, front
	local relationSkill = self.lordLocalData.skillCascade
	for k, var in pairs(relationSkill) do
		if k == skillID and type(var) == "table" then
			for _, var in ipairs(var) do
				table.insert(front, var)
			end
		end
	end
	return front
end
function lordAuxiliary:getSkillCD(skillID, currentLevel)
	local skill = 0
	if tonumber(currentLevel) <= 9 then
		skill = skillID .. "0" .. currentLevel
	else
		skill = skillID .. currentLevel
	end
	skill = tonumber(skill)
	if self.lordLocalData.skillData[skill] then
		return self.lordLocalData.skillData[skill].skillCurCD
	end
	return nil
end
function lordAuxiliary:getSkillPower(skillID, currentLevel)
	local _ENV, rs
	local skill = 0
	if tonumber(currentLevel) <= 9 then
		skill = skillID .. "0" .. currentLevel
	else
		skill = skillID .. currentLevel
	end
	skill = tonumber(skill)
	if self.lordLocalData.skillData[skill] then
		local skillProperty = tostring(self.lordLocalData.skillData[skill].skillProperty)
		if string.utf8len(skillProperty) < 10 then
			rs.pid = tonumber(string.sub(skillProperty, 1, 1))
			rs.type = tonumber(string.sub(skillProperty, 2, 3))
			rs.value = string.sub(skillProperty, 4, 9)
		else
			rs.pid = tonumber(string.sub(skillProperty, 1, 2))
			rs.type = tonumber(string.sub(skillProperty, 3, 4))
			rs.value = string.sub(skillProperty, 5, 10)
		end
		return rs
	end
	return rs
end
function lordAuxiliary:getSkillPost(skillID)
	local rs = self:getRelationPostSkill(tostring(skillID))
	return rs
end
function lordAuxiliary:getSkillFont(skillID)
	local rs = self:getRelationFontSkill(tostring(skillID))
	return rs
end
function lordAuxiliary:getSkillType(skillID)
	if self.lordLocalData.skillType.battle[tostring(skillID)] then
		return LORD_ATTR.Battle
	elseif self.lordLocalData.skillType.develop[tostring(skillID)] then
		return LORD_ATTR.Develop
	elseif self.lordLocalData.skillType.auxiliary[tostring(skillID)] then
		return LORD_ATTR.Auxiliary
	end
end
function lordAuxiliary:getSkillDetail(skillID, data)
	if data then
		_ENV = nil
		if data ~= nil then
			if data.battle[tostring(skillID)] then
				return data.battle[tostring(skillID)]
			elseif data.develop[tostring(skillID)] then
				return data.develop[tostring(skillID)]
			elseif data.auxiliary[tostring(skillID)] then
				return data.auxiliary[tostring(skillID)]
			end
		end
	end
end
function lordAuxiliary:updateLordBaseInfo(data, lordBaseInfo)
	local currentLevel = lordBaseInfo.level
	local currentEXP = lordBaseInfo.exp
	if data then
		_ENV = nil
		if data ~= nil then
			for key, var in pairs(data) do
				if type(var) == "table" and next(var) ~= nil and key ~= "castleReward" then
					for k, v in pairs(var) do
						lordBaseInfo[k] = v
					end
				else
					lordBaseInfo[key] = var
				end
			end
		end
	end
	return lordBaseInfo, currentLevel, currentEXP
end
function lordAuxiliary:getInitiativeSKill(data)
	local comps = function(a, b)
		return tonumber(a.skillID) > tonumber(b.skillID)
	end
	local initiativeSKill = self:initiativeSKill()
	if data and next(data) ~= nil then
		local skill = data.skill.skillBasic
		if skill and next(skill) ~= nil then
			for i, v in ipairs(initiativeSKill) do
				if skill[tostring(v.skillID)] then
					v.isOpened = true
				end
			end
		end
	end
	table.sort(initiativeSKill, comps)
	return initiativeSKill
end
function lordAuxiliary:initiativeSKill()
	local _ENV, rs
	local skillData = self.lordLocalData.skillData
	if skillData and next(skillData) ~= nil then
		for key, var in pairs(skillData) do
			if tonumber(var.isAcitve) == 1 then
				local skillID = string.sub(key, 0, 5)
				_ENV = 5
				;(5).skillID = skillID
				;(5).isOpened = false
				table.insert(rs, 5)
			end
		end
	end
	return rs
end
function lordAuxiliary:mosaicSkillId(skillID, level)
	local str = ""
	if level <= 9 then
		str = tostring(skillID) .. "0" .. tostring(level)
	else
		str = tostring(skillID) .. tostring(level)
	end
	return str
end
function lordAuxiliary:openQueue(data)
	local _ENV, rs
	local queueType = data.queueType
	local skillID = data.skillId
	local skillData = self.lordLocalData.skillData[tonumber(skillID)]
	if skillData and next(skillData) ~= nil then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local time = lordInfoCtrl:getLordSkillCDTime(skillData.skillCurCD)
		local starttime = serviceFunctions.systemTime()
		local totaltime = tonumber(time)
		local lefttime = tonumber(time)
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		_ENV = nil
		queueCtrl:addQueue(queueType, starttime, totaltime, lefttime, nil)
		table.insert(rs, tonumber(string.sub(skillID, 0, 5)))
		table.insert(rs, queueType)
		table.insert(rs, true)
	else
		table.insert(rs, tonumber(string.sub(skillID, 0, 5)))
		table.insert(rs, queueType)
	end
	return rs
end
function lordAuxiliary:getVip(lordInfo)
	local _ENV, rs
	if lordInfo and next(lordInfo) ~= nil then
		local level = lordInfo.vip.level
		table.insert(rs, level)
		local vipEndTime = lordInfo.vip.vipEndTime
		if 0 < vipEndTime then
			table.insert(rs, true)
		else
			table.insert(rs, false)
		end
	end
	return rs
end
function lordAuxiliary:getVipDetails(lordInfo)
	local _ENV, rs
	if lordInfo and next(lordInfo) ~= nil then
		local vipInfo = self:getVip(lordInfo)
		if vipInfo and next(vipInfo) ~= nil then
			rs.level = vipInfo[1]
			rs.isActivated = vipInfo[2]
		end
		rs.vipLogin = lordInfo.vip.loginDay
		rs.svipFlag = lordInfo.vip.svipFlag or false
		local point, sVipPoint = self:getVipPoint(rs.vipLogin + 1)
		if lordInfo.vip.svipFlag then
			rs.nextVipPoint = sVipPoint
		else
			rs.nextVipPoint = point
		end
		if rs.svipFlag then
			rs.vipPoint = lordInfo.vip.vipPoint - VIP_TO_SVIP_POINT
		else
			rs.vipPoint = lordInfo.vip.vipPoint
		end
		rs.realVipPoint = lordInfo.vip.vipPoint
		rs.vipPointUpper = vipLocalData.vipData[#vipLocalData.vipData].point
		rs.iconID = lordInfo.base.imageId
		rs.avatar = lordInfo.base.avatar
	end
	return rs
end
function lordAuxiliary:getVipPoint(level)
	local point = 0
	local sVipPoint = 0
	if vipLocalData.vipLoginData and next(vipLocalData.vipLoginData) ~= nil then
		point, sVipPoint = vipLocalData.getVipPoint(level)
	end
	return point, sVipPoint
end
function lordAuxiliary:getVipBuffDetails(level1, level2)
	local _UPVALUE0_, rs
	rs = self:generateBuff(level1, level2, "vipGift", rs)
	rs = self:generateBuff(level1, level2, "buildSpeed", rs)
	rs = self:generateBuff(level1, level2, "resources", rs)
	rs = self:generateBuff(level1, level2, "body", rs)
	rs = self:generateBuff(level1, level2, "monster", rs)
	rs = self:generateBuff(level1, level2, "march", rs)
	rs = self:generateBuff(level1, level2, "troop", rs)
	rs = self:generateBuff(level1, level2, "attack", rs)
	rs = self:generateBuff(level1, level2, "defense", rs)
	rs = self:generateBuff(level1, level2, "life", rs)
	rs = self:generateBuff(level1, level2, "hurt", rs)
	rs = self:generateBuff(level1, level2, "pyramidQuickSearch", rs)
	rs = self:generateBuff(level1, level2, "pyramidRefresh", rs)
	rs = self:generateBuff(level1, level2, "hero", rs)
	rs = self:generateBuff(level1, level2, "heroDouble", rs)
	rs = self:generateBuff(level1, level2, "soldierSpeed", rs)
	rs = self:generateBuff(level1, level2, "Workshop", rs)
	rs = self:generateBuff(level1, level2, "workshopQuality", rs)
	rs = self:generateBuff(level1, level2, "lost", rs)
	rs = self:generateBuff(level1, level2, "limit", rs)
	rs = self:generateBuff(level1, level2, "safeResource", rs)
	rs = self:generateBuff(level1, level2, "massArmy", rs)
	return rs
end
function lordAuxiliary:generateBuff(level1, level2, key, rs)
	local buff1, buff2 = self:getBuffByLevel(level1, level2, key)
	local judge = self:judgeBuff(buff1, buff2)
	if judge then
		local temp1 = buff1[3]
		local temp2 = buff2[3]
		_UPVALUE4_ = nil
		;(nil)[1] = temp1
		;(nil)[2] = temp2
		;(nil)[3] = buff1[1]
		;(nil)[4] = buff1[2]
		table.insert(rs, nil)
	end
	return rs
end
function lordAuxiliary:getBuffByLevel(level1, level2, key)
	local buff1, buff2
	if vipLocalData.vipBuffData and next(vipLocalData.vipBuffData) ~= nil then
		buff1 = vipLocalData.vipBuffData[tostring(level1)][key]
		buff2 = vipLocalData.vipBuffData[tostring(level2)][key]
	end
	return buff1, buff2
end
function lordAuxiliary:judgeBuff(buff1, buff2)
	local judge = false
	if buff1 ~= nil and buff2 ~= nil then
		local temp1 = buff1[3]
		local temp2 = buff2[3]
		if temp1 ~= 0 or temp2 ~= 0 then
			judge = true
		end
	end
	return judge
end
function lordAuxiliary:updateVipQueue(time)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.vip_time)
	if queue then
		timerList:increaseTime(queue.timerNode, tonumber(time))
	else
		local starttime = serviceFunctions.systemTime()
		local totaltime = tonumber(time)
		local lefttime = tonumber(time)
		gametop = tonumber(time)
		queueCtrl:addQueue(gQueueTypeDef.vip_time, starttime, totaltime, lefttime, tonumber(time))
	end
end
function lordAuxiliary:getTechnologyPower(lordInfo, tType)
	local rs = 0
	if lordInfo and next(lordInfo) ~= nil then
		local skillBasic = lordInfo.skill.skillBasic
		if skillBasic and next(skillBasic) ~= nil then
			for _, v in pairs(skillBasic) do
				local id = v[1]
				local level = v[2]
				local technologyIdStr = self:mosaicSkillId(id, level)
				local technologyDetails = self.lordLocalData.skillData[tonumber(technologyIdStr)]
				if technologyDetails and next(technologyDetails) ~= nil then
					local skillProperty = tostring(technologyDetails.skillProperty)
					local isAcitve = technologyDetails.isAcitve
					if isAcitve == 2 and string.len(skillProperty) == 10 then
						local tempType = string.sub(skillProperty, 1, 2)
						local cardinal = string.sub(skillProperty, 3, 4) == "01" and 1000 or 1
						if tonumber(tempType) == tType then
							rs = rs + tonumber(string.sub(skillProperty, 5, string.len(skillProperty))) / cardinal
						end
					end
				end
			end
		end
	end
	return rs
end
function lordAuxiliary:physicalRecInt(data)
	if data and next(data) ~= nil then
		local level = data.base.level
		local physicalRecovery = self.lordLocalData.rankData[tonumber(level)].physicalRecovery
		local addPercent = self:getPhysicalRecAddPercent()
		physicalRecovery = tonumber(string.match(tonumber(physicalRecovery) * (1 / (1 + addPercent)), "^(%d+)"))
		return physicalRecovery
	end
	return 0
end
function lordAuxiliary:getPhysicalRecAddPercent()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local lorddata = lordInfoCtrl.lordInfo
	local vipadd = 0
	if tonumber(lorddata.vip.vipEndTime) ~= 0 then
		local effect = buffCtrl:getBuffEffect(gBuffEffect.STAMINA_RECOVER_SPEED_BOOST, gBuffSource.VIP)
		if effect ~= nil then
			vipadd = tonumber(effect) / 1000
		end
	end
	local guardianAdd = buffCtrl:getBuffEffect(gBuffEffect.PHYSICAL_RECOVER_SPEED) or 0
	guardianAdd = tonumber(guardianAdd) / 1000
	local techadd = technologyCtrl:getTechnologyPower(gTechnologyType.PHYSICAL_REPLY)
	local lordSkillCtrl = gametop.playertop_:getModule("lordSkillCtrl")
	local skilladd = lordSkillCtrl:queryBuff(gLordTechnologyType.STAMINA_RECOVERY_RATE) or 0
	local ret = vipadd + techadd + skilladd + guardianAdd
	return ret
end
function lordAuxiliary:getSplitName(headData)
	local name = headData.nickName or ""
	local allianceAbbr = headData.allianceAbb
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = headData.nickName
		name = i18n("common_text_186", nil)
	end
	if headData.fromKid then
		name = name .. "#" .. tostring(headData.fromKid)
	end
	return name
end
function lordAuxiliary:setCastleLv(clv, Sprite_castle, Text_castleLv)
	local buildLogic = include("buildLogic")
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and 1 <= warLv then
		clv = warLv
		castleImg = "301101.png"
	end
	local clv = math.min(clv, 30)
	if Sprite_castle then
		Sprite_castle:setSpriteFrame(castleImg)
		Sprite_castle:setScale(35 / Sprite_castle:getContentSize().width)
	end
	if Text_castleLv then
		Text_castleLv:setString(clv)
	end
	return castleImg, clv
end
return lordAuxiliary
