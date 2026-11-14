local voiceChatHoldPopView = class("voiceChatHoldPopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("voiceChatHoldPopView")
	end
	return target
end)
function voiceChatHoldPopView:ctor()
	self.isHidePrePanel = false
	self.spHold = SoraDGetChildByName(self, "Sprite_icon")
	_UPVALUE1_ = nil
	;(nil)[1] = cca.fadeTo(1, 0.5)
	;(nil)[2] = cca.fadeTo(1, 1)
	;(nil)[3] = cca.fadeTo(1, 1)
	;(nil)[4] = cca.fadeTo(1, 1)
	self.spHold:runAction(cca.repeatForever(cca.seq(nil)))
end
return voiceChatHoldPopView
