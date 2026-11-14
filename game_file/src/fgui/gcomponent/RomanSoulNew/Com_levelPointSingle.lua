local baseComponent = require("fgui.base.baseComponent")
local Com_levelPointSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_levelPointSingle", Com_levelPointSingle)
function Com_levelPointSingle:onInit()
	self.white = true
	self.fields.bg:setVisible(false)
	self:fixChildrenPos()
end
function Com_levelPointSingle:initData(whiteFlag, data)
	if whiteFlag then
		self.fields.bg:setVisible(true)
	end
	self.fields.Text_point:setString(data.point)
	self.fields.Text_level:setString(tostring(data.level))
end
function Com_levelPointSingle:onShow()
end
return Com_levelPointSingle
