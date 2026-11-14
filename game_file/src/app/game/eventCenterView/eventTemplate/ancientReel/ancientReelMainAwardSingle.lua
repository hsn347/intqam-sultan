local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ancientReelMainAwardSingle = class("ancientReelMainAwardSingle", function(target)
	return target
end)
local ancientReelUtil = include("ancientReelUtil")
local ANCIENT_REEL_AWARD_TYPE = ancientReelUtil.ANCIENT_REEL_AWARD_TYPE
local ANCIENT_REEL_ITEM_TYPE = ancientReelUtil.ANCIENT_REEL_ITEM_TYPE
function ancientReelMainAwardSingle:ctor()
	self.data, _ENV, self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil, nil, nil
	self.txtLevel = SoraDGetChildByName(self, "Text_award_lv")
	self.Panel_fg = SoraDGetChildByName(self, "Panel_fg")
	self.Sprite_bg = SoraDGetChildByName(self, "Sprite_bg")
	self.txtTip = SoraDGetChildByName(self, "Text_single_tip")
end
function ancientReelMainAwardSingle:initData(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
	end
	self.isLast = otherData.isLast
	self:recycleSingle()
	self:setAward()
end
function ancientReelMainAwardSingle:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = self:createItem()
	end
	single:setVisible(true)
	return single
end
function ancientReelMainAwardSingle:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function ancientReelMainAwardSingle:createItem()
	local single = include("ancientReelItem").new()
	single:setScale(0.7)
	single:setBaseScale(1.0)
	single:setOwnView(self.view)
	single:setOwnScroll(self.ownScroll)
	single:addTo(self, 100)
	return single
end
function ancientReelMainAwardSingle:resetStatus()
	self.Panel_fg:setVisible(false)
	self.Sprite_bg:setVisible(false)
end
function ancientReelMainAwardSingle:setItemStatus(itemType, num)
	self:resetStatus()
	if itemType == ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_AWARD then
		if 0 < num then
			self.Sprite_bg:setVisible(true)
		end
	elseif itemType == ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_NORMAL then
		self.Panel_fg:setVisible(true)
	end
end
function ancientReelMainAwardSingle:setAward_imp(award, itemType, posX, awardType, lv, posY)
	local offset = (#award + 1) % 2 * 45
	posY = posY or 55
	local totalWidth = 640
	for k, v in ipairs(award) do
		local single = self:getSingle()
		single:setPosition(SoraDFPosX(totalWidth - (posX - (k % 2 == 0 and 1 or -1) * offset), totalWidth), posY)
		single:initData(v.id, v.count)
		single:setItemStatus(itemType, ancientReelCtrl:isActiveGold(), awardType)
		table.insert(self.scrollItems, single)
	end
	_UPVALUE2_ = posX
	posX[1] = self.spScrollTitleNormal
	posX[2] = self.txtScrollTitleNormal
	ancientReelCtrl = self.txtScrollTitleNormal
	self.txtScrollTitleNormal[1] = 5
	_G.SoraDAlignNodeArrayOnCenterX(SoraDFPosX(posX, 0), posX, SoraDFIsRA(), self.txtScrollTitleNormal)
end
function ancientReelMainAwardSingle:setAward()
	local nodeTexture = SoraDGetChildByName(self, "Node_Texture")
	if nodeTexture then
		nodeTexture:setVisible(false)
	end
	if self.data.award then
		local awardType = ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_SUPER
		local itemType = ancientReelCtrl:getAwardItemStatus(awardType)
		self:setAward_imp(self.data.award, itemType, 140, awardType)
		self.txtLevel:setString("50+")
		self:setItemStatus(itemType, #self.data.award)
		self.txtTip:setString(i18n("summoned_text_45"))
		self.txtTip:setVisible(true)
	else
		self.txtTip:setVisible(false)
		local lv = self.data.lv
		do
			local awardType = ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_NORMAL
			local itemType = ancientReelCtrl:getAwardItemStatus(awardType, lv)
			self:setAward_imp(self.data.bronzeAward, itemType, 140, awardType, lv)
			self:setItemStatus(itemType, #self.data.bronzeAward)
		end
		do
			local awardType = ANCIENT_REEL_AWARD_TYPE.ANCIENT_REEL_AWARD_TYPE_GOLD
			local itemType = ancientReelCtrl:getAwardItemStatus(awardType, lv)
			self:setAward_imp(self.data.goldAward, itemType, 500, awardType, lv)
			if itemType == ANCIENT_REEL_ITEM_TYPE.ANCIENT_REEL_ITEM_TYPE_AWARD then
				self:setItemStatus(itemType, #self.data.goldAward)
			end
		end
		self.txtLevel:setString(lv)
	end
end
return ancientReelMainAwardSingle
