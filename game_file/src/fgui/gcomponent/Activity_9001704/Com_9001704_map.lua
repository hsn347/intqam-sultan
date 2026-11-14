local activity_9001704_Read = include("activity_9001704_Read")
local activity_9001704_Ctrl = SoraDGetCtrl("activity_9001704_Ctrl")
local commonBuyGiftUtil = include("commonBuyGiftUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001704_map = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001704/Com_9001704_map", Com_9001704_map)
function Com_9001704_map:onInit()
	self.gridList, _ENV, self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704, gActivityTimeActivityID.NORMAL_ACTIVITY_9001704, gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	for i = 0, 20 do
		local Com_grid = self.fields["Com_grid" .. i]
		Com_grid:addClickListener(handlerEx(self, self.onClickGrid, i))
		self.gridList[i] = Com_grid
	end
	self.extraList, _ENV = 0, (for index)
	for i = 1, 6 do
		local Com_extra = self.fields["Com_extra" .. i]
		Com_extra:addClickListener(handlerEx(self, self.onClickExtra, i))
		self.extraList[i] = Com_extra
	end
	self.gridMax = activity_9001704_Read.getGridMax()
end
function Com_9001704_map:onShow()
end
function Com_9001704_map:onClickGrid(index, context)
	print("==Com_9001704_map:onClickGrid==", index)
	if index <= 0 then
		return
	end
	local freeReward = activity_9001704_Read.getFreeReward(index)
	local pass_reward = activity_9001704_Read.getPassReward(index)
	local _ENV, rewards = index, index
	table.insertto(rewards, freeReward)
	if 0 < #pass_reward then
		table.insertto(rewards, pass_reward)
	end
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).rewards = rewards
	uiManager:show("CommonStageReward2", nil)
end
function Com_9001704_map:onClickExtra(index, context)
	local payRewardIdx = activity_9001704_Read.getPayRewardIdx(index)
	print("==Com_9001704_map:onClickExtra==", index, payRewardIdx)
	if not payRewardIdx then
		return
	end
	local payReward = activity_9001704_Read.getPayReward(payRewardIdx)
	activity_9001704_Read = payRewardIdx
	payRewardIdx.activityID = self.activityID
	local payRewardIdx.rewards, params = payReward, payRewardIdx
	local state = activity_9001704_Ctrl:getExtraRewardState(index)
	if state == gBtnTargetStatusDef.GO then
		if not activity_9001704_Ctrl:getIsAdvanceRewardUnlock() then
			local rechargeName = commonBuyGiftUtil.getRechargeName(self.activityID)
			activity_9001704_Read = nil
			;(nil).name = rechargeName
			params.tipStr = i18n("sky_island_text08", nil)
			params.btnStr = i18n("Secret_explore_text_14")
			function params.btnHandle()
				_ENV = nil
				;(nil).activityID = self.activityID
				uiManager:show("CommonBuyGift", nil)
			end
		else
			params.tipStr = i18n("sky_island_text11")
		end
	elseif state == gBtnTargetStatusDef.GET then
		params.btnStr = i18n("common_text_1146")
		function params.btnHandle()
			activity_9001704_Ctrl:reqPayReward(payRewardIdx)
		end
	else
		params.btnStr = i18n("common_text_1892")
		params.btnEnabled = false
	end
	uiManager:show("CommonStageReward2", params)
end
function Com_9001704_map:updateSteps(isAni, func)
	self.steps = activity_9001704_Ctrl:getSteps()
	self.fields.Com_self:stopAllActions()
	if not isAni or not self.preSteps then
		local Com_grid = self:getComGrid(self.steps)
		local pos = Com_grid:getPosition()
		self.fields.Com_self:setPosition(pos)
		self:scrollToCenter(pos)
		self.preSteps = self.steps
		self:updateBuyGift()
	else
		if self.preSteps == self.steps then
			return
		end
		local activity_9001704_Ctrl, actionList = self.preSteps, self.preSteps
		for step = self.preSteps, self.steps do
			do
				local Com_grid = self:getComGrid(step)
				local pos = Com_grid:getPosition()
				_ENV = nil
				;(nil)[1] = ffa.moveTo(0.5, pos)
				;(nil)[2] = ffa.callFunc(function()
					self:scrollToCenter(pos, 0.5)
				end)
				;(nil)[3] = ffa.callFunc(function()
					self:scrollToCenter(pos, 0.5)
				end)
				table.insert(actionList, ffa.spawn(nil))
			end
		end
		table.insert(actionList, ffa.callFunc(function()
			self:updateBuyGift()
			if func then
				func()
			end
		end))
		local action = ffa.seq(actionList)
		self.fields.Com_self:runAction(action)
		self.preSteps = self.steps
	end
end
function Com_9001704_map:getComGrid(step)
	local _step = (step - 1) % self.gridMax + 1
	return self.gridList[_step]
end
function Com_9001704_map:updateBuyGift()
	for index, Com_extra in ipairs(self.extraList) do
		local Com_lock = Com_extra:getChild("Com_lock")
		local c1 = Com_lock:getController("c1")
		local state = activity_9001704_Ctrl:getExtraRewardState(index)
		if state == gBtnTargetStatusDef.GO then
			c1:setSelectedIndex(0)
		elseif state == gBtnTargetStatusDef.GET then
			c1:setSelectedIndex(1)
		else
			c1:setSelectedIndex(2)
		end
	end
end
function Com_9001704_map:updatePayReward()
	self:updateBuyGift()
end
return Com_9001704_map
