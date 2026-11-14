local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local equipmentAdditionMgr = include("equipmentAdditionMgr")
local attributeSystem = include("attributeSystem")
local equipmentMgr = include("equipmentMgr")
local equipmentCell = class("equipmentCell")
_ENV = "equipmentCell"
;("equipmentCell").eid = nil
;("equipmentCell").epid = nil
;("equipmentCell").slv = 0
;("equipmentCell").qly = nil
;("equipmentCell").wear = gStatus.NO
;("equipmentCell").isCle = gStatus.NO
;("equipmentCell").extra = nil
;("equipmentCell").rExtra = nil
;("equipmentCell").rExtra10 = nil
;("equipmentCell").mainM = nil
;("equipmentCell").subM = nil
;("equipmentCell").endTime = nil
local ("equipmentCell").islock, property = false, "equipmentCell"
function equipmentCell:disassembleEquipment()
	return gErrDef.Err_None
end
function equipmentCell:strengthenEquipment(slv)
	self.property.slv = self.property.slv + 1
	local epid = self:getEPID()
	local equipmentltCtrl, baseProperty = self, self
	local elv = self:getEquipmentLV()
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self:getEID())
	local index = math.floor(self:getEID() % 1000000 / 100000)
	local equipQuality = self:getEquipmentQuality()
	if not isSuitEquip then
		baseProperty = self:getEquipmentBaseProperty()
	else
		elv = elv % 100
		local propertyType, propertyValue, propertyType2, propertyValue2 = equipmentltCtrl.getSuitEquipBuffValueByEidAndIndex(index, self:getEID(), equipQuality, self.property.slv)
		table.insert(baseProperty, propertyType)
		table.insert(baseProperty, propertyValue)
		table.insert(baseProperty, propertyType2)
		table.insert(baseProperty, propertyValue2)
	end
	if self:isWearing() then
		self:reCalculateProperty()
	end
	return gErrDef.Err_None
end
function equipmentCell:remakeEquipment(rExtraProperty)
	self.property.rExtra = rExtraProperty
	self.property.rExtra10 = nil
	return gErrDef.Err_None
end
function equipmentCell:confirmRemakeProperty()
	if not self.property.rExtra then
		return gErrDef.Err_NOT_REMAKE_EXTRA_PROPERTY
	end
	local curExtraProperty = self.property.extra
	self.property.extra = self.property.rExtra
	self.property.rExtra = nil
	if self:isWearing() then
		local epid = self:getEPID()
		if curExtraProperty then
			for i, v in ipairs(curExtraProperty) do
				equipmentAdditionMgr.remove(v[1], epid)
			end
		end
		self:reCalculateProperty()
	end
	return gErrDef.Err_None
end
function equipmentCell:remakeEquipmentTen(rExtraPropertyTen)
	self.property.rExtra10 = rExtraPropertyTen
	self.property.rExtra = nil
	return gErrDef.Err_None
end
function equipmentCell:confirmRemakePropertyTen(idx)
	if not self.property.rExtra10 then
		return gErrDef.Err_NOT_REMAKE_EXTRA_PROPERTY
	end
	local curExtraProperty = self.property.extra
	self.property.extra = self.property.rExtra10[idx]
	self.property.rExtra10 = nil
	if self:isWearing() then
		local epid = self:getEPID()
		if curExtraProperty then
			for i, v in ipairs(curExtraProperty) do
				equipmentAdditionMgr.remove(v[1], epid)
			end
		end
		self:reCalculateProperty()
	end
	return gErrDef.Err_None
end
function equipmentCell:deleteRemakeProperty()
	if not self.property.rExtra then
		return gErrDef.Err_NOT_FOUND_REMAKE_EXTRA_PROPERTY
	end
	self.property.rExtra = nil
	return gErrDef.Err_None
end
function equipmentCell:isWearing()
	return self.property.wear == gStatus.YES
end
function equipmentCell:isLock()
	return self.property.islock
