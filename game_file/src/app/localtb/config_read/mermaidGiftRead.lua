local mermaidGiftRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "mermaid_gift_recharge"
	;(nil)[2] = true
	mermaidGiftRead:defineValue("recharge", nil)
	mermaidGiftRead = nil
	;(nil)[1] = "mermaid_gift_show"
	mermaidGiftRead:defineValue("show", nil)
	_ENV = nil
	;(nil)[1] = "mermaid_gift_reward"
	;(nil)[2] = true
	mermaidGiftRead:defineValue("reward", nil)
	mermaidGiftRead:defineValue("showGroup", function()
		mermaidGiftRead.showGroup, mermaidGiftRead = nil, nil
		for i, v in ipairs(mermaidGiftRead.show) do
			if not mermaidGiftRead.showGroup[v.group] then
				mermaidGiftRead = mermaidGiftRead.showGroup[v.group]
			end
			mermaidGiftRead.showGroup[v.group] = mermaidGiftRead.showGroup[v.group]
			table.insert(mermaidGiftRead.showGroup[v.group], v)
		end
		return mermaidGiftRead.showGroup
	end)
	mermaidGiftRead:defineValue("rewardGroup", function()
		mermaidGiftRead.rewardGroup, mermaidGiftRead = nil, nil
		for i, v in pairs(mermaidGiftRead.reward) do
			if not mermaidGiftRead.rewardGroup[v.group] then
				mermaidGiftRead = mermaidGiftRead.rewardGroup[v.group]
			end
			mermaidGiftRead.rewardGroup[v.group] = mermaidGiftRead.rewardGroup[v.group]
			table.insert(mermaidGiftRead.rewardGroup[v.group], v)
		end
		return mermaidGiftRead.rewardGroup
	end)
	local createData = function(name)
		mermaidGiftRead.rank, mermaidGiftRead = nil, nil
		local rank = require_data("mermaid_gift_rank", true, true).data
		mermaidGiftRead.rankRewardTypes, mermaidGiftRead = "mermaid_gift_rank", "mermaid_gift_rank"
		local mermaidGiftCtrl = SoraDGetCtrl("mermaidGiftCtrl")
		for k, v in pairs(rank) do
			if v.type == 2 then
				mermaidGiftRead = v.type
				v.type.i18nKey = "Mermaid_text_18"
				v.type.charmNum = mermaidGiftCtrl:getGiftCharNum()
				v.needShowInfo, v.type.num = v.type, mermaidGiftCtrl:getGiftMinRank()
			end
			if not mermaidGiftRead.rank[v.group] then
				mermaidGiftRead = mermaidGiftRead.rank[v.group]
			end
			mermaidGiftRead.rank[v.group] = mermaidGiftRead.rank[v.group]
			table.insert(mermaidGiftRead.rank[v.group], v)
			if not mermaidGiftRead.rankRewardTypes[v.group] then
				mermaidGiftRead = mermaidGiftRead.rankRewardTypes[v.group]
			end
			mermaidGiftRead.rankRewardTypes[v.group] = mermaidGiftRead.rankRewardTypes[v.group]
			if not mermaidGiftRead.rankRewardTypes[v.group][v.type] then
				mermaidGiftRead = mermaidGiftRead.rankRewardTypes[v.group][v.type]
			end
			mermaidGiftRead.rankRewardTypes[v.group][v.type] = mermaidGiftRead.rankRewardTypes[v.group][v.type]
			table.insert(mermaidGiftRead.rankRewardTypes[v.group][v.type], v)
		end
		for k, v in pairs(mermaidGiftRead.rankRewardTypes) do
			for k2, v2 in pairs(v) do
				table.sort(v2, function(l, r)
					return l.Index < r.Index
				end)
			end
		end
		return mermaidGiftRead[name]
	end
	mermaidGiftRead:defineValue("rank", createData)
	mermaidGiftRead:defineValue("rankRewardTypes", createData)
end
init()
function mermaidGiftRead.getRechargeList()
	return mermaidGiftRead.recharge
end
function mermaidGiftRead.getRankReward()
	return mermaidGiftRead.rank[mermaidGiftRead.getGroup()]
end
function mermaidGiftRead.getShowRankAward(rankType)
	return mermaidGiftRead.showGroup[mermaidGiftRead.getGroup()][rankType].rewardShow
end
function mermaidGiftRead.getRankAward(rankType)
	return mermaidGiftRead.rankRewardTypes[mermaidGiftRead.getGroup()][rankType]
end
function mermaidGiftRead.getReward()
	return mermaidGiftRead.rewardGroup[mermaidGiftRead.getGroup()]
end
function mermaidGiftRead.getGiftNumByType(stype)
	local rewardCfg = mermaidGiftRead.rewardGroup[mermaidGiftRead.getGroup()]
	for k, v in pairs(rewardCfg) do
		if stype == v.type then
			return v.giftNum
		end
	end
end
function mermaidGiftRead.getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.MERMAID_GIFT_ACTIVITY)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return mermaidGiftRead
