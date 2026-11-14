local equipmentMgr = include("equipmentMgr")
local equipDesRead = include("equipDesRead")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_suitCell = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_suitCell", Btn_suitCell)
function Btn_suitCell:onInit()
	self.isSelect = false
	self.fields.select:setVisible(false)
	self.fields.own:setVisible(false)
	self.fields.shadow:setVisible(false)
	self.fields.forging:setVisible(false)
	self.fields.icon_free:setVisible(false)
	self.fields.timer:setVisible(false)
	self.fields.timer:setTimeUpdateListener(handler(self, self.timeUpdate))
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_suitCell:onShow()
end
function Btn_suitCell:initDataEX(data, index, showIndex, parentData)
	self.data = data
	self.index = index
	self.parentData = parentData
	self.isSelect = true
	self:setTouchEnabled(true)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.icon_base:setSpriteFrame(equipDesRead.color[self.data.quality])
	self.fields.icon:setSpriteFrame(self.parentData.icon)
	self.fields.select:setVisible(index == showIndex)
	self.fields.shadow:setVisible(index ~= showIndex)
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local isOwn = false
	for k, v in ipairs(tabelBaseList) do
		if v:getEID() == self.data.equipmentID and v:getEquipmentQuality() == self.data.quality then
			isOwn = true
			break
		end
	end
	self.fields.own:setVisible(isOwn)
	local queue = queueCtrl:queryQueue(gQueueTypeDef.forge_equipment)
	local isOwnHigher = self:isOwnHighEquip(self.data.equipmentID, self.data.quality)
	self.fields.icon_free:setVisible(equipmentCtrl:canSuitForge(self.data.equipmentID, self.data.quality) and not queue and not isOwnHigher)
	self.totalTime = nil
	if queue and queue.data.eid == self.data.equipmentID and queue.data.qly == self.data.quality then
		self.fields.forging:setVisible(true)
		self.fields.timer:setVisible(true)
		local leftTime = queue.timerNode.timer:getRemainTime()
		self.totalTime = queue.totaltime
		self.fields.timer:beginTime(leftTime)
		self.fields.forging:setFillAmount(leftTime / self.totalTime)
	else
		self.fields.forging:setVisible(false)
		self.fields.timer:endTime()
		self.fields.timer:setVisible(false)
	end
end
function Btn_suitCell:isOwnHighEquip(eid, quality)
	local isOwn = false
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	for k, v in ipairs(tabelBaseList) do
		if v:getEID() == eid and quality <= v:getEquipmentQuality() then
			isOwn = true
			break
		end
	end
	return isOwn
end
function Btn_suitCell:initDataSp(data, isMatch)
	self.data = data
	self.isSelect = false
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local quality = 0
	local isOwn = false
	for k, v in ipairs(tabelBaseList) do
		if v:getEID() == self.data.equipid then
			quality = math.max(v:getEquipmentQuality(), quality)
			isOwn = true
		end
	end
	if isMatch then
		self.fields.icon:setGrayed(false)
		self.fields.icon_base:setSpriteFrame(equipDesRead.getBg(quality))
	else
		self.fields.icon:setGrayed(true)
		self.fields.icon_base:setSpriteFrame(equipDesRead.getBg(0))
	end
	self.fields.icon:setSpriteFrame(self.data.icon)
	self.controllers.c1:setSelectedIndex(isOwn and 0 or 1)
	self:setTouchEnabled(false)
end
function Btn_suitCell:initData(data, onlyShow)
	self.data = data
	self.isSelect = false
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local quality = 0
	local isOwn = false
	for k, v in ipairs(tabelBaseList) do
		if v:getEID() == self.data.equipid then
			quality = math.max(v:getEquipmentQuality(), quality)
			isOwn = true
		end
	end
	self.fields.icon_base:setSpriteFrame(equipDesRead.getBg(quality))
	self.fields.icon:setSpriteFrame(self.data.icon)
	self.controllers.c1:setSelectedIndex(isOwn and 0 or 1)
	if onlyShow then
		self:setTouchEnabled(false)
		return
	end
	local queue = queueCtrl:queryQueue(gQueueTypeDef.forge_equipment)
	self.totalTime = nil
	if queue and queue.data.eid == self.data.equipid then
		self.fields.forging:setVisible(true)
		self.fields.timer:setVisible(true)
		local leftTime = queue.timerNode.timer:getRemainTime()
		self.totalTime = queue.totaltime
		self.fields.timer:beginTime(leftTime)
		self.fields.forging:setFillAmount(leftTime / self.totalTime)
	else
		self.fields.forging:setVisible(false)
		self.fields.timer:endTime()
		self.fields.timer:setVisible(false)
	end
	self.fields.icon_free:setVisible(equipmentCtrl:canSuitForge(self.data.equipid) and not queue and not isOwn)
end
function Btn_suitCell:timeUpdate(time)
	if self.totalTime then
		self.fields.forging:setFillAmount(time / self.totalTime)
	end
end
function Btn_suitCell:btnClick()
	SoraDPlaySound()
	if self.isSelect then
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_EQUIP_SUIT_CELL_SELECT"
		;(nil).index = self.index
		;(nil).equipID = self.parentData.equipid
		SoraDSendMessage(nil)
	else
		_ENV = nil
		;(nil).suitTag = self.data.suitequipID
		uiManager:show("suitInfoView", nil)
	end
end
return Btn_suitCell
