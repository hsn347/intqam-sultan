local baseComponent = require("fgui.base.baseComponent")
local Com_warRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_warRankSingle", Com_warRankSingle)
function Com_warRankSingle:onInit()
	self:fixChildrenPos()
	self.fields.Load_bg:fix()
end
function Com_warRankSingle:onShow()
end
function Com_warRankSingle:initData(data, rank, redKid)
	_ENV = nil
	;(nil).rank = rank
	;(nil).isSelf = data.uid == SoraDGetPlayerID()
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	local color = redKid <= data.kid and cc.c3b(255, 115, 115) or cc.c3b(115, 155, 214)
	self.fields.Text_name:setString(textParser.formatPlayerName(data.abbr, data.nickName, data.kid))
	self.fields.Text_name:setColor(color)
	_ENV = textParser.formatPlayerName(data.abbr, data.nickName, data.kid)
	textParser.formatPlayerName(data.abbr, data.nickName, data.kid).power = string.formatnumberthousands(data.power)
	self.fields.Text_power:setString(i18n("common_text_128", textParser.formatPlayerName(data.abbr, data.nickName, data.kid)))
	self.fields.Text_power:setColor(color)
	self.fields.Text_score:setString(data.score)
end
return Com_warRankSingle
