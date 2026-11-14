local armyDesRead = include("armyDesRead")
local armorSystemRead = include("armorSystemRead")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersPromoteTSuccessPanel = class("soldiersPromoteTSuccessPanel", baseFguiPanel)
function soldiersPromoteTSuccessPanel:ctor(...)
	self.isLRU = true
	soldiersPromoteTSuccessPanel.super.ctor(self, ...)
	print("soldiersPromoteTSuccessPanel:ctor", self.viewName)
end
function soldiersPromoteTSuccessPanel:onInit()
	print("=======soldiersPromoteTSuccessPanel:onInit")
	self.fields.List_res:setAlignCenter(true)
	self.fields.List_res:setItemRenderer(handler(self, self.onResRender))
end
function soldiersPromoteTSuccessPanel:onResRender(index, obj)
	local data = self.resList[index + 1]
	obj:getChild("icon"):setURL(publicRead.getIcon(data.resID))
	obj:getChild("Text_name"):setString(publicRead.getName(data.resID))
	obj:getChild("Text_count"):setString(SoraDConvertNumberWithUnit(data.rescount))
end
function soldiersPromoteTSuccessPanel:endShow()
	print("=======soldiersPromoteTSuccessPanel:endShow")
	self.toArmyId = self.param.toArmyId
	self.armyId = self.param.armyId
	self.count = self.param.count
	self.giltCost = constantRead.getConstValueArray("T14_UP_GILT_COST")
	self.fields.icon_success:setURL(SoraDFIsRA() and "frame_zjccs_promoted_ar.png" or "frame_zjccs_promoted_en.png")
	_ENV = nil
	;(nil).val = string.formatnumberthousands(self.count)
	;(nil).name = armyDesRead.getName(self.toArmyId)
	self.fields.Text_num:setString(i18n("gilt_armor_text15", nil))
	self.fields.Com_army:initData(self.toArmyId)
	local lastCount = armorSystemCtrl:getMothyPromoteNum()
	_ENV = i18n("gilt_armor_text15", nil)
	i18n("gilt_armor_text15", nil).num = fguiHelper.getColorString("#E02B2B", string.formatnumberthousands(self.count))
	i18n("gilt_armor_text15", nil).army = fguiHelper.getColorString("#FFD43E", armyDesRead.getName(self.toArmyId))
	i18n("gilt_armor_text15", nil).last = string.formatnumberthousands(lastCount)
	self.fields.Text_tip:setString(i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil)))
	local resID = self.giltCost[1]
	local resCount = self.giltCost[2]
	_ENV, _ENV = i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil))
	i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil)).resID = self.armyId
	_ENV, i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil))[1], i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil)).rescount = i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil))
	i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil)).resID = resID
	self.resList, i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil))[2], i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil)).rescount = i18n("gilt_armor_text35", i18n("gilt_armor_text15", nil))
	self.fields.List_res:setNumItems(#self.resList)
end
return soldiersPromoteTSuccessPanel
