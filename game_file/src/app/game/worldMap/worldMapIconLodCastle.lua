local worldMapUtil = include("worldMapUtil")
local worldMapIconLodCastle = class("worldMapIconLodCastle", include("worldMapIconLod"))
function worldMapIconLodCastle:ctor()
	worldMapIconLodCastle.super.ctor(self)
	self:_initData()
	self.imgIcon:setAnchorPoint(cc.p(0.52, 0.39))
end
function worldMapIconLodCastle:_initData()
	self.lodConfig = nil
	self.model = nil
	self.showModel = nil
end
local castleModelCfg = worldMapUtil.castleModelCfg
function worldMapIconLodCastle:updateData(data)
	if not data then
		return
	end
	if data.model then
		self.showModel = nil
		self.model = data.model
		self:updateLodChange()
	end
end
function worldMapIconLodCastle:updateModel()
	self.showModel = true
	local model = self.model
	local palaceInfoRead = include("palaceInfoRead")
	local castleImg = palaceInfoRead.getImg(tonumber(model))
	if castleImg then
		self.imgIcon:setSpriteFrame(castleImg)
		if castleModelCfg[model] then
			self.imgIcon:setPositionX(castleModelCfg[model].offsetx)
		else
			self.imgIcon:setPositionX(0)
		end
	else
		self.imgIcon:setPositionX(0)
		self.imgIcon:setSpriteFrame("Map_King_castle_01.png")
	end
end
function worldMapIconLodCastle:updateIcon()
	self.showModel = false
	self.imgIcon:setPositionX(-10)
	local palaceInfoRead = include("palaceInfoRead")
	local iconLod = palaceInfoRead.getIconLod(tonumber(self.model))
	self.imgIcon:setSpriteFrame(iconLod)
end
local worldLodDef = worldMapDefine.worldLodDef
local lodChange = worldLodDef.LOD3
function worldMapIconLodCastle:updateLodChange()
	if self.lod <= lodChange then
		if self.showModel ~= true then
			self:setScale(1.0)
			self.imgIcon:setPositionY(0)
			self:updateModel()
		end
	elseif self.showModel ~= false then
		self:updateIcon()
		self.imgIcon:setPositionY(10)
	end
end
function worldMapIconLodCastle:updateScaleChange(revertScale, scale)
	if self.lod > lodChange then
		self:setScale(revertScale)
	end
end
return worldMapIconLodCastle
