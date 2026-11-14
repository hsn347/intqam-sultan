local outStandingsRead = include("outStandingsRead")
local outStandingsCtrl = SoraDGetCtrl("outStandingsCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_MyRank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001157/Com_MyRank", Com_MyRank)
function Com_MyRank:onInit()
	self:fixChildrenPos()
	self.fields.Button_icon:addClickListener(handler(self, self.buttonRankingRewardClickCallBack))
end
function Com_MyRank:onShow()
end
function Com_MyRank:updateView()
	local myRankInfo = outStandingsCtrl:getMyRankingInfo()
	local name = myRankInfo.nickName
	if myRankInfo.allianceAbbr then
		outStandingsCtrl = nil
		;(nil).abbr = _q(myRankInfo.allianceAbbr)
		;(nil).name = myRankInfo.nickName
		name = i18n("common_text_186", nil)
	end
	self.fields.Text_name:setString(name)
	self.fields.Com_head:setHeadSprite(myRankInfo.imageId, myRankInfo.avatar)
	if myRankInfo.rank == 0 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_rank:setString(i18n("common_text_827"))
	elseif myRankInfo.rank <= RANK_TOP_SPECIAL then
		self.controllers.c1:setSelectedIndex(myRankInfo.rank)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_rank:setString(myRankInfo.rank)
	end
	if myRankInfo.score == 0 then
		self.fields.Text_score:setVisible(false)
	else
		self.fields.Text_score:setVisible(true)
		self.fields.Text_score:setString(string.formatnumberthousands(myRankInfo.score))
	end
end
function Com_MyRank:buttonRankingRewardClickCallBack()
	SoraDPlaySound()
	local rankType = outStandingsCtrl:getRankingType()
	local rankInfo = outStandingsRead.getRankingInfo(rankType)
	local _ENV, rewardList = rankType, rankType
	for i, v in ipairs(rankInfo) do
		_ENV = nil
		;(nil).rank = v
		;(nil).reward = outStandingsRead.getRankingRewardByType(i, rankType)
		table.insert(rewardList, nil)
		if i == #rankInfo then
			lastRank = v[2]
		end
	end
	_ENV = nil
	;(nil).awardList = rewardList
	_ENV = rewardList
	rewardList.num = lastRank
	;(nil).tipStr = i18n("rides_text_14", rewardList)
	uiManager:show("commonRankAwardView", nil)
end
return Com_MyRank
