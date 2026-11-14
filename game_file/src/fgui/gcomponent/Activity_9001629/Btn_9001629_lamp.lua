local baseComponent = require("fgui.base.baseComponent")
local Btn_9001629_lamp = fgui.extension_class(fgui.GButton, baseComponent)
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
fgui.register_extension("ui://Activity_9001629/Btn_9001629_lamp", Btn_9001629_lamp)
function Btn_9001629_lamp:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Btn_9001629_lamp:setWishClickHandler(handler)
	self.wishClickHandler = handler
end
function Btn_9001629_lamp:onShow()
end
function Btn_9001629_lamp:initData(wish, index)
	self.wishIdx = index
	local isHavePlayer = activity_9001629_Ctrl:getIsHaveWish()
	self.isHavePlayer = isHavePlayer
	self.fields.icon:setVisible(not self.fields.add:isVisible())
	self.fields.ani_loop:setVisible(isHavePlayer)
	self.fields.add_bg:setVisible(not isHavePlayer)
	self.fields.add:setVisible(not isHavePlayer)
	self.fields.title:setVisible(isHavePlayer)
	self.fields.bg:setVisible(isHavePlayer)
	if isHavePlayer then
		self.fields.ani_loop:setAllFrameNameOnce("dh_9001629_fzxh_%02d.png", 1, true)
		self.fields.title:setString(index == 1 and i18n("nebula_stars_wishing_text5") or wish.name)
	end
end
function Btn_9001629_lamp:playWishAni()
	self.fields.icon:setVisible(false)
	self.fields.ani_loop:setVisible(false)
	self.fields.Usm_1:setAlpha(1)
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_1:setEffectPath("acitvitiy_usm_fz_9001629.usm", false)
	_ENV = "acitvitiy_usm_fz_9001629.usm"
	;("acitvitiy_usm_fz_9001629.usm").frame = 18
	self.fields.Usm_1:getCriSprite():addFrameEventData("acitvitiy_usm_fz_9001629.usm")
	self.fields.Usm_1:getCriSprite():setFrameEventCallback(function(data)
		self.fields.Usm_1:runAction(ffa.seq(ffa.fadeOut(0.2), ffa.callFunc(function()
			self.fields.Usm_1:clearEffect()
		end)))
		self.fields.icon:setVisible(true)
		self.fields.icon:setAlpha(0)
		self.fields.icon:runAction(ffa.fadeIn(0.3))
		self.fields.ani_loop:setVisible(true)
		self.fields.ani_loop:setAlpha(0)
		self.fields.ani_loop:runAction(ffa.fadeIn(0.3))
		self.fields.ani_loop:setAllFrameNameOnce("dh_9001629_fzxh_%02d.png", 1, true)
	end)
end
function Btn_9001629_lamp:onClick()
	if not self.isHavePlayer then
		if self.wishClickHandler then
			self.wishClickHandler()
		end
		return
	end
	SoraDPlaySound()
	activity_9001629_Ctrl:reqPlayer(self.wishIdx)
	activity_9001629_Ctrl:setRecordLikeNum()
	self:setReddot(false)
end
return Btn_9001629_lamp
