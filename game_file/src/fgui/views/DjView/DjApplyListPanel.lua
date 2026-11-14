local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjApplyListPanel = class("DjApplyListPanel", baseFguiPanel)
function DjApplyListPanel:ctor(...)
	self.isLRU = true
	DjApplyListPanel.super.ctor(self, ...)
	print("DjApplyListPanel:ctor", self.viewName)
end
function DjApplyListPanel:onInit()
	print("=======DjApplyListPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("Anchor_text_146"))
	self.fields.Button_clean:setTitle(i18n("Anchor_text_155"))
	self.fields.Button_clean:addClickListener(handler(self, self.onClick_Button_clean))
end
function DjApplyListPanel:endShow()
	print("=======DjApplyListPanel:endShow")
	djCtrl:reqGetApplyList()
	SoraDShowLoading(self)
end
function DjApplyListPanel:initView(target, data)
	SoraDCloseLoading(self)
	if not data.list then
		_ENV = data.list
	end
	self.ListData = data.list
	self.fields.List:setNumItems(#self.ListData)
end
function DjApplyListPanel:updateView(target, data)
	if data.agreeApply then
		self:close()
	end
end
function DjApplyListPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:initData(data)
end
function DjApplyListPanel:onClick_Button_clean(context)
	SoraDPlaySound()
	djCtrl:reqClearApplyList()
	SoraDShowLoading(self)
end
return DjApplyListPanel
