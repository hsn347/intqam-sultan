local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_rewardSingle", Com_rewardSingle)
local getRankRange = function(cfg)
	local rank = cfg.rank or cfg.rankRange or cfg.rankInterval
	if type(rank) == "table" and not rank[1] then
		local min = rank.min or rank[1] or 0
		local _UPVALUE2_, max = nil, rank.max or rank[2] or min
		rank, (nil)[1] = nil, min
		rank, (nil)[2] = nil, max
	end
	return rank or cfg.index or 0
end
local getRewardList = function(cfg)
	if not cfg.reward and not cfg.rewards and not cfg.rewardList then
		_UPVALUE0_ = cfg.rewardList
	end
	return cfg.rewardList
end
local getRewardId = function(data)
	return data.id or data.itemID or data.itemId or data[1]
end
local getRewardCount = function(data)
	return data.count or data.num or data.itemNum or data[2] or 0
end
local setRewardItemStatus = function(obj, status)
	obj.controllers.button:setSelectedIndex(status == "received" and 1 or 0)
end
function Com_rewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function Com_rewardSingle:onShow()
end
function Com_rewardSingle:itemRenderer_List(index, obj)
	local data = self.rewards[index + 1]
	if obj.initData then
		obj:initData(getRewardId(data), getRewardCount(data))
	end
	setRewardItemStatus(obj, self.rewardStatus)
end
function Com_rewardSingle:initData(cfg, options)
	if not cfg then
		cfg, getRankRange = nil, nil
	end
	if not options then
		options, getRankRange = nil, nil
	end
	self.rewardStatus = options.status or cfg.status or cfg._rewardPreviewStatus
	local isLevelPreview = options.type == "level" or cfg.levelID ~= nil
	local titleNum = options.levelID or cfg.levelID or cfg.index or getRankRange(cfg)
	if isLevelPreview then
		self.fields.n16:setString("Lv." .. tostring(titleNum))
	else
		self.fields.n16:setString(tostring(titleNum))
	end
	self.controllers.ctrlLight:setSelectedIndex(self.rewardStatus == "current" and 1 or 0)
	self.rewards = getRewardList(cfg)
	self.fields.List:setNumItems(#self.rewards)
end
return Com_rewardSingle
