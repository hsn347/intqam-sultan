local lordLocalData = include("lordLocalData")
local lordSpineDef = include("lordSpineDef")
local LordChangeHeadSingle = class("lordChangeHeadSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("lordChangeHeadSingle")
	end
	return target
end)
function LordChangeHeadSingle:ctor()
	self.spriteHead = SoraDGetChildByName(self, "Sprite_head")
	self.imageID = 0
end
function LordChangeHeadSingle:initData(imageID)
	self.imageID = imageID
	local info = lordSpineDef.getLordSpineInfo(self.imageID)
	if info then
		if self.spine then
			self.spine:removeFromParent()
			self.spine = nil
		end
		self.spriteHead:setVisible(false)
		self.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
		local offset = info.offset or cc.p(0, 0)
		self.spine:setPosition(cc.p(0 + offset.x, -240 + offset.y))
		self.spine:setAnimation(0, "animation", true)
		self.spine:addTo(self, 9)
		self.spine:setScale(display.height > 1136 and 1 or display.height / 1136)
	else
		self.spriteHead:setVisible(true)
		self.spriteHead:setScale(display.height > 1136 and 1 or display.height / 1136)
		self.spriteHead:setSpriteFrame(lordLocalData.getPortrait(self.imageID))
	end
end
function LordChangeHeadSingle:setColor(...)
	if self.spine then
		self.spine:setColor(...)
	else
		self.spriteHead:setColor(...)
	end
end
function LordChangeHeadSingle:setOpacity(...)
	if self.spine then
		self.spine:setOpacity(...)
	else
		self.spriteHead:setOpacity(...)
	end
end
return LordChangeHeadSingle
