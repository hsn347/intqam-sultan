local worldMapIconLod = class("worldMapIconLod", include("worldMapInstanceLod"))
function worldMapIconLod:ctor()
	worldMapIconLod.super.ctor(self)
	self:_initUI()
end
function worldMapIconLod:_initUI()
	self.imgIcon = display.newSpriteNoChild("#lod_monster.png")
	self.imgIcon:addTo(self, -1)
	self.imgIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
end
function worldMapIconLod:setIcon(icon)
	self.imgIcon:setSpriteFrame(icon)
end
function worldMapIconLod:setColor(color)
	self.imgIcon:setColor(color)
end
function worldMapIconLod:initInstanceData(objData, worldInstanceData, instanceData)
	self:updateData(objData)
end
return worldMapIconLod
