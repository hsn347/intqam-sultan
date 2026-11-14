local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001738_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_9001738_rewardSingle", Com_9001738_rewardSingle)
function Com_9001738_rewardSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.List_reward1:setItemRenderer(handler(self, self.itemRenderer_List_reward1))
	self.fields.List_reward:fixPos()
	self.fields.List_reward1:fixPos()
	self.fields.Text_lv:fixPos()
end
function Com_9001738_rewardSingle:onShow()
end
function Com_9001738_rewardSingle:itemRenderer_List_reward(index, obj)
	local data = self.normalReward[index + 1]
	obj:initData(data)
	obj:setStatus(self.normalStatus)
end
function Com_9001738_rewardSingle:itemRenderer_List_reward1(index, obj)
	local data = self.advanceReward[index + 1]
	obj:initData(data)
	obj:setStatus(self.goldStatus)
end
function Com_9001738_rewardSingle:refreshRewardListStatus(list, status)
	for _, obj in ipairs(list:getChildren()) do
		obj:setStatus(status)
	end
end
function Com_9001738_rewardSingle:initData(cfg, otherData)
	self.cfg = cfg
	if not otherData then
		otherData, _ENV = nil, nil
	end
	local rewardID = cfg.rewardID or cfg.level or cfg.lv or 0
	self.fields.Text_lv:setString(otherData.levelText or rewardID)
	local rowIndex = otherData.rowIndex
	self.controllers.ctrlLight:setSelectedIndex((rowIndex or 0) % 2)
	self.controllers.ctrlNoAdv:setSelectedIndex(otherData.noAdvanceReward and 1 or 0)
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
	if otherData.advanceBuffReward then
		self.advanceReward = clone(self.advanceReward)
		table.insert(self.advanceReward, otherData.advanceBuffReward)
	end
	local noAdvanceReward = otherData.noAdvanceReward
	self.fields.List_reward:setNumItems(#self.normalReward)
	self.fields.List_reward1:setNumItems(noAdvanceReward and 0 or #self.advanceReward)
	self:refreshRewardListStatus(self.fields.List_reward, self.normalStatus)
	if not noAdvanceReward then
		self:refreshRewardListStatus(self.fields.List_reward1, self.goldStatus)
	else
		self.fields.List_reward:fixPos()
	end
end
return Com_9001738_rewardSingle
