local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local activity_9001729_Read = include("activity_9001729_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001729_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001729/Com_9001729_rewardSingle", Com_9001729_rewardSingle)
_ENV = fgui.register_extension
fgui.register_extension.Unlock = 0
fgui.register_extension.CanGet = 1
fgui.register_extension.Getted = 2
local fgui.register_extension.Normal, REWARD_STATUS = 3, fgui.register_extension
function Com_9001729_rewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.n34:fix()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward1:setItemRenderer(handler(self, self.onItemRenderer1))
end
function Com_9001729_rewardSingle:onShow()
end
function Com_9001729_rewardSingle:onItemRenderer(index, obj)
	obj:initData(self.normalReward[index + 1].id, self.normalReward[index + 1].count)
	obj:setStatus(self.normalStatus)
end
function Com_9001729_rewardSingle:onItemRenderer1(index, obj)
	obj:initData(self.advanceReward[index + 1].id, self.advanceReward[index + 1].count)
	obj:setStatus(self.goldStatus)
end
function Com_9001729_rewardSingle:initData(cfg, activityDay)
	self.cfg = cfg
	local maxLevel = activity_9001729_Read:getMaxBattlePassLv(gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY)
	local isMax = maxLevel < cfg.rewardID
	if isMax then
		self.fields.Text_lv:setString(cfg.rewardID .. "+")
	else
		self.fields.Text_lv:setString(cfg.rewardID)
	end
	local rewardLv = activity_9001729_Ctrl:getRewardDay()
	local rewardLvGold = activity_9001729_Ctrl:getRewardDayGold()
	self.normalStatus = REWARD_STATUS.Normal
	self.goldStatus = REWARD_STATUS.Unlock
	if rewardLv >= cfg.rewardID then
		self.normalStatus = REWARD_STATUS.Getted
	elseif activityDay > rewardLv and activityDay >= cfg.rewardID then
		self.normalStatus = REWARD_STATUS.CanGet
	end
	if not activity_9001729_Ctrl:isActiveGold() then
		self.goldStatus = REWARD_STATUS.Unlock
	elseif rewardLvGold >= cfg.rewardID then
		self.goldStatus = REWARD_STATUS.Getted
	elseif activityDay > rewardLvGold and activityDay >= cfg.rewardID then
		self.goldStatus = REWARD_STATUS.CanGet
	else
		self.goldStatus = REWARD_STATUS.Normal
	end
	activity_9001729_Ctrl = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.normalReward = serviceFunctions.tableFormat(cfg.normalReward, nil)
	activity_9001729_Ctrl = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.advanceReward = serviceFunctions.tableFormat(cfg.advanceReward, nil)
	self.fields.List_reward:setNumItems(#self.normalReward)
	self.fields.List_reward1:setNumItems(#self.advanceReward)
	self.controllers.c2:setSelectedIndex(not isMax and cfg.rewardID == activityDay and 1 or 0)
end
return Com_9001729_rewardSingle
