local worldMapIconLodBattery = class("worldMapIconLodBattery", include("worldMapIconLod"))
local palaceInfoRead = include("palaceInfoRead")
function worldMapIconLodBattery:ctor()
	worldMapIconLodBattery.super.ctor(self)
end
local gKWBattery = _G.gKWBattery
function worldMapIconLodBattery:initModelNode()
	if self.nodeMode then
		return
	end
	self.nodeMode = display.newNode()
	self:addChild(self.nodeMode, -1)
	self.modelImage = display.newSprite("#paotai_dj_n_01.png")
	self.nodeMode:addChild(self.modelImage, -1)
	self.modelImageMask = display.newSprite("#map_battery_mask_14.png")
	self.modelImageMask:setPosition(cc.p(65, 55))
	self.nodeMode:addChild(self.modelImageMask, -1)
end
function worldMapIconLodBattery:addCacheBefore()
	if self.nodeMode then
		self.nodeMode:setVisible(false)
	end
end
function worldMapIconLodBattery:initInstanceData(objData, worldInstanceData, instanceData)
	local instanceType = self:getInstanceType()
	if instanceType == gMapObjTypeDef.mapObjTypeKingdomLevelBuild then
		self.imgIcon:setSpriteFrame("Map_build_kingdomLv.png")
		self.imgIcon:setScale(0.8)
		self.imgIcon:setPosition(cc.p(-45, 115))
	elseif instanceType == gMapObjTypeDef.mapTypePyramidGloryBuild then
		self.imgIcon:setSpriteFrame("map_building_honor.png")
		self.imgIcon:setScale(0.8)
		self.imgIcon:setPosition(cc.p(5, 5))
	elseif instanceType == gMapObjTypeDef.mapObjTypeFortress then
		self.imgIcon:setSpriteFrame("Map_build_fort.png")
		self.imgIcon:setPosition(cc.p(0, 45))
	elseif instanceType == gMapObjTypeDef.mapObjTypeBattery then
		self.imgIcon:setScale(1.0)
		local classID = worldInstanceData.class
		local imgName = palaceInfoRead.getBatteryImg(classID)
		if imgName then
			self.imgIcon:setSpriteFrame(imgName)
			if classID == gKWBattery.NORTH then
				self.imgIcon:setPosition(cc.p(-50, 50))
			elseif classID == gKWBattery.SOUTH then
				self.imgIcon:setPosition(cc.p(-61, 98))
			elseif classID == gKWBattery.EAST then
				self.imgIcon:setPosition(cc.p(-67, 23))
				if not self.nodeMode then
					self:initModelNode()
				end
				self.nodeMode:setPosition(cc.p(-67, 23))
				self.nodeMode:setVisible(true)
				self.modelImage:setSpriteFrame("fytp_dj_w_001.png")
				self.modelImage:setPosition(cc.p(50, 86))
				self.modelImageMask:setSpriteFrame("map_battery_mask_14.png")
				self.modelImage:setFlippedX(true)
			elseif classID == gKWBattery.WEST then
				self.imgIcon:setPosition(cc.p(-59, 12))
				if not self.nodeMode then
					self:initModelNode()
				end
				self.nodeMode:setPosition(cc.p(-59, 12))
				self.nodeMode:setVisible(true)
				self.modelImage:setSpriteFrame("fytn_dj_w_001.png")
				self.modelImage:setPosition(cc.p(60, 100))
				self.modelImageMask:setSpriteFrame("map_battery_mask_14.png")
				self.modelImageMask:setPosition(cc.p(65, 55))
			end
		end
	end
end
function worldMapIconLodBattery:updateScaleChange(revertScale, scale)
end
return worldMapIconLodBattery
