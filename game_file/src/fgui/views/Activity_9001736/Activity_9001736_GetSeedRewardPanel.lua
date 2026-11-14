local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_GetSeedRewardPanel = class("Activity_9001736_GetSeedRewardPanel", baseFguiPanel)
function Activity_9001736_GetSeedRewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_GetSeedRewardPanel.super.ctor(self, ...)
	print("Activity_9001736_GetSeedRewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_GetSeedRewardPanel:onInit()
	print("=======Activity_9001736_GetSeedRewardPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_close:setString(i18n("common_text_204"))
end
function Activity_9001736_GetSeedRewardPanel:onExit()
	print("=======Activity_9001736_GetSeedRewardPanel:onExit")
	uiManager:close("Activity_9001736_GetSeedShow")
end
function Activity_9001736_GetSeedRewardPanel:endShow()
	print("=======Activity_9001736_GetSeedRewardPanel:endShow")
	if not self.param.rewardSeeds then
		_ENV = self.param.rewardSeeds
	end
	self.rewardSeeds = self.param.rewardSeeds
	if not self.param.expSeedMap then
		_ENV = self.param.expSeedMap
	end
	self.expSeedMap = self.param.expSeedMap
	self.showEffect = true
	self.fields.List:setNumItems(#self.rewardSeeds)
	self.showEffect = false
	self.Bg_black:setVisible(false)
end
function Activity_9001736_GetSeedRewardPanel:itemRenderer_List(index, obj)
	local seedID = self.rewardSeeds[index + 1]
	_ENV = index + 1
	;(index + 1).id = seedID
	local (index + 1).count, data = 1, index + 1
	local exp = self.expSeedMap[index + 1]
	if exp then
		if self.showEffect then
			obj:initData(data)
			obj:showExpSeed(gIDDef.BALL_FIELD_MATCH_EXP, exp)
		else
			obj:initExpData(gIDDef.BALL_FIELD_MATCH_EXP, exp)
		end
	else
		obj:initData(data)
	end
end
function Activity_9001736_GetSeedRewardPanel:showBgBlack()
	self.Bg_black:setVisible(true)
end
return Activity_9001736_GetSeedRewardPanel
