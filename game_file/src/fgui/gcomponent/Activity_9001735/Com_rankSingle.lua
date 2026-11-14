local activity_9001735_Read = include("activity_9001735_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001735/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, isOwnRank)
	activity_9001735_Read = nil
	;(nil).rank = data.rank
	;(nil).rankMax = activity_9001735_Read.getMaxRankNum()
	;(nil).isOwnRank = isOwnRank
	self.fields.Com_rankBase:initRankBaseData(nil)
	if data.uid == SoraDGetPlayerID() then
		self.fields.Com_head:setSelfHead()
	else
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.Com_head:setPlayerID(data.uid)
		self.fields.Com_head:setKid(data.kid)
	end
	self.fields.Text_name:setString(textParser.formatPlayerName(data.allianceAbbr, data.name, data.kid))
	self.fields.Text_score:setString(string.formatnumberthousands(data.score))
end
return Com_rankSingle
