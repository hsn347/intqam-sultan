local baseComponent = require("fgui.base.baseComponent")
local Com_congratulationsBase = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Com_congratulationsBase", Com_congratulationsBase)
function Com_congratulationsBase:onInit()
	self.fields.Load_title:setVisible(false)
	self.fields.Usm_2:setBlendMode(fgui.BlendMode.Normal)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "gongxihdwz_ay.usm" or "gongxihdwz_en.usm")
	self.fields.Text_Tip:setString(i18n("birthday_text_04"))
end
function Com_congratulationsBase:onShow()
end
function Com_congratulationsBase:initBaseData(data)
	if data.tips then
		self.fields.Text_Tip:setString(data.tips)
	end
	if data.scrollH then
		local posy = self:getHeight() / 2 - self.fields.Group_title:getHeight() - 20 - (data.scrollH - 103) / 2
		self.fields.Group_title:setPositionY(posy)
	end
end
return Com_congratulationsBase
