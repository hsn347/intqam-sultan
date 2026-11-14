local unchartedAdventureRead = include("unchartedAdventureRead")
local unchartedRewardView = class("unchartedRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("unchartedRewardView")
	end
	return target
end)
local PANEL_HEIGHT = 50
function unchartedRewardView:ctor()
	self:initControls()
	self:initScroll()
end
function unchartedRewardView:initControls()
	self.panelCell = SoraDGetChildByName(self, "panel_cell")
	self.panelMegalo = SoraDGetChildByName(self, "panel_megalo")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.scroll = SoraDGetChildByName(self, "scrollview_content")
	self.ccs_bg:setTitleName(i18n("Secret_explore_text_03"))
	self.ccs_bg:setSize(cc.size(550, 680))
	self.panelMegalo:setPositionY(display.height / 2)
	self.ccs_bg.Panel_cut:setPosition(cc.p(275, display.height / 6))
	self.scroll:setContentSize(cc.size(530, 590))
	if display.height > 960 then
		self.scroll:setPosition(275, display.height / 6 * 2.51)
	else
		self.scroll:setPosition(275, display.height / 6 * 2.79)
	end
	if device.isIphoneXMode() then
		self.scroll:setPosition(275, display.height / 6 * 2.35)
	end
	self.rewardlist = unchartedAdventureRead.getClearanceReward()
end
function unchartedRewardView:initScroll()
	self.scroll:removeAllChildren()
	local totalHeight = 0
	local _ENV, everyHeightTable = self.scroll, self.scroll
	for i = 1, #self.rewardlist do
		table.insert(everyHeightTable, totalHeight)
		totalHeight = totalHeight + math.ceil(#self.rewardlist[i] / 4) * 70 + PANEL_HEIGHT
	end
	local scrollH = math.max(totalHeight, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(display.width, scrollH))
	for i = 1, #self.rewardlist do
		local panel = self.panelCell:clone()
		panel:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - everyHeightTable[i]))
		panel:addTo(self.scroll)
		local textTitle = SoraDGetChildByName(panel, "Text_grade")
		_ENV = cc.p(self.scroll:getContentSize().width / 2, scrollH - everyHeightTable[i])
		cc.p(self.scroll:getContentSize().width / 2, scrollH - everyHeightTable[i]).level = i
		textTitle:setString(i18n("common_text_1721", cc.p(self.scroll:getContentSize().width / 2, scrollH - everyHeightTable[i])))
		if i == #self.rewardlist then
			_ENV = i18n("common_text_1721", cc.p(self.scroll:getContentSize().width / 2, scrollH - everyHeightTable[i]))
			i18n("common_text_1721", cc.p(self.scroll:getContentSize().width / 2, scrollH - everyHeightTable[i])).Num = i
			textTitle:setString(i18n("Secret_explore_text_50", i18n("common_text_1721", cc.p(self.scroll:getContentSize().width / 2, scrollH - everyHeightTable[i]))))
		end
		for j = 1, #self.rewardlist[i] / 2 do
			local itemKey = self.rewardlist[i][2 * j - 1]
			local itemCount = self.rewardlist[i][2 * j]
			local singleItem = include("itemSingleView").new()
			singleItem:setScale(0.65)
			singleItem:setItemDelegate(handler(self, self.singleItemClick))
			singleItem:setRechargeUse(true)
			singleItem:setButtonTag(itemKey)
			singleItem:setScroll(self.scroll)
			singleItem:sendParentToButton(self)
			if 1 < math.ceil(j / 4) then
				singleItem:setPosition(cc.p(40 + 120 * (math.floor(j % 4) - 1), panel:getPositionY() - 80 * math.ceil(j / 4)))
			else
				singleItem:setPosition(cc.p(40 + 120 * (j - 1), panel:getPositionY() - 50 * math.ceil(j / 4)))
			end
			singleItem:addTo(self.scroll)
			singleItem:initRechargeForRewardData(itemKey, itemCount)
		end
	end
end
return unchartedRewardView
