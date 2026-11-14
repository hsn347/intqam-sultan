local heroBiographyRead = include("heroBiographyRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroCollectedBiographiesPopPanel = class("HeroCollectedBiographiesPopPanel", baseFguiPanel)
function HeroCollectedBiographiesPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroCollectedBiographiesPopPanel:ctor", self.viewName)
end
function HeroCollectedBiographiesPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroCollectedBiographiesPopPanel:onInit()
	print("=======HeroCollectedBiographiesPopPanel:onInit")
	self.itemList, _ENV, self.index = self.proxy.param.index or 1, self.proxy.param.index or 1, self.proxy.param.index or 1
	self.fields.Panel_bg:setString(i18n("Biography_text_15"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRender))
end
function HeroCollectedBiographiesPopPanel:onShow()
	print("=======HeroCollectedBiographiesPopPanel:onShow")
	local lv1, lv2 = heroBiographyRead.getLvArray(self.index)
	_ENV = nil
	;(nil).index = self.index
	_ENV = nil
	;(nil).num = 1
	;(nil).title = i18n("Biography_text_16", nil)
	_ENV = nil
	;(nil).lv = lv1
	;(nil).pre = i18n("Biography_text_18", nil)
	;(nil).stage = gHeroStorySkillStage.LEVELUP
	;(nil).missionNum = lv1
	table.insert(self.itemList, nil)
	_ENV = nil
	;(nil).index = self.index
	_ENV = nil
	;(nil).num = 2
	;(nil).title = i18n("Biography_text_16", nil)
	_ENV = nil
	;(nil).lv = lv2
	;(nil).pre = i18n("Biography_text_18", nil)
	;(nil).stage = gHeroStorySkillStage.LEVELUP
	;(nil).missionNum = lv2
	table.insert(self.itemList, nil)
	_ENV = nil
	;(nil).index = self.index
	;(nil).title = i18n("Biography_text_17")
	;(nil).pre = i18n("Biography_text_19")
	;(nil).stage = gHeroStorySkillStage.AWAKE
	;(nil).awake = true
	table.insert(self.itemList, nil)
	self.fields.list:setNumItems(#self.itemList)
end
function HeroCollectedBiographiesPopPanel:onItemRender(index, target)
	target:initData(self.itemList[index + 1])
end
return HeroCollectedBiographiesPopPanel
