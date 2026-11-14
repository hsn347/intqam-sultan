local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local tradeBoardMoneySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://marketView/tradeBoardMoneySingle", tradeBoardMoneySingle)
function tradeBoardMoneySingle:onInit()
	self.fields.Button_gain:setString(i18n("common_text_1146"))
	self.fields.Button_gain:addClickListener(handler(self, self.btnGainClick))
	self:fixChildrenPos()
end
function tradeBoardMoneySingle:onShow()
end
function tradeBoardMoneySingle:initData(data)
	self.data = data
	self.fields.item:initData(gIDDef.GOLD, self.data.gold)
	_ENV = nil
	_ENV = nil
	;(nil).name = publicRead.getName(self.data.item)
	;(nil).count = self.data.num
	;(nil).item = i18n("common_text_1460", nil)
	self.fields.Text_singleDes:setString(i18n("common_text_3367", nil))
	self.fields.Text_singleTime:setString(SoraDConvertTimeToDate(self.data.time, false, true))
end
function tradeBoardMoneySingle:btnGainClick()
	SoraDPlaySound()
	salesRoomAgCtrl:sendReceiveOneGold(self.data)
end
return tradeBoardMoneySingle
