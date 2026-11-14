local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001642/Com_rewardSingle", Com_rewardSingle)
function Com_rewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.Load_bg:fix()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_rewardSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_rewardSingle:onShow()
end
function Com_rewardSingle:initData(cfg, index, isStage)
	self.reward = cfg.reward
	self.fields.List_reward:setNumItems(#self.reward)
	self.controllers.c2:setSelectedIndex(isStage and 1 or 0)
	if isStage then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_num:setString(cfg.rankNum)
	else
		self.controllers.c1:setSelectedIndex(index <= RANK_TOP_SPECIAL and index or 0)
		if index > RANK_TOP_SPECIAL then
			_ENV = nil
			;(nil).var1 = cfg.rank[1]
			;(nil).var2 = cfg.rank[2]
			self.fields.Text_rank:setString(i18n("%{var1}-%{var2}", nil))
		end
	end
end
return Com_rewardSingle
