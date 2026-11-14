local baseComponent = require("fgui.base.baseComponent")
local Com_9001577_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001577/Com_9001577_rewardSingle", Com_9001577_rewardSingle)
function Com_9001577_rewardSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
	self.fields.n12:fix()
end
function Com_9001577_rewardSingle:onShow()
end
function Com_9001577_rewardSingle:initData(cfg)
	self.reward = cfg.reward
	if cfg.task[1] ~= nil and cfg.task[1] == cfg.task[2] then
		local rank = cfg.task[1]
		if rank <= RANK_TOP_SPECIAL then
			self.controllers.c1:setSelectedIndex(rank)
		else
			self.controllers.c1:setSelectedIndex(0)
			_ENV = nil
			;(nil).num = rank
			self.fields.Text_rank:setString(i18n("common_text_617", nil))
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		if cfg.task[1] == nil then
			self.fields.Text_rank:setString(i18n("accompany_peer_text_06"))
		else
			_ENV = i18n("accompany_peer_text_06")
			i18n("accompany_peer_text_06").min = cfg.task[1]
			i18n("accompany_peer_text_06").max = cfg.task[2]
			self.fields.Text_rank:setString(i18n("common_text_1770", i18n("accompany_peer_text_06")))
		end
	end
	local cnt = #self.reward / 2
	self.fields.List_reward:setNumItems(cnt)
	self.fields.List_reward:scrollToView(0, false, false)
end
function Com_9001577_rewardSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
return Com_9001577_rewardSingle
