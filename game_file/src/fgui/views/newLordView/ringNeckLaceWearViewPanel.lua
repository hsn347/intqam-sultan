local equipmentMgr = include("equipmentMgr")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local CONCEAL_NECKLACE_ID = 6800401
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ringNeckLaceWearViewPanel = class("ringNeckLaceWearViewPanel", baseFguiPanel)
function ringNeckLaceWearViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ringNeckLaceWearViewPanel:ctor", self.viewName)
end
function ringNeckLaceWearViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ringNeckLaceWearViewPanel:onInit()
	print("=======ringNeckLaceWearViewPanel:onInit")
	self.specialList, _ENV, self.baseList, _ENV, self.tableSingle, _ENV = print, print, print, print, print, print
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Com_line:setString(i18n("common_text_4746"))
	self.fields.Text_Normal_Property:setString(i18n("equip_text_06"))
	self.fields.Text_Special_Property:setString(i18n("equip_text_07"))
	self.fields.Button_GoShop:setString(i18n("equip_text_11"))
	self.fields.Button_GoShop:addClickListener(handler(self, self.btnGoShopClick))
	self.fields.Button_info:setString(i18n("common_text_1329"))
	self.fields.Button_info:addClickListener(handler(self, self.btnInfoClick))
	self.fields.ScrollView_equip:setVirtual()
	self.fields.ScrollView_equip:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.ScrollView_Normal:setItemRenderer(handler(self, self.onNormalRenderer))
	self.fields.List_sp:setItemRenderer(handler(self, self.onSpecialRenderer))
	self.fields.Button_bless:setString(i18n("alliance_beast_btn_08"))
	self.fields.Button_bless:addClickListener(handler(self, self.btnBlessClick))
end
function ringNeckLaceWearViewPanel:endShow()
	print("=======ringNeckLaceWearViewPanel:endShow")
	self:initData(self.param.part, self.param.isWearing, self.param.setID)
	if commonCheck.NECKLACE then
		local isInWar = worldMapDefine.isInKingdomBattle() or worldMapDefine.isInWar() or worldMapDefine.isInPyramid()
		self.fields.Button_bless:setVisible(self.param.part == gEquipmentPart.NECKLACE and not isInWar)
	else
		self.fields.Button_bless:setVisible(false)
	end
end
function ringNeckLaceWearViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableSingle[index + 1], self.equipment and self.equipment:getEPID(), self.setID)
end
function ringNeckLaceWearViewPanel:onNormalRenderer(index, obj)
	obj:initData(self.baseList[index + 1], true)
end
function ringNeckLaceWearViewPanel:onSpecialRenderer(index, obj)
	obj:initData(self.specialList[index + 1])
end
function ringNeckLaceWearViewPanel:initData(part, isWearing, setID)
	self.part = part
	self.isWearing = isWearing or false
	self.setID = setID
	self.fields.Com_title:updateTitle(equipDesRead.getPartName(self.part))
	if part == gEquipmentPart.RING then
		self.fields.Button_GoShop:setVisible(true)
		self.fields.Text_NoEquipTips:setString(i18n("equip_text_36"))
		self.fields.Text_name:setString(i18n("equip_text_13"))
	else
		self.fields.Button_GoShop:setVisible(false)
		self.fields.Text_NoEquipTips:setString(i18n("equip_text_35"))
		self.fields.Text_name:setString(i18n("equip_text_14"))
	end
	if not setID then
		self.equipment = equipmentMgr.getPartEquipment(part)
	else
		self.equipment = equipmentCtrl:getEquipmentSetPart(setID, part)
	end
	self.controllers.c1:setSelectedIndex(self.equipment and 1 or 0)
	self:setEquipInfo()
	self:updateScrollData()
end
function ringNeckLaceWearViewPanel:updateScrollData(target, data)
	local curData = equipmentMgr.getEquipmentArrayWithFilerFromRing(self.part)
	local bagCapacity = self.part == gEquipmentPart.RING and equipmentMgr.getShowRingUnitNum() or equipmentMgr.getShowNeckLaceUnitNum()
	for i = 1, bagCapacity do
		equipmentMgr = nil
		self.tableSingle[i], (nil).data = nil, curData[i] or nil
	end
	self.fields.ScrollView_equip:setNumItems(#self.tableSingle)
end
function ringNeckLaceWearViewPanel:updateView(target, data)
	if data.msg == "MESSAGE_SERVER_EQUIP_SET_WEAR_BACK" and data.epid and data.part == self.part then
		self:initData(self.part, data.isWearing, self.setID)
	end
	if data.msg == "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT" and data.eid and equipmentltCtrl.getEquipmentPart(data.eid) == self.part then
		self:initData(self.part, data.isWearing, self.setID)
	end
end
function ringNeckLaceWearViewPanel:setEquipInfo()
	self.fields.Com_target:initData(self.part, self.equipment, self.setID)
	if self.equipment then
		self.fields.Text_name:setString(equipDesRead.getName(self.equipment:getEID()))
		self.baseList = equipmentltCtrl.getEquipmentAllProperty(self.equipment:getEID(), self.equipment:getEquipmentQuality(), self.equipment:getEquipmentSLV())
		self.specialList = equipmentltCtrl.getEquipmentSpecialProperty(self.equipment:getEID(), self.equipment:getEquipmentQuality())
		self.fields.ScrollView_Normal:setNumItems(#self.baseList)
		if self.specialList and next(self.specialList) then
			self.controllers.c2:setSelectedIndex(1)
			self.fields.List_sp:setNumItems(#self.specialList)
		else
			self.controllers.c2:setSelectedIndex(0)
		end
	end
end
function ringNeckLaceWearViewPanel:btnGoShopClick()
	SoraDPlaySound()
	uiManager:show("ringShopView")
end
function ringNeckLaceWearViewPanel:btnInfoClick()
	SoraDPlaySound()
	equipmentCtrl:takeOffEquipment(self.equipment:getEPID(), self.part, self.setID)
end
function ringNeckLaceWearViewPanel:btnBlessClick()
	SoraDPlaySound()
	local isOwn = equipmentMgr.isOwnHideNecklace(CONCEAL_NECKLACE_ID)
	if not isOwn then
		SoraDShowMsgTip(i18n("common_text_4950"))
		return
	end
	uiManager:show("neckTechView")
end
return ringNeckLaceWearViewPanel
