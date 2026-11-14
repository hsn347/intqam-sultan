local baseFguiPanel = require("fgui.base.baseFguiPanel")
local divineBeastRead = include("divineBeastRead")
local DivineBeastMarkEquipPanel = class("DivineBeastMarkEquipPanel", baseFguiPanel)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
function DivineBeastMarkEquipPanel:ctor(...)
	DivineBeastMarkEquipPanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkEquipPanel:ctor", self.viewName)
end
function DivineBeastMarkEquipPanel:onInit()
	print("=======DivineBeastMarkEquipPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_text_12"))
	self.filterArmy, _ENV, self.filterQuality, _ENV = self.fields.Panel_bg.setTitle, self.fields.Panel_bg.setTitle, self.fields.Panel_bg.setTitle, self.fields.Panel_bg.setTitle
	self.fields.list_marks:setVirtual()
	self.fields.list_marks:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_quality:setTitle(i18n("commandhall_text_52"))
	self.fields.Btn_quality:addClickEventListener(handler(self, self.onQualityClick))
	self.fields.Btn_army:setTitle(i18n("mail_2_text_35"))
	self.fields.Btn_army:addClickEventListener(handler(self, self.onArmyClick))
	self.fields.Btn_more:setTitle(i18n("common_text_337"))
	self.fields.Btn_more:addClickEventListener(handler(self, self.onGetMoreClick))
	self.fields.Btn_equip:addClickEventListener(handler(self, self.onEquipClick))
	self.fields.Txt_tip:setString(i18n("Divine_beast_mark_text_21"))
	self.selectedSlot = self.param.slot
	self.beastId = self.param.beastId
	self.setId = self.param.setId
	self.equipMarks = self.param.equipMarks
	self.setSlotMark = self.param.setSlotMark
	self.fields.Com_MC_MarkDetail:setLockVisible(self.setId == nil)
	self.fields.Btn_quality:fixPos()
	self.fields.Btn_army:fixPos()
	self.fields.Btn_more:fixPos()
	self.fields.Btn_equip:fixPos()
end
function DivineBeastMarkEquipPanel:onShow()
	print("=======DivineBeastMarkEquipPanel:onShow")
	self:updateView()
end
function DivineBeastMarkEquipPanel:updateView()
	local bagMarkData = divineBeastMarkCtrl:getBagMarkList()
	self.markList, divineBeastMarkCtrl = divineBeastMarkCtrl, divineBeastMarkCtrl
	local curMark = self.curMark
	self.curMark = nil
	self.curSlotBagMarkId = nil
	for _, v in pairs(bagMarkData) do
		local cfg = v.markCfg
		if cfg and not self.filterArmy[cfg.army_id] and not self.filterQuality[cfg.quality] then
			divineBeastMarkCtrl = self.filterQuality[cfg.quality]
			local self.filterQuality[cfg.quality].data, markData = v, self.filterQuality[cfg.quality]
			if v.slot ~= nil and v.slot == self.selectedSlot and v.beastId == self.beastId then
				markData.order = 9999999
				self.curSlotBagMarkId = v.bagMarkId
			else
				markData.order = (v.slot ~= nil and 1000000 or 0) + v.lv * 100 + cfg.quality * 10 + v.lock
			end
			table.insert(self.markList, markData)
			if curMark and v.bagMarkId == curMark.bagMarkId then
				self.curMark = v
			end
		end
	end
	table.sort(self.markList, function(a, b)
		if a.order ~= b.order then
			return a.order > b.order
		end
		return a.data.markId > b.data.markId
	end)
	if self.curMark == nil then
		if self.curSlotBagMarkId == nil then
			for i, v in ipairs(self.markList) do
				if v.data.slot == nil then
					self.curMark = v.data
					break
				end
			end
		end
		self.curMark = self.curMark == nil and self.markList[1] and self.markList[1].data or self.curMark
		if self.curMark ~= nil and self.curMark.slot == self.selectedSlot then
			self.curMark = self.markList[2] and self.markList[2].data or self.curMark
		end
	end
	self.controllers.c1:setSelectedIndex(#self.markList > 0 and 1 or 0)
	self.lastSelectedObj = nil
	self.fields.list_marks:setNumItems(#self.markList)
	self:updateCurMark()
end
function DivineBeastMarkEquipPanel:updateMark(bagMarkId)
	local childrenCount = self.fields.list_marks:getChildrenCount()
	for i = 0, childrenCount - 1 do
		local obj = self.fields.list_marks:getChildAt(i)
		obj:updateMark(bagMarkId)
	end
	if self.curMark ~= nil and self.curMark.bagMarkId == bagMarkId then
		self.curMark = divineBeastMarkCtrl:getMarkByBagMarkId(bagMarkId)
		self:updateCurMark()
	end
end
function DivineBeastMarkEquipPanel:updateCurMark()
	self.fields.Com_MC_MarkDetail:setVisible(self.curMark ~= nil)
	if self.curMark ~= nil then
		local btnTitle = i18n("Divine_beast_mark_text_12")
		if self.curSlotBagMarkId == self.curMark.bagMarkId then
			btnTitle = i18n("Weapon_Rune_button_003")
		elseif self.curSlotBagMarkId ~= nil then
			btnTitle = i18n("common_text_1371")
		end
		self.fields.Btn_equip:setTitle(btnTitle)
		self.fields.Com_MC_MarkDetail:initData(self.curMark, true)
	end
end
function DivineBeastMarkEquipPanel:onQualityClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).filterData = self.filterQuality
	;(nil).filterType = 2
	;(nil).sureCallback = function(filterData)
		self.filterQuality = filterData
		self:updateView()
	end
	uiManager:show("DivineBeastMarkFilter", nil)
end
function DivineBeastMarkEquipPanel:onArmyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).filterData = self.filterArmy
	;(nil).filterType = 1
	;(nil).sureCallback = function(filterData)
		self.filterArmy = filterData
		self:updateView()
	end
	uiManager:show("DivineBeastMarkFilter", nil)
