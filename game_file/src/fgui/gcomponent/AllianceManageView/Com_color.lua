local baseComponent = require("fgui.base.baseComponent")
local Com_color = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceManageView/Com_color", Com_color)
function Com_color:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Com_color:onShow()
end
function Com_color:initData(data, curIndex, territoryColorId)
	self.data = data
	self.curIndex = curIndex
	self.territoryColorId = territoryColorId
	self.fields.Panel_color:setColor(cc.c3b(self.data.color[1] * 255, self.data.color[2] * 255, self.data.color[3] * 255))
	self.fields.Sprite_select:setVisible(self.data.index == self.curIndex)
	self.fields.Sprite_cur:setVisible(self.data.index == self.territoryColorId)
end
function Com_color:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_UI_MANAGER_SETTING_COLOR_SELECT"
	;(nil).index = self.data.index
	SoraDSendMessage(nil)
end
return Com_color
