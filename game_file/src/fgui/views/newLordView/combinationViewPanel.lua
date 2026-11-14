local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local warGemltCtrl = include("warGemltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local combinationViewPanel = class("combinationViewPanel", baseFguiPanel)
function combinationViewPanel:ctor(...)
	combinationViewPanel.super.ctor(self, ...)
	print("combinationViewPanel:ctor", self.viewName)
end
function combinationViewPanel:onInit()
	print("=======combinationViewPanel:onInit")
	self.cellList, _ENV = print, print
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickSave))
	self.fields.Button_rename:addClickListener(handler(self, self.onClickRename))
	self.fields.Button_rename:fixPos()
end
function combinationViewPanel:onListRenderer(index, obj)
	obj:initData(self.cellList[index + 1], self.slotList[index + 1], index + 1, handler(self, self.refreshButton))
end
function combinationViewPanel:onShow()
	print("=======combinationViewPanel:onShow")
	self.index = self.param.index
	self:initData()
end
function combinationViewPanel:initData()
	self.slotList = combinationCtrl:getBaseCombinationSlotList()
	self:updateConbination()
	if self.combData then
		self.cellList, combinationCtrl = self.combData, self.combData
		for i, slotInfo in ipairs(self.slotList) do
			self.cellList[i] = self.combData[slotInfo.fieldKey] or 0
		end
		self.fields.List:setNumItems(#self.cellList)
	else
		self.fields.Button_ok:setEnabled(false)
		self.cellList, combinationCtrl = self.fields.Button_ok.setEnabled, self.fields.Button_ok.setEnabled
		for i, _ in ipairs(self.slotList) do
			self.cellList[i] = 0
		end
		self.fields.List:setNumItems(#self.cellList)
	end
	self:refreshButton()
end
function combinationViewPanel:refreshButton(index, setID)
	local needShow = false
	if index then
		self.cellList[index] = setID
	end
	for i, v in ipairs(self.cellList) do
		if tonumber(v) > 0 then
			needShow = true
			break
		end
	end
	self.fields.Button_ok:setEnabled(needShow)
end
function combinationViewPanel:updateConbination()
	self.combData = combinationCtrl:getCombinationData(self.index)
	local ctype = combinationCtrl.COMBINATION_TYPE.COMBINATION
	local name = combinationCtrl:getSetName(ctype, self.index)
	self.fields.Panel_bg:setString(name)
end
function combinationViewPanel:checkSetUnLock(data)
	if not self.slotList then
		_ENV = self.slotList
	end
	for _, slotInfo in ipairs(self.slotList) do
		local setID = data and tonumber(data[slotInfo.fieldKey]) or 0
		if 0 < setID then
			local unlock = combinationCtrl:checkSetUnLock(slotInfo.ctype, setID)
			if not unlock then
				SoraDShowMsgTip(i18n("privilege_text_128"))
				return false
			end
		end
	end
	return true
end
function combinationViewPanel:onClickRename()
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.index
	;(nil).renameType = 4
	uiManager:show("lordEquipRename", nil)
end
function combinationViewPanel:onClickSave()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	local SoraDPlaySound.setId, data = self.index, SoraDPlaySound
	if not self.slotList then
		_ENV = self.slotList
	end
	for i, slotInfo in ipairs(self.slotList) do
		data[slotInfo.fieldKey] = self.cellList[i]
	end
	if self:checkSetUnLock(data) then
		combinationCtrl:reqCombinationSet(data)
		self:close()
	end
end
return combinationViewPanel
