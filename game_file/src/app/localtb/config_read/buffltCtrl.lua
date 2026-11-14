local ltBase = include("ltBase")
local buffltCtrl = class("buffltCtrl", ltBase, include("aAReadClass").new())
function buffltCtrl:ctor()
	buffltCtrl.super.ctor(self)
	self:init()
end
function buffltCtrl:init()
	local createData = function(name)
		local buff = require_once("app." .. LocalTblPath .. ".config_server.buff")
		local _ENV, bufflist = "app." .. LocalTblPath .. ".config_server.buff", "app." .. LocalTblPath .. ".config_server.buff"
		local _ENV, cityBuff = LocalTblPath, LocalTblPath
		local _ENV, dressBuff = ".config_server.buff", ".config_server.buff"
		local _ENV, buffTypelist
		for buffID, info in pairs(buff) do
			bufflist[buffID] = info
			local effectType = info.effectType
			if gBuffEffect.CASTLE_DRESS_UP == effectType or gBuffEffect.HIGH_CASTLE_DRESS_UP == effectType then
				local effect = info.effect
				local dressID = effect[2]
				if not dressBuff[dressID] then
					_ENV = dressBuff[dressID]
				end
				dressBuff[dressID] = dressBuff[dressID]
				table.insert(dressBuff[dressID], buffID)
			end
			if gBuffSource.CITY == info.origin then
				if not cityBuff[effectType] then
					_ENV = cityBuff[effectType]
				end
				cityBuff[effectType] = cityBuff[effectType]
				table.insert(cityBuff[effectType], buffID)
			end
			if not buffTypelist[effectType] then
				_ENV = buffTypelist[effectType]
			end
			buffTypelist[effectType] = buffTypelist[effectType]
			table.insert(buffTypelist[effectType], buffID)
		end
		self.bufflist = bufflist
		self.cityBuff = cityBuff
		self.dressBuff = dressBuff
		self.buffTypelist = buffTypelist
		if name == "bufflist" then
			return bufflist
		elseif name == "cityBuff" then
			return cityBuff
		elseif name == "dressBuff" then
			return dressBuff
		elseif name == "buffTypelist" then
			return buffTypelist
		end
	end
	buffltCtrl:defineValue("bufflist", createData)
	buffltCtrl:defineValue("cityBuff", createData)
	buffltCtrl:defineValue("dressBuff", createData)
	buffltCtrl:defineValue("buffTypelist", createData)
end
function buffltCtrl:isBuffID(id)
	if self.bufflist[id] then
		return true
	end
	return false
end
function buffltCtrl:getBuffType(id)
	return self:getProperty(self.bufflist, id, "buffType")
end
function buffltCtrl:getBuffSource(id)
	return self:getProperty(self.bufflist, id, "origin")
end
function buffltCtrl:canSuperpose(id)
	return self:getProperty(self.bufflist, id, "superposition")
end
function buffltCtrl:getEffectType(id)
	return self:getProperty(self.bufflist, id, "effectType")
end
function buffltCtrl:getEffect(id)
	local effect = self:getProperty(self.bufflist, id, "effect")
	if effect and 0 < #effect then
		return effect[2], effect[1]
	else
		return 0
	end
end
function buffltCtrl:getTime(id)
	return self:getProperty(self.bufflist, id, "time")
end
function buffltCtrl:getBuffID(effectType)
	if effectType then
		return self.buffTypelist[effectType]
	end
end
function buffltCtrl:getCityBuffID(effectType)
	if effectType then
		return self.cityBuff[effectType]
	end
end
function buffltCtrl:getBuffListOfDress()
	return self.dressBuff
end
return buffltCtrl
