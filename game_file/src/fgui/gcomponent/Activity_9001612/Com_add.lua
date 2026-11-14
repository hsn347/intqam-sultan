local constantRead = include("constantRead")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_add = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001612/Com_add", Com_add)
function Com_add:onInit()
	self.coinID = constantRead.getConstValue("PLAYER_GLORY_RETURN_STORE_ITEM")
	self.fields.Button_add:addClickListener(handler(self, self.onBtnClick))
	self:fixChildrenPos()
end
function Com_add:onShow()
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.coinID))
end
function Com_add:initData()
	self.fields.title:setString(backpackCtrl:getItemCount(self.coinID))
end
function Com_add:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.coinID
	uiManager:show("CommonSourceGuide", nil)
end
return Com_add
