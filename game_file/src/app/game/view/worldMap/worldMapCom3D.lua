local worldMapEvent = include("worldMapEvent")
local worldMapCom3D = class("worldMapCom3D", include("worldMapCom"))
function worldMapCom3D:ctor()
	worldMapCom3D.super.ctor(self, "worldMapCom3D")
end
function worldMapCom3D:init()
	worldMapCom3D.super.init(self)
	self.top_fog = SoraDGetChildByName(self.target_, "Top_Image_fog")
	self.top_fog:setPositionY(display.height + display.iPhoneXBottom)
	self.bottom_fog = SoraDGetChildByName(self.target_, "Bottom_Image_fog")
	self.bottom_fog:setPositionY(0)
end
function worldMapCom3D:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TOGGLE_3D", handler(self, self.toggle3D))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TOGGLE_DEBUG", handler(self, self.toggleDebugLayer))
	self:toggle3D()
end
function worldMapCom3D:toggle3D()
	gEnableWorldMap3D = false
	if gEnableWorldMap3D then
		local director = cc.Director:getInstance()
		director:setProjection(cc.DIRECTOR_PROJECTION3_D)
		self.top_fog:setVisible(true)
		self.bottom_fog:setVisible(true)
	else
		local director = cc.Director:getInstance()
		director:setProjection(cc.DIRECTOR_PROJECTION2_D)
		self.top_fog:setVisible(false)
		self.bottom_fog:setVisible(false)
	end
	_ENV = self.bottom_fog
	self.bottom_fog.name = worldMapEvent.EVENT_TOOGLE_3D
	self:dispatchEvent(self.bottom_fog)
end
function worldMapCom3D:toggleDebugLayer()
	worldMapEvent = nil
	;(nil).name = worldMapEvent.EVENT_TILED_DEBUG
	self:dispatchEvent(nil)
	self:toggle3D()
end
return worldMapCom3D
