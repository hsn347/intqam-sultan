local baseComponent = require("fgui.base.baseComponent")
local btn_chooes = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CastleChange/btn_chooes", btn_chooes)
function btn_chooes:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
	self:fixChildrenPos()
end
function btn_chooes:onShow()
end
function btn_chooes:setGroupId(groupId)
	self.groupId = groupId
end
function btn_chooes:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_DRESS_GROUP_SELECT"
	;(nil).groupId = self.groupId
	SoraDSendMessage(nil)
end
return btn_chooes
