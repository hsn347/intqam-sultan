local baseComponent = require("fgui.base.baseComponent")
local Com_9001702_bg2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001702/Com_9001702_bg2", Com_9001702_bg2)
function Com_9001702_bg2:onInit()
end
function Com_9001702_bg2:onShow()
	self.fields.Usm_1:setVisible(false)
end
function Com_9001702_bg2:playFlipAnimation(grade, isGold)
	self.fields.icon:setURL(string.format("twist_egg_grade%d.png", grade))
	self.transitions.t0:play(1, 0, handler(self, self.onComplete))
	if isGold then
		self.fields.Usm_1:play(false)
	end
end
function Com_9001702_bg2:onComplete()
	if self.completeCallback then
		self.completeCallback()
	end
end
function Com_9001702_bg2:setCompleteCallback(callback)
	self.completeCallback = callback
end
return Com_9001702_bg2
