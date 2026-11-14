local worldMapResourceLod2 = class("worldMapResourceLod2", include("worldMapResourceLod"))
local worldMapDefine = include("worldMapDefine")
function worldMapResourceLod2:ctor()
	worldMapResourceLod2.super.ctor(self)
	self:_initUI()
end
function worldMapResourceLod2:_initUI()
	self.image_level = display.newSpriteNoChild("#lod_mineLevel.png")
	self.image_level:setPosition(cc.p(0, -22))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = "1"
	self.image_level.size = 14
	self.text_level = SoraDCreateLabelNoChild(self.image_level)
	self.text_level:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_level:setPosition(cc.p(0, -20))
	self.text_level:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.text_level:addTo(self, 1)
end
function worldMapResourceLod2:initInstanceData(objData, worldInstanceData, instanceData)
	local resourceClassID = worldInstanceData.class
	local level = worldMapDefine.getResourceLevel(resourceClassID)
	self.text_level:setString(level)
	worldMapResourceLod2.super.initInstanceData(self, objData, worldInstanceData, instanceData)
end
return worldMapResourceLod2
