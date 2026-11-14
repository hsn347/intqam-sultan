propParser, _ENV = nil, nil
propParser.propTypeFuncMap, _ENV = nil, nil
propParser.propCustomFuncMap, _ENV = nil, nil
local vdf_numbert = function(value)
	return string.formatnumberthousands(value)
end
local vdf_numberu = function(value)
	return SoraDConvertNumberWithUnit(value)
end
local vdf_numbers = function(value)
	if value < 0 then
		return value
	else
		return "+" .. value
	end
end
local vdf_numberts = function(value)
	if value < 0 then
		return string.formatnumberthousands(value)
	else
		return "+" .. string.formatnumberthousands(value)
	end
end
local vdf_numberms = function(value)
	return string.format("%0.2fs", value / 10000)
end
_ENV = nil
;(nil)[gPropShowValueType.default] = function(value)
	return value
end
;(nil)[gPropShowValueType.numbert] = vdf_numbert
;(nil)[gPropShowValueType.numberu] = vdf_numberu
;(nil)[gPropShowValueType.numbers] = vdf_numbers
;(nil)[gPropShowValueType.numberts] = vdf_numberts
propParser.valueDecorators, (nil)[gPropShowValueType.numberms] = nil, vdf_numberms
local propType_attr = function(propCfg, data)
	local param = propCfg.param
	local filterSystem = include("filterSystem")
	local attrType = param.attrType
	local filterGroupID = param.filterGroupID
	local filter = filterSystem.converGroupID(filterGroupID)
	local gametop = gModuleMgr.getObject("gametop")
	local attributeCtrl = gametop.playertop_:getModule("attributeCtrl")
	local attrValue = attributeCtrl:queryByFilter(attrType, filter)
	return attrValue
end
local propType_formula = function(propCfg, data)
	local fid = propCfg.param.fid
	return calcFormula(fid, data)
end
local propType_custom = function(propCfg, data, args)
	local func = propParser.propCustomFuncMap[propCfg.propId]
	if func then
		return func(propCfg, data, args)
	else
		assert(false, "propCustomFuncMap[" .. propCfg.propId .. "] not defined! (propParser.lua)")
	end
end
propParser.propTypeFuncMap.attr = propType_attr
propParser.propTypeFuncMap.formula = propType_formula
propParser.propTypeFuncMap.custom = propType_custom
function propParser.getPropValueById(propId, data, args)
	local propCfg = include("attrltCtrl").getPropertyCfg(propId)
	if propCfg then
		local propFunc = propParser.propTypeFuncMap[propCfg.propType]
		if propFunc then
			return propFunc(propCfg, data, args)
		end
	end
end
function propParser.getFormatPropValueById(propId, data, showValueType)
	local value = propParser.getPropValueById(propId, data)
	if not showValueType then
		local propCfg = include("attrltCtrl").getPropertyCfg(propId)
		if propCfg then
			showValueType = propCfg.showValueType
		end
	end
	showValueType = showValueType or gPropShowValueType.default
	local vdf = propParser.valueDecorators[showValueType]
	if vdf then
		return vdf(value)
	else
		return value
	end
end
function propParser.getFormatByAttrIDAndValue(attrID, value, showValueType)
	local attrltCtrl = include("attrltCtrl")
	local attrType = attrltCtrl.getAttrType(attrID)
	return propParser.getFormatByAttrTypeAndValue(attrType, value, showValueType)
end
function propParser.getFormatByAttrTypeAndValue(attrType, value, showValueType)
	local attrltCtrl = include("attrltCtrl")
	local attrValueType = attrltCtrl.getAttrValueType(attrType)
	local showValueType = showValueType or attrltCtrl.getShowValueType(attrType)
	print("attrType ", attrType, "value ", value, "attrValueType ", attrValueType, "showValueType ", showValueType)
	if attrValueType == gAttrValueType.percentage then
		value = value / 100
	end
	showValueType = showValueType or gPropShowValueType.default
	local vdf = propParser.valueDecorators[showValueType]
	if vdf then
		value = vdf(value)
	end
	if attrValueType == gAttrValueType.percentage and showValueType ~= gPropShowValueType.numberms then
		value = value .. "%"
	end
	return value
end
function propParser.getModuleValue(name, data, args)
end
function propParser.getCustomValue(name, data, args)
end
return propParser
