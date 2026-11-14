local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local publicRead = include("publicRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentMgr = include("equipmentMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001722_MainPanel = class("Activity_9001722_MainPanel", baseFguiPanel)
function Activity_9001722_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001722_MainPanel.super.ctor(self, ...)
	print("Activity_9001722_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_EQUIPMENT_ACTIVITY
	local cfg = equipmentltCtrl.getNebulaEquipLimitReturnCfg()
	self.exchangeItem = cfg[1].returnItem1[1]
	self.exchangeList, Activity_9001722_MainPanel, self.exchangeItemNum = cfg[1].returnItem1[2], cfg[1].returnItem1[2], cfg[1].returnItem1[2]
	for k, v in ipairs(cfg) do
		table.insert(self.exchangeList, v.equipid)
	end
end
function Activity_9001722_MainPanel:onInit()
	print("=======Activity_9001722_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:setTitleWidthHeight(480, 40)
	self.fields.Label_title:setString(publicRead.getName(self.exchangeItem))
	self.fields.equip_to:initData(self.exchangeItem, self.exchangeItemNum)
	self.fields.Text_onlyOne:setString(i18n("nebula_equip_rebuid_04"))
	self.fields.Text_tip:setString(i18n("nebula_equip_rebuid_03"))
	self.fields.Text_none:setString(i18n("nebula_equip_rebuid_05"))
	self.fields.List:setItemRenderer(handler(self, self.onEquipRederer))
	self.fields.List:addClickListener(handler(self, self.onClickEquipList))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
end
function Activity_9001722_MainPanel:onEquipRederer(index, obj)
	obj:setLongClick(function(equip)
		self:updateEquipPop(equip)
	end)
	obj:setSelectShow(true)
	obj:initData(self.equipList[index + 1])
end
function Activity_9001722_MainPanel:onClickEquipList()
	SoraDPlaySound()
	self:updateShow()
end
function Activity_9001722_MainPanel:hideTips()
	self.fields.Com_equipPop:setVisible(false)
end
function Activity_9001722_MainPanel:updateEquipPop(equip)
	if equip then
		self.fields.Com_equipPop:setVisible(true)
		self.fields.Com_equipPop:initData(equip)
		self.fields.Com_equipPop:setPositionY(self.fields.List:getPositionY() + self.fields.Com_equipPop:getRealHeight() / 2 - 280)
	else
		self.fields.Com_equipPop:setVisible(false)
	end
end
function Activity_9001722_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_equip_rebuid_02")
	uiManager:show("RuleView", nil)
end
function Activity_9001722_MainPanel:endShow()
	print("=======Activity_9001722_MainPanel:endShow")
	self.fields.Com_equipPop:setVisible(false)
	self.fields.List:setSelectedIndex(-1)
	self:initView()
end
function Activity_9001722_MainPanel:initView()
	SoraDCloseLoading(self)
	self.equipList = equipmentMgr.getHaveEquipment(self.exchangeList)
	self.fields.List:setNumItems(#self.equipList)
	self.fields.List:setScrollEnable(#self.equipList > 12)
	self.controllers.c1:setSelectedIndex(#self.equipList == 0 and 0 or 1)
	self:updateShow()
end
function Activity_9001722_MainPanel:updateShow()
	self.nebulaExchangeInfo = equipmentCtrl:getNebulaExchangeInfo()
	if self.nebulaExchangeInfo.exchangeEid then
		self.fields.Button_exchange:setEnabled(false)
		self.selectEquip = nil
		self.fields.equip_from:setVisible(false)
		self.fields.List:setSelectedIndex(-1)
		self.fields.Button_exchange:setString(i18n("nebula_equip_rebuid_08"))
	else
		self.fields.Button_exchange:setString(i18n("common_text_1889"))
		local index = self.fields.List:getSelectedIndex() + 1
		self.selectEquip = self.equipList[index]
		if self.selectEquip then
			self.fields.equip_from:setVisible(true)
			self.fields.equip_from:initData(self.selectEquip)
		else
			self.fields.equip_from:setVisible(false)
		end
		self.fields.Button_exchange:setEnabled(true)
		self.fields.Button_exchange:setBright(self.selectEquip and true or false)
	end
end
function Activity_9001722_MainPanel:btnExchangeClick()
	SoraDPlaySound()
	if not self.selectEquip then
		SoraDShowMsgTip(i18n("nebula_equip_rebuid_06"))
		return
	end
	if equipmentCtrl:isEquipmentLocked(self.selectEquip:getEPID()) then
		SoraDShowMsgTip(i18n("Safety_lock_text_37"))
		return
	end
	_ENV = i18n("Safety_lock_text_37")
	i18n("Safety_lock_text_37").content = i18n("nebula_equip_rebuid_07")
	i18n("Safety_lock_text_37").cancelString = i18n("common_text_185")
	i18n("Safety_lock_text_37").confirmFunc = function()
		equipmentCtrl:equipmentNebulaExchange(self.selectEquip:getEPID())
		SoraDShowLoading(self)
	end
	uiManager:show("MessageBox", i18n("Safety_lock_text_37"))
end
return Activity_9001722_MainPanel