end
function equipmentCell:setIsLock(islock)
	self.property.islock = islock
end
function equipmentCell:reCalculateProperty(isNotNotify)
	local epid = self:getEPID()
	local equipmentltCtrl, baseProperty = self, self
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self:getEID())
	local index = math.floor(self:getEID() % 1000000 / 100000)
	local equipQuality = self:getEquipmentQuality()
	local equipmentltCtrl, tmpPropertyTable = self, self
	if not isSuitEquip then
		baseProperty = self:getEquipmentBaseProperty()
		for i = 1, #baseProperty - 1, 2 do
			if not tmpPropertyTable[baseProperty[i]] then
				tmpPropertyTable[baseProperty[i]] = baseProperty[i + 1]
			else
				tmpPropertyTable[baseProperty[i]] = tmpPropertyTable[baseProperty[i]] + baseProperty[i + 1]
			end
		end
	else
		local propertyType, propertyValue, propertyType2, propertyValue2 = equipmentltCtrl.getSuitEquipBuffValueByEidAndIndex(index, self:getEID(), equipQuality, self.property.slv)
		if not tmpPropertyTable[propertyType] then
			tmpPropertyTable[propertyType] = propertyValue
		else
			tmpPropertyTable[propertyType] = tmpPropertyTable[propertyType] + propertyValue
		end
		if not tmpPropertyTable[propertyType2] then
			tmpPropertyTable[propertyType2] = propertyValue2
		else
			tmpPropertyTable[propertyType2] = tmpPropertyTable[propertyType2] + propertyValue2
		end
	end
	local extraProperty = self:getEquipmentExtraProperty()
	if extraProperty then
		for i, v in ipairs(extraProperty) do
			if not tmpPropertyTable[v[1]] then
				tmpPropertyTable[v[1]] = v[2]
			else
				tmpPropertyTable[v[1]] = tmpPropertyTable[v[1]] + v[2]
			end
		end
	end
	for k, v in pairs(tmpPropertyTable) do
		equipmentAdditionMgr.remove(k, epid)
		equipmentAdditionMgr.add(k, epid, v)
	end
end
function equipmentCell:wearEquipment(init)
	local epid = self:getEPID()
	local equipmentltCtrl, baseProperty = self, self
	local equipmentltCtrl, specialProperty
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self:getEID())
	local index = math.floor(self:getEID() % 1000000 / 100000)
	local equipQuality = self:getEquipmentQuality()
	local equipmentltCtrl, tmpPropertyTable = self, self
	if not isSuitEquip then
		local part = self:getEquipmentPart()
		if part == gEquipmentPart.NECKLACE or part == gEquipmentPart.RING then
			baseProperty = equipmentltCtrl.getEquipmentAllProperty(self:getEID(), equipQuality, self.property.slv)
			specialProperty = equipmentltCtrl.getEquipmentSpecialProperty(self:getEID(), equipQuality)
		else
			local retBase = self:getEquipmentBaseProperty()
			for i = 1, #retBase - 1, 2 do
				equipmentltCtrl = self:getEID()
				self:getEID().propertyType = retBase[i]
				self:getEID().propertyValue = retBase[i + 1]
				table.insert(baseProperty, self:getEID())
			end
		end
		for i, v in ipairs(baseProperty) do
			if not tmpPropertyTable[v.propertyType] then
				tmpPropertyTable[v.propertyType] = v.propertyValue
			else
				tmpPropertyTable[v.propertyType] = tmpPropertyTable[v.propertyType] + v.propertyValue
			end
		end
	else
		local propertyType, propertyValue, propertyType2, propertyValue2 = equipmentltCtrl.getSuitEquipBuffValueByEidAndIndex(index, self:getEID(), equipQuality, self.property.slv)
		if not tmpPropertyTable[propertyType] then
			tmpPropertyTable[propertyType] = propertyValue
		else
			tmpPropertyTable[propertyType] = tmpPropertyTable[propertyType] + propertyValue
		end
		if not tmpPropertyTable[propertyType2] then
			tmpPropertyTable[propertyType2] = propertyValue2
		else
			tmpPropertyTable[propertyType2] = tmpPropertyTable[propertyType2] + propertyValue2
		end
	end
	local extraProperty = self:getEquipmentExtraProperty()
	if extraProperty then
		for i, v in ipairs(extraProperty) do
			if not tmpPropertyTable[v[1]] then
				tmpPropertyTable[v[1]] = v[2]
			else
				tmpPropertyTable[v[1]] = tmpPropertyTable[v[1]] + v[2]
			end
		end
	end
	for k, v in pairs(tmpPropertyTable) do
		equipmentAdditionMgr.add(k, epid, v, init)
	end
	for i, v in ipairs(specialProperty) do
		attributeSystem.add(v.attrID, epid, v.attrValue, gAttributeSourceEnum.EQUIPMENT)
	end
	self.property.wear = gStatus.YES
	if isSuitEquip then
		equipmentAdditionMgr.wearSuitCombineProperty(equipmentltCtrl.getEquipmentSuitID(self:getEID(), self:getEquipmentQuality()))
	end
	return true
