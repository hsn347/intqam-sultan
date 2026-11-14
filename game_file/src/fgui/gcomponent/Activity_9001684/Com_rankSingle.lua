local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001684/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, rank)
	_ENV = nil
	;(nil).rank = data.rank or rank
	;(nil).uid = data.uid
	;(nil).isOwnRank = data.isOwnRank
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	self.fields.Text_name:setString(textParser.formatAllianceName(data.allianceAbbr, data.name, data.kid))
	self.fields.Text_score:setString(string.formatnumberthousands(data.score))
end
return Com_rankSingle
