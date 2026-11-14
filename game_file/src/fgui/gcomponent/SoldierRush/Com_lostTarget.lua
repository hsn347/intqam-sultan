local baseComponent = require("fgui.base.baseComponent")
local Com_lostTarget = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_lostTarget", Com_lostTarget)
function Com_lostTarget:onInit()
	self.fields.btn_go:setString(i18n("common_text_477"))
end
function Com_lostTarget:onShow()
end
function Com_lostTarget:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 0)
	self.fields.title:setString(data.des)
	self.handle = data.handle
	self.fields.btn_go:addClickListener(handler(self, self.onGoClick))
end
function Com_lostTarget:onGoClick()
	SoraDPlaySound()
	if self.handle then
		self.handle()
	end
end
return Com_lostTarget
