local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001643_ChapterPanel = class("Activity_9001643_ChapterPanel", baseFguiPanel)
function Activity_9001643_ChapterPanel:ctor(...)
	Activity_9001643_ChapterPanel.super.ctor(self, ...)
	print("Activity_9001643_ChapterPanel:ctor", self.viewName)
end
function Activity_9001643_ChapterPanel:onInit()
	print("=======Activity_9001643_ChapterPanel:onInit")
	self.fields.Com_title:initData(i18n("eidal_celebration_text2"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function Activity_9001643_ChapterPanel:onShow()
	print("=======Activity_9001643_ChapterPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_chapter:setAlpha(0)
	self.fields.first:runAction(ffa.fadeOut(0.3))
	self.fields.Com_chapter:initData(self.param.cfg)
	_UPVALUE1_ = ffa.fadeOut(0.3)
	ffa.fadeOut(0.3)[1] = ffa.delay(0.8)
	ffa.fadeOut(0.3)[2] = ffa.fadeIn(0.3)
	ffa.fadeOut(0.3)[3] = ffa.fadeIn(0.3)
	self.fields.Com_chapter:runAction(ffa.seq(ffa.fadeOut(0.3)))
end
function Activity_9001643_ChapterPanel:updateView(target, data)
	self.fields.Com_chapter:initData(self.param.cfg)
end
function Activity_9001643_ChapterPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("eidal_celebration_text30")
	uiManager:show("RuleView", nil)
end
return Activity_9001643_ChapterPanel
