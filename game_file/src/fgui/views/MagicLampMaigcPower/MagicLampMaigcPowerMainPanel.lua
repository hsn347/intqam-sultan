local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampSkillRead = include("magicLampSkillRead")
local publicRead = include("publicRead")
local MagicLampMaigcPowerMainPanel = class("MagicLampMaigcPowerMainPanel", baseFguiPanel)
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
local magicLampSkillLotteryRead = include("magicLampSkillLotteryRead")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
function MagicLampMaigcPowerMainPanel:ctor(...)
	self.debug = true
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.MAGIC_DRAW_ACTIVITY
	self.super.ctor(self, ...)
	print("MagicLampMaigcPowerMainPanel:ctor", self.viewName)
end
function MagicLampMaigcPowerMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
	end
	return self._packageList
end
function MagicLampMaigcPowerMainPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
		self.fields.Com_boxList:fixChildrenPos(true)
	end
	print("=======MagicLampMaigcPowerMainPanel:onInit")
	self.fields.Com_title:initData(i18n("Magic_draw_text_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btn_preview:addClickEventListener(handler(self, self.onPreviewClick))
	self.fields.btn_preview:setTitle(i18n("Magic_draw_text_10"))
	self.fields.btn_reward:addClickEventListener(handler(self, self.onRewardClick))
	self.fields.btn_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.Btn_daily:addClickEventListener(handler(self, self.onDailyClick))
	self.fields.Btn_daily:setTitle(i18n("datepalm_tree_text18"))
	self.fields.Com_moli:addClickEventListener(handler(self, self.onMoliClick))
	self.fields.btn_one:addClickEventListener(handler(self, self.onOneClick), 1)
	self.fields.btn_ten:addClickEventListener(handler(self, self.onTenClick), 5)
	_ENV = self.onTenClick
	self.onTenClick.num = 1
	self.fields.btn_one:setTitle(i18n("Magic_draw_text_03", self.onTenClick))
	_ENV = i18n("Magic_draw_text_03", self.onTenClick)
	i18n("Magic_draw_text_03", self.onTenClick).num = 5
	self.fields.btn_ten:setTitle(i18n("Magic_draw_text_03", i18n("Magic_draw_text_03", self.onTenClick)))
	self.fields.List_pool:setItemRenderer(handler(self, self.onPoolRenderer))
	self.fields.List_pool:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollItem))
	self.fields.List_pool:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.label_timer)
	self.text_time:setTimeEndListener(handler(self, self.updateView))
	self.text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("Magic_draw_text_06", nil)
	end)
	self.showCfgs = magicLampSkillLotteryRead.getShowCfgList()
	self.curPoolIndex = 1
	magicLampSkillLotteryCtrl:sendInitMsg()
end
function MagicLampMaigcPowerMainPanel:onShow()
	print("=======MagicLampMaigcPowerMainPanel:onShow")
	self.paramPoolID = self.proxy.param and self.proxy.param.magicPoolID or nil
	self:updatePoolList(true)
	self:updateView(true)
	self.transitions.t1:play()
end
function MagicLampMaigcPowerMainPanel:onIntoPanel(...)
	print("=======MagicLampMaigcPowerMainPanel:onIntoPanel")
	magicLampSkillCtrl:updateGuideSkill2()
