local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001649_MainPanel = class("Activity_9001649_MainPanel", baseFguiPanel)
local activity_9001649_Read = include("activity_9001649_Read")
local activity_9001649_Ctrl = SoraDGetCtrl("activity_9001649_Ctrl")
local publicRead = include("publicRead")
local cheatCtrl = SoraDGetCtrl("cheatCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Activity_9001649_MainPanel:ctor(...)
	Activity_9001649_MainPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001649_MainPanel:ctor", self.viewName)
end
_UPVALUE4_, Activity_9001649_MainPanel.onInit = function(self)
	print("=======Activity_9001649_MainPanel:onInit")
	self.itemData = activity_9001649_Read:getItemCfg()
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self.needNum = self.itemData.expend[2]
	self.itemID = self.itemData.expend[1]
	self.needNum2 = self.itemData.expendfree[2]
	self.itemID2 = self.itemData.expendfree[1]
	self.fields.text_auto:setString(i18n("explore_ore_text21"))
	self.fields.Com_title:initData(i18n("activity_name_9001649"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("summoned_text_07"))
	self.fields.Button_Reward:addClickEventListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Com_Have2:initData(self.itemID2)
	self.fields.Com_Have2:hideBtnAdd()
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_One:setString(i18n("explore_ore_text6", handler(self, self.onClickPreaward)))
	self.fields.Button_One:addClickEventListener(handler(self, self.onHookClick), false)
	self.fields.Button_Ten:setString(i18n("explore_ore_text9"))
	self.fields.Button_Ten:addClickEventListener(handler(self, self.onHookClick), true)
	self.fields.Button_Skip:setString(i18n("explore_ore_text24"))
	self.fields.Button_Skip:addClickEventListener(handler(self, self.onSkipClick), true)
	self.fields.Button_Stop:setString(i18n("explore_ore_text23"))
	self.fields.Button_Stop:addClickEventListener(handler(self, self.onStopClick), true)
	self.fields.button_cheat:setString(i18n("#刷新"))
	self.fields.button_cheat:setVisible(device.platform == "mac")
	self.fields.button_cheat:addClickEventListener(handler(self, self.onCheat))
	self.fields.auto_mask:addClickListener(handler(self, self.onMaskClick))
	self.fields.text_tip:setString(i18n("explore_ore_text12"))
	self.boxInfo = activity_9001649_Read:getStageConfig()
	local bigReward = activity_9001649_Read.getBigReward()
	fguiHelper.get_fields(self.fields.Com_preview).item:initData(bigReward.id, bigReward.count)
	self.view:fixChildrenPos()
	self.fields.bar:fixChildrenPos()
end, function(self)
	print("=======Activity_9001649_MainPanel:onInit")
	self.itemData = activity_9001649_Read:getItemCfg()
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self.needNum = self.itemData.expend[2]
	self.itemID = self.itemData.expend[1]
	self.needNum2 = self.itemData.expendfree[2]
	self.itemID2 = self.itemData.expendfree[1]
	self.fields.text_auto:setString(i18n("explore_ore_text21"))
	self.fields.Com_title:initData(i18n("activity_name_9001649"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("summoned_text_07"))
	self.fields.Button_Reward:addClickEventListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Com_Have2:initData(self.itemID2)
	self.fields.Com_Have2:hideBtnAdd()
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_One:setString(i18n("explore_ore_text6", handler(self, self.onClickPreaward)))
	self.fields.Button_One:addClickEventListener(handler(self, self.onHookClick), false)
	self.fields.Button_Ten:setString(i18n("explore_ore_text9"))
	self.fields.Button_Ten:addClickEventListener(handler(self, self.onHookClick), true)
	self.fields.Button_Skip:setString(i18n("explore_ore_text24"))
	self.fields.Button_Skip:addClickEventListener(handler(self, self.onSkipClick), true)
	self.fields.Button_Stop:setString(i18n("explore_ore_text23"))
	self.fields.Button_Stop:addClickEventListener(handler(self, self.onStopClick), true)
	self.fields.button_cheat:setString(i18n("#刷新"))
	self.fields.button_cheat:setVisible(device.platform == "mac")
	self.fields.button_cheat:addClickEventListener(handler(self, self.onCheat))
	self.fields.auto_mask:addClickListener(handler(self, self.onMaskClick))
	self.fields.text_tip:setString(i18n("explore_ore_text12"))
	self.boxInfo = activity_9001649_Read:getStageConfig()
	local bigReward = activity_9001649_Read.getBigReward()
	fguiHelper.get_fields(self.fields.Com_preview).item:initData(bigReward.id, bigReward.count)
	self.view:fixChildrenPos()
	self.fields.bar:fixChildrenPos()
end
;(function(self)
	print("=======Activity_9001649_MainPanel:onInit")
	self.itemData = activity_9001649_Read:getItemCfg()
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self.needNum = self.itemData.expend[2]
	self.itemID = self.itemData.expend[1]
	self.needNum2 = self.itemData.expendfree[2]
	self.itemID2 = self.itemData.expendfree[1]
	self.fields.text_auto:setString(i18n("explore_ore_text21"))
	self.fields.Com_title:initData(i18n("activity_name_9001649"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("summoned_text_07"))
	self.fields.Button_Reward:addClickEventListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Com_Have2:initData(self.itemID2)
	self.fields.Com_Have2:hideBtnAdd()
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_One:setString(i18n("explore_ore_text6", handler(self, self.onClickPreaward)))
	self.fields.Button_One:addClickEventListener(handler(self, self.onHookClick), false)
	self.fields.Button_Ten:setString(i18n("explore_ore_text9"))
	self.fields.Button_Ten:addClickEventListener(handler(self, self.onHookClick), true)
	self.fields.Button_Skip:setString(i18n("explore_ore_text24"))
	self.fields.Button_Skip:addClickEventListener(handler(self, self.onSkipClick), true)
	self.fields.Button_Stop:setString(i18n("explore_ore_text23"))
	self.fields.Button_Stop:addClickEventListener(handler(self, self.onStopClick), true)
	self.fields.button_cheat:setString(i18n("#刷新"))
	self.fields.button_cheat:setVisible(device.platform == "mac")
	self.fields.button_cheat:addClickEventListener(handler(self, self.onCheat))
	self.fields.auto_mask:addClickListener(handler(self, self.onMaskClick))
	self.fields.text_tip:setString(i18n("explore_ore_text12"))
	self.boxInfo = activity_9001649_Read:getStageConfig()
	local bigReward = activity_9001649_Read.getBigReward()
	fguiHelper.get_fields(self.fields.Com_preview).item:initData(bigReward.id, bigReward.count)
	self.view:fixChildrenPos()
	self.fields.bar:fixChildrenPos()
end)[1] = ""
;(function(self)
	print("=======Activity_9001649_MainPanel:onInit")
	self.itemData = activity_9001649_Read:getItemCfg()
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self.needNum = self.itemData.expend[2]
	self.itemID = self.itemData.expend[1]
	self.needNum2 = self.itemData.expendfree[2]
	self.itemID2 = self.itemData.expendfree[1]
	self.fields.text_auto:setString(i18n("explore_ore_text21"))
	self.fields.Com_title:initData(i18n("activity_name_9001649"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("summoned_text_07"))
	self.fields.Button_Reward:addClickEventListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Com_Have2:initData(self.itemID2)
	self.fields.Com_Have2:hideBtnAdd()
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_One:setString(i18n("explore_ore_text6", handler(self, self.onClickPreaward)))
	self.fields.Button_One:addClickEventListener(handler(self, self.onHookClick), false)
	self.fields.Button_Ten:setString(i18n("explore_ore_text9"))
	self.fields.Button_Ten:addClickEventListener(handler(self, self.onHookClick), true)
	self.fields.Button_Skip:setString(i18n("explore_ore_text24"))
	self.fields.Button_Skip:addClickEventListener(handler(self, self.onSkipClick), true)
	self.fields.Button_Stop:setString(i18n("explore_ore_text23"))
	self.fields.Button_Stop:addClickEventListener(handler(self, self.onStopClick), true)
	self.fields.button_cheat:setString(i18n("#刷新"))
	self.fields.button_cheat:setVisible(device.platform == "mac")
	self.fields.button_cheat:addClickEventListener(handler(self, self.onCheat))
	self.fields.auto_mask:addClickListener(handler(self, self.onMaskClick))
	self.fields.text_tip:setString(i18n("explore_ore_text12"))
	self.boxInfo = activity_9001649_Read:getStageConfig()
	local bigReward = activity_9001649_Read.getBigReward()
	fguiHelper.get_fields(self.fields.Com_preview).item:initData(bigReward.id, bigReward.count)
	self.view:fixChildrenPos()
	self.fields.bar:fixChildrenPos()
end)[2] = "."
;(function(self)
	print("=======Activity_9001649_MainPanel:onInit")
	self.itemData = activity_9001649_Read:getItemCfg()
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self.needNum = self.itemData.expend[2]
	self.itemID = self.itemData.expend[1]
	self.needNum2 = self.itemData.expendfree[2]
	self.itemID2 = self.itemData.expendfree[1]
	self.fields.text_auto:setString(i18n("explore_ore_text21"))
	self.fields.Com_title:initData(i18n("activity_name_9001649"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("summoned_text_07"))
	self.fields.Button_Reward:addClickEventListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Com_Have2:initData(self.itemID2)
	self.fields.Com_Have2:hideBtnAdd()
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_One:setString(i18n("explore_ore_text6", handler(self, self.onClickPreaward)))
	self.fields.Button_One:addClickEventListener(handler(self, self.onHookClick), false)
	self.fields.Button_Ten:setString(i18n("explore_ore_text9"))
	self.fields.Button_Ten:addClickEventListener(handler(self, self.onHookClick), true)
	self.fields.Button_Skip:setString(i18n("explore_ore_text24"))
	self.fields.Button_Skip:addClickEventListener(handler(self, self.onSkipClick), true)
	self.fields.Button_Stop:setString(i18n("explore_ore_text23"))
	self.fields.Button_Stop:addClickEventListener(handler(self, self.onStopClick), true)
	self.fields.button_cheat:setString(i18n("#刷新"))
	self.fields.button_cheat:setVisible(device.platform == "mac")
	self.fields.button_cheat:addClickEventListener(handler(self, self.onCheat))
	self.fields.auto_mask:addClickListener(handler(self, self.onMaskClick))
	self.fields.text_tip:setString(i18n("explore_ore_text12"))
	self.boxInfo = activity_9001649_Read:getStageConfig()
	local bigReward = activity_9001649_Read.getBigReward()
	fguiHelper.get_fields(self.fields.Com_preview).item:initData(bigReward.id, bigReward.count)
	self.view:fixChildrenPos()
	self.fields.bar:fixChildrenPos()
end)[3] = ".."
local (function(self)
	print("=======Activity_9001649_MainPanel:onInit")
	self.itemData = activity_9001649_Read:getItemCfg()
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self.needNum = self.itemData.expend[2]
	self.itemID = self.itemData.expend[1]
	self.needNum2 = self.itemData.expendfree[2]
	self.itemID2 = self.itemData.expendfree[1]
	self.fields.text_auto:setString(i18n("explore_ore_text21"))
	self.fields.Com_title:initData(i18n("activity_name_9001649"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("summoned_text_07"))
	self.fields.Button_Reward:addClickEventListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Com_Have2:initData(self.itemID2)
	self.fields.Com_Have2:hideBtnAdd()
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_One:setString(i18n("explore_ore_text6", handler(self, self.onClickPreaward)))
	self.fields.Button_One:addClickEventListener(handler(self, self.onHookClick), false)
	self.fields.Button_Ten:setString(i18n("explore_ore_text9"))
	self.fields.Button_Ten:addClickEventListener(handler(self, self.onHookClick), true)
	self.fields.Button_Skip:setString(i18n("explore_ore_text24"))
	self.fields.Button_Skip:addClickEventListener(handler(self, self.onSkipClick), true)
	self.fields.Button_Stop:setString(i18n("explore_ore_text23"))
	self.fields.Button_Stop:addClickEventListener(handler(self, self.onStopClick), true)
	self.fields.button_cheat:setString(i18n("#刷新"))
	self.fields.button_cheat:setVisible(device.platform == "mac")
	self.fields.button_cheat:addClickEventListener(handler(self, self.onCheat))
	self.fields.auto_mask:addClickListener(handler(self, self.onMaskClick))
	self.fields.text_tip:setString(i18n("explore_ore_text12"))
	self.boxInfo = activity_9001649_Read:getStageConfig()
	local bigReward = activity_9001649_Read.getBigReward()
	fguiHelper.get_fields(self.fields.Com_preview).item:initData(bigReward.id, bigReward.count)
	self.view:fixChildrenPos()
	self.fields.bar:fixChildrenPos()
end)[4], autoStrs = "...", function(self)
	print("=======Activity_9001649_MainPanel:onInit")
	self.itemData = activity_9001649_Read:getItemCfg()
	self.activityID = gActivityTimeActivityID.GEOCENTRIC_EXPLORATION
	self.needNum = self.itemData.expend[2]
	self.itemID = self.itemData.expend[1]
	self.needNum2 = self.itemData.expendfree[2]
	self.itemID2 = self.itemData.expendfree[1]
	self.fields.text_auto:setString(i18n("explore_ore_text21"))
	self.fields.Com_title:initData(i18n("activity_name_9001649"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_Reward:setString(i18n("summoned_text_07"))
	self.fields.Button_Reward:addClickEventListener(handler(self, self.onClickPreaward))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Com_Have2:initData(self.itemID2)
	self.fields.Com_Have2:hideBtnAdd()
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_One:setString(i18n("explore_ore_text6", handler(self, self.onClickPreaward)))
	self.fields.Button_One:addClickEventListener(handler(self, self.onHookClick), false)
	self.fields.Button_Ten:setString(i18n("explore_ore_text9"))
	self.fields.Button_Ten:addClickEventListener(handler(self, self.onHookClick), true)
	self.fields.Button_Skip:setString(i18n("explore_ore_text24"))
	self.fields.Button_Skip:addClickEventListener(handler(self, self.onSkipClick), true)
	self.fields.Button_Stop:setString(i18n("explore_ore_text23"))
	self.fields.Button_Stop:addClickEventListener(handler(self, self.onStopClick), true)
	self.fields.button_cheat:setString(i18n("#刷新"))
	self.fields.button_cheat:setVisible(device.platform == "mac")
	self.fields.button_cheat:addClickEventListener(handler(self, self.onCheat))
	self.fields.auto_mask:addClickListener(handler(self, self.onMaskClick))
	self.fields.text_tip:setString(i18n("explore_ore_text12"))
	self.boxInfo = activity_9001649_Read:getStageConfig()
	local bigReward = activity_9001649_Read.getBigReward()
	fguiHelper.get_fields(self.fields.Com_preview).item:initData(bigReward.id, bigReward.count)
	self.view:fixChildrenPos()
	self.fields.bar:fixChildrenPos()
end
local autoIndex = 1
function Activity_9001649_MainPanel:autoAnimation()
	self.fields.text_auto:setString(i18n("explore_ore_text21") .. autoStrs[autoIndex])
	self.fields.text_auto:stopAllActions()
	self.fields.text_auto:runAction(ffa.seq(ffa.delay(0.3), ffa.callFunc(handler(self, self.autoAnimation))))
end
function Activity_9001649_MainPanel:onShow()
	print("=======Activity_9001649_MainPanel:onShow")
	self:updateView()
	_ENV = nil
	;(nil).byUID = true
	local autoGotRewards = SoraDConfigGet("Game:Activity_9001649_MainPanel:showGetRewards~table", nil)
	dump(autoGotRewards, "autoGotRewards")
	if autoGotRewards ~= nil and autoGotRewards.activityTime == activityShowCtrl:getBeginTimeSecond(self.activityID) and autoGotRewards.rewards and next(autoGotRewards.rewards) then
		self:runAction(ffa.seq(ffa.delay(0), ffa.callFunc(function()
			_ENV = nil
			autoGotRewards, (nil).itemType = nil, 5
			;(nil).rewards, (nil)[1] = nil, autoGotRewards.rewards
			;(nil).width = 540
			uiManager:show("CommonCongratulations", nil)
			_ENV, _ENV = nil, "CommonCongratulations"
			;(nil).byUID = true
			SoraDConfigSet("Game:Activity_9001649_MainPanel:showGetRewards~table", "CommonCongratulations", nil)
		end)))
	end
	_ENV = ffa.seq(ffa.delay(0), ffa.callFunc(function()
		_ENV = nil
		autoGotRewards, (nil).itemType = nil, 5
		;(nil).rewards, (nil)[1] = nil, autoGotRewards.rewards
		;(nil).width = 540
		uiManager:show("CommonCongratulations", nil)
		_ENV, _ENV = nil, "CommonCongratulations"
		;(nil).byUID = true
		SoraDConfigSet("Game:Activity_9001649_MainPanel:showGetRewards~table", "CommonCongratulations", nil)
	end))
	ffa.seq(ffa.delay(0), ffa.callFunc(function()
		_ENV = nil
		autoGotRewards, (nil).itemType = nil, 5
		;(nil).rewards, (nil)[1] = nil, autoGotRewards.rewards
		;(nil).width = 540
		uiManager:show("CommonCongratulations", nil)
		_ENV, _ENV = nil, "CommonCongratulations"
		;(nil).byUID = true
		SoraDConfigSet("Game:Activity_9001649_MainPanel:showGetRewards~table", "CommonCongratulations", nil)
	end)).byUID = true
	if not SoraDConfigGet("Game:Activity_9001649_MainPanel:guide~bool", ffa.seq(ffa.delay(0), ffa.callFunc(function()
		_ENV = nil
		autoGotRewards, (nil).itemType = nil, 5
		;(nil).rewards, (nil)[1] = nil, autoGotRewards.rewards
		;(nil).width = 540
		uiManager:show("CommonCongratulations", nil)
		_ENV, _ENV = nil, "CommonCongratulations"
		;(nil).byUID = true
		SoraDConfigSet("Game:Activity_9001649_MainPanel:showGetRewards~table", "CommonCongratulations", nil)
	end))) then
		_ENV = "Game:Activity_9001649_MainPanel:guide~bool"
		;("Game:Activity_9001649_MainPanel:guide~bool").msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		;("Game:Activity_9001649_MainPanel:guide~bool").step = 9991100
		SoraDSendMessage("Game:Activity_9001649_MainPanel:guide~bool")
	end
end
function Activity_9001649_MainPanel:updateView()
	self.isHooking = false
	self.isStopping = false
	self.controllers.c1:setSelectedIndex(0)
	self:updateStageButton()
	self:updateButton()
	self:updateGameUI()
end
function Activity_9001649_MainPanel:updateGameUI()
	self.fields.Com_9001649_game:initData(activity_9001649_Ctrl:getRandomMine(), activity_9001649_Ctrl:getMineData())
	self.isAuto = false
	self.autoCount = 0
	self.controllers.c1:setSelectedIndex(0)
end
function Activity_9001649_MainPanel:initProgress()
	local personScore = activity_9001649_Ctrl:getScore()
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	local passIndex = 0
	self.fields.List_box:setNumItems(#self.boxInfo)
	local singlePassPercent = 1 / #self.boxInfo * 100
	for i, v in ipairs(self.boxInfo) do
		if personScore >= v.point then
			passIndex = passIndex + 1
		end
	end
	if passIndex < #self.boxInfo then
		local nowPoint = self.boxInfo[passIndex] and self.boxInfo[passIndex].point or 0
		local littlePercent = (personScore - nowPoint) / (self.boxInfo[passIndex + 1].point - nowPoint) * singlePassPercent
		dump(singlePassPercent * passIndex + littlePercent, "(singlePassPercent * (passIndex) + littlePercent)")
		self.fields.bar:setPercent((singlePassPercent * passIndex + littlePercent) / 100)
	else
		self.fields.bar:setPercent(1)
	end
	activity_9001649_Ctrl = (singlePassPercent * passIndex + littlePercent) / 100
	activity_9001649_Ctrl, activity_9001649_Ctrl, (singlePassPercent * passIndex + littlePercent) / 100.num = handler(self, self.onBoxRenderer)
	v.point.num, handler(self, self.onBoxRenderer).color = handler(self, self.onBoxRenderer)
	self.fields.text_value:setString(i18n_html("explore_ore_text2", (singlePassPercent * passIndex + littlePercent) / 100, v.point))
end
function Activity_9001649_MainPanel:onBoxRenderer(index, obj)
	local boxInfo = self.boxInfo[index + 1]
	local getStatus = activity_9001649_Ctrl:getBoxRewardDataStatus(boxInfo.point, boxInfo.point)
	obj:initData(index, boxInfo.point, getStatus, handler(self, self.buttonGetRewardCallBack))
	obj:setIcon(publicRead.getIcon(boxInfo.reward[1].id))
	obj.fields.text_num:setString("x" .. boxInfo.reward[1].count)
	if not obj._longAdd then
		obj._longAdd = true
		obj:addLongPressListener(function(button, startPos, endPos)
			self.isLong = true
			SoraDPlaySound()
			self = nil
			;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
			;(nil).id = boxInfo.reward[1].id
			;(nil).num = boxInfo.reward[1].count
			;(nil).pos = startPos
			SoraDSendMessage(nil)
		end)
	end
end
function Activity_9001649_MainPanel:buttonGetRewardCallBack(index)
	if self.isLong then
		self.isLong = false
		return
	end
	SoraDPlaySound()
	local boxInfo = self.boxInfo[index + 1]
	local getStatus = activity_9001649_Ctrl:getBoxRewardDataStatus(boxInfo.index, boxInfo.point)
	_UPVALUE2_ = boxInfo.index
	boxInfo.index[1] = getStatus
	boxInfo.index[2] = boxInfo
	dump(boxInfo.index, "getStatus")
	if getStatus == gBtnTargetStatusDef.GOT then
		if boxInfo.herojump ~= nil and boxInfo.herojump ~= 0 then
			SoraDShowHeroDetailView(boxInfo.herojump)
		else
			SoraDShowMsgTip(i18n("explore_ore_text4"))
		end
	elseif getStatus == gBtnTargetStatusDef.GET then
		activity_9001649_Ctrl:reqStageReward(boxInfo.point)
	elseif boxInfo.herojump ~= nil and boxInfo.herojump ~= 0 then
		SoraDShowHeroDetailView(boxInfo.herojump)
	else
		SoraDShowMsgTip(i18n("explore_ore_text3"))
	end
end
function Activity_9001649_MainPanel:updateStageButton()
	self:initProgress()
	_ENV = nil
	;(nil).num = activity_9001649_Ctrl:getLuckyNum()
	;(nil).limitnum = self.itemData.maxlucky
	self.fields.text_lucky:setString(i18n("explore_ore_text5", nil))
end
function Activity_9001649_MainPanel:updateButton()
	if backpackCtrl:getItemCount(self.itemID2) >= self.needNum2 then
		self.fields.Button_One:setCost(self.itemID2, 1)
	else
		self.fields.Button_One:setCost(self.itemID, 1)
	end
	self.haveItem = self.fields.Com_Have:updateNum()
	self.fields.Com_Have2:updateNum()
end
function Activity_9001649_MainPanel:onClickHelp()
	SoraDPlaySound()
	if self.autoCount and self.autoCount > 0 then
		SoraDShowMsgTip(i18n("explore_ore_text13"))
		return
	end
	_ENV = i18n("explore_ore_text13")
	i18n("explore_ore_text13").content = i18n("explore_ore_text1")
	uiManager:show("RuleView", i18n("explore_ore_text13")):setOwnerKey(self)
end
function Activity_9001649_MainPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("Activity_9001649_Pop")
end
function Activity_9001649_MainPanel:onHookClick(sender, isAuto)
	SoraDPlaySound()
	print("Activity_9001649_MainPanel:onHookClick = ", isAuto)
	if self.fields.Com_9001649_game:getIsHooking() then
		SoraDShowMsgTip(i18n("explore_ore_text8"))
		return
	end
	local haveItem2Num = backpackCtrl:getItemCount(self.itemID2)
	if haveItem2Num < self.needNum2 and self.haveItem < self.needNum then
		_ENV = i18n("explore_ore_text8")
		i18n("explore_ore_text8").item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("explore_ore_text7", i18n("explore_ore_text8")))
		return
	end
	if isAuto then
		self.controllers.c1:setSelectedIndex(1)
		self:autoAnimation()
	end
	self.isAuto = isAuto
	if isAuto then
		_ENV = self.autoAnimation
		if self.autoAnimation then
			goto lbl_57
		end
	end
	::lbl_57::
	self.gotRewards = nil
	self.autoCount = isAuto and math.floor(haveItem2Num / self.needNum2) + math.floor(self.haveItem / self.needNum) or 1
	self.fields.Com_9001649_game:setHookCallback(handler(self, self.hookCallback))
	self.fields.Com_9001649_game:hookStart(isAuto)
end
function Activity_9001649_MainPanel:hookCallback(mine)
	if self.isStopping then
		self.controllers.c1:setSelectedIndex(0)
		self.isStopping = false
	end
	self.autoCount = self.autoCount - 1
	if mine ~= nil then
		SoraDShowLoading(self, nil, nil, true, 5)
		activity_9001649_Ctrl:reqLottery(mine.id, self.isAuto)
	end
end
function Activity_9001649_MainPanel:startNext()
	if self.isStopping then
		return
	end
	if self.isAuto and self.autoCount > 0 and not self.fields.Com_9001649_game:hookStart(true) then
		self.isAuto = false
		self.autoCount = 0
	end
end
function Activity_9001649_MainPanel:onMaskClick()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("explore_ore_text13"))
end
function Activity_9001649_MainPanel:onSkipClick()
	SoraDPlaySound()
	self.isAuto = false
	self.autoCount = 0
	self.controllers.c1:setSelectedIndex(0)
	SoraDShowLoading(self, nil, nil, true, 5)
	activity_9001649_Ctrl:reqLotteryAll()
end
function Activity_9001649_MainPanel:onStopClick()
	SoraDPlaySound()
	if self.isStopping then
		return
	end
	self.isAuto = false
	self.isStopping = true
	self.autoCount = 0
end
function Activity_9001649_MainPanel:showGetRewards(reward, isAll)
	dump(reward, "Activity_9001649_MainPanel:showGetRewards")
	local gotRewards
	if isAll then
		gotRewards, _ENV = self.gotRewards, self.gotRewards
		gotRewards = self.gotRewards or nil
		for i, v in ipairs(reward.rewardsList) do
			table.insert(gotRewards, v)
		end
	else
		if self.gotRewards and reward.rewards[1] then
			reward.id = reward.rewards[1].id
			reward.count = reward.rewards[1].count
			table.insert(self.gotRewards, reward)
		end
		_ENV = reward
		reward.rewards = self.gotRewards
		_ENV, reward.activityTime = activityShowCtrl:getBeginTimeSecond(self.activityID), activityShowCtrl:getBeginTimeSecond(self.activityID)
		activityShowCtrl:getBeginTimeSecond(self.activityID).byUID = true
		SoraDConfigSet("Game:Activity_9001649_MainPanel:showGetRewards~table", reward, (activityShowCtrl:getBeginTimeSecond(self.activityID)))
		self:showEffect()
		if reward.itemorder ~= 1 or self.gotRewards ~= nil then
			SoraDMailGainItems(reward.rewards, true)
		else
			_ENV = activityShowCtrl:getBeginTimeSecond(self.activityID)
			activityShowCtrl:getBeginTimeSecond(self.activityID).rewards = reward.rewards
			uiManager:show("Activity_9001649_BigReward", (activityShowCtrl:getBeginTimeSecond(self.activityID)))
		end
	end
	if self.isAuto and self.autoCount > 0 then
		return
	end
	if gotRewards ~= nil and next(gotRewards) then
		SoraDShowLoading(self, nil, nil, true, 5)
		self:runAction(ffa.seq(ffa.delay(0.3), ffa.callFunc(function()
			SoraDCloseLoading(self)
			self.controllers.c1:setSelectedIndex(0)
			_ENV, _ENV = nil, 0
			;(nil).byUID = true
			SoraDConfigSet("Game:Activity_9001649_MainPanel:showGetRewards~table", 0, nil)
			_ENV = nil
			self, (nil).itemType = nil, 5
			;(nil).rewards, (nil)[1] = nil, gotRewards
			;(nil).width = 540
			uiManager:show("CommonCongratulations", nil)
			self.gotRewards = nil
		end)))
	end
end
function Activity_9001649_MainPanel:showEffect()
	self.fields.line1:setAllFrameNameOnce("dh_9001649_02_%02d.png", 1, false)
	self.fields.line1:stopAllActions()
	self.fields.line1:runAction(ffa.seq(ffa.delay(0.2), ffa.callFunc(function()
		self.fields.line3:setAllFrameNameOnce("dh_9001649_01_%02d.png", 1, false)
	end), ffa.delay(0.3), ffa.callFunc(function()
		self.fields.line2:setAllFrameNameOnce("dh_9001649_02_%02d.png", 1, false)
	end)))
end
function Activity_9001649_MainPanel:onCheat()
	cheatCtrl = nil
	;(nil).command = "sxdxtx"
	cheatCtrl:reqCheat(nil, nil)
	activity_9001649_Ctrl:sendReqInitDataMsg()
end
function Activity_9001649_MainPanel:gameGuide_getTarget(itemName, parameters)
	_UPVALUE2_ = nil
	;(nil)[1] = self.fields[itemName]
	;(nil)[2] = itemName
	dump(nil, "gameGuide_getTarget")
	if itemName == "hook" then
		return self.fields.Com_9001649_game:getGuideRect()
	elseif itemName == "box1" then
		return self.fields.List_box:getChildAt(0)
	end
	return self.fields[itemName]
end
return Activity_9001649_MainPanel
