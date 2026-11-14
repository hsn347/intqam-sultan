local baseComponent = require("fgui.base.baseComponent")
local Progress_score = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://NebulaCompetition/Progress_score", Progress_score)
function Progress_score:onInit()
	self.fields.bar:fixPos()
	self.fields.Image_light:fixPos()
	_UPVALUE2_ = self.fields.Image_light.fixPos
	self.lines, self.fields.Image_light.fixPos[1] = self.fields.Image_light.fixPos, self.fields.Image_line1
	self.lines, self.fields.Image_light.fixPos[2] = self.fields.Image_light.fixPos, self.fields.Image_line2
	local x = self.fields.Loader:getX()
	local width = self.fields.Loader:getWidth()
	self.fields.Image_line1:setX(x + width / 3)
	self.fields.Image_line2:setX(x + width * 2 / 3)
end
function Progress_score:onShow()
end
function Progress_score:setTextValue(value)
	self.fields.Text_value:setString(value)
end
return Progress_score
