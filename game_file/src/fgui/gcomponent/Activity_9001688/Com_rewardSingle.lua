local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001688/Com_rewardSingle", Com_rewardSingle)
function Com_rewardSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_reward:fixPos()
end
function Com_rewardSingle:onItemRederer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Com_rewardSingle:onShow()
end
function Com_rewardSingle:initData(cfg)
	_ENV = nil
	;(nil).rank = cfg.rank
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.rewards = cfg.reward
	self.fields.List_reward:setNumItems(#self.rewards)
	print("#self.rewards===", #self.rewards, #self.rewards > 6)
	self.fields.List_reward:setScrollEnable(#self.rewards > 6)
end
return Com_rewardSingle
