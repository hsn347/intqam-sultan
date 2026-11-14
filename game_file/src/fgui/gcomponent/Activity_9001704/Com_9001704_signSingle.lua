local activity_9001704_Ctrl = SoraDGetCtrl("activity_9001704_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001704_signSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001704/Com_9001704_signSingle", Com_9001704_signSingle)
function Com_9001704_signSingle:onInit()
	self.fields.List_reward1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.List_reward2:setItemRenderer(handler(self, self.onItemRenderer2))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_9001704_signSingle:onShow()
end
function Com_9001704_signSingle:onItemRenderer1(index, obj)
	local data = self.normalReward[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(self.state1)
end
function Com_9001704_signSingle:onItemRenderer2(index, obj)
	local data = self.advanceReward[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(self.state2)
end
function Com_9001704_signSingle:initData(cfg, level, curLv)
	self.fields.Text_day:setString(level)
	self.state1 = activity_9001704_Ctrl:getBattlePassRewardState(1, level)
	self.state2 = activity_9001704_Ctrl:getBattlePassRewardState(2, level)
	self.normalReward = cfg.normalReward
	self.advanceReward = cfg.advanceReward
	self.fields.List_reward1:setNumItems(#self.normalReward)
	self.fields.List_reward2:setNumItems(#self.advanceReward)
	if curLv == level then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Com_9001704_signSingle
