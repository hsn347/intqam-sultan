local unpack = unpack or table.unpack
local bracketDummy = "@@@@@@@@@{@@@@@@@@@"
local ltDummy = "@@@@@@@@@<@@@@@@@@@"
local interpolateVariables = function(str, vars)
	return str:gsub("%%{%s*(.-)%s*}", function(key)
		return tostring(vars[key])
	end)
end
local interpolateFormattedVariables = function(str, vars)
	return str:gsub("%%<%s*(.-)%s*>%.([cdEefgGiouXxsq])", function(key, formatChar)
		return string.format("%" .. formatChar, vars[key] or "nil")
	end)
end
local escapeDoublePercent = function(str)
	return str:gsub("%%%%{", bracketDummy):gsub("%%%%<", ltDummy)
end
local unescapeDoublePercent = function(str)
	return str:gsub(ltDummy, "%%<"):gsub(bracketDummy, "%%{")
end
local interpolate = function(str, vars, escapeFun)
	if not vars then
		vars, escapeDoublePercent = nil, nil
	end
	if escapeFun then
		str = escapeFun(str)
	end
	str = escapeDoublePercent(str)
	str = interpolateVariables(str, vars)
	str = interpolateFormattedVariables(str, vars)
	str = unescapeDoublePercent(str)
	return str
end
return interpolate
