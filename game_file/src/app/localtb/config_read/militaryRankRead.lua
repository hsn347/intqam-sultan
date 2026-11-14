local militaryRankRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "military_rank_level"
	;(nil)[2] = true
	militaryRankRead:defineValue("level", nil)
	_ENV = nil
	;(nil)[1] = "military_rank_reward"
	;(nil)[2] = true
	militaryRankRead:defineValue("reward", nil)
	_ENV = nil
	;(nil)[1] = "military_rank_shop"
	;(nil)[2] = true
	militaryRankRead:defineValue("shop", nil)
	_ENV = nil
	;(nil)[1] = "military_skill_buff"
	;(nil)[2] = true
	militaryRankRead:defineValue("skillbuff", nil)
	militaryRankRead = nil
	;(nil)[1] = "military_rank_skill_view"
	militaryRankRead:defineValue("skillDes", nil)
	militaryRankRead = nil
	;(nil)[1] = "military_rank_level_view"
	militaryRankRead:defineValue("rankDes", nil)
	_ENV = nil
	;(nil)[1] = "military_rank_skill"
	;(nil)[2] = true
	militaryRankRead:defineValue("skill", nil)
	local createData = function(name)
		militaryRankRead.skill = require_data("military_rank_skill", true, true).data
		local militaryRankRead, skillsTypeCfg = require_data("military_rank_skill", true, true).data, require_data("military_rank_skill", true, true).data
		for k, v in pairs(militaryRankRead.skill) do
			if skillsTypeCfg[v.skillType] == nil then
				skillsTypeCfg[v.skillType], militaryRankRead = nil, nil
			end
			local tmpSkillIndex = tonumber(k)
			v.skillIndex = tmpSkillIndex
			table.insert(skillsTypeCfg[v.skillType], v)
		end
		militaryRankRead.skillsTypeCfg = skillsTypeCfg
		return militaryRankRead[name]
	end
	militaryRankRead:defineValue("skill", createData)
	militaryRankRead:defineValue("skillsTypeCfg", createData)
	militaryRankRead:defineValue("ranks", function()
		local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
		if militaryRankCtrl == nil then
			return nil
		end
		local _ENV, tmpRanks
		for k, v in pairs(militaryRankRead.level) do
			_ENV = nil
			;(nil).effect, _ENV, (nil).lv = v.militaryLevel, v.militaryLevel, v.militaryLevel
			local single
			local effect = v.effectType
			for i = 1, #effect, 2 do
				local tmpEffectID = tonumber(effect[i])
				local tmpEffectNum = tonumber(effect[i + 1])
				_ENV = nil
				;(nil).id = militaryRankCtrl:getBuffType(tmpEffectID)
				;(nil).num = tmpEffectNum
				table.insert(single.effect, nil)
			end
			tmpRanks[v.militaryLevel] = single
		end
		return tmpRanks
	end)
	militaryRankRead:defineValue("rewards", function()
		local _ENV, tmpRewards
		for i, v in ipairs(militaryRankRead.reward) do
			_ENV = nil
			;(nil).rewards, _ENV, (nil).rank = v.rank, v.rank, v.rank
			local single
			local rewards = v.reward
			for i = 1, #rewards, 2 do
				local tmpRewardID = tonumber(rewards[i])
				local tmpRewardNum = tonumber(rewards[i + 1])
				_ENV = nil
				;(nil).id = tmpRewardID
				;(nil).count = tmpRewardNum
				table.insert(single.rewards, nil)
			end
			table.insert(tmpRewards, single)
		end
		return tmpRewards
	end)
	militaryRankRead:defineValue("maxLv", function()
		local maxLv = 1
		for k, v in pairs(militaryRankRead.level) do
			if maxLv <= v.militaryLevel then
				maxLv = v.militaryLevel
			end
		end
		return maxLv
	end)
end
init()
require("app.constdef.militaryRankDef")
function militaryRankRead.getShopCfg(mShopType)
	local tmpShopType = tonumber(mShopType)
	local _ENV, shopCfg = mShopType, mShopType
	for k, v in pairs(militaryRankRead.shop) do
		if tmpShopType == tonumber(k) then
			shopCfg.Type = v.Type
			shopCfg.id = v.Effect
			shopCfg.quality = v.quality
			break
		end
	end
	return shopCfg
