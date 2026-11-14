local worldMapViewDef = include("worldMapViewDef")
local worldMapComTmxBg = class("worldMapComTmxBg", include("worldMapCom"))
function worldMapComTmxBg:ctor()
	worldMapComTmxBg.super.ctor(self, "worldMapComTmxBg")
end
function worldMapComTmxBg:init()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:initMapTiledBg()
end
local TileBG_Size = 1024
local TileBG_Offset_X = worldMapViewDef.TileBG_Offset_X
local TileBG_Offset_Y = worldMapViewDef.TileBG_Offset_Y
function worldMapComTmxBg:initMapTiledBg()
	local sizex = TileBG_Offset_X * 2 + display.width / worldMapViewDef.MIN_SCALE + TileBG_Size
	local sizey = TileBG_Offset_Y * 2 + display.height / worldMapViewDef.MIN_SCALE + TileBG_Size
	print("maptiledbg", sizex, sizey)
	local spriteName = "SinglePicture/tiledmap.png"
	local anchor = cc.p(TileBG_Offset_X / sizex, 0.0)
	if worldMapDefine.isNebulaAllStarKingdomID() then
		spriteName = "SinglePicture/tiledmap_nebulaallstar.png"
		local width = display.width + 0.5 * display.height
		local height = display.height * 1.4
		sizex = width / worldMapViewDef.MIN_SCALE
		sizey = height / worldMapViewDef.MIN_SCALE
		anchor = cc.p(0.2, 0)
	end
	local tiledBg = display.newTilesSprite(spriteName, cc.rect(0, 0, sizex, sizey))
	local Z_ORDER = worldMapDefine.Z_ORDER
	tiledBg:addTo(self.target_.containerView, Z_ORDER.tmxView - 1)
	tiledBg:setAnchorPoint(anchor)
	self.tiledBg = tiledBg
	self.tiledBg_x = 0
	self.tiledBg_y = 0
	self.containerView = self.target_.containerView
end
local POINT_ZERO = cc.p(0, 0)
function worldMapComTmxBg:updateMapPos(event)
	local tile_pos = self.containerView:convertToNodeSpace(POINT_ZERO)
	local posxTile = math.floor(tile_pos.x / TileBG_Size)
	local posyTile = math.floor(tile_pos.y / TileBG_Size)
	if self.tiledBg_x ~= posxTile or self.tiledBg_y ~= posyTile then
		self.tiledBg_x = posxTile
		self.tiledBg_y = posyTile
		local posxTileNew = posxTile * TileBG_Size
		local posyTileNew = posyTile * TileBG_Size
		self.tiledBg:setPosition(cc.p(posxTileNew, posyTileNew))
	end
end
return worldMapComTmxBg
