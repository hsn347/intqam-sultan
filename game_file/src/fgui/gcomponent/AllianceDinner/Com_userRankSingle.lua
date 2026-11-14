local baseComponent = require("fgui.base.baseComponent")
local Com_userRankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceDinner/Com_userRankSingle", Com_userRankSingle)
fgui.register_extension("ui://AllianceDinner/Com_userRankBottom", Com_userRankSingle)
local textParser = include("textParser")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
function Com_userRankSingle:onInit()
	self:fixChildrenPos()
	if self.fields.list then
		self.fields.list:setItemRenderer(handler(self, self.onAwardItemRederer))
	end
end
function Com_userRankSingle:show()
end
function Com_userRankSingle:initData(data, otheData)
	local isSelf = data.uid == lordInfoCtrl:getLordInfo().base.uid
	local index = 0
	if not otheData then
		otheData, lordInfoCtrl = lordInfoCtrl, lordInfoCtrl
	end
	local isAlianceRank = otheData.rankType == nil or otheData.rankType == gAllianceDinnerRankType.ALLIANCE
	self.controllers.c3:setSelectedIndex(isAlianceRank and 1 or 0)
	local rank = data.rank or otheData.index or 0
	if rank <= RANK_TOP_SPECIAL then
		index = rank
	elseif isSelf then
		index = 4
	end
	self.controllers.c1:setSelectedIndex(index)
	self.fields.Text_score:setString(string.formatnumberthousands(data.num or data.ranking or data.score or data.point))
	if isAlianceRank then
		if rank <= 0 then
			self.fields.Text_rank1:setString(i18n("common_text_827"))
		else
			self.fields.Text_rank1:setString(rank)
		end
		self.fields.Text_name:setString(textParser.formatAllianceName(data.allianceAbbr, data.allianceName, otheData.kid))
	else
		if rank <= 0 then
			self.fields.Text_rank:setString(i18n("common_text_827"))
		else
			self.fields.Text_rank:setString(rank)
		end
		self.fields.Text_name:setString(textParser.formatPlayerName(data.allianceAbb or data.allianceName or data.allianceAbbr, data.name or data.nickName, otheData.kid))
		self.fields.Com_head:setHeadSprite(data.headid or data.iconID, data.avatar)
		self.fields.Com_head:setPlayerID(data.uid)
	end
	if otheData and otheData.bootom ~= nil then
		self.controllers.c2:setSelectedIndex(otheData.bootom)
	end
	if self.fields.list and otheData.rewards then
		self.rewards = otheData.rewards
		self.fields.list:setNumItems(#otheData.rewards)
	end
end
function Com_userRankSingle:onAwardItemRederer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
return Com_userRankSingle
