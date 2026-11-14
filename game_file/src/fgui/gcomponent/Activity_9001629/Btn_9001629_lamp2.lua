local baseComponent = require("fgui.base.baseComponent")
local Btn_9001629_lamp2 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001629/Btn_9001629_lamp2", Btn_9001629_lamp2)
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
function Btn_9001629_lamp2:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Btn_9001629_lamp2:onShow()
end
function Btn_9001629_lamp2:initData(wish, index)
	self.wishIdx = index
	local isHavePlayer = wish ~= nil and wish.uid ~= 0
	self.isHavePlayer = isHavePlayer
	self.fields.title:setVisible(isHavePlayer)
	self.fields.icon:setVisible(isHavePlayer)
	self.fields.ani_loop:setVisible(self.isHavePlayer)
	self.fields.bg:setVisible(isHavePlayer)
	if isHavePlayer then
		self.fields.ani_loop:setAllFrameNameOnce("dh_9001629_fzxh_%02d.png", 1, true)
		self.fields.title:setString(index == 1 and i18n("nebula_stars_wishing_text5") or wish.name)
	end
end
function Btn_9001629_lamp2:onClick()
	if not self.isHavePlayer then
		return
	end
	SoraDPlaySound()
	activity_9001629_Ctrl:reqPlayer(self.wishIdx)
end
return Btn_9001629_lamp2
