local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local LinkSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://LinkLinkGame/LinkSingle", LinkSingle)
function LinkSingle:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function LinkSingle:onShow()
end
function LinkSingle:initData(info, index, isLinking, isChoosed)
	self.index = index
	self.isLinking = isLinking
	if info and info.heroID then
		self:setIcon(heroltCtrl.getHeroInfo(info.heroID).herIcon)
		self:setVisible(true)
		self:showSelected(not self.isSelected or self.isLinking or isChoosed)
	else
		self:setVisible(false)
	end
end
function LinkSingle:onClick()
	if self.isBreak then
		return
	end
	SoraDPlaySound()
	if not self.isLinking then
		self:showSelected(true)
		_ENV = self
		self.msg = "MESSAGE_LINKLINK_CHOOSE"
		self.index = self.index
		SoraDSendMessage(self)
	end
end
function LinkSingle:showSelected(isSelected)
	if isSelected and self.isSelected then
		return
	end
	if isSelected then
		self.fields.selected:setVisible(true)
		self.controllers.c1:setSelectedIndex(1)
		self.fields.effect:setVisible(false)
		self.fields.selected:setAlpha(0)
		self.fields.selected:stopAllActions()
		self.fields.selected:runAction(ffa.fadeIn(0.1))
		self.isSelected = true
	else
		self.controllers.c1:setSelectedIndex(0)
		self.isSelected = false
	end
end
function LinkSingle:showBreak(endCallback)
	self.controllers.c1:setSelectedIndex(1)
	self.isBreak = true
	self.transitions.shine:play(function()
		print(" LinkSingle:showBreak End")
		if endCallback then
			endCallback()
		end
	end)
	self.fields.effect:setVisible(true)
	self.fields.effect:setAllFrameName("dh_llk1_%02d.png", 1)
	self.fields.effect:setPlaySettings(0, -1, 1)
end
return LinkSingle
