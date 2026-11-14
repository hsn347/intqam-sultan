local dressltCtrl = include("dressltCtrl")
local dressUnitClass = include("dressUnit")
local attributeSystem = include("attributeSystem")
local castleSkinRead = include("castleSkinRead")
local dressMgr = class("dressMgr")
function dressMgr:ctor()
	self.property, _UPVALUE0_ = nil, nil
	self.type_unit, _UPVALUE0_, self.dress_list, _UPVALUE0_, self.property.setting, _UPVALUE0_ = self.property, self.property, self.property, self.property
end
function dressMgr:getPermanentCastleDressNum()
	local permanentCastleDressNum = 0
	for dressId, v in pairs(self.dress_list) do
		local dressType = dressltCtrl.getDressType(dressId)
		local dressLifeType = dressltCtrl.getDressLifeType(dressId)
		if tostring(dressType) == gDressType.CASTLE and dressLifeType == gDressLifeType.FOREVER and not castleSkinRead.isSpecailCastel(dressId) then
			permanentCastleDressNum = permanentCastleDressNum + 1
		end
	end
	return permanentCastleDressNum
end
function dressMgr:loadInitData(initData)
	if initData then
		self.property.setting, _ENV = nil, nil
		for k, v in pairs(initData.list) do
			local dressID = tonumber(k)
			if gErrDef.Err_None == dressltCtrl.isDress(dressID) then
				local ret, dressUnit = self:createDressUnit(dressID)
				dressUnit:load(v)
				self:_add(dressID, dressUnit)
			end
		end
		for k, v in pairs(initData.setting) do
			self:setDress(v)
		end
	end
end
function dressMgr:setDress(dressID)
	print("dressMgr:setDress(dressID)", dressID)
	local ret, dressUnit = self:getDress(dressID)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	local dressType = dressltCtrl.getDressType(dressID)
	self:_removeSetting(dressType)
	self:_setSetting(dressType, dressID)
	return gErrDef.Err_None
end
function dressMgr:restoreSetting(dressType)
	local dressID = self:_getSetting(dressType)
	if not dressID then
		return gErrDef.Err_DRESS_NOT_FOUND_SETTING
	end
	self:_removeSetting(dressType)
	return gErrDef.Err_None, dressID
end
function dressMgr:addDress(dressID, property)
	local ret, dressUnit = self:getDress(dressID)
	if gErrDef.Err_None == ret then
		dressUnit:load(property)
	else
		local dressType = dressltCtrl.getDressType(dressID)
		local subType = dressltCtrl.getSubType(dressID)
		dressUnit = self:_getDressByType(dressType, subType)
		local isSetting
		if dressUnit then
			local rmDressID = dressUnit:getDressID()
			isSetting = self:isCurSetting(rmDressID)
			self:removeDress(rmDressID)
		end
		ret, dressUnit = self:createDressUnit(dressID)
		if gErrDef.Err_None == ret then
			dressUnit:load(property)
			self:_add(dressID, dressUnit)
		end
		if isSetting then
			self:setDress(dressID)
		end
	end
	return ret, dressUnit
end
function dressMgr:getDress(dressID)
	local dressUnit = self:_get(dressID)
	if not dressUnit then
		return gErrDef.Err_DRESS_NOT_FOUND_DRESS
	end
	return gErrDef.Err_None, dressUnit
end
function dressMgr:getDressOfSetting(dressType)
	local dressID = self:_getSetting(dressType)
	if not dressID then
		return gErrDef.Err_DRESS_NOT_FOUND_SETTING
	end
	return self:getDress(dressID)
end
function dressMgr:removeDress(dressID)
	if not self:_get(dressID) then
		return gErrDef.Err_DRESS_NOT_FOUND_DRESS
	end
	local dressUnit = self:_remove(dressID)
	local dressType = dressUnit:getDressType()
	local setting = self:_getSetting(dressType)
	if setting == dressID then
		self:_removeSetting(dressType)
	end
	return gErrDef.Err_None, dressUnit
end
function dressMgr:createDressUnit(dressID)
	return gErrDef.Err_None, dressUnitClass.create(dressID)
end
function dressMgr:isCurSetting(dressID)
	local dressType = dressltCtrl.getDressType(dressID)
	local curSetting = self:_getSetting(dressType)
	if curSetting == dressID then
		return true
	end
	return false
end
function dressMgr:_getDressByType(dressType, subType)
	if self.type_unit[dressType] then
		return self.type_unit[dressType][subType]
	end
end
function dressMgr:_setSetting(dressType, dressID)
	print("dressMgr:_setSetting( dressType, dressID )", dressType, dressID)
	if gDressType.MARCH_SUIT == dressType then
		dressType = gDressType.MARCH_ARMY
	end
	self.property.setting[dressType] = dressID
	local subType = dressltCtrl.getSubType(dressID)
	local attrMap = dressltCtrl.getUseAttribute(subType)
	local attrSource = gAttributeSourceEnum.DRESS
	if attrMap and next(attrMap) then
		for _, attrPair in pairs(attrMap) do
			local subTypeKey = subType .. "_use"
			attributeSystem.add(attrPair.attrID, subTypeKey, attrPair.attrValue, attrSource)
		end
	end
end
function dressMgr:_removeSetting(dressType)
	local dressID = self.property.setting[dressType]
	self.property.setting[dressType] = nil
	if dressID and dressID then
		local subType = dressltCtrl.getSubType(dressID)
		local attrMap = dressltCtrl.getUseAttribute(subType)
		local attrSource = gAttributeSourceEnum.DRESS
		if attrMap and next(attrMap) then
			for _, attrPair in pairs(attrMap) do
				local subTypeKey = subType .. "_use"
				attributeSystem.remove(attrPair.attrID, subTypeKey, attrSource)
			end
		end
	end
end
function dressMgr:_getSetting(dressType)
	return self.property.setting[dressType]
end
function dressMgr:_get(dressID)
	return self.dress_list[dressID]
end
function dressMgr:_add(dressID, dressUnit)
	self.dress_list[dressID] = dressUnit
	local dressType = dressltCtrl.getDressType(dressID)
	local subType = dressltCtrl.getSubType(dressID)
	if not self.type_unit[dressType] then
		dressltCtrl = self.type_unit[dressType]
	end
	self.type_unit[dressType] = self.type_unit[dressType]
	self.type_unit[dressType][subType] = dressUnit
	local attrMap = dressltCtrl.getOwnAttribute(subType)
	local attrSource = gAttributeSourceEnum.DRESS
	if attrMap and next(attrMap) then
		for _, attrPair in pairs(attrMap) do
			local subTypeKey = subType .. "_own"
			attributeSystem.add(attrPair.attrID, subTypeKey, attrPair.attrValue, attrSource)
		end
	end
end
function dressMgr:_remove(dressID)
	local dressUnit = self.dress_list[dressID]
	self.dress_list[dressID] = nil
	local dressType = dressltCtrl.getDressType(dressID)
	local subType = dressltCtrl.getSubType(dressID)
	if self.type_unit[dressType] then
		self.type_unit[dressType][subType] = nil
	end
	local attrMap = dressltCtrl.getOwnAttribute(subType)
	local attrSource = gAttributeSourceEnum.DRESS
	if attrMap and next(attrMap) then
		for _, attrPair in pairs(attrMap) do
			local subTypeKey = subType .. "_own"
			attributeSystem.remove(attrPair.attrID, subTypeKey, attrSource)
		end
	end
	return dressUnit
end
function dressMgr:dump()
end
return dressMgr
