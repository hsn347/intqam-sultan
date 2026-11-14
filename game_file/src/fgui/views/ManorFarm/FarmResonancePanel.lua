local manorFarmRead = include("manorFarmRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmResonancePanel = class("FarmResonancePanel", baseFguiPanel)
function FarmResonancePanel:ctor(...)
	self.isLRU = true
	FarmResonancePanel.super.ctor(self, ...)
	print("FarmResonancePanel:ctor", self.viewName)
end
function FarmResonancePanel:onInit()
	print("=======FarmResonancePanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.Panel_bg:setTitle(i18n("farmland_text_47"))
	self.fields.txtNum:setString(i18n("farmland_text_49"))
	self.fields.txtDesc:setString(i18n("farmland_text_48"))
	self.fields.listType:setTouchable(false)
	self.fields.listResonance:setItemRenderer(handler(self, self.itemRenderer_listResonance))
	self.fields.progress:setMax(100)
end
function FarmResonancePanel:endShow()
	print("=======FarmResonancePanel:endShow")
	self:initData()
end
function FarmResonancePanel:itemRenderer_listType(index, obj)
	local icon = manorFarmRead.getSeedTypeIcon(index + 1)
	local num = manorCityUtil.getFarmNumInType(index + 1)
	obj:initData(index + 1, icon, num)
end
function FarmResonancePanel:itemRenderer_listResonance(index, obj)
	local data = self.resonanceData[index + 1]
	obj:initData(data)
end
function FarmResonancePanel:initData(...)
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum() - 1)
	self.resonanceData = manorFarmRead.getResonanceList()
	self.fields.listResonance:setNumItems(#self.resonanceData)
	self.fields.listResonance:ResizeToFit(#self.resonanceData)
	self:updateProgressHeight()
	local progressValue = self:getProgressValue()
	self:refreshProgressValue(progressValue)
end
function FarmResonancePanel:updateProgressHeight()
	local bar_v = self.fields.progress:getChild("bar_v")
	self.barHeight = math.max(#self.resonanceData, 1) * 105
	bar_v:setHeight(self.barHeight)
end
function FarmResonancePanel:refreshProgressValue(progressValue)
	local resetValue = 0 < progressValue and 0 or self.fields.progress:getMax()
	self.fields.progress:setValue(resetValue)
	self.fields.progress:setValue(progressValue)
end
function FarmResonancePanel:getProgressValue()
	local value = manorCityUtil:getMaxFarmNum()
	local offsetY = 0
	for i, v in ipairs(self.resonanceData) do
		if value >= v.farmlandNum then
			if i == 1 then
				offsetY = offsetY + 47
			else
				offsetY = offsetY + 105
			end
		else
			local base = 126
			local lastNum = 0
			if i == 1 then
				base = 44
			else
				lastNum = self.resonanceData[i - 1].farmlandNum
			end
			offsetY = offsetY + base * (value - lastNum) / (v.farmlandNum - lastNum)
			break
		end
	end
	print("self:getProgressValue()", offsetY)
	if 0 >= self.barHeight then
		return 0
	end
	return offsetY / self.barHeight * 100
end
return FarmResonancePanel
