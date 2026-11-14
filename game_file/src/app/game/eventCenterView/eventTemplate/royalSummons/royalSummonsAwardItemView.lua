local royalSummonsUtil = include("royalSummonsUtil")
local royalSummonsRead = include("royalSummonsRead")
local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local ROYAL_SUMMONS_AWARD_TYPE = royalSummonsUtil.ROYAL_SUMMONS_AWARD_TYPE
local MAX_ROW_NUM = 4
local royalSummonsAwardItemView = class("royalSummonsAwardItemView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("royalSummonsAwardItemView")
	end
	return target
end)
function royalSummonsAwardItemView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("summoned_text_20"))
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeTitle = SoraDGetChildByName(self.nodeReward, "Node_title")
	self.nodeTitle:setVisible(false)
	self.single = SoraDGetChildByName(self.nodeReward, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
end
function royalSummonsAwardItemView:addItemList(data, awardType)
	if 0 < #data then
		_UPVALUE0_ = nil
		;(nil).awardType = awardType
		self.itemList[#self.itemList + 1], (nil).award = nil, data
	end
end
function royalSummonsAwardItemView:initData(data)
	self.itemList, royalSummonsUtil = nil, nil
	local addAward = royalSummonsUtil.addAward
	local royalSummonsUtil, itemGoldAward
	if not data.goldAward then
		royalSummonsUtil = data.goldAward
	end
	addAward(data.goldAward, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD, itemGoldAward)
	local royalSummonsUtil, itemBronzeAward = addAward, addAward
	if not data.bronzeAward then
		royalSummonsUtil = data.bronzeAward
	end
	addAward(data.bronzeAward, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL, itemBronzeAward)
	if royalSummonsCtrl:isActiveGold() then
		if not data.superLevelAward then
			royalSummonsUtil = data.superLevelAward
		end
		addAward(data.superLevelAward, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_SUPER, itemGoldAward)
	else
		if not data.superLevelAward then
			royalSummonsUtil = data.superLevelAward
		end
		addAward(data.superLevelAward, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_SUPER, itemBronzeAward)
	end
	self:addItemList(itemGoldAward, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD)
	self:addItemList(itemBronzeAward, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL)
	self:initScrollList()
end
function royalSummonsAwardItemView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 140
function royalSummonsAwardItemView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function royalSummonsAwardItemView:updateScrollData()
	for _, v in ipairs(self.itemList) do
		self:updateScrollData_imp(v.awardType, v.award)
	end
end
function royalSummonsAwardItemView:updateScrollData_imp(taskType, itemInfo)
	self:getSingle_Title(taskType, #itemInfo)
	self:getSingle_AwardPanel(taskType, itemInfo)
end
local getAwardTypeTitle = function(awardType, num)
	if awardType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		ROYAL_SUMMONS_AWARD_TYPE = nil
		;(nil).num = num
		return i18n("summoned_text_21", nil)
	else
		ROYAL_SUMMONS_AWARD_TYPE = nil
		;(nil).num = num
		return i18n("summoned_text_22", nil)
	end
end
function royalSummonsAwardItemView:getSingle_Title(taskType, num)
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
function royalSummonsAwardItemView:getSingle_AwardPanel(taskType, itemInfo)
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
function royalSummonsAwardItemView:getSingle_AwardItem()
	local single = include("royalSummonsAwardItem").new()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setOwnView(self)
	local size = cc.size(55, 22)
	single:setTextWidthHeight(size)
	return single
end
return royalSummonsAwardItemView
