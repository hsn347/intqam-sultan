local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local equipmentMgr = include("equipmentMgr")
local MIN_EQUIPMENT_LEVEL = 40
local MAX_EQUIPMENT_LEVEL = 100
local baseComponent = require("fgui.base.baseComponent")
local equipMenuColumnSingleSpecial = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/equipMenuColumnSingleSpecial", equipMenuColumnSingleSpecial)
function equipMenuColumnSingleSpecial:onInit()
	self.operateType = gEquipOperateType.FORGE
	self.data = nil
	self.nextEquipData = nil
	self.part = 1
	self.btnList, _ENV, self.setID = gEquipOperateType.FORGE, gEquipOperateType.FORGE, nil
	self.fields.Btn_suit:addClickListener(handler(self, self.clickSuitDetail))
	self.fields.List_btns:setItemRenderer(handler(self, self.onBtnsRenderer))
	self:fixChildrenPos()
end
function equipMenuColumnSingleSpecial:onBtnsRenderer(index, obj)
	local btnInfo = self.btnList[index + 1]
	obj:setBtnColorIndex(btnInfo.colorEnum or 0)
	obj:setString(btnInfo.title)
	obj.handle = btnInfo.handle
	if not obj.isInit then
		obj:addClickListener(function()
			obj.handle()
		end)
		obj.isInit = true
	end
end
function equipMenuColumnSingleSpecial:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_INTENSIFY_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.updateView))
end
function equipMenuColumnSingleSpecial:onShow()
end
function equipMenuColumnSingleSpecial:updateView(target, data)
	if self.data then
		if data.msg == "MESSAGE_SERVER_EQUIP_FORGE_BACK" or data.msg == "MESSAGE_SERVER_EQUIP_FORGE_FINISH" or data.msg == "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK" then
			SoraDGetEquip()
			if self.operateType == gEquipOperateType.FORGE then
				self:initData(self.data, self.operateType)
			end
		elseif data.msg == "MESSAGE_SERVER_EQUIP_INTENSIFY_BACK" or data.msg == "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE" then
			if self.operateType == gEquipOperateType.INTENSIFY and data.epid == self.data:getEPID() and self.operateType ~= gEquipOperateType.FORGE then
				self:initData(self.data, self.operateType)
			end
		elseif data.msg == "MESSAGE_SERVER_EQUIP_WEAR_BACK" and self.operateType ~= gEquipOperateType.FORGE and data.epid == self.data:getEPID() then
			self.fields.Sprite_wear:setVisible(self.data:isWearing())
			if self.fields.Btn_suit then
				local equipInfo = equipmentltCtrl.getEquipCfg(self.data:getEID())
				local isSuit = false
				if equipInfo and equipInfo.suitequipID ~= 0 and self.data:isWearing() then
					isSuit = true
				end
				self.fields.Btn_suit:setVisible(isSuit)
			end
		end
	end
end
function equipMenuColumnSingleSpecial:initData(data, operateType, part, setID)
	self.data = data
	self.operateType = operateType
	self.part = part
	self.setID = setID
	_ENV, _ENV, self.nextEquipData = nil, nil, nil
	;(nil).name = "Button_baptize"
	;(nil).title = i18n("common_text_1341")
	;(nil).handle = handler(self, self.btnBaptizeClickCallBack)
	_ENV, (nil)[1], (nil).colorEnum = nil, nil, 0
	;(nil).name = "Button_intensify"
	;(nil).title = i18n("common_text_1340")
	;(nil).handle = handler(self, self.btnIntensifyClickCallBack)
	self.btnList, (nil)[2], (nil).colorEnum = nil, nil, 0
	if self.data then
		self.controllers.c1:setSelectedIndex(0)
		self:setEquipInfo()
		self.isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.data:getEID())
		if not (self.data:getEquipmentQuality() ~= gQualityDef.PURPLE or equipmentltCtrl.judgeSuitEquipByEid(self.data:getEID())) or self.data:getEquipmentQuality() == gQualityDef.ORANGE and not self.isSuitEquip then
			local equipPartList = equipmentltCtrl.getEquipmentList(self.part)
			local equipLv = self.data:getEquipmentLV()
			for i, v in ipairs(equipPartList) do
				if equipLv == v.level then
					self.nextEquipData = v
					break
				end
			end
			local nextEquipment = equipmentltCtrl.getNextOrangeEquipInfo(self.data:getEID(), self.data:getEquipmentQuality() == gQualityDef.ORANGE)
			if self.nextEquipData and SoraDGetLordLv() >= self.nextEquipData.level and nextEquipment then
				local titleStr = self.data:getEquipmentQuality() == gQualityDef.PURPLE and i18n("equip_text_22") or i18n("equip_text_49")
				_ENV = self.data:getEID()
				self.data:getEID().name = "Button_orange"
				self.data:getEID().title = titleStr
				self.data:getEID().handle = handler(self, self.btnOrangeClickCallBack)
				self.data:getEID().colorEnum = 0
				table.insert(self.btnList, self.data:getEID())
			end
		end
		if (gEquipTypeDef.EQUIP_LEGEND == self.data:getEquipmentType() or gEquipTypeDef.EQUIP_NEBULA == self.data:getEquipmentType()) and equipDesRead.getKingEquipConfig(self.data:getEID()) then
			_ENV = self.data:getEID()
			self.data:getEID().name = "Button_refine"
			self.data:getEID().title = i18n("equip_btn_01")
			self.data:getEID().handle = handler(self, self.btnRefineClickCallBack)
			self.data:getEID().colorEnum = 0
			table.insert(self.btnList, self.data:getEID())
		end
		local titleInfo = ""
		if self.operateType == gEquipOperateType.FORGE then
			titleInfo = i18n("common_text_829")
		elseif self.operateType == gEquipOperateType.BAPTIZE or self.operateType == gEquipOperateType.INTENSIFY or self.operateType == gEquipOperateType.EQUIP then
			if self.operateType == gEquipOperateType.INTENSIFY then
				local max = equipmentltCtrl.getStrengthenMaxLv(self.data:getEquipmentLV(), self.data:getEquipmentType())
				if max <= self.data:getEquipmentSLV() then
					titleInfo = i18n("common_text_829")
				else
					titleInfo = i18n("common_text_1340")
				end
			elseif self.operateType == gEquipOperateType.BAPTIZE then
				if self.data:getEquipmentQuality() > gQualityDef.WHITE then
					titleInfo = i18n("common_text_1341")
				else
					titleInfo = i18n("common_text_829")
				end
			elseif self.operateType == gEquipOperateType.EQUIP then
				titleInfo = i18n("common_text_1328")
			end
		elseif self.operateType == gEquipOperateType.REMOVE then
			titleInfo = i18n("common_text_1329")
		end
		_ENV = "common_text_1340"
		;("common_text_1340").name = "Button_info"
		;("common_text_1340").title = titleInfo
		;("common_text_1340").handle = handler(self, self.btnClickCallBack)
		;("common_text_1340").colorEnum = 2
		table.insert(self.btnList, "common_text_1340")
		self.fields.List_btns:setNumItems(#self.btnList)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_attr:setHeight(126)
		self:setHeight(214)
		self:setJumpInfo()
	end
end
function equipMenuColumnSingleSpecial:setJumpInfo()
	self.fields.com_equip:initWear(self.part)
	_ENV = nil
	;(nil).equip = equipDesRead.getPartName(self.part)
	self.fields.Text_tip_none:setString(i18n("common_text_1399", nil))
end
function equipMenuColumnSingleSpecial:setEquipInfo()
