local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
local constantRead = include("constantRead")
local itemDesRead = include("itemDesRead")
local activityCommonDrawRead = include("activityCommonDrawRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001640_RewardPanel = class("Activity_9001640_RewardPanel", baseFguiPanel)
function Activity_9001640_RewardPanel:ctor(...)
	Activity_9001640_RewardPanel.super.ctor(self, ...)
	print("Activity_9001640_RewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.PHOENIX_ARRIVAL
end
function Activity_9001640_RewardPanel:onInit()
	print("=======Activity_9001640_RewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("nebulaemperor_text_86"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001640_RewardPanel:onShow()
	print("=======Activity_9001640_RewardPanel:onShow")
	_ENV = nil
	local rewardArray = constantRead.getConstValueArray("PHOENIX_ARRIVAL_DONATE_REWARD", nil)
	itemDesRead = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "weight"
	self.rewardList = serviceFunctions.tableFormat(rewardArray, nil)
	self.fields.List:setNumItems(#self.rewardList)
	local itemID = activityCommonDrawCtrl:getItemID(self.activityID)
	local itemName = itemDesRead.getName(itemID)
	_ENV = nil
	;(nil).item = itemName
	self.fields.Text_des:setString(i18n("phoenix_arrival_text_02", nil))
end
function Activity_9001640_RewardPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
return Activity_9001640_RewardPanel