end
function militaryRankRead.isInMilitaryShop(id)
	local quality = 0
	for k, v in pairs(militaryRankRead.shop) do
		if v.Effect == id then
			quality = v.quality
			return true, quality
		end
	end
	return false, quality
end
function militaryRankRead.getSkillCfg(mSkillType)
	local tmpSkillType = tonumber(mSkillType)
	local _ENV, skillCfg = mSkillType, mSkillType
	for k, v in pairs(militaryRankRead.skillsTypeCfg) do
		if tmpSkillType == tonumber(v.skillType) then
			local tmpSkillID = tonumber(k)
			local tmpLevel = tonumber(v.level)
			skillCfg[tmpLevel] = v
		end
	end
	return skillCfg
end
function militaryRankRead.getSkillsByType()
	return militaryRankRead.skillsTypeCfg
end
function militaryRankRead.getSkillCfgByTypeAndLv(mType, mLv)
	mLv = tonumber(mLv)
	mType = tonumber(mType)
	for k, v in pairs(militaryRankRead.skill) do
		local tmpSkillIndex = tonumber(k)
		if v.skillType == mType and v.level == mLv then
			return v
		end
	end
	return nil
end
function militaryRankRead.getSkillEffect(mEffectID)
	for k, v in pairs(militaryRankRead.skillbuff) do
		if tonumber(k) == mEffectID then
			return v
		end
	end
	return nil
end
function militaryRankRead.getRewardCfg(mRank)
	local _ENV, tmpRewards
	for k, v in pairs(militaryRankRead.reward) do
		local rankRange = v.rank
		local tmpLen = #rankRange
		local bingo = false
		if 1 == tmpLen then
			if mRank == tonumber(rankRange[1]) then
				bingo = true
			end
		elseif 2 == tmpLen and mRank >= tonumber(rankRange[1]) and mRank <= tonumber(rankRange[2]) then
			bingo = true
		end
		if bingo then
			local rewards = v.reward
			for i = 1, #rewards, 2 do
				local tmpRewardID = tonumber(rewards[i])
				local tmpRewardNum = tonumber(rewards[i + 1])
				_ENV = nil
				;(nil).id = tmpRewardID
				;(nil).count = tmpRewardNum
				table.insert(tmpRewards, nil)
			end
			break
		end
	end
	return tmpRewards
end
function militaryRankRead.getRankList()
	return militaryRankRead.ranks
end
function militaryRankRead.getRewardList()
	return militaryRankRead.rewards
end
function militaryRankRead.getRankMax()
	return militaryRankRead.maxLv
end
function militaryRankRead.getRankNeedPoint(mRankLv)
	local tmpRankLv = mRankLv and tonumber(mRankLv) or 1
	local point = -1
	for k, v in pairs(militaryRankRead.level) do
		if v.militaryLevel == tmpRankLv then
			point = v.needPoint
			break
		end
	end
	return point
end
function militaryRankRead.getSkillName(mSkillID)
	local tmpSkillID = tonumber(mSkillID)
	return i18n(militaryRankRead.skillDes[tmpSkillID].name)
end
function militaryRankRead.getSkillDes(mSkillID)
	local tmpSkillID = tonumber(mSkillID)
	local effectType = militaryRankRead.skill[tmpSkillID].effectType
	local tmpValue = militaryRankRead.getSkillEffect(effectType)
	_ENV = nil
	;(nil).value = tmpValue.effect[2] / 10
	return i18n(militaryRankRead.skillDes[tmpSkillID].des, nil)
end
function militaryRankRead.getSkillIcon(mSkillID)
	local tmpSkillID = tonumber(mSkillID)
	local fileName = militaryRankRead.skillDes[tmpSkillID].icon
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName) == nil then
		fileName = "icon_item_common.png"
	end
	return fileName
end
function militaryRankRead.getRankNameByLv(mRankLv)
	local tmpRankLv = mRankLv and tonumber(mRankLv) or 1
	local name
	for k, v in pairs(militaryRankRead.rankDes) do
		if v.lv == tmpRankLv then
			name = v.name
			break
		end
	end
	return i18n(name)
end
function militaryRankRead.getRankIconByLv(mRankLv, fromMemory)
	local tmpRankLv = mRankLv and tonumber(mRankLv) or 1
	local fileName
	for k, v in pairs(militaryRankRead.rankDes) do
		if v.lv == tmpRankLv then
			fileName = v.icon
			break
		end
	end
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName) == nil then
		fileName = "icon_item_common.png"
	end
	if fromMemory then
		fileName = "#" .. fileName
	end
	return fileName
