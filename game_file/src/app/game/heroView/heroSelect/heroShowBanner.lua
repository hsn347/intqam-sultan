local HeroShowBanner = class("heroShowBanner", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroShowBanner")
	end
	return target
end)
function HeroShowBanner:ctor()
	self.myTbl, _ENV = nil, nil
	self.items = SoraDGetChildsArrayByName(self, "CCS_heroEpicItem_", 5, 1, true, true)
	self.Image_line = SoraDGetChildByName(self, "Image_line")
	if self.Image_line then
		self.Image_line:setVisible(false)
	end
	self.armsSingle = SoraDGetChildByName(self, "Node_skill")
	self.armsSingle:setVisible(false)
	self.nodeL = SoraDGetChildByName(self, "Node_L")
	SoraDGetChildByName(self.nodeL, "Text_Title"):setString(i18n("lieutenant_text_01"))
end
function HeroShowBanner:initData(tbl, scroll, alignLR)
	self.myTbl = tbl
	self.scroll = scroll
	self:initView(alignLR)
	self:initLieutenant(SoraDGetCtrl("heroCtrl"):getLieutenantByHeroList(self.myTbl))
end
function HeroShowBanner:setLineVisible(ret)
	if self.Image_line then
		self.Image_line:setVisible(ret)
	end
end
function HeroShowBanner:initView(alignLR)
	local _ENV, showOcx
	for i, v in ipairs(self.items) do
		if self.myTbl and self.myTbl[i] then
			v:initData(self.myTbl[i], self.scroll)
			v:setVisible(true)
			table.insert(showOcx, v)
		else
			v:setVisible(false)
		end
	end
	if self.armsSingle:isVisible() then
		table.insert(showOcx, 1, self.armsSingle)
	end
	local posX = 5 < #showOcx and 108 or 120
	if alignLR then
		local startPosx = (5 < #showOcx and 2.5 or 2) * posX
		for i, v in ipairs(showOcx) do
			v:setPositionX(SoraDFSign(startPosx - (i - 1) * posX))
		end
	else
		local startPosx = #showOcx * posX / 2
		for i, v in ipairs(showOcx) do
			v:setPositionX(SoraDFSign(startPosx - (i - 1) * posX - posX / 2))
		end
	end
end
function HeroShowBanner:initArmsView(armsData)
	if armsData and next(armsData) and armsData[1] then
		SoraDGetChildByName(self.armsSingle, "Sprite_skill"):setSpriteFrame(include("equipDesRead").getArtifactIcon(armsData[1].armsID))
		SoraDGetChildByName(self.armsSingle, "Text_lv"):setString(tostring(armsData[1].level))
		self.armsSingle:setVisible(true)
	else
		self.armsSingle:setVisible(false)
	end
end
function HeroShowBanner:initLieutenant(data)
	if #data <= 0 or not commonCheck.HERO_COMBOS_SKILL then
		self.nodeL:setVisible(false)
		return 0
	end
	self.nodeL:setVisible(true)
	local nodeHero = SoraDGetChildByName(self.nodeL, "Node_Hero")
	for _, v in ipairs(data) do
		local heroSingle = include("heroEpicItem").new()
		heroSingle:addTo(nodeHero)
		heroSingle:setScale(0.8)
		heroSingle:setPosition(0, 0)
		heroSingle:initData(v, self.scroll)
	end
	SoraDToCenter(nodeHero, 120, SoraDFIsRA())
end
function HeroShowBanner:getExtendHeight()
	local height = 0
	if self.nodeL:isVisible() then
		height = 126
	end
	return height * self:getScale()
end
return HeroShowBanner
