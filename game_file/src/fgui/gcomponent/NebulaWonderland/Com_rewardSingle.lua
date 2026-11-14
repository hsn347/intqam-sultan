local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWonderland/Com_rewardSingle", Com_rewardSingle)
function Com_rewardSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_rewardSingle:initData(index, data)
	self.reward = data.reward
	_ENV = nil
	;(nil).num = string.formatnumberthousands(data.integral)
	self.fields.Text_day:setString(i18n("nebula_wonderland_006", nil))
	self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
end
function Com_rewardSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
function Com_rewardSingle:onShow()
end
return Com_rewardSingle
