local baseComponent = require("fgui.base.baseComponent")
local Com_9001746_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001746/Com_9001746_rewardSingle", Com_9001746_rewardSingle)
function Com_9001746_rewardSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.List_reward1:setItemRenderer(handler(self, self.itemRenderer_List_reward1))
	self.fields.List_reward:fixPos()
	self.fields.List_reward1:fixPos()
	self.fields.Text_lv:fixPos()
end
function Com_9001746_rewardSingle:itemRenderer_List_reward(index, obj)
	local data = self.normalReward[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(self.normalStatus)
end
function Com_9001746_rewardSingle:itemRenderer_List_reward1(index, obj)
	local data = self.advanceReward[index + 1]
	obj:initData(data.id, data.count)
	obj:setStatus(self.goldStatus)
end
function Com_9001746_rewardSingle:refreshRewardListStatus(list, status)
	for _, obj in ipairs(list:getChildren()) do
		obj:setStatus(status)
	end
end
function Com_9001746_rewardSingle:initData(cfg, otherData)
	if not otherData then
		otherData, _ENV = nil, nil
	end
	local rewardID = tonumber(cfg.rewardID) or 0
	local noAdvanceReward = otherData.noAdvanceReward == true
	self.fields.Text_lv:setString(otherData.levelText or rewardID)
	self.controllers.ctrlLight:setSelectedIndex((otherData.rowIndex or 0) % 2)
	self.controllers.ctrlNoAdv:setSelectedIndex(noAdvanceReward and 1 or 0)
	self.normalStatus = otherData.normalStatus or gBtnTargetStatusDef.NONE
	self.goldStatus = otherData.goldStatus or gBtnTargetStatusDef.NONE
	if not cfg.normalReward then
		_ENV = cfg.normalReward
	end
	self.normalReward = cfg.normalReward
	if not cfg.advanceReward then
		_ENV = cfg.advanceReward
	end
	self.advanceReward = cfg.advanceReward
	self.fields.List_reward:setNumItems(#self.normalReward)
	self.fields.List_reward1:setNumItems(noAdvanceReward and 0 or #self.advanceReward)
	self:refreshRewardListStatus(self.fields.List_reward, self.normalStatus)
	self:refreshRewardListStatus(self.fields.List_reward1, self.goldStatus)
end
return Com_9001746_rewardSingle
