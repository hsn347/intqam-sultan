local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001734_AchiPanel = class("Activity_9001734_AchiPanel", baseFguiPanel)
function Activity_9001734_AchiPanel:ctor(...)
	self.isLRU = true
	Activity_9001734_AchiPanel.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY
end
function Activity_9001734_AchiPanel:onInit()
	self.fields.Panel_bg:setString(i18n("anniversary_dice_text_08"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001734_AchiPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("football_betting_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001734_AchiPanel:endShow()
	self:updateData()
end
function Activity_9001734_AchiPanel:updateData()
	local _ENV, ret
	for __, uniqueID in ipairs(activity_9001734_Read.getUniqueIDList()) do
		_ENV = activity_9001734_Read.getUniqueIDList()
		activity_9001734_Read.getUniqueIDList().uniqueID = uniqueID
		activity_9001734_Read.getUniqueIDList().state = activity_9001734_Ctrl:getAchievementState(uniqueID)
		table.insert(ret, activity_9001734_Read.getUniqueIDList())
	end
	table.sort(ret, function(a, b)
		if a.state ~= b.state then
			return a.state < b.state
		end
		return a.uniqueID < b.uniqueID
	end)
	self.dataList = ret
	self.fields.List:setNumItems(#self.dataList)
end
function Activity_9001734_AchiPanel:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	obj:initData(data)
end
function Activity_9001734_AchiPanel:onMsgUpdateData(target, event)
	if event.subMsg ~= "achievementReward" then
		return
	end
	SoraDCloseLoading()
	self:updateData()
end
return Activity_9001734_AchiPanel
