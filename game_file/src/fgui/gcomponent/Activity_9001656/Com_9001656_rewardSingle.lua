local baseComponent = require("fgui.base.baseComponent")
local Com_9001656_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001656_Read = include("activity_9001656_Read")
local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
fgui.register_extension("ui://Activity_9001656/Com_9001656_rewardSingle", Com_9001656_rewardSingle)
_ENV = fgui.register_extension
fgui.register_extension.Unlock = 0
fgui.register_extension.CanGet = 1
fgui.register_extension.Getted = 2
local fgui.register_extension.Normal, REWARD_STATUS = 3, fgui.register_extension
function Com_9001656_rewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward1:setItemRenderer(handler(self, self.onItemRenderer1))
end
function Com_9001656_rewardSingle:onShow()
end
function Com_9001656_rewardSingle:onItemRenderer(index, obj)
	obj:initData(self.normalReward[2 * index + 1], self.normalReward[2 * index + 2])
	obj:setStatus(self.normalStatus)
end
function Com_9001656_rewardSingle:onItemRenderer1(index, obj)
	obj:initData(self.advanceReward[2 * index + 1], self.advanceReward[2 * index + 2])
	obj:setStatus(self.goldStatus)
end
function Com_9001656_rewardSingle:initData(cfg)
	self.cfg = cfg
	local level = cfg.lv
	local curLv = activity_9001656_Read.getLvByExp(activity_9001656_Ctrl:getCurExp())
	local maxLevel = activity_9001656_Read:getMaxLevel()
	local isMax = level >= maxLevel
	if isMax then
		self.fields.Text_lv:setString(level .. "+")
	else
		self.fields.Text_lv:setString(level)
	end
	local rewardLv = activity_9001656_Ctrl:getRewardLevel()
	local rewardLvGold = activity_9001656_Ctrl:getRewardLevelGold()
	self.normalStatus = REWARD_STATUS.Normal
	self.goldStatus = REWARD_STATUS.Normal
	local realLv = isMax and math.max(curLv, level) or level
	if rewardLv >= realLv then
		if not isMax then
			self.normalStatus = REWARD_STATUS.Getted
		end
	elseif curLv >= realLv then
		self.normalStatus = REWARD_STATUS.CanGet
	end
	if not activity_9001656_Ctrl:isActiveGold() then
		self.goldStatus = REWARD_STATUS.Unlock
	elseif rewardLvGold >= realLv then
		if not isMax then
			self.goldStatus = REWARD_STATUS.Getted
		end
	elseif curLv >= realLv then
		self.goldStatus = REWARD_STATUS.CanGet
	end
	self.normalReward = cfg.normalReward
	self.advanceReward = cfg.advanceReward
	self.fields.List_reward:setNumItems(#self.normalReward / 2)
	self.fields.List_reward1:setNumItems(#self.advanceReward / 2)
	self.controllers.c2:setSelectedIndex(not isMax and cfg.level == curLv and 1 or 0)
end
return Com_9001656_rewardSingle
