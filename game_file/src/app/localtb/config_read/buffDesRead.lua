local buffDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	buffDesRead = nil
	;(nil)[1] = "buff_data"
	buffDesRead:defineValue("buff", nil)
	_ENV = nil
	;(nil)[1] = "new_player_buff"
	;(nil)[2] = true
	buffDesRead:defineValue("newPlayerBuff", nil)
	buffDesRead:defineValue("basic_attribute", function()
		local cfg = require_data("basic_attribute", false, true).data
		local _ENV, ret = "basic_attribute", "basic_attribute"
		for k, v in ipairs(cfg) do
			if not ret[v.type] then
				ret[v.type], _ENV = nil, nil
			end
			table.insert(ret[v.type], v)
		end
		return ret
	end)
	function buffDesRead()
		local cfg = require_data("basic_attribute", false, true).data
		local _ENV, ret = "basic_attribute", "basic_attribute"
		for k, v in ipairs(cfg) do
			if not ret[v.type] then
				ret[v.type], _ENV = nil, nil
			end
			table.insert(ret[v.type], v)
		end
		return ret
	end
	;(function()
		local cfg = require_data("basic_attribute", false, true).data
		local _ENV, ret = "basic_attribute", "basic_attribute"
		for k, v in ipairs(cfg) do
			if not ret[v.type] then
				ret[v.type], _ENV = nil, nil
			end
			table.insert(ret[v.type], v)
		end
		return ret
	end)[1] = "battletest"
	buffDesRead:defineValue("battletest", function()
		local cfg = require_data("basic_attribute", false, true).data
		local _ENV, ret = "basic_attribute", "basic_attribute"
		for k, v in ipairs(cfg) do
			if not ret[v.type] then
				ret[v.type], _ENV = nil, nil
			end
			table.insert(ret[v.type], v)
		end
		return ret
	end)
end
init()
function buffDesRead.getNewPlayerBuff()
	return buffDesRead.newPlayerBuff
end
function buffDesRead.getIfBattleBuff(eid)
	if buffDesRead.buff[eid] == nil then
		return false
	end
	return buffDesRead.buff[eid].ifBattleBuff == 1
end
function buffDesRead.getTitleBase(eid, needData, noArgs)
	eid = tonumber(eid)
	local oEid = eid
	if buffDesRead.buff[eid] == nil then
		eid = 1
	end
	local key = buffDesRead.buff[eid].title
	if oEid ~= eid and userSDKManager.isBeta() then
		oEid = oEid or "nil"
		key = "Miss-" .. oEid
	end
	local args
	noArgs = true
	if noArgs then
		args, _ENV = oEid, oEid
		args.num = ""
		for i = 1, 5 do
			args["num" .. i] = ""
		end
	end
	if needData then
		return i18n(key, args), buffDesRead.buff[eid]
	else
		return i18n(key, args)
	end
end
function buffDesRead.checkColon(titleBase)
	local str_en, str_zh = ":", "："
	_UPVALUE2_ = nil
	;(nil)[1] = str_en
	;(nil)[2] = str_zh
	for __, str in ipairs(nil) do
		local len = string.len(str)
		local subBegin = string.len(titleBase) - len + 1
		local subStr = string.sub(titleBase, subBegin, -1)
		if subStr == str then
			return titleBase
		end
	end
	return titleBase .. str_en
end
function buffDesRead.getTitleWithValue(eid, value, noSign)
	eid = tonumber(eid)
	local base, data = buffDesRead.getTitleBase(eid, true, true)
	if value ~= nil then
		if data.effectType == 1 then
			value = buffDesRead.addSign(value / 10, data.isIncrease, noSign) .. "%"
		elseif data.effectType == 2 then
			value = buffDesRead.addSign(value, data.isIncrease, noSign)
		elseif data.effectType == 5 then
			value = buffDesRead.addSign(value / 1000, data.isIncrease, noSign)
		else
			value = buffDesRead.addSign(value, data.isIncrease, noSign)
		end
	end
	if value == nil then
		_ENV = data.isIncrease
		data.isIncrease.title = base
		data.isIncrease.value = ""
		return i18n("common_text_3904", data.isIncrease)
	end
	_ENV = data.isIncrease
	data.isIncrease.title = base
	data.isIncrease.value = value
	return i18n("common_text_3904", data.isIncrease)
