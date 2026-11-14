local manorFarmRead = include("manorFarmRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PlantTypeViewPanel = class("PlantTypeViewPanel", baseFguiPanel)
local GUIDE_FARM_TYPE_FIRE = 1
local GUIDE_FARM_TYPE_STEP = 1270103
function PlantTypeViewPanel:ctor(...)
	self.isLRU = true
	PlantTypeViewPanel.super.ctor(self, ...)
	print("PlantTypeViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_
end
function PlantTypeViewPanel:onInit()
	print("=======PlantTypeViewPanel:onInit")
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
	self.fields.btnConfirm:setTitle(i18n("common_text_054"))
	self.fields.btnConfirm:addClickListener(handler(self, self.onClick_btnConfirm))
	self.fields.btnSwitch:setTitle(i18n("common_text_2264"))
	self.fields.btnSwitch:addClickListener(handler(self, self.onClick_btnSwitch))
	self.fields.btnSwitchPrice:addClickListener(handler(self, self.onClick_btnSwitchPrice))
	self.fields.Panel_bg1:setString(i18n("farmland_text_42"))
	self.labelCountDown = SoraDCreateTimerLabel(self, self.fields.txtCountDown)
	self.labelCountDown:setTimeEndListener(function(...)
		self:initData(self.param.isSwitch)
	end)
end
function PlantTypeViewPanel:endShow()
	print("=======PlantTypeViewPanel:endShow")
	self:initData(self.param.isSwitch)
end
function PlantTypeViewPanel:itemRenderer_listType(index, obj)
	local icon = manorFarmRead.getSeedTypeIcon(index + 1)
	obj:initData(index + 1, icon)
	if self.selectedType then
		if self.selectedType == index + 1 then
			obj.controllers.ctrlSelected:setSelectedIndex(2)
		else
			obj.controllers.ctrlSelected:setSelectedIndex(1)
		end
	else
		obj.controllers.ctrlSelected:setSelectedIndex(0)
	end
end
function PlantTypeViewPanel:onClickItem_listType(context)
	SoraDPlaySound()
	local seedType = context.data.type
	if tonumber(SoraDIsGameGuide()) == GUIDE_FARM_TYPE_STEP and seedType ~= GUIDE_FARM_TYPE_FIRE then
		return
	end
	self.selectedType = seedType
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum() - 1)
	self:updateBtnGrayed()
	if tonumber(SoraDIsGameGuide()) == GUIDE_FARM_TYPE_STEP and not self.isSwitch then
		self.param.callback(self.selectedType, self.param.comMap)
		self:close()
	end
end
function PlantTypeViewPanel:onClick_btnConfirm(context)
	SoraDPlaySound()
	if not self.selectedType then
		return
	end
	self.param.callback(self.selectedType, self.param.comMap)
	self:close()
end
function PlantTypeViewPanel:onClick_btnSwitch(context)
	SoraDPlaySound()
	if not self.selectedType then
		return
	end
	manorCityCtrl:reqFarmlandChangeType(self.param.data.iid, self.selectedType)
	self:close()
end
function PlantTypeViewPanel:onClick_btnSwitchPrice(context)
	SoraDPlaySound()
	if not self.selectedType then
		return
	end
	manorCityCtrl:reqFarmlandChangeType(self.param.data.iid, self.selectedType)
	self:close()
end
function PlantTypeViewPanel:initData(isSwitch)
	self.isSwitch = isSwitch
	if not self.param.data then
		_ENV = self.param.data
	end
	if not self.param.data.extra then
		_ENV = self.param.data.extra
	end
	self.selectedType = self.param.data.extra.type or nil
	if isSwitch then
		self.controllers.ctrlState:setSelectedIndex(1)
		self:updateSwitch()
	else
		self.fields.txtDesc:setString(i18n("farmland_text_43"))
		self.controllers.ctrlState:setSelectedIndex(0)
	end
	self:updateBtnGrayed()
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum() - 1)
end
function PlantTypeViewPanel:updateSwitch()
	local freeCount, lastFreeTime = manorCityCtrl:getFreeChangeFarmlandTypeInfo()
	if 0 < freeCount then
		manorCityCtrl = nil
		;(nil).num = freeCount
		self.fields.txtDesc:setString(i18n("farmland_text_44", nil))
		self.fields.txtDesc:setVisible(true)
		self.controllers.ctrlPrice:setSelectedIndex(0)
	else
		local costItem = CONST_ARRAY.FARMLAND_CHANGE_COST
		local itemId = costItem[1]
		local itemCount = costItem[2]
		self.fields.txtDesc:setVisible(false)
		self.controllers.ctrlPrice:setSelectedIndex(1)
		self.fields.btnSwitchPrice:initData(itemId, itemCount)
		local leftTime = (self.param.data.extra.lastChangeTypeTime or 0) + CONST_VALUE.FARMLAND_CHANGE_TIME - serviceFunctions.systemTime()
		if 0 < leftTime then
			self.labelCountDown:setVisible(true)
			self.labelCountDown:setTimeUpdateListener(function(time)
				local freeCount, lastFreeTime = manorCityCtrl:getFreeChangeFarmlandTypeInfo()
				if 0 < freeCount then
					manorCityCtrl = nil
					;(nil).num = freeCount
					self.fields.txtDesc:setString(i18n("farmland_text_44", nil))
					self.fields.txtDesc:setVisible(true)
					self.controllers.ctrlPrice:setSelectedIndex(0)
				end
				local leftTime = (self.param.data.extra.lastChangeTypeTime or 0) + CONST_VALUE.FARMLAND_CHANGE_TIME - serviceFunctions.systemTime()
				if leftTime <= 0 then
					self.labelCountDown:setVisible(false)
					self:updateBtnGrayed()
				else
					manorCityCtrl = i18n("farmland_text_44", nil)
					i18n("farmland_text_44", nil).time = SoraDConvertSecondToString(self.param.data.extra.lastChangeTypeTime + CONST_VALUE.FARMLAND_CHANGE_TIME - serviceFunctions.systemTime())
					self.fields.txtCountDown:setString(i18n("farmland_text_80", i18n("farmland_text_44", nil)))
				end
			end)
			self.labelCountDown:beginTime(serviceFunctions.getNextMonthFirstDayTime())
		else
			self.labelCountDown:setVisible(false)
		end
	end
