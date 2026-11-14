local baseComponent = require("fgui.base.baseComponent")
local Com_Input1 = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Input1", Com_Input1)
function Com_Input1:onInit()
end
function Com_Input1:onShow()
	self.fields.n1:setPrompt("输入")
	self.fields.n2:setPrompt("输入")
	self.fields.n3:setPrompt("输入")
	self.fields.n4:setPrompt("输入")
end
function Com_Input1:getInputData()
	return self.fields.n1:getText(), self.fields.n2:getText(), self.fields.n3:getText(), self.fields.n4:getText()
end
return Com_Input1
