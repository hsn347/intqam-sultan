local cityCtrl = SoraDGetCtrl("cityCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local funUnlockRead = include("funUnlockRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local smithyViewPanel = class("smithyViewPanel", baseFguiPanel)
function smithyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("smithyViewPanel:ctor", self.viewName)
end
function smithyViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function smithyViewPanel:onInit()
	print("=======smithyViewPanel:onInit")
	self.fields.Com_title:initData(i18n("buildDes_name_115"), handler(self, self.onClickClose))
	self.fields.Button_bag:addClickListener(handler(self, self.btnBagClickCallBack))
	self.fields.Top_Button_forge:setString(i18n("common_text_1339"))
	self.fields.Top_Button_forge:addClickListener(handler(self, self.btnForgeClick))
	self.fields.Button_intensify:setString(i18n("common_text_1340"))
	self.fields.Button_intensify:addClickListener(handler(self, self.btnIntensifyClick))
	self.fields.Center_Button_baptize:setString(i18n("common_text_1341"))
	self.fields.Center_Button_baptize:addClickListener(handler(self, self.btnBaptizeClick))
	self.fields.Center_Button_suit:setString(i18n("suit_title_01"))
	self.fields.Center_Button_suit:addClickListener(handler(self, self.btnSuitClick))
	self.fields.Center_Button_orange:setString(i18n("equip_text_22"))
	self.fields.Center_Button_orange:addClickListener(handler(self, self.btnOrangeClick))
	self.fields.Btn_overdue:setString(i18n("legend_equip_return_001"))
	self.fields.Btn_overdue:addClickListener(handler(self, self.btnOverdueClick))
end
function smithyViewPanel:onShow()
	print("=======smithyViewPanel:onShow")
	local isOpen = serviceFunctions.systemTime() >= constantRead.getConstValue("LEGEND_EQUIP_RETURN_OPEN_TIME")
	self.fields.Btn_overdue:setVisible(isOpen)
	self:updateSteel()
	self:showForge()
	self:checkSuitStatus()
	self:checkOrangeStatus()
	self:checkBaptizeStatus()
	self:checkOverdueStatus()
end
function smithyViewPanel:updateSteel()
	self.fields.Com_steel:initData(cityCtrl:getResCount(gIDDef.STEEL))
end
function smithyViewPanel:showForge()
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.forge_equipment)
	if self.queue then
		local leftTime = self.queue.timerNode.timer:getRemainTime()
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.queue.data.eid)
		if isSuitEquip then
			self.fields.Center_Button_suit:setTime(leftTime)
		elseif self.queue.data.qly == gQualityDef.ORANGE then
			self.fields.Center_Button_orange:setTime(leftTime)
		else
			self.fields.Top_Button_forge:setTime(leftTime)
		end
	else
		self.fields.Center_Button_suit:setTime(0)
		self.fields.Center_Button_orange:setTime(0)
		self.fields.Top_Button_forge:setTime(0)
	end
end
function smithyViewPanel:checkSuitStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.SUIT_EQUIP)
	self.fields.Center_Button_suit:setVisible(unlockLv <= SoraDGetCastleLv())
end
function smithyViewPanel:checkOrangeStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ORANGE_FORGE)
	self.fields.Center_Button_orange:setVisible(unlockLv <= SoraDGetCastleLv())
end
function smithyViewPanel:checkBaptizeStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EQUIP_CLEAR)
	self.fields.Center_Button_baptize:setVisible(unlockLv <= SoraDGetCastleLv())
end
function smithyViewPanel:checkOverdueStatus()
	if not equipmentCtrl:getOverdueEquipments() then
		local equipmentCtrl, equipList = equipmentCtrl:getOverdueEquipments(), equipmentCtrl:getOverdueEquipments()
	end
	self.isHaveOverdue = table.nums(equipList) > 0
	self.fields.Btn_overdue:getController("c1"):setSelectedIndex(self.isHaveOverdue and 1 or 0)
	self.fields.Btn_overdue:setReddot(self.isHaveOverdue)
end
function smithyViewPanel:btnForgeClick()
	SoraDPlaySound("equipment", 1)
	_ENV = nil
	;(nil).operateType = gEquipOperateType.FORGE
	uiManager:show("equipMenuView", nil)
end
function smithyViewPanel:btnIntensifyClick()
	SoraDPlaySound("equipment", 1)
	_ENV = nil
	;(nil).operateType = gEquipOperateType.INTENSIFY
	uiManager:show("equipMenuView", nil)
end
function smithyViewPanel:btnBaptizeClick()
	SoraDPlaySound("equipment", 1)
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EQUIP_CLEAR)
	if unlockLv > SoraDGetCastleLv() then
		_ENV = nil
		;(nil).name = i18n("common_text_1341")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
		return
	end
	_ENV = i18n("common_text_2122", nil)
	i18n("common_text_2122", nil).operateType = gEquipOperateType.BAPTIZE
	uiManager:show("equipMenuView", i18n("common_text_2122", nil))
end
function smithyViewPanel:btnSuitClick()
	SoraDPlaySound("equipment", 1)
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.SUIT_EQUIP)
	if unlockLv <= SoraDGetCastleLv() then
		uiManager:show("suitMainView")
	else
		_ENV = nil
		;(nil).name = i18n("suit_title_01")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	end
end
function smithyViewPanel:btnOrangeClick()
	SoraDPlaySound("equipment", 1)
	if SoraDGetLordLv() < CASTLE_LV40_LIMITED then
		SoraDShowMsgTip(i18n("equip_text_23"))
		return
	end
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ORANGE_FORGE)
	if unlockLv > SoraDGetCastleLv() then
		_ENV = i18n("equip_text_23")
		i18n("equip_text_23").name = i18n("equip_text_22")
		i18n("equip_text_23").lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", i18n("equip_text_23")))
		return
	end
	_ENV = i18n("common_text_2122", i18n("equip_text_23"))
	i18n("common_text_2122", i18n("equip_text_23")).operateType = gEquipOperateType.ORANGE
	uiManager:show("equipMenuView", i18n("common_text_2122", i18n("equip_text_23")))
end
function smithyViewPanel:btnBagClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = gEquipMaterialType.EQUIP
	uiManager:show("storageBoxView", nil)
end
function smithyViewPanel:btnOverdueClick()
	SoraDPlaySound()
	if self.isHaveOverdue then
		uiManager:show("equipOverdueGainView")
	else
		uiManager:show("equipOverduePreView")
	end
end
return smithyViewPanel
