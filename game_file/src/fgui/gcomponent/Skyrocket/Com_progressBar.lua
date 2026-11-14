local baseComponent = require("fgui.base.baseComponent")
local Com_progressBar = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://Skyrocket/Com_progressBar", Com_progressBar)
function Com_progressBar:onInit()
	self.fields.mv_bar:setAllFrameName("dh_tianpinzwjdt_%.2d.png", 0)
	self.fields.mv_bar:setVisible(false)
end
function Com_progressBar:onShow()
end
function Com_progressBar:setBarValue(val, isAct)
	self:stopAllActions()
	if isAct then
		_UPVALUE2_ = nil
		;(nil)[1] = ffa.callFunc(function()
			self:tweenValue(val, 0.5)
		end)
		;(nil)[2] = ffa.delay(0.5)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.mv_bar:setVisible(true)
			self.fields.mv_bar:setPlaySettings(0, -1, 1)
		end)
		;(nil)[4] = ffa.callFunc(function()
			self.fields.mv_bar:setVisible(true)
			self.fields.mv_bar:setPlaySettings(0, -1, 1)
		end)
		self:runAction(ffa.seq(nil))
	else
		self:setValue(val)
		self.fields.mv_bar:setVisible(false)
	end
end
return Com_progressBar
