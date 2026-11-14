local baseComponent = require("fgui.base.baseComponent")
local Com_difficulty = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SuchaFeast/Com_difficulty", Com_difficulty)
function Com_difficulty:onInit()
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_difficulty:onShow()
end
function Com_difficulty:setStatus(state)
	self.controllers.c2:setSelectedIndex(IsArClient and 0 or 1)
	self.controllers.c1:setSelectedIndex(tonumber(state))
end
function Com_difficulty:onBtnClick()
	SoraDPlaySound()
	uiManager:show("SignFinalView")
end
return Com_difficulty
