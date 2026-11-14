local ancientReelRead = include("ancientReelRead")
local MAX_ROW_NUM = 4
local ancientReelAwardPreviewView = class("ancientReelAwardPreviewView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("ancientReelAwardPreviewView")
	end
	return target
end)
function ancientReelAwardPreviewView:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.txtTips = SoraDGetChildByName(self, "Text_tips")
	SoraDSetTextWidthHeight(self.txtTips, cc.size(500, 60))
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_award")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	_G.SoraDCreatAnimationEx(self.__cname, self, true)
end
function ancientReelAwardPreviewView:initData(isGold)
	self.itemList, _ENV, self.isGold = nil, nil, isGold
	local insertAward = function(itemData, lv)
		local awardList = self.itemList
		for _, v in ipairs(itemData) do
			self = nil
			;(nil).id = v.id
			;(nil).count = v.count
			awardList[#awardList + 1], (nil).lv = nil, lv
		end
	end
	if not ancientReelRead:getLevelList() then
		local _ENV, awardShowList = ancientReelRead:getLevelList(), ancientReelRead:getLevelList()
	end
	for _, v in ipairs(awardShowList) do
		local award
		if isGold then
			award = v.goldAward
		else
			award = v.bronzeAward
		end
		if award then
			insertAward(award, v.index)
		end
	end
	dump(self.itemList, "self.itemList", 10)
	self:initScrollList()
end
function ancientReelAwardPreviewView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 140
function ancientReelAwardPreviewView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function ancientReelAwardPreviewView:updateScrollData()
	self:updateScrollData_imp(self.itemList)
end
function ancientReelAwardPreviewView:updateScrollData_imp(itemInfo)
	if self.isGold then
		self.txtTips:setString(i18n("Ancient_reel_text_13"))
		self.textTitle:setString(i18n("Ancient_reel_text_02"))
	else
		self.txtTips:setString(i18n("Ancient_reel_text_05"))
		self.textTitle:setString(i18n("Ancient_reel_text_01"))
	end
	local height = self.txtTips:getContentSize().height
	self.txtTips:setVisible(true)
	self.txtTips:setPositionY(-self.scrollH)
	self.scrollH = self.scrollH + height
	self:getSingle_AwardPanel(itemInfo)
end
function ancientReelAwardPreviewView:getSingle_AwardPanel(itemInfo)
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
function ancientReelAwardPreviewView:getSingle_AwardItem()
	local single = include("royalSummonsAwardItem").new()
	single:addTo(self.nodeReward)
	single:setCascadeOpacityEnabled(true)
	single:setVisible(true)
	single:setOwnView(self)
	local size = cc.size(55, 22)
	single:setTextWidthHeight(size)
	return single
end
return ancientReelAwardPreviewView
