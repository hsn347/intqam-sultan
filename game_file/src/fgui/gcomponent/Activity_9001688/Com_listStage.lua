local baseComponent = require("fgui.base.baseComponent")
local Com_listStage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001688/Com_listStage", Com_listStage)
function Com_listStage:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_listStage:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_listStage:onShow()
end
function Com_listStage:initData(cfg)
	self.fields.title:setString(cfg.score)
	self.reward = cfg.reward
	self.fields.List:setNumItems(#self.reward)
	self.fields.List:setScrollEnable(#self.reward > 4)
end
return Com_listStage
