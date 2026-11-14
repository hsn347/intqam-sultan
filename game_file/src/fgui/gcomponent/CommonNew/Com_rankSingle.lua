local textParser = include("textParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, otheData)
	if not otheData then
		otheData, textParser = nil, nil
	end
	local rank = data.rank or otheData.index or 0
	textParser = nil
	;(nil).rank = rank
	;(nil).uid = data.uid
	;(nil).isOwnRank = data.isOwnRank
	;(nil).rankStr = otheData.rankStr
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_head:setHeadSprite(data.iconID or data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	local kid = data.kid or otheData.kid
	local nameStr = textParser.formatPlayerName(data.abbr or data.allianceAbbr, data.name or data.nickName, kid)
	self.fields.Text_name:setString(nameStr)
	self.fields.Text_score:setString(string.formatnumberthousands(data.score or 0))
end
return Com_rankSingle
