local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjListPanel = class("DjListPanel", baseFguiPanel)
function DjListPanel:ctor(...)
	self.isLRU = true
	DjListPanel.super.ctor(self, ...)
	print("DjListPanel:ctor", self.viewName)
end
function DjListPanel:onInit()
	print("=======DjListPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_none:setString(i18n("Anchor_text_183"))
	self.fields.Com_title:initData(i18n("Anchor_text_70"), handler(self, self.onClickClose))
	self.fields.Button_myInfo:setTitle(i18n("Anchor_text_73"))
	self.fields.Button_myInfo:addClickListener(handler(self, self.onClick_Button_myInfo))
end
function DjListPanel:endShow()
	print("=======DjListPanel:endShow")
	self:updateView()
end
function DjListPanel:updateView()
	SoraDCloseLoading(self)
	self.djList, _ENV = SoraDCloseLoading, SoraDCloseLoading
	local djList = djCtrl:getDJTimeList()
	for k, v in ipairs(djList) do
		if v.uid ~= SoraDGetPlayerID() then
			table.insert(self.djList, v)
		end
	end
	self.fields.List:setNumItems(#self.djList)
	self.fields.Text_none:setVisible(#self.djList == 0)
end
function DjListPanel:itemRenderer_List(index, obj)
	local data = self.djList[index + 1]
	obj:initData(data)
end
function DjListPanel:onClick_Button_myInfo(context)
	SoraDPlaySound()
	uiManager:show("DjInfo")
end
return DjListPanel
