local luxuryRebateDef = include("luxuryRebateDef")
local AWARD_STATUES = luxuryRebateDef.AWARD_STATUES
local luxuryRebateActivityItem = class("luxuryRebateActivityItem", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("luxuryRebateActivityItem")
	end
	if target ~= nil then
		local timerClass = include("commonItemAward")
		target = timerClass.new(target)
	end
	return target
end)
function luxuryRebateActivityItem:ctor()
	self.spStatues = SoraDGetChildByName(self, "Sprite_statues")
	self.panelForbid = SoraDGetChildByName(self, "panel_forbid")
	self.nodeStatus = SoraDGetChildByName(self, "Node_statues")
end
function luxuryRebateActivityItem:resetStatus()
	self.nodeStatus:setVisible(false)
end
function luxuryRebateActivityItem:setItemStatus(statue)
	if AWARD_STATUES.AWARD_STATUES_GET == statue then
		self.nodeStatus:setVisible(true)
		self.spStatues:setVisible(true)
		self.spStatues:setSpriteFrame("frame_csyx_gou01.png")
		self.spStatues:setScale(1.0)
		self.panelForbid:setVisible(false)
	elseif AWARD_STATUES.AWARD_STATUES_LOCK == statue then
		self.nodeStatus:setVisible(true)
		self.spStatues:setVisible(true)
		self.spStatues:setSpriteFrame("btn_cw_lock.png")
		self.spStatues:setScale(0.6)
		self.panelForbid:setVisible(true)
	elseif AWARD_STATUES.AWARD_STATUES_LOCK_DAY == statue then
		self.nodeStatus:setVisible(true)
		self.spStatues:setVisible(false)
		self.panelForbid:setVisible(true)
	else
		self.nodeStatus:setVisible(false)
	end
end
return luxuryRebateActivityItem