end
function MagicLampMaigcPowerMainPanel:updateView(isInit)
	magicLampSkillLotteryCtrl = nil
	;(nil)[1] = self.curPoolIndex
	;(nil)[2] = #self.showList
	dump(nil, "MagicLampMaigcPowerMainPanel:updateView")
	self.curCfg = self.showList[self.curPoolIndex]
	if not self.curCfg then
		return
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local skillList = magicLampSkillCtrl:getSkillList()
	local max = magicLampSkillCtrl:getSkillStorageMax()
	self.max = max
	self.curNum = #skillList
	_ENV = nil
	;(nil).num = #skillList
	;(nil).max = max
	self.fields.Com_moli:setTitle(i18n("jinn_skill_8", nil))
	self.fields.List_pool:scrollToCenter(self.fields.List_pool:getChildAt(self.curPoolIndex), not isInit)
	self:onScrollItem()
	self.magicPoolID = self.curCfg.magicPoolID
	self.curData = magicLampSkillLotteryCtrl:getPoolData(self.magicPoolID)
	local poolLastTime
	if self.curCfg.activeTime >= 1 then
		self.isCurPoolUnlock = magicLampSkillLotteryCtrl:getIsPoolOpen(self.curCfg.magicPoolID)
		if self.isCurPoolUnlock then
			poolLastTime = activityShowCtrl:getEndTimeSecond(self.activityID) - serviceFunctions.systemTime()
		end
	end
	self.isFree = false
	self.lastFreeTime = 0
	self.isCurPoolUnlock = true
	if self.isCurPoolUnlock and self.curCfg.freeTime ~= 0 then
		self.lastFreeTime = self.curData and self.curData.lastFreeTime and self.curData.lastFreeTime + self.curCfg.freeTime - serviceFunctions.systemTime() or 0
		self.isFree = self.lastFreeTime <= 0
	end
	self.text_time:setVisible(self.isCurPoolUnlock and self.lastFreeTime > 0)
	self.text_time:removeTime()
	if self.isCurPoolUnlock and self.lastFreeTime > 0 then
		self.text_time:beginTime(self.lastFreeTime)
	end
	local cirNum = not (self.curData and self.curData.isFirstN) and self.curCfg.firstIndex or self.curCfg.circulateIndex1
	local lastN = cirNum - (self.curData and self.curData.N or 0)
	dump(self.curCfg.magicPoolID, "self.curCfg.magicPoolID ")
	if self.curCfg.magicPoolID == 1 then
		_ENV = i18n("jinn_skill_8", nil)
		i18n("jinn_skill_8", nil).num = lastN
		self.fields.text_tips:setString(i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil)))
		_ENV = i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil))
		i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil)).num = lastN
		self.fields.text_tips3:setString(i18n("Magic_draw_text_16", i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil))))
	else
		_ENV = i18n("Magic_draw_text_16", i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil)))
		i18n("Magic_draw_text_16", i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil))).num = lastN
		self.fields.text_tips:setString(i18n("Magic_draw_text_05", i18n("Magic_draw_text_16", i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil)))))
		_ENV = i18n("Magic_draw_text_05", i18n("Magic_draw_text_16", i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil))))
		i18n("Magic_draw_text_05", i18n("Magic_draw_text_16", i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil)))).num = lastN
		self.fields.text_tips3:setString(i18n("Magic_draw_text_05", i18n("Magic_draw_text_05", i18n("Magic_draw_text_16", i18n("Magic_draw_text_16", i18n("jinn_skill_8", nil))))))
	end
	local lottryTimes = self.curData and self.curData.lottryTimes or 0
	self.curStageRewards = magicLampSkillLotteryRead.getStageReward(self.magicPoolID)
	local selectedIndex = 1
	if self.curStageRewards ~= nil then
		self.controllers.c1:setSelectedIndex(1)
		self:initProgress(lottryTimes)
	else
		self.controllers.c1:setSelectedIndex(0)
		selectedIndex = 0
	end
	if self.curSelectedIndex ~= selectedIndex and selectedIndex == 1 then
		self.transitions.t2:play()
	end
	self.curSelectedIndex = selectedIndex
	self:refreshItem()
	self:updateDailyReward()
