local baseComponent = require("fgui.base.baseComponent")
local Com_reViewBuff = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_reViewBuff", Com_reViewBuff)
function Com_reViewBuff:onInit()
	self:fixChildrenPos()
	self.fields.n2:setScaleX(SoraDFIsRA() and 0.55 or -0.55)
	self.fields.MV_fly:setAllFrameName("dh_baoshi_add_%.2d.png", 1)
	self.fields.MV_fly:setVisible(false)
	self.fields.MV_fly:setScaleX(SoraDFIsRA() and -2 or 2)
end
function Com_reViewBuff:onShow()
end
function Com_reViewBuff:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_STRENGTHEN_EFFECT", handler(self, self.playCost))
end
function Com_reViewBuff:playCost(target, data)
	self.fields.MV_fly:setVisible(true)
	self.fields.MV_fly:setPlaySettings(0, -1, 1)
end
function Com_reViewBuff:initData(data)
	self.fields.Text_cur:setString(data.cur)
	if data.pre then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_next:setString(data.pre)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Com_reViewBuff
