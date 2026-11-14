local baseComponent = require("fgui.base.baseComponent")
local com_activitySingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001620/com_activitySingle", com_activitySingle)
function com_activitySingle:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function com_activitySingle:onShow()
end
function com_activitySingle:initData(data)
	self.data = data
	self.fields.Sprite_icon:setSpriteFrame(self.data.activity_icon)
	self.fields.Text_name:setString(i18n(self.data.activity_name))
	if #self.data.opnetime == 1 then
		self.fields.Text_date:setString("(" .. os.date("%m.%d", self.data.opnetime[1]) .. ")")
	else
		self.fields.Text_date:setString("(" .. os.date("%m.%d", self.data.opnetime[1]) .. "、" .. os.date("%m.%d", self.data.opnetime[2]) .. ")")
	end
	self.fields.new:setVisible(self.data.subscript == 1)
	self.fields.hot:setVisible(self.data.subscript == 2)
end
function com_activitySingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("Activity_9001620_pop", nil)
end
return com_activitySingle
