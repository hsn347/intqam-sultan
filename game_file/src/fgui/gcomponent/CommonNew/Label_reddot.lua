local baseComponent = require("fgui.base.baseComponent")
local Label_reddot = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Label_reddot", Label_reddot)
fgui.register_extension("ui://CommonNew/Label_reddotNew", Label_reddot)
function Label_reddot:onInit()
	self:setVisible(false)
	self.title = self:getChild("title")
end
function Label_reddot:onShow()
end
function Label_reddot:initData(visible, num)
	self:setVisible(visible)
	if visible then
		if num and (type(num) == "string" or type(num) == "number" and 0 < num) then
			self.title:setVisible(true)
			if type(num) == "number" and 99 < num then
				self.title:setString("99+")
			else
				self.title:setString(num)
			end
		else
			self.title:setVisible(false)
		end
	end
end
function Label_reddot:setMax()
	self.title:setVisible(true)
	self.title:setString("99+")
end
