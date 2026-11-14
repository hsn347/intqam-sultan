local baseFguiPanel = require("fgui.base.baseFguiPanel")
local bulletUsmPopPanel = class("bulletUsmPopPanel", baseFguiPanel)
function bulletUsmPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("bulletUsmPopPanel:ctor", self.viewName)
end
function bulletUsmPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function bulletUsmPopPanel:onInit()
	print("=======bulletUsmPopPanel:onInit")
	self.fields.Text_Tips:setString(i18n("shoot_game_text_002"))
	self.fields.Text_Tip2:setString(i18n("shoot_game_text_003"))
	self.fields.Usm_1:setPrepareCallback(function()
		self.fields.Usm_1:play(true)
		self = true
		;(true).frame = 2
		self.fields.Usm_1:getCriSprite():addFrameEventData(true)
		self = true
		;(true).frame = 130
		self.fields.Usm_1:getCriSprite():addFrameEventData(true)
		self.fields.Usm_1:getCriSprite():setFrameEventCallback(handler(self, self.changeTips))
	end)
end
function bulletUsmPopPanel:changeTips(info)
	print("showUsm2", self.fields.Usm_1:getCriSprite():getTotalFrame(), info.frame)
	if info and info.frame and 2 == self.fields.Usm_1:getCriSprite():getCurPlayFrame() then
		self.fields.Text_Tip2:setString(i18n("shoot_game_text_003"))
	elseif info and info.frame and 130 == self.fields.Usm_1:getCriSprite():getCurPlayFrame() then
		self.fields.Text_Tip2:setString(i18n("shoot_game_text_004"))
	end
end
function bulletUsmPopPanel:onShow()
	print("=======bulletUsmPopPanel:onShow")
end
return bulletUsmPopPanel
