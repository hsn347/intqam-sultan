local equipmentSet = class("equipmentSet")
function equipmentSet:ctor(DBData)
	self._data = DBData or self:_getDefaultData()
end
function equipmentSet:setSetID(setID)
	self._data.setID = setID
end
function equipmentSet:getSetID()
	return self._data.setID
end
function equipmentSet:setPart(part, epid)
	self._data.list[tostring(part)] = epid
end
function equipmentSet:getPart(part)
	return self._data.list[tostring(part)]
end
function equipmentSet:resetPart(part, epid)
	self._data.list[tostring(part)] = nil
end
function equipmentSet:setTitle(title)
	self._data.title = title
end
function equipmentSet:getTitle()
	return self._data.title
end
function equipmentSet:reset()
	self._data.list, _UPVALUE0_ = nil, nil
end
function equipmentSet:getEquipmentList()
	local _ENV, ret
	for partStr, v in pairs(self._data.list) do
		ret[tonumber(partStr)] = v
	end
	return ret
end
function equipmentSet:getDataForDB()
	return self._data
end
function equipmentSet:_getDefaultData()
	_UPVALUE0_ = nil
	;(nil).setID = "0"
	;(nil).title = ""
	;(nil).list, _UPVALUE0_, (nil).active = nil, nil, false
	return nil
end
return equipmentSet
