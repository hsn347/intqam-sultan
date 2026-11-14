local itemLogic = include("itemLogic")
local backpackCell = class("backpackCell")
backpackCell.id_ = 0
backpackCell.count_ = 0
backpackCell.specialID_ = 0
backpackCell.cellCount_ = 0
backpackCell.invalidtime_ = nil
function backpackCell:ctor(id)
	if "number" ~= type(id) then
		print("the id is not number")
		return
	end
	self:id(id)
end
local updateCellCount = function(self)
	local newCount = itemLogic.calCellCount(self:id(), self:count())
	local val = newCount - self:cellCount()
	self:cellCount(newCount)
	return val, self:cellCount()
end
local setValue = function(self, key, value)
	self[key] = value
end
local getValue = function(self, key)
	return self[key]
end
local info = function(self, key, value)
	if not value then
		return getValue(self, key)
	else
		setValue(self, key, value)
	end
end
function backpackCell:add(count)
	count = count or 1
	local newCount = count + self:count()
	self:count(newCount)
	return updateCellCount(self)
end
function backpackCell:sub(count)
	count = count or 1
	local newCount = self:count() - count
	self:count(newCount)
	return updateCellCount(self)
end
function backpackCell:count(count)
	return info(self, "count_", count)
end
function backpackCell:id(id)
	return info(self, "id_", id)
end
function backpackCell:specialID(id)
	return info(self, "specialID_", id)
end
function backpackCell:cellCount(count)
	return info(self, "cellCount_", count)
end
function backpackCell:invalidtime(invalidtime)
	return info(self, "invalidtime_", invalidtime)
end
return backpackCell
