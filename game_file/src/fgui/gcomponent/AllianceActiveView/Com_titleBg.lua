local baseComponent = require("fgui.base.baseComponent")
local Com_titleBg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceActiveView/Com_titleBg", Com_titleBg)
function Com_titleBg:onInit()
	self.fields.Button_log:addClickListener(handler(self, self.btnLogClick))
	self.fields.Button_log:fixPos()
end
function Com_titleBg:onShow()
end
function Com_titleBg:initData(title, isShowLog)
	self.fields.title:setString(title)
	self.fields.Button_log:setVisible(isShowLog or false)
end
function Com_titleBg:btnLogClick()
	SoraDPlaySound()
	SoraDCreatePanel("allianceActiveLogView"):show()
end
return Com_titleBg
