local djCtrl = SoraDGetCtrl("djCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjHistoryGiftPanel = class("DjHistoryGiftPanel", baseFguiPanel)
function DjHistoryGiftPanel:ctor(...)
	self.isLRU = true
	DjHistoryGiftPanel.super.ctor(self, ...)
	print("DjHistoryGiftPanel:ctor", self.viewName)
end
function DjHistoryGiftPanel:onInit()
	print("=======DjHistoryGiftPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("Anchor_text_144"))
end
function DjHistoryGiftPanel:endShow()
	print("=======DjHistoryGiftPanel:endShow")
	djCtrl:reqGetContributeRecord()
	SoraDShowLoading(self)
end
function DjHistoryGiftPanel:initView(target, data)
	SoraDCloseLoading(self)
	if not data.list then
		_ENV = data.list
	end
	self.ListData = table.reverse(data.list)
	self.fields.List:setNumItems(#self.ListData)
end
function DjHistoryGiftPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	_ENV = nil
	;(nil).name = _p(data.n) .. _p("#" .. data.k)
	_ENV = nil
	;(nil).name = publicRead.getName(data.id)
	;(nil).count = data.c
	;(nil).item = fguiHelper.getColorString("#70C723", i18n("pickup_star_028", nil))
	local str = i18n("Anchor_text_97", nil)
	obj:setTitle(str)
end
return DjHistoryGiftPanel
