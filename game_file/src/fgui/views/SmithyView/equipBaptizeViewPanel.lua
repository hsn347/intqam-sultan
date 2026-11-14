local dailyRemindManager = include("dailyRemindManager")
local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local itemDesRead = include("itemDesRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipBaptizeViewPanel = class("equipBaptizeViewPanel", baseFguiPanel)
function equipBaptizeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipBaptizeViewPanel:ctor", self.viewName)
end
function equipBaptizeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipBaptizeViewPanel:onInit()
	print("=======equipBaptizeViewPanel:onInit")
	self.lockInfo, _ENV, self.needList, _ENV, self.attrList, _ENV = print, print, print, print, print, print
	self.curLockItem = 207701
	self.remakesArray, _ENV, self.curBaptizeItem = print, print, nil
	self.fields.Com_title:initData(i18n("common_text_1366"), handler(self, self.onClickClose))
	self.fields.Text_attr:setString(i18n("common_text_1368"))
	self.fields.Text_need:setString(i18n("Weapon_Rune_tips_053"))
	self.fields.Lab_pre:setString(i18n("common_text_1370"))
	self.fields.Button_bag:addClickListener(handler(self, self.btnBagClickCallBack))
	self.fields.Button_help:addClickListener(handler(self, self.OnBtnFAQClick))
	self.fields.Button_notice:setString(i18n("equipment_training_text_18"))
	self.fields.Button_notice:addClickListener(handler(self, self.btnNoticeClickCallBack))
	self.fields.Button_baptize:setString(i18n("common_text_1639"))
	self.fields.Button_baptize:addClickListener(handler(self, self.btnBaptizeClickCallBack))
	_ENV = handler(self, self.btnBaptizeClickCallBack)
	handler(self, self.btnBaptizeClickCallBack).num = 10
	self.fields.Button_ten:setString(i18n("common_text_4601", handler(self, self.btnBaptizeClickCallBack)))
	self.fields.Button_ten:addClickListener(handler(self, self.btnBaptizeTenClickCallBack))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.List_need:setItemRenderer(handler(self, self.onNeedRenderer))
	self.fields.List_preview:setItemRenderer(handler(self, self.onPreviewRenderer))
	self.fields.Com_activity:setVisible(false)
	self.fields.Button_help:fixPos()
	self.fields.Com_equip:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Button_notice:fixPos()
	self.fields.Text_attr:fixPos()
	self.fields.List_attr:fixPos()
end
function equipBaptizeViewPanel:onShow()
	print("=======equipBaptizeViewPanel:onShow")
	self.equipCell = self.param.equipData
	self.fields.Com_equip:initData(self.equipCell)
	self.fields.Text_name:setString(equipDesRead.getName(self.equipCell:getEID()))
	self.maxLockNum = equipDesRead.getMaxSelectNum(self.equipCell:getEquipmentQuality()) - 1
	self:initData()
end
function equipBaptizeViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.attrList[index + 1], self.lockInfo, self.maxLockNum)
end
function equipBaptizeViewPanel:onNeedRenderer(index, obj)
	obj:initData(self.needList[index + 1], self.equipCell)
end
function equipBaptizeViewPanel:onPreviewRenderer(index, obj)
	obj:initData(self.remakesArray[index + 1], self.equipCell)
