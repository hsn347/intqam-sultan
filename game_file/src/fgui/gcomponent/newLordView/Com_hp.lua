local baseComponent = require("fgui.base.baseComponent")
local Com_hp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_hp", Com_hp)
function Com_hp:onInit()
	self.fields.bar:setMax(100)
	self.fields.Button_addStamina:addClickListener(handler(self, self.onBtnClick))
	self:fixChildrenPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function Com_hp:onShow()
end
function Com_hp:initData(maxValue, curValue)
	self.fields.bar:setValue(curValue * 100 / maxValue)
	_ENV = nil
	;(nil).var1 = curValue
	;(nil).var2 = maxValue
	self.fields.title:setString(i18n("%{var1}/%{var2}", nil))
end
function Com_hp:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).enum = 2
	uiManager:show("lordEXPHPBuyView", nil)
end
return Com_hp
