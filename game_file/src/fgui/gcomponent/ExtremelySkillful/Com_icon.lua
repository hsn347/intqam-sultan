local buffDesRead = include("buffDesRead")
local buffltCtrl = include("buffltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_icon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/Com_icon", Com_icon)
function Com_icon:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_icon:initData(iconName, buffID)
	if buffID then
		local effectType = buffltCtrl:getEffectType(buffID)
		self.buffDes = buffDesRead.getTitleBase(effectType)
	end
	self.fields.icon:setURL(iconName)
end
function Com_icon:onBtnClick()
	if self.buffDes and self.buffDes ~= "" then
		SoraDPlaySound()
		_ENV = nil
		;(nil).des = self.buffDes
		uiManager:show("RadiantMsgTip", nil)
	end
end
function Com_icon:onShow()
end
return Com_icon
