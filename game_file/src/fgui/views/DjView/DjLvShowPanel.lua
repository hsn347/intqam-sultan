local djRead = include("djRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjLvShowPanel = class("DjLvShowPanel", baseFguiPanel)
function DjLvShowPanel:ctor(...)
	self.isLRU = true
	DjLvShowPanel.super.ctor(self, ...)
	print("DjLvShowPanel:ctor", self.viewName)
end
function DjLvShowPanel:onInit()
	print("=======DjLvShowPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("Anchor_text_91"))
	self.fields.Text_lv:setString(i18n("Anchor_text_88"))
	self.fields.Text_val:setString(i18n("Anchor_text_89"))
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_val:fixPos()
	self.fields.Text_ex:fixPos()
end
function DjLvShowPanel:endShow()
	print("=======DjLvShowPanel:endShow")
	self.tag = self.param and self.param.tag or 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("Anchor_text_86")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Anchor_text_87")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_TabW:initView(nil)
end
function DjLvShowPanel:onTabClick(tag)
	self.tag = tag
	self.fields.Text_ex:setString(self.tag == 1 and i18n("Anchor_text_90") or i18n("Anchor_text_92"))
	self.ListData = self.tag == 1 and djRead.getMonthLvCfg() or djRead.getLifeLvCfg()
	self.fields.List:setNumItems(#self.ListData)
	self.fields.List:setScrollEnable(#self.ListData > 6)
end
function DjLvShowPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:initData(data, self.tag)
end
return DjLvShowPanel
