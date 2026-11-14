local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
_ENV = "fgui.base.baseFguiPanel"
;("fgui.base.baseFguiPanel").PERSON = 1
local ("fgui.base.baseFguiPanel").GLOBAL, REWARDTYPE = 2, "fgui.base.baseFguiPanel"
local PickupStarsAgainGlobalPanel = class("PickupStarsAgainGlobalPanel", baseFguiPanel)
function PickupStarsAgainGlobalPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PickupStarsAgainGlobalPanel:ctor", self.viewName)
end
function PickupStarsAgainGlobalPanel:onInit()
	self.fields.panel_normal:setString(i18n("build_colossus_04"))
	self.fields.txt_reward_tip:setString(i18n("common_text_2211"))
	print("=======PickupStarsAgainGlobalPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function PickupStarsAgainGlobalPanel:onShow()
	print("=======PickupStarsAgainGlobalPanel:onShow")
	self.rewardCfgs = pickupStarsAgainRead:getRewards(REWARDTYPE.GLOBAL)
	self.fields.scroll:setNumItems(#self.rewardCfgs)
end
function PickupStarsAgainGlobalPanel:onHide()
	print("=======PickupStarsAgainGlobalPanel:onHide")
end
function PickupStarsAgainGlobalPanel:onDispose()
	print("=======PickupStarsAgainGlobalPanel:onDispose")
end
function PickupStarsAgainGlobalPanel:onNormalItemRenderer(index, obj)
	local rewardCfg = self.rewardCfgs[index + 1]
	obj:initData(rewardCfg)
end
return PickupStarsAgainGlobalPanel
