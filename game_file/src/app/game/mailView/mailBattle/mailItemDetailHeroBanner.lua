local heroCtrl = SoraDGetCtrl("heroCtrl")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailItemDetailHeroBanner = class("mailItemDetailHeroBanner", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailHeroBanner")
end)
function mailItemDetailHeroBanner:ctor(properties)
	self:setCascadeOpacityEnabled(true)
	self.itemWidth = gMailDetaiViewWidth
	self.layout_content = SoraDGetChildByName(self, "Panel")
	self.imgLine = SoraDGetChildByName(self.layout_content, "Image_line")
	self.nodeHero = SoraDGetChildByName(self.layout_content, "Node_Hero")
	self.nodeL = SoraDGetChildByName(self.layout_content, "Node_L")
	SoraDGetChildByName(self.nodeL, "Text_Title"):setString(i18n("lieutenant_text_01"))
end
function mailItemDetailHeroBanner:initData(info)
	dump(info, "info")
	if not info.heroInfo then
		_ENV = info.heroInfo
	end
	if not info.armsInfo then
		_ENV = info.armsInfo
	end
	if not info.divineBeastInfo then
		local _ENV, heros, arms, divineBeasts = info.divineBeastInfo, info.heroInfo, info.armsInfo, info.divineBeastInfo
	end
	local lieuTenant = heroCtrl:getLieutenantByHeroList(heros)
	local heroHeight = 0 < #heros and 100 or 0
	local num = 0
	if arms and next(arms) and arms[1] then
		local armsSingle = include("heroArtifactItem").new()
		armsSingle:addTo(self.nodeHero)
		armsSingle:setPosition(0, 0)
		armsSingle:setScale(0.78)
		armsSingle:initData(arms)
		heroHeight = 100
		num = num + 1
	end
	for _, v in ipairs(heros) do
		local heroSingle = include("heroEpicItem").new()
		heroSingle:addTo(self.nodeHero)
		heroSingle:setScale(0.65)
		heroSingle:setPosition(0, 0)
		heroSingle:initData(v, mailMgr:getScrollParent())
	end
	num = #heros + num
	for _, v in ipairs(divineBeasts) do
		local single = include("commonDivinebeast").new()
		single:addTo(self.nodeHero)
		single:setScale(0.8)
		single:setPosition(0, 0)
		single:initData(v, 1)
	end
	num = #divineBeasts + num
	dump(num, "SoraDToCenter")
	if num <= 6 then
		heroHeight = 100
		SoraDToCenter(self.nodeHero, 100, SoraDFIsRA())
	else
		heroHeight = 100 * math.ceil(num / 6)
		SoraDautoSortPos(self.nodeHero, 6, SoraDFIsRA() and 0 or 2, cc.size(100, 100), SoraDFIsRA())
	end
	local lHeight = self:initLieutenant(lieuTenant)
	local totalHeight = lHeight + heroHeight
	dump(lHeight + heroHeight, "lHeight+heroHeight")
	self.nodeL:setPositionY(lHeight)
	self.nodeHero:setPositionY(totalHeight - heroHeight / 2)
	self.layout_content:setContentSize(cc.size(self.itemWidth, totalHeight))
	self.itemHeight = totalHeight
end
function mailItemDetailHeroBanner:initLieutenant(data)
	if #data <= 0 or not commonCheck.HERO_COMBOS_SKILL then
		self.nodeL:setVisible(false)
		return 0
	end
	self.nodeL:setVisible(true)
	local nodeHero = SoraDGetChildByName(self.nodeL, "Node_Hero")
	for _, v in ipairs(data) do
		local heroSingle = include("heroEpicItem").new()
		heroSingle:addTo(nodeHero)
		heroSingle:setScale(0.65)
		heroSingle:setPosition(0, 0)
		heroSingle:initData(v, mailMgr:getScrollParent())
	end
	SoraDToCenter(nodeHero, 100, SoraDFIsRA())
	return 130
end
function mailItemDetailHeroBanner:getItemWidth()
	return self.itemWidth
end
function mailItemDetailHeroBanner:getItemHeight()
	return self.itemHeight
end
return mailItemDetailHeroBanner
