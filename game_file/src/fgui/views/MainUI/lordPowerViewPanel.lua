local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordPowerViewPanel = class("lordPowerViewPanel", baseFguiPanel)
function lordPowerViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordPowerViewPanel:ctor", self.viewName)
end
function lordPowerViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordPowerViewPanel:onInit()
	print("=======lordPowerViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_090"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	lordInfoCtrl:getLordBattleInfoReq()
end
function lordPowerViewPanel:onShow()
	print("=======lordPowerViewPanel:onShow")
end
function lordPowerViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableInfo[index + 1], index + 1)
end
function lordPowerViewPanel:initData()
	_ENV, _UPVALUE11_ = nil, nil
	;(nil).key = "totalFc"
	_ENV, (nil).title = i18n("common_text_097"), i18n("common_text_097")
	i18n("common_text_097").key = "lordFc"
	_ENV, i18n("common_text_097").title = i18n("common_text_355"), i18n("common_text_355")
	i18n("common_text_355").key = "armyFc"
	_ENV, i18n("common_text_355").title = i18n("common_text_356"), i18n("common_text_356")
	i18n("common_text_356").key = "buildFc"
	_ENV, i18n("common_text_356").title = i18n("common_text_357"), i18n("common_text_357")
	i18n("common_text_357").key = "techFc"
	_ENV, i18n("common_text_357").title = i18n("common_text_358"), i18n("common_text_358")
	i18n("common_text_358").key = "trapFc"
	_ENV, i18n("common_text_358").title = i18n("common_text_359"), i18n("common_text_359")
	i18n("common_text_359").key = "equipFc"
	_ENV, i18n("common_text_359").title = i18n("common_text_1394"), i18n("common_text_1394")
	i18n("common_text_1394").key = "warGemFc"
	_ENV, i18n("common_text_1394").title = i18n("common_text_4086"), i18n("common_text_4086")
	i18n("common_text_4086").key = "attrFc"
	_ENV = nil
	;(nil).title = i18n("common_text_2267")
	_ENV, i18n("common_text_4086").title = i18n("common_text_1915", nil), i18n("common_text_1915", nil)
	i18n("common_text_1915", nil).key = "petExtraFc"
	_ENV, i18n("common_text_1915", nil).title = i18n("pet_text_15"), i18n("pet_text_15")
	i18n("pet_text_15").key = "heroExtraFc"
	i18n("pet_text_15").title = i18n("hero_text_98")
	;(nil)[1] = nil
	;(nil)[2] = i18n("common_text_097")
	;(nil)[3] = i18n("common_text_355")
	;(nil)[4] = i18n("common_text_356")
	;(nil)[5] = i18n("common_text_357")
	;(nil)[6] = i18n("common_text_358")
	;(nil)[7] = i18n("common_text_359")
	;(nil)[8] = i18n("common_text_1394")
	;(nil)[9] = i18n("common_text_4086")
	;(nil)[10] = i18n("common_text_1915", nil)
	local (nil)[11], tableInfo = i18n("pet_text_15"), nil
	if not IsArClient then
		_ENV = i18n("common_text_355")
		i18n("common_text_355").key = "masteryFc"
		i18n("common_text_355").title = i18n("specialization_text_15")
		table.insert(tableInfo, (i18n("common_text_355")))
	end
	if commonCheck.ARTIFACT then
		_ENV = i18n("common_text_355")
		i18n("common_text_355").key = "godArmsFc"
		i18n("common_text_355").title = i18n("artifact_text_34")
		table.insert(tableInfo, (i18n("common_text_355")))
	end
	if SoraDCheckIsOpenBuildStar() then
		_ENV = i18n("artifact_text_34")
		i18n("artifact_text_34").key = "buildStarFc"
		i18n("artifact_text_34").title = i18n("Glory_text_36")
		table.insert(tableInfo, 5, (i18n("artifact_text_34")))
	end
	if SoraDIsBraveOpen() then
		_ENV = 5
		;(5).key = "craftFc"
		;(5).title = i18n("Soldiers_armor_text_49")
		table.insert(tableInfo, 5)
	end
	if SoraDGetCtrl("magicLampCtrl"):getIsUnlock() then
		_ENV = 5
		;(5).key = "magicLampFc"
		;(5).title = i18n("magic_lamp_text_040")
		table.insert(tableInfo, 5)
	end
	if SoraDGetCtrl("divineBeastCtrl"):getIsUnlock() then
		_ENV = 5
		;(5).key = "divineBeastFc"
		;(5).title = i18n("Divine_beast_text_44")
		table.insert(tableInfo, 5)
	end
	if SoraDGetCtrl("manorCityCtrl"):getIsUnLock() then
		_ENV = 5
		;(5).key = "gardenFc"
		;(5).title = i18n("garden_text_43")
		table.insert(tableInfo, 5)
	end
	self.tableInfo = tableInfo
	self.fields.List:setNumItems(#self.tableInfo)
end
return lordPowerViewPanel
