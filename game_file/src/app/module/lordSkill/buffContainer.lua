local buffContainer = class("buffContainer")
function buffContainer:ctor()
	self._data, _UPVALUE0_ = nil, nil
end
function buffContainer:update(key, value, id)
	assert(key)
	assert("number" == type(value))
	if not self._data[key] then
		_ENV = self._data[key]
		self._data[key].total = nil
		self._data[key].list = nil
	end
	self._data[key] = self._data[key]
	local valueData = self._data[key]
	if id then
		valueData.total = valueData.total or 0
		if not valueData.list then
			_ENV = valueData.list
		end
		valueData.list = valueData.list
		local curValue = valueData.list[id] or 0
		valueData.total = valueData.total - curValue + value
		valueData.list[id] = value
	else
		valueData.total = valueData.total or 0
		valueData.total = valueData.total + value
	end
end
function buffContainer:remove(key, id)
	assert(key)
	if id then
		local valueData = self._data[key]
		if valueData then
			local list = valueData.list
			local value = list and list[id]
			if value then
				valueData.total = valueData.total - value
				list[id] = nil
				if not next(list) and valueData.total == 0 then
					self._data[key] = nil
				end
				return true, value
			end
		else
			print("buffContainer:remove: not found data")
		end
	else
		local valueData = self._data[key]
		if valueData then
			local value = valueData.total
			self._data[key] = nil
			return true, value
		else
			print("buffContainer:remove: not found data")
		end
	end
	return false
end
function buffContainer:query(key, id)
	assert(key)
	if id then
		local valueData = self._data[key]
		if valueData then
			return valueData.list[id], valueData.total
		end
	else
		local valueData = self._data[key]
		return valueData and valueData.total
	end
end
function buffContainer:clean()
	self._data, _UPVALUE0_ = nil, nil
end
function buffContainer:dump(str)
end
return buffContainer
