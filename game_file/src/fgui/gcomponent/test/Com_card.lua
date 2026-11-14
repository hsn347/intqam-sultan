_ENV = nil
;(nil).JK1 = 16
local (nil).JK2, POKER_JK_RANK = 17, nil
local baseComponent = require("fgui.base.baseComponent")
local Com_card = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://test/Com_card", Com_card)
function Com_card:onInit()
	self.fields.Text_jk1:setString([[
J
O
K
E
R]])
	self.fields.Text_jk2:setString([[
J
O
K
E
R]])
	self:addClickListener(handler(self, self.btnClick))
end
function Com_card:onShow()
end
function Com_card:initData(data, curChooseCard)
