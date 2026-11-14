local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentMgr = include("equipmentMgr")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_selectNeed = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_selectNeed", Btn_selectNeed)
function Btn_selectNeed:onInit()
	self.fields.sheer_tbg:setVisible(false)
	self.fields.Text_time:setVisible(false)
	self.fields.select:setVisible(false)
	self.fields.max:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
	self.fields.Text_num:fixPos()
	self.fields.Text_qlv:fixPos()
	self.fields.select:fixPos()
	self.fields.max:fixPos()
end
function Btn_selectNeed:onShow()
end
function Btn_selectNeed:initData(data, mode, tag, index, selectIndex)
	self.data = data
	self.mode = mode
	self.tag = tag
	self.index = index
	self.selectIndex = selectIndex
	if self.mode == 0 then
		self.fields.icon_base:setSpriteFrame(itemDesRead.getBg(self.data.mid))
		self.fields.icon:setSpriteFrame(itemDesRead.getIcon(self.data.mid))
		self.fields.Text_num:setVisible(true)
		self.fields.Text_num:setString(self.data.count)
		self.fields.sheer:setVisible(self.selectIndex and self.index == self.selectIndex or false)
		self.fields.select:setVisible(self.selectIndex and self.index == self.selectIndex or false)
	else
		local equipLv = self.data:getEquipmentLV()
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.data:getEID())
		if isSuitEquip then
			equipLv = equipLv % 100
		end
		self.fields.icon_base:setSpriteFrame(equipDesRead.getBg(self.data:getEquipmentQuality()))
		self.fields.icon:setSpriteFrame(equipDesRead.getIcon(self.data:getEID()))
		local equipType = self.data:getEquipmentType()
		if equipType == gEquipTypeDef.EQUIP_LEGEND then
			self.fields.Text_num:setVisible(false)
		else
			self.fields.Text_num:setVisible(true)
			itemDesRead = equipDesRead.getIcon(self.data:getEID())
			equipDesRead.getIcon(self.data:getEID()).lv = equipLv
			self.fields.Text_num:setString(i18n("common_text_101", equipDesRead.getIcon(self.data:getEID())))
		end
		local maxSLV = equipmentltCtrl.getStrengthenMaxLv(equipLv, self.data:getEquipmentType())
		if maxSLV > self.data:getEquipmentSLV() then
			self.fields.max:setVisible(false)
			self.fields.Text_qlv:setString("+" .. self.data:getEquipmentSLV())
			self.fields.Text_qlv:setVisible(true)
		else
			self.fields.max:setVisible(true)
			self.fields.Text_qlv:setVisible(false)
		end
		local endTime = self.data:getEquipmentEndTimeProperty()
		if endTime and 0 < endTime then
			self.fields.sheer_tbg:setVisible(true)
			self.fields.Text_time:setVisible(true)
			self.fields.Text_time:beginTime(endTime - serviceFunctions.systemTime())
		end
		self.fields.sheer:setVisible(self.selectIndex and self.index == self.selectIndex or false)
		self.fields.select:setVisible(self.selectIndex and self.index == self.selectIndex or false)
	end
end
function Btn_selectNeed:btnClick()
	SoraDPlaySound()
	if self.mode == 0 then
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_EQUIP_FORGE_SELECT"
		;(nil).mid = self.data.mid
		;(nil).tag = self.tag
		;(nil).index = self.index
		SoraDSendMessage(nil)
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_EQUIP_FORGE_SELECT"
		;(nil).baseEquip = self.data
		;(nil).index = self.index
		SoraDSendMessage(nil)
	end
end
return Btn_selectNeed
