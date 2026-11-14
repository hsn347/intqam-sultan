local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonPopBox2Panel = class("CommonPopBox2Panel", baseFguiPanel)
function CommonPopBox2Panel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("CommonPopBox2Panel:ctor", self.viewName)
end
function CommonPopBox2Panel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonBoxSingle"
	end
	return self._packageList
end
function CommonPopBox2Panel:onInit()
	print("=======CommonPopBox2Panel:onInit")
	self.fields.Panel_bg:setTitle(i18n("hero_title_02"))
	self.fields.Text_tip:setString(i18n("common_text_1892"))
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickCloseView))
	self.confirmCallback = self.param.callback
	self.paramData = self.param.paramData
	if self.param.btnTitle then
		self.fields.Button_confirm:setTitle(self.param.btnTitle)
	else
		self.fields.Button_confirm:setTitle(i18n("common_text_204"))
	end
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function CommonPopBox2Panel:onClickCloseView()
	if self and self.view then
		if self.confirmCallback then
			self.confirmCallback(self.paramData)
		end
		self:close()
	end
end
function CommonPopBox2Panel:onItemRenderer(index, object)
	object:initData(self.data[index * 2 + 1], self.data[index * 2 + 2])
end
function CommonPopBox2Panel:onShow()
	print("=======CommonPopBox2Panel:onShow")
	self.param = self.proxy.param
	if self.param.data then
		self.data = self.param.data
		self.fields.List_reward:setNumItems(table.nums(self.param.data) / 2)
		if self.param.controller then
			self.controllers.c1:setSelectedIndex(self.param.controller)
		end
	end
end
function CommonPopBox2Panel:onHide()
	print("=======CommonPopBox2Panel:onHide")
end
function CommonPopBox2Panel:onDispose()
	print("=======CommonPopBox2Panel:onDispose")
end
return CommonPopBox2Panel
