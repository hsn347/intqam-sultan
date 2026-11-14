local gametop = gModuleMgr.getObject("gametop")
local crossDecryptionCtrl = gametop.playertop_:getModule("crossDecryptionCtrl")
local crossDecryptionRead = include("crossDecryptionRead")
_ENV = "crossDecryptionRead"
;("crossDecryptionRead").DOING = 1
;("crossDecryptionRead").COMLIETE = 2
local ("crossDecryptionRead").COMLIETE_DONE, taskStatus = 3, "crossDecryptionRead"
local decryptionPopView = class("decryptionPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("decryptionPopView")
	end
	return target
end)
function decryptionPopView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.text_task = SoraDGetChildByName(self, "Text_task")
	self.text_rewards = SoraDGetChildByName(self, "Text_rewards")
	self.text_progress = SoraDGetChildByName(self, "Text_count")
	self.progress = SoraDGetChildByName(self, "LoadingBar_progress")
	self.btn_operate = SoraDGetChildByName(self, "Button_operate")
	self.node_rewards = SoraDGetChildByName(self, "Node_rewards")
	self.text_rewards:setString(i18n("decrypt_text_03"))
	self.btn_operate:addTouchEventListener(handler(self, self.btnOperateClick))
end
function decryptionPopView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_CROSS_UPDATE_TASK", function(...)
		print("decryptionPopView reflashView ------")
		self:reflashView()
		SoraDCloseLoading(self.btn_operate)
	end)
end
function decryptionPopView:initData(data, ctrl, crossDecryptionRead)
	self.taskdata = data
	ctrl = {}
	if not crossDecryptionRead.getTaskDesByID(data.taskID) then
		crossDecryptionCtrl = crossDecryptionRead.getTaskDesByID(data.taskID)
	end
	self.taskDes = crossDecryptionRead.getTaskDesByID(data.taskID)
	dump(self.taskdata, " decryptionPopView:initData===taskdata", 10)
	dump(self.taskDes)
	if not crossDecryptionRead.getTaskInfoByID(data.taskID) then
		crossDecryptionCtrl = crossDecryptionRead.getTaskInfoByID(data.taskID)
	end
	self.taskDetail = crossDecryptionRead.getTaskInfoByID(data.taskID)
	dump(self.taskDetail, " decryptionPopView:initData===taskDetail", 10)
	self.ccs_bg:setTitleName(i18n("decrypt_text_02"))
	if isnumber(self.taskDes.Describe.num) and self.taskDes.Describe.num and self.taskDes.Describe.num >= 1000 then
		self.taskDes.Describe.num = string.formatnumberthousands(self.taskDes.Describe.num)
		self.text_task:setString(i18n(self.taskDes.Describe))
	else
		self.text_task:setString(i18n(self.taskDes.Describe))
	end
	self.taskCondition = crossDecryptionRead.getTaskCondition(self.taskDetail.Conditiontype)
	dump(self.taskCondition, " decryptionPopView:initData===taskCondition", 10)
	self:reflashView()
	self:initTaskRewards(self.taskDetail.Taskreward)
end
function decryptionPopView:reflashView()
	print("decryptionPopView reflashView ------")
	self.taskdata = crossDecryptionCtrl:getTaskDataByID(self.taskdata.taskID)
	self.text_progress:setString(string.formatnumberthousands(self.taskdata.curNum) .. "/" .. string.formatnumberthousands(self.taskDetail.Conditionnum))
	self.progress:setPercent(self.taskdata.curNum / self.taskDetail.Conditionnum * 100)
	self.btn_operate:setBright(true)
	self.btn_operate:setTouchEnabled(true)
	if self.taskdata.taskStatus == taskStatus.COMLIETE then
		self.btn_operate:setTitleColor(cc.c3b(255, 255, 255))
		SoraChangeButtonImage(self.btn_operate, "btn_green_normal_01.png")
		self.btn_operate:setTitleText(i18n("common_text_854"))
	elseif self.taskdata.taskStatus == taskStatus.DOING then
		self.btn_operate:setTitleColor(cc.c3b(255, 255, 255))
		SoraChangeButtonImage(self.btn_operate, "btn_blue_normal_01.png")
		self.btn_operate:setTitleText(i18n("common_text_477"))
		if not self.taskCondition.questType then
			self.btn_operate:setVisible(false)
		end
	elseif self.taskdata.taskStatus == taskStatus.COMLIETE_DONE then
		self.btn_operate:setTitleColor(cc.c3b(255, 255, 255))
		self.btn_operate:setBright(false)
		self.btn_operate:setTouchEnabled(false)
		SoraChangeButtonImage(self.btn_operate, "btn_blue_normal_01.png")
		self.btn_operate:setTitleText(i18n("common_text_1892"))
	end
end
function decryptionPopView:initTaskRewards(rewards)
	for k, v in ipairs(rewards) do
		local single = SoraDCreatePanel("commonItemAward")
		single:addTo(self.node_rewards)
		single:setScale(0.8)
		single:setBaseScale(1.0)
		local pos = -230 + k * 90
		if SoraDFIsRA() then
			pos = 230 - k * 90
		end
		single:setPositionX(pos)
		single:setPositionY(0)
		single:setOwnView(self)
		single:initData(v.id, v.count)
	end
end
function decryptionPopView:btnOperateClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local taskID = self.taskdata.taskID
		if self.taskdata.taskStatus == taskStatus.COMLIETE then
			local loading = SoraDShowLoading(sender, sender:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
			_ENV = cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2)
			cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2).taskID = self.taskdata.taskID
			crossDecryptionCtrl:reqCommitTask(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
			self:close(sender, event)
		elseif self.taskdata.taskStatus == taskStatus.DOING then
			if self.taskCondition.questType then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local qtype = self.taskCondition.questType
				if self.taskCondition.taskType == "gNewPLayerTaskType" then
					mildGuideManager:starMildByNewPlayerQuestID(qtype, self.taskCondition)
				elseif self.taskCondition.taskType == "gEverydayTaskType" then
					mildGuideManager:starMildByEverydayTaskID(qtype, self.taskCondition)
				end
			end
			SoraDShowMsgTip(i18n(self.taskDes.Describe))
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return decryptionPopView
