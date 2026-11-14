local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatCmdPopPanel = class("CheatCmdPopPanel", baseFguiPanel)
function CheatCmdPopPanel:ctor(...)
	CheatCmdPopPanel.super.ctor(self, ...)
	print("CheatCmdPopPanel:ctor", self.viewName)
end
function CheatCmdPopPanel:onInit()
	print("=======CheatCmdPopPanel:onInit")
	self.fields.Button_cmd:addClickListener(handler(self, self.btnClick))
end
function CheatCmdPopPanel:onShow()
	print("=======CheatCmdPopPanel:onShow")
	self.prompt = self.param.prompt
	self.btnTitle = self.param.btnTitle
	self.handle = self.param.handle
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder(self.prompt or "输入参数")
	self.fields.Button_cmd:setString(self.btnTitle or "确定")
end
function CheatCmdPopPanel:btnClick()
	SoraDPlaySound()
	if self.handle then
		self.handle(self.input:getText())
	end
	self:close()
end
return CheatCmdPopPanel
