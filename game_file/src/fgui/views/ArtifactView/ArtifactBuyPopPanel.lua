local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtifactBuyPopPanel = class("ArtifactBuyPopPanel", baseFguiPanel)
function ArtifactBuyPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArtifactBuyPopPanel:ctor", self.viewName)
end
function ArtifactBuyPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ArtifactBuyPopPanel:onInit()
	print("=======ArtifactBuyPopPanel:onInit")
	self.gold = self.proxy.param.gold
	self.count = self.proxy.param.count
	self.weaponID = self.proxy.param.weaponID
	_ENV = nil
	;(nil).num = string.formatnumberthousands(self.gold)
	self.fields.Text_Tips:setString(i18n("artifact_text_09", nil))
	self.fields.Button_Sure:setString(i18n("common_text_204"))
	self.fields.Button_Sure:addClickListener(handler(self, self.onClickSure))
	self.fields.Button_Sure:setCost(gIDDef.GOLD, self.gold)
end
function ArtifactBuyPopPanel:onShow()
	print("=======ArtifactBuyPopPanel:onShow")
end
function ArtifactBuyPopPanel:onClickSure()
	SoraDPlaySound()
	if SoraDEnoughGold(self.gold) then
		godArmsCtrl:reqRefine(self.weaponID, ARMS_REFINE_TYPE.ADVANCE_REFINE, self.count, true)
	end
	self:removeFromParent()
end
return ArtifactBuyPopPanel
