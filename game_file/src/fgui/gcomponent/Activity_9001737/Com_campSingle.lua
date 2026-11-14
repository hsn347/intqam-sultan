local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_campSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001737/Com_campSingle", Com_campSingle)
function Com_campSingle:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Com_campSingle:onShow()
end
function Com_campSingle:initData(data)
	self.data = data
	self.fields.Text_name:setString(i18n(data.campName))
	self.fields.Text_score:setString(data.rankInfo.point)
	self.fields.icon:setURL(data.campIcon)
	local enemyCamp = activity_9001737_Ctrl:getEnemyCamp()
	self.controllers.c1:setSelectedIndex(enemyCamp == data.campType and 1 or 0)
	self.fields.rank1:setVisible(data.rankInfo.rank == 1)
end
function Com_campSingle:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).campId = self.data.campType
	uiManager:show("Activity_9001737_Donate", nil)
end
return Com_campSingle
