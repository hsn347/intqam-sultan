local FPRD = require_data("feast_point_reward", true)
local PFPRD = require_data("party_feast_point_reward_data")
local partyRankRuleView = class("partyRankRuleView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("partyRankRuleView")
	end
	return target
end)
function partyRankRuleView:ctor()
	self:initControls()
end
function partyRankRuleView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.scroll = SoraDGetChildByName(self, "scroll_view")
	SoraDGetChildByName(self, "desc_label"):setString(i18n("feast_text_17"))
	SoraDGetChildByName(self, "title_label"):setString(i18n("common_text_1173"))
	if display.height > 960 then
		self.panel:setPositionY(700)
	end
	self:initScroll()
end
function partyRankRuleView:initScroll()
	local rangeNum = #PFPRD.data[1]
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollMinH = self.scroll:getContentSize().height
	local scrollW = scrollInner:getContentSize().width
	print("scrollW", scrollW)
	local scrollH = math.max(scrollMinH, rangeNum * 135)
	local defaultItem = SoraDGetChildByName(self, "default_node")
	for i = 1, rangeNum do
		node = defaultItem:clone()
		node:addTo(self.scroll)
		node:setTag(i)
		node:setPosition(260, scrollH - i * 135)
		node:setVisible(true)
		self:updateRankNode(node, i)
	end
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollH))
end
function partyRankRuleView:getRuleInfo(index)
	if PFPRD.data[1][index] then
		return FPRD.data[PFPRD.data[1][index]]
	end
end
function partyRankRuleView:updateRankNode(node, index)
	local info = self:getRuleInfo(index)
	if not info then
		node:setVisible(false)
		return
	end
	local title = node:getChildByName("rank_range")
	if info.PointParam[1] ~= info.PointParam[2] then
		_ENV = nil
		;(nil).min = info.PointParam[1]
		;(nil).max = info.PointParam[2]
		title:setString(i18n("common_text_1770", nil))
	else
		_ENV = i18n("common_text_1770", nil)
		i18n("common_text_1770", nil).num = info.PointParam[1]
		title:setString(i18n("common_text_617", i18n("common_text_1770", nil)))
	end
	local maxNum = #info.PointReward
	for i = 1, maxNum, 2 do
		local itemId = info.PointReward[i]
		local itemNum = info.PointReward[i + 1]
		local singleItem = include("itemSingleView").new()
		singleItem:setRechargeUse(true)
		singleItem:setButtonTag(itemId)
		singleItem:sendParentToButton(self)
		singleItem:setScale(0.6)
		singleItem:addTo(node)
		singleItem:setPosition(cc.p(50 * (i - 1) - 245, 100))
		_ENV = singleItem.setPosition
		singleItem.setPosition.id = itemId
		local singleItem.setPosition.count, itemInfo = itemNum, singleItem.setPosition
		_ENV = cc.p(50 * (i - 1) - 245, 100)
		cc.p(50 * (i - 1) - 245, 100).itemData = itemInfo
		singleItem:initData(cc.p(50 * (i - 1) - 245, 100))
	end
end
return partyRankRuleView
