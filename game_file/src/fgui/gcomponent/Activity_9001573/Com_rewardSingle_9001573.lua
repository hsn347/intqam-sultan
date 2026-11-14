local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle_9001573 = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local activity_9001573_Read = include("activity_9001573_Read")
fgui.register_extension("ui://Activity_9001573/Com_rewardSingle_9001573", Com_rewardSingle_9001573)
function Com_rewardSingle_9001573:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_rewardSingle_9001573:onShow()
end
function Com_rewardSingle_9001573:initData(cfg)
	self.reward, activity_9001573_Ctrl = nil, nil
	local lv = activity_9001573_Ctrl:getPowerRatio()
	local powerRatio = activity_9001573_Read.getRewardRatio(lv)
	for i, v in ipairs(cfg.reward) do
		activity_9001573_Ctrl = nil
		;(nil).id = v.id
		;(nil).count = v.count
		table.insert(self.reward, nil)
	end
	for i, v in ipairs(cfg.diffReward) do
		local addNum = math.floor(v.count * powerRatio / 1000)
		local isIn = false
		for i2, v2 in ipairs(self.reward) do
			if v2.id == v.id then
				isIn = true
				v2.count = v2.count + addNum
			end
		end
		if not isIn then
			activity_9001573_Ctrl = ipairs(self.reward)
			ipairs(self.reward).id = v.id
			ipairs(self.reward).count = addNum
			table.insert(self.reward, ipairs(self.reward))
		end
	end
	if cfg.rank[1] ~= nil and cfg.rank[1] == cfg.rank[2] then
		local rank = cfg.rank[1]
		if rank <= RANK_TOP_SPECIAL then
			self.controllers.c1:setSelectedIndex(rank)
		else
			self.controllers.c1:setSelectedIndex(0)
			activity_9001573_Ctrl = math.floor(v.count * powerRatio / 1000)
			math.floor(v.count * powerRatio / 1000).num = rank
			self.fields.Text_rank:setString(i18n("common_text_617", (math.floor(v.count * powerRatio / 1000))))
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		if cfg.rank[1] == nil then
			self.fields.Text_rank:setString(i18n("accompany_peer_text_06"))
		else
			activity_9001573_Ctrl = i18n("accompany_peer_text_06")
			i18n("accompany_peer_text_06").min = cfg.rank[1]
			i18n("accompany_peer_text_06").max = cfg.rank[2]
			self.fields.Text_rank:setString(i18n("common_text_1770", i18n("accompany_peer_text_06")))
		end
	end
	local cnt = #self.reward
	self.fields.List_reward:setNumItems(cnt)
	self.fields.List_reward:scrollToView(0, false, false)
end
function Com_rewardSingle_9001573:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
return Com_rewardSingle_9001573
