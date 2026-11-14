local royalSummonsItem = class("royalSummonsItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("royalSummonsItem")
	end
	if target ~= nil then
		local timerClass = include("commonItemAward")
		target = timerClass.new(target)
	end
	return target
end)
local royalSummonsUtil = include("royalSummonsUtil")
local ROYAL_SUMMONS_ITEM_TYPE = royalSummonsUtil.ROYAL_SUMMONS_ITEM_TYPE
local ROYAL_SUMMONS_AWARD_TYPE = royalSummonsUtil.ROYAL_SUMMONS_AWARD_TYPE
local royalSummonsCtrl = SoraDGetCtrl("royalSummonsCtrl")
function royalSummonsItem:ctor()
	self.nodeAward = SoraDGetChildByName(self, "Node_award")
	self.nodeGet = SoraDGetChildByName(self, "Node_get")
	self.frameGet = SoraDGetChildByName(self, "icon_g")
	self.frameGet:setSpriteFrame(SoraDGetCtrl("royalSummonsCtrl"):getClassType() == 1 and "icon_g.png" or "icon_czhl_g.png")
	self.frameGet:setScale(SoraDGetCtrl("royalSummonsCtrl"):getClassType() == 1 and 1 or 0.8)
end
function royalSummonsItem:resetStatus()
	self.nodeAward:setVisible(false)
	self.nodeGet:setVisible(false)
	self:hideCoolSquare()
	if royalSummonsCtrl:getClassType() == 1 then
		royalSummonsCtrl:playCircleEffect(false, self)
	end
end
function royalSummonsItem:setItemStatus(itemType, isGold, awardType)
	self.itemType = itemType
	self:resetStatus()
	if itemType == ROYAL_SUMMONS_ITEM_TYPE.ROYAL_SUMMONS_ITEM_TYPE_AWARD then
		self:showCoolSquare()
	elseif itemType == ROYAL_SUMMONS_ITEM_TYPE.ROYAL_SUMMONS_ITEM_TYPE_ACTIVITY then
		self:showCoolSquare()
	elseif itemType == ROYAL_SUMMONS_ITEM_TYPE.ROYAL_SUMMONS_ITEM_TYPE_GET then
		self.nodeGet:setVisible(true)
	end
	if SoraDGetCtrl("royalSummonsCtrl"):getClassType() == 2 then
		self:hideCoolSquare()
	end
	if royalSummonsCtrl:getClassType() == 1 then
		local coolSquare = self:getCoolSquare()
		if royalSummonsCtrl:checkNeedShowHighLight(self.itemID) and (not coolSquare or not coolSquare:isVisible()) then
			royalSummonsCtrl:playCircleEffect(true, self)
		end
	end
	self:setGray(not isGold and awardType ~= ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL)
end
return royalSummonsItem
