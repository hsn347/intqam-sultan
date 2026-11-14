local baseComponent = require("fgui.base.baseComponent")
local Com_relation = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/Com_relation", Com_relation)
function Com_relation:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_relation:onShow()
end
function Com_relation:initData(data, isHelp, rType)
	self.tag = data.tag
	self.rType = rType
	self.fields.Check_tick:setVisible(not isHelp)
	self.fields.Text_relation:setString(data.name)
	self.fields.Image_color:setColor(data.color)
	if not isHelp then
		if self.rType then
			self.fields.Check_tick:setSelected(self.tag == self.rType)
		else
			self.fields.Check_tick:setSelected(false)
		end
	end
end
function Com_relation:btnClick()
	SoraDPlaySound()
	if self.rType and self.rType == self.tag then
		self.fields.Check_tick:setSelected(true)
	else
		_ENV = self.fields.Check_tick
		self.fields.Check_tick.msg = "MESSAGE_ALLIANCE_UI_RELATION_CHECK_SELECT"
		self.fields.Check_tick.tag = self.tag
		SoraDSendMessage(self.fields.Check_tick)
	end
end
return Com_relation
