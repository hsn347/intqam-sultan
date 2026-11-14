local worldMapComLodBase = class("worldMapComLodBase", include("worldMapCom"))
function worldMapComLodBase:ctor()
	worldMapComLodBase.super.ctor(self, "worldMapComLodBase")
end
function worldMapComLodBase:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TOGGLE_LOD", handler(self, self.toggleLOD))
end
function worldMapComLodBase:toggleLOD()
	SoraDRemoveAllPrePanelFromManager(self)
	_ENV = self
	self.msg = "MESSAGE_MAINSCEN_ONSHOW"
	self.viewType = VIEW_TYPE_MAP
	SoraDSendMessage(self)
end
return worldMapComLodBase
