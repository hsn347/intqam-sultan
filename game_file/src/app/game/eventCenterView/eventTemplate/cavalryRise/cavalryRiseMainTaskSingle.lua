local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = SoraDGetCtrl("cavalryRiseCtrl")
local cavalryRiseUtil = include("cavalryRiseUtil")
local cavalryRiseMainTaskSingle = class("cavalryRiseMainTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("cavalryRiseMainTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
function cavalryRiseMainTaskSingle:ctor()
	self.Node_got = SoraDGetChildByName(self, "Node_got")
	self.Text_got = SoraDGetChildByName(self, "Text_got")
	self.Text_got:setString(i18n("common_text_2601"))
	self.awardOffsetY = 61
end
function cavalryRiseMainTaskSingle:initData(data, otherData)
	if otherData then
		self.mainView = otherData.mainView
	end
	local taskID = data.taskID
	data.count = cavalryRiseUtil:getTaskProgress(taskID)
	data.total = cavalryRiseUtil:getTaskAmount(taskID)
	data.taskStatus = cavalryRiseUtil:getTaskStatus(taskID)
	self:initData_imp(data, otherData)
	if data.taskStatus == gBtnTargetStatusDef.GOT then
		self.Node_got:setVisible(true)
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
		self.Node_got:setVisible(false)
	end
end
function cavalryRiseMainTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.mainView)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:reqRuestClaimReward(taskID, gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY)
end
function cavalryRiseMainTaskSingle:skipTo(taskDes)
	local data = self.data
	cavalryRiseUtil:skipTo(data, taskDes)
end
return cavalryRiseMainTaskSingle
