local worldMapMonsterLod = class("worldMapMonsterLod", include("worldMapInstanceLod"))
function worldMapMonsterLod:ctor()
	worldMapMonsterLod.super.ctor(self)
	self:_initUI()
end
function worldMapMonsterLod:_initUI()
	self.monster = display.newSpriteNoChild("#lod_monster.png")
	self.monster:addTo(self, -1)
	self.monster:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self.image_level = display.newSpriteNoChild("#lod_mineLevel.png")
	self.image_level:setPosition(cc.p(0, -22))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = "1"
	self.image_level.size = 14
	self.text_level = SoraDCreateLabel(self.image_level)
	self.text_level:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_level:setPosition(cc.p(0, -20))
	self.text_level:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.text_level:addTo(self, 1)
end
function worldMapMonsterLod:initInstanceData(objData, worldInstanceData, instanceData)
	local monsterClassID = worldInstanceData.class
	local monsterLevel = worldMapDefine.getMonsterLevel(monsterClassID)
	self.text_level:setString(monsterLevel)
	local imgName = worldMapDefine.getMonsterIconLod(monsterClassID)
	if not imgName or string.len(imgName) <= 0 then
		imgName = "lod_monster.png"
	end
	self.monster:setSpriteFrame(imgName)
end
return worldMapMonsterLod
