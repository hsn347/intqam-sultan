local baseComponent = require("fgui.base.baseComponent")
local UI_Com_WinOrLose = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_WinOrLose", UI_Com_WinOrLose)
function UI_Com_WinOrLose:onInit()
end
function UI_Com_WinOrLose:onShow()
	local scale = self:getParent():getParent():getScale()
	if scale < 1 then
		self.fields.Usm_1:setScale(1 / scale)
		self.fields.Usm_2:setScale(1 / scale)
		self.fields.Usm_3:setScale(1 / scale)
	end
end
function UI_Com_WinOrLose:playWin()
	self.controllers.c1:setSelectedIndex(0)
	SoraDPlaySound("elimiateGame", 5)
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_2:clearEffect()
	self.fields.Usm_3:clearEffect()
	self.fields.Usm_1:setEffectPath("dunpai2.usm", false)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
	self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_3:setEffectPath("G_dunpai1.usm,G_xh_dunpai3.usm")
	self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
end
function UI_Com_WinOrLose:playLose()
	self.controllers.c1:setSelectedIndex(1)
	SoraDPlaySound("huntSound", "hunt_lost")
	self.fields.Usm_1:clearEffect()
	self.fields.Usm_2:clearEffect()
	self.fields.Usm_3:clearEffect()
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_1:setEffectPath("sp_sszzsb_001.usm", false)
	self.fields.lose_sp:setURL(SoraDFIsRA() and "FONT_shibai_ar.png" or "FONT_shibai.png")
end
return UI_Com_WinOrLose
