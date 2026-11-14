local textParser = include("textParser")
local baseComponent = require("fgui.base.baseComponent")
local NebulaKingHistoryItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaKing/NebulaKingHistoryItem", NebulaKingHistoryItem)
function NebulaKingHistoryItem:onInit()
	self:fixChildrenPos()
end
function NebulaKingHistoryItem:onShow()
end
function NebulaKingHistoryItem:initData(data)
	local index = 0
	local rank = data.rank
	if not rank then
		return
	end
	if rank <= RANK_TOP_SPECIAL then
		index = rank
	end
	self.controllers.c1:setSelectedIndex(index)
	if rank <= 0 then
		self.fields.Text_rank:setString(i18n("common_text_827"))
	else
		self.fields.Text_rank:setString(rank)
	end
	local abbr = data.allianceAbb or data.allianceAbbr
	local nickName = data.name or data.nickName
	self.fields.Text_name:setString(textParser.formatPlayerName(abbr, nickName))
end
return NebulaKingHistoryItem
