local dressCtrl = SoraDGetCtrl("dressCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CastleChangeTaskViewPanel = class("CastleChangeTaskViewPanel", baseFguiPanel)
function CastleChangeTaskViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CastleChangeTaskViewPanel:ctor", self.viewName)
end
function CastleChangeTaskViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CastleChangeTaskViewPanel:onInit()
	print("=======CastleChangeTaskViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("pray_text_11"))
	self.fields.Text_Tips:setString(i18n("skin_text_13"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function CastleChangeTaskViewPanel:onItemRenderer(index, obj)
	obj:initData(self.taskList[index + 1])
end
function CastleChangeTaskViewPanel:onShow()
	print("=======CastleChangeTaskViewPanel:onShow")
	self:initData()
end
function CastleChangeTaskViewPanel:initData()
	self.taskList = dressCtrl:getTaskList()
	self.fields.List:setNumItems(#self.taskList)
	dressCtrl = nil
	;(nil).num = dressCtrl:getPermanentCastleDressNum()
	self.fields.Text_num:setString(i18n("skin_text_24", nil))
end
return CastleChangeTaskViewPanel