end
function buffDesRead.getBuffDes(eid, value, effectType, isNeedExtra)
	eid = tonumber(eid)
	local base, data = buffDesRead.getTitleBase(eid, true, true)
	if effectType == 1 then
		value = buffDesRead.addSign(value / 100, data.isIncrease) .. "%"
	elseif data.effectType == 5 then
		value = buffDesRead.addSign(value / 1000, data.isIncrease)
	else
		value = buffDesRead.addSign(value, data.isIncrease)
	end
	if isNeedExtra then
		_ENV = data.isIncrease
		data.isIncrease.title = base
		data.isIncrease.value = value or ""
		return i18n("common_text_3904", data.isIncrease), base, value
	else
		_ENV = value
		value.title = base
		value.value = value or ""
		return i18n("common_text_3904", value)
	end
end
function buffDesRead.getTitleValueWithValue(eid, value, noSign, reverse)
	eid = tonumber(eid)
	local base, data = buffDesRead.getTitleBase(eid, true)
	if data.effectType == 1 then
		if reverse then
			value = "%" .. buffDesRead.addSign(value / 10, data.isIncrease, noSign, reverse)
		else
			value = buffDesRead.addSign(value / 10, data.isIncrease, noSign, reverse) .. "%"
		end
	elseif data.effectType == 2 then
		value = buffDesRead.addSign(value, data.isIncrease, noSign, reverse)
	elseif data.effectType == 5 then
		value = buffDesRead.addSign(value / 1000, data.isIncrease, noSign, reverse)
	else
		value = buffDesRead.addSign(value, data.isIncrease, noSign, reverse)
	end
	return value
end
function buffDesRead.addSign(value, isIncrease, noSign, reverse)
	if not noSign then
		if isIncrease == 1 then
			if reverse then
				value = value .. "+"
			else
				value = "+" .. value
			end
		elseif isIncrease == 2 then
			if value < 0 then
				value = tostring(value)
			elseif reverse then
				value = value .. "-"
			else
				value = "-" .. value
			end
		else
			value = tostring(value)
		end
	else
		value = tostring(value)
	end
	return value
end
function buffDesRead.getBuffIcon(eid)
	eid = tonumber(eid)
	return buffDesRead.buff[eid].icon ~= "" and buffDesRead.buff[eid].icon or nil
end
function buffDesRead.isBuff(eid)
	eid = tonumber(eid)
	return buffDesRead.buff[eid] and true or false
end
function buffDesRead.isGoodBuff(eid)
	eid = tonumber(eid)
	local isIncrease = buffDesRead.buff[eid] and buffDesRead.buff[eid].isIncrease or 1
	return isIncrease ~= 2
end
function buffDesRead.isShowInHeroSelect(eid)
	eid = tonumber(eid)
	return buffDesRead.buff[eid] and buffDesRead.buff[eid].showChoose ~= 0 or false
end
function buffDesRead.getShowChoose(eid)
	eid = tonumber(eid)
	return buffDesRead.buff[eid] and buffDesRead.buff[eid].showChoose or 0
end
function buffDesRead.isShowInAdvanced(eid)
	eid = tonumber(eid)
	return buffDesRead.buff[eid] and buffDesRead.buff[eid].showAdvanced ~= 0 or false
end
function buffDesRead.getShowAdvanced(eid)
	eid = tonumber(eid)
	return buffDesRead.buff[eid] and buffDesRead.buff[eid].showAdvanced or 0
end
function buffDesRead.getEffectType(eid)
	eid = tonumber(eid)
	return buffDesRead.buff[eid] and buffDesRead.buff[eid].effectType or 1
end
function buffDesRead.getBasicAttrCfg()
	return buffDesRead.basic_attribute
end
function buffDesRead.getExtraAttrCfg()
	return buffDesRead.battletest
end
return buffDesRead
