local gametop = gModuleMgr.getObject("gametop")
local expeditionCtrl = gametop.playertop_:getModule("expeditionCtrl")
local eventQuestRead = include("eventQuestRead")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local MAX_AWARD_NUM = 5
local eventExpedtionSingle = class("eventExpedtionSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventExpedtionSingle")
	end
	return target
end)
function eventExpedtionSingle:ctor()
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
function eventExpedtionSingle:initData(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
		self.activityID = otherData.activityID
	end
	local lang = self.data.taskDes[1]
	local targetNum = self.data.taskDes.num or self.data.taskDes.count
	local targetLevel = self.data.taskDes.lv
	_ENV = nil
	;(nil).num = targetNum and string.formatnumberthousands(targetNum) or ""
	;(nil).count = targetNum and string.formatnumberthousands(targetNum) or ""
	_ENV, _ENV, (nil).lv = targetNum, targetLevel or "", targetLevel or ""
	targetNum.color = "#ffff00"
	_ENV, (targetLevel or "").num, targetNum.i = targetNum, targetNum, "true"
	targetNum.color = "#ffff00"
	_ENV, (targetLevel or "").count, targetNum.i = targetNum, targetNum, "true"
	targetNum.color = "#ffff00"
	_ENV, (targetLevel or "").lv, targetNum.i = targetNum, targetNum, "true"
	;(targetLevel or "").__default, targetNum.color = targetNum, "#d7c39b"
	local str_des = i18n_html(lang, nil, targetLevel or "")
	self.Text_des:setString(str_des)
	self.taskStatus, self.amount = expeditionCtrl:getQuestStatus(self.data.taskID)
	local total = eventQuestRead.getAim(self.data.taskID)
	local amount = self.taskStatus == gBtnTargetStatusDef.GO and math.min(self.amount, total) or total
	_ENV = nil
	;(nil).count = amount
	_ENV, (nil).total = nil, total
	if total <= amount then
		_ENV = nil
		;(nil).color = "#d7c39b"
		if nil then
			goto lbl_112
		end
	end
	_ENV = nil
	_ENV, (nil).count, (nil).color = nil, nil, "#be2828"
	::lbl_112::
	_ENV, (nil).total, (nil).color = nil, nil, "#d7c39b"
	;(nil).__default, (nil).color = nil, "#d7c39b"
	self.Text_schedule:setString(i18n_html("common_text_3683", nil, nil))
	self:setBtnStatus()
	self:setAward()
end
function eventExpedtionSingle:setBtnStatus()
	self.Button_go:setBright(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.Button_go:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or self.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.Button_go:setTitleColor(self.taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	self.Button_go:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GOT and "btn_gray_small.png" or self.taskStatus == gBtnTargetStatusDef.GO and "btn_blue_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
end
function eventExpedtionSingle:setAward()
	local reward = eventQuestRead.getReward(self.data.taskID)
	for k, v in ipairs(reward) do
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
function eventExpedtionSingle:btnOperateClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.taskStatus == gBtnTargetStatusDef.GET then
			SoraDShowLoading(self.view)
			expeditionCtrl:sendGetRewardMsg(self.data.taskID)
		elseif self.taskStatus == gBtnTargetStatusDef.GO then
			self:skipTo(self.data.taskID, i18n(self.data.taskDes))
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
function eventExpedtionSingle:skipTo(taskID, des)
	if taskID == 4206006 or taskID == 4206007 or taskID == 4206008 then
		mildGuideManager = nil
		;(nil).bid = BUILDID.CHARIOT_PLANT
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	else
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD, nil)
	end
	SoraDShowMsgTip(des)
	SoraDRemoveAllPanelFromManager()
end
return eventExpedtionSingle
