local baseComponent = require("fgui.base.baseComponent")
local Com_buffBar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CityInfoView/Com_buffBar", Com_buffBar)
function Com_buffBar:onInit()
	self:fixChildrenPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function Com_buffBar:onShow()
end
function Com_buffBar:initData(data)
	self.fields.Text_Name:setString(data.title)
	_ENV = nil
	;(nil).var = string.formatnumberthousands(data.curval)
	self.fields.Text_Perhour:setString(i18n("%{var}/h", nil))
	self.fields.bar:setMax(data.max)
	self.fields.bar:setValue(data.curval)
end
return Com_buffBar
