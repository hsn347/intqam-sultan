local gametop = gModuleMgr.getObject("gametop")
local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
local eventFlowerAwardView = class("eventFlowerAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventFlowerAwardView")
	end
	return target
end)
function eventFlowerAwardView:ctor()
	self.rankAward, _ENV = nil, nil
	self:setBackGround(0)
	self.lab_title = SoraDGetChildByName(self, "Text_title")
	self.lab_title:setString(i18n("common_text_2078"))
	SoraDGetChildByName(self, "Size_Tile_image_bg"):setFillType(1)
	SoraDGetChildByName(self, "Tile_Size_Image_zhuzi_left"):setFillType(1)
	SoraDGetChildByName(self, "Tile_Size_Image_zhuzi_right"):setFillType(1)
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_award")
end
function eventFlowerAwardView:initView(style)
	self.rankAward = newActivityCtrl:getFlowerActivityRankAward(style)
	self:initScroll()
end
function eventFlowerAwardView:initScroll()
	self.curCount = 0
	local dataNum = table.nums(self.rankAward)
	local singleHeight = 160
	local totalHeight = 0
	local _ENV, singleArray
	for k = 1, dataNum do
		local single = self:getSingle()
		single.setRank(self.rankAward[k].ranking)
		single.setAward(self.rankAward[k].award)
		totalHeight = totalHeight + single.realHeight
		singleArray[k] = single
	end
	local scrollH = math.max(self.scroll:getContentSize().height, totalHeight)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	local tempHeight = 0
	for k, v in ipairs(singleArray) do
		v:setPosition(cc.p(0, scrollH - tempHeight))
		tempHeight = tempHeight + v.realHeight
		v:addTo(self.scroll)
	end
end
function eventFlowerAwardView:getSingle()
	local single = SoraDGetChildByName(self, "Panel_single"):clone()
	local Node_title = SoraDGetChildByName(single, "Node_title")
	single.realHeight = 63
	function single.setRank(rank)
		local Text_rank = SoraDGetChildByName(single, "Text_rank")
		if rank[1] == rank[2] then
			_ENV = nil
			;(nil).num = rank[1]
			Text_rank:setString(i18n("common_text_617", nil))
		else
			_ENV = i18n("common_text_617", nil)
			i18n("common_text_617", nil).min = rank[1]
			i18n("common_text_617", nil).max = rank[2]
			Text_rank:setString(i18n("common_text_1770", i18n("common_text_617", nil)))
		end
	end
	function single.setAward(award)
		local totalRow = math.ceil(#award / 8)
		single.realHeight = single.realHeight + totalRow * 100 * 0.85 + 25 * totalRow
		single:setContentSize(cc.size(single:getContentSize().width, single.realHeight))
		Node_title:setPositionY(single.realHeight - 32)
		for i = 1, #award - 1, 2 do
			do
				local line = math.ceil(i / 2) % 4
				if line == 0 then
					line = 4
				end
				if SoraDFIsRA() then
					line = 5 - line
				end
				local row = math.ceil(i / 8)
				self.curCount = self.curCount + 1
				local createItemFunc = function()
					local rewardItem = include("commonItemAward").new()
					rewardItem:setScale(0.85)
					rewardItem:setBaseScale(1.0)
					rewardItem:addTo(single)
					rewardItem:setScroll(self.scroll)
					rewardItem:setOwnView(self)
					rewardItem:initData(award[i], award[i + 1])
					rewardItem:setPosition(cc.p(110 * (line - 1) + 90, single.realHeight - 110 * (row - 1) - 120))
				end
				if self.curCount >= 16 then
					single = cc.size(single:getContentSize().width, single.realHeight)
					cc.size(single:getContentSize().width, single.realHeight)[1] = cca.delay(0.016666666666666666 * (self.curCount - 16))
					cc.size(single:getContentSize().width, single.realHeight)[2] = cca.callFunc(createItemFunc)
					cc.size(single:getContentSize().width, single.realHeight)[3] = cca.callFunc(createItemFunc)
					self:runAction(cca.seq(cc.size(single:getContentSize().width, single.realHeight)))
				else
					createItemFunc()
				end
			end
		end
	end
	return single
end
return eventFlowerAwardView
