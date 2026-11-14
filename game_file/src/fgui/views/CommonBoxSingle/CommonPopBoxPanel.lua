local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonPopBoxPanel = class("CommonPopBoxPanel", baseFguiPanel)
function CommonPopBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("CommonPopBoxPanel:ctor", self.viewName)
end
function CommonPopBoxPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function CommonPopBoxPanel:onInit()
	print("=======CommonPopBoxPanel:onInit")
	self.fields.List_detail:setItemRenderer(handler(self, self.onItemRenderer))
end
function CommonPopBoxPanel:initData(param)
	dump(param, "sjfkajfksjfksdf", 10)
	self.fields.Panel_bg:setTitle(param.title or i18n("hero_title_02"))
	if not param.data then
		_ENV = param.data
	end
	self.data = param.data
	self.noIndex = param.noIndex or false
	if param.source then
		self.fields.List_detail:setDefaultItem(param.source)
	end
	self.fields.List_detail:setNumItems(table.nums(self.data))
	local itemHeight = self.fields.List_detail:getChildAt(0):getHeight()
	if itemHeight * table.nums(self.data) < self.fields.Panel_bg:getHeight() then
		self.fields.List_detail:resizeToFit(table.nums(self.data), 200)
	end
end
function CommonPopBoxPanel:onItemRenderer(index, object)
	if self.noIndex then
		object:initData(self.data[index + 1])
	else
		object:initData(index + 1, self.data[index + 1])
	end
end
function CommonPopBoxPanel:onShow()
	print("=======CommonPopBoxPanel:onShow")
	self:initData(self.proxy.param)
end
function CommonPopBoxPanel:onHide()
	print("=======CommonPopBoxPanel:onHide")
end
function CommonPopBoxPanel:onDispose()
	print("=======CommonPopBoxPanel:onDispose")
end
return CommonPopBoxPanel
