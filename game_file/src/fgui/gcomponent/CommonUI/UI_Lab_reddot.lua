local baseComponent = require("fgui.base.baseComponent")
local UI_Lab_reddot = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Lab_reddot", UI_Lab_reddot)
fgui.register_extension("ui://CommonUI/UI_Lab_reddotEX", UI_Lab_reddot)
function UI_Lab_reddot:onInit()
	self:setVisible(false)
end
function UI_Lab_reddot:onShow()
end
function UI_Lab_reddot:initData(visible, num)
	self:setVisible(visible)
	if visible then
		if num and (type(num) == "string" or type(num) == "number" and 0 < num) then
			self.fields.title:setVisible(true)
			if type(num) == "number" and 99 < num then
				self.fields.title:setString("99+")
			else
				self.fields.title:setString(num)
			end
		else
			self.fields.title:setVisible(false)
		end
	end
end
function UI_Lab_reddot:setMax()
	self:setVisible(true)
	self.fields.title:setVisible(true)
	self.fields.title:setString("99+")
end
return UI_Lab_reddot
