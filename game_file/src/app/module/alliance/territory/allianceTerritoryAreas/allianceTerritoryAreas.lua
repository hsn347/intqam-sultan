local allianceTerritoryAreas = class("allianceTerritoryAreas")
function allianceTerritoryAreas:ctor()
	self.data, _UPVALUE0_ = nil, nil
end
function allianceTerritoryAreas:initialize(data)
	if not data then
		data, _UPVALUE0_ = nil, nil
	end
	local areas = data.areas
	self:initializeAreas(areas)
end
function allianceTerritoryAreas:destroy()
	self:destroyAreas()
end
function allianceTerritoryAreas:setAreas(areas)
	self.data.areas = areas
end
function allianceTerritoryAreas:getAreas()
	return self.data.areas
end
function allianceTerritoryAreas:initializeAreas(areas)
	areas = areas or 0
	self:setAreas(areas)
end
function allianceTerritoryAreas:destroyAreas()
	local defaultAreas = 0
	self:setAreas(defaultAreas)
end
return allianceTerritoryAreas
