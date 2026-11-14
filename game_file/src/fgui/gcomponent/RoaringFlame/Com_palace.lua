local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_palace = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_palace", Com_palace)
function Com_palace:onInit()
end
function Com_palace:onShow()
end
function Com_palace:initData(data)
	self.controllers.c1:setSelectedIndex(data and 1 or 0)
	if data then
		local cfg = roaringFlameWarRead.getCampCfg(data.camp)
		self.fields.Text_name:setString(i18n(cfg.name))
		self.fields.Text_name:setColor(SoraDHtmlColor2RGB(cfg.color or "#FAFAFA"))
		roaringFlameWarRead = SoraDHtmlColor2RGB(cfg.color or "#FAFAFA")
		SoraDHtmlColor2RGB(cfg.color or "#FAFAFA").kid = data.fromKid
		SoraDHtmlColor2RGB(cfg.color or "#FAFAFA").name = data.kingdomName
		self.fields.Text_kingdom:setString(i18n("#%{kid}%{name}", SoraDHtmlColor2RGB(cfg.color or "#FAFAFA")))
	end
end
return Com_palace
