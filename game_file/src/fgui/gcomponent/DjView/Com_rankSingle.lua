local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_rankSingle", Com_rankSingle)
_ENV = fgui.register_extension
fgui.register_extension.ONE_KINGDOM_WEEK = 1
fgui.register_extension.ONE_KINGDOM_MONTH = 2
fgui.register_extension.ONE_KINGDOM_TOTAL = 3
fgui.register_extension.ALL_KINGDOM_WEEK = 4
fgui.register_extension.ALL_KINGDOM_MONTH = 5
fgui.register_extension.ALL_KINGDOM_TOTAL = 6
fgui.register_extension.DJ_WEEK = 7
fgui.register_extension.DJ_MONTH = 8
local fgui.register_extension.DJ_TOTAL, ChatAnchorRankType = 9, fgui.register_extension
function Com_rankSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, otheData)
	if not otheData then
		otheData, _ENV = nil, nil
	end
	self:setVisible(next(data) ~= nil)
	if next(data) == nil then
		return
	end
	local rank = data.rank or otheData.index or 0
	_ENV = data
	data.rank = rank
	data.uid = data.uid
	data.isOwnRank = data.isOwnRank or otheData.isOwnRank
	self.fields.Com_rankBase:initRankBaseData(data)
	self.fields.Com_head:setHeadSprite(data.iconID or data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	local alliance = ""
	if data.allianceName then
		_ENV = data.avatar
		data.avatar.conten = data.allianceName
		alliance = i18n("common_text_925", data.avatar)
	else
		_ENV = data.avatar
		data.avatar.conten = i18n("common_text_826")
		alliance = i18n("common_text_925", data.avatar)
	end
	if otheData.rankType <= ChatAnchorRankType.ONE_KINGDOM_TOTAL then
		self.fields.Text_name:setString(data.nickName)
		self.fields.Text_alliance:setString(alliance)
	elseif otheData.rankType <= ChatAnchorRankType.ALL_KINGDOM_TOTAL then
		local nameStr = textParser.formatPlayerName(nil, data.nickName, data.kid)
		self.fields.Text_name:setString(nameStr)
		self.fields.Text_alliance:setString(alliance)
	else
		local nameStr = textParser.formatPlayerName(data.abbr or data.allianceAbbr, data.nickName, data.kid)
		self.fields.Text_name:setString(nameStr)
		self.fields.Text_alliance:setString(data.anchor_sign or "")
	end
	self.fields.Text_score:setString(string.formatnumberthousands(data.score or 0))
end
return Com_rankSingle
