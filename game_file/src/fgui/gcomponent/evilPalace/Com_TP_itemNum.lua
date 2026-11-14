local monsterpalaceCtrl = SoraDGetCtrl("monsterpalaceCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_TP_itemNum = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://evilPalace/Com_TP_itemNum", Com_TP_itemNum)
function Com_TP_itemNum:onInit()
	self.fields.btn_add:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_TP_itemNum:onShow()
end
function Com_TP_itemNum:initData()
	local itemCount = monsterpalaceCtrl:getItemCount()
	self.fields.title:setString(string.formatnumberthousands(itemCount))
end
function Com_TP_itemNum:btnClick()
	SoraDPlaySound()
	_ENV = nil
	_ENV, (nil).itemType = gItemType.ASSAULT_HORN, gItemType.ASSAULT_HORN
	;(nil).troopData, gItemType.ASSAULT_HORN.itemID = gItemType.ASSAULT_HORN, MONSTERPALACE_HORNID
	uiManager:show("PropBuyView", nil)
end
return Com_TP_itemNum
