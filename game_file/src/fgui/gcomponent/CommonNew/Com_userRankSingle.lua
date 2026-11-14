local textParser = include("textParser")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_userRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_userRankSingle", Com_userRankSingle)
fgui.register_extension("ui://CommonNew/Com_userRankSingleNew", Com_userRankSingle)
fgui.register_extension("ui://IceGragonCastle/Com_userRankSingle", Com_userRankSingle)
fgui.register_extension("ui://SunnyLane/Com_rankSingle", Com_userRankSingle)
fgui.register_extension("ui://StarLampCeremony/Com_userRankSingle", Com_userRankSingle)
fgui.register_extension("ui://BeastCanyon/Com_RankSingle", Com_userRankSingle)
fgui.register_extension("ui://Intetior/Com_RankSingle", Com_userRankSingle)
fgui.register_extension("ui://Activity_9001157/Com_rankSingle", Com_userRankSingle)
fgui.register_extension("ui://Activity_9001573/Com_rankSingle", Com_userRankSingle)
function Com_userRankSingle:onInit()
	if self.fields.Load_bg then
		self.fields.Load_bg:fix()
	end
	self:fixChildrenPos()
end
function Com_userRankSingle:show()
end
function Com_userRankSingle:initData(data, otheData)
	dump(data, "data")
	local isSelf = data.uid == lordInfoCtrl:getLordInfo().base.uid
	local index = 0
	if not otheData then
		otheData, _ENV = lordInfoCtrl, lordInfoCtrl
	end
	local rank = data.rank or otheData.index or 0
	if rank <= RANK_TOP_SPECIAL then
		index = rank
	elseif isSelf then
		index = 4
	end
	self.controllers.c1:setSelectedIndex(index)
	if rank <= 0 then
		self.fields.Text_rank:setString(i18n("common_text_827"))
	else
		self.fields.Text_rank:setString(rank)
	end
	if self.fields.ranknum_bg then
		self.fields.ranknum_bg:setVisible(3 < rank)
	end
	local point = data.num or data.ranking or data.score
	self.fields.Text_score:setString(string.formatnumberthousands(point))
	local nickName = data.name or data.nickName or data.nickname
	local abbr = data.allianceAbb or data.allianceName or data.abbr or data.allianceAbbr
	self.fields.Text_name:setString(textParser.formatPlayerName(abbr, nickName, otheData.kid))
	self.fields.Com_head:setHeadSprite(data.headid or data.iconID or data.imageId, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	if otheData and otheData.bootom ~= nil then
		self.controllers.c2:setSelectedIndex(otheData.bootom)
	end
end
return Com_userRankSingle
