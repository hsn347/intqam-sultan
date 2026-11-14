local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001684/Com_rewardSingle", Com_rewardSingle)
function Com_rewardSingle:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:fixPos()
end
function Com_rewardSingle:onItemRederer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Com_rewardSingle:onShow()
end
function Com_rewardSingle:initData(cfg)
	_UPVALUE0_ = nil
	;(nil).rank = cfg.rankInterval
	self.fields.Com_rankBase:initRankBaseData(nil)
	self.rewards = cfg.rewards
	self.fields.List:setNumItems(#self.rewards)
	self.fields.List:setScrollEnable(#self.rewards > 6)
end
return Com_rewardSingle
