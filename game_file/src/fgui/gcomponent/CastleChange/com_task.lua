local dressCtrl = SoraDGetCtrl("dressCtrl")
local baseComponent = require("fgui.base.baseComponent")
local com_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/com_task", com_task)
function com_task:onInit()
	self.fields.Button_Get:setString(i18n("common_text_1146"))
	self.fields.Button_Get:addClickListener(handler(self, self.btnGetClick))
	self.fields.Text_unReach:setString(i18n("common_text_2139"))
	self.fields.Text_Got:setString(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function com_task:onShow()
end
function com_task:initData(data)
	self.data = data
	_ENV = nil
	;(nil).num = self.data.skin_quantity
	self.fields.Text_des:setString(i18n("skin_text_22", nil))
	self.fields.item:initData(self.data.stage_reward[1], self.data.stage_reward[2])
	if self.data.status == gBtnTargetStatusDef.GOT then
		self.controllers.c1:setSelectedIndex(2)
	elseif self.data.status == gBtnTargetStatusDef.GET then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function com_task:btnGetClick()
	SoraDPlaySound()
	dressCtrl:illustrateReceive(self.data.stage)
end
return com_task
