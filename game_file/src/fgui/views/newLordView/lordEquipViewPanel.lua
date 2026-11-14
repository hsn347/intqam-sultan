local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local lordLocalData = include("lordLocalData")
local equipmentMgr = include("equipmentMgr")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local achiDesRead = include("achiDesRead")
local militaryRankRead = include("militaryRankRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipDesRead = include("equipDesRead")
local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordEquipViewPanel = class("lordEquipViewPanel", baseFguiPanel)
function lordEquipViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordEquipViewPanel:ctor", self.viewName)
end
function lordEquipViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordEquipViewPanel:onInit()
	print("=======lordEquipViewPanel:onInit")
	self.tbAttrList, _ENV, self.tablePlayerInfo, _ENV, self.isHideCurrentSceneView = print, print, print, print, true
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Text_Item_Title:setString(i18n("common_text_1961"))
	self.fields.Com_equipInfoPop:setVisible(false)
	self.fields.btn_equip:setString(i18n("common_text_1328"))
	self.fields.btn_equip:addClickListener(handler(self, self.onClick_btn_equip))
	self.fields.btn_reset:setString(i18n("common_text_4152"))
	self.fields.btn_reset:addClickListener(handler(self, self.onClick_btn_reset))
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemRenderer))
	for i = 1, 8 do
		self.fields["equip_" .. i]:fixPos()
	end
end
function lordEquipViewPanel:onShow()
	print("=======lordEquipViewPanel:onShow")
	self:initData()
end
function lordEquipViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tbAttrList[index + 1], index + 1)
end
function lordEquipViewPanel:initData()
	self.tablePlayerInfo = lordInfoCtrl:getLordInfo()
	self.fields.Spine_lord:initData(self.tablePlayerInfo.base.imageId)
	if not self.selIndex then
		local selIndex = 1
		local curActiveSetID = equipmentCtrl:getActiveSet()
		if curActiveSetID then
			curActiveSetID = tonumber(curActiveSetID)
			selIndex = curActiveSetID
		end
		self:didSelectTab(selIndex)
	else
		self:updateView()
	end
end
function lordEquipViewPanel:didSelectTab(index)
	self.selIndex = index
	self.setID = tostring(self.selIndex)
	self:updateView()
	self:updateTitle()
end
function lordEquipViewPanel:updateView()
	self:initEquip()
	self:updateBottomBtn()
end
function lordEquipViewPanel:sMsgEquipSetActiveBack(target, data)
	SoraDShowMsgTip(i18n("lordequip_text_03"))
	self:updateBottomBtn()
end
function lordEquipViewPanel:sMsgEquipRenameBack(target, data)
	local err = data.err
	if err == gErrDef.Err_None then
		self:updateTitle()
	else
		local isOK, needVipLv = equipmentCtrl:isEquipmentSetUnlock(tostring(self.setID))
		if not isOK then
			_ENV = tostring(self.setID)
			tostring(self.setID).lv = needVipLv
			SoraDShowMsgTip(i18n("common_text_3242", tostring(self.setID)))
		end
	end
end
function lordEquipViewPanel:sMsgUpdateVip(target, data)
	local vipDetail = lordInfoCtrl:getVipDetails()
	if not vipDetail.isActivated then
		self:updateBottomBtn()
	end
end
function lordEquipViewPanel:updateTitle()
	local ctype = combinationCtrl.COMBINATION_TYPE.EQUIPMENT
	local equipTitle = combinationCtrl:getSetName(ctype, self.setID)
	self.fields.Com_title:updateTitle(equipTitle)
	combinationCtrl = equipTitle
	equipTitle.setID = self.setID
	equipTitle.ctype = combinationCtrl.COMBINATION_TYPE.EQUIPMENT
	equipTitle.rtype = 1
	function equipTitle.handle(selectID)
		if not tolua.isnull(self) then
			self:didSelectTab(selectID)
		end
	end
	self.fields.Com_setTitle:initData(equipTitle)
