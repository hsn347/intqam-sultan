local baseComponent = require("fgui.base.baseComponent")
local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
_ENV = "pickupStarsAgainRead"
;("pickupStarsAgainRead").PERSON = 1
local ("pickupStarsAgainRead").GLOBAL, REWARDTYPE = 2, "pickupStarsAgainRead"
local PickupStarsAgainGlobalSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/PickupStarsAgainGlobalSingle", PickupStarsAgainGlobalSingle)
function PickupStarsAgainGlobalSingle:onInit()
	self:fixChildrenPos()
	self.fields.n5:fix()
	self.fields.n19:fix()
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.Com_got:setString(i18n("common_text_2210"))
	self.fields.txt_not:setString(i18n("build_colossus_11"))
	self.fields.txt_ing:setString(i18n("activity_text_05"))
	self.debug = true
end
function PickupStarsAgainGlobalSingle:onShow()
end
function PickupStarsAgainGlobalSingle:initData(rewardCfg)
	self.rewards = rewardCfg.Reward
	self.fields.scroll:setNumItems(#self.rewards / 2)
	local globalScore = pickupStarsAgainCtrl:getGlobalScore()
	pickupStarsAgainCtrl = nil
	;(nil).value = string.formatnumberthousands(globalScore)
	;(nil).total = string.formatnumberthousands(rewardCfg.NeedNum)
	self.fields.txt_progress:setString(i18n("pickup_star_34", nil))
	pickupStarsAgainCtrl = i18n("pickup_star_34", nil)
	i18n("pickup_star_34", nil).var = rewardCfg.Rank
	self.fields.txt_step:setString(i18n("build_colossus_05", i18n("pickup_star_34", nil)))
	if globalScore >= rewardCfg.NeedNum then
		self.controllers.c1:setSelectedIndex(2)
	else
		local curRoundCfg = pickupStarsAgainRead:getCurGlobalRound(globalScore)
		self.controllers.c1:setSelectedIndex(curRoundCfg.Index == rewardCfg.Index and 1 or 0)
	end
end
function PickupStarsAgainGlobalSingle:onNormalItemRenderer(index, obj)
	obj:initData(self.rewards[2 * index + 1], self.rewards[2 * index + 2])
end
return PickupStarsAgainGlobalSingle
