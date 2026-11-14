local baseFguiPanel = require("fgui.base.baseFguiPanel")
local setSelectPopViewPanel = class("setSelectPopViewPanel", baseFguiPanel)
function setSelectPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("setSelectPopViewPanel:ctor", self.viewName)
end
function setSelectPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function setSelectPopViewPanel:onInit()
	print("=======setSelectPopViewPanel:onInit")
	_ENV = print
	print.WARGEM = 1
	print.LORDSKILL = 2
	print.EQUIPMENT = 3
	print.TEAMEDIT = 4
	self.COMBINATION_TYPE, print.COMBINATION = print, 5
	self.itemList, _ENV, self.curIndex = print, print, 1
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function setSelectPopViewPanel:onShow()
	print("=======setSelectPopViewPanel:onShow")
	self.ctype = self.param.ctype
	self.rtype = self.param.rtype
	self.handle = self.param.handle
	self.maxNum = self.ctype == self.COMBINATION_TYPE.EQUIPMENT and 8 or 6
	_ENV, self.curIndex = tonumber(self.param.setID), tonumber(self.param.setID)
	tonumber(self.param.setID)[1] = i18n("privilege_text_122")
	tonumber(self.param.setID)[2] = i18n("privilege_text_121")
	local tonumber(self.param.setID)[3], setTitle = i18n("privilege_text_120"), tonumber(self.param.setID)
	self.fields.Panel_bg:setString(setTitle[self.ctype] or "")
	for i = 1, self.maxNum do
		table.insert(self.itemList, i)
	end
	self:refreshItem()
end
function setSelectPopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], self.ctype, self.rtype, self.handle, self.curIndex, self)
end
function setSelectPopViewPanel:refreshItem()
	self.fields.List:setNumItems(#self.itemList)
end
function setSelectPopViewPanel:sMsgRenameBack(target, data)
	self:refreshItem()
end
return setSelectPopViewPanel
