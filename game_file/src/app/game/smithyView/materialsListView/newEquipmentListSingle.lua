local equipDesRead = include("equipDesRead")
local itemDesRead = include("itemDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local newEquipmentListSingle = class("newEquipmentListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newEquipmentListSingle")
	end
	return target
end)
function newEquipmentListSingle:ctor()
	self.data = nil
	self.nextSLV = nil
	self.Button_equip = SoraDGetChildByName(self, "Button_equip")
	self.Button_equip:setSwallowTouches(false)
	self.Button_equip:setPressedActionEnabled(false)
	self.Sprite_bg = SoraDGetChildByName(self, "Sprite_bg")
	self.Sprite_icon = SoraDGetChildByName(self, "Sprite_icon")
	self.icon_g = SoraDGetChildByName(self, "icon_g")
	self.icon_g:setVisible(false)
	self.Text_topNum = SoraDGetChildByName(self, "Text_topNum")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Node_limitTime = SoraDGetChildByName(self, "Node_limitTime")
	self.Node_limitTime:setVisible(false)
	self.Node_time = SoraDGetChildByName(self.Node_limitTime, "Node_time")
	self.txtLimitTime = SoraDGetChildByName(self, "Text_timer")
	self.txtLimitTime = SoraDCreateTimerLabel(self, self.txtLimitTime)
	self.Button_equip:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function newEquipmentListSingle:initData(data, isMaterial, nextSLV)
	self.data = data
	self.nextSLV = nextSLV
	if isMaterial then
		self:initMaterialView()
	else
		self:initView()
	end
end
function newEquipmentListSingle:initMaterialView()
	self.Sprite_bg:loadTexture(itemDesRead.getBg(self.data.mid), ccui.TextureResType.plistType)
	self.Sprite_icon:setSpriteFrame(itemDesRead.getIcon(self.data.mid))
	self.Text_topNum:setVisible(false)
	self.Text_num:setString(self.data.count)
end
function newEquipmentListSingle:setTimeEndHandle(handle)
	self.timeEndHandle = handle
end
function newEquipmentListSingle:initView()
	self.Sprite_bg:loadTexture(equipDesRead.getBg(self.data:getEquipmentQuality()), ccui.TextureResType.plistType)
	self.Sprite_icon:setSpriteFrame(equipDesRead.getIcon(self.data:getEID()))
	local value = self.nextSLV or self.data:getEquipmentSLV()
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.data:getEID())
	local equipLv = self.data:getEquipmentLV()
	if isSuitEquip then
		equipLv = equipLv % 100
	end
	local maxSLV = equipmentltCtrl.getStrengthenMaxLv(equipLv, self.data:getEquipmentType())
	local valStr = "MAX"
	if value < maxSLV then
		valStr = "+" .. value
	end
	self.Text_topNum:setString(valStr)
	local equipType = self.data:getEquipmentType()
	if equipType == gEquipTypeDef.EQUIP_LEGEND then
		self.Text_num:setVisible(false)
	else
		self.Text_num:setVisible(true)
		equipDesRead = self.data:getEquipmentType()
		self.data:getEquipmentType().lv = equipLv
		self.Text_num:setString(i18n("common_text_101", self.data:getEquipmentType()))
	end
	local endTime = self.data:getEquipmentEndTimeProperty()
	if endTime and 0 < endTime then
		self.txtLimitTime:beginTime(endTime - serviceFunctions.systemTime())
		if self.timeEndHandle then
			self.txtLimitTime:setTimeEndListener(self.timeEndHandle)
		end
		SoraDToCenter(self.Node_time, 0)
		self.Node_limitTime:setVisible(true)
	end
	self.icon_g:setVisible(self.data:isWearing())
end
function newEquipmentListSingle:hideLv()
	self.Text_num:setVisible(false)
	self.Text_topNum:setVisible(false)
end
function newEquipmentListSingle:setHandle(handle)
	self.handle = handle
end
function newEquipmentListSingle:setScroll(scroll)
	self.scroll = scroll
end
function newEquipmentListSingle:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self.data, self)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if self.scroll and tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self:stopAllActions()
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return newEquipmentListSingle
