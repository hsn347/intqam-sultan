local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_super = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://merchanteView/Com_super", Com_super)
function Com_super:onInit()
	self.fields.Text_todayTip:setString(i18n("common_text_440"))
	self.fields.Text_todayTip:enableGradient(cc.c3b(253, 245, 185), cc.c3b(240, 217, 114))
	self.fields.Text_todayTip:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	self.fields.touch:addClickListener(handler(self, self.btnHelpClick))
	self.fields.icon:fixPos()
	self.fields.Text_oldPrice:fixPos()
	self.fields.Text_nowPrice:fixPos()
end
function Com_super:onShow()
end
function Com_super:initData(data)
	self.fields.item:initData(data.itemId, data.itemNum)
	self.fields.item:showCoolSquare(true)
	self.fields.Text_itemName:setString(publicRead.getName(data.itemId))
	self.fields.Text_oldPrice:setString(string.formatnumberthousands(data.primeprice))
	self.fields.Text_nowPrice:setString(string.formatnumberthousands(data.price))
	self.fields.line:fixPos()
end
function Com_super:btnHelpClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_443"))
end
return Com_super
