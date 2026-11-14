local baseComponent = require("fgui.base.baseComponent")
local Com_9001649_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001649/Com_9001649_rewardSingle", Com_9001649_rewardSingle)
function Com_9001649_rewardSingle:onInit()
	self.fields.list:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_9001649_rewardSingle:onShow()
end
function Com_9001649_rewardSingle:initData(data)
	self.fields.title:setString(data.title)
	self.reward = data.reward
	dump(self.reward, "self.reward")
	self.fields.list:setNumItems(#self.reward)
	self.fields.list:setHeight(math.ceil(#self.reward / 5) * 107)
end
function Com_9001649_rewardSingle:onItemRederer(index, obj)
	local data = self.reward[index + 1]
	obj:initData(data.id, data.count)
end
return Com_9001649_rewardSingle
