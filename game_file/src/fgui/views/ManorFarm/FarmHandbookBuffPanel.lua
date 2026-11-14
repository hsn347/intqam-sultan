local manorFarmRead = include("manorFarmRead")
local manorCityUtil = include("manorCityUtil")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmHandbookBuffPanel = class("FarmHandbookBuffPanel", baseFguiPanel)
local FIRST_PROGRESS_HEIGHT = 47
local PROGRESS_ITEM_HEIGHT = 105
function FarmHandbookBuffPanel:ctor(...)
	self.isLRU = true
	FarmHandbookBuffPanel.super.ctor(self, ...)
	print("FarmHandbookBuffPanel:ctor", self.viewName)
end
function FarmHandbookBuffPanel:onInit()
	print("=======FarmHandbookBuffPanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.Com_title:initData(i18n("farmland_text_30"), handler(self, self.onClickClose))
	self:updateDesc()
	self.fields.listResonance:setItemRenderer(handler(self, self.itemRenderer_listResonance))
	self.fields.progress:setMax(100)
end
function FarmHandbookBuffPanel:itemRenderer_listResonance(index, obj)
	local data = self.resonanceBuffs[index + 1]
	obj:initHandbookBuff(data)
end
function FarmHandbookBuffPanel:endShow()
	print("=======FarmHandbookBuffPanel:endShow")
	self:initData()
end
function FarmHandbookBuffPanel:initData()
	self:updateDesc()
	self.resonanceBuffs = manorFarmRead.getAllHandBookBuff()
	self.fields.listResonance:setNumItems(#self.resonanceBuffs)
	self.fields.listResonance:ResizeToFit(#self.resonanceBuffs)
	self:updateProgressHeight()
	local progressValue = self:getProgressValue()
	self:refreshProgressValue(progressValue)
	self.fields.Mod_Resonance:getScrollPane():setPercY(progressValue / 100, true)
end
function FarmHandbookBuffPanel:updateDesc()
	local bookNum = manorCityCtrl:getUnlockFruitBookNum()
	self.fields.txtDesc:setString(i18n("farmland_text_31") .. ": " .. bookNum)
end
function FarmHandbookBuffPanel:updateProgressHeight()
	local bar_v = self.fields.progress:getChild("bar_v")
	self.barHeight = math.max(FIRST_PROGRESS_HEIGHT + (#self.resonanceBuffs - 1) * PROGRESS_ITEM_HEIGHT, 0)
	bar_v:setHeight(self.barHeight)
	bar_v:getChild("icon"):setWidth(self.barHeight + 19)
end
function FarmHandbookBuffPanel:refreshProgressValue(progressValue)
	local resetValue = 0 < progressValue and 0 or self.fields.progress:getMax()
	self.fields.progress:setValue(resetValue)
	self.fields.progress:setValue(progressValue)
end
function FarmHandbookBuffPanel:getProgressValue()
	local value = manorCityCtrl:getUnlockFruitBookNum()
	local offsetY = 0
	for i, v in ipairs(self.resonanceBuffs) do
		if value >= v.fruitNum then
			if i == 1 then
				offsetY = offsetY + FIRST_PROGRESS_HEIGHT
			else
				offsetY = offsetY + PROGRESS_ITEM_HEIGHT
			end
		else
			local base = PROGRESS_ITEM_HEIGHT
			local lastNum = 0
			if i == 1 then
				base = FIRST_PROGRESS_HEIGHT
			else
				lastNum = self.resonanceBuffs[i - 1].fruitNum
			end
			offsetY = offsetY + base * (value - lastNum) / (v.fruitNum - lastNum)
			break
		end
	end
	print("self:getProgressValue()", offsetY)
	if 0 >= self.barHeight then
		return 0
	end
	return offsetY / self.barHeight * 100
end
return FarmHandbookBuffPanel
