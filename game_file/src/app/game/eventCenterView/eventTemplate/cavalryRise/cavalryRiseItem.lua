local cavalryRiseCtrl = SoraDGetCtrl("cavalryRiseCtrl")
local cavalryRiseItem = class("cavalryRiseItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("cavalryRiseItem")
	end
	if target ~= nil then
		local timerClass = include("commonItemAward")
		target = timerClass.new(target)
	end
	return target
end)
local cavalryRiseUtil = include("cavalryRiseUtil")
local CAVALRY_RISE_ITEM_TYPE = cavalryRiseUtil.CAVALRY_RISE_ITEM_TYPE
local CAVALRY_RISE_AWARD_TYPE = cavalryRiseUtil.CAVALRY_RISE_AWARD_TYPE
function cavalryRiseItem:ctor()
	self.nodeAward = SoraDGetChildByName(self, "Node_award")
	self.nodeGet = SoraDGetChildByName(self, "Node_get")
	self.frameGet = SoraDGetChildByName(self, "icon_g")
	self.frameGet:setSpriteFrame(SoraDGetCtrl("cavalryRiseCtrl"):getClassType() == 1 and "icon_g.png" or "icon_czhl_g.png")
	self.frameGet:setScale(SoraDGetCtrl("cavalryRiseCtrl"):getClassType() == 1 and 1 or 0.8)
end
function cavalryRiseItem:resetStatus()
	self.nodeAward:setVisible(false)
	self.nodeGet:setVisible(false)
	self:hideCoolSquare()
end
function cavalryRiseItem:setItemStatus(awardStatus, awardType)
	self.itemType = awardStatus
	self:resetStatus()
	if awardStatus == CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_GET then
		self:showCoolSquare()
	elseif awardStatus == CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_GOT then
		self.nodeGet:setVisible(true)
	elseif awardStatus == CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_NEED_ACTIVITY then
	end
end
return cavalryRiseItem
