local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipOrangeBuyMorePopViewPanel = class("equipOrangeBuyMorePopViewPanel", baseFguiPanel)
function equipOrangeBuyMorePopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipOrangeBuyMorePopViewPanel:ctor", self.viewName)
end
function equipOrangeBuyMorePopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipOrangeBuyMorePopViewPanel:onInit()
	print("=======equipOrangeBuyMorePopViewPanel:onInit")
	self.methodList, _ENV = print, print
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function equipOrangeBuyMorePopViewPanel:onShow()
	print("=======equipOrangeBuyMorePopViewPanel:onShow")
	self.materialID = self.param.materialID
	self.isOrange = self.param.isOrange or false
	self.isArtifact = self.param.isArtifact or false
	if self.isArtifact then
		self:initDataEx()
	else
		self:initData()
	end
end
function equipOrangeBuyMorePopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.methodList[index + 1])
end
function equipOrangeBuyMorePopViewPanel:initData()
	local itemName = itemDesRead.getName(self.materialID)
	itemDesRead = nil
	;(nil).name = itemName
	self.fields.txtDes:setString(i18n("equip_text_27", nil))
	self.methodList, itemDesRead = self.fields.txtDes.setString, self.fields.txtDes.setString
	itemDesRead = i18n("equip_text_27", nil)
	i18n("equip_text_27", nil).title = i18n("equip_text_28")
	i18n("equip_text_27", nil).handle = handler(self, self.onMaterialGoClick)
	table.insert(self.methodList, i18n("equip_text_27", nil))
	itemDesRead = i18n("equip_text_27", nil)
	i18n("equip_text_27", nil).title = i18n("equip_text_29")
	i18n("equip_text_27", nil).handle = handler(self, self.onBoxClick)
	table.insert(self.methodList, i18n("equip_text_27", nil))
	self.fields.List:setNumItems(#self.methodList)
end
function equipOrangeBuyMorePopViewPanel:initDataEx()
	local itemName = itemDesRead.getName(self.materialID)
	itemDesRead = nil
	;(nil).name = itemName
	self.fields.txtDes:setString(i18n("equip_text_27", nil))
	self.methodList, itemDesRead = self.fields.txtDes.setString, self.fields.txtDes.setString
	itemDesRead = i18n("equip_text_27", nil)
	i18n("equip_text_27", nil).title = i18n("return_lcks_text_036")
	i18n("equip_text_27", nil).handle = handler(self, self.onShopClick)
	table.insert(self.methodList, i18n("equip_text_27", nil))
	itemDesRead = i18n("equip_text_27", nil)
	i18n("equip_text_27", nil).title = i18n("activity_name_9001168")
	i18n("equip_text_27", nil).handle = handler(self, self.onActivityClick)
	table.insert(self.methodList, i18n("equip_text_27", nil))
	self.fields.List:setNumItems(#self.methodList)
end
function equipOrangeBuyMorePopViewPanel:onMaterialGoClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mid = self.isOrange and self.materialID - 1 or self.materialID
	uiManager:show("equipSetsMaterialsView", nil)
	self:close()
end
function equipOrangeBuyMorePopViewPanel:onBoxClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemType = gItemType.ORANGE_EQUIP_MATERIAL_BOX
	uiManager:show("PropBuyView", nil)
	self:close()
end
function equipOrangeBuyMorePopViewPanel:onShopClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = 1
	;(nil).jumpStore = "btnOther"
	uiManager:show("bagView", nil)
	self:close()
end
function equipOrangeBuyMorePopViewPanel:onActivityClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WRATH_BEAST_ACTIVITY) then
		local panel = SoraDCreatePanel("wrathBeastMainView")
		panel.ccs_tab:clickByTag(2)
		panel:show()
	else
		SoraDShowMsgTip(i18n("devilvalley_text_08"))
	end
	self:close()
end
return equipOrangeBuyMorePopViewPanel
