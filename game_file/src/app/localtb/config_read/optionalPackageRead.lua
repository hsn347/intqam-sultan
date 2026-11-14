local optionalPackageRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "optional_package"
	;(nil)[2] = true
	optionalPackageRead:defineValue("op", nil)
	optionalPackageRead = nil
	;(nil)[1] = "optional_package_client"
	optionalPackageRead:defineValue("opc", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "sell_type"
	;(nil)[2] = true
	optionalPackageRead:defineValue("st", nil)
end
init()
function optionalPackageRead:getSaleTypeListBySettingIndex(settingIndex)
	local optionalPackageRead, saleTypeList
	if optionalPackageRead.st[settingIndex] then
		saleTypeList = optionalPackageRead.st[settingIndex].Saletype
	end
	return saleTypeList
end
function optionalPackageRead:getPriceBySettingIndex(settingIndex)
	local price = 0
	if optionalPackageRead.st[settingIndex] then
		price = optionalPackageRead.st[settingIndex].Price
	end
	return price
end
function optionalPackageRead:getLimitCountBySettingIndex(settingIndex)
	local limitCount = 0
	if optionalPackageRead.st[settingIndex] then
		limitCount = optionalPackageRead.st[settingIndex].Limit
	end
	return limitCount
end
function optionalPackageRead:getPackageTypeBySettingIndex(settingIndex)
	local packageType = 0
	if optionalPackageRead.st[settingIndex] then
		packageType = optionalPackageRead.st[settingIndex].packagetype
	end
	return packageType
end
function optionalPackageRead:getMustDataBySaleTypeList(settingIndex)
	local optionalPackageRead, MustData
	local optionalPackageRead, saleTypeList
	if optionalPackageRead.st[settingIndex] then
		saleTypeList = optionalPackageRead.st[settingIndex].Saletype
	end
	for i, v in ipairs(saleTypeList) do
		if optionalPackageRead.op[v] and optionalPackageRead.op[v].grouptype == 1 then
			table.insert(MustData, optionalPackageRead.op[v])
		end
	end
	return MustData
end
function optionalPackageRead:getOptionalDataBySaleTypeList(settingIndex)
	local optionalPackageRead, optionalData
	if optionalPackageRead.st[settingIndex] then
		local packageType = optionalPackageRead.st[settingIndex].packagetype
		for i, v in ipairs(optionalPackageRead.op) do
			if v.packagetype == packageType and v.grouptype == 2 then
				table.insert(optionalData, v)
			end
		end
	end
	return optionalData
end
function optionalPackageRead:getFixedPackageNameByIndex(packageIndex)
	local packageName = ""
	if optionalPackageRead.opc[packageIndex] then
		packageName = optionalPackageRead.opc[packageIndex].Packagename
	end
	return packageName
end
function optionalPackageRead:getFixedPackageIconByIndex(packageIndex)
	local packageIcon = "btn_main_activity.png"
	if optionalPackageRead.opc[packageIndex] then
		packageIcon = optionalPackageRead.opc[packageIndex].Packageicon
	end
	return packageIcon
end
return optionalPackageRead
