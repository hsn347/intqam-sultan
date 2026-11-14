local _ENV, i18n
local locale, pluralizeFunction
local defaultLocale = "en_us"
local fallbackLocale = defaultLocale
local path = (...):gsub("%.init$", "")
local plural = require(path .. ".plural")
local interpolate = require(path .. ".interpolate")
local variants = require(path .. ".variants")
local version = require(path .. ".version")
local _ENV, originalData = path .. ".version", path .. ".version"
local _ENV, updateData = ".version", ".version"
i18n.plural, i18n.interpolate, i18n.variants, i18n.version, i18n._VERSION = plural, interpolate, variants, version, version
local dotSplit = function(str)
	_UPVALUE0_ = nil
	local fields, length = nil, 0
	str:gsub("[^%.]+", function(c)
		fields[length] = c
	end)
	return fields, length
end
local isPluralTable = function(t)
	return type(t) == "table" and type(t.other) == "string"
end
local isPresent = function(str)
	return type(str) == "string" and 0 < #str
end
local assertPresent = function(functionName, paramName, value)
	if isPresent(value) then
		return
	end
	local msg = "i18n.%s requires a non-empty string on its %s. Got %s (a %s value)."
	error(msg:format(functionName, paramName, tostring(value), type(value)))
end
local assertPresentOrPlural = function(functionName, paramName, value)
	if isPresent(value) or isPluralTable(value) then
		return
	end
	local msg = "i18n.%s requires a non-empty string or plural-form table on its %s. Got %s (a %s value)."
	error(msg:format(functionName, paramName, tostring(value), type(value)))
end
local assertPresentOrTable = function(functionName, paramName, value)
	if isPresent(value) or type(value) == "table" then
		return
	end
	local msg = "i18n.%s requires a non-empty string or table on its %s. Got %s (a %s value)."
	error(msg:format(functionName, paramName, tostring(value), type(value)))
end
local assertFunctionOrNil = function(functionName, paramName, value)
	if value == nil or type(value) == "function" then
		return
	end
	local msg = "i18n.%s requires a function (or nil) on param %s. Got %s (a %s value)."
	error(msg:format(functionName, paramName, tostring(value), type(value)))
end
local defaultPluralizeFunction = function(count)
	return plural.get(variants.root(i18n.getLocale()), count)
end
local pluralize = function(t, data)
	assertPresentOrPlural("interpolatePluralTable", "t", t)
	if not data then
		data, assertPresentOrPlural = assertPresentOrPlural, assertPresentOrPlural
	end
	local count = data.count or 1
	local plural_form = pluralizeFunction(count)
	return t[plural_form]
end
local treatNode = function(node, data, escapeFun)
	if type(node) == "string" then
		return interpolate(node, data, escapeFun)
	elseif isPluralTable(node) then
		return interpolate(pluralize(node, data), data, escapeFun)
	end
	return node
end
local function recursiveLoad(currentContext, data)
	local composedKey
	for k, v in pairs(data) do
		composedKey = (currentContext and currentContext .. "." or "") .. tostring(k)
		assertPresent("load", composedKey, k)
		assertPresentOrTable("load", composedKey, v)
		if type(v) == "string" then
			i18n.set(composedKey, v)
		else
			recursiveLoad(composedKey, v)
		end
	end
end
local customizeLocalizedTranslate = function(key, locale, data, escapeFun)
	local node = originalData[key]
	node = node or updateData[key]
	node = node or key
	return treatNode(node, data, escapeFun)
end
function i18n.setOriginalData(data)
	data = {}
end
function i18n.setUpdateData(data)
	if type(data) == "table" then
		data = {}
	end
end
function i18n.set(key, value)
	assertPresent("set", "key", key)
	assertPresentOrPlural("set", "value", value)
	local path, length = dotSplit(key)
	local node = originalData
	for i = 1, length - 1 do
		key = path[i]
		if not node[key] then
			assertPresent = node[key]
		end
		node[key] = node[key]
		node = node[key]
	end
	local lastKey = path[length]
	node[lastKey] = value
end
function i18n.judgeArgs(key, data, escapeFun)
	if type(key) == "table" then
		local _ENV, mixKey = type(key), type(key)
		mixKey = table.easymerge(mixKey, key, data)
		return i18n.translate(key[1], mixKey, escapeFun)
	else
		return i18n.translate(key, data, escapeFun)
	end
end
function i18n.translate(key, data, escapeFun)
	if key == "" then
		return key
	end
	key = key or " "
	assertPresent("translate", "key", key)
	if not data then
		data, assertPresent = assertPresent, assertPresent
	end
	local usedLocale = data.locale or locale
	local fallbacks = variants.fallbacks(usedLocale, fallbackLocale)
	for i = 1, #fallbacks do
		local value = customizeLocalizedTranslate(key, fallbacks[i], data, escapeFun)
		if value then
			return value
		end
	end
	if data.default == nil then
		data.default = key
	end
	return data.default
end
function i18n.setLocale(newLocale, newPluralizeFunction)
	assertPresent("setLocale", "newLocale", newLocale)
	assertFunctionOrNil("setLocale", "newPluralizeFunction", newPluralizeFunction)
	newLocale = {}
end
function i18n.setFallbackLocale(newFallbackLocale)
	assertPresent("setFallbackLocale", "newFallbackLocale", newFallbackLocale)
	newFallbackLocale = {}
end
function i18n.getFallbackLocale()
	return fallbackLocale
end
function i18n.getLocale()
	return locale
end
function i18n.reset()
	originalData = nil
	originalData = {}
	plural.reset()
	i18n.setLocale(defaultLocale)
	i18n.setFallbackLocale(defaultLocale)
end
function i18n.load(data)
	recursiveLoad(nil, data)
end
function i18n.loadFile(path)
	local chunk = assert(loadfile(path))
	local data = chunk()
	i18n.load(data)
end
_ENV = nil
;(nil).__call = function(_, ...)
	return i18n.judgeArgs(...)
end
setmetatable(i18n, nil)
i18n.reset()
return i18n
