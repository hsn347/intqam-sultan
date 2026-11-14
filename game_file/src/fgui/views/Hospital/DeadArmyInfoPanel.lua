local lifeWaterCtrl = SoraDGetCtrl("lifeWaterCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DeadArmyInfoPanel = class("DeadArmyInfoPanel", baseFguiPanel)
function DeadArmyInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DeadArmyInfoPanel:ctor", self.viewName)
end
function DeadArmyInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DeadArmyInfoPanel:onInit()
	print("=======DeadArmyInfoPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_3459"))
	self.fields.Text_info:setString(i18n("legendaryking_text_73"))
	self.fields.Text_num:setString(i18n("legendaryking_text_75"))
	self.fields.Text_name:setString(i18n("legendaryking_text_74"))
	self.fields.Text_tip:setString(i18n("legendaryking_text_79"))
	self.fields.Button_go:setString(i18n("legendaryking_text_80"))
	self.fields.Button_go:addClickListener(handler(self, self.onBtnGoClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_num:fixPos()
	self.fields.Text_name:fixPos()
end
function DeadArmyInfoPanel:onItemRenderer(index, obj)
	obj:initData(self.armyInfo[index + 1])
end
function DeadArmyInfoPanel:onShow()
	print("=======DeadArmyInfoPanel:onShow")
	local ret, info = lifeWaterCtrl:getValueArmy()
	self.armyInfo = info
	dump(self.armyInfo, "self.armyInfo===")
	self.fields.List:setNumItems(#self.armyInfo)
end
function DeadArmyInfoPanel:onBtnGoClick()
	SoraDPlaySound()
	uiManager:show("LifeSpringsView")
	self:close()
end
return DeadArmyInfoPanel
