local _ENV, attrltCtrl
local attribute_config = include("attribute_config")
local property_config = include("property_config")
local attribute_value_config = include("attribute_value_config")
function attrltCtrl.init()
end
function attrltCtrl.attrIDValid(attrID)
	if attribute_config[attrID] then
		return true
	else
		return false
	end
end
function attrltCtrl.attrTypeValid(attrType)
	if attrType then
		return true
	else
		return false
	end
end
function attrltCtrl.getAttrType(attrID)
	return attribute_config[attrID].attrType
end
function attrltCtrl.getAttrDes(attrID)
	local des = attribute_config[attrID].des
	if des == "" then
		des = "NA"
	end
	return i18n(des)
end
function attrltCtrl.getFilter(attrID)
	local filterGroupID = attrltCtrl.getFilterGroupID(attrID)
	return attrltCtrl.getFilterByGroupID(filterGroupID)
end
function attrltCtrl.getFilterGroupID(attrID)
	return attribute_config[attrID].filterGroupID
end
function attrltCtrl.getPropertyCfg(propId)
	return property_config[propId]
end
function attrltCtrl.getAttrValueType(attrType)
	if attribute_value_config[attrType] then
		return attribute_value_config[attrType].attrValueType
	else
		print("@error: ", "attrltCtrl.getAttrValueType attrType = " .. attrType .. "not found")
		return 1
	end
end
function attrltCtrl.getShowValueType(attrType)
	if attribute_value_config[attrType] then
		return attribute_value_config[attrType].showValueType
	else
		print("@error: ", "attrltCtrl.getShowValueType attrType = " .. attrType .. "not found")
		return 1
	end
end
attrltCtrl.init()
return attrltCtrl
