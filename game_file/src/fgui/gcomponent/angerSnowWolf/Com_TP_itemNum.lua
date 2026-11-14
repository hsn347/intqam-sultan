local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_TP_itemNum = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://angerSnowWolf/Com_TP_itemNum", Com_TP_itemNum)
function Com_TP_itemNum:onInit()
	self.fields.btn_add:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_TP_itemNum:onShow()
end
function Com_TP_itemNum:initData()
	local itemCount = angrySnowWolfKingCtrl:getItemCount()
	self.fields.title:setString(string.formatnumberthousands(itemCount))
end
function Com_TP_itemNum:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = angrySnowWolfKingCtrl:getItemID()
	uiManager:show("CommonSourceGuide", nil)
end
return Com_TP_itemNum
