local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SeedCultivatePanel = class("SeedCultivatePanel", baseFguiPanel)
function SeedCultivatePanel:ctor(...)
	self.isLRU = true
	SeedCultivatePanel.super.ctor(self, ...)
	print("SeedCultivatePanel:ctor", self.viewName)
end
function SeedCultivatePanel:onInit()
	print("=======SeedCultivatePanel:onInit")
	self.fields.Com_title:initData(i18n("farmland_text_08"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btnReceive:setTitle(i18n("summoned_btn_01"))
	self.fields.btnReceive:addClickListener(handler(self, self.onClick_btnReceive))
	self.fields.btnSimulate:addClickListener(handler(self, self.onClick_btnSimulate))
	self.fields.btnSimulate:setString(i18n("farmland_text_26"))
end
function SeedCultivatePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("farmland_text_85")
	uiManager:show("RuleView", nil)
end
function SeedCultivatePanel:endShow()
	print("=======SeedCultivatePanel:endShow")
	self:initData()
	self.fields.prefabEx:setVisible(true)
	self.fields.prefabEx:setEffectPath("fx_farm_zzpy_bg.prefab")
end
function SeedCultivatePanel:onClick_btnReceive(context)
	SoraDPlaySound()
	manorCityCtrl:reqFarmlandPickMergeSeed()
	SoraDShowLoading(self)
end
function SeedCultivatePanel:onClick_btnSimulate(context)
	uiManager:show("SeedCultivateSim")
end
function SeedCultivatePanel:initData()
	for queue = 1, 5 do
		self.fields["slot" .. queue]:initSeedData(queue)
	end
	self:updateReceive()
end
function SeedCultivatePanel:updateReceive()
	local enabled = false
	for queue = 1, 5 do
		local status = manorCityUtil.getSeedCultivateStatus(queue)
		if status == 3 then
			enabled = true
			break
		end
	end
	self.fields.btnReceive:setEnabled(enabled)
end
return SeedCultivatePanel
