local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001676/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, rank, isSelf)
	_ENV = nil
	;(nil).rank = data.rank or rank
	;(nil).rankMax = 300
	;(nil).isOwnRank = isSelf
	self.fields.Com_rankBase:initRankBaseData(nil)
	if data.uid == SoraDGetPlayerID() then
		self.fields.Com_head:setSelfHead()
	else
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.Com_head:setPlayerID(data.uid)
		self.fields.Com_head:setKid(data.kid)
	end
	self.fields.Text_name:setString(textParser.formatPlayerName(nil, data.name, data.kid))
	self.fields.Text_score:setString(SoraDConvertSecondToString(data.costTime))
	local alliance = ""
	if data.allianceAbbr then
		_ENV = SoraDConvertSecondToString(data.costTime)
		SoraDConvertSecondToString(data.costTime).conten = data.allianceAbbr
		alliance = i18n("common_text_925", SoraDConvertSecondToString(data.costTime))
	else
		_ENV = SoraDConvertSecondToString(data.costTime)
		SoraDConvertSecondToString(data.costTime).conten = i18n("common_text_826")
		alliance = i18n("common_text_925", SoraDConvertSecondToString(data.costTime))
	end
	self.fields.Text_alliance:setString(alliance)
	if isSelf and (data.rank or rank) == 0 then
		self.fields.Com_rankBase.fields.Text_rank:setString(i18n("common_text_827"))
	end
end
return Com_rankSingle
