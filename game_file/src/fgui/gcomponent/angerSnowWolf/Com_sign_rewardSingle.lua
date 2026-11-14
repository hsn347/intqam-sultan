local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_sign_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://angerSnowWolf/Com_sign_rewardSingle", Com_sign_rewardSingle)
function Com_sign_rewardSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.List_reward1:setItemRenderer(handler(self, self.itemRenderer_List_reward1))
	self:fixChildrenPos()
end
function Com_sign_rewardSingle:onShow()
end
function Com_sign_rewardSingle:initData(cfg, level)
	self.level = level
	self.fields.Text_lv:setString(self.level)
	self.normalReward = cfg.normalReward
	self.advanceReward = cfg.advanceReward
	self.fields.List_reward:setNumItems(#self.normalReward)
	self.fields.List_reward1:setNumItems(#self.advanceReward)
	local curLv = angrySnowWolfKingCtrl:getCurDay()
	self.controllers.c1:setSelectedIndex(self.level == curLv and 1 or 0)
end
function Com_sign_rewardSingle:itemRenderer_List_reward(index, obj)
	local data = self.normalReward[index + 1]
	obj:initData(data.id, data.count)
	local status1, status2 = angrySnowWolfKingCtrl:getSignLevelStatus(self.level)
	obj:setStatus(status1)
end
function Com_sign_rewardSingle:itemRenderer_List_reward1(index, obj)
	local data = self.advanceReward[index + 1]
	obj:initData(data.id, data.count)
	local status1, status2 = angrySnowWolfKingCtrl:getSignLevelStatus(self.level)
	obj:setStatus(status2)
end
return Com_sign_rewardSingle
