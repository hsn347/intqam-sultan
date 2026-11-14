local worldLodDef = worldMapDefine.worldLodDef
local worldMapNebulaLodUI = include("worldMapNebulaLodUI")
local worldMapNebulaAllStarLodUI = class("worldMapNebulaAllStarLodUI", worldMapNebulaLodUI)
function worldMapNebulaAllStarLodUI:getLodConfig(...)
	local _ENV, config
	_ENV = nil
	;(nil).widget = self.lodMap
	;(nil).showLodMin = worldLodDef.LOD2
	;(nil).offset = cc.p(SoraDFSign(200), 0)
	table.insert(config, nil)
	_ENV = nil
	;(nil).widget = self.target_:getNodeWar()
	;(nil).showLodMax = worldLodDef.LOD1
	table.insert(config, nil)
	local mainUI = SoraDCurrentMainUI()
	local mainUITop = mainUI:getMainUITop()
	local mainUIBottom = mainUI:getMainUIBottom()
	_ENV = 0
	;(0).widget = mainUITop:getTarget("nebulaAllStarUITop")
	;(0).showLodMax = worldLodDef.LOD1
	;(0).isFgui = true
	table.insert(config, 0)
	_ENV = 0
	;(0).widget = mainUIBottom:getTarget("nebulaAllStarUIBottom")
	;(0).showLodMax = worldLodDef.LOD1
	;(0).isFgui = true
	table.insert(config, 0)
	return config
end
function worldMapNebulaAllStarLodUI:initNodeInfo(...)
	self.Node_mapInfo:setVisible(false)
end
return worldMapNebulaAllStarLodUI
