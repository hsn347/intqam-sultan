local baseComponent = require("fgui.base.baseComponent")
local Com_usmThree = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DesertSecretTreasure/Com_usmThree", Com_usmThree)
function Com_usmThree:onInit()
	self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	function self.func1()
		_ENV = nil
		;(nil).msg = "MESSAGE_DESERT_TREASURE_GET"
		SoraDSendMessage(nil)
	end
	self.fields.Usm_1:setPrepareCallback(function()
		self.fields.Usm_1:getCriSprite():start()
		self = self.fields.Usm_1:getCriSprite()
		self.fields.Usm_1:getCriSprite().msg = "MESSAGE_DESERT_TREASURE_READY"
		SoraDSendMessage((self.fields.Usm_1:getCriSprite()))
	end)
	self.fields.Usm_2:setPrepareCallback(function()
		self.fields.Usm_2:getCriSprite():start()
	end)
	self.fields.Usm_3:setCompleteCallback(self.func1)
end
function Com_usmThree:initData(flag)
	if flag then
		self.fields.Usm_1:setVisible(true)
		self.fields.Usm_2:setVisible(false)
	else
		self.fields.Usm_1:setVisible(false)
		self.fields.Usm_2:setVisible(true)
	end
end
function Com_usmThree:showUsm()
	self.fields.Usm_3:play(false)
end
function Com_usmThree:onShow()
end
return Com_usmThree
