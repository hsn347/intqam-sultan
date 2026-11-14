local commandHallRead = include("commandHallRead")
local armyDesRead = include("armyDesRead")
local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local commandHallUtil = include("commandHallUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallTaskPanel = class("CommandHallTaskPanel", baseFguiPanel)
function CommandHallTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallTaskPanel:ctor", self.viewName)
	local lordInfo = lordInfoCtrl:getBaseInfo()
	self.curPhysical = lordInfo.physical
	self.physicalUpper = lordInfo.physicalUpper
end
function CommandHallTaskPanel:onInit()
	print("=======CommandHallTaskPanel:onInit")
	self.taskData = self.proxy.param.taskData
	local taskID = self.taskData.taskID
	local taskType = commandHallRead.getTaskType(taskID)
	self.taskType = taskType
	local quality = commandHallRead.getTaskQuality(taskID)
	local ui = self.fields
	ui.Load_flag:setURL(commandHallRead.getQualityFlagImage(quality))
	ui.Load_icon:setURL(commandHallRead.getTaskIcon(taskType))
	ui.Panel_bg:setString(commandHallRead.getTaskName(taskID))
	ui.Text_des:setString(commandHallRead.getTaskDes(taskType))
	self:updateTextPhysical()
	do
		local _obj = ui.Com_physical
		local _ui = fguiHelper.get_fields(_obj)
		_ui.Button_add:addClickListener(handler(self, self.onClickBtnPhysical))
	end
	local c_type = self.controllers.c_type
	if taskType == gCommandHallTaskType.REBEL_ARMY_PIONEER_TASK then
		c_type:setSelectedIndex(0)
		local taskDes = commandHallRead.getTaskDes(taskType)
		taskDes = taskDes .. "\n" .. self:getDamageAndRewardRadioStr(taskType)
		ui.Text_des:setString(taskDes)
		local recommendStr = self:getRecommendStr(taskID)
		ui.Text1_buff:setString(recommendStr)
	else
		c_type:setSelectedIndex(1)
		local qualityName = commandHallRead.getQualityName(quality)
		local color = commandHallRead.getQualityDeepColor(quality)
		_ENV = taskType
		taskType.color = color
		local qualityStr = i18n("commandhall_text_43") .. SoraDWrapHtmlTagByStyle(qualityName, taskType)
		ui.Text2_quality:setString(qualityStr)
		if not self.taskData.isFixedTask then
			local timeLabel = SoraDCreateTimerLabel(nil, ui.Text2_time)
			timeLabel:setTimeLast(function(timeStr, timeNumber)
				if timeNumber < 3600 then
					_ENV = nil
					;(nil).color = "#FF0000"
					timeStr = SoraDWrapHtmlTagByStyle(timeStr, nil)
				end
				return i18n("commandhall_text_48") .. timeStr
			end)
			local remainTime = commandHallCtrl:getTaskRefreshRemainTime()
			timeLabel:beginTime(remainTime)
		end
		local taskDes = commandHallRead.getTaskDes(taskType)
		taskDes = taskDes .. "\n" .. self:getDamageAndRewardRadioStr(taskType)
		if taskType == gCommandHallTaskType.BATTLE_TASK then
			taskDes = taskDes .. "\n" .. self:getRecommendStr(taskID)
		end
		ui.Text_des:setString(taskDes)
	end
	self.fields.Text_reward:setString(i18n("commandhall_text_42"))
	do
		local rewards = commandHallRead.getTaskVictoryReward(taskID)
		self.fields.List_reward:setItemRenderer(function(index, obj)
			local data = rewards[index + 1]
			obj:initData(data.id, data.count)
		end)
		self.fields.List_reward:setNumItems(#rewards)
	end
	ui.Button_attack:addClickListener(handler(self, self.onClickBtnAttack))
	self:updateTaskStatue()
	if not SoraDFIsRA() then
		self.fields.Text1_buff:fixPos()
		self.fields.Text2_quality:fixPos()
		self.fields.Text2_time:fixPos()
	end
end
function CommandHallTaskPanel:updateTaskStatue(...)
	local statue = self.taskData.statue
	local taskID = self.taskData.taskID
	if statue == gCommandHallTaskStatue.FINISH then
		self.fields.Button_attack:setCostNum(0)
		self.fields.Button_attack:setFreeTitle(i18n("common_text_1146"))
	else
		local consume = commandHallRead.getTaskConsume(taskID)
		self.fields.Button_attack:setCostIcon("icon_lord_sp.png")
		self.fields.Button_attack:setCostNum(consume, self.curPhysical)
		self.fields.Button_attack:setString(i18n("common_text_477"))
	end
end
function CommandHallTaskPanel:onShow()
	print("=======CommandHallTaskPanel:onShow")
end
function CommandHallTaskPanel:onHide()
	print("=======CommandHallTaskPanel:onHide")
	local proxy = uiManager:getProxy("CommandHallMain")
	if proxy then
		proxy:reSetAllTaskSingle()
	end
end
function CommandHallTaskPanel:onClickBtnGo(...)
	SoraDPlaySound()
	local ok, taskType = commandHallUtil.checkTaskPanelShowBtnGo()
	if ok then
		_ENV = nil
		;(nil).msg = "MESSAGE_COMMANDHALL_SELECT_TASK"
		;(nil).taskType = taskType
		SoraDSendMessage(nil)
	end
end
function CommandHallTaskPanel:onClickBtnAttack(...)
	SoraDPlaySound()
	local statue = self.taskData.statue
	if statue == gCommandHallTaskStatue.FINISH then
		commandHallCtrl:reqCommitTask(self.taskData.type, self.taskData.index)
		SoraDShowLoading(self:displayObject())
		return
	end
	local consume = commandHallRead.getTaskConsume(self.taskData.taskID)
	if consume > self.curPhysical then
		SoraDShowMsgBox(i18n("common_text_988"), i18n("common_text_204"), nil, function(exitType)
			if exitType == MSGBOX_CALLBACK_YES then
				SoraDCreatePanel("physicalBuyView"):show()
			end
		end)
		commandHallUtil.checkFinishGuide()
		return
	end
	if not commandHallUtil.checkTaskTypeNeedArmy(self.taskType) then
		local dispatch = function()
			local proxy = uiManager:getProxy("CommandHallMain")
			if proxy then
				proxy:showDispatch(self.taskData.index)
			end
			self:closePanel()
		end
		if not self.taskData.isFixedTask then
			local constantRead = include("constantRead")
			local COMMANDHALL_PROMPT_TIME = constantRead.getConstValue("COMMANDHALL_PROMPT_TIME", 0)
			local remainTime = commandHallCtrl:getTaskRefreshRemainTime()
			if COMMANDHALL_PROMPT_TIME > remainTime then
				_ENV = self:displayObject()
				self:displayObject().time = SoraDConvertSecondToString(remainTime)
				local showMsg = i18n("commandhall_text_72", self:displayObject())
				SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(eventType)
					if eventType == MSGBOX_CALLBACK_YES then
						dispatch()
					end
				end)
				return
			end
		end
		dispatch()
	elseif self.taskData.obj and self.taskData.obj.x then
		if SoraDCurrentSceneShowView("mainCityView") then
			SoraDShowLoading(self:displayObject())
			commandHallCtrl:reqRefreshPos2(self.taskData.obj)
		else
			local pos = mapSyncUtilClient.serverTOClientPos(cc.p(self.taskData.obj.x, self.taskData.obj.y))
			SoraDRemoveAllPanelFromManager()
			SoraDGotoWorldMapPoint(pos, true)
		end
	end
end
function CommandHallTaskPanel:updatePhysical(...)
	self.curPhysical = lordInfoCtrl:getBaseInfo().physical
	local statue = self.taskData.statue
	if statue ~= gCommandHallTaskStatue.FINISH then
		local consume = commandHallRead.getTaskConsume(self.taskData.taskID)
		self.fields.Button_attack:setCostNum(consume, self.curPhysical)
	end
	self:updateTextPhysical()
end
function CommandHallTaskPanel:getTaskType(...)
	return self.taskType
end
function CommandHallTaskPanel:getTaskStatue(...)
	return self.taskData.statue
end
function CommandHallTaskPanel:getTaskData(...)
	return self.taskData
end
function CommandHallTaskPanel:updateTaskData(taskData)
	self.taskData = taskData
	self:updateTaskStatue()
end
function CommandHallTaskPanel:getDamageAndRewardRadioStr(taskType)
	local armyGroupID = commandHallCtrl:getArmyGroupID()
	local taskID = commandHallRead.getTaskIDByOrder(armyGroupID)
	local taskDamage = commandHallRead.getTaskDamage(taskID, taskType)
	local curRadioStr = commandHallCtrl:getCurDamageRadioStr()
	local curRadio = commandHallCtrl:getCurDamageRadio()
	local tmpRadio = curRadio.value
	if curRadio.valueType == 1 then
		tmpRadio = math.ceil(tmpRadio / 1000 * taskDamage)
	end
	commandHallCtrl = nil
	;(nil).num1 = taskDamage
	;(nil).num2 = tmpRadio
	local ret = i18n("commandhall_text_85", nil)
	local curRadio = commandHallCtrl:getCurRewardRadio()
	commandHallCtrl = nil
	;(nil).num = curRadio
	ret = ret .. "\n" .. i18n("commandhall_text_104", nil)
	return ret
end
function CommandHallTaskPanel:getRecommendStr(taskID)
	local hero = commandHallRead.getRecommendHero(taskID)
	local army = commandHallRead.getRecommendArmy(taskID)
	commandHallRead = nil
	;(nil).num1 = string.formatnumberthousands(hero)
	;(nil).num2 = string.formatnumberthousands(army)
	return i18n("commandhall_text_86", nil)
end
function CommandHallTaskPanel:onClickBtnPhysical(...)
	SoraDPlaySound()
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local itemLogic = include("itemLogic")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local resList = backpackltCtrl:getItemArray(gItemType.STAMINA)
	for __, itemID in ipairs(resList) do
		local itemCount = backpackCtrl:getItemCount(itemID)
		if 0 < itemCount and itemLogic.checkUseCond(itemID) then
			SoraDCreatePanel("physicalBuyView"):show()
			return true
		end
	end
	local itemDesRead = include("itemDesRead")
	local itemID = gIDDef.STAMINA
	local output = itemDesRead.getOutput(itemID)
	local _ENV, ret = itemID, itemID
	for __, sourceId in ipairs(output) do
		if sourceId == 162 then
			local curChapterID = SoraDGetCtrl("newPlayerTaskCtrl"):getCurChapterID()
			if curChapterID and 0 < curChapterID then
				table.insert(ret, sourceId)
			end
		elseif sourceId == 163 then
			local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
			if not soldierRushCtrl:checkFinishAllGate() then
				table.insert(ret, sourceId)
			end
		else
			table.insert(ret, sourceId)
		end
	end
	if #ret <= 1 then
		SoraDCreatePanel("physicalBuyView"):show()
	else
		_ENV = SoraDCreatePanel("physicalBuyView")
		SoraDCreatePanel("physicalBuyView").sources = ret
		uiManager:show("CommonSourceGuide", (SoraDCreatePanel("physicalBuyView")))
	end
end
function CommandHallTaskPanel:updateTextPhysical(...)
	_ENV = nil
	;(nil).member = self.curPhysical
	;(nil).total = self.physicalUpper
	self.fields.Com_physical:setString(i18n("common_text_155", nil))
end
function CommandHallTaskPanel:gameGuide_getTarget(itemName, parameters)
	if self.fields[itemName] then
		return self.fields[itemName]
	end
	return self.fields[itemName]
end
return CommandHallTaskPanel
