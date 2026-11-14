local baseComponent = require("fgui.base.baseComponent")
local Com_RoundDetailCell = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_RoundDetailCell", Com_RoundDetailCell)
function Com_RoundDetailCell:onInit()
end
function Com_RoundDetailCell:onShow()
end
function Com_RoundDetailCell:initData(name, value, color, percentValue, symbol)
	local effectValue
	if type(value) == "table" then
		effectValue = value.effectValue
	else
		effectValue = value
	end
	self.fields.text_name:setString(name)
	local str
	if percentValue then
		local percentValue = effectValue * percentValue
		local formattedValue = string.format("%.2f", percentValue):gsub("%.?0+$", "")
		str = formattedValue .. "%"
	else
		str = string.formatnumberthousands(effectValue)
	end
	if symbol then
		str = symbol .. str
	end
	self.fields.text_value:setString(str)
	if color then
		self.controllers.c1:setSelectedIndex(color)
	end
end
return Com_RoundDetailCell
