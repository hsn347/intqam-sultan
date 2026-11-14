local baseComponent = require("fgui.base.baseComponent")
local Bar_exp = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://NewServerReturn/Bar_exp", Bar_exp)
function Bar_exp:onInit()
end
function Bar_exp:onShow()
end
function Bar_exp:setPercent(curExp, nextExp)
	_ENV = nil
	;(nil).var1 = curExp
	;(nil).var2 = nextExp
	self.fields.Text_percent:setString(i18n("%{var1}/%{var2}", nil))
	self:setMax(nextExp)
	self:setValue(curExp)
	self.fields.n3:setPositionX(SoraDFPosX((1 - self:getValue() / self:getMax()) * self.fields.bar:getWidth() + 7, self:getWidth()))
end
return Bar_exp
