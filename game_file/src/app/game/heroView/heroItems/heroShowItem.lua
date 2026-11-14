local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local HeroShowItem = class("heroShowItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroShowItem")
	end
	return target
end)
function HeroShowItem:ctor()
	self.btnHead = SoraDGetChildByName(self, "Button_click")
	self.spHeroHead = SoraDGetChildByName(self, "Sprite_head")
	self.spHeadBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.btnHead:addTouchEventListener(handler(self, self.btnHeadClick))
end
function HeroShowItem:initData(heroID)
	self.heroID = tonumber(heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function HeroShowItem:setHeadBg(quality)
	if quality then
		self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(quality))
	else
		self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(gHeroQuality.WHITE))
	end
end
function HeroShowItem:initView(...)
	local dressID = heroCtrl:getHeroDressSeting(self.heroID)
	if dressID and not heroltCtrl:isDefaultDress(dressID) then
		self.spHeroHead:setSpriteFrame(heroltCtrl.heroDressCfg[dressID].herIcon)
	else
		self.spHeroHead:setSpriteFrame(heroltCtrl.herosInfo[self.heroID].herIcon)
	end
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
end
function HeroShowItem:btnHeadClick(button, eventType)
	if self.clickCallback then
		self.clickCallback(self, eventType)
	end
	if eventType == ccui.TouchEventType.ended then
		print("btn click")
	end
end
function HeroShowItem:setClickCallback(callback)
	self.clickCallback = callback
end
function HeroShowItem:setSwallowTouches(isSwallow)
	self.btnHead:setSwallowTouches(isSwallow)
end
return HeroShowItem
