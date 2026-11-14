local textParser = include("textParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_backerSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001609/Com_backerSingle", Com_backerSingle)
function Com_backerSingle:onInit()
	self:fixChildrenPos()
end
function Com_backerSingle:onShow()
end
function Com_backerSingle:initData(data)
	self.data = data
	self.fields.Com_head:setHeadSprite(self.data.headid, self.data.avatar)
	self.fields.Com_head:setKid(self.data.kid)
	self.fields.Com_head:setPlayerID(self.data.uid)
	self.fields.Text_name:setString(textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName))
	textParser = textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName)
	textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName).kid = self.data.kid
	self.fields.Text_kingdom:setString(i18n("common_text_342", textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName)))
	textParser = i18n("common_text_342", textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName))
	i18n("common_text_342", textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName)).point = self.data.dailyPoint or 0
	self.fields.Text_actPoint:setString(i18n("recallfriends_text_19", i18n("common_text_342", textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName))))
	textParser = i18n("recallfriends_text_19", i18n("common_text_342", textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName)))
	i18n("recallfriends_text_19", i18n("common_text_342", textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName))).num = self.data.recharge or 0
	self.fields.Text_cumu:setString(i18n("recallfriends_text_20", i18n("recallfriends_text_19", i18n("common_text_342", textParser.formatPlayerName(self.data.allianceAbbr, self.data.nickName)))))
end
return Com_backerSingle
