local baseComponent = require("fgui.base.baseComponent")
local Com_donateSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001737/Com_donateSingle", Com_donateSingle)
function Com_donateSingle:onInit()
	self:fixChildrenPos()
end
function Com_donateSingle:onShow()
end
function Com_donateSingle:initData(data, rank, isOwnRank)
	_ENV = nil
	;(nil).rank = rank
	;(nil).isOwnRank = isOwnRank
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Text_name:setString(textParser.formatPlayerName(data.allianceAbbr, data.playerName, data.kid))
	self.fields.Text_score:setString(string.formatnumberthousands(data.point))
end
return Com_donateSingle
