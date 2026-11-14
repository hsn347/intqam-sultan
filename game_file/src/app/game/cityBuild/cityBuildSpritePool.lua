cityBuildSpritePool, _ENV = nil, nil
cityBuildSpritePool.tblCollectSpritePool, _ENV = nil, nil
function cityBuildSpritePool:init()
	if self.isInit == true then
		return
	end
	if display.getAnimationCache("animation_iron") ~= nil then
	else
		local frames = display.newFrames("iron_%d.png", 1, 5)
		local animation = display.newAnimation(frames, 0.05)
		display.setAnimationCache("animation_iron", animation)
	end
	if display.getAnimationCache("animation_steel") ~= nil then
	else
		local frames = display.newFrames("stone_%d.png", 1, 5)
		local animation = display.newAnimation(frames, 0.05)
		display.setAnimationCache("animation_steel", animation)
	end
	if display.getAnimationCache("animation_food") ~= nil then
	else
		local frames = display.newFrames("food_%d.png", 1, 5)
		local animation = display.newAnimation(frames, 0.05)
		display.setAnimationCache("animation_food", animation)
	end
	if display.getAnimationCache("animation_wood") ~= nil then
	else
		local frames = display.newFrames("wood_%d.png", 1, 5)
		local animation = display.newAnimation(frames, 0.05)
		display.setAnimationCache("animation_wood", animation)
	end
	if display.getAnimationCache("animation_crystal") ~= nil then
	else
		local frames = display.newFrames("shuijingkuang_%02d.png", 1, 5)
		local animation = display.newAnimation(frames, 0.05)
		display.setAnimationCache("animation_crystal", animation)
	end
	for i = 1, 20 do
		local spriteName = "#food_1.png"
		local sprite = display.newSprite(spriteName)
		self:addToSpritePool(sprite)
	end
end
function cityBuildSpritePool:cleanSpritePool(spritePool)
	local count = 0
	for i, v in ipairs(spritePool) do
		if v then
			v:stopAllActions()
			v:release()
			count = count + 1
		end
	end
	return count
end
function cityBuildSpritePool:removeAll()
	local count = 0
	self.tblCollectSpritePool, _ENV, count = self:cleanSpritePool(self.tblCollectSpritePool), self:cleanSpritePool(self.tblCollectSpritePool), count + self:cleanSpritePool(self.tblCollectSpritePool)
	self.isInit = false
	local batchNodeCollect = display.getRunningScene():getChildByName("mainCityView_batchNode_collect")
	if batchNodeCollect ~= nil and not tolua.isnull(batchNodeCollect) then
		batchNodeCollect:removeAllChildren(true)
		batchNodeCollect:stopAllActions()
	end
	display.removeAnimationCache("animation_iron")
	display.removeAnimationCache("animation_steel")
	display.removeAnimationCache("animation_food")
	display.removeAnimationCache("animation_wood")
	display.removeAnimationCache("animation_crystal")
	self:dump()
end
function cityBuildSpritePool:getSprite(buildID)
	local ret
	local isNeedRelease = false
	local spritePool = self.tblCollectSpritePool
	if 0 < #spritePool then
		ret = spritePool[#spritePool]
		table.remove(spritePool, #spritePool)
		isNeedRelease = true
		return ret, isNeedRelease
	end
	local spriteName = "#food_1.png"
	local bid
	if bid == BUILDID.IRON_MINE then
		spriteName = "#iron_1.png"
	elseif bid == BUILDID.STEEL then
		spriteName = "#stone_1.png"
	elseif bid == BUILDID.FARM then
		spriteName = "#food_1.png"
	elseif bid == BUILDID.SAWMILL then
		spriteName = "#wood_1.png"
	elseif bid == BUILDID.CRYSTAL_MINE then
		spriteName = "#food_1.png"
	end
	local sprite = display.newSprite(spriteName)
	isNeedRelease = false
	return sprite, isNeedRelease
end
function cityBuildSpritePool:addToSpritePool(node)
	table.insert(self.tblCollectSpritePool, #self.tblCollectSpritePool + 1, node)
	node:setScale(1)
	node:retain()
end
function cityBuildSpritePool:dump()
	do return end
	print("================cityBuildSpritePool:dump()====================:")
	print("当前回收池情况:")
	print("精灵: 通用, 个数", #self.tblCollectSpritePool)
	print("===================================================:")
end
return cityBuildSpritePool
