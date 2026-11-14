local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local sinbadTreasureRead = include("sinbadTreasureRead")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local sinbadTreasureTaskView = class("sinbadTreasureTaskView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sinbadTreasureTaskView")
	end
	return target
end)
function sinbadTreasureTaskView:ctor()
	self:initWidget()
	self:fitDevice()
	self:initScroll()
end
function sinbadTreasureTaskView:fitDevice()
	self.Panel_cut:setPositionY(display.height / 2)
end
function sinbadTreasureTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", function(target, data)
		SoraDCloseLoading(self)
		self:initScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", function(target, data)
		self:initScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", function(target, data)
		self:initScroll()
	end)
end
function sinbadTreasureTaskView:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.activityID = gActivityTimeActivityID.SINBAD_TREASURE
	self.Text_name:setString(i18n("Sinbad_text_09"))
	self.Text_main:setString(i18n("task_text_02"))
	self.ScrollView_1 = SoraDCreatePanelByCloneNode(self.ScrollView_1, "commonAutoScrollList")
	self.ScrollView_1:setSingleCreate(handler(self, self.createSingle))
	self.Image_bg:setFillType(1)
end
function sinbadTreasureTaskView:initScroll()
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	activityTaskComponentCtrl = nil
	;(nil).scroll = self.Top_Size_scrollTask
	;(nil).view = self
	;(nil).activityID = self.activityID
	;(nil).mainView = self
	self.ScrollView_1:updateScrollView(cc.size(534, 125), self.taskList, 1, nil)
