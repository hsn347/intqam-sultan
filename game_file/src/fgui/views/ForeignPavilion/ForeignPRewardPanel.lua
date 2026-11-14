local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignPRewardPanel = class("ForeignPRewardPanel", baseFguiPanel)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
function ForeignPRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ForeignPRewardPanel:ctor", self.viewName)
end
function ForeignPRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function ForeignPRewardPanel:onInit()
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	print("=======ForeignPRewardPanel:onInit")
	self.fields.txt_need:setString(i18n("exitic_pavillion_text_0060"))
	self.fields.btn_get:addClickEventListener(handler(self, self.onGetClick))
end
function ForeignPRewardPanel:onShow()
	print("=======ForeignPRewardPanel:onShow")
	local intimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	local intimacyValue = exoticPavilionCtrl:getCurIntimacyValue()
	local curIntimacyCfg = foreignPavilionRead:getCurIntimacyCfg(intimacyLv)
	self.fields.panel_normal:setTitle(i18n(curIntimacyCfg.boxname))
	foreignPavilionRead = i18n(curIntimacyCfg.boxname)
	i18n(curIntimacyCfg.boxname)[1] = "id"
	i18n(curIntimacyCfg.boxname)[2] = "count"
	self.awards = serviceFunctions.tableFormat(curIntimacyCfg.award, i18n(curIntimacyCfg.boxname))
	self.fields.scroll:setNumItems(#self.awards)
	local isGetDailyReward = exoticPavilionCtrl:getIsGetDailyReward()
	self.fields.btn_get:setTitle(isGetDailyReward and i18n("common_text_1892") or i18n("common_text_1146"))
	self.fields.btn_get:setEnabled(not isGetDailyReward)
end
function ForeignPRewardPanel:onHide()
	print("=======ForeignPRewardPanel:onHide")
end
function ForeignPRewardPanel:onDispose()
	print("=======ForeignPRewardPanel:onDispose")
end
function ForeignPRewardPanel:onItemRenderer(index, obj)
	local award = self.awards[index + 1]
	obj:initData(award.id, award.count)
end
function ForeignPRewardPanel:onGetClick()
	SoraDPlaySound()
	exoticPavilionCtrl:reqGetDaliyReward()
	SoraDMailGainItems(self.awards, true)
	self:close()
end
return ForeignPRewardPanel
