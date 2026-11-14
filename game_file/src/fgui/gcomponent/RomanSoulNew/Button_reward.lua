local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Button_reward", Button_reward)
function Button_reward:onInit()
	self.fields.Text_reward:setString(i18n("decrypt_text_03"))
	self:addClickListener(handler(self, self.onClickRewardPreview))
end
function Button_reward:onShow()
end
function Button_reward:onClickRewardPreview()
	SoraDPlaySound()
	uiManager:show("RomanRewardPreview"):setOwnerKey(self)
end
return Button_reward
