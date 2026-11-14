local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentMgr = include("equipmentMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_equipShow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_equipShow", Com_equipShow)
function Com_equipShow:onInit()
	self.fields.Lab_timer:setVisible(false)
	self.fields.max:setVisible(false)
	self.fields.n13:fix()
	self.fields.n14:fix()
	self.fields.Text_qlv:fixPos()
	self.fields.max:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.wear:fixPos()
	self.fields.spriteNew:fixPos()
end
function Com_equipShow:onShow()
end
function Com_equipShow:initData(data, selectID, spTimeShow, toEquip)
	self.data = data
	self.selectID = selectID
	self.fields.select:setVisible(self.selectID and self.data:getEID() == self.selectID or false)
	self.fields.icon_base:setSpriteFrame(equipDesRead.getBg(self.data:getEquipmentQuality()))
	self.fields.icon:setSpriteFrame(toEquip and equipDesRead.getIcon(toEquip.equipmentID) or equipDesRead.getIcon(self.data:getEID()))
	local maxSLV = equipmentltCtrl.getStrengthenMaxLv(self.data:getEquipmentLV(), self.data:getEquipmentType())
	local showSLV = self.data:getEquipmentSLV()
	local isWearing = self.data:isWearing()
	local isLock = self.data:isLock()
	local isShowSlv = true
	if self.data:getEquipmentPart() == gEquipmentPart.RING or self.data:getEquipmentPart() == gEquipmentPart.NECKLACE then
		self.fields.Text_lv:setString("")
		isShowSlv = false
		isWearing = self.data.isNowSetWearing
	else
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.data:getEID())
		local equipLv = self.data:getEquipmentLV()
		if isSuitEquip then
			equipLv = equipLv % 100
		end
		equipDesRead = self.data:getEID()
		self.data:getEID().lv = toEquip and toEquip.level or equipLv
		self.fields.Text_lv:setString(i18n("common_text_100", self.data:getEID()))
	end
	self.fields.Text_qlv:setVisible(isShowSlv and maxSLV > showSLV)
	self.fields.n13:setVisible(isShowSlv)
	self.fields.Text_qlv:setString("+" .. showSLV)
	self.fields.max:setVisible(maxSLV <= showSLV)
	local leftTime = (self.data:getEquipmentEndTimeProperty() or 0) - serviceFunctions.systemTime()
	if spTimeShow then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Lab_timer:setVisible(0 < leftTime)
		if 0 < leftTime then
			self.fields.Lab_timer:beginTime(leftTime)
		end
	else
		self.fields.Lab_timer:setVisible(false)
		self.controllers.c1:setSelectedIndex(0 < leftTime and 1 or 0)
		if 0 < leftTime then
			self.fields.Text_time:beginTime(leftTime)
		end
	end
	self.fields.wear:setVisible(isWearing)
	self.fields.spriteNew:setVisible(equipmentMgr.isNewList(self.data) and not isWearing)
	self.controllers.lock:setSelectedIndex(isLock and 1 or 0)
	local eType = self.data:getEquipmentType()
	self.fields.Effect_coolSquare:setVisible(gEquipTypeDef.EQUIP_LEGEND == eType or gEquipTypeDef.EQUIP_NEBULA == eType)
end
function Com_equipShow:hideOther()
	self.fields.n13:setVisible(false)
	self.fields.n14:setVisible(false)
	self.fields.Text_qlv:setVisible(false)
	self.fields.max:setVisible(false)
	self.fields.Text_lv:setVisible(false)
end
return Com_equipShow
