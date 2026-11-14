local ancientReelItem = class("ancientReelItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("ancientReelItem")
	end
	if target ~= nil then
		local timerClass = include("commonItemAward")
		target = timerClass.new(target)
	end
	return target
end)
local ancientReelUtil = include("ancientReelUtil")
local ANCIENT_REEL_ITEM_TYPE = ancientReelUtil.ANCIENT_REEL_ITEM_TYPE
function ancientReelItem:ctor()
	self.nodeGet = SoraDGetChildByName(self, "Node_get")
	self.frameGet = SoraDGetChildByName(self, "icon_g")
	self.isGray = false
end
function ancientReelItem:resetStatus()
	self.nodeGet:setVisible(false)
	self:hideCoolSquare()
end
function ancientReelItem:updateGray(isGray)
	if isGray == self.isGray then
		return
	end
	self.isGray = isGray
	self:setGray(isGray)
end
function ancientReelItem:setItemStatus(itemType, isGold, awardType)
	self.itemType = itemType
	self:resetStatus()
	local isGray = false
	if itemType == ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_AWARD then
		self:showCoolSquare()
	elseif itemType == ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_ACTIVITY then
		self:showCoolSquare()
		self.nodeGet:setVisible(true)
		self.frameGet:setVisible(true)
		self.frameGet:setSpriteFrame("dh_Tex_hlflhd_003.png")
	elseif itemType == ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_GET then
		isGray = true
		self.nodeGet:setVisible(true)
		self.frameGet:setVisible(true)
		self.frameGet:setSpriteFrame("icon_g.png")
	elseif itemType == ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_LOCK then
		self.nodeGet:setVisible(true)
		self.frameGet:setVisible(true)
		self.frameGet:setSpriteFrame("dh_Tex_hlflhd_003.png")
	else
		self.nodeGet:setVisible(true)
		self.frameGet:setVisible(false)
	end
	self:updateGray(isGray)
end
return ancientReelItem
