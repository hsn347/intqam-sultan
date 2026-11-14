local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkElementPanel = class("DivineBeastMarkElementPanel", baseFguiPanel)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastMarkRead = include("divineBeastMarkRead")
function DivineBeastMarkElementPanel:ctor(...)
	DivineBeastMarkElementPanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkElementPanel:ctor", self.viewName)
end
function DivineBeastMarkElementPanel:onInit()
	print("=======DivineBeastMarkElementPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_text_14"))
	self.fields.Text_title:setString(i18n("Divine_beast_mark_text_56"))
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_help:addClickEventListener(handler(self, self.onHelpClick))
	self.beastId = self.param.beastId
	self.lvsCount = divineBeastMarkCtrl:getElementLvCount(self.beastId)
	for i = 1, 4 do
		self.fields["Check_MC_Element" .. i]:addClickEventListener(handler(self, self.onElementSelected), i)
		local elementCfg = divineBeastMarkRead.getElementCfg(i)
		self.fields["Check_MC_Element" .. i]:setIcon(elementCfg.icon)
		local elementEffectCfg = divineBeastMarkRead.getElementsEffect(self.beastId, i, self.lvsCount[i] or 0)
		local elv = elementEffectCfg and elementEffectCfg.lv or 0
		_ENV = handler(self, self.onHelpClick)
		handler(self, self.onHelpClick).lv = elv
		self.fields["Text_lv" .. i]:setString(i18n("common_text_100", handler(self, self.onHelpClick)))
	end
	self.selectedElement = self.param.type and self.param.type or 1
	self:onElementSelected(self.fields.Check_MC_Element1, self.selectedElement)
	self.view:fixChildrenPos()
end
function DivineBeastMarkElementPanel:onShow()
	print("=======DivineBeastMarkElementPanel:onShow")
end
function DivineBeastMarkElementPanel:onElementSelected(sender, param)
	SoraDPlaySound()
	for i = 1, 4 do
		self.fields["Check_MC_Element" .. i]:setSelected(param == i)
	end
	self.selectedElement = param
	self:updateView()
end
function DivineBeastMarkElementPanel:updateView()
	self.dataList, divineBeastMarkRead = nil, nil
	local elementEffectCfgs = divineBeastMarkRead.getElementsEffect(self.beastId, self.selectedElement)
	divineBeastMarkCtrl = self.selectedElement
	self.selectedElement[1] = self.selectedElement
	self.selectedElement[2] = elementEffectCfgs
	dump(self.selectedElement, "self.selectedElement")
	local curLv = self.lvsCount[self.selectedElement] or 0
	for i, v in ipairs(elementEffectCfgs) do
		if curLv >= v.need_elements then
			self.dataList[1] = v
		else
			table.insert(self.dataList, v)
		end
	end
	dump(self.dataList, "self.dataList")
	self.fields.list:setNumItems(#self.dataList)
	self.fields.list:scrollToView(0)
	self.lvsCount = divineBeastMarkCtrl:getElementLvCount(self.beastId)
	for i = 1, 4 do
		local elementCfg = divineBeastMarkRead.getElementCfg(i)
		self.fields["Element" .. i]:setIcon(elementCfg.icon)
		self.fields["Text_num" .. i]:setString(self.lvsCount[i])
	end
end
function DivineBeastMarkElementPanel:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	local curLv = self.lvsCount[self.selectedElement] or 0
	obj:initData(data, curLv >= data.need_elements, index)
end
function DivineBeastMarkElementPanel:onHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = 1
	;(nil).beastId = self.beastId
	uiManager:show("DivineBeastRule", nil)
end
return DivineBeastMarkElementPanel
