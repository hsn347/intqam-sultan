local baseComponent = require("fgui.base.baseComponent")
local annivColossusCtrl = SoraDGetCtrl("annivColossusCtrl")
local annivColossusRead = include("annivColossusRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local jumpDesRead = include("jumpDesRead")
local itemDesRead = include("itemDesRead")
_ENV = "itemDesRead"
;("itemDesRead").PERSON = 1
local ("itemDesRead").GLOBAL, REWARDTYPE = 2, "itemDesRead"
local Com_Anniv_box = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnnivColossusActivity/Com_Anniv_box", Com_Anniv_box)
function Com_Anniv_box:onInit()
	self.fields.btn_all_reward:addClickEventListener(handler(self, self.onAllRewardClick))
end
function Com_Anniv_box:onShow()
end
function Com_Anniv_box:updateGlobalBox()
	local globalScore = annivColossusCtrl:getGlobalScore()
	local curRoundCfg = annivColossusRead:getCurGlobalRound(globalScore)
	annivColossusCtrl = nil
	;(nil).num1 = globalScore
	annivColossusCtrl, annivColossusCtrl, (nil).num2 = nil, curRoundCfg.NeedNum, curRoundCfg.NeedNum
	curRoundCfg.NeedNum.num2, (nil).color = nil, "#ffffff"
	local curStr = i18n_html("%{num1}/%{num2}", nil, curRoundCfg.NeedNum)
	self.fields.txt_all_value:setString(curStr)
	annivColossusCtrl = nil
	;(nil).var = curRoundCfg.Rank
	self.fields.txt_all_pro:setString(i18n("build_colossus_01", nil))
	annivColossusCtrl = i18n("build_colossus_01", nil)
	i18n("build_colossus_01", nil).var = curRoundCfg.Rank
	self.fields.txt_step:setString(i18n("build_colossus_05", i18n("build_colossus_01", nil)))
	local perValue = 8 + globalScore / curRoundCfg.NeedNum * 82
	self.fields.progressBar1:setValue(perValue)
	if globalScore >= annivColossusRead:getMaxScore(REWARDTYPE.GLOBAL) then
		self.fields.txt_all_pro:setString(i18n("build_colossus_13"))
	end
end
function Com_Anniv_box:onAllRewardClick()
	SoraDPlaySound()
	uiManager:show("AnnivColossusGlobalReward")
end
return Com_Anniv_box
