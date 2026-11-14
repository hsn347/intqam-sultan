local baseComponent = require("fgui.base.baseComponent")
local Progress_score = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity2112/Progress_score", Progress_score)
fgui.register_extension("ui://ArtisanHouse/Com_artisanProgressBar", Progress_score)
fgui.register_extension("ui://RadiantDecree/Com_artisanProgressBar", Progress_score)
function Progress_score:onInit()
	self.fields.bar:fix(false)
	self.lang = SoraDGetDefaultLanguage()
end
function Progress_score:setValue(curValue, needValue)
	curValue = curValue or 0
	local lang = SoraDGetDefaultLanguage()
	self.fields.Text_point:setString(curValue .. "/" .. needValue)
	if needValue > curValue then
		self.fields.bar:setFillAmount(1 - curValue / needValue)
		self.percent = curValue / needValue
	else
		self.fields.bar:setFillAmount(0)
		self.percent = 1
	end
	self:setPointPoistion(curValue, needValue)
end
function Progress_score:setPointPoistion(curValue, needValue)
	if not self.fields.point then
		return
	end
	if self.lang == "ar" then
		local offset = needValue ~= 0 and self.fields.line:getWidth() * (curValue / needValue) + self.fields.point:getWidth() / 2 or 0
		self.fields.point:setPositionX(self.fields.line:getPositionX() + self.fields.line:getWidth() - offset)
	else
		local offset = needValue ~= 0 and self.fields.line:getWidth() * (curValue / needValue) - self.fields.point:getWidth() / 2 or 0
		self.fields.point:setPositionX(self.fields.line:getPositionX() + offset)
	end
end
function Progress_score:setMax()
	self.fields.bar:setFillAmount(0)
	self.fields.Text_point:setString("MAX")
end
function Progress_score:positionFix()
end
function Progress_score:onShow()
end
return Progress_score
