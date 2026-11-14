local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_listSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ItemSend/Com_listSingle", Com_listSingle)
function Com_listSingle:onInit()
	self.fields.Btn_gift:addClickListener(handler(self, self.onGiftClick))
end
function Com_listSingle:onShow()
end
function Com_listSingle:initData(data, itemID)
	self.data = data
	self.itemID = itemID
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Text_name:setString(data.nickName)
	_ENV = nil
	;(nil).var1 = string.formatnumberthousands(data.totalFc)
	self.fields.Text_power:setString(i18n("across_move_power_name", nil))
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function Com_listSingle:onGiftClick()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) > 0 then
		_ENV = nil
		;(nil).data = self.data
		;(nil).itemID = self.itemID
		uiManager:show("ItemSendPop", nil)
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
return Com_listSingle