end
function lordEquipViewPanel:initEquip()
	for i = 1, 8 do
		self.fields["equip_" .. i]:initData(i, equipmentCtrl:getEquipmentSetPart(self.setID, i), self.setID, true)
	end
	self.tbAttrList, equipmentCtrl = 1, (for index)
	local tbAttr = equipmentCtrl:getEquipmentSetPropertyList(self.setID)
	for i, v in ipairs(tbAttr) do
		local attrName, attrValue = self:getTitleAndValueStr(v)
		equipmentCtrl = i
		i.name = attrName
		i.value = attrValue
		table.insert(self.tbAttrList, i)
	end
	self.fields.List_attr:setNumItems(#self.tbAttrList)
end
function lordEquipViewPanel:getTitleAndValueStr(v)
	if v[3] then
		local titleStr = attrltCtrl.getAttrDes(v[1])
		local attrType = attrltCtrl.getAttrType(v[1])
		local valueStr = propParser.getFormatByAttrTypeAndValue(attrType, v[2], attrltCtrl.getShowValueType(attrType))
		return titleStr, valueStr
	else
		return equipDesRead.getAttrName(v[1]), string.format("+%s", equipDesRead.getSuitpropertyDes(v[1], v[2]))
	end
end
function lordEquipViewPanel:updateEquipPop(target, data)
	if data.data then
		self.fields.Com_equipInfoPop:setVisible(true)
		local equipInfo = equipmentMgr.getAllPartEquipment()
		self.fields.Com_equipInfoPop:initData(data.data, equipInfo)
		local line = math.ceil(data.index / 2) - 1
		self.fields.Com_equipInfoPop:setPositionY(line * 110 + self.fields.Com_equipInfoPop:getRealHeight() / 2 + 30)
	else
		self.fields.Com_equipInfoPop:setVisible(false)
	end
end
function lordEquipViewPanel:updateBottomBtn()
	local curActiveSetID = equipmentCtrl:getActiveSet()
	curActiveSetID = curActiveSetID and tonumber(curActiveSetID)
	if self.selIndex == curActiveSetID then
		self.fields.btn_equip:setVisible(false)
		self.fields.btn_reset:setPositionX(self:getWidth() / 2)
	else
		self.fields.btn_equip:setVisible(true)
		self.fields.btn_equip:setPositionX(SoraDFPosX(self:getWidth() / 2 + 140, self:getWidth()))
		self.fields.btn_reset:setPositionX(SoraDFPosX(self:getWidth() / 2 - 140, self:getWidth()))
	end
	local numOfEquips = self:getNumOfEquips()
	self.fields.btn_reset:setEnabled(0 < numOfEquips)
	self.fields.btn_equip:setEnabled(0 < numOfEquips)
end
function lordEquipViewPanel:getNumOfEquips()
	local numOfEquip = 0
	for i = 1, 8 do
		if self.fields["equip_" .. i]:isWearEquip() then
			numOfEquip = numOfEquip + 1
		end
	end
	return numOfEquip
end
function lordEquipViewPanel:checkVipActive(needShowTip)
	local isOK, needVipLv = equipmentCtrl:isEquipmentSetUnlock(tostring(self.setID))
	if needShowTip and not isOK then
		equipmentCtrl = tostring(self.setID)
		tostring(self.setID).lv = needVipLv
		SoraDShowMsgTip(i18n("lordequip_text_11", tostring(self.setID)))
	end
	return isOK
end
function lordEquipViewPanel:onClick_btn_equip()
	SoraDPlaySound()
	if not self:checkVipActive(true) then
		return
	end
	local numOfEquips = self:getNumOfEquips()
	print("numOfEquips = ", numOfEquips)
	if numOfEquips < 6 then
		SoraDShowMsgBox(i18n("lordequip_text_02"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				equipmentCtrl:acitveEquipmentSet(self.setID)
			end
		end)
	else
		equipmentCtrl:acitveEquipmentSet(self.setID)
	end
end
function lordEquipViewPanel:onClick_btn_reset()
	SoraDPlaySound()
	if not self:checkVipActive(true) then
		return
	end
	SoraDShowMsgBox(i18n("Equipment_reset_tips_0001"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			equipmentCtrl:resetEquipmentSet(self.setID)
		end
	end)
end
return lordEquipViewPanel