end
function equipmentCell:takeOffEquipment()
	if self:isWearing() then
		local epid = self:getEPID()
		local equipmentltCtrl, baseProperty = self, self
		local equipmentltCtrl, specialProperty
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self:getEID())
		local index = math.floor(self:getEID() % 1000000 / 100000)
		local equipQuality = self:getEquipmentQuality()
		local partList = equipmentltCtrl.getSuitPartList(index, self:getEID())
		if not isSuitEquip then
			local part = self:getEquipmentPart()
			if part == gEquipmentPart.NECKLACE or part == gEquipmentPart.RING then
				baseProperty = equipmentltCtrl.getEquipmentAllProperty(self:getEID(), equipQuality, self.property.slv)
				specialProperty = equipmentltCtrl.getEquipmentSpecialProperty(self:getEID(), equipQuality)
			else
				local retBase = self:getEquipmentBaseProperty()
				for i = 1, #retBase - 1, 2 do
					equipmentltCtrl = self:getEID()
					self:getEID().propertyType = retBase[i]
					self:getEID().propertyValue = retBase[i + 1]
					table.insert(baseProperty, self:getEID())
				end
			end
			for i, v in ipairs(baseProperty) do
				equipmentAdditionMgr.remove(v.propertyType, epid)
			end
		else
			local propertyType, propertyValue = partList[equipQuality + 1].propertyType, partList[equipQuality + 1].propertyValue
			local propertyType2, propertyValue2 = partList[equipQuality + 1].propertyType2, partList[equipQuality + 1].propertyValue2
			table.insert(baseProperty, propertyType)
			table.insert(baseProperty, propertyValue)
			table.insert(baseProperty, propertyType2)
			table.insert(baseProperty, propertyValue2)
			equipmentAdditionMgr.remove(baseProperty[1], epid)
			equipmentAdditionMgr.remove(baseProperty[3], epid)
		end
		local extraProperty = self:getEquipmentExtraProperty()
		if extraProperty then
			for i, v in ipairs(extraProperty) do
				equipmentAdditionMgr.remove(v[1], epid)
			end
		end
		for i, v in ipairs(specialProperty) do
			attributeSystem.remove(v.attrID, epid, gAttributeSourceEnum.EQUIPMENT)
		end
		self.property.wear = gStatus.NO
		if isSuitEquip then
			equipmentAdditionMgr.takeOffSuitCombineProperty(equipmentltCtrl.getEquipmentSuitID(self:getEID(), self:getEquipmentQuality()))
		end
		return true
	else
		print("equipmentCell.wearEquipment: not wear")
	end
end
function equipmentCell:getEID()
	return self.property.eid
end
function equipmentCell:getEPID()
	return self.property.epid
end
function equipmentCell:getEquipmentPart()
	return equipmentltCtrl.getEquipmentPart(self.property.eid)
