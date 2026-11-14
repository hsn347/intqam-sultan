local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackWarTaskPop = class("sultansBackWarTaskPop", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("sultansBackWarTaskPop")
end)
function sultansBackWarTaskPop:ctor(properties)
	self.activityID = gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.scrollList = SoraDGetChildByName(self, "ScrollView_list")
	self.scrollList = include("commonAutoScrollList").new(self.scrollList)
	self.scrollList:setSingleCCS("sultansBackWarTaskSingle")
end
function sultansBackWarTaskPop:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateScroll))
end
function sultansBackWarTaskPop:initData(taskType)
	self.taskType = taskType
	local config = sultansBackRead.getBattleTaskConfigByIndex(taskType)
	self.nodeCommonPopBox:setTitleName(i18n(config.name))
	self:updateScroll()
end
function sultansBackWarTaskPop:updateScroll()
	SoraDCloseLoading(self)
	local taskList = sultansBackCtrl:getQuestData(self.activityID, self.taskType)
	_ENV = nil
	;(nil).scroll = self.scrollList
	;(nil).view = self
	self.scrollList:updateScrollView(cc.size(640, 143), taskList, 1, nil)
end
return sultansBackWarTaskPop