end
function DivineBeastMarkEquipPanel:onGetMoreClick()
	SoraDPlaySound()
	_UPVALUE1_, _ENV = nil, nil
	;(nil).sources, (nil)[1] = nil, 274
	uiManager:show("CommonSourceGuide", nil)
end
function DivineBeastMarkEquipPanel:onEquipClick()
	SoraDPlaySound()
	if self.setId ~= nil then
		self:onGroupEquipClick()
		return
	end
	if self.curMark == nil then
		return
	end
	if self.curSlotBagMarkId == self.curMark.bagMarkId then
		divineBeastMarkCtrl:sendDisMount(self.beastId, self.selectedSlot)
		self:close()
	elseif self:isHaveSameType() then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_1"))
		return
	elseif self.curMark.slot ~= nil then
		local beastName = divineBeastRead.getName(self.curMark.beastId)
		_ENV = i18n("Divine_beast_mark_text_1")
		i18n("Divine_beast_mark_text_1").name = beastName
		SoraDShowMsgBoxNew(i18n("Divine_beast_mark_text_20", i18n("Divine_beast_mark_text_1")), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				divineBeastMarkCtrl:sendMount(self.curMark.bagMarkId, self.beastId, self.selectedSlot)
				self:close()
			end
		end)
	else
		divineBeastMarkCtrl:sendMount(self.curMark.bagMarkId, self.beastId, self.selectedSlot)
		self:close()
	end
end
function DivineBeastMarkEquipPanel:onGroupEquipClick()
	for i = 1, 6 do
		local v = self.equipMarks[i]
		if v ~= nil and i ~= self.selectedSlot and v.markCfg.type == self.curMark.markCfg.type then
			SoraDShowMsgTip(i18n("Divine_beast_mark_text_1"))
			return
		end
	end
	divineBeastMarkCtrl:sendMountInSet(self.curMark.bagMarkId, self.setId, self.selectedSlot)
	self:close()
end
function DivineBeastMarkEquipPanel:onItemRenderer(index, obj)
	local mark = self.markList[index + 1].data
	obj:initData(mark)
	local isSelectedOne = self.curMark ~= nil and self.curMark.bagMarkId == mark.bagMarkId
	obj:setSelected(isSelectedOne)
	obj:setClickCallback(handler(self, self.onMarkClick))
	if isSelectedOne then
		self.lastSelectedObj = obj
	end
end
function DivineBeastMarkEquipPanel:onMarkClick(sender, mark)
	if mark == nil then
		return
	end
	dump(self.curMark, "self.curMark")
	self.curMark = mark
	if not tolua.isnull(self.lastSelectedObj) then
		self.lastSelectedObj:setSelected(false)
	end
	sender:setSelected(true)
	self.lastSelectedObj = sender
	self:updateCurMark()
end
function DivineBeastMarkEquipPanel:isHaveSameType()
	if self.curMark.beastId == self.beastId then
		return false
	end
	local beastMarkData = divineBeastMarkCtrl:getBeastMarkData(self.beastId)
	for k, v in pairs(beastMarkData) do
		if v.slot ~= self.selectedSlot and v.markCfg.type == self.curMark.markCfg.type then
			return true
		end
	end
	return false
end
function DivineBeastMarkEquipPanel:gameGuide_getTarget(itemName, parameters)
	_UPVALUE2_ = nil
	;(nil)[1] = self.fields[itemName]
	;(nil)[2] = itemName
	dump(nil, "gameGuide_getTarget")
	if itemName == "Btn_equip" then
		if #self.markList == 0 then
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
			SoraDSendMessage(nil)
			return
		end
		return self.fields.Btn_equip
	end
	return self.fields[itemName]
end
return DivineBeastMarkEquipPanel
