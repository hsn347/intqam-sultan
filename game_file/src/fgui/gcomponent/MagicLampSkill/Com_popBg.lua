local baseComponent = require("fgui.base.baseComponent")
local Com_popBg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_popBg", Com_popBg)
function Com_popBg:onInit()
	self.fields.Usm_1:setPrepareCallback(function()
		print("==self.fields.Usm_1:setPrepareCallback==")
		self.fields.Usm_1:getCriSprite():start()
		self.fields.Image_bg:setVisible(false)
	end)
	self.fields.Text_close:setString(i18n("mail_2_text_12"))
end
function Com_popBg:onShow()
end
return Com_popBg