end
function equipBaptizeViewPanel:initData()
	self:updateSteel()
	self:updateBtn()
	self:initAttrLabel()
	self:initScouringActivity()
	self:initStone()
	self.remakesArray, _ENV, self.remakes = self.equipCell:getEquipmentRemakeProperty(), self.equipCell:getEquipmentRemakeProperty(), self.equipCell:getEquipmentRemakeProperty()
	for k, v in ipairs(self.remakes) do
		_ENV = nil
		;(nil).index = k
		;(nil).data = v
		;(nil).isNotice = equipmentCtrl:isNoticeAttribute(self.equipCell, v)
		table.insert(self.remakesArray, nil)
	end
	table.sort(self.remakesArray, function(a, b)
		if a.isNotice == b.isNotice then
			return a.index < b.index
		end
		return a.isNotice
	end)
	self.controllers.c1:setSelectedIndex(#self.remakesArray > 0 and 1 or 0)
	self.fields.List_preview:setNumItems(#self.remakesArray)
	local suitH = self.fields.Text_need:getY() - self.fields.arrow:getY() - 45
	self.fields.List_preview:setHeight(suitH)
end
function equipBaptizeViewPanel:initStone()
	self.needList, equipmentltCtrl = nil, nil
	self.tableMaterial = equipmentltCtrl.getRemakeMaterialAndNum(self.equipCell:getEquipmentQuality())
	for i, v in ipairs(self.tableMaterial) do
		self.curBaptizeItem = v.id
		equipmentltCtrl = self.equipCell:getEquipmentQuality()
		self.equipCell:getEquipmentQuality().id = v.id
		self.equipCell:getEquipmentQuality().num = v.num
		self.equipCell:getEquipmentQuality().own = backpackCtrl:getItemCount(v.id)
		table.insert(self.needList, self.equipCell:getEquipmentQuality())
		break
	end
	local lockNum = self:getLockInfoNum()
	if 0 < lockNum then
		local costInfo = equipDesRead.getLockCostByNum(lockNum)
		equipmentltCtrl = self.equipCell:getEquipmentQuality()
		self.equipCell:getEquipmentQuality().id = costInfo[1]
		self.equipCell:getEquipmentQuality().num = costInfo[2]
		self.equipCell:getEquipmentQuality().own = backpackCtrl:getItemCount(costInfo[1])
		table.insert(self.needList, self.equipCell:getEquipmentQuality())
	end
	self.fields.List_need:setNumItems(#self.needList)
end
function equipBaptizeViewPanel:buffSelect(target, data)
	local buffID = data.buffID
	local isSelect = data.isSelect
	if isSelect then
		self.lockInfo[tostring(buffID)] = 1
	elseif self.lockInfo[tostring(buffID)] then
		self.lockInfo[tostring(buffID)] = nil
	end
	self.fields.List_attr:setNumItems(#self.attrList)
	self:initStone()
end
function equipBaptizeViewPanel:updateBtn()
	local remake = self.equipCell:getEquipmentRemakeProperty()
	local canFree = equipmentCtrl:canFreeRemaking()
	if #remake <= 0 then
		self.fields.Button_baptize:setString(canFree and i18n("common_text_1639") or i18n("common_text_1341"))
	else
		self.fields.Button_baptize:setTitleText(canFree and i18n("common_text_1639") or i18n("common_text_1372"))
	end
end
function equipBaptizeViewPanel:updateSteel()
	local haveSteel = cityCtrl:getResCount(gIDDef.STEEL)
	local needSteel = equipmentCtrl:getRealSteelNumOfRemake(self.equipCell:getEquipmentQuality())
	self.fields.Com_steelOne:initData(gIDDef.STEEL, haveSteel, needSteel, handler(self, self.showBuySteel))
	self.fields.Com_steelTen:initData(gIDDef.STEEL, haveSteel, needSteel * 10, handler(self, self.showBuySteel))
end
function equipBaptizeViewPanel:initScouringActivity()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY) then
		self.fields.Com_activity:setVisible(SoraDGetCastleLv() >= CASTLE_LV10_LIMITED)
		self.fields.Com_activity:initData()
	else
		self.fields.Com_activity:setVisible(false)
	end
end
function equipBaptizeViewPanel:limitTimeOut(target, data)
	if data.epid and data.epid == self.equipCell:getEPID() then
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function equipBaptizeViewPanel:equipDataUpdate()
	SoraDRemoveAllPrePanelFromManager(self)
end
function equipBaptizeViewPanel:initAttrLabel()
