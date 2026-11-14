local crossDecryptionRead = include("crossDecryptionRead")
local crossDecryptionCtrl = SoraDGetCtrl("anniversaryCrossDecryptionCtrl")
_ENV = "anniversaryCrossDecryptionCtrl"
;("anniversaryCrossDecryptionCtrl").DOING = 1
;("anniversaryCrossDecryptionCtrl").COMLIETE = 2
local ("anniversaryCrossDecryptionCtrl").COMLIETE_DONE, taskStatus = 3, "anniversaryCrossDecryptionCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DecryptionRewardPopPanel = class("DecryptionRewardPopPanel", baseFguiPanel)
function DecryptionRewardPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DecryptionRewardPopPanel:ctor", self.viewName)
end
function DecryptionRewardPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DecryptionNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function DecryptionRewardPopPanel:onInit()
	print("=======DecryptionRewardPopPanel:onInit")
	if self.param.activityID and self.param.activityID == gActivityTimeActivityID.CROSS_MISSION_2022_ACTIVITY then
	end
	self.param = self.param.taskData
	self.fields.Text_tip:setString(i18n("decrypt_text_03"))
	self.fields.bg:setTitle(i18n("decrypt_text_02"))
	self.fields.Btn_reward:addClickListener(handler(self, self.onClick))
	self.fields.bar:fixChildrenPos()
end
function DecryptionRewardPopPanel:onShow()
	print("=======DecryptionRewardPopPanel:onShow")
	self.taskDetail = crossDecryptionRead.getTaskDesByID(self.param.taskID)
	local numStr = self.taskDetail.Describe.num
	if type(self.taskDetail.Describe.num) == "number" then
		numStr = string.formatnumberthousands(self.taskDetail.Describe.num)
	end
	_ENV = nil
	;(nil).num = numStr
	self.fields.Text_des:setString(i18n(self.taskDetail.Describe[1], nil))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	local taskInfo = crossDecryptionRead.getTaskInfoByID(self.param.taskID)
	self.itemList = taskInfo.Taskreward
	self.fields.List_award:setNumItems(#self.itemList)
	self.fields.bar:setMax(taskInfo.Conditionnum)
	self.fields.bar:setPercent(self.param.curNum / taskInfo.Conditionnum)
	_ENV = handler(self, self.onItemRenderer)
	handler(self, self.onItemRenderer).member = string.formatnumberthousands(self.param.curNum)
	handler(self, self.onItemRenderer).total = string.formatnumberthousands(taskInfo.Conditionnum)
	self.fields.Text_pro:setString(i18n("common_text_155", handler(self, self.onItemRenderer)))
	self.taskCondition = crossDecryptionRead.getTaskCondition(self.taskDetail.Conditiontype)
	if self.param.taskStatus == taskStatus.COMLIETE_DONE then
		self.fields.Btn_reward:setTitleText(i18n("common_text_1892"))
		self.fields.Btn_reward:setEnabled(false)
	elseif self.param.taskStatus == taskStatus.DOING then
		self.fields.Btn_reward:setTitleText(i18n("common_text_477"))
		self.fields.Btn_reward:setEnabled(true)
	elseif self.param.taskStatus == taskStatus.COMLIETE then
		self.fields.Btn_reward:setTitleText(i18n("common_text_1146"))
		self.fields.Btn_reward:setEnabled(true)
	end
end
function DecryptionRewardPopPanel:onHide()
	print("=======DecryptionRewardPopPanel:onHide")
end
function DecryptionRewardPopPanel:onDispose()
	print("=======DecryptionRewardPopPanel:onDispose")
end
function DecryptionRewardPopPanel:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function DecryptionRewardPopPanel:onClick()
	SoraDPlaySound()
	local taskID = self.param.taskID
	if self.param.taskStatus == taskStatus.COMLIETE then
		_ENV = nil
		;(nil).taskID = self.param.taskID
		crossDecryptionCtrl:reqCommitTask(nil)
		self:close()
	elseif self.param.taskStatus == taskStatus.DOING then
		if self.taskCondition.questType then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local qtype = self.taskCondition.questType
			if self.taskCondition.taskType == "gNewPLayerTaskType" then
				mildGuideManager:starMildByNewPlayerQuestID(qtype, self.taskCondition)
			elseif self.taskCondition.taskType == "gEverydayTaskType" then
				mildGuideManager:starMildByEverydayTaskID(qtype, self.taskCondition)
			end
		end
		local describe = self.taskDetail.Describe
		SoraDShowMsgTip(i18n(describe))
		SoraDRemoveAllPanelFromManager()
	end
end
return DecryptionRewardPopPanel
