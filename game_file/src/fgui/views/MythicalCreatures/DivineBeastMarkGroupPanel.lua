local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkGroupPanel = class("DivineBeastMarkGroupPanel", baseFguiPanel)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
function DivineBeastMarkGroupPanel:ctor(...)
	DivineBeastMarkGroupPanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkGroupPanel:ctor", self.viewName)
end
function DivineBeastMarkGroupPanel:onInit()
	print("=======DivineBeastMarkGroupPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_text_91"))
	self.fields.List_groups:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_icon:addClickEventListener(handler(self, self.onChangeNameClick))
	for i = 1, 6 do
		_ENV = handler(self, self.onChangeNameClick)
		handler(self, self.onChangeNameClick).num = i
		self.fields["Com_MC_GroupSlot" .. i]:setTitle(i18n("Divine_beast_mark_text_93", handler(self, self.onChangeNameClick)))
	end
	self.curSetId = 1
end
function DivineBeastMarkGroupPanel:onShow()
	print("=======DivineBeastMarkGroupPanel:onShow")
	self.beastId = self.param.beastId
	self:updateView()
end
function DivineBeastMarkGroupPanel:updateView()
	self.marks = divineBeastMarkCtrl:getGroupMarkData(self.curSetId)
	for i = 1, 6 do
		self.fields["Com_MC_GroupSlot" .. i]:initData(self.marks[i], i, self.curSetId, self.marks, self.beastId)
	end
	self:updateGroupName()
end
function DivineBeastMarkGroupPanel:onItemRenderer(index, obj)
	local compiletype = index + 1
	local tName = divineBeastMarkCtrl:getGroupName(compiletype)
	obj:setString(tName)
	if compiletype == self.curSetId then
		obj:setSelected(true)
	end
	if obj.setId == nil then
		obj:addClickEventListener(handler(self, self.btnGroupClickCallBack))
	end
	obj.setId = compiletype
end
function DivineBeastMarkGroupPanel:onChangeNameClick(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.curSetId
	;(nil).renameType = 8
	uiManager:show("lordEquipRename", nil)
end
function DivineBeastMarkGroupPanel:updateGroupName()
	self.fields.text_name:setString(divineBeastMarkCtrl:getGroupName(self.curSetId))
	self.fields.List_groups:setNumItems(6)
end
function DivineBeastMarkGroupPanel:btnGroupClickCallBack(button, type)
	SoraDPlaySound()
	if self.curSetId == button.setId then
		return
	end
	self.curSetId = button.setId
	self:updateView()
end
return DivineBeastMarkGroupPanel
