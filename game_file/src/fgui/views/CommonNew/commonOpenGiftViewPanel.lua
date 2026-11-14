local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonOpenGiftViewPanel = class("commonOpenGiftViewPanel", baseFguiPanel)
function commonOpenGiftViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("commonOpenGiftViewPanel:ctor", self.viewName)
end
function commonOpenGiftViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonOpenGiftViewPanel:onInit()
	print("=======commonOpenGiftViewPanel:onInit")
	self.closeHandler = nil
	self.fields.Text_title:setString(i18n("common_text_316"))
	self.fields.text_bottom_tip:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function commonOpenGiftViewPanel:onShow()
	print("=======commonOpenGiftViewPanel:onShow")
	SoraDPlaySound("uicontrol", 4)
	if not self.param.itemList then
		_ENV = self.param.itemList
	end
	self.itemList = self.param.itemList
	if not self.param.params then
		_ENV = self.param.params
	end
	self.params = self.param.params
	self:initData()
end
function commonOpenGiftViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], self.itemType)
end
function commonOpenGiftViewPanel:initData()
	if self.params and self.params.title then
		self.fields.Text_title:setString(self.params.title)
	end
	if self.params and self.params.bottomtip then
		self.fields.text_bottom_tip:setVisible(true)
		self.fields.text_bottom_tip:setString(self.params.bottomtip)
	end
	if self.params and self.params.closeHandler then
		self.closeHandler = self.params.closeHandler
	end
	self.itemType = self.params and self.params.itemType or nil
	local showHeight = math.min(#self.itemList * 65, display.height / 2)
	self.fields.List:setHeight(showHeight)
	self.fields.List:setNumItems(#self.itemList)
end
function commonOpenGiftViewPanel:onHide()
	if self.closeHandler then
		self.closeHandler()
	end
end
return commonOpenGiftViewPanel
