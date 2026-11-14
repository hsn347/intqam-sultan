local baseFguiPanel = require("fgui.base.baseFguiPanel")
local openSesameCtrl = SoraDGetCtrl("openSesameCtrl")
local OpenSesamePopPanel = class("OpenSesamePopPanel", baseFguiPanel)
function OpenSesamePopPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("OpenSesamePopPanel:ctor", self.viewName)
end
function OpenSesamePopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function OpenSesamePopPanel:onInit()
	print("=======OpenSesamePopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.list:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function OpenSesamePopPanel:onShow()
	print("=======OpenSesamePopPanel:onShow")
	self.rewardCfgs = openSesameCtrl:getPreRewards()
	self.fields.list:setNumItems(#self.rewardCfgs)
end
function OpenSesamePopPanel:onNormalItemRenderer(index, obj)
	local item = self.rewardCfgs[index + 1]
	obj:initData(item.id, item.count)
end
return OpenSesamePopPanel
