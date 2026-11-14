local ltBase = include("ltBase")
local snowWolfltCtrl = class("snowWolfltCtrl", ltBase, include("aAReadClass").new())
local isInited = false
local init = function()
	if isInited then
		return
	end
	snowWolfltCtrl:init()
end
function snowWolfltCtrl:ctor()
	snowWolfltCtrl.super.ctor(self)
end
function snowWolfltCtrl:init()
	snowWolfltCtrl:defineValue("featheraward", function()
		self.featheraward, self = nil, nil
		local battle_feather_award = require_once("app." .. LocalTblPath .. ".config_server.snowwolf_feather_award")
		for k, v in pairs(battle_feather_award) do
			local classType = v.classType or 1
			if not self.featheraward[classType] then
				self.featheraward[classType], self = nil, nil
			end
			if not self.featheraward[classType][v.battletype] then
				self.featheraward[classType][v.battletype], self = nil, nil
			end
			table.insert(self.featheraward[classType][v.battletype], v)
		end
		return self.featheraward
	end)
	local createData = function(name)
		local battle_atk_award = require_once("app." .. LocalTblPath .. ".config_server.snowwolf_attack_award")
		self.monsterReward, _ENV, self.attackaward, _ENV = "app." .. LocalTblPath .. ".config_server.snowwolf_attack_award", "app." .. LocalTblPath .. ".config_server.snowwolf_attack_award", "app." .. LocalTblPath .. ".config_server.snowwolf_attack_award", "app." .. LocalTblPath .. ".config_server.snowwolf_attack_award"
		local _ENV, activityTypes = "app." .. LocalTblPath .. ".config_server.snowwolf_attack_award", "app." .. LocalTblPath .. ".config_server.snowwolf_attack_award"
		local _ENV, superReward = LocalTblPath, LocalTblPath
		local _ENV, goldReward = ".config_server.snowwolf_attack_award", ".config_server.snowwolf_attack_award"
		local _ENV, normalReward
		for k, v in pairs(battle_atk_award) do
			local classType = v.classType or 1
			if not activityTypes[classType] then
				_ENV = activityTypes[classType]
			end
			activityTypes[classType] = activityTypes[classType]
			if not superReward[classType] then
				_ENV = superReward[classType]
			end
			superReward[classType] = superReward[classType]
			if not superReward[classType][v.activityType] then
				_ENV = superReward[classType][v.activityType]
			end
			superReward[classType][v.activityType] = superReward[classType][v.activityType]
			if not goldReward[classType] then
				_ENV = goldReward[classType]
			end
			goldReward[classType] = goldReward[classType]
			if not goldReward[classType][v.activityType] then
				_ENV = goldReward[classType][v.activityType]
			end
			goldReward[classType][v.activityType] = goldReward[classType][v.activityType]
			if not normalReward[classType] then
				_ENV = normalReward[classType]
			end
			normalReward[classType] = normalReward[classType]
			if not normalReward[classType][v.activityType] then
				_ENV = normalReward[classType][v.activityType]
			end
			normalReward[classType][v.activityType] = normalReward[classType][v.activityType]
			if next(v.reward) then
				if v.reward[1] == gIDDef.GOLD then
					table.insert(goldReward[classType][v.activityType], v)
				else
					table.insert(normalReward[classType][v.activityType], v)
				end
			elseif next(v.superReward) then
				table.insert(superReward[classType][v.activityType], v)
			end
			activityTypes[classType][v.activityType] = v.activityType
		end
		for k, w in pairs(activityTypes) do
			if not self.monsterReward[k] then
				_ENV = self.monsterReward[k]
			end
			self.monsterReward[k] = self.monsterReward[k]
			if not self.attackaward[k] then
				_ENV = self.attackaward[k]
			end
			self.attackaward[k] = self.attackaward[k]
			for _, v in pairs(w) do
				if not self.monsterReward[k][v] then
					self.monsterReward[k][v], _ENV = nil, nil
				end
				table.sort(goldReward[k][v], function(a, b)
					return a.reward[2] > b.reward[2]
				end)
				local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
				table.sort(normalReward[k][v], function(a, b)
					local qualitya = backpackltCtrl:getItemQuality(a.reward[1]) or 0
					local qualityb = backpackltCtrl:getItemQuality(b.reward[1]) or 0
					return qualitya > qualityb
				end)
				table.sort(self.featheraward[k][v], function(a, b)
					return backpackltCtrl:getItemQuality(a.feather[1]) > backpackltCtrl:getItemQuality(b.feather[1])
				end)
				for index, value in ipairs(superReward[k][v]) do
					if not self.attackaward[k][v] then
						_ENV = self.attackaward[k][v]
					end
					self.attackaward[k][v] = self.attackaward[k][v]
					table.insert(self.attackaward[k][v], value)
					_ENV = value
					value.id = value.superReward[1]
					value.num = value.superReward[2]
					value.serverLv = value.serverLv
					table.insert(self.monsterReward[k][v], value)
				end
				for index, value in ipairs(self.featheraward[k][v]) do
					_ENV = value
					value.id = value.feather[1]
					value.num = value.feather[2]
					value.serverLv = value.serverLv
					table.insert(self.monsterReward[k][v], value)
				end
				for index, value in ipairs(goldReward[k][v]) do
					if not self.attackaward[k][v] then
						_ENV = self.attackaward[k][v]
					end
					self.attackaward[k][v] = self.attackaward[k][v]
					table.insert(self.attackaward[k][v], value)
					_ENV = value
					value.id = value.reward[1]
					value.num = value.reward[2]
					value.serverLv = value.serverLv
					table.insert(self.monsterReward[k][v], value)
				end
				for index, value in ipairs(normalReward[k][v]) do
					if not self.attackaward[k][v] then
						_ENV = self.attackaward[k][v]
					end
					self.attackaward[k][v] = self.attackaward[k][v]
					table.insert(self.attackaward[k][v], value)
					_ENV = value
					value.id = value.reward[1]
					value.num = value.reward[2]
					value.serverLv = value.serverLv
					table.insert(self.monsterReward[k][v], value)
				end
			end
		end
		if name == "attackaward" then
			return self.attackaward
		elseif name == "monsterReward" then
			return self.monsterReward
		end
	end
	snowWolfltCtrl:defineValue("attackaward", createData)
	snowWolfltCtrl:defineValue("monsterReward", createData)
	_UPVALUE2_ = createData
	createData[1] = "snowwolf_feathershop"
	createData[2] = true
	self:defineValue("snowwolf_feathershop", createData)
	snowWolfltCtrl:defineValue("mp_feathershop", function()
		return snowWolfltCtrl.getClassTypeConfig(snowWolfltCtrl.snowwolf_feathershop)
	end)
