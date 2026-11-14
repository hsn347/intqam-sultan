local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FruitCultivatePanel = class("FruitCultivatePanel", baseFguiPanel)
function FruitCultivatePanel:ctor(...)
	self.isLRU = true
	FruitCultivatePanel.super.ctor(self, ...)
	print("FruitCultivatePanel:ctor", self.viewName)
end
function FruitCultivatePanel:onInit()
	print("=======FruitCultivatePanel:onInit")
	self.fields.Com_title:initData(i18n("farmland_text_32"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btnReceive:setTitle(i18n("summoned_btn_01"))
	self.fields.btnReceive:addClickListener(handler(self, self.onClick_btnReceive))
	self.fields.prefabEx:setEffectPath("fx_farm_gspy_bg.prefab")
end
function FruitCultivatePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("farmland_text_33")
	uiManager:show("RuleView", nil)
end
function FruitCultivatePanel:endShow()
	print("=======FruitCultivatePanel:endShow")
	self:initData()
end
function FruitCultivatePanel:onClick_btnReceive(context)
	SoraDPlaySound()
	manorCityCtrl:reqFarmlandPickCultivate()
	SoraDShowLoading(self)
end
function FruitCultivatePanel:initData(noRefreshSlot)
	local previewNum = 0
	for queue = 1, 5 do
		if not noRefreshSlot then
			self.fields["slot" .. queue]:initFruitData(queue)
		end
		previewNum = previewNum + manorCityUtil.previewFruitCultivateCount(queue)
	end
	print("==================预览可收获果实数量:", previewNum)
	self.fields.btnReceive:setGrayed(previewNum == 0)
	self.fields.pb:initData(previewNum, 0, CONST_VALUE.FARMLAND_SEED_CULTIVATE_REWARD_NUM)
end
return FruitCultivatePanel