end
function MagicLampMaigcPowerMainPanel:initProgress(lottryTimes)
	self.boxFields = fguiHelper.get_fields(self.fields.Com_boxList)
	local personScore = lottryTimes
	self.boxFields.text_countTitle:setString(i18n("magic_lamp_text_003"))
	self.boxFields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	local passIndex = 0
	local maxScore = 0
	self.boxFields.List_box:setPivot(0, 1)
	self.boxFields.bar:setPivot(0, 1)
	self.boxFields.List_box:setNumItems(#self.curStageRewards)
	self.boxFields.List_box:setWidth(math.max(535, #self.curStageRewards * 80 + (#self.curStageRewards - 1) * 30))
	local singlePassPercent = 1 / #self.curStageRewards * 100
	for i, v in ipairs(self.curStageRewards) do
		if personScore >= v.drawNum then
			passIndex = passIndex + 1
		end
		maxScore = v.drawNum
	end
	if passIndex < #self.curStageRewards then
		local nowPoint = self.curStageRewards[passIndex] and self.curStageRewards[passIndex].drawNum or 0
		local littlePercent = (personScore - nowPoint) / (self.curStageRewards[passIndex + 1].drawNum - nowPoint) * singlePassPercent
		dump(singlePassPercent * passIndex + littlePercent, "(singlePassPercent * (passIndex) + littlePercent)")
		self.boxFields.bar:setPercent((singlePassPercent * passIndex + littlePercent) / 100)
	else
		self.boxFields.bar:setPercent(1)
	end
	_ENV = (singlePassPercent * passIndex + littlePercent) / 100
	;(singlePassPercent * passIndex + littlePercent) / 100.num1 = personScore
	;(singlePassPercent * passIndex + littlePercent) / 100.num2 = maxScore
	self.boxFields.text_countValue:setString(i18n("snow_competition_text_22", (singlePassPercent * passIndex + littlePercent) / 100))
	if self.curPoolIndex ~= self.lastCurPoolIndex then
		self.fields.Com_boxList:getScrollPane():setPercX(SoraDFIsRA() and 1 or 0)
	end
	self.lastCurPoolIndex = self.curPoolIndex
end
function MagicLampMaigcPowerMainPanel:refreshItem()
	self.itemID = self.curCfg.drwaCost1[1]
	self.needNum1 = self.curCfg.drwaCost1[2]
	self.needNum2 = self.curCfg.drawCost2[2]
	self.fields.Com_have:initData(self.itemID)
	self.haveNum = self.fields.Com_have:updateNum()
	self.fields.btn_one:setCost(self.itemID, self.isFree and 0 or self.needNum1, false)
	dump(self.itemID, self.needNum1, "self.itemID, self.needNum1")
	self.fields.btn_ten:setCost(self.itemID, self.needNum2)
	self.fields.btn_one:setTouchEnabled(self.isCurPoolUnlock)
	self.fields.btn_ten:setTouchEnabled(self.isCurPoolUnlock)
	self.fields.btn_one:setBtnBgGray(not self.isCurPoolUnlock)
	self.fields.btn_ten:setBtnBgGray(not self.isCurPoolUnlock)
end
function MagicLampMaigcPowerMainPanel:updatePoolList(isFirst)
	local _ENV, showList
	self.isHaveActivityPool = false
	for i, v in ipairs(self.showCfgs) do
		local isCurPoolUnlock = magicLampSkillLotteryCtrl:getIsPoolOpenInRightArea(v.magicPoolID)
		if isCurPoolUnlock then
			if v.activeTime >= 1 then
				isCurPoolUnlock = magicLampSkillLotteryCtrl:getIsPoolOpen(v.magicPoolID)
				self.isHaveActivityPool = self.isHaveActivityPool or isCurPoolUnlock
			end
			if isCurPoolUnlock then
				if isFirst and v.magicPoolID == self.paramPoolID then
					self.curPoolIndex = #showList + 1
				end
				table.insert(showList, v)
			end
		end
	end
	self.showList = showList
	dump(self.showList, "self.showList")
	self.fields.List_pool:setNumItems(#self.showList + 2)
	self.fields.List_pool:scrollToCenter(self.fields.List_pool:getChildAt(self.curPoolIndex), true)
end
function MagicLampMaigcPowerMainPanel:updateDailyReward()
	local controllers = fguiHelper.get_controllers(self.fields.Btn_daily)
	self.fields.Btn_daily:setVisible(self.isHaveActivityPool)
	self.dailyReward = magicLampSkillLotteryCtrl:getIsDailyFree()
	controllers.c1:setSelectedIndex(self.dailyReward and 0 or 1)
	self.fields.Btn_daily:setReddot(self.dailyReward)
	if not self.dailyReward then
		if self.timerLabel == nil then
			self.timerLabel = fguiHelper.get_fields(self.fields.Btn_daily).time
			self.timerLabel = SoraDCreateTimerLabel(self, self.timerLabel)
			self.timerLabel:setTimeEndListener(handler(self, self.updateDailyReward))
		end
		self.timerLabel:beginTime(serviceFunctions.getTomorrowZeroHourUTC() - serviceFunctions.systemTime())
	end
end
function MagicLampMaigcPowerMainPanel:onOneClick(sender, params)
	SoraDPlaySound()
	if self.max < self.curNum + 1 then
		SoraDShowMsgTip(i18n("Magic_draw_text_08"))
		return
	end
	if not self.isFree and not self:checkItem(self.needNum1) then
		return
	end
	magicLampSkillLotteryCtrl:reqSkillLetteoryDraw(self.magicPoolID, 1, self.isFree)
end
function MagicLampMaigcPowerMainPanel:onTenClick(sender, params)
	SoraDPlaySound()
	if self.max < self.curNum + 5 then
		SoraDShowMsgTip(i18n("Magic_draw_text_08"))
		return
	end
	if not self:checkItem(self.needNum2) then
		return
	end
	magicLampSkillLotteryCtrl:reqSkillLetteoryDraw(self.magicPoolID, 5, false)
end
function MagicLampMaigcPowerMainPanel:onPreviewClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).magicPoolID = self.magicPoolID
	uiManager:show("MagicLampMagicPowerPreview", nil)
end
function MagicLampMaigcPowerMainPanel:onRewardClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).magicPoolID = self.magicPoolID
	uiManager:show("MagicLampMaigcPowerReward", nil)
end
function MagicLampMaigcPowerMainPanel:onDailyClick()
	SoraDPlaySound()
	if not self.dailyReward then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
	else
		magicLampSkillLotteryCtrl:reqDailyReward()
	end
end
function MagicLampMaigcPowerMainPanel:onMoliClick()
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	uiManager:show("MagicLampSkillMain")
end
function MagicLampMaigcPowerMainPanel:checkItem(num)
	if num > self.haveNum then
		SoraDShowMsgTip(i18n("Magic_draw_text_07"))
		return false
	end
	return true
end
function MagicLampMaigcPowerMainPanel:onPoolRenderer(index, obj)
	local cfg = self.showList[index]
	obj:initData(cfg, index)
	obj:setClickHandler(handler(self, self.onPoolSelected))
end
function MagicLampMaigcPowerMainPanel:onPoolSelected(index)
	self.curPoolIndex = index
	self:updateView()
end
function MagicLampMaigcPowerMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Magic_draw_text_02")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MagicLampMaigcPowerMainPanel:onScrollItem()
	local offsetX = self.fields.List_pool:getScrollPane():getScrollingPosX()
	local listW = self.fields.List_pool:getContentSize().width
	local scrollW = self.fields.List_pool:getInnerContainerSize().width
	local centerX = offsetX + listW / 2
	for i = 1, self.fields.List_pool:getNumItems() do
		local objW = self.fields.List_pool:getChildAt(i - 1):getContentSize().width
		local objOffsetX = self.fields.List_pool:getChildAt(i - 1):getX() + objW / 2 - offsetX - listW / 2
		self.fields.List_pool:getChildAt(i - 1):setRatio((scrollW - math.abs(objOffsetX)) / scrollW)
	end
end
function MagicLampMaigcPowerMainPanel:onScrollEndItem()
	local midIndex = 0
	local ratio = 0
	for i = 1, self.fields.List_pool:getNumItems() do
		if ratio <= self.fields.List_pool:getChildAt(i - 1):getRatio() and not self.fields.List_pool:getChildAt(i - 1):isEmptyCom() then
			ratio = self.fields.List_pool:getChildAt(i - 1):getRatio()
			midIndex = i
		end
	end
	self.curPoolIndex = midIndex - 1
	self:updateView()
end
function MagicLampMaigcPowerMainPanel:onBoxRenderer(index, obj)
	local boxInfo = self.curStageRewards[index + 1]
	local getStatus = magicLampSkillLotteryCtrl:getBoxRewardDataStatus(self.magicPoolID, index + 1, boxInfo.drawNum)
	obj:initData(index, boxInfo.drawNum, getStatus, handler(self, self.buttonGetRewardCallBack))
	if JudgeItemType(boxInfo.reward[1].id) == gIDType.MAGIC_LAMP_SKILL then
		obj.fields.icon:setVisible(false)
		obj.fields.Com_skill:setVisible(true)
		magicLampSkillLotteryCtrl = true
		;(true).skillType = boxInfo.reward[1].id
		obj.fields.Com_skill:initData(true)
	else
		obj.fields.icon:setVisible(true)
		obj.fields.Com_skill:setVisible(false)
		if #boxInfo.reward == 1 then
			obj:setIcon(publicRead.getIcon(boxInfo.reward[1].id))
		end
	end
	if #boxInfo.reward == 1 then
		obj.fields.text_num:setString("x" .. boxInfo.reward[1].count)
	else
		obj.fields.text_num:setString("")
	end
	if not obj._longAdd and #boxInfo.reward == 1 then
		obj._longAdd = true
		obj:addLongPressListener(function(button, startPos, endPos)
			self.isLong = true
			SoraDPlaySound()
			if JudgeItemType(boxInfo.reward[1].id) == gIDType.MAGIC_LAMP_SKILL then
				self = nil
				;(nil).data = obj.fields.Com_skill.data
				uiManager:show("MagicLampSkillDetailsLook", nil)
			else
				self = uiManager
				uiManager.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
				uiManager.id = boxInfo.reward[1].id
				uiManager.num = boxInfo.reward[1].count
				uiManager.pos = startPos
				SoraDSendMessage(uiManager)
			end
		end)
	end
end
function MagicLampMaigcPowerMainPanel:buttonGetRewardCallBack(index)
	if self.isLong then
		self.isLong = false
		return
	end
	SoraDPlaySound()
	local boxInfo = self.curStageRewards[index + 1]
	local getStatus = magicLampSkillLotteryCtrl:getBoxRewardDataStatus(self.magicPoolID, index + 1, boxInfo.drawNum)
	if 1 < #boxInfo.reward then
		_ENV = boxInfo.drawNum
		boxInfo.drawNum.activityID = self.activityID
		boxInfo.drawNum.rewards = boxInfo.reward
		_ENV = nil
		;(nil).num = boxInfo.drawNum
		boxInfo.drawNum.tipStr = i18n("Magic_draw_text_22", nil)
		_ENV = nil
		;(nil).num = self.curData and self.curData.lottryTimes or 0
		boxInfo.drawNum.pointStr = i18n("Magic_draw_text_23", nil)
		boxInfo.drawNum.state = getStatus
		_ENV, boxInfo.drawNum.stage = index + 1, index + 1
		;(index + 1).stageType = self.magicPoolID
		boxInfo.drawNum.otherData, (index + 1).stage = index + 1, index + 1
		uiManager:show("CommonStageReward", boxInfo.drawNum)
		return
	end
	_UPVALUE2_ = uiManager
	uiManager[1] = getStatus
	uiManager[2] = boxInfo
	dump(uiManager, "getStatus")
	if getStatus == gBtnTargetStatusDef.GOT then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
	elseif getStatus == gBtnTargetStatusDef.GET then
		magicLampSkillLotteryCtrl:reqStageReward(self.magicPoolID, index + 1)
	else
		SoraDShowMsgTip(i18n("magic_flip_15"))
	end
end
function MagicLampMaigcPowerMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "pool" then
		return self.fields.List_pool:getChildAt(1)
	elseif itemName == "btn_preview" then
		return self.fields.btn_preview
	elseif itemName == "Com_moli" then
		return self.fields.Com_moli
	end
	return self.fields[itemName]
end
return MagicLampMaigcPowerMainPanel
