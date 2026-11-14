local heroNewTrialRead = include("heroNewTrialRead")
local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroNewTrialHook1Panel = class("HeroNewTrialHook1Panel", baseFguiPanel)
function HeroNewTrialHook1Panel:ctor(...)
	HeroNewTrialHook1Panel.super.ctor(self, ...)
	print("HeroNewTrialHook1Panel:ctor", self.viewName)
end
function HeroNewTrialHook1Panel:onInit()
	print("=======HeroNewTrialHook1Panel:onInit")
	self.fields.Panel_bg:setString(i18n("hero_experience_04"))
	self.fields.Text_reward:setString(i18n("hero_experience_06"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function HeroNewTrialHook1Panel:onShow()
	print("=======HeroNewTrialHook1Panel:onShow")
	local heroID = self.param and self.param.heroID
	local afkUnlockStage = heroNewTrialCtrl:getAfkUnlockStage(heroID)
	_ENV = nil
	;(nil).num = afkUnlockStage
	self.fields.Text_des:setString(i18n("hero_experience_05", nil))
	self.rewardList = heroNewTrialRead.getDisplayedReward(heroID)
	self.fields.List:setNumItems(#self.rewardList)
end
function HeroNewTrialHook1Panel:onItemRenderer(index, obj)
	local item = self.rewardList[index + 1]
	obj:initData(item.id, item.count)
end
return HeroNewTrialHook1Panel
