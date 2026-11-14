local gametop = gModuleMgr.getObject("gametop")
local eventRushTaskCtrl = gametop.playertop_:getModule("eventRushTaskCtrl")
local MAX_AWARD_NUM = 5
local eventRushTaskSingle = class("eventRushTaskSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventRushTaskSingle")
	end
	return target
end)
function eventRushTaskSingle:ctor()
	self.awardArray, _ENV, self.data, _ENV = nil, nil, nil, nil
	self.taskStatus = gBtnTargetStatusDef.GO
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	SoraDAutoSizeButtonText(self.Button_go, cc.size(120, 50))
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.btnOperateClick))
	self.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
end
function eventRushTaskSingle:initData(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
	end
	local lang = self.data.taskDes[1]
	local targetNum = self.data.taskDes.num
	_ENV = nil
	_ENV, _ENV, (nil).num = targetNum, targetNum and string.formatnumberthousands(targetNum) or "", targetNum and string.formatnumberthousands(targetNum) or ""
	targetNum.color = "#ffff00"
	_ENV, (targetNum and string.formatnumberthousands(targetNum) or "").num, targetNum.i = targetNum, targetNum, "true"
	;(targetNum and string.formatnumberthousands(targetNum) or "").__default, targetNum.color = targetNum, "#d7c39b"
	local str_des = i18n_html(lang, nil, targetNum and string.formatnumberthousands(targetNum) or "")
	self.Text_des:setString(str_des)
	local severTaskData = eventRushTaskCtrl:getTaskData(data.amount, tostring(data.activityID))
	self.taskStatus = gBtnTargetStatusDef.GO
	if severTaskData.receive then
		self.taskStatus = gBtnTargetStatusDef.GOT
	elseif severTaskData.finishCount >= severTaskData.amount then
		self.taskStatus = gBtnTargetStatusDef.GET
	end
	local amount = severTaskData.finishCount
	local total = severTaskData.amount
	_ENV = tostring(data.activityID)
	tostring(data.activityID).count = amount
	_ENV, tostring(data.activityID).total = tostring(data.activityID)
	if amount >= total then
		_ENV = tostring(data.activityID)
		tostring(data.activityID).color = "#d7c39b"
		if tostring(data.activityID) then
			goto lbl_82
		end
	end
	_ENV = tostring(data.activityID)
	_ENV, tostring(data.activityID).count, tostring(data.activityID).color = tostring(data.activityID)
	::lbl_82::
	_ENV, tostring(data.activityID).total, tostring(data.activityID).color = tostring(data.activityID)
	tostring(data.activityID).__default, tostring(data.activityID).color = tostring(data.activityID)
	self.Text_schedule:setString(i18n_html("common_text_3683", tostring(data.activityID)))
	self:setBtnStatus()
	self:setAward()
end
function eventRushTaskSingle:setBtnStatus()
	self.Button_go:setBright(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTouchEnabled(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or self.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.Button_go:setTitleColor(self.taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	self.Button_go:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GOT and "btn_gray_small.png" or self.taskStatus == gBtnTargetStatusDef.GO and "btn_blue_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
end
function eventRushTaskSingle:setAward()
	for k, v in ipairs(self.data.award) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(640 - (60 + (k - 1) * 90)), 70)
			self.awardArray[k]:addTo(self)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
end
function eventRushTaskSingle:btnOperateClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local taskID = self.data.taskID
		if self.taskStatus == gBtnTargetStatusDef.GET then
			SoraDShowLoading(self.view)
			_ENV = nil
			;(nil).activityID = self.data.activityID
			;(nil).amount = self.data.amount
			eventRushTaskCtrl:reqCommitTask(nil)
		elseif self.taskStatus == gBtnTargetStatusDef.GO then
			self:skipTo(self.data.taskDes)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function eventRushTaskSingle:skipTo(taskDes)
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if tostring(self.data.activityID) == gEventRushActivityID.developmentRush then
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil)
	elseif tostring(self.data.activityID) == gEventRushActivityID.trainRush then
		_ENV = nil
		;(nil).bid = BUILDID.CHARIOT_PLANT
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	else
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		if currentView.__cname == "worldMapView" then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_CITY
			SoraDSendMessage(nil)
		end
	end
	SoraDShowMsgTip(i18n(taskDes))
	SoraDRemoveAllPanelFromManager()
end
return eventRushTaskSingle
