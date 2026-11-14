local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ATotalPanel = class("ATotalPanel", baseFguiPanel)
function ATotalPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ATotalPanel:ctor", self.viewName)
end
function ATotalPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ATotalPanel:onInit()
	print("=======ATotalPanel:onInit")
	self.fields.Text_title:setString(i18n("common_text_1356"))
	self.fields.Text_tip:setString(i18n("mail_2_text_12"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function ATotalPanel:onItemRenderer(index, obj)
	local data = self.param.materialArray[index + 1]
	obj:initData(data.id, data.count)
end
function ATotalPanel:onShow()
	print("=======ATotalPanel:onShow")
	local count = 0
	for k, v in ipairs(self.param.materialArray) do
		count = count + v.count
	end
	_ENV = nil
	;(nil).value = fguiHelper.getColorString("#FF9600", count)
	self.fields.Text_total:setString(i18n("common_text_1357", nil))
	self.fields.list:setNumItems(#self.param.materialArray)
end
return ATotalPanel
