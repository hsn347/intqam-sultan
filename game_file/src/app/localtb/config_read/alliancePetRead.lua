local buffDesRead = include("buffDesRead")
local alliancePetRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "alliance_beast_data"
	;(nil)[2] = true
	alliancePetRead:defineValue("alliance_beast_data", nil)
	alliancePetRead:defineValue("petDataConfig", function()
		local _ENV, petDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_data) do
			if not petDataConfig[v.PetType] then
				petDataConfig[v.PetType], _ENV = nil, nil
			end
			petDataConfig[v.PetType][v.Level] = v
		end
		return petDataConfig
	end)
	function _ENV()
		local _ENV, petDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_data) do
			if not petDataConfig[v.PetType] then
				petDataConfig[v.PetType], _ENV = nil, nil
			end
			petDataConfig[v.PetType][v.Level] = v
		end
		return petDataConfig
	end
	;(function()
		local _ENV, petDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_data) do
			if not petDataConfig[v.PetType] then
				petDataConfig[v.PetType], _ENV = nil, nil
			end
			petDataConfig[v.PetType][v.Level] = v
		end
		return petDataConfig
	end)[1] = "alliance_beast_contribute"
	;(function()
		local _ENV, petDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_data) do
			if not petDataConfig[v.PetType] then
				petDataConfig[v.PetType], _ENV = nil, nil
			end
			petDataConfig[v.PetType][v.Level] = v
		end
		return petDataConfig
	end)[2] = true
	alliancePetRead:defineValue("alliance_beast_contribute", function()
		local _ENV, petDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_data) do
			if not petDataConfig[v.PetType] then
				petDataConfig[v.PetType], _ENV = nil, nil
			end
			petDataConfig[v.PetType][v.Level] = v
		end
		return petDataConfig
	end)
	alliancePetRead:defineValue("petDonateDataConfig", function()
		local _ENV, petDonateDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_contribute) do
			petDonateDataConfig[v.PetType] = v
		end
		return petDonateDataConfig
	end)
	function _ENV()
		local _ENV, petDonateDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_contribute) do
			petDonateDataConfig[v.PetType] = v
		end
		return petDonateDataConfig
	end
	;(function()
		local _ENV, petDonateDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_contribute) do
			petDonateDataConfig[v.PetType] = v
		end
		return petDonateDataConfig
	end)[1] = "alliance_beast_reward"
	;(function()
		local _ENV, petDonateDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_contribute) do
			petDonateDataConfig[v.PetType] = v
		end
		return petDonateDataConfig
	end)[2] = true
	alliancePetRead:defineValue("alliance_beast_reward", function()
		local _ENV, petDonateDataConfig
		for k, v in pairs(alliancePetRead.alliance_beast_contribute) do
			petDonateDataConfig[v.PetType] = v
		end
		return petDonateDataConfig
	end)
	alliancePetRead:defineValue("rewardsConfig", function()
		local _ENV, rewardsConfig
		for k, v in pairs(alliancePetRead.alliance_beast_reward) do
			if not rewardsConfig[v.PetType] then
				rewardsConfig[v.PetType], _ENV = nil, nil
			end
			rewardsConfig[v.PetType][v.TrailLevel] = v
		end
		return rewardsConfig
	end)
	function _ENV()
		local _ENV, rewardsConfig
		for k, v in pairs(alliancePetRead.alliance_beast_reward) do
			if not rewardsConfig[v.PetType] then
				rewardsConfig[v.PetType], _ENV = nil, nil
			end
			rewardsConfig[v.PetType][v.TrailLevel] = v
		end
		return rewardsConfig
	end
	;(function()
		local _ENV, rewardsConfig
		for k, v in pairs(alliancePetRead.alliance_beast_reward) do
			if not rewardsConfig[v.PetType] then
				rewardsConfig[v.PetType], _ENV = nil, nil
			end
			rewardsConfig[v.PetType][v.TrailLevel] = v
		end
		return rewardsConfig
	end)[1] = "alliance_beast_call"
	;(function()
		local _ENV, rewardsConfig
		for k, v in pairs(alliancePetRead.alliance_beast_reward) do
			if not rewardsConfig[v.PetType] then
				rewardsConfig[v.PetType], _ENV = nil, nil
			end
			rewardsConfig[v.PetType][v.TrailLevel] = v
		end
		return rewardsConfig
	end)[2] = true
	alliancePetRead:defineValue("alliance_beast_call", function()
		local _ENV, rewardsConfig
		for k, v in pairs(alliancePetRead.alliance_beast_reward) do
			if not rewardsConfig[v.PetType] then
				rewardsConfig[v.PetType], _ENV = nil, nil
			end
			rewardsConfig[v.PetType][v.TrailLevel] = v
		end
		return rewardsConfig
	end)
	alliancePetRead:defineValue("petCallCondConfig", function()
		local _ENV, petCallCondConfig
		for k, v in pairs(alliancePetRead.alliance_beast_call) do
			petCallCondConfig[v.PetType] = v
		end
		return petCallCondConfig
	end)
	function alliancePetRead()
		local _ENV, petCallCondConfig
		for k, v in pairs(alliancePetRead.alliance_beast_call) do
			petCallCondConfig[v.PetType] = v
		end
		return petCallCondConfig
	end
	;(function()
		local _ENV, petCallCondConfig
		for k, v in pairs(alliancePetRead.alliance_beast_call) do
			petCallCondConfig[v.PetType] = v
		end
		return petCallCondConfig
	end)[1] = "alliance_beast_describe"
	alliancePetRead:defineValue("alliance_beast_describe", function()
		local _ENV, petCallCondConfig
		for k, v in pairs(alliancePetRead.alliance_beast_call) do
			petCallCondConfig[v.PetType] = v
		end
		return petCallCondConfig
	end)
	alliancePetRead:defineValue("baseInfoConfig", function()
		local _ENV, baseInfoConfig
		for i, v in ipairs(alliancePetRead.alliance_beast_describe) do
			baseInfoConfig[v.PetType] = v
		end
		return baseInfoConfig
	end)
	function alliancePetRead()
		local _ENV, baseInfoConfig
		for i, v in ipairs(alliancePetRead.alliance_beast_describe) do
			baseInfoConfig[v.PetType] = v
		end
		return baseInfoConfig
	end
	;(function()
		local _ENV, baseInfoConfig
		for i, v in ipairs(alliancePetRead.alliance_beast_describe) do
			baseInfoConfig[v.PetType] = v
		end
		return baseInfoConfig
	end)[1] = "alliance_beast_modelconfig"
	alliancePetRead:defineValue("alliance_beast_modelconfig", function()
		local _ENV, baseInfoConfig
		for i, v in ipairs(alliancePetRead.alliance_beast_describe) do
			baseInfoConfig[v.PetType] = v
		end
		return baseInfoConfig
	end)
	alliancePetRead:defineValue("pet3DModelConfig", function()
		local _ENV, pet3DModelConfig
		for k, v in pairs(alliancePetRead.alliance_beast_modelconfig) do
			if not pet3DModelConfig[v.PetType] then
				pet3DModelConfig[v.PetType], _ENV = nil, nil
			end
			pet3DModelConfig[v.PetType][v.Level] = v
		end
		return pet3DModelConfig
	end)
