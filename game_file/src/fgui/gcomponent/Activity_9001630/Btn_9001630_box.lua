local activity_9001630_Ctrl = SoraDGetCtrl("activity_9001630_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_9001630_box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001630/Btn_9001630_box", Btn_9001630_box)
_UPVALUE5_ = fgui.register_extension
fgui.register_extension[1] = 1
fgui.register_extension[2] = 4
fgui.register_extension[3] = 5
fgui.register_extension[4] = 6
local fgui.register_extension[5], boxIndex = 8, fgui.register_extension
function Btn_9001630_box:onInit()
	self:addClickEventListener(handler(self, self.onClicked))
end
function Btn_9001630_box:onShow()
end
function Btn_9001630_box:initData(boxInfo, index)
	self.index = index
	local boxScore = activity_9001630_Ctrl:getScore()
	self.fields.title:setString(string.formatnumberthousands(boxInfo.point))
	dump(boxInfo, "boxInfo")
	local getStatus = activity_9001630_Ctrl:getBoxRewardDataStatus(self.index, boxInfo.point)
	if gBtnTargetStatusDef.GOT == getStatus then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(getStatus == gBtnTargetStatusDef.GET and 1 or 0)
	end
end
function Btn_9001630_box:setClickHandler(callback)
	self.callback = callback
end
function Btn_9001630_box:onClicked()
	if self.callback then
		self.callback(self, self.index)
	end
end
return Btn_9001630_box
