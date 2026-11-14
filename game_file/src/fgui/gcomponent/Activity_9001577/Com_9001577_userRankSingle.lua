local textParser = include("textParser")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001577_userRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001577/Com_9001577_userRankSingle", Com_9001577_userRankSingle)
function Com_9001577_userRankSingle:onInit()
	self:fixChildrenPos()
	self.fields.n9:fix()
end
function Com_9001577_userRankSingle:onShow()
end
function Com_9001577_userRankSingle:initData(data)
	dump(data, "rankInfo")
	local rank = data.rank
	if not rank then
		return
	end
	local index = 0
	if rank == 0 then
		self.fields.Text_rank:setString(i18n("common_text_827"))
	elseif rank <= RANK_TOP_SPECIAL then
		index = rank
	else
		local maxRank = constantRead.getConstValue("NEBULAKING_UNRANK", 5)
		local rankStr = rank
		if rank == 0 or rank > maxRank then
			rankStr = maxRank .. "+"
		end
		_ENV = i18n("common_text_827")
		i18n("common_text_827").num = rankStr
		self.fields.Text_rank:setString(i18n("common_text_617", i18n("common_text_827")))
	end
	self.controllers.c1:setSelectedIndex(index)
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	local abbr = data.allianceAbbr
	local nickName = data.nickName
	self.fields.Text_name:setString(textParser.formatPlayerName(abbr, nickName, data.kid))
end
return Com_9001577_userRankSingle
