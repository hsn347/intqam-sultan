local baseComponent = require("fgui.base.baseComponent")
local Btn_9001597_box = fgui.extension_class(fgui.GButton, baseComponent)
local activity_9001597_Ctrl = SoraDGetCtrl("activity_9001597_Ctrl")
fgui.register_extension("ui://Activity_9001597/Btn_9001597_box", Btn_9001597_box)
_UPVALUE5_ = fgui.register_extension
fgui.register_extension[1] = 1
fgui.register_extension[2] = 4
fgui.register_extension[3] = 5
fgui.register_extension[4] = 6
local fgui.register_extension[5], boxIndex = 8, fgui.register_extension
function Btn_9001597_box:onInit()
	self.isJoinAlliance = activity_9001597_Ctrl:getIsJoinAlliance()
	self:addClickEventListener(handler(self, self.onClicked))
end
function Btn_9001597_box:onShow()
end
function Btn_9001597_box:initData(boxInfo, index)
	self.index = index
	local boxScore = activity_9001597_Ctrl:getBoxRewardNum()
	self.fields.title:setString(string.formatnumberthousands(boxInfo.score))
	self.fields.title:setColor(boxScore < boxInfo.score and cc.c3b(185, 149, 72) or cc.c3b(255, 223, 45))
	dump(boxInfo, "boxInfo")
	local getStatus = activity_9001597_Ctrl:getBoxRewardDataStatus(self.index, boxInfo.score)
	if not self.isJoinAlliance and getStatus == gBtnTargetStatusDef.GET then
		getStatus = gBtnTargetStatusDef.NONE
	end
	local imgIcon = self.fields.loarder:getContent()
	if not imgIcon then
		imgIcon = SoraDGetCommonBox(boxIndex[index], getStatus, imgIcon)
		self.fields.loarder:setContent(imgIcon)
	else
		SoraDGetCommonBox(boxIndex[index], getStatus, imgIcon)
	end
	if not self.isJoinAlliance then
		self.controllers.c1:setSelectedIndex(0)
		return
	end
	if gBtnTargetStatusDef.GOT == getStatus then
		SoraDSetNodeGray(imgIcon, true)
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(getStatus == gBtnTargetStatusDef.GET and 1 or 0)
	end
end
function Btn_9001597_box:setClickHandler(callback)
	self.callback = callback
end
function Btn_9001597_box:onClicked()
	if self.callback then
		self.callback(self, self.index)
	end
end
return Btn_9001597_box
