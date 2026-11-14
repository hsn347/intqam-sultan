local baseComponent = require("fgui.base.baseComponent")
local Btn_buy = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Btn_buy", Btn_buy)
function Btn_buy:onInit()
	self.fields.icon:fixPos()
	self.fields.Text_oldPrice:fixPos()
	self.fields.n4:fixPos()
	self.fields.Text_nowPrice:fixPos()
end
function Btn_buy:onShow()
end
function Btn_buy:initData(cur, ori)
	self.fields.Text_nowPrice:setString(string.formatnumberthousands(cur))
	self.fields.Text_nowPrice:fixPos()
	self.fields.Text_oldPrice:setString(string.formatnumberthousands(ori))
end
function Btn_buy:checkGold(cur)
	self.fields.Text_nowPrice:setColor(SoraDEnoughGold(cur, true) and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
end
return Btn_buy
