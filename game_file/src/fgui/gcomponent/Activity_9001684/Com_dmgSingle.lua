local baseComponent = require("fgui.base.baseComponent")
local Com_dmgSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001684/Com_dmgSingle", Com_dmgSingle)
function Com_dmgSingle:onInit()
	self.fields.Btn_detail:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_dmgSingle:onShow()
end
function Com_dmgSingle:initData(cfg, index, cfgCount)
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.Text_des:setString(cfg.des)
	self.fields.Text_num:setString(cfg.num)
	self.fields.Btn_detail:setVisible(index == cfgCount)
	self.fields.Text_des:setColor(index == cfgCount and cc.c3b(255, 223, 45) or cc.c3b(240, 230, 210))
end
function Com_dmgSingle:btnClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001684_Factor")
end
return Com_dmgSingle
