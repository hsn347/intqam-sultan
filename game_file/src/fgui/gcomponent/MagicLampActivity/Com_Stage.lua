local magicFlipCtrl = SoraDGetCtrl("magicFlipCtrl")
local magicFlipRead = include("magicFlipRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampActivity/Com_Stage", Com_Stage)
function Com_Stage:onInit()
	self:fixChildrenPos()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_Stage:setActivityID(activityID)
	self.activityID = activityID
end
function Com_Stage:onShow()
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		local nebulaWarRead = include("nebulaWarRead")
		local round = nebulaActivityCtrl:getCurRound()
		self.stageConfig = nebulaWarRead.getScoreRewardList(round)
	else
		self.stageConfig = magicFlipRead.getStageConfig()
	end
	self.fields.List_reward:setNumItems(#self.stageConfig)
	self.fields.List_reward:resizeToFit(#self.stageConfig)
	local bar_v = self.fields.Com_Bar:getChild("bar_v")
	self.barHeight = self.fields.Com_Bar:getChild("bg"):getHeight() - 3
	bar_v:setHeight(self.barHeight)
	bar_v:getChild("icon"):setWidth(self.barHeight + 19)
	self.fields.Com_Bar:setMax(100)
	self.fields.Com_Bar:setValue(self:getProgressValue())
	self:getScrollPane():setPercY(self:getProgressValue() / 100, true)
end
function Com_Stage:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001498_UPDATE", handler(self, self.msgRefreshView))
end
function Com_Stage:msgRefreshView(target, data)
	if data.subMsg == "stage" then
		self.fields.List_reward:setNumItems(#self.stageConfig)
	end
end
function Com_Stage:onItemRederer(index, target)
	_UPVALUE0_ = index + 1
	;(index + 1).activityID = self.activityID
	target:initData(self.stageConfig[index + 1], index + 1)
end
function Com_Stage:getProgressValue()
	local value = 0
	local key = ""
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		value = nebulaActivityCtrl:getPlayerScore()
		key = "need"
	else
		value = magicFlipCtrl:getFlipCount()
		key = "num"
	end
	local offsetY = 0
	for i, v in ipairs(self.stageConfig) do
		if value >= v[key] then
			if i == 1 then
				offsetY = offsetY + 44
			else
				offsetY = offsetY + 126
			end
		else
			local base = 126
			local lastNum = 0
			if i == 1 then
				base = 44
			else
				lastNum = self.stageConfig[i - 1][key]
			end
			offsetY = offsetY + base * (value - lastNum) / (v[key] - lastNum)
			break
		end
	end
	print("self:getProgressValue()", offsetY)
	return offsetY / self.barHeight * 100
end
function Com_Stage:updateScrolll(...)
	self.fields.List_reward:setNumItems(#self.stageConfig)
end
return Com_Stage
