local baseComponent = require("fgui.base.baseComponent")
local ComLevelItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/ComLevelItem", ComLevelItem)
function ComLevelItem:onInit()
	self:addClickListener(handler(self, self.onClickItem))
	self.controllers.ctrlSelect:setSelectedIndex(0)
end
function ComLevelItem:onShow()
end
function ComLevelItem:initData(data, isUnlock, prevLevelID, isSelect)
	self.data = data
	self.levelID = data.levelID or data.index or 0
	self.isUnlock = isUnlock
	self.prevLevelID = prevLevelID or math.max(self.levelID - 1, 0)
	_ENV = nil
	;(nil).num = self.levelID
	self.fields.txtName:setString(i18n("memory_flip_text_05", nil))
	self.controllers.ctrlState:setSelectedIndex(self.isUnlock and 1 or 0)
	self.controllers.ctrlSelect:setSelectedIndex(isSelect and 1 or 0)
end
function ComLevelItem:onClickItem()
	SoraDPlaySound()
	if not self.isUnlock then
		_ENV = nil
		;(nil).num = self.prevLevelID
		SoraDShowMsgTip(i18n("memory_flip_text_04", nil))
		return
	end
	_ENV = i18n("memory_flip_text_04", nil)
	i18n("memory_flip_text_04", nil).levelID = self.levelID
	uiManager:show("Activity_9001738_Challenge", i18n("memory_flip_text_04", nil))
end
return ComLevelItem
