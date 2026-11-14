local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjSearchPanel = class("DjSearchPanel", baseFguiPanel)
function DjSearchPanel:ctor(...)
	self.isLRU = true
	DjSearchPanel.super.ctor(self, ...)
	print("DjSearchPanel:ctor", self.viewName)
end
function DjSearchPanel:onInit()
	print("=======DjSearchPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("Anchor_text_145"))
	self.fields.Button_search:setTitle(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClick_Button_search))
	self.fields.Text_none:setString(i18n("Anchor_text_200"))
	self.input = self.fields.input:getChild("input")
	self.view:fixChildrenPos()
end
function DjSearchPanel:endShow()
	print("=======DjSearchPanel:endShow")
	self.input:setText("")
	djCtrl:reqGetAudienceList()
	SoraDShowLoading(self)
end
function DjSearchPanel:initView(target, data)
	SoraDCloseLoading(self)
	if not data.list then
		_ENV = data.list
	end
	self.searchList = data.list
	self.showList = clone(self.searchList)
	self:updateView()
end
function DjSearchPanel:updateView()
	self.fields.List:setNumItems(#self.showList)
	self.fields.Text_none:setVisible(#self.showList == 0)
end
function DjSearchPanel:itemRenderer_List(index, obj)
	obj:initData(self.showList[index + 1])
end
function DjSearchPanel:onClick_Button_search(context)
	SoraDPlaySound()
	local name = self.input:getText()
	if string.utf8len(name) < 3 then
		SoraDShowMsgTip(i18n("Anchor_text_200"))
		return
	end
	local _ENV, searchList = SoraDShowMsgTip, SoraDShowMsgTip
	for k, v in ipairs(self.searchList) do
		if string.find(v.nikeName, name) then
			table.insert(searchList, v)
		end
	end
	if 0 < #searchList then
		self.showList = searchList
		self:updateView()
	else
		SoraDShowMsgTip(i18n("Anchor_text_186"))
	end
end
return DjSearchPanel
