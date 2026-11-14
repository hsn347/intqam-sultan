local gametop = gModuleMgr.getObject("gametop")
local smeltCtrl = SoraDGetCtrl("smeltCtrl")
local eventQuestRead = include("eventQuestRead")
local questDesRead = include("questDesRead")
_ENV = "questDesRead"
;("questDesRead").FINISH = 1
;("questDesRead").UNCOMPLETE = 2
local ("questDesRead").RECEIVE, TaskStatus = 3, "questDesRead"
local smeltTaskPopView = class("smeltTaskPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("smeltTaskPopView")
	end
	return target
end)
function smeltTaskPopView:ctor()
	self:initWidget()
	self:initData()
end
function smeltTaskPopView:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("Smelt_text_43"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.tipNode = SoraDGetChildByName(self, "Image_task_tip")
	self.textTip = SoraDGetChildByName(self, "Text_task_tip")
	self.textTip:setString(i18n("task_text_02"))
end
function smeltTaskPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_DATA", handler(self, self.initData))
end
function smeltTaskPopView:initData()
	self.taskList = smeltCtrl:getTasks()
	smeltCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(538, 135), self.taskList, 1, nil)
	local task = self.taskList[1]
	self.tipNode:setVisible(false)
	self.scroll:setContentSize(cc.size(538, 573))
	if task then
		local taskCfg = eventQuestRead.getTaskConfig(task.taskID)
		if taskCfg and taskCfg.type == 1 then
			self.tipNode:setVisible(true)
			self.scroll:setContentSize(cc.size(538, 533))
		end
	end
end
function smeltTaskPopView:createSingle()
	local single = self.Node_single:clone()
	SoraDGetAllChildFromWidget(single, single)
	single.Text_des = _G.SoraDChangeTextToHtml(single.Text_des)
	single.Button_go:setTitleText(i18n("alliance_btn_02"))
	SoraDAutoSizeButtonTextByContent(single.Button_go)
	single.Button_go:addTouchEventListener(handler(self, self.btnGoClick))
	single.Node_got = SoraDGetChildByName(single, "Node_got")
	single.Text_got = SoraDGetChildByName(single, "Text_got")
	single.Text_got:setString(i18n("common_text_1892"))
	single.awardArray, _ENV = single.Text_got.setString, single.Text_got.setString
	single.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(single, "Text_player"))
	return single
end
function smeltTaskPopView:btnGoClick(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if button.data.status == TaskStatus.FINISH then
			local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
			activityTaskComponentCtrl:reqRuestClaimReward(button.data.taskID, gActivityTimeActivityID.SMELT_ACTIVITY)
		else
			local guideId = eventQuestRead.getGuideId(button.data.taskID)
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local tbParam = mildGuideManager:splitGuideParam(guideId)
			if tbParam.id == gNewPLayerTaskType.POP_TIP then
				SoraDShowMsgTip(i18n(taskDes))
			end
			if guideId then
				local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
				if not notNeedClose then
					SoraDRemoveAllPanelFromManager()
				end
			end
		end
	end
end
function smeltTaskPopView:refreshSingle(single, data, otherData)
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
		self.scroll = otherData.scroll
		self.activityID = otherData.activityID
	end
	local taskID = data.taskID
	local status = data.status
	local progress = data.progress
	eventQuestRead, eventQuestRead, single.Button_go.data = nil, single.Button_go, data
	;(nil).color = "#ffff00"
	eventQuestRead, single.Button_go.num, (nil).i = nil, nil, "true"
	single.Button_go.__default, (nil).color = nil, "#d7c39b"
	local styles = single.Button_go
	single.Text_des:setString(eventQuestRead.getDesEx(taskID, styles))
	local targetStr = eventQuestRead.getAim(taskID)
	if type(targetStr) == "number" then
		if progress > targetStr then
			progress = targetStr
		end
		targetStr = string.formatnumberthousands(targetStr)
	end
	eventQuestRead = eventQuestRead.getDesEx(taskID, styles)
	eventQuestRead.getDesEx(taskID, styles).count = string.formatnumberthousands(progress)
	eventQuestRead, eventQuestRead.getDesEx(taskID, styles).total = string.formatnumberthousands(progress), targetStr
	if status == TaskStatus.FINISH then
		eventQuestRead = TaskStatus.FINISH
		TaskStatus.FINISH.color = "#d7c39b"
		if TaskStatus.FINISH then
			goto lbl_68
		end
	end
	eventQuestRead = TaskStatus.FINISH
	eventQuestRead, string.formatnumberthousands(progress).count, TaskStatus.FINISH.color = TaskStatus.FINISH, TaskStatus.FINISH, "#be2828"
	::lbl_68::
	eventQuestRead, string.formatnumberthousands(progress).total, TaskStatus.FINISH.color = TaskStatus.FINISH, TaskStatus.FINISH, "#d7c39b"
	string.formatnumberthousands(progress).__default, TaskStatus.FINISH.color = TaskStatus.FINISH, "#d7c39b"
	single.Text_schedule:setString(i18n_html("common_text_3683", eventQuestRead.getDesEx(taskID, styles)))
	single.Node_got:setVisible(status == TaskStatus.RECEIVE)
	single.Button_go:setVisible(status ~= TaskStatus.RECEIVE)
	local btnTitle = status == TaskStatus.UNCOMPLETE and i18n("common_text_477") or status == TaskStatus.FINISH and i18n("common_text_1146") or i18n("common_text_1892")
	single.Button_go:setTitleText(btnTitle)
	single.Button_go:setTitleColor(status == TaskStatus.RECEIVE and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	if status == TaskStatus.RECEIVE then
		single.Button_go:loadTextures("btn_gray_small.png", "btn_gray_small.png", "btn_gray_small.png", ccui.TextureResType.plistType)
	elseif status == TaskStatus.UNCOMPLETE then
		single.Button_go:loadTextures("btn_yellow_small_01.png", "btn_yellow_small_01.png", "btn_yellow_small_01.png", ccui.TextureResType.plistType)
	else
		single.Button_go:loadTextures("btn_green_small_01.png", "btn_green_small_01.png", "btn_green_small_01.png", ccui.TextureResType.plistType)
	end
	local MAX_AWARD_NUM = 5
	local rewards = eventQuestRead.getReward(taskID)
	for i, v in ipairs(single.awardArray) do
		v:setVisible(false)
	end
	local awardOffsetY = 45
	local itemWidth = 538
	local rewardOffsetX = 50
	local itemSepX = 69
	local itemScale = 0.65
	for k, v in ipairs(rewards) do
		local award = single.awardArray[k]
		if not award and k <= MAX_AWARD_NUM then
			award = include("commonItemAward").new()
			award:setScale(itemScale)
			award:setOwnView(self.view)
			award:setOwnScroll(self.scroll)
			award:setScroll(self.scroll)
			award:setPosition(SoraDFPosX(itemWidth - (rewardOffsetX + (k - 1) * itemSepX), itemWidth), awardOffsetY)
			award:addTo(single, 1)
			single.awardArray[k] = award
		end
		if award then
			award:initData(v.id, v.count)
			award:setVisible(k <= MAX_AWARD_NUM)
		end
	end
end
return smeltTaskPopView
