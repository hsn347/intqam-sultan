local baseComponent = require("fgui.base.baseComponent")
local Com_lordName = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_lordName", Com_lordName)
function Com_lordName:onInit()
	self.fields.Button_copy:addClickListener(handler(self, self.copyClick))
	self:addClickListener(handler(self, self.renameClick))
end
function Com_lordName:onShow()
end
function Com_lordName:initData(tablePlayerInfo, isSelfView)
	self.tablePlayerInfo = tablePlayerInfo
	self.isSelfView = isSelfView
	self.fields.title:setString(self.tablePlayerInfo.base.nickName)
	self.controllers.c1:setSelectedIndex(self.isSelfView and 0 or 1)
end
function Com_lordName:copyClick()
	SoraDPlaySound()
	local nickName = self.tablePlayerInfo.base.nickName
	local allianceAbbr = self.tablePlayerInfo.abbr
	local name = nickName
	if string.utf8len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = nickName
		name = i18n("common_text_186", nil)
	end
	SoraDCopyText(name)
	SoraDShowMsgTip(i18n("common_text_1062"))
end
function Com_lordName:renameClick()
	if self.isSelfView then
		SoraDPlaySound()
		uiManager:show("lordRename")
	end
end
return Com_lordName