end
function PlantTypeViewPanel:updateBtnGrayed()
	if self.isSwitch then
		local count = backpackCtrl:getItemCount(CONST_ARRAY.FARMLAND_CHANGE_COST[1])
		if CONST_ARRAY.FARMLAND_CHANGE_COST[1] == gIDDef.GOLD then
			local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
			count = lordInfoCtrl:getBaseInfo().gold
		end
		local freeCount = manorCityCtrl:getFreeChangeFarmlandTypeInfo()
		if not self.param.data then
			backpackCtrl = self.param.data
		end
		if not self.param.data.extra then
			backpackCtrl = self.param.data.extra
		end
		if self.selectedType == self.param.data.extra.type then
			self.fields.btnSwitch:setEnabled(false)
			self.fields.btnSwitchPrice:setEnabled(false)
		elseif freeCount <= 0 then
			if not self.param.data then
				backpackCtrl = self.param.data
			end
			if not self.param.data.extra then
				backpackCtrl = self.param.data.extra
			end
			local lastPayTime = self.param.data.extra.lastChangeTypeTime
			self.fields.btnSwitch:setEnabled(not lastPayTime or CONST_VALUE.FARMLAND_CHANGE_TIME + lastPayTime < serviceFunctions.systemTime())
			self.fields.btnSwitchPrice:setEnabled(not lastPayTime or CONST_VALUE.FARMLAND_CHANGE_TIME + lastPayTime < serviceFunctions.systemTime())
			self.fields.btnSwitchPrice:setStatus(count, CONST_ARRAY.FARMLAND_CHANGE_COST[2])
		else
			self.fields.btnSwitch:setEnabled(true)
			self.fields.btnSwitchPrice:setEnabled(true)
			self.fields.btnSwitchPrice:setStatus(count, CONST_ARRAY.FARMLAND_CHANGE_COST[2])
		end
	elseif self.selectedType then
		self.fields.btnConfirm:setEnabled(true)
	else
		self.fields.btnConfirm:setEnabled(false)
	end
end
function PlantTypeViewPanel:gameGuide_getTarget(itemName, parameters)
