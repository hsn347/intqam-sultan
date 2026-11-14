local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
local friendsCallbackRead = include("friendsCallbackRead")
local honorBackPetPatrolReward = class("honorBackPetPatrolReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("honorBackPetPatrolReward")
	end
	return target
end)
function honorBackPetPatrolReward:ctor()
	local rewardConfing = friendsCallbackRead.getReturnCatRewardConfig()
	friendsCallbackRead, friendsCallbackRead = nil, nil
	;(nil).title = "return_lcks_text_027"
	friendsCallbackRead, (nil)[1], (nil).reward = nil, nil, rewardConfing.lowWalkReward
	;(nil).title = "return_lcks_text_029"
	self.config, (nil)[2], (nil).reward = nil, nil, rewardConfing.highWalkReward
	self:initWidget()
	self:initData()
end
function honorBackPetPatrolReward:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.Node_cat = SoraDGetChildByName(self.scaleActTarget, "Node_cat")
	self.Node_cell = SoraDGetChildByName(self.scaleActTarget, "Node_cell")
	self.Text_title = SoraDGetChildByName(self.scaleActTarget, "Text_title")
	self.Node_cell:setVisible(false)
	self.Text_title:setString(i18n("return_lcks_text_026"))
end
function honorBackPetPatrolReward:initData()
	for i = 1, 2 do
		local cell = self.Node_cell:clone()
		cell:addTo(self.scaleActTarget)
		cell:setPositionY(410 - 265 * i)
		cell:setVisible(true)
		local config = self.config[i]
		cell:getChildByName("Text_reward"):setString(i18n(config.title))
		cell:getChildByName("Text_tip"):setString(i18n("kits_text_07"))
		local Node_reward = cell:getChildByName("Node_reward")
		for i, v in ipairs(config.reward) do
			local single = SoraDCreatePanel("commonItemAward")
			single:addTo(Node_reward)
			single:setScale(0.85)
			single:setOwnView(self)
			single:initData(v.id, v.count)
		end
		local align = SoraDFIsRA() and 2 or 0
		SoraDautoSortPos(Node_reward, 4, align, cc.size(106, 92))
		Node_reward:setPositionY(Node_reward:getPositionY() - 60)
	end
	self.isUnlock = friendPetCtrl:getInitData().isUnlock
	self:createSpineCat()
end
function honorBackPetPatrolReward:createSpineCat(...)
	local spine_cat
	if self.isUnlock then
		spine_cat = sp.SkeletonAnimation:create("spine/lingmao_zhanmao.skel", "spine/lingmao_zhanmao.atlas", 1)
	else
		spine_cat = sp.SkeletonAnimation:create("spine/lingmao_youmao.skel", "spine/lingmao_youmao.atlas", 1)
	end
	spine_cat:setAnimation(0, "animation", true)
	spine_cat:setPosition(cc.p(0, -80))
	spine_cat:addTo(self.Node_cat, -1)
end
return honorBackPetPatrolReward
