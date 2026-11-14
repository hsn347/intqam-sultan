local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkFilterPanel = class("DivineBeastMarkFilterPanel", baseFguiPanel)
local divineBeastMarkRead = include("divineBeastMarkRead")
function DivineBeastMarkFilterPanel:ctor(...)
	DivineBeastMarkFilterPanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkFilterPanel:ctor", self.viewName)
end
function DivineBeastMarkFilterPanel:onInit()
	print("=======DivineBeastMarkFilterPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("gem_btn_01"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_sure:addClickEventListener(handler(self, self.onSureClick))
	self.fields.Btn_sure:setTitle(i18n("common_text_204"))
	self.fields.Btn_all:addClickEventListener(handler(self, self.onAllClick))
	self.fields.Btn_all:setTitle(i18n("common_text_404"))
	self.fields.Btn_clear:addClickEventListener(handler(self, self.onClearClick))
	self.fields.Btn_clear:setTitle(i18n("gem_btn_02"))
	self.fields.Btn_sure:fixPos()
	self.fields.Btn_all:fixPos()
	self.fields.Btn_clear:fixPos()
end
function DivineBeastMarkFilterPanel:onShow()
	print("=======DivineBeastMarkFilterPanel:onShow")
	self.filterData = self.param.filterData
	self.sureCallback = self.param.sureCallback
	self.filterType = self.param.filterType
	self:updateView()
end
function DivineBeastMarkFilterPanel:updateView()
	self.showDatas = divineBeastMarkRead.getFilterCfg(self.filterType)
	self.fields.list:setNumItems(#self.showDatas)
	self:updateBtn()
end
function DivineBeastMarkFilterPanel:onItemRenderer(index, obj)
	local showData = self.showDatas[index + 1]
	if obj.showDataValue == nil then
		obj:addClickEventListener(handler(self, self.onDataClick))
	end
	obj:fixChildrenPos()
	obj:setTitle(showData.introduce == "" and showData.value or i18n(showData.introduce))
	obj.showDataValue = showData.value
	obj:setSelected(not self.filterData[showData.value])
end
function DivineBeastMarkFilterPanel:onDataClick(sender)
	SoraDPlaySound()
	dump(sender:isSelected(), "DivineBeastMarkFilterPanel:onDataClick")
	self.filterData[sender.showDataValue] = not sender:isSelected()
	dump(self.filterData, "self.filterData")
end
function DivineBeastMarkFilterPanel:onSureClick()
	SoraDPlaySound()
	if self.sureCallback then
		self.sureCallback(self.filterData)
	end
	self:close()
end
function DivineBeastMarkFilterPanel:onAllClick()
	SoraDPlaySound()
	self.filterData, _ENV = SoraDPlaySound, SoraDPlaySound
	self.fields.list:setNumItems(#self.showDatas)
	self:updateBtn()
end
function DivineBeastMarkFilterPanel:onClearClick()
	for i, v in ipairs(self.showDatas) do
		self.filterData[v.value] = true
	end
	self.fields.list:setNumItems(#self.showDatas)
	self:updateBtn()
end
function DivineBeastMarkFilterPanel:updateBtn()
	local selectedCount = 0
	for i, v in pairs(self.filterData) do
		if v then
			selectedCount = selectedCount + 1
		end
	end
	self.fields.Btn_all:setVisible(selectedCount == #self.showDatas)
	self.fields.Btn_clear:setVisible(selectedCount ~= #self.showDatas)
end
return DivineBeastMarkFilterPanel
