local baseComponent = require("fgui.base.baseComponent")
local Button_edit = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceMemberView/Button_edit", Button_edit)
function Button_edit:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Button_edit:onShow()
end
function Button_edit:initData(key, rank, data, isEdit)
	self.key = key
	self.rank = rank
	self.data = data
	self.isEdit = isEdit
	if self.data then
		self.controllers.c1:setSelectedIndex(self.data.status and 1 or 0)
		self.controllers.c2:setSelectedIndex(self.isEdit and self.data.set and 2 or 0)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Button_edit:btnClick()
	if self.isEdit and self.data and self.data.set then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_ALLIANCE_UI_PERMISSION_SET"
		;(nil).key = self.key
		;(nil).rank = self.rank
		;(nil).status = not self.data.status
		SoraDSendMessage(nil)
	end
end
return Button_edit
