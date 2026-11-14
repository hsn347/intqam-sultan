local pyramidTreasureRewardView = class("pyramidTreasureRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidTreasureRewardView")
	end
	return target
end)
function pyramidTreasureRewardView:ctor()
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("Pyramid_treasure_text_07"))
end
function pyramidTreasureRewardView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function pyramidTreasureRewardView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function pyramidTreasureRewardView:initData(reward)
	for k, v in ipairs(reward) do
		local item = include("pyramidTreasureRewardSingle").new()
		item:initData(k, v, self)
		item:setPosition(0, 0)
		item:addTo(self.Node_items)
	end
	SoraDautoSortPos(self.Node_items, 5, 1, cc.size(100, 130), not SoraDFIsRA())
end
return pyramidTreasureRewardView