end
init()
_ENV, _ENV = nil, init
;(nil).scale = 0.85
_ENV, init[1], (nil).position = nil, nil, cc.p(-10, 20)
;(nil).scale = 0.75
_ENV, init[2], (nil).position = nil, nil, cc.p(-10, 20)
;(nil).scale = 1.0
_ENV, init[3], (nil).position = nil, nil, cc.p(0, 20)
;(nil).scale = 0.95
_ENV, init[4], (nil).position = nil, nil, cc.p(-10, 20)
;(nil).scale = 1.0
_ENV, init[5], (nil).position = nil, nil, cc.p(-10, 20)
;(nil).scale = 0.9
_ENV, init[6], (nil).position = nil, nil, cc.p(-10, 20)
;(nil).scale = 0.8
_ENV, init[7], (nil).position = nil, nil, cc.p(-10, 20)
;(nil).scale = 0.7
_ENV, init[8], (nil).position = nil, nil, cc.p(-10, 20)
;(nil).scale = 1.0
alliancePetRead.worldMapPetOffset, init[9], (nil).position = init, nil, cc.p(-10, 20)
function alliancePetRead.getPetInfoList()
	local _ENV, list
	for i, v in ipairs(alliancePetRead.alliance_beast_describe) do
		table.insert(list, v)
	end
	return list
end
function alliancePetRead.getBaseInfo(petType)
	if not alliancePetRead.baseInfoConfig[petType] then
		alliancePetRead = alliancePetRead.baseInfoConfig[petType]
	end
	return alliancePetRead.baseInfoConfig[petType]
end
function alliancePetRead.getName(petType)
	return i18n(alliancePetRead.getBaseInfo(petType).PetName or "???")
end
function alliancePetRead.getIcon(petType, fromMemory)
	local fileName = alliancePetRead.getBaseInfo(petType).Icon or "icon_item_common.png"
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function alliancePetRead.getPicture(petType, fromMemory)
	local fileName = alliancePetRead.getBaseInfo(petType).Picture or "icon_item_common.png"
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function alliancePetRead.getWorldMapModel(petType)
	return i18n(alliancePetRead.getBaseInfo(petType).WorldMapModel or "ma")
end
function alliancePetRead.getMaxLevel(petType)
	local maxLv = 1
	if alliancePetRead.petDataConfig[petType] then
		for k, v in pairs(alliancePetRead.petDataConfig[petType]) do
			if maxLv < v.Level then
				maxLv = v.Level
			end
		end
	end
	return maxLv
