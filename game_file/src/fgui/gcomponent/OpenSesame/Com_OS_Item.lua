local baseComponent = require("fgui.base.baseComponent")
local Com_OS_Item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://OpenSesame/Com_OS_Item", Com_OS_Item)
function Com_OS_Item:onInit()
	self.fields.show:setAllFrameName("YDTS_glowkuang_%02d.png", 1)
	self.fields.show:setBlendFunc(gl.ONE, gl.ONE)
end
function Com_OS_Item:onShow()
end
function Com_OS_Item:initData(reward, index)
	self:setVisible(false)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.2 + index * 0.1)
	;(nil)[2] = ffa.callFunc(function()
		self:setVisible(true)
		self.fields.show:setPlaySettings(0, -1, 1)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:setVisible(true)
		self.fields.show:setPlaySettings(0, -1, 1)
	end)
	self:runAction(ffa.seq(nil))
	_ENV = ffa.seq(nil)
	ffa.seq(nil).num = index + 1
	self.fields.txt_title:setString(i18n("petra_text_07", ffa.seq(nil)))
	self.fields.item:initData(reward.id, reward.count)
end
return Com_OS_Item