end
function militaryRankRead.getRankNameByID(mRankID)
	local tmpRankID = tonumber(mRankID)
	return i18n(militaryRankRead.rankDes[tmpRankID].name)
end
function militaryRankRead.getRankIconByID(mRankID)
	local tmpRankID = tonumber(mRankID)
	local fileName = militaryRankRead.rankDes[tmpRankID].icon
	if cc.SpriteFrameCache:getInstance():getSpriteFrame(fileName) == nil then
		fileName = "icon_item_common.png"
	end
	return fileName
end
function militaryRankRead.getRankStr(rank, max)
	max = max or 300
	local rankStr = ""
	if rank == nil or rank <= 0 then
		rankStr = i18n("common_text_827")
	elseif 0 < rank and rank <= max then
		rankStr = string.formatnumberthousands(rank)
	else
		rankStr = string.formatnumberthousands(max) .. "+"
	end
	return rankStr
end
_UPVALUE2_ = nil
;(nil)[1] = "military_war_zone"
;(nil)[2] = true
militaryRankRead:defineValue("military_war_zone", nil)
local MILITARY_RANK_KINGDOMS_PER_CREW = 5
function militaryRankRead.getServerGroupKingdomRange()
	local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
	local gametop = gModuleMgr.getObject("gametop")
	local mKid = gametop.playertop_:getKingdomID()
	local militaryZoneCfg = militaryRankRead.military_war_zone
	local len = #militaryZoneCfg
	local maxKid = militaryZoneCfg[len].kid[1]
	local _ENV, kids
	if mKid >= maxKid then
		local remainder = #militaryZoneCfg[len - 1].kid % MILITARY_RANK_KINGDOMS_PER_CREW
		if mKid - maxKid < MILITARY_RANK_KINGDOMS_PER_CREW - remainder then
			local lenTemp = #militaryZoneCfg[len - 1].kid
			local begin = lenTemp - remainder + 1
			for i = begin, lenTemp do
				table.insert(kids, militaryZoneCfg[len - 1].kid[i])
			end
			for kid = maxKid, mKid do
				table.insert(kids, kid)
			end
			if #kids < MILITARY_RANK_KINGDOMS_PER_CREW then
				for i = 1, MILITARY_RANK_KINGDOMS_PER_CREW - #kids do
					local kid = mKid + i
					if kingdomCtrl:isFoundKingdomID(kid) then
						table.insert(kids, kid)
					end
				end
			end
		else
			local temp = maxKid + (MILITARY_RANK_KINGDOMS_PER_CREW - remainder)
			local begin = temp + MILITARY_RANK_KINGDOMS_PER_CREW * math.floor((mKid - temp) / MILITARY_RANK_KINGDOMS_PER_CREW)
			for kid = begin, begin + MILITARY_RANK_KINGDOMS_PER_CREW - 1 do
				if kingdomCtrl:isFoundKingdomID(kid) then
					table.insert(kids, kid)
				end
			end
		end
	else
		local isFind = false
		local findType = 0
		for type, v in ipairs(militaryZoneCfg) do
			for i, kid in ipairs(v.kid) do
				if kid == mKid then
					local begin = MILITARY_RANK_KINGDOMS_PER_CREW * math.floor((i - 1) / MILITARY_RANK_KINGDOMS_PER_CREW) + 1
					local endIdx = begin + MILITARY_RANK_KINGDOMS_PER_CREW - 1
					if endIdx > #v.kid then
						endIdx = #v.kid
					end
					for i = begin, endIdx do
						table.insert(kids, v.kid[i])
					end
					isFind = true
					findType = type
					break
				end
			end
			if isFind then
				break
			end
		end
		if isFind and findType == len - 1 and #kids < MILITARY_RANK_KINGDOMS_PER_CREW then
			local endKid = maxKid + MILITARY_RANK_KINGDOMS_PER_CREW - #kids - 1
			for kid = maxKid, endKid do
				if kingdomCtrl:isFoundKingdomID(kid) then
					table.insert(kids, kid)
				end
			end
		end
	end
	print("serviceFunctions.getServerGroupKingdomRange kids", mKid)
	dump(kids, "serviceFunctions.getServerGroupKingdomRange kids", 5)
	return kids
end
return militaryRankRead
