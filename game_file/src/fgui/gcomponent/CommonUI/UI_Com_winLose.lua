local baseComponent = require("fgui.base.baseComponent")
local UI_Com_winLose = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_winLose", UI_Com_winLose)
function UI_Com_winLose:onInit()
end
function UI_Com_winLose:onShow()
end
function UI_Com_winLose:initData(isWin)
	self.controllers.c1:setSelectedIndex(isWin and 0 or 1)
	if isWin then
		SoraDPlaySound("elimiateGame", 5)
		self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
		self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	else
		SoraDPlaySound("huntSound", "hunt_lost")
		self.fields.lose_sp:setURL(SoraDFIsRA() and "FONT_shibai_ar.png" or "FONT_shibai.png")
	end
	local scaleY = math.max(1, display.height / 1136)
	local scaleX = math.max(1, 1136 / display.height)
	local scale = math.max(scaleX, scaleY)
	self.fields.Usm_1:setScale(scale)
	self.fields.Usm_2:setScale(scale)
	self.fields.Usm_3:setScale(scale)
	self.fields.Usm_lost:setScale(scale)
end
return UI_Com_winLose
