local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AtlantisSeaonEndPanel = class("AtlantisSeaonEndPanel", baseFguiPanel)
function AtlantisSeaonEndPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AtlantisSeaonEndPanel:ctor", self.viewName)
end
function AtlantisSeaonEndPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
	end
	return self._packageList
end
function AtlantisSeaonEndPanel:onInit()
	print("=======AtlantisSeaonEndPanel:onInit")
	_UPVALUE2_ = nil
	;(nil)[1] = "ar"
	;(nil)[2] = "en"
	local icon = SoraDGetImageNameByLang("frame_shmc_congratulation_%s.png", nil)
	self.fields.Load_title:setURL(icon)
	self.fields.Text_des:setString(i18n("atlantiswar_text_0411", self.param))
end
function AtlantisSeaonEndPanel:onShow()
	print("=======AtlantisSeaonEndPanel:onShow")
end
return AtlantisSeaonEndPanel
