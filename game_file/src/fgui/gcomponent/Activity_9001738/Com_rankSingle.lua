local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_rankSingle", Com_rankSingle)
local getRank = function(data, defaultRank)
	local rank = data.rank or data.rankNo or data.ranking or data.no or data.index or defaultRank or 0
	if type(rank) == "table" then
		rank = rank.rank or rank[1] or 0
	end
	return tonumber(rank) or 0
end
local getLevel = function(data)
	local level = data.levelID or data.levelId or data.maxLevelId or data.maxLevleId or data.difficulty or data.lv or data.score
	return tonumber(level) or 0
end
local formatDifficulty = function(level)
	level = tonumber(level) or 0
	if level <= 0 then
		return ""
	end
	_ENV = nil
	;(nil).level = level
	return i18n("common_text_1229", nil)
end
local formatCostTime = function(value)
	if value == nil or value == "" then
		return ""
	end
	local time = tonumber(value)
	if not time then
		return ""
	end
	return string.format("%.2f", math.max(time, 0) / 100)
end
local formatPlayerName = function(data)
	local name = data.name or data.nickName or data.playerName or data.lordName or ""
	local abbr = data.allianceAbbr or data.abbr or data.allianceName or data.leagueAbbr
	if abbr ~= nil then
		abbr = tostring(abbr)
	end
	return textParser.formatPlayerName(abbr, name, data.kid)
end
function Com_rankSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, rank, isOwnRank)
	if not data then
		data, getRank = nil, nil
	end
	local realRank = getRank(data, rank)
	local isOwn = isOwnRank or data.isOwnRank
	local rankStr
	if realRank <= 0 then
		rankStr = i18n("common_text_827")
	end
	getRank = nil
	;(nil).rank = realRank
	;(nil).rankStr = rankStr
	;(nil).uid = data.uid
	;(nil).isOwnRank = isOwn
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_head:setHeadSprite(data.headid or data.iconID or data.headId or data.imageId, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	if data.kid then
		self.fields.Com_head:setKid(data.kid)
	end
	self.fields.Text_name:setString(formatPlayerName(data))
	local levelText = formatDifficulty(getLevel(data))
	local timeText = formatCostTime(data.costTime)
	if isOwn and realRank <= 0 then
		levelText = ""
		timeText = ""
	end
	self.fields.Text_score:setString(levelText)
	self.fields.Text_time:setString(timeText)
end
return Com_rankSingle
