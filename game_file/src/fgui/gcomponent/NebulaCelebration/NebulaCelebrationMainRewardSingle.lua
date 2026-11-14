local nebulaCelebrationCtrl = SoraDGetCtrl("nebulaCelebrationCtrl")
local nebulaCelebrationRead = include("nebulaCelebrationRead")
local baseComponent = require("fgui.base.baseComponent")
local NebulaCelebrationMainRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCelebration/NebulaCelebrationMainRewardSingle", NebulaCelebrationMainRewardSingle)
_ENV = fgui.register_extension
fgui.register_extension.Unlock = 0
fgui.register_extension.CanGet = 1
fgui.register_extension.Getted = 2
local fgui.register_extension.Normal, REWARD_STATUS = 3, fgui.register_extension
function NebulaCelebrationMainRewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.Ani_blue:setAllFrameName("dh_xqyd_ls_%.2d.png", 1)
	self.fields.Ani_purple:setAllFrameName("dh_xqyd_zs_%.2d.png", 1)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward1:setItemRenderer(handler(self, self.onItemRenderer1))
end
function NebulaCelebrationMainRewardSingle:onItemRenderer(index, obj)
	obj:initData(self.normalReward[2 * index + 1], self.normalReward[2 * index + 2])
	obj:setStatus(self.normalStatus)
end
function NebulaCelebrationMainRewardSingle:onItemRenderer1(index, obj)
	obj:initData(self.seniorReward[2 * index + 1], self.seniorReward[2 * index + 2])
	obj:setStatus(self.goldStatus)
end
function NebulaCelebrationMainRewardSingle:onShow()
end
function NebulaCelebrationMainRewardSingle:initData(cfg)
	self.cfg = cfg
	local level = cfg.level
	local maxLevel = nebulaCelebrationCtrl:getMaxLevel()
	local isMax = level >= maxLevel
	if isMax then
		self.fields.Text_lv:setString(level .. "+")
	else
		self.fields.Text_lv:setString(level)
	end
	local curLv = nebulaCelebrationCtrl:getCurLevel()
	local rewardLv = nebulaCelebrationCtrl:getRewardLevel()
	local rewardLvGold = nebulaCelebrationCtrl:getRewardLevelGold()
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
	if not nebulaCelebrationCtrl:isActiveGold() then
		self.goldStatus = REWARD_STATUS.Unlock
	elseif rewardLvGold >= realLv then
		if not isMax then
			self.goldStatus = REWARD_STATUS.Getted
		end
	elseif curLv >= realLv then
		self.goldStatus = REWARD_STATUS.CanGet
	end
	self.normalReward = cfg.normalReward
	self.seniorReward = cfg.seniorReward
	self.fields.List_reward:setNumItems(#self.normalReward / 2)
	self.fields.List_reward1:setNumItems(#self.seniorReward / 2)
	self.controllers.c2:setSelectedIndex(not isMax and cfg.level == curLv and 1 or 0)
	self.fields.Ani_blue:setVisible(curLv >= realLv and rewardLv < realLv)
	self.fields.Ani_purple:setVisible(curLv >= realLv and rewardLvGold < realLv)
end
return NebulaCelebrationMainRewardSingle
