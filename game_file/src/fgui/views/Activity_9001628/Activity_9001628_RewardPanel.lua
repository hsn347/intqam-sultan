local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001628_RewardPanel = class("Activity_9001628_RewardPanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local activity_9001628_Ctrl = gametop.playertop_:getModule("activity_9001628_Ctrl")
function Activity_9001628_RewardPanel:ctor(...)
	Activity_9001628_RewardPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001628_RewardPanel:ctor", self.viewName)
end
function Activity_9001628_RewardPanel:onInit()
	print("=======Activity_9001628_RewardPanel:onInit")
	self.ccs_title = SoraDGetChildByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:initData(i18n("anniversary_dice_text_08"), handler(self, self.onClickClose))
	self.scroll = SoraDGetChildByName(self, "Top_Size_scroll")
	self.nodeSingle = SoraDGetChildByName(self, "node_single")
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001628_RewardPanel:updateView()
	self.taskList = activity_9001628_Ctrl:getSortedTaskList()
	self.fields.list:setNumItems(#self.taskList)
end
function Activity_9001628_RewardPanel:onShow()
	print("=======Activity_9001628_RewardPanel:onShow")
	self:updateView()
end
function Activity_9001628_RewardPanel:buttonGetRewardCallBack(uniqueID, taskType)
	SoraDPlaySound()
	if uniqueID ~= 0 and taskType ~= 0 then
		activity_9001628_Ctrl:reqGetRewardMsg(taskType, uniqueID)
		SoraDShowLoading(self)
	end
end
function Activity_9001628_RewardPanel:onItemRenderer(index, obj)
	local data = self.taskList[index + 1]
	obj:initData(data)
	obj:setClickHandler(handler(self, self.buttonGetRewardCallBack))
end
return Activity_9001628_RewardPanel
