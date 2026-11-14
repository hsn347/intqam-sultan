local foreignPavilionRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "exotic_pavilion_intimacy"
	;(nil)[2] = true
	foreignPavilionRead:defineValue("intimacy", nil)
	foreignPavilionRead = nil
	;(nil)[1] = "exotic_pavilion_intimacy_config"
	foreignPavilionRead:defineValue("intimacyConfig", nil)
	_ENV = nil
	;(nil)[1] = "exotic_pavilion_integral"
	;(nil)[2] = true
	foreignPavilionRead:defineValue("integral", nil)
	foreignPavilionRead:defineValue("gift", function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)
	function foreignPavilionRead()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end
	;(function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)[1] = "exotic_pavilion_linkgame"
	foreignPavilionRead:defineValue("linkgame", function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)
	function foreignPavilionRead()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end
	;(function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)[1] = "exotic_pavilion_roadrough"
	foreignPavilionRead:defineValue("roadrough", function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)
	function foreignPavilionRead()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end
	;(function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)[1] = "exotic_pavilion_map_config"
	foreignPavilionRead:defineValue("mapConfig", function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)
	function foreignPavilionRead()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end
	;(function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)[1] = "exotic_pavilion_talk"
	foreignPavilionRead:defineValue("talk", function()
		foreignPavilionRead.gift, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.integral) do
			if value.type == 2 then
				table.insert(foreignPavilionRead.gift, value)
			end
		end
		return foreignPavilionRead.gift
	end)
	foreignPavilionRead:defineValue("talkMap", function()
		foreignPavilionRead.talkMap, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.talk) do
			local type1 = value.type
			if not foreignPavilionRead.talkMap[type1] then
				foreignPavilionRead.talkMap[type1], foreignPavilionRead = nil, nil
			end
			local type2 = value.intimacy
			if not foreignPavilionRead.talkMap[type1][type2] then
				foreignPavilionRead.talkMap[type1][type2], foreignPavilionRead = nil, nil
			end
			table.insert(foreignPavilionRead.talkMap[type1][type2], value)
		end
		return foreignPavilionRead.talkMap
	end)
	foreignPavilionRead:defineValue("pointTalkMap", function()
		foreignPavilionRead.pointTalkMap, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.talk) do
			if value.type == 5 then
				local type2 = value.intimacy
				if not foreignPavilionRead.pointTalkMap[type2] then
					foreignPavilionRead.pointTalkMap[type2], foreignPavilionRead = nil, nil
				end
				local pointType = value.probability
				if not foreignPavilionRead.pointTalkMap[type2][pointType] then
					foreignPavilionRead.pointTalkMap[type2][pointType], foreignPavilionRead = nil, nil
				end
				table.insert(foreignPavilionRead.pointTalkMap[type2][pointType], value)
			end
		end
		return foreignPavilionRead.pointTalkMap
	end)
	function foreignPavilionRead()
		foreignPavilionRead.pointTalkMap, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.talk) do
			if value.type == 5 then
				local type2 = value.intimacy
				if not foreignPavilionRead.pointTalkMap[type2] then
					foreignPavilionRead.pointTalkMap[type2], foreignPavilionRead = nil, nil
				end
				local pointType = value.probability
				if not foreignPavilionRead.pointTalkMap[type2][pointType] then
					foreignPavilionRead.pointTalkMap[type2][pointType], foreignPavilionRead = nil, nil
				end
				table.insert(foreignPavilionRead.pointTalkMap[type2][pointType], value)
			end
		end
		return foreignPavilionRead.pointTalkMap
	end
	;(function()
		foreignPavilionRead.pointTalkMap, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.talk) do
			if value.type == 5 then
				local type2 = value.intimacy
				if not foreignPavilionRead.pointTalkMap[type2] then
					foreignPavilionRead.pointTalkMap[type2], foreignPavilionRead = nil, nil
				end
				local pointType = value.probability
				if not foreignPavilionRead.pointTalkMap[type2][pointType] then
					foreignPavilionRead.pointTalkMap[type2][pointType], foreignPavilionRead = nil, nil
				end
				table.insert(foreignPavilionRead.pointTalkMap[type2][pointType], value)
			end
		end
		return foreignPavilionRead.pointTalkMap
	end)[1] = "exotic_pavilion_dialogue"
	foreignPavilionRead:defineValue("dialogue", function()
		foreignPavilionRead.pointTalkMap, foreignPavilionRead = nil, nil
		for index, value in pairs(foreignPavilionRead.talk) do
			if value.type == 5 then
				local type2 = value.intimacy
				if not foreignPavilionRead.pointTalkMap[type2] then
					foreignPavilionRead.pointTalkMap[type2], foreignPavilionRead = nil, nil
				end
				local pointType = value.probability
				if not foreignPavilionRead.pointTalkMap[type2][pointType] then
					foreignPavilionRead.pointTalkMap[type2][pointType], foreignPavilionRead = nil, nil
				end
				table.insert(foreignPavilionRead.pointTalkMap[type2][pointType], value)
			end
		end
		return foreignPavilionRead.pointTalkMap
	end)
	foreignPavilionRead:defineValue("dialogueMap", function()
		local _ENV, dialogueMap
		for index, value in pairs(foreignPavilionRead.dialogue) do
			if not dialogueMap[value.stage] then
				dialogueMap[value.stage], _ENV = nil, nil
			end
			table.insert(dialogueMap[value.stage], value)
		end
		for key, value in pairs(dialogueMap) do
			table.sort(value, function(a, b)
				return a.index < b.index
			end)
		end
		foreignPavilionRead.dialogueMap = dialogueMap
		return dialogueMap
	end)
	foreignPavilionRead:defineValue("buffList", function()
		local _ENV, buffList
		for index, value in ipairs(foreignPavilionRead.intimacy) do
			if not buffList[value.intimacy] then
				buffList[value.intimacy], _ENV = nil, nil
			end
			local tmpBuff = buffList[value.intimacy]
			for idx = 1, #value.buff / 2 do
				print(idx, #value.buff, "#value.buff")
				tmpBuff[value.buff[idx * 2 - 1]] = value.buff[idx * 2]
			end
		end
		foreignPavilionRead.buffList = buffList
		return foreignPavilionRead.buffList
	end)
end
init()
function foreignPavilionRead.getLinkgame()
	local _ENV, array
	for k, v in ipairs(foreignPavilionRead.linkgame) do
		table.insert(array, v.heroID)
	end
	return array
end
function foreignPavilionRead.getRoadrough(map, x, y)
	local _ENV, info
	for k, v in ipairs(foreignPavilionRead.roadrough) do
		if tonumber(v.map) == map and v.land[1] == x and v.land[2] == y then
			info.npcType = v.npc[1]
			info.npcBlood = v.npc[2]
			info.npcModel = v.npcModel
		end
	end
	return info
end
function foreignPavilionRead.getNpcModelCfg(npcModel)
	_ENV, _ENV = nil, nil
	;(nil).scale = 1
	_ENV, (nil).dl, (nil).offset = nil, nil, cc.p(0, -65)
	;(nil).scale = 0.9
	_ENV, (nil).bjlsk, (nil).offset = nil, nil, cc.p(0, -75)
	;(nil).scale = 0.85
	_ENV, (nil).xyzs, (nil).offset = nil, nil, cc.p(0, -80)
	;(nil).scale = 1.2
	;(nil).hero, (nil).offset = nil, cc.p(-10, -90)
	local cfg
	return cfg[npcModel]
end
function foreignPavilionRead.getMapConfig(map)
	local _ENV, targetInfo
	for k, v in ipairs(foreignPavilionRead.mapConfig) do
		if v.map == map then
			table.insert(targetInfo, v)
		end
	end
	return targetInfo
end
function foreignPavilionRead:getDialogues(step)
	return foreignPavilionRead.dialogueMap[step]
end
function foreignPavilionRead:getCurIntimacyCfg(intimacy)
	for index, value in ipairs(self.intimacyConfig) do
		if value.intimacy == intimacy then
			return value
		end
	end
end
function foreignPavilionRead:getIntimacyCfgs()
	return self.intimacyConfig
end
function foreignPavilionRead:getTalk(type1, type2)
	return foreignPavilionRead.talkMap[type1][type2]
end
function foreignPavilionRead:getPointTalk(type2, isPoint)
	local isPointInt = isPoint and 1 or 2
	return foreignPavilionRead.pointTalkMap[type2][isPointInt]
end
function foreignPavilionRead:getGiftCfgs()
	return foreignPavilionRead.gift
end
function foreignPavilionRead:getMaxIntimacyLv()
	local maxLv = 1
	for index, value in ipairs(self.intimacyConfig) do
		if maxLv < value.intimacy then
			maxLv = value.intimacy
		end
	end
	return maxLv
end
function foreignPavilionRead:getIntimacyValue(type, rule)
	for key, value in pairs(self.integral) do
		if value.type == type and value.rule == rule then
			return value
		end
	end
	return nil
end
_ENV, foreignPavilionRead.getAllBuff = function(self, intimacyLv)
	return foreignPavilionRead.buffList[intimacyLv]
end, function(self, intimacyLv)
	return foreignPavilionRead.buffList[intimacyLv]
end
;(function(self, intimacyLv)
	return foreignPavilionRead.buffList[intimacyLv]
end).ROADROUGH = 1
;(function(self, intimacyLv)
	return foreignPavilionRead.buffList[intimacyLv]
end).LINKGAME = 2
;(function(self, intimacyLv)
	return foreignPavilionRead.buffList[intimacyLv]
end).SHOOTGAME = 3
local (function(self, intimacyLv)
	return foreignPavilionRead.buffList[intimacyLv]
end).TOWERDEFEND, gameTypes = 4, function(self, intimacyLv)
	return foreignPavilionRead.buffList[intimacyLv]
end
foreignPavilionRead.gameTypes = gameTypes
return foreignPavilionRead
