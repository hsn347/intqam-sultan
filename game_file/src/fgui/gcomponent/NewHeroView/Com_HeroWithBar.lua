local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_HeroWithBar = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_HeroWithBar", Com_HeroWithBar)
function Com_HeroWithBar:onInit()
	self:addClickListener(handler(self, self.btnItemClick))
	self.fields.loadBar:fixChildrenPos()
end
function Com_HeroWithBar:onShow()
end
function Com_HeroWithBar:initData(heroID)
	self.heroID = tonumber(heroID)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function Com_HeroWithBar:initView(...)
	self:defaultView()
	self.fields.Sprite_head:setURL(self.heroDesInfo.herIcon)
	self.fields.Sprite_headBg:setURL(heroltCtrl.getBg(self.heroInfo.quality))
	self.fields.Sprite_class:setURL(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.fields.Text_Lv:setString(self.heroInfo.level)
	if self.heroInfo.level >= gHeroMaxLevel then
		self.fields.loadBar:setMax(100)
		self.fields.loadBar:setValue(100)
	else
		local maxExp = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroInfo.level).exp
		self.fields.loadBar:setMax(maxExp)
		self.fields.loadBar:setValue(self.heroInfo.level_exp)
	end
	self:initState()
end
function Com_HeroWithBar:defaultView(...)
	self:setGrayed(false)
	self.fields.nodeJail:setVisible(false)
end
function Com_HeroWithBar:initState(...)
	if gHeroState.HERO_STATE_DEAD == self.heroInfo.state then
		self:setGrayed(true)
	elseif gHeroState.HERO_STATE_CAPTURED == self.heroInfo.state then
		self.fields.nodeJail:setVisible(true)
	end
end
function Com_HeroWithBar:btnItemClick(button, eventType)
	SoraDPlaySound()
	heroltCtrl.normalHeroHeadClick(self.heroID)
end
return Com_HeroWithBar
