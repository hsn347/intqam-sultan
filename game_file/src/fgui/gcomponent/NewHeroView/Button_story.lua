local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_story = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Button_story", Button_story)
function Button_story:onInit()
	self.fields.btn:setString(i18n("Biography_text_11"))
	self.fields.red:setVisible(false)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Button_story:onShow()
end
function Button_story:setRed()
	local num = heroBiographyCtrl:getUnlockHeroStoryNum()
	self.fields.red:setVisible(0 < num)
	self.fields.red:setTitle(num)
end
function Button_story:onBtnClick()
	SoraDPlaySound()
	if SoraDGetCastleLv() >= CASTLE_LV40_LIMITED then
		uiManager:show("HeroCollectedBiographies")
	else
		_ENV = nil
		;(nil).level = 1
		SoraDShowMsgTip(i18n("common_text_3962", nil))
	end
end
return Button_story
