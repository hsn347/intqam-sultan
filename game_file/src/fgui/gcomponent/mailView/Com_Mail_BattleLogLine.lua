local baseComponent = require("fgui.base.baseComponent")
local Com_Mail_BattleLogLine = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_Mail_BattleLogLine", Com_Mail_BattleLogLine)
function Com_Mail_BattleLogLine:onInit()
	self.fields.text_title:setString(i18n("title_text"))
	self.fields.text_my:setString(i18n("battlelog_text_63"))
	self.fields.text_enmey:setString(i18n("battlelog_text_62"))
	self:fixChildrenPos()
end
function Com_Mail_BattleLogLine:onShow()
end
function Com_Mail_BattleLogLine:initData(title, myDesc, enemyDesc)
	self.fields.text_title:setString(title)
	self.fields.text_myDesc:setString(myDesc)
	self.fields.text_enemyDesc:setString(enemyDesc)
end
return Com_Mail_BattleLogLine
