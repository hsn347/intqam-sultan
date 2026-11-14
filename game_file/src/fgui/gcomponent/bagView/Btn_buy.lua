local baseComponent = require("fgui.base.baseComponent")
local Btn_buy = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://bagView/Btn_buy", Btn_buy)
function Btn_buy:onInit()
	self.fields.spriteGold:fixPos()
	self.fields.Text_ori:fixPos()
	self.fields.n4:fixPos()
end
function Btn_buy:onShow()
end
function Btn_buy:initData(cur, ori)
	self.controllers.c1:setSelectedIndex(ori and 1 or 0)
	self.fields.title:setString(string.formatnumberthousands(cur))
	self.fields.title:fixPos()
	if ori then
		self.fields.Text_ori:setString(string.formatnumberthousands(ori))
	end
end
return Btn_buy
