local MAX_ROW_NUM = 4
local petraRareTreasureAwardView = class("petraRareTreasureAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("petraRareTreasureAwardView")
	end
	return target
end)
function petraRareTreasureAwardView:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_award")
	SoraDCreatAnimation("petraRareTreasureAwardView", self, false)
	self:setCloseCallBack(function()
		if self.showLuck then
			if self.isPyramid then
				self = nil
				;(nil).msg = "MESSAGE_SERVER_PYRAMID_TREASURE_EFFECT"
				;(nil).unlockedLuckyCoin = self.unlockedLuckyCoin
				SoraDSendMessage(nil)
			else
				local petraRareTreasureUtil = include("petraRareTreasureUtil")
				petraRareTreasureUtil:showAwardLuckey(self.unlockedLuckyCoin)
			end
			self:removeFromParent()
		end
	end)
end
function petraRareTreasureAwardView:initData(itemList, showLuck, unlockedLuckyCoin, isPyramid)
	self.itemList = itemList
	self.showLuck = showLuck
	self.unlockedLuckyCoin = unlockedLuckyCoin
	self.isPyramid = isPyramid
	dump(self.itemList, "self.itemList", 10)
	self:initScrollList()
end
function petraRareTreasureAwardView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
local SCROLL_ITEM_HEIGHT = 140
function petraRareTreasureAwardView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH + 0)
end
function petraRareTreasureAwardView:updateScrollData()
	for k, v in ipairs(self.itemList) do
		local award = self:getSingle_AwardItem()
		award:initItem(v)
		local x = (k - 1) % MAX_ROW_NUM
		local y = math.floor((k - 1) / MAX_ROW_NUM)
		local posX = SoraDFPosX(185 - x * 120, 0, 600)
		local posy = y * SCROLL_ITEM_HEIGHT
		award:setPosition(cc.p(posX, -(self.scrollH + 80 + posy)))
	end
	self.scrollH = self.scrollH + math.ceil(#self.itemList / MAX_ROW_NUM) * SCROLL_ITEM_HEIGHT
end
function petraRareTreasureAwardView:getSingle_AwardItem()
	local single = include("petraRareTreasureAwardItem").new()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setOwnView(self)
	local size = cc.size(55, 22)
	single:setTextWidthHeight(size)
	return single
end
return petraRareTreasureAwardView
