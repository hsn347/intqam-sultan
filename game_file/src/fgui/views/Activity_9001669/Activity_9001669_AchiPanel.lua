local activityCommonKitchenRead = include("activityCommonKitchenRead")
local activityCommonKitchenCtrl = SoraDGetCtrl("activityCommonKitchenCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001669_AchiPanel = class("Activity_9001669_AchiPanel", baseFguiPanel)
function Activity_9001669_AchiPanel:ctor(...)
	Activity_9001669_AchiPanel.super.ctor(self, ...)
	print("Activity_9001669_AchiPanel:ctor", self.viewName)
end
function Activity_9001669_AchiPanel:onInit()
	print("=======Activity_9001669_AchiPanel:onInit")
	self.fields.Panel_bg:setString(i18n("anniversary_dice_text_08"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
end
function Activity_9001669_AchiPanel:onShow()
	print("=======Activity_9001669_AchiPanel:onShow")
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	self.activityID = self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	self.uniqueIDList = activityCommonKitchenRead.getUniqueIDList(self.activityID)
	self:updateData()
end
function Activity_9001669_AchiPanel:updateData(...)
	local _ENV, ret
	for __, uniqueID in ipairs(self.uniqueIDList) do
		_ENV = nil
		;(nil).uniqueID = uniqueID
		;(nil).state = activityCommonKitchenCtrl:getAchivevementState(self.activityID, uniqueID)
		table.insert(ret, nil)
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
function Activity_9001669_AchiPanel:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	obj:initData(self.activityID, data)
end
function Activity_9001669_AchiPanel:onMsgUpdateData(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "achievementReward" then
		self:updateData()
	end
end
return Activity_9001669_AchiPanel
