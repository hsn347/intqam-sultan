local warBuildingOwnerMgr = class("warBuildingOwnerMgr")
function warBuildingOwnerMgr:ctor()
	self.ownerMap, _UPVALUE0_ = nil, nil
end
function warBuildingOwnerMgr:setWarBuildingOwnerMap(kid, warBuildingOwnerMap)