end
init()
function snowWolfltCtrl:getAttackAward(battletype, classType)
	classType = classType or 1
	local battletype = tonumber(battletype)
	return self.attackaward[classType][battletype]
end
function snowWolfltCtrl:getFeatherAward(battletype, classType)
	classType = classType or 1
	local battletype = tonumber(battletype)
	return self.featheraward[classType][battletype]
end
function snowWolfltCtrl:getMonsterAward(battletype, classType, lv)
	classType = classType or 1
	lv = lv or 1
	local battletype = tonumber(battletype)
	local _ENV, tb = battletype, battletype
	for index, value in ipairs(self.monsterReward[classType][battletype]) do
		local min = value.serverLv[1]
		local max = value.serverLv[2]
		if lv >= min and lv <= max then
			table.insert(tb, value)
		end
	end
	return tb
end
function snowWolfltCtrl:get_feahtershop(lv)
	if lv then
		return self:get_feahtershopByZeroLv(lv)
	else
		return self.mp_feathershop[SoraDGetActivityClassType(gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY)]
	end
end
function snowWolfltCtrl:get_feahtershopByZeroLv(lv)
	local _ENV, tb
	local shopCfg = self.mp_feathershop[SoraDGetActivityClassType(gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY)]
	for index, value in ipairs(shopCfg) do
		local min = value.serverLv[1]
		local max = value.serverLv[2]
		if lv >= min and lv <= max then
			table.insert(tb, value)
		end
	end
	return tb
end
return snowWolfltCtrl
