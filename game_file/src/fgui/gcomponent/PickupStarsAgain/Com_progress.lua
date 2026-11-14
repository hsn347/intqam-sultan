local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local jumpDesRead = include("jumpDesRead")
local itemDesRead = include("itemDesRead")
_ENV = "itemDesRead"
;("itemDesRead").PERSON = 1
local ("itemDesRead").GLOBAL, REWARDTYPE = 2, "itemDesRead"
local baseComponent = require("fgui.base.baseComponent")
local Com_progress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/Com_progress", Com_progress)
function Com_progress:onInit()
	self.fields.btn_all_reward:addClickEventListener(handler(self, self.onAllRewardClick))
end
function Com_progress:onShow()
end
function Com_progress:updateGlobalBox()
	local globalScore = pickupStarsAgainCtrl:getGlobalScore()
	local curRoundCfg = pickupStarsAgainRead:getCurGlobalRound(globalScore)
	pickupStarsAgainCtrl = nil
	;(nil).num1 = string.formatnumberthousands(globalScore)
	pickupStarsAgainCtrl, pickupStarsAgainCtrl, (nil).num2 = curRoundCfg.NeedNum, string.formatnumberthousands(curRoundCfg.NeedNum), string.formatnumberthousands(curRoundCfg.NeedNum)
	string.formatnumberthousands(curRoundCfg.NeedNum).num2, curRoundCfg.NeedNum.color = curRoundCfg.NeedNum, "#ffffff"
	local curStr = i18n_html("%{num1}/%{num2}", nil, (string.formatnumberthousands(curRoundCfg.NeedNum)))
	self.fields.txt_all_value:setString(curStr)
	self.fields.txt_all_pro:setString(i18n("pickup_star_003"))
	pickupStarsAgainCtrl = i18n("pickup_star_003")
	i18n("pickup_star_003").num = curRoundCfg.Rank
	self.fields.txt_step:setString(i18n("pickup_star_004", i18n("pickup_star_003")))
	local perValue = 8 + globalScore / curRoundCfg.NeedNum * 82
	self.fields.progressBar1:setValue(perValue)
	if globalScore >= pickupStarsAgainRead:getMaxScore(REWARDTYPE.GLOBAL) then
		self.fields.txt_all_pro:setString(i18n("pickup_star_33"))
	end
end
function Com_progress:onAllRewardClick()
	SoraDPlaySound()
	uiManager:show("PickupStarsAgainGlobal")
end
return Com_progress
