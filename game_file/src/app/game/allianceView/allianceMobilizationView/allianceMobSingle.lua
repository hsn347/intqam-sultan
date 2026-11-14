local MAX_AWARD_NUM = 5
local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local allianceMobSingle = class("allianceMobSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMobSingle")
	end
	return target
end)
function allianceMobSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Node_action = SoraDGetChildByName(self, "Node_action")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	SoraDAutoSizeButtonText(self.Button_go, cc.size(120, 50))
	self.Button_go:addTouchEventListener(handler(self, self.onBtnGoClick))
end
function allianceMobSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.view = otherData.view
	if self.data.des[1] == "NA" then
		self.Text_des:setString(self.data.des[1])
	else
		local numStr = self.data.target
		if type(self.data.target) == "number" then
			numStr = string.formatnumberthousands(self.data.target)
		end
		_ENV = nil
		;(nil).num = numStr
		_ENV, _ENV, (nil).lv = nil, self.data.lv, self.data.lv
		;(nil).color = "#ffff00"
		_ENV, self.data.lv.num, (nil).i = nil, nil, "true"
		;(nil).color = "#ffff00"
		_ENV, self.data.lv.lv, (nil).i = nil, nil, "true"
		self.data.lv.__default, (nil).color = nil, "#d7c39b"
		self.Text_des:setString(i18n_html(self.data.des[1], nil, self.data.lv))
	end
	local targetStr = self.data.target
	if type(self.data.target) == "number" then
		targetStr = string.formatnumberthousands(self.data.target)
	end
	_ENV = i18n_html(self.data.des[1], nil, self.data.lv)
	i18n_html(self.data.des[1], nil, self.data.lv).count = string.formatnumberthousands(self.data.curnum)
	_ENV, i18n_html(self.data.des[1], nil, self.data.lv).total = string.formatnumberthousands(self.data.curnum), targetStr
	if self.data.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
		_ENV = self.data.taskstatus
		self.data.taskstatus.color = "#d7c39b"
		if self.data.taskstatus then
			goto lbl_96
		end
	end
	_ENV = self.data.taskstatus
	_ENV, string.formatnumberthousands(self.data.curnum).count, self.data.taskstatus.color = self.data.taskstatus, self.data.taskstatus, "#be2828"
	::lbl_96::
	_ENV, string.formatnumberthousands(self.data.curnum).total, self.data.taskstatus.color = self.data.taskstatus, self.data.taskstatus, "#d7c39b"
	string.formatnumberthousands(self.data.curnum).__default, self.data.taskstatus.color = self.data.taskstatus, "#d7c39b"
	self.Text_schedule:setString(i18n_html("common_text_3683", i18n_html(self.data.des[1], nil, self.data.lv)))
	self.taskStatus = gBtnTargetStatusDef.GO
	if self.data.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
		self.taskStatus = gBtnTargetStatusDef.GET
	end
	if tonumber(self.data.isTurn) == 0 and self.taskStatus ~= gBtnTargetStatusDef.GET then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
	self:setBtnStatus()
	self:setAward()
end
function allianceMobSingle:setBtnStatus()
	self.Button_go:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or i18n("common_text_1146"))
	self.Button_go:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GO and "btn_blue_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
end
function allianceMobSingle:refreshAction()
	self.Node_action:setScaleY(1.0)
	_UPVALUE1_ = self.Node_action
	self.Node_action[1] = cca.scaleTo(0.2, 1.0, 0)
	self.Node_action[2] = cca.scaleTo(0.2, 1.0, 1.0)
	self.Node_action[3] = cca.scaleTo(0.2, 1.0, 1.0)
	self.Node_action[4] = cca.scaleTo(0.2, 1.0, 1.0)
	self.Node_action[5] = cca.scaleTo(0.2, 1.0, 1.0)
	local action = cca.seq(self.Node_action)
	self.Node_action:runAction(action)
end
function allianceMobSingle:setAward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local awardList = serviceFunctions.tableFormat(self.data.award, nil)
	for k, v in ipairs(awardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(0, 0)
			self.awardArray[k]:addTo(self.Node_items)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	SoraDautoSortPos(self.Node_items, MAX_AWARD_NUM, SoraDFIsRA() and 2 or 0, cc.size(90, 90))
end
function allianceMobSingle:onBtnGoClick(button, event)
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
			playerMobilizationCtrl:reqMissionComplete(self.data.tasktypeid)
			self:refreshAction()
		elseif self.taskStatus == gBtnTargetStatusDef.GO then
			local guideId = mobilizationltCtrl:getGuideId(self.data.tasktypeid)
			if guideId then
				local ret = mildGuideManager:starMildByNewPlayerStringParam(guideId)
				if ret ~= false then
					SoraDRemoveAllPanelFromManager()
				end
			end
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
return allianceMobSingle
