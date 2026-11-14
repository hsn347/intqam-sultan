local localSettingRead = include("aAReadClass").new()
localSettingRead.splitString = "@_configByUID_@"
_UPVALUE1_ = nil
;(nil)[1] = "localSettingConfig"
localSettingRead:defineValue("settingConfig", nil)
function localSettingRead.getItem(key)
	local byUID = SoraDStringsSplit(key, localSettingRead.splitString)
	local keyTbl = SoraDStringSplit(key, "~")
	local getFun = localSettingRead.getTypeFun(keyTbl[2], true)
	local defaultRead = function(mapName, defaultVal)
		local onOffVal = cc.UserDefault:getInstance():getBoolForKey(mapName .. "~isDefault")
		if onOffVal then
			return getFun(mapName)
		else
			return defaultVal
		end
	end
	if byUID and table.nums(byUID) > 1 then
		return defaultRead(key, defaultRead(byUID[2], clone(localSettingRead.settingConfig[byUID[2]])))
	else
		return defaultRead(key, clone(localSettingRead.settingConfig[key]))
	end
end
function localSettingRead.setItem(key, value)
	local keyTbl = SoraDStringSplit(key, "~")
	local setFun = localSettingRead.getTypeFun(keyTbl[2], false)
	cc.UserDefault:getInstance():setBoolForKey(key .. "~isDefault", true)
	setFun(key, value)
end
function localSettingRead.getTypeFun(type, getOrSet)
	local reFun
	if "float" == type then
		reFun = getOrSet and function(arg1)
			return cc.UserDefault:getInstance():getFloatForKey(arg1)
		end or function(arg1, arg2)
			return cc.UserDefault:getInstance():setFloatForKey(arg1, arg2)
		end
	elseif "bool" == type then
		reFun = getOrSet and function(arg1)
			return cc.UserDefault:getInstance():getBoolForKey(arg1)
		end or function(arg1, arg2)
			return cc.UserDefault:getInstance():setBoolForKey(arg1, arg2)
		end
	elseif "string" == type then
		reFun = getOrSet and function(arg1)
			return cc.UserDefault:getInstance():getStringForKey(arg1)
		end or function(arg1, arg2)
			return cc.UserDefault:getInstance():setStringForKey(arg1, arg2)
		end
	elseif "integer" == type then
		reFun = getOrSet and function(arg1)
			return cc.UserDefault:getInstance():getIntegerForKey(arg1)
		end or function(arg1, arg2)
			return cc.UserDefault:getInstance():setIntegerForKey(arg1, arg2)
		end
	elseif "table" == type then
		reFun = getOrSet and localSettingRead.getTable or localSettingRead.setTable
	end
	return reFun
end
function localSettingRead.setTable(key, value)
	local str = json.encode(value)
	if not str then
		_ENV = nil
		str = json.encode(nil)
	end
	cc.UserDefault:getInstance():setStringForKey(key, str)
end
function localSettingRead.getTable(key)
	local str = cc.UserDefault:getInstance():getStringForKey(key)
	local obj = json.decode(str)
	return obj
end
return localSettingRead
