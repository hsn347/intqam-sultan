local activityCommonKitchenCtrl = SoraDGetCtrl("activityCommonKitchenCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001699_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001669/Com_9001699_rewardSingle", Com_9001699_rewardSingle)
function Com_9001699_rewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.List_reward1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.List_reward2:setItemRenderer(handler(self, self.onItemRenderer2))
end
function Com_9001699_rewardSingle:onShow()
end
function Com_9001699_rewardSingle:onItemRenderer1(index, obj)
	local data = self.normalReward[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(self.state1)
end
function Com_9001699_rewardSingle:onItemRenderer2(index, obj)
	local data = self.advanceReward[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(self.state2)
end
function Com_9001699_rewardSingle:initData(activityID, cfg, level, curLv)
	_ENV = nil
	;(nil).count = level
	self.fields.Text_day:setString(i18n("common_text_523", nil))
	self.state1 = activityCommonKitchenCtrl:getBattlePassRewardState(activityID, 1, level)
	self.state2 = activityCommonKitchenCtrl:getBattlePassRewardState(activityID, 2, level)
	print("==Com_9001699_rewardSingle:initData==", level, curLv, self.state1, self.state2)
	self.normalReward = cfg.normalReward
	self.advanceReward = cfg.advanceReward
	self.fields.List_reward1:setNumItems(#self.normalReward)
	self.fields.List_reward2:setNumItems(#self.advanceReward)
	if level <= curLv then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
return Com_9001699_rewardSingle