end
function equipmentCell:getEquipmentLV()
	return equipmentltCtrl.getEquipmentLv(self.property.eid)
end
function equipmentCell:getEquipmentType()
	return equipmentltCtrl.getEquipmentType(self.property.eid, self.property.qly)
end
function equipmentCell:getEquipmentSLV()
	return self.property.slv
end
function equipmentCell:recastEquipmentSLV()
	self.property.slv = 0
end
function equipmentCell:setEquipmentSLV(slv)
	self.property.slv = slv
end
function equipmentCell:getEquipmentEndTimeProperty()
	return self.property.endTime
end
function equipmentCell:getEquipmentQuality()
	return self.property.qly
end
function equipmentCell:getEquipmentBaseProperty(slv)
	local propertyType, propertyValue, propertyType2, propertyValue2, propertyType3, propertyValue3, propertyType4, propertyValue4 = equipmentltCtrl.getEquipmentBaseProperty(self:getEID(), self:getEquipmentQuality(), slv or self:getEquipmentSLV())
	_UPVALUE2_ = nil
	;(nil)[1] = propertyType
	local (nil)[2], ret = propertyValue, nil
	if propertyType2 and propertyType2 ~= 0 and propertyValue2 and propertyValue2 ~= 0 then
		table.insert(ret, propertyType2)
		table.insert(ret, propertyValue2)
	end
	if propertyType3 and propertyType3 ~= 0 and propertyValue3 and propertyValue3 ~= 0 then
		table.insert(ret, propertyType3)
		table.insert(ret, propertyValue3)
	end
	if propertyType4 and propertyType4 ~= 0 and propertyValue4 and propertyValue4 ~= 0 then
		table.insert(ret, propertyType4)
		table.insert(ret, propertyValue4)
	end
	return ret
end
function equipmentCell:getEquipmentExtraProperty()
	return self.property.extra
end
function equipmentCell:setEquipmentExtraProperty(extra)
	self.property.extra = extra
end
function equipmentCell:getEquipmentRemakeProperty()
	if self.property.rExtra10 and next(self.property.rExtra10) then
		return self.property.rExtra10
	else
		_UPVALUE1_ = self.property.rExtra10
		self.property.rExtra10[1] = self.property.rExtra
		return self.property.rExtra10
	end
	return
end
function equipmentCell:checkIsLockAttr(attr)
	dump(self.property.extra, "rExtra")
	for i, v in ipairs(self.property.extra) do
		if tonumber(v[1]) == tonumber(attr) then
			return true
		end
	end
end
function equipmentCell:getIsTenRemake()
	if self.property.rExtra10 and next(self.property.rExtra10) then
		return true
	else
		return false
	end
	return
end
function equipmentCell:isEquipmentComplete()
	return self.property.isCle == gStatus.YES
end
function equipmentCell:completeForging()
	self.property.isCle = gStatus.YES
end
function equipmentCell:getSuitequipID()
	if not self.suitequipID then
		local equipInfo = equipmentltCtrl.getEquipCfg(self:getEID())
		if equipInfo then
			self.suitequipID = equipInfo.suitequipID
		end
	end
	return self.suitequipID or 0
end
function equipmentCell:getMainMaterialInfo()
	return self.property.mainM
end
function equipmentCell:getSubMaterialInfo()
	return self.property.subM
end
function equipmentCell:cleanForgingInfo()
	self.property.mainM = nil
	self.property.subM = nil
end
function equipmentCell:getEquipmentPower()
	local basePropertyType, basePropertyValue = self:getEquipmentBaseProperty()
	return equipmentltCtrl.getEquipmentPower(basePropertyType, basePropertyValue, self.property.extra)
end
function equipmentCell:getLockInfo()
	if not self.property.lockInfo then
		_UPVALUE0_ = self.property.lockInfo
	end
	return self.property.lockInfo
end
function equipmentCell:dump()
end
function equipmentCell:ctor(property)
	self.property = property or clone(property)
end
return equipmentCell
