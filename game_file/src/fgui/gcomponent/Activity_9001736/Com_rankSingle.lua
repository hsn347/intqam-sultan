local activityCommonRankCtrl = SoraDGetCtrl("activityCommonRankCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_rankSingle", Com_rankSingle)
function Com_rankSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankSingle:onShow()
end
function Com_rankSingle:initData(data, otherData)
	if not otherData then
		otherData, activityCommonRankCtrl = nil, nil
	end
	local rankMax = activityCommonRankCtrl:getRankMax(otherData.activityID)
	activityCommonRankCtrl = nil
	;(nil).rank = data.rank
	;(nil).rankMax = rankMax
	;(nil).isOwnRank = otherData.isOwnRank
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	local nameStr = textParser.formatPlayerName(data.allianceAbbr, data.name, data.kid)
	self.fields.Text_name:setString(nameStr)
	local powerStr = string.formatnumberthousands(data.power)
	self.fields.Text_power:setString(powerStr)
	local scoreStr = string.formatnumberthousands(data.score)
	self.fields.Text_score:setString(scoreStr)
end
return Com_rankSingle
