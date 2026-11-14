local worldLodDef = worldMapDefine.worldLodDef
local worldMapNebulaLodUI = include("worldMapNebulaLodUI")
local worldMapSimulatedDrillLodUI = class("worldMapSimulatedDrillLodUI", worldMapNebulaLodUI)
function worldMapSimulatedDrillLodUI:getLodConfig(...)
	local _ENV, config
	_ENV = nil
	;(nil).widget = self.lodMap
	;(nil).showLodMin = worldLodDef.LOD2
	;(nil).offset = cc.p(SoraDFSign(200), 0)
	table.insert(config, nil)
	return config
end
function worldMapSimulatedDrillLodUI:initNodeInfo(...)
	self.Node_mapInfo:setVisible(false)
end
return worldMapSimulatedDrillLodUI
