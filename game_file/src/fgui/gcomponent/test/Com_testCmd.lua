local baseComponent = require("fgui.base.baseComponent")
local Com_testCmd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://test/Com_testCmd", Com_testCmd)
function Com_testCmd:onInit()
	self.fields.Button_send:setString("发送")
	self.fields.Input_cmd:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.Input_cmd:addEventListener(fgui.UIEventType.Submit, handler(self, self.onChanged))
end
function Com_testCmd:onChanged()
	local prompt = self.fields.Input_cmd:getText()
	self.fields.Text_prompt:setString(prompt .. "?")
end
function Com_testCmd:onShow()
end
return Com_testCmd
