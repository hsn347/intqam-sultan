local baseComponent = require("fgui.base.baseComponent")
local Com_Kings_Rewards = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingStarBattle/Com_Kings_Rewards", Com_Kings_Rewards)
function Com_Kings_Rewards:onInit()
	self.fields.rewardlist:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_Kings_Rewards:onShow()
end
function Com_Kings_Rewards:initData(title, kingReward)
	self.fields.text_reward_des:setString(title)
	self.kingReward = kingReward
	if display.height > 1136 then
		self.controllers.c1:setSelectedIndex(1)
		for i = 1, 7 do
			self:onItemRenderer(i - 1, self.fields["reward" .. i])
		end
	else
		self.fields.rewardlist:setNumItems(#kingReward)
	end
end
function Com_Kings_Rewards:onItemRenderer(index, obj)
	local reward = self.kingReward[index + 1]
	obj:initData(reward.id, reward.count)
end
return Com_Kings_Rewards
