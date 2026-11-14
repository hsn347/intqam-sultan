local annivColossusCtrl = SoraDGetCtrl("annivColossusCtrl")
local annivColossusRead = include("annivColossusRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
_ENV = "fgui.base.baseFguiPanel"
;("fgui.base.baseFguiPanel").PERSON = 1
local ("fgui.base.baseFguiPanel").GLOBAL, REWARDTYPE = 2, "fgui.base.baseFguiPanel"
local AnnivColossusGlobalRewardPanel = class("AnnivColossusGlobalRewardPanel", baseFguiPanel)
function AnnivColossusGlobalRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AnnivColossusGlobalRewardPanel:ctor", self.viewName)
end
function AnnivColossusGlobalRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AnnivColossusActivity"
	end
	return self._packageList
end
function AnnivColossusGlobalRewardPanel:onInit()
	self.fields.panel_normal:setString(i18n("build_colossus_04"))
	self.fields.txt_reward_tip:setString(i18n("common_text_2211"))
	print("=======AnnivColossusGlobalRewardPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function AnnivColossusGlobalRewardPanel:onShow()
	print("=======AnnivColossusGlobalRewardPanel:onShow")
	self.rewardCfgs = annivColossusRead:getRewards(REWARDTYPE.GLOBAL)
	self.fields.scroll:setNumItems(#self.rewardCfgs)
end
function AnnivColossusGlobalRewardPanel:onHide()
	print("=======AnnivColossusGlobalRewardPanel:onHide")
end
function AnnivColossusGlobalRewardPanel:onDispose()
	print("=======AnnivColossusGlobalRewardPanel:onDispose")
end
function AnnivColossusGlobalRewardPanel:onNormalItemRenderer(index, obj)
	local rewardCfg = self.rewardCfgs[index + 1]
	obj:initData(rewardCfg)
end
return AnnivColossusGlobalRewardPanel
