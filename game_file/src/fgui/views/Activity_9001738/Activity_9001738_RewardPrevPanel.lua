local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_RewardPrevPanel = class("Activity_9001738_RewardPrevPanel", baseFguiPanel)
function Activity_9001738_RewardPrevPanel:ctor(...)
	self.isLRU = true
	Activity_9001738_RewardPrevPanel.super.ctor(self, ...)
	print("Activity_9001738_RewardPrevPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
end
function Activity_9001738_RewardPrevPanel:onInit()
	print("=======Activity_9001738_RewardPrevPanel:onInit")
	self:fixChildrenPos()
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.Panel_bg:setString(i18n("devilvalley_text_27"))
end
function Activity_9001738_RewardPrevPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("memory_flip_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001738_RewardPrevPanel:endShow()
	print("=======Activity_9001738_RewardPrevPanel:endShow")
	self.rewards, _ENV = print, print
	local levelList = activity_9001738_Read.getLevelList(activity_9001738_Ctrl:getClassType())
	local maxClearedLevelID = tonumber(activity_9001738_Ctrl:getMaxLevelId()) or 0
	local currentLevelID = tonumber(activity_9001738_Ctrl:getCurrentLevelId()) or 0
	if maxClearedLevelID >= currentLevelID then
		currentLevelID = maxClearedLevelID + 1
	end
	for _, cfg in ipairs(levelList) do
		local levelID = tonumber(cfg.levelID) or 0
		local status = "normal"
		if 0 < levelID and maxClearedLevelID >= levelID then
			status = "received"
		elseif 0 < levelID and levelID == currentLevelID then
			status = "current"
		end
		_ENV = activity_9001738_Ctrl:getCurrentLevelId()
		activity_9001738_Ctrl:getCurrentLevelId().cfg = cfg
		activity_9001738_Ctrl:getCurrentLevelId().levelID = levelID
		activity_9001738_Ctrl:getCurrentLevelId().status = status
		table.insert(self.rewards, activity_9001738_Ctrl:getCurrentLevelId())
	end
	self.fields.List_reward:setNumItems(#self.rewards)
end
function Activity_9001738_RewardPrevPanel:itemRenderer_List_reward(index, obj)
	local data = self.rewards[index + 1]
	if obj.initData then
		_UPVALUE0_ = nil
		;(nil).type = "level"
		;(nil).status = data.status
		;(nil).levelID = data.levelID
		obj:initData(data.cfg, nil)
	end
end
return Activity_9001738_RewardPrevPanel
