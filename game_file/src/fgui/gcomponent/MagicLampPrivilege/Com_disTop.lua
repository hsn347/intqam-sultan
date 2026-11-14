local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_disTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampPrivilege/Com_disTop", Com_disTop)
function Com_disTop:onInit()
	self.fields.Text_atonce:setString(i18n("common_text_4061"))
	self.fields.Text_once:setString(i18n("common_text_3990"))
	self:fixChildrenPos()
end
function Com_disTop:onShow()
end
function Com_disTop:initData(data)
	_ENV = nil
	;(nil).num = math.floor(data.discount[2])
	;(nil).char = "%"
	self.fields.Lab_discount:setString(i18n("common_text_1470", nil))
	if data.extraData then
		local alreadyBuy = privilegeGiftCtrl:getBoughtNums(data.rechargeID)
		_ENV = i18n("common_text_1470", nil)
		i18n("common_text_1470", nil).num = data.extraData - alreadyBuy
		self.fields.Text_once:setString(i18n("common_text_2516", i18n("common_text_1470", nil)))
	end
	self.fields.txtGold:setString(string.formatnumberthousands(data.gold))
end
return Com_disTop
