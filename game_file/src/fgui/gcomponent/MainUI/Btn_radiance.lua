local baseComponent = require("fgui.base.baseComponent")
local Btn_radiance = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_radiance", Btn_radiance)
function Btn_radiance:onInit()
	self.fields.lab_red:setVisible(false)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_radiance:onShow()
end
function Btn_radiance:setRed(num)
	self._isShowRed = 0 < num
	self.fields.lab_red:setVisible(0 < num)
	self.fields.lab_red:setString(num)
end
function Btn_radiance:isShowRed()
	return self._isShowRed or false
end
function Btn_radiance:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
function Btn_radiance:onBtnClick()
	SoraDPlaySound()
	local radianceWarUtil = include("radianceWarUtil")
	radianceWarUtil.openRadianceWarView()
end
return Btn_radiance
