local gametop = gModuleMgr.getObject("gametop")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local everydayTaskRead = include("everydayTaskRead")
local MAX_AWARD_NUM = 5
local wishingTaskSingleView = class("wishingTaskSingleView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("wishingTaskSingleView")
	end
	return target
end)
function wishingTaskSingleView:ctor()
	self.awardArray, _ENV, self.data, _ENV = nil, nil, nil, nil
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.text_progress_title = SoraDGetChildByName(self, "text_progress_title")
	self.text_progress_value = SoraDGetChildByName(self, "text_progress_value")
	self.text_title = SoraDGetChildByName(self, "text_goldValue")
	self.text_title = SoraDChangeTextToHtml(self.text_title)
	self.text_progress_value = SoraDChangeTextToHtml(self.text_progress_value)
	self.text_progress_title:setString(i18n("common_text_3780"))
	self.btn_operate:addTouchEventListener(handler(self, self.onClick_btn_operate))
	self.btn_operate:setSwallowTouches(false)
	self.btn_operate:setTouchEnabled(true)
end
function wishingTaskSingleView:initData(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
		self.activityID = otherData.activityID
	end
	self.taskStatus = self.data.taskStatus
	local amount = self.data.count
	local total = self.data.total
	local color = cc.c3b(170, 150, 130)
	if amount < total then
		color = cc.c3b(255, 0, 0)
	elseif self.taskStatus == gBtnTargetStatusDef.GET then
		color = cc.c3b(0, 255, 0)
	end
	local lang = self.data.taskDes[1] or ""
	local targetNum = self.data.taskDes.num
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, targetNum or "", targetNum or ""
	;(nil).color = "#ffff00"
	_ENV, (targetNum or "").num, (nil).i = nil, nil, "true"
	;(targetNum or "").__default, (nil).color = nil, "#AA9682"
	local str_des = _G.i18n_html(lang, nil, targetNum or "")
	self.text_title:setString(str_des)
	_ENV = str_des
	str_des.member = SoraDConvertNumberWithUnit(amount)
	_ENV, _ENV, str_des.total = total, SoraDConvertNumberWithUnit(total), SoraDConvertNumberWithUnit(total)
	_ENV, SoraDConvertNumberWithUnit(total).member, total.color = total, total, color
	SoraDConvertNumberWithUnit(total).__default, total.color = total, "#AA9682"
	local strSchedul = i18n_html("common_text_155", str_des, (SoraDConvertNumberWithUnit(total)))
	self.text_progress_value:setString(strSchedul)
	self:setBtnStatus()
	self:setAward()
end
function wishingTaskSingleView:setBtnStatus()
	self.btn_operate:setVisible(self.data.isAct ~= 0 or self.taskStatus ~= gBtnTargetStatusDef.GO)
	self.btn_operate:setBright(self.taskStatus ~= gBtnTargetStatusDef.GOT)
	self.btn_operate:setTitleText(self.taskStatus == gBtnTargetStatusDef.GO and i18n("common_text_477") or self.taskStatus == gBtnTargetStatusDef.GET and i18n("common_text_1146") or self.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892"))
	self.btn_operate:setTitleColor(self.taskStatus == gBtnTargetStatusDef.GOT and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255))
	self.btn_operate:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GOT and "btn_gray_small.png" or self.taskStatus == gBtnTargetStatusDef.GO and "btn_blue_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
	SoraDAutoSizeButtonText(self.btn_operate, cc.size(120, 40))
end
function wishingTaskSingleView:setAward()
	for k, v in ipairs(self.data.award) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(630 - (60 + (k - 1) * 90)), 60)
			self.awardArray[k]:addTo(self)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
end
function wishingTaskSingleView:onClick_btn_operate(button, event)
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
			activityTaskComponentCtrl:reqRuestClaimReward(self.data.taskID, self.activityID)
		elseif self.taskStatus == gBtnTargetStatusDef.GO then
			self:skipTo()
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
function wishingTaskSingleView:skipTo(taskID, des)
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(self.data.guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(self.data.taskDes))
	end
	local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
	if not notNeedClose then
		SoraDRemoveAllPanelFromManager()
	end
end
return wishingTaskSingleView
