local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTempleMainPanel = class("HeroTempleMainPanel", baseFguiPanel)
function HeroTempleMainPanel:ctor(...)
	HeroTempleMainPanel.super.ctor(self, ...)
	print("HeroTempleMainPanel:ctor", self.viewName)
end
function HeroTempleMainPanel:onInit()
	print("=======HeroTempleMainPanel:onInit")
	_ENV, self.tag = print, 1
	print[1] = gHeroType.INFANTRY
	print[2] = gHeroType.CAVALRY
	self.heroTypeCfg, print[3] = print, gHeroType.ARCHER
	self.fields.Com_title:initData(i18n("hero_palace_text_01"), handler(self, self.onClickClose))
end
function HeroTempleMainPanel:onShow()
	print("=======HeroTempleMainPanel:onShow")
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("hero_palace_text_18")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("hero_palace_text_19")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("hero_palace_text_20")
	;(nil).tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(nil)
end
function HeroTempleMainPanel:onTabClick(tag)
	if self.tag ~= tag then
		self.transitions.normal:play(1, 0, 0, -1)
	end
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:updateView()
end
function HeroTempleMainPanel:updateView()
	self.fields["Com_view_" .. self.tag]:initData(self.heroTypeCfg[self.tag])
	local ownCount, cfgCount = self.fields["Com_view_" .. self.tag]:getHeroNums()
	self.fields.Com_info:initData(self.tag, ownCount, cfgCount)
end
function HeroTempleMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Btn_help" then
		return self.fields.Com_info:getBtnHelp()
	else
		return self.fields[itemName]
	end
end
return HeroTempleMainPanel
