local djRead = include("djRead")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_live = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_live", Com_live)
function Com_live:onInit()
	self.fields.Text_title:setString(i18n("Anchor_text_87"))
	self.fields.Text_none:setString(i18n("Anchor_text_181"))
	self.fields.Text_tip:setString(i18n("Anchor_text_84"))
	self.fields.Text_isWear:setString(i18n("Anchor_text_85"))
	self.fields.Check_tick:addClickListener(handler(self, self.btnClick))
end
function Com_live:onShow()
end
function Com_live:initData(data)
	self.selfInfo = data
	local liveLv = djRead.getLifeLvByExp(self.selfInfo.exp)
	self.controllers.c1:setSelectedIndex(0 < liveLv and 1 or 0)
	if 0 < liveLv then
		local cfg = djRead.getLifeLvCfg(liveLv)
		self.fields.Lab_honor:setTitle(i18n(cfg.nameLife))
		self.fields.Lab_honor:setIcon(cfg.picLife)
		self.fields.Check_tick:setSelected(self.selfInfo.showTitle or false)
	end
end
function Com_live:btnClick()
	local showTitle = self.fields.Check_tick:isSelected()
	djCtrl:reqSwitchTitle(showTitle)
end
return Com_live
