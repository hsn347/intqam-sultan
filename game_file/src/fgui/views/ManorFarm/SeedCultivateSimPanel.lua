local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SeedCultivateSimPanel = class("SeedCultivateSimPanel", baseFguiPanel)
function SeedCultivateSimPanel:ctor(...)
	self.isLRU = true
	SeedCultivateSimPanel.super.ctor(self, ...)
	print("SeedCultivateSimPanel:ctor", self.viewName)
end
function SeedCultivateSimPanel:onInit()
	print("=======SeedCultivateSimPanel:onInit")
	self.fields.Panel_bg:setString(i18n("farmland_text_26"))
	self.fields.seedResult:addClickListener(handler(self, self.onClick_seedResult))
	self.fields.seedSource1:addClickListener(handler(self, self.onClick_seedSource1))
	self.fields.seedSource2:addClickListener(handler(self, self.onClick_seedSource2))
	self.fields.seedResult.fields.btnReduce:addClickListener(handler(self, self.onClick_seedResult_reduce))
	self.fields.seedSource1.fields.btnReduce:addClickListener(handler(self, self.onClick_seedSource1_reduce))
	self.fields.seedSource2.fields.btnReduce:addClickListener(handler(self, self.onClick_seedSource2_reduce))
	self.fields.txtSeed:setString(i18n("farmland_text_28"))
	self.fields.txtFormula:setString(i18n("farmland_text_27"))
end
function SeedCultivateSimPanel:endShow()
	print("=======SeedCultivateSimPanel:endShow")
	self:initData()
end
function SeedCultivateSimPanel:onClick_seedResult(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).isSource = false
	;(nil).id = context.sender.id
	;(nil).type = 3
	;(nil).callback = handler(self, self.updateResult)
	uiManager:show("SeedCultivateSimChoose", nil)
end
function SeedCultivateSimPanel:onClick_seedSource1(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).isSource = true
	;(nil).id = context.sender.id
	;(nil).type = 1
	;(nil).callback = handler(self, self.updateSource)
	uiManager:show("SeedCultivateSimChoose", nil)
end
function SeedCultivateSimPanel:onClick_seedSource2(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).isSource = true
	;(nil).id = context.sender.id
	;(nil).type = 2
	;(nil).callback = handler(self, self.updateSource)
	uiManager:show("SeedCultivateSimChoose", nil)
end
function SeedCultivateSimPanel:onClick_seedResult_reduce(context)
	self.fields.seedResult:initData()
	self:updateFormula()
	self.fields.txtSeed:setVisible(false)
	context:stopPropagation()
end
function SeedCultivateSimPanel:onClick_seedSource1_reduce(context)
	self.fields.seedSource1:initData()
	self:updateFormula()
	self.fields.txtFormula:setVisible(false)
	context:stopPropagation()
end
function SeedCultivateSimPanel:onClick_seedSource2_reduce(context)
	self.fields.seedSource2:initData()
	self:updateFormula()
	self.fields.txtFormula:setVisible(false)
	context:stopPropagation()
end
function SeedCultivateSimPanel:updateSource(sourceId, sourceIndex)
	self.fields["seedSource" .. sourceIndex]:initData(sourceId)
	self:updateFormula()
end
function SeedCultivateSimPanel:updateResult(resultSeedId, resultIndex)
	self.fields.seedResult:initData(resultSeedId)
	self:updateFormula()
end
function SeedCultivateSimPanel:initData()
	self.fields.seedSource1:GetController("ctrlAdd"):setSelectedIndex(0)
	self.fields.seedSource2:GetController("ctrlAdd"):setSelectedIndex(0)
	self.fields.formulaResult:GetController("ctrlAdd"):setSelectedIndex(2)
	self.fields.seedReverse1:GetController("ctrlAdd"):setSelectedIndex(2)
	self.fields.seedReverse2:GetController("ctrlAdd"):setSelectedIndex(2)
	self.fields.seedResult:GetController("ctrlAdd"):setSelectedIndex(0)
	self.fields.txtSeed:setVisible(false)
	self.fields.txtFormula:setVisible(false)
end
function SeedCultivateSimPanel:updateFormula()
	local source1 = self.fields.seedSource1.id
	local source2 = self.fields.seedSource2.id
	local result = self.fields.seedResult.id
	if source1 and source2 then
		local result = manorCityCtrl:getFarmSeedFormula(source1, source2)
		if result then
			self.fields.formulaResult:initData(result)
			self.fields.formulaResult:setReduce(1)
			self.fields.txtFormula:setVisible(false)
		else
			self.fields.formulaResult:initData()
			self.fields.formulaResult:setStatus(2)
			self.fields.txtFormula:setVisible(true)
		end
	end
	if result then
		local sources, isMultiple = manorCityCtrl:getFarmSeedFormula(result)
		if sources and #sources == 2 then
			self.fields.seedReverse1:initData(sources[1])
			self.fields.seedReverse1:setReduce(1)
			self.fields.seedReverse2:initData(sources[2])
			self.fields.seedReverse2:setReduce(1)
			if isMultiple then
				self.fields.txtSeed:setVisible(true)
				self.fields.txtSeed:setString(i18n("farmland_text_29"))
			else
				self.fields.txtSeed:setString(i18n("farmland_text_28"))
				self.fields.txtSeed:setVisible(false)
			end
		else
			self.fields.seedReverse1:initData()
			self.fields.seedReverse2:initData()
			self.fields.seedReverse1:setStatus(2)
			self.fields.seedReverse2:setStatus(2)
			self.fields.txtSeed:setVisible(true)
		end
	end
end
return SeedCultivateSimPanel
