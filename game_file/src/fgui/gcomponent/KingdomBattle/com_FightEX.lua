local baseComponent = require("fgui.base.baseComponent")
local com_FightEX = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/com_FightEX", com_FightEX)
function com_FightEX:onInit()
	self.fields.mv:setAllFrameName("dh_wangguozfz_%02d.png", 1)
	self.fields.Text_blue:setAlign(2)
	self.fields.Text_blueInt:setAlign(2)
	self.fields.Text_red:setAlign(0)
	self.fields.Text_redInt:setAlign(0)
end
function com_FightEX:onShow()
end
function com_FightEX:initData(data)
	self.fields.Text_blue:setString(textParser.formatPlayerName(nil, data.blue.kname, data.blue.kid))
	_ENV = textParser.formatPlayerName(nil, data.blue.kname, data.blue.kid)
	textParser.formatPlayerName(nil, data.blue.kname, data.blue.kid).num = data.blue.kingdomScore
	self.fields.Text_blueInt:setString(i18n("common_text_2556", textParser.formatPlayerName(nil, data.blue.kname, data.blue.kid)))
	self.fields.Text_red:setString(textParser.formatPlayerName(nil, data.red.kname, data.red.kid))
	_ENV = textParser.formatPlayerName(nil, data.red.kname, data.red.kid)
	textParser.formatPlayerName(nil, data.red.kname, data.red.kid).num = data.red.kingdomScore
	self.fields.Text_redInt:setString(i18n("common_text_2556", textParser.formatPlayerName(nil, data.red.kname, data.red.kid)))
end
return com_FightEX
