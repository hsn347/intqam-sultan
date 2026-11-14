local baseComponent = require("fgui.base.baseComponent")
local Progress_score = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Progress_score", Progress_score)
function Progress_score:onInit()
	self:fixChildrenPos()
	self.fields.bar:fix(false)
	self.fields.Text_point:fix(false)
end
function Progress_score:setValue(curValue, needValue)
	self.fields.Text_point:setString(curValue .. "/" .. needValue)
	if curValue < needValue then
		self.fields.bar:setFillAmount(1 - curValue / needValue)
		self.percent = curValue / needValue
	else
		self.fields.bar:setFillAmount(0)
		self.percent = 1
	end
	self:setPointPoistion(curValue, needValue)
end
function Progress_score:setPointPoistion(curValue, needValue)
end
function Progress_score:setMax()
	self.fields.bar:setFillAmount(0)
	self.fields.Text_point:setString("MAX")
end
function Progress_score:onShow()
end
return Progress_score
