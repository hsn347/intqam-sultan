local baseComponent = require("fgui.base.baseComponent")
local Button_style = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Button_style", Button_style)
_ENV = fgui.register_extension
fgui.register_extension[gHeroBtnStyleType.story] = "hero_text_117"
fgui.register_extension[gHeroBtnStyleType.dress] = "heroDress_text_001"
fgui.register_extension[gHeroBtnStyleType.share] = "common_text_533"
fgui.register_extension[gHeroBtnStyleType.task] = "hero_text_118"
fgui.register_extension[gHeroBtnStyleType.biography] = "Biography_text_11"
fgui.register_extension[gHeroBtnStyleType.tactics] = "herotactics_text_01"
fgui.register_extension[gHeroBtnStyleType.attribute] = "hero_title_01"
fgui.register_extension[gHeroBtnStyleType.trial] = "hero_experience_01"
local _ENV, fgui.register_extension[gHeroBtnStyleType.trialAfk], nameCfg = gHeroBtnStyleType.trialAfk, "hero_experience_04", fgui.register_extension
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.story] = "btn_yxgs_yxtyyh.png"
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.dress] = "heroDressUp.png"
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.share] = "icon_fenxiang.png"
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.task] = "btn_yxrw_yxtyyh.png"
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.biography] = "btn_hero_liezhuan.png"
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.tactics] = "btn_yxlz_yxtyyh.png"
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.attribute] = "btn_hero_shuxing.png"
gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.trial] = "btn_hero_lookfor.png"
local gHeroBtnStyleType.trialAfk[gHeroBtnStyleType.trialAfk], iconCfg = "btn_hero_lookfor.png", gHeroBtnStyleType.trialAfk
function Button_style:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Button_style:onShow()
end
function Button_style:initData(data, heroID, heroClass)
	local redNum = 0
	if type(data) == "number" then
		self.style = data
	else
		self.style = data.style
		redNum = data.red
	end
	self.heroID = tonumber(heroID)
	self.heroClass = heroClass
	self:setIcon(iconCfg[self.style])
	self:setText(i18n(nameCfg[self.style]))
	self.fields.Label_reddot:initData(0 < redNum, redNum)
end
function Button_style:btnClick()
	SoraDPlaySound()
	if self.style == gHeroBtnStyleType.story then
		_ENV = nil
		;(nil).heroID = self.heroID
		uiManager:show("HeroStory", nil)
	end
	if self.style == gHeroBtnStyleType.dress then
		_ENV = nil
		;(nil).heroID = self.heroID
		;(nil).heroClass = self.heroClass
		uiManager:show("HeroSkin", nil)
	end
	if self.style == gHeroBtnStyleType.share then
		_ENV = nil
		;(nil).shareHid = self.heroID
		uiManager:show("HeroShareBox", nil)
	end
	if self.style == gHeroBtnStyleType.task then
		_ENV = nil
		;(nil).type = 1
		;(nil).heroID = self.heroID
		uiManager:show("HeroTask", nil)
	end
	if self.style == gHeroBtnStyleType.biography then
		if SoraDGetCastleLv() >= CASTLE_LV40_LIMITED then
			local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
			_ENV = self.heroID
			self.heroID.index = heroBiographyCtrl:getBiographyIndexByHeroID(self.heroID)
			uiManager:show("HeroCollectedBiographies", self.heroID)
		else
			_ENV = "HeroCollectedBiographies"
			;("HeroCollectedBiographies").level = 1
			SoraDShowMsgTip(i18n("common_text_3962", "HeroCollectedBiographies"))
		end
	end
	if self.style == gHeroBtnStyleType.tactics then
		local panel = SoraDCreatePanel("heroTacticsPopView")
		panel:initData(self.heroID)
		panel:show()
	elseif self.style == gHeroBtnStyleType.attribute then
		_ENV = self.heroID
		self.heroID.heroID = self.heroID
		uiManager:show("HeroAttribute", self.heroID)
	elseif self.style == gHeroBtnStyleType.trial then
		_ENV = self.heroID
		self.heroID.heroID = self.heroID
		uiManager:show("HeroNewTrialMap", self.heroID)
	elseif self.style == gHeroBtnStyleType.trialAfk then
		_ENV = self.heroID
		self.heroID.heroID = self.heroID
		uiManager:show("HeroNewTrialHookView", self.heroID)
	end
end
return Button_style
