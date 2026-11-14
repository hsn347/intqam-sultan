local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_FirstPanel = class("Activity_9001731_FirstPanel", baseFguiPanel)
function Activity_9001731_FirstPanel:ctor(...)
	self.isLRU = true
	Activity_9001731_FirstPanel.super.ctor(self, ...)
	print("Activity_9001731_FirstPanel:ctor", self.viewName)
end
function Activity_9001731_FirstPanel:onInit()
	print("=======Activity_9001731_FirstPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Ludo_test_021"))
end
function Activity_9001731_FirstPanel:endShow()
	print("=======Activity_9001731_FirstPanel:endShow")
	self.player = self.param.player
	self.fields.Text_name:setString(self.player.nickName or self.player.name)
	self.fields.Com_head:setHeadSprite(self.player.iconID or self.player.head, self.player.avatar)
	_UPVALUE1_ = self.player.avatar
	self.player.avatar[1] = ffa.delay(3)
	self.player.avatar[2] = ffa.callFunc(function()
		self:close()
	end)
	self.player.avatar[3] = ffa.callFunc(function()
		self:close()
	end)
	self:runAction(ffa.seq(self.player.avatar))
end
function Activity_9001731_FirstPanel:obSystemBackKeyClick()
end
return Activity_9001731_FirstPanel
