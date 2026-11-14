local baseComponent = require("fgui.base.baseComponent")
local Com_awardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_awardSingle", Com_awardSingle)
fgui.register_extension("ui://CommonNew/Com_rewardSingle", Com_awardSingle)
fgui.register_extension("ui://SunnyLane/Com_rewardSingle", Com_awardSingle)
fgui.register_extension("ui://Intetior/Com_priceShowSingle", Com_awardSingle)
fgui.register_extension("ui://CommonNew/Com_awardSingle2", Com_awardSingle)
fgui.register_extension("ui://CommonNew/Com_awardSingle3", Com_awardSingle)
fgui.register_extension("ui://Activity_9001061/kingsOrderRankAwardSingle", Com_awardSingle)
fgui.register_extension("ui://Activity_9001666/Com_9001666_rankAward", Com_awardSingle)
fgui.register_extension("ui://Activity_9001705/Com_9001705_rankAward", Com_awardSingle)
function Com_awardSingle:onInit()
	self:fixChildrenPos()
	if self.fields.Load_bg then
		self.fields.Load_bg:fix()
	end
	if self.fields.List_reward then
		self.fields.AwardList = self.fields.List_reward
	end
	self.fields.AwardList:setItemRenderer(handler(self, self.onItemRender))
end
function Com_awardSingle:show()
end
function Com_awardSingle:initData(data, otherdata)
	dump(data, "data")
	local rankFrom = data.rank[1]
	local rankTo = data.rank[2]
	if not rankFrom and not rankTo then
		self.fields.Text_rank:setString(i18n("common_text_312"))
	else
		local strNum = ""
		if rankFrom == rankTo then
			strNum = rankFrom
		elseif 99999999 <= rankTo then
			strNum = string.format("%d+", rankFrom)
		else
			strNum = string.format("%d-%d", rankFrom, rankTo)
		end
		if otherdata and otherdata.showKey then
			_ENV = i18n("common_text_312")
			i18n("common_text_312").num = strNum
			self.fields.Text_rank:setString(i18n("common_text_617", i18n("common_text_312")))
		else
			self.fields.Text_rank:setString(strNum)
		end
	end
	self.controllers.c1:setSelectedIndex(rankFrom == rankTo and rankFrom <= RANK_TOP_SPECIAL and rankFrom or 0)
	local awardList = data.reward or data.rewards
	self:updateAwardList(awardList)
end
function Com_awardSingle:onItemRender(index, object)
	local item = self.awardList[index + 1]
	object:initData(item.id, item.count)
end
function Com_awardSingle:initCustomData(params)
	local rankStr = params.rankStr
	if rankStr then
		self.fields.Text_rank:setString(rankStr)
	end
	local awardList = params.awardList
	if awardList then
		self:updateAwardList(awardList)
	end
end
function Com_awardSingle:updateAwardList(awardList)
