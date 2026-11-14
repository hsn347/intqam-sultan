local baseComponent = require("fgui.base.baseComponent")
local Com_MiningMeteorites_Preivew = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MiningMeteorites/Com_MiningMeteorites_Preivew", Com_MiningMeteorites_Preivew)
function Com_MiningMeteorites_Preivew:onInit()
	self.fields.RewardList:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_MiningMeteorites_Preivew:onShow()
end
function Com_MiningMeteorites_Preivew:initData(rewards, title)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(rewards, nil)
	self.fields.RewardList:setNumItems(#self.rewards)
	self.fields.Text_Title:setString(i18n(title))
end
function Com_MiningMeteorites_Preivew:onItemRenderer(index, target)
	dump(self.rewards[index + 1], "self.rewards[index+1]")
	target:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
return Com_MiningMeteorites_Preivew
