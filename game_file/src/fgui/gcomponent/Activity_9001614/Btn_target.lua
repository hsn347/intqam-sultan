local activity_9001614_Ctrl = SoraDGetCtrl("activity_9001614_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_target = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001614/Btn_target", Btn_target)
_UPVALUE5_ = fgui.register_extension
fgui.register_extension[1] = 1
fgui.register_extension[2] = 4
fgui.register_extension[3] = 5
fgui.register_extension[4] = 6
local fgui.register_extension[5], boxIndex = 8, fgui.register_extension
function Btn_target:onInit()
	self:addClickEventListener(handler(self, self.onBtnClick))
end
function Btn_target:onShow()
end
function Btn_target:initData(data, index)
	self.data = data
	self.fields.title:setString(self.data.rechargeAmount)
	self.status = activity_9001614_Ctrl:getBoxStatus(self.data.index)
	local imgIcon = self.fields.loarder:getContent()
	local boxStyle = boxIndex[index] or boxIndex[#boxIndex]
	if not imgIcon then
		imgIcon = SoraDGetCommonBox(boxStyle, self.status, imgIcon)
		self.fields.loarder:setContent(imgIcon)
	else
		SoraDGetCommonBox(boxStyle, self.status, imgIcon)
	end
	if gBtnTargetStatusDef.GOT == self.status then
		SoraDSetNodeGray(imgIcon, true)
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(self.status == gBtnTargetStatusDef.GET and 1 or 0)
	end
end
function Btn_target:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	;(nil).status = self.status
	uiManager:show("Activity_9001614_pop", nil)
end
return Btn_target
