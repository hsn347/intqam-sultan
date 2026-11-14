local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaTreasureA/Com_rewardSingle", Com_rewardSingle)
function Com_rewardSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_rewardSingle:onShow()
end
function Com_rewardSingle:initData_Imp(data)
	self.reward = data.award
	_ENV = nil
	;(nil).num = data.layerId
	self.fields.Text_day:setString(i18n("nebula_treasure_hunt_07", nil))
	self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
end
function Com_rewardSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
return Com_rewardSingle
