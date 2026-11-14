local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonQuicklyaddPanel = class("CommonQuicklyaddPanel", baseFguiPanel)
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function CommonQuicklyaddPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommonQuicklyaddPanel:ctor", self.viewName)
end
function CommonQuicklyaddPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonQuicklyadd"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function CommonQuicklyaddPanel:onInit()
	print("=======CommonQuicklyaddPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("quick_use_03"))
	self.fields.Label_title1:setString(i18n("quick_use_04"))
	self.fields.Label_title2:setString(i18n("quick_use_05"))
	self.fields.Button_use:setTitle(i18n("common_text_314"))
	self.fields.Button_use:addClickEventListener(handler(self, self.onBtnUseClick))
	self.useList = self.proxy.useList
	self.resultList = self.proxy.resultList
	local scroll = self.fields.List_1
	scroll:setItemRenderer(handler(self, self.onNormalItemRenderer1))
	scroll:setNumItems(#self.useList)
	local scroll = self.fields.List_2
	scroll:setItemRenderer(handler(self, self.onNormalItemRenderer2))
	scroll:setNumItems(#self.resultList)
end
function CommonQuicklyaddPanel:onShow()
	print("=======CommonQuicklyaddPanel:onShow")
end
function CommonQuicklyaddPanel:onHide()
	print("=======CommonQuicklyaddPanel:onHide")
end
function CommonQuicklyaddPanel:onDispose()
	print("=======CommonQuicklyaddPanel:onDispose")
end
function CommonQuicklyaddPanel:onBtnUseClick()
	local _ENV, data
	for i, v in ipairs(self.useList) do
		_ENV = v.id
		v.id.count = v.count
		data[tostring(v.id)], v.id.extra = v.id, v.extra
	end
	backpackCtrl:reqUseItemList(data)
	self:closePanel()
end
function CommonQuicklyaddPanel:onNormalItemRenderer1(index, obj)
	local data = self.useList[index + 1]
	obj:initData(data.id, data.count)
end
function CommonQuicklyaddPanel:onNormalItemRenderer2(index, obj)
	local data = self.resultList[index + 1]
	obj:getChild("Image_icon"):setURL(publicRead.getIcon(data.id))
	obj:getChild("title"):setString(SoraDConvertNumberWithUnit(data.count))
end
return CommonQuicklyaddPanel
