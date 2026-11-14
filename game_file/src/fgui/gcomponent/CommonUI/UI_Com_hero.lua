local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_hero = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_hero", UI_Com_hero)
function UI_Com_hero:onInit()
	self.fields.rarity:fixPos()
	self.fields.class:fixPos()
	self.fields.Text_lv:fixPos()
	self.showHeroDetail = false
end
function UI_Com_hero:onShow()
end
function UI_Com_hero:initMax(heroID)
	local heroInfo = heroCtrl:getHeroMax(heroID)
	local dressCfg = heroltCtrl:getHeroDress(heroID)
	local dressID = dressCfg[2] or dressCfg[1]
	self.fields.bg:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
	if dressID and 0 < dressID then
		self.fields.icon:setSpriteFrame(heroltCtrl:getDressHerIcon(dressID))
	else
		local heroCfg = heroltCtrl.getHeroInfo(heroID)
		self.fields.icon:setSpriteFrame(heroCfg.herIcon)
	end
	self.fields.Text_lv:setString(heroInfo.level)
	self.fields.rarity:setSpriteFrame(heroltCtrl:getCardRareImg(heroID))
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(heroID)
	self.fields.class:setSpriteFrame(heroClassInfo.icon)
end
function UI_Com_hero:initData(heroID, dressID)
	self.heroID = tonumber(heroID)
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self:initDataWithInfo(heroInfo, dressID)
end
function UI_Com_hero:initDataWithInfo(heroInfo, dressID)
	self.heroID = self.heroID or heroInfo.heroID
	self.heroLevel = self.heroLevel or heroInfo.level
	self.heroQuality = self.heroQuality or heroInfo.quality
	self.dressID = self.dressID or heroInfo.dressID
	dressID = dressID or heroInfo.dressID
	self.fields.bg:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
	if dressID and 0 < dressID then
		self.fields.icon:setSpriteFrame(heroltCtrl:getDressHerIcon(dressID))
	else
		local heroCfg = heroltCtrl.getHeroInfo(self.heroID)
		self.fields.icon:setSpriteFrame(heroCfg.herIcon)
	end
	self.fields.Text_lv:setString(heroInfo.level)
	self.fields.rarity:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID)
	self.fields.class:setSpriteFrame(heroClassInfo.icon)
end
function UI_Com_hero:setShowHeroDetail(show)
	if not self.showHeroDetail and show then
		self:addClickEventListener(handler(self, self.onClickShowHeroDetail))
	end
	self.showHeroDetail = show
end
function UI_Com_hero:onClickShowHeroDetail()
	if self.heroID and self.heroLevel and self.heroQuality and self.showHeroDetail then
		SoraDPlaySound()
		_ENV = nil
		;(nil).heroID = self.heroID
		;(nil).quality = self.heroQuality
		;(nil).level = self.heroLevel
		;(nil).dressID = self.dressID
		uiManager:show("HeroIntroduction", nil)
	end
end
return UI_Com_hero
