local worldMapComInstanceLodAlliance = class("worldMapComInstanceLodAlliance", include("worldMapComInstanceLod"))
local worldMapDefine = _G.worldMapDefine
local worldMapViewDef = include("worldMapViewDef")
function worldMapComInstanceLodAlliance:ctor(param)
	worldMapComInstanceLodAlliance.super.ctor(self, param)
end
function worldMapComInstanceLodAlliance:onMessageListener()
	worldMapComInstanceLodAlliance.super.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_NODEINFO_SELECT_CHANGE", handler(self, self.updateNodeInfoSelect))
end
function worldMapComInstanceLodAlliance:updateNodeInfoSelect()
	local isShow = false
	if worldMapDefine.isInNebula() or worldMapDefine.isInAtlantis() then
		isShow = true
	else
		worldMapDefine = worldMapDefine.isInAtlantis()
		local worldMapDefine.isInAtlantis()[worldMapViewDef.NODEINFO_TYPE_ALLIANCE], config = true, worldMapDefine.isInAtlantis()
		isShow = config[worldMapDefine.curSelectNodeInfo] or false
	end
	self.builder:updateLodFocusChange(isShow and self.lodFocus)
end
function worldMapComInstanceLodAlliance:doLodChange(focus, lod)
	if focus then
		self.builder:updateLodChange(lod)
	end
	self:updateNodeInfoSelect()
end
return worldMapComInstanceLodAlliance
