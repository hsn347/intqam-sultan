local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local HeroJailItem2 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://HeroJail/HeroJailItem2", HeroJailItem2)
function HeroJailItem2:onInit()
	self:fixChildrenPos()
	self.fields.Progress_Lv:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Progress_Lv:setMax(100)
end
function HeroJailItem2:onShow()
end
function HeroJailItem2:initData(heroID)
	self.heroID = tonumber(heroID)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function HeroJailItem2:initView(...)
	self.fields.Label_Lv:setString(self.heroInfo.level)
	local dressID = self.heroInfo.dressID or heroltCtrl.getHeroDefaultDressID(self.heroInfo.heroID)
	self.fields.Sprite_head:setURL(heroltCtrl:getDressHerIcon(dressID))
	self.fields.Sprite_headBg:setURL(heroltCtrl.getCubeBg(self.heroInfo.quality))
	if self.heroInfo.level >= gHeroMaxLevel then
		self.fields.Progress_Lv:setValue(0)
	else
		local maxExp = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroInfo.level).exp
		self.fields.Progress_Lv:setValue((1 - self.heroInfo.level_exp / maxExp) * 100)
	end
	self:initState()
end
function HeroJailItem2:initState(...)
	self:setGrayed(false)
	self.fields.nodeJail:setVisible(false)
	if gHeroState.HERO_STATE_DEAD == self.heroInfo.state then
		self:setGrayed(true)
	elseif gHeroState.HERO_STATE_CAPTURED == self.heroInfo.state then
		self.fields.nodeJail:setVisible(true)
	end
end
return HeroJailItem2