end
function alliancePetRead.getMaxSword(petType)
	local maxLv = alliancePetRead.getMaxLevel(petType)
	return alliancePetRead.getSword(petType, maxLv)
end
function alliancePetRead.getSword(petType, lv)
	if alliancePetRead.petDataConfig[petType] and alliancePetRead.petDataConfig[petType][lv] then
		return alliancePetRead.petDataConfig[petType][lv].Sword
	end
	return 0
end
function alliancePetRead.getNeedPoint(petType, lv)
	if alliancePetRead.petDataConfig[petType] and alliancePetRead.petDataConfig[petType][lv] then
		return alliancePetRead.petDataConfig[petType][lv].NeedPoint
	end
	return 0
end
function alliancePetRead.getStamina(petType, lv)
	if alliancePetRead.petDataConfig[petType] and alliancePetRead.petDataConfig[petType][lv] then
		return alliancePetRead.petDataConfig[petType][lv].Stamina
	end
	return 0
end
function alliancePetRead.getTroops(petType, lv)
	if alliancePetRead.petDataConfig[petType] and alliancePetRead.petDataConfig[petType][lv] then
		return alliancePetRead.petDataConfig[petType][lv].Troops
	end
	alliancePetRead = alliancePetRead.petDataConfig[petType][lv].Troops
	return alliancePetRead.petDataConfig[petType][lv].Troops
end
function alliancePetRead.getWishDesByType(petType, lv)
	local effectType, value = alliancePetRead.getWishEffectAndVale(petType, lv)
	if effectType and value then
		return buffDesRead.getTitleWithValue(effectType, value)
	else
		return "???"
	end
end
function alliancePetRead.getWishEffectAndVale(petType, lv)
	local effect = alliancePetRead.getWishEffect(petType, lv)
	if "table" == type(effect) and table.nums(effect) == 3 then
		return effect[1], effect[3]
	end
end
function alliancePetRead.getWishEffect(petType, lv)
	if alliancePetRead.rewardsConfig[petType] and alliancePetRead.rewardsConfig[petType][lv] then
		return alliancePetRead.rewardsConfig[petType][lv].Effect
	end
	alliancePetRead = alliancePetRead.rewardsConfig[petType][lv].Effect
	return alliancePetRead.rewardsConfig[petType][lv].Effect
end
function alliancePetRead.getMaxTrailLevel(petType)
	local maxLv = 1
	if alliancePetRead.rewardsConfig[petType] then
		for k, v in pairs(alliancePetRead.rewardsConfig[petType]) do
			if maxLv < v.TrailLevel then
				maxLv = v.TrailLevel
			end
		end
	end
	return maxLv
end
function alliancePetRead.getMinTrailLevel(petType)
	local minLv = 99
	if alliancePetRead.rewardsConfig[petType] then
		for k, v in pairs(alliancePetRead.rewardsConfig[petType]) do
			if minLv > v.TrailLevel then
				minLv = v.TrailLevel
			end
		end
	end
	return minLv
end
function alliancePetRead.getRewards(petType, lv)
	if alliancePetRead.rewardsConfig[petType] and alliancePetRead.rewardsConfig[petType][lv] then
		return alliancePetRead.rewardsConfig[petType][lv].kill_rewards
	end
	alliancePetRead = alliancePetRead.rewardsConfig[petType][lv].kill_rewards
	return alliancePetRead.rewardsConfig[petType][lv].kill_rewards
end
function alliancePetRead.getCallFreeCond(petType)
	if alliancePetRead.petCallCondConfig[petType] then
		return alliancePetRead.petCallCondConfig[petType].Free
	end
	return 0
end
function alliancePetRead.getCallGoldCond(petType)
	if alliancePetRead.petCallCondConfig[petType] then
		return alliancePetRead.petCallCondConfig[petType].Gold
	end
	return 0
end
function alliancePetRead.getDonateDataByKey(petType, key)
	if alliancePetRead.petDonateDataConfig[petType] then
		return alliancePetRead.petDonateDataConfig[petType][key] or 0
	end
	return 0
end
function alliancePetRead.getPetSinglePidAndRank(petType, lv)
	local model = alliancePetRead.getPet3DModelConfig(petType, lv)
	if model then
		return model[1], model[2]
	end
end
function alliancePetRead.getPet3DModelConfig(petType, lv)
	if alliancePetRead.pet3DModelConfig[petType] and alliancePetRead.pet3DModelConfig[petType][lv] then
		return alliancePetRead.pet3DModelConfig[petType][lv].Model
	end
	return nil
end
function alliancePetRead.checkScienceTotalLv(needlv, showTip, msg)
	needlv = needlv or 0
	local totalLv = alliancePetRead.getCurScienceTotalLv()
	local ret = needlv <= totalLv
	if showTip and not ret then
		SoraDShowMsgTip(msg or i18n("alliance_beast_notice_03"))
	end
	return ret
end
function alliancePetRead.getCurScienceTotalLv()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	return allianceScience:getCurSciTotalLv()
end
return alliancePetRead
