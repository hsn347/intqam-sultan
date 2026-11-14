local baseFguiPanel = require("fgui.base.baseFguiPanel")
local GetWayPopBoxPanel = class("GetWayPopBoxPanel", baseFguiPanel)
function GetWayPopBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("GetWayPopBoxPanel:ctor", self.viewName)
end
function GetWayPopBoxPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function GetWayPopBoxPanel:onInit()
	print("=======GetWayPopBoxPanel:onInit")
end
function GetWayPopBoxPanel:initData()
	print("=======GetWayPopBoxPanel:onInit")
	self.fields.Text_title:setString(self.data.title)
	self.fields.List_getWay:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_getWay:setNumItems(self.data.size)
	self.fields.List_getWay:resizeToFit(self.data.size, 50)
	self.fields.List_getWay:getChildAt(self.data.size - 1):setLineVisible(false)
end
function GetWayPopBoxPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.data.defaultBtnTitle or self.data.btnTitle[index + 1], self.data.itemTitle[index + 1], self.data.btnCallBack[index + 1], self.data.btnCallBackParam[index + 1], self.data.notCloseSelf)
end
function GetWayPopBoxPanel:onShow()
	print("=======GetWayPopBoxPanel:onShow")
	self.data = self.proxy.param
	self:initData()
end
function GetWayPopBoxPanel:onHide()
	print("=======GetWayPopBoxPanel:onHide")
end
function GetWayPopBoxPanel:onDispose()
	print("=======GetWayPopBoxPanel:onDispose")
end
return GetWayPopBoxPanel
