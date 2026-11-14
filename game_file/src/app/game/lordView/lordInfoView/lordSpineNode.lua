local lordSpineDef = include("lordSpineDef")
local lordLocalData = include("lordLocalData")
local lordSpineNode = class("lordSpineNode", function()
	return display.newNode()
end)
function lordSpineNode:ctor()
	self.imageId = nil
	self.spine = nil
	local sprite = display.newSprite()
	sprite:addTo(self)
	sprite:setVisible(false)
	self.spritePortrait = sprite
end
function lordSpineNode:initData(imageId)
	local info = lordSpineDef.getLordSpineInfo(imageId)
	if info then
		if self.spine then
			self.spine:setVisible(true)
		end
		self.spritePortrait:setVisible(false)
		if self.imageId == imageId then
			return
		end
		self.imageId = imageId
		if self.spine then
			self.spine:removeFromParent()
			self.spine = nil
		end
		self.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
		local offset = info.offset or cc.p(0, 0)
		self.spine:setPosition(cc.p(offset.x, -260 + offset.y))
		self.spine:setAnimation(0, "animation", true)
		self.spine:addTo(self)
	else
		if self.spine then
			self.spine:setVisible(false)
		end
		self.spritePortrait:setVisible(true)
		if self.imageId == imageId then
			return
		end
		self.imageId = imageId
		self.spritePortrait:setSpriteFrame(lordLocalData.getPortrait(imageId))
	end
end
return lordSpineNode
