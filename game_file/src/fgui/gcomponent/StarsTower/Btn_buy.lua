local starlightPavilionCtrl = SoraDGetCtrl("starlightPavilionCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_buy = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://StarsTower/Btn_buy", Btn_buy)
function Btn_buy:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.icon:fixPos()
	self.fields.Text_nowPrice:fixPos()
	self.fields.Text_oldPrice:fixPos()
	self.fields.n4:fixPos()
end
function Btn_buy:onShow()
end
function Btn_buy:initData(data)
	self.data = data
	self.fields.Text_nowPrice:setString(string.formatnumberthousands(data.price))
	self.fields.Text_nowPrice:setColor(data.price > SoraDGetGold() and cc.c3b(190, 40, 40) or cc.c3b(255, 255, 0))
	self.fields.Text_oldPrice:setString(string.formatnumberthousands(data.originPrice))
end
function Btn_buy:onBtnClick()
	SoraDPlaySound()
	local boughtNum = starlightPavilionCtrl:getExchangeCount(self.data.index)
	local leftNum = self.data.limitNum - boughtNum
	if 0 < leftNum then
		if SoraDEnoughGold(self.data.price) then
			_ENV = nil
			;(nil).data = self.data
			uiManager:show("StarsTowerExchangeProp", nil)
		end
	else
		SoraDShowMsgTip(i18n("Nebulastore_text_01"))
	end
end
return Btn_buy
