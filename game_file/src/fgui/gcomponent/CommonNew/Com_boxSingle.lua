local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_boxSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_boxSingle", Com_boxSingle)
fgui.register_extension("ui://CommonNew/Com_boxSingle2", Com_boxSingle)
fgui.register_extension("ui://Activity_9001649/Com_boxSingle", Com_boxSingle)
fgui.register_extension("ui://MagicLampMaigcPower/Com_boxSingle", Com_boxSingle)
fgui.register_extension("ui://Activity_9001665/Com_starSingle", Com_boxSingle)
function Com_boxSingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_boxSingle:onShow()
end
function Com_boxSingle:initData(index, point, state, handle)
	self.index = index
	self.handle = handle
	self.controllers.c_state:setSelectedIndex(state)
	self.fields.title:setString(string.formatnumberthousands(point))
end
function Com_boxSingle:btnClick(context)
	SoraDPlaySound()
	if self.handle then
		self.handle(self.index, context)
	end
end
function Com_boxSingle:initItem(id, count)
	self.fields.icon:setURL(publicRead.getIcon(id))
	publicRead = publicRead.getIcon(id)
	publicRead.getIcon(id).num = count
	self.fields.txtNum:setString(i18n("Eidal_celebration_text_29", publicRead.getIcon(id)))
	self.fields.txtNum:setVisible(true)
end
function Com_boxSingle:initOther(icon, num, gold)
	self.fields.icon:setURL(icon)
	self.fields.title:setString(string.formatnumberthousands(num))
	self.fields.title:setVisible(true)
	self.controllers.ctrlGoldNum:setSelectedIndex(gold and 1 or 0)
end
return Com_boxSingle
