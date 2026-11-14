local newLotteryRead = include("newLotteryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001564_PreawardPanel = class("Activity_9001564_PreawardPanel", baseFguiPanel)
function Activity_9001564_PreawardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001564_PreawardPanel:ctor", self.viewName)
end
function Activity_9001564_PreawardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001564_PreawardPanel:onInit()
	print("=======Activity_9001564_PreawardPanel:onInit")
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001564
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.config = newLotteryRead.getPreAwardByActivityID(self.activityID, SoraDGetCtrl("activity_9001564_Ctrl"):getClassType())
	dump(self.config, "config")
	self.fields.List:setNumItems(#self.config)
end
function Activity_9001564_PreawardPanel:onShow()
	print("=======Activity_9001564_PreawardPanel:onShow")
end
function Activity_9001564_PreawardPanel:onItemRederer(index, target)
	target:initData(self.config[index + 1])
end
return Activity_9001564_PreawardPanel
