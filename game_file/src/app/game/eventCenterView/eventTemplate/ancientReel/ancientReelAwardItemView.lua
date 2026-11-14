local ancientReelUtil = include("ancientReelUtil")
local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ANCIENT_REEL_AWARD_TYPE = ancientReelUtil.ANCIENT_REEL_AWARD_TYPE
local MAX_ROW_NUM = 4
local ancientReelAwardItemView = class("ancientReelAwardItemView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("ancientReelAwardItemView")
	end
	return target
end)
function ancientReelAwardItemView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Ancient_reel_text_11"))
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeTitle = SoraDGetChildByName(self.nodeReward, "Node_title")
	self.nodeTitle:setVisible(false)
	self.single = SoraDGetChildByName(self.nodeReward, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
end
function ancientReelAwardItemView:addItemList(data, awardType)
	if 0 < #data then
		_UPVALUE0_ = nil
		;(nil).awardType = awardType
		self.itemList[#self.itemList + 1], (nil).award = nil, data
	end
end
function ancientReelAwardItemView:initData(data)
	self.itemList, ancientReelUtil = nil, nil
	local addAward = ancientReelUtil.addAward
	local ancientReelUtil, itemGoldAward
	if not data.goldAward then
		ancientReelUtil = data.goldAward
	end
	addAward(data.goldAward, ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD, itemGoldAward)
	local ancientReelUtil, itemBronzeAward = addAward, addAward
	if not data.bronzeAward then
		ancientReelUtil = data.bronzeAward
	end
	addAward(data.bronzeAward, ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL, itemBronzeAward)
	if ancientReelCtrl:isActiveGold() then
		if not data.superLevelAward then
			ancientReelUtil = data.superLevelAward
		end
		addAward(data.superLevelAward, ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_SUPER, itemGoldAward)
	else
		if not data.superLevelAward then
			ancientReelUtil = data.superLevelAward
		end
		addAward(data.superLevelAward, ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_SUPER, itemBronzeAward)
	end
	self:addItemList(itemGoldAward, ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD)
	self:addItemList(itemBronzeAward, ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL)
	self:initScrollList()
end
function ancientReelAwardItemView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 140
function ancientReelAwardItemView:updateScrollPos()
	local listHeight = self.scrollH + 10
	local sSize = self.scroll:getContentSize()
	if listHeight <= 400 then
		self.scroll:setContentSize(cc.size(sSize.width, listHeight))
		self.scroll:setPositionY(listHeight * 0.5)
		local width = listHeight + 100
		self.ccs_bg:setSize(cc.size(600, width))
		self.ccs_bg:setPositionY(-width * 0.5)
		sSize = self.scroll:getContentSize()
	end
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function ancientReelAwardItemView:updateScrollData()
	for _, v in ipairs(self.itemList) do
		self:updateScrollData_imp(v.awardType, v.award)
	end
end
function ancientReelAwardItemView:updateScrollData_imp(taskType, itemInfo)
	self:getSingle_Title(taskType, #itemInfo)
	self:getSingle_AwardPanel(taskType, itemInfo)
end
local getAwardTypeTitle = function(awardType, num)
	if awardType == ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD then
		ANCIENT_REEL_AWARD_TYPE = nil
		;(nil).num = num
		return i18n("Ancient_reel_text_16", nil)
	else
		ANCIENT_REEL_AWARD_TYPE = nil
		;(nil).num = num
		return i18n("Ancient_reel_text_15", nil)
	end
end
function ancientReelAwardItemView:getSingle_Title(taskType, num)
	local single = self.nodeTitle:clone()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	local strTitle = getAwardTypeTitle(taskType, num)
	txtScoreTitle:setString(strTitle)
	single:setPositionY(-self.scrollH)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	return single
end
function ancientReelAwardItemView:getSingle_AwardPanel(taskType, itemInfo)
	local single = self.single:clone()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setPositionY(-self.scrollH)
	for k, v in ipairs(itemInfo) do
		local award = self:getSingle_AwardItem()
		award:initItem(v)
		local x = (k - 1) % MAX_ROW_NUM
		local y = math.floor((k - 1) / MAX_ROW_NUM)
		local posX = SoraDFPosX(185 - x * 120, 0, 600)
		local posy = y * SCROLL_ITEM_HEIGHT
		award:setPosition(cc.p(posX, -(self.scrollH + 80 + posy)))
	end
	self.scrollH = self.scrollH + math.ceil(#itemInfo / MAX_ROW_NUM) * SCROLL_ITEM_HEIGHT
end
function ancientReelAwardItemView:getSingle_AwardItem()
	local single = include("royalSummonsAwardItem").new()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setOwnView(self)
	local size = cc.size(55, 22)
	single:setTextWidthHeight(size)
	return single
end
return ancientReelAwardItemView