end
function sinbadTreasureTaskView:createSingle()
	local ocx = self.Node_single:clone()
	local Text_task = SoraDGetChildByName(ocx, "Text_task")
	local Text_progress = SoraDGetChildByName(ocx, "Text_progress")
	local Node_Finish = SoraDGetChildByName(ocx, "Node_Finish")
	local Button_go = SoraDGetChildByName(ocx, "Button_go")
	Button_go:setSwallowTouches(false)
	local Text_Finish = SoraDGetChildByName(ocx, "Text_Finish")
	local Button_detail = SoraDGetChildByName(ocx, "Button_detail")
	Button_detail:setSwallowTouches(false)
	Button_detail:addTouchEventListener(function(btn, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			SoraDShowHelpMsgTip(i18n("Sinbad_text_32"))
		end
	end)
	Text_task = SoraDChangeTextToHtml(Text_task)
	Text_progress = SoraDChangeTextToHtml(Text_progress)
	SoraDSetTextWidthHeight(Text_task, cc.size(300, 45))
	SoraDSetTextWidthHeight(Text_progress, cc.size(150, 45))
	Text_Finish:setString(i18n("common_text_1892"))
	function ocx.initData(target, data, otherData)
		dump(data, "data=======")
		local lan = data.taskDes[1]
		local curNum = data.count
		local taskStatus = data.taskStatus
		local guideID = data.guideId
		local taskID = data.taskID
		local rewardList = data.award
		local ruleID = data.ruleID
		local redColor = "#FF0000"
		_ENV = nil
		_ENV, _ENV, (nil).num = data.total, string.formatnumberthousands(data.total), string.formatnumberthousands(data.total)
		_ENV, string.formatnumberthousands(data.total).num, data.total.color = data.total, data.total, "#FFD246"
		string.formatnumberthousands(data.total).__default, data.total.color = data.total, "#D7C39B"
		Text_task:setString(i18n_html(lan, nil, (string.formatnumberthousands(data.total))))
		if guideID == "id:23" and ruleID == 177 then
			Button_detail:setVisible(true)
			Text_task:setPositionX(SoraDFPosX(485, 530))
		else
			Button_detail:setVisible(false)
			Text_task:setPositionX(SoraDFPosX(510, 530))
		end
		if curNum >= data.total then
			curNum = data.total
			redColor = "#D7C39B"
		end
		Button_go:setVisible(taskStatus ~= gBtnTargetStatusDef.GOT)
		Node_Finish:setVisible(curNum >= data.total and taskStatus == gBtnTargetStatusDef.GOT)
		_ENV = SoraDFPosX(510, 530)
		SoraDFPosX(510, 530).member = string.formatnumberthousands(curNum)
		_ENV, _ENV, SoraDFPosX(510, 530).total = data.total, string.formatnumberthousands(data.total), string.formatnumberthousands(data.total)
		_ENV, string.formatnumberthousands(data.total).member, data.total.color = data.total, data.total, redColor
		string.formatnumberthousands(data.total).__default, data.total.color = data.total, "#D7C39B"
		local strhtml = TextDirectionMarkStr.LRO .. "(" .. i18n_html("common_text_155", SoraDFPosX(510, 530)) .. ")"
		_ENV = string.formatnumberthousands(data.total)
		_ENV, _ENV, string.formatnumberthousands(data.total).value = SoraDFPosX(510, 530)
		data.total.__default, SoraDFPosX(510, 530).color = SoraDFPosX(510, 530)
		Text_progress:setString(i18n_html("complete_text_05", string.formatnumberthousands(data.total), data.total))
		Button_go:setBright(taskStatus ~= gBtnTargetStatusDef.GOT)
		Button_go:setTitleText(taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
		Button_go:setTitleColor(taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
		Button_go:loadTextureNormal(taskStatus == gBtnTargetStatusDef.GO and "btn_blue_small_01.png" or taskStatus == gBtnTargetStatusDef.GET and "btn_green_small_01.png" or "btn_gray_small.png", ccui.TextureResType.plistType)
		Button_go:addTouchEventListener(function(btn, eventType)
			if eventType == ccui.TouchEventType.ended then
				SoraDPlaySound()
				if taskStatus == gBtnTargetStatusDef.GET then
					local activityData = sinbadTreasureCtrl:getActivityData()
					local level = activityData.activityStage + 1
					if 1 < level then
						SoraDShowMsgTip(i18n("Sinbad_text_08"))
						SoraDRemoveAllExceptPanelFromManager(SoraDSearchPanelFromManagerByName("EventCenterView"))
						clientEventMgr.singleClickEvent(gActivityTimeActivityID.SINBAD_TREASURE)
						return
					end
					SoraDShowLoading(self)
					activityTaskComponentCtrl:reqRuestClaimReward(taskID, self.activityID)
				elseif taskStatus == gBtnTargetStatusDef.GO then
					if string.len(guideID) > 0 then
						local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
						local ret = mildGuideManager:starMildByNewPlayerStringParam(guideID)
						print("wekjrhwkejr", guideID, taskID)
						if guideID == "id:49" then
							local currentScene = display.getRunningScene()
							if currentScene.name == "MainScene" then
								local currentView = currentScene:currentSceneShowView()
								if currentView.__cname == "worldMapView" then
									_ENV = taskID
									taskID.msg = "MESSAGE_MAINSCEN_ONSHOW"
									taskID.viewType = VIEW_TYPE_CITY
									SoraDSendMessage(taskID)
								end
								SoraDRemoveAllPanelFromManager()
								return
							end
						end
						if ret ~= false and guideID ~= "id:44" then
							SoraDRemoveAllPanelFromManager()
						end
					else
						self.scroll:jumpToTop()
					end
				end
			end
		end)
		for i, v in ipairs(rewardList) do
			local rewardCell = include("commonItemAward").new()
			rewardCell:setScale(0.65)
			rewardCell:setBaseScale(1.0)
			rewardCell:setOwnView(self)
			rewardCell:initData(v.id, v.count)
			if SoraDFIsRA() then
				rewardCell:setPosition(485 - (i - 1) * 70, 45)
			else
				rewardCell:setPosition(50 + (i - 1) * 70, 45)
			end
			rewardCell:addTo(ocx, 1)
		end
	end
	return ocx
end
return sinbadTreasureTaskView
