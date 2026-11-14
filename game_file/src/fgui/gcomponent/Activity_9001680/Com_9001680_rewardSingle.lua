local baseComponent = require("fgui.base.baseComponent")
local Com_9001680_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001680/Com_9001680_rewardSingle", Com_9001680_rewardSingle)
local activity_9001680_Read = include("activity_9001680_Read")
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
_ENV = "activity_9001680_Ctrl"
;("activity_9001680_Ctrl").Unlock = 0
;("activity_9001680_Ctrl").CanGet = 1
;("activity_9001680_Ctrl").Getted = 2
local ("activity_9001680_Ctrl").Normal, REWARD_STATUS = 3, "activity_9001680_Ctrl"
function Com_9001680_rewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward1:setItemRenderer(handler(self, self.onItemRenderer1))
end
function Com_9001680_rewardSingle:onShow()
end
function Com_9001680_rewardSingle:onItemRenderer(index, obj)
	obj:initData(self.normalReward[index + 1].id, self.normalReward[index + 1].count)
	obj:setStatus(self.normalStatus)
end
function Com_9001680_rewardSingle:onItemRenderer1(index, obj)
	obj:initData(self.advanceReward[index + 1].id, self.advanceReward[index + 1].count)
	obj:setStatus(self.goldStatus)
end
function Com_9001680_rewardSingle:initData(cfg, level)
	self.cfg = cfg
	local curLv = activity_9001680_Ctrl:getCurDay()
	local maxLevel = activity_9001680_Read:getMaxLevel()
	local isMax = level > maxLevel
	if isMax then
		self.fields.Text_lv:setString(level .. "+")
	else
		self.fields.Text_lv:setString(level)
	end
	local rewardLv = activity_9001680_Ctrl:getRewardDay()
	local rewardLvGold = activity_9001680_Ctrl:getRewardDayGold()
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
	if not activity_9001680_Ctrl:isActiveGold() then
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
	self.fields.List_reward:setNumItems(#self.normalReward)
	self.fields.List_reward1:setNumItems(#self.advanceReward)
	self.controllers.c2:setSelectedIndex(not isMax and cfg.level == curLv and 1 or 0)
end
return Com_9001680_rewardSingle
