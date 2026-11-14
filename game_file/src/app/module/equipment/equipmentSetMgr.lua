local equipmentSet = include("equipmentSet")
local equipmentltCtrl = include("equipmentltCtrl")
local _ENV, equipmentSetMgr = "equipmentltCtrl", "equipmentltCtrl"
function equipmentSetMgr:initialize(DBData)
	_ENV, self._setList, _ENV = nil, nil, nil
	self._data, (nil).setList, _ENV, (nil).activeSet = nil, nil, nil, nil
	if DBData then
		self._data.activeSet = DBData.activeSet
		for setID, setData in pairs(DBData.setList) do
			if equipmentltCtrl.setIDValid(setID) then
				self:_addSet(setID, setData)
			end
		end
	end
	local setListConfig = equipmentltCtrl.getEquipmentSetList()
	if setListConfig then
		for _, setID in ipairs(setListConfig) do
			if not self:_findSet(setID) then
				self:_newSet(setID)
			end
		end
	end
end
function equipmentSetMgr:active(setID)
	if not equipmentltCtrl.setIDValid(setID) then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	if self:isActive(setID) then
		return gErrDef.Err_EQUIPMENTSET_ALREADY_ACTIVE
	end
	self._data.activeSet = setID
	return gErrDef.Err_None
end
function equipmentSetMgr:isActive(setID)
	if self._data.activeSet == setID then
		return true
	end
end
function equipmentSetMgr:getActiveSet()
	return self._data.activeSet
end
function equipmentSetMgr:setPart(setID, part, epid)
	local set = self:_findSet(setID)
	if not set then
		return gErrDef.Err_NOT_FOUND_EQUIPMENTSET
	end
	set:setPart(part, epid)
	return gErrDef.Err_None
end
function equipmentSetMgr:resetPart(setID, part, epid)
	local set = self:_findSet(setID)
	if not set then
		return gErrDef.Err_NOT_FOUND_EQUIPMENTSET
	end
	set:resetPart(part, epid)
	return gErrDef.Err_None
end
function equipmentSetMgr:reset(setID)
	local set = self:_findSet(setID)
	if not set then
		return gErrDef.Err_NOT_FOUND_EQUIPMENTSET
	end
	set:reset()
	return gErrDef.Err_None
end
function equipmentSetMgr:setTitle(setID, title)
	local set = self:_findSet(setID)
	if not set then
		return false
	end
	set:setTitle(title)
	return true
end
function equipmentSetMgr:getTitle(setID)
	local set = self:_findSet(setID)
	if not set then
		return ""
	end
	local title = set:getTitle()
	return title
end
function equipmentSetMgr:getEquipmentSetList(setID)
	local set = self:_findSet(setID)
	if not set then
		return gErrDef.Err_NOT_FOUND_EQUIPMENTSET
	end
	return gErrDef.Err_None, set:getEquipmentList()
end
function equipmentSetMgr:getEquipmentSetPart(setID, part)
	local set = self:_findSet(setID)
	if not set then
		return gErrDef.Err_NOT_FOUND_EQUIPMENTSET
	end
	return gErrDef.Err_None, set:getPart(part)
end
function equipmentSetMgr:removeEquipment(part, rmEpid)
	for setID, set in pairs(self._setList) do
		local epid = set:getPart(part)
		if epid == rmEpid then
			set:resetPart(part, epid)
		end
	end
end
function equipmentSetMgr:getDataForDB()
	return self._data
end
function equipmentSetMgr:_newSet(setID)
	if not self._setList[setID] then
		local set = equipmentSet.new()
		self._setList[setID] = set
		self._data.setList[setID] = set:getDataForDB()
	end
end
function equipmentSetMgr:_addSet(setID, setData)
	if not self._setList[setID] then
		local set = equipmentSet.new(setData)
		self._setList[setID] = set
		self._data.setList[setID] = set:getDataForDB()
	end
end
function equipmentSetMgr:_findSet(setID)
	return self._setList[setID]
end
function equipmentSetMgr:_isTitleLegal(title)
	if "string" ~= type(title) then
		return false
	end
	if "" == string.trim(title) then
		return false
	end
	return true
end
return equipmentSetMgr
