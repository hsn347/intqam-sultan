local cityCtrl = SoraDGetCtrl("cityCtrl")
local commandHallRead = include("commandHallRead")
local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local instanceFactory = include("instanceFactory")
local commandHallUtil = include("commandHallUtil")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallMainPanel = class("CommandHallMainPanel", baseFguiPanel)
_ENV = "CommandHallMainPanel"
;("CommandHallMainPanel").LV = 1
local ("CommandHallMainPanel").TASK, FINGER_TYPE = 2, "CommandHallMainPanel"
function CommandHallMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallMainPanel:ctor", self.viewName)
	self.taskObjList, _ENV, self.data, _ENV, self.isHideCurrentSceneView = print, print, print, print, true
	self.taskPosList = self.proxy:getTaskPosListConfig()
	self.showFinish = self.proxy.param and self.proxy.param.showFinish
	self:checkLmpbHdRes()
end
function CommandHallMainPanel:onClickClose(...)
	if SoraDCurrentSceneShowView("mainCityView") then
		_ENV = "mainCityView"
		;("mainCityView").msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
		;("mainCityView").buildIndex = BUILDID.CommandHall
		;("mainCityView").delay = 0
		SoraDSendMessage("mainCityView")
	end
	self.super.onClickClose(self, ...)
end
function CommandHallMainPanel:onInit()
	print("=======CommandHallMainPanel:onInit")
	local ui = self.fields
	ui.Com_title:initData(i18n("commandhall_text_1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	ui.Button_warn:addClickListener(handler(self, self.onClickBtnWarn))
	self.c_state_warning = ui.Button_warn:getController("c_state")
	self:updateBtnWaring()
	do
		local _obj = self.fields.Com_commandLv
		_obj:addClickListener(handler(self, self.onClickBtnCommandLv))
		local _ui = fguiHelper.get_fields(_obj)
		_ui.Bar_exp:fixChildrenPos()
		_obj.c_lv = _ui.Com_lv:getController("c_lv")
		_obj.c_effect = _ui.Com_lv:getController("c_effect")
		local Com_lv = fguiHelper.get_fields(_ui.Com_lv)
		Com_lv.MovieClip_tkd:setAllFrameName("dh_tsdt_tkd_%02d.png", 1)
		Com_lv.MovieClip_tksc:setAllFrameName("dh_tsdt_tksc_%02d.png", 1)
		Com_lv.MovieClip_jiantou:setAllFrameName("dh_tsdt_jt_%02d.png", 1)
	end
	ui.Button_reward:setString(i18n("decrypt_text_03"))
	ui.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	ui.Button_rank:setString(i18n("common_text_851"))
	ui.Button_rank:addClickListener(handler(self, self.onClickBtnRank))
	self.fieldsMap = fguiHelper.get_fields(self.fields.Com_hallMap)
	local Com_palace = self.fieldsMap.Com_palace
	Com_palace:addClickListener(handler(self, self.onClickBtnPalace))
	self.Group_palaceTime = Com_palace:getChild("Group_time")
	self.Group_palaceTime:setVisible(false)
	local Text_palaceTime = SoraDCreateTimerLabel(nil, Com_palace:getChild("Text_time"))
	Text_palaceTime:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("commandhall_text_73", nil)
	end)
	self.Text_palaceTime = Text_palaceTime
	local Text_noTask = SoraDCreateTimerLabel(nil, self.fieldsMap.Text_noTask)
	Text_noTask:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("commandhall_text_68") .. "," .. i18n("commandhall_text_78", nil)
	end)
	self.Text_noTask = Text_noTask
	self.fields.Com_TSDT_tips:setTipType(2)
	self.fieldsMap.Node_solider:setSortingOrder(100)
	self.fields.Com_MainReward:setLoadingParent(self:displayObject())
end
function CommandHallMainPanel:onShow()
	print("=======CommandHallMainPanel:onShow")
	self.defaultSelect = self.proxy.param and self.proxy.param.defaultSelect
	if commandHallCtrl:checkIsDataInit() then
		self:updateInitData()
	else
		SoraDShowLoading(self:displayObject())
		commandHallCtrl:reqInit()
	end
end
function CommandHallMainPanel:reSetAllTaskSingle(...)
	for __, obj in pairs(self.taskObjList) do
		obj.Button_task:setSelected(false)
	end
end
function CommandHallMainPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("commandhall_text_2"))
end
function CommandHallMainPanel:updateInitData()
	self.data = commandHallCtrl:getInitData()
	self.hurtHp = commandHallCtrl:getArmyGroupTaskHurtHp()
	self:updateCommandLv()
	self:onInitMap()
	if SoraDIsGameGuide() and SoraDIsGameGuide() < 910110 then
		if not commandHallCtrl:getArmyPioneerTaskData() then
			local commandHallCtrl, task = commandHallCtrl:getArmyPioneerTaskData(), commandHallCtrl:getArmyPioneerTaskData()
		end
		if not next(task) or task.statue == gCommandHallTaskStatue.FINISH then
			commandHallUtil.checkFinishGuide()
		end
	end
end
function CommandHallMainPanel:onClickBtnWarn(...)
	SoraDPlaySound()
	uiManager:show("CommandHallWarnSetting")
end
function CommandHallMainPanel:updateBtnWaring(...)
	local showWarning = commandHallUtil.getConfigShowWarning()
	self.c_state_warning:setSelectedIndex(showWarning and 1 or 0)
end
function CommandHallMainPanel:onClickBtnCommandLv(...)
	SoraDPlaySound()
	self:hideFinger()
	uiManager:show("CommandHallLv")
end
function CommandHallMainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	uiManager:show("CommandHallAward")
end
function CommandHallMainPanel:onClickBtnRank(...)
	SoraDPlaySound()
	uiManager:show("CommandHallRank")
end
function CommandHallMainPanel:onInitMap(...)
	for __, obj in pairs(self.taskObjList) do
		obj:removeFromParent()
	end
	self.tilesMap, _ENV, self.taskObjList, _ENV = pairs(self.taskObjList)
	self.mapTileSize = cc.size(12, 8)
	self.playerTilePos = cc.p(10, 3)
	self.fieldsMap.Image_player:setSortingOrder(self.playerTilePos.y + 1)
	local tilesArray = instanceFactory.getTilesArrayByInstace(self.playerTilePos, 2)
	for i, v in ipairs(tilesArray) do
		self.tilesMap[v] = true
	end
	self.palaceTilePos = cc.p(0, 3)
	self.fieldsMap.Com_palace:setSortingOrder(self.palaceTilePos.y + 1)
	local tilesArray = instanceFactory.getTilesArrayByInstace(self.palaceTilePos, 2)
	for i, v in ipairs(tilesArray) do
		self.tilesMap[v] = true
	end
	self:initPalace2PlayerTileMap(self.palaceTilePos, self.playerTilePos)
	self:updateArmyGroupTask()
	for key, tilePos in pairs(self.taskPosList) do
		local key1 = commandHallUtil.getTilePosKey(tilePos)
		if self.tilesMap[key1] then
			self.taskPosList[key] = nil
		else
			local key2 = commandHallUtil.getTilePosKey(cc.p(tilePos.x, tilePos.y + 1))
			if self.tilesMap[key2] then
				self.taskPosList[key] = nil
			else
				self.tilesMap[key1] = true
				self.tilesMap[key2] = true
			end
		end
	end
	self:updateTaskList()
	local _ENV, ret = self.updateTaskList, self.updateTaskList
	for __, task in ipairs(self.taskList) do
		local index = task.index or 0
		local key = task.type .. "," .. index
		ret[key] = self.taskPosList[key]
	end
	self.taskPosList = ret
	self.proxy:setTaskPosListConfig(self.taskPosList)
	local index = 0
	self:stopAllActions()
	instanceFactory = 0
	;(0)[1] = ffa.callFunc(function()
		if index > #self.taskList then
			dump(self.tilesMap, "==self.tilesMap==")
			self:stopAllActions()
			self:showTaskFinger()
			return
		end
		local task = self.taskList[index]
		self:initTaskSingle(task)
	end)
	;(0)[2] = ffa.delay(0.06666666666666667)
	;(0)[3] = ffa.delay(0.06666666666666667)
	self:runAction(ffa.repeatForever(ffa.seq(0)))
end
function CommandHallMainPanel:initTaskSingle(task)
	local taskType = task.type
	local index = task.index or 0
	local gobj = fgui.UIPackage:createObject("CommandHall", "Com_taskSingle")
	self.taskObjList[tostring(index)] = gobj
	local size = gobj:getContentSize()
	local tilePos
	local zorder = 0
	if taskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
		tilePos = cc.p(self.palaceTilePos.x + 0.5, self.palaceTilePos.y)
		zorder = 99
	else
		local key = taskType .. "," .. index
		if self.taskPosList[key] then
			tilePos = self.taskPosList[key]
		else
			tilePos = self:getRandomTilePos()
			self.taskPosList[key] = tilePos
			self.proxy:setTaskPosListConfig(self.taskPosList)
			local key = commandHallUtil.getTilePosKey(tilePos)
			self.tilesMap[key] = true
			local key = commandHallUtil.getTilePosKey(cc.p(tilePos.x, tilePos.y + 1))
			self.tilesMap[key] = true
		end
		zorder = tilePos.y + 1
	end
	self.fields.Com_hallMap:addChild(gobj, zorder)
	local pos = commandHallUtil.tilePos2MapPos(cc.p(tilePos.x, tilePos.y + 0.5))
	gobj:setPosition(pos.x - size.width / 2, pos.y - size.height / 2)
	gobj:setTag(index)
	gobj.taskType = taskType
	local ui = fguiHelper.get_fields(gobj)
	local Button_task = ui.Button_task
	gobj.Button_task = Button_task
	Button_task:setTag(index)
	Button_task:addClickListener(handler(self, self.onClickBtnTask))
	local c_state = Button_task:getController("c_state")
	gobj.c_state = c_state
	if task.statue == gCommandHallTaskStatue.FINISH then
		c_state:setSelectedIndex(1)
	else
		c_state:setSelectedIndex(0)
	end
	ui.mv_shuaxin:setAllFrameNameOnce("dh_tsrwsx_%02d.png", 1, false)
	gobj.mv_shandian = ui.mv_shandian
	gobj.mv_shandian:setVisible(false)
	gobj.mv_huoyan = ui.mv_huoyan
	gobj.mv_huoyan:setVisible(false)
	local _ui = fguiHelper.get_fields(Button_task)
	local quality = commandHallRead.getTaskQuality(task.taskID)
	local bgImage = commandHallRead.getQualityBgImage(quality)
	_ui.Load_bg:setURL(bgImage)
	local taskIcon = commandHallRead.getTaskIcon(taskType)
	Button_task:setIcon(taskIcon)
	local c_type = Button_task:getController("c_type")
	local c_effect = Button_task:getController("c_effect")
	if taskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
	else
		c_type:setSelectedIndex(1)
		_ui.Usm_1:setVisible(false)
		if 5 <= quality then
			_ui.MovieClip_1:setAllFrameName("dh_tongshuaidttb_%02d.png", 1)
			_ui.MovieClip_2:setAllFrameName("dh_tsjingbao_%02d.png", 1)
		end
	end
	if taskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK or quality < 5 then
		c_effect:setSelectedIndex(0)
	elseif quality == 5 then
		c_effect:setSelectedIndex(1)
	elseif quality == 6 then
		c_effect:setSelectedIndex(2)
	end
	local Com_reddot = _ui.Com_reddot
	Com_reddot:getChild("mv_bx1"):setAllFrameNameOnce("dh_tsdt_bx_%02d.png", 1)
	if self.defaultSelect and self.defaultSelect == taskType then
		self.defaultSelect = nil
		Button_task:setSelected(true)
		_ENV = 1
		;(1).taskData = commandHallCtrl:getTaskByIndex(index)
		uiManager:show("CommandHallTask", 1)
	end
end
function CommandHallMainPanel:getRandomTilePos(...)
	for i = 1, 10000 do
		local randomTilePos = cc.p(math.random(0, self.mapTileSize.width - 1), math.random(0, self.mapTileSize.height - 1))
		local key = commandHallUtil.getTilePosKey(randomTilePos)
		if not self.tilesMap[key] then
			local randomTilePos = cc.p(randomTilePos.x, randomTilePos.y - 1)
			if 0 <= randomTilePos.y then
				local key = commandHallUtil.getTilePosKey(randomTilePos)
				if not self.tilesMap[key] then
					return randomTilePos
				end
			end
		end
	end
	return cc.p(0, 0)
end
function CommandHallMainPanel:onClickBtnPalace(...)
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("commandhall_text_66"), i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			SoraDRemoveAllPanelFromManager()
			SoraDGotoWorldMapPoint(cc.p(600, 600))
		end
	end)
end
function CommandHallMainPanel:onClickBtnTask(EventContext)
	SoraDPlaySound()
	self:hideFinger()
	local index = EventContext:getSender():getTag()
	local task = commandHallCtrl:getTaskByIndex(index)
	if not task then
		return
	end
	if task.statue == gCommandHallTaskStatue.FINISH then
		commandHallCtrl:reqCommitTask(task.type, task.index)
		SoraDShowLoading(self:displayObject())
	else
		_ENV = self:displayObject()
		self:displayObject().taskData = task
		uiManager:show("CommandHallTask", self:displayObject())
	end
end
function CommandHallMainPanel:updateCommandLv(...)
	self.data = commandHallCtrl:getInitData()
	local _obj = self.fields.Com_commandLv
	local _ui = fguiHelper.get_fields(_obj)
	local curLv = self.data.commandLv
	local iconLv = commandHallRead.getCommandLvIconLv(curLv)
	_obj.c_lv:setSelectedIndex(iconLv - 1)
	local showRed = commandHallCtrl:getLvReceiveStatus()
	_obj.c_effect:setSelectedIndex(showRed and 1 or 0)
	if showRed then
		guideCtrl:updateGuideModule(gGuideModule.COMMAND_HALL2)
		self:showLvFinger()
	end
	commandHallCtrl = nil
	;(nil).lv = curLv
	_ui.Text_lv:setString(i18n("commandhall_text_3", nil))
	local commandLvMax = commandHallRead.getCommandLvMax()
	if curLv < commandLvMax then
		local needExp = commandHallRead.getCommandLvNeedExp(curLv)
		_ui.Bar_exp:setMax(needExp)
		_ui.Bar_exp:setValue(self.data.commandExp)
	else
		_ui.Bar_exp:getChild("title"):setString(i18n("commandhall_text_4"))
	end
end
function CommandHallMainPanel:setTaskSingleSelected(obj)
	if obj then
		obj.Button_task:setSelected(true)
		local index = obj:getTag()
		_ENV = nil
		;(nil).taskData = commandHallCtrl:getTaskByIndex(index)
		uiManager:show("CommandHallTask", nil)
	end
end
function CommandHallMainPanel:selectTaskByTaskType(taskType)
	local obj = self:getTaskSingle(taskType)
	self:setTaskSingleSelected(obj)
end
function CommandHallMainPanel:selectTaskByIndex(index)
	local obj = self:getTaskSingleByIndex(index)
	self:setTaskSingleSelected(obj)
end
function CommandHallMainPanel:initPalace2PlayerTileMap(beginTile, endTile)
	local setTilesMap = function(tilePos)
		local key = commandHallUtil.getTilePosKey(tilePos)
		self.tilesMap[key] = true
		local Com_mapTile = self.fieldsMap.Com_mapTile
		if Com_mapTile then
			local index = tilePos.x + tilePos.y * 12
			local image = Com_mapTile:getChild("Image" .. index)
			if image then
				image:setVisible(false)
			end
		end
	end
	local stepx = beginTile.x < endTile.x and 1 or -1
	for x = beginTile.x, endTile.x, stepx do
		local stepy = beginTile.y <= endTile.y and 1 or -1
		for y = beginTile.y, endTile.y + 1, stepy do
			local tilePos = cc.p(x, y)
			setTilesMap(tilePos)
		end
	end
end
function CommandHallMainPanel:updateCommitTask(target, event)
	dump(event, "==CommandHallMainPanel:updateCommitTask==")
	SoraDCloseLoading(self:displayObject())
	self.data = commandHallCtrl:getInitData()
	self:updateCommandLv()
	self:updateTaskList()
	if not event.diffList then
		local _ENV, diffList = event.diffList, event.diffList
	end
	if not diffList.removeList then
		local _ENV, removeList = diffList.removeList, diffList.removeList
	end
	if not diffList.addList then
		local _ENV, addList = diffList.addList, diffList.addList
	end
	if not diffList.updateList then
		local _ENV, updateList = diffList.updateList, diffList.updateList
	end
	for __, _index in ipairs(removeList) do
		local obj = self.taskObjList[tostring(_index)]
		if obj then
			obj:removeFromParent()
			self.taskObjList[tostring(_index)] = nil
		end
	end
	local isUpdate = false
	for __, _index in ipairs(addList) do
		local task = commandHallCtrl:getTaskByIndex(_index)
		if task.type == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
			self:updateArmyGroupTask()
			isUpdate = true
		else
			self:initTaskSingle(task)
		end
	end
	for __, _index in ipairs(updateList) do
		local obj = self.taskObjList[tostring(_index)]
		if obj then
			local c_state = obj.c_state
			local task = commandHallCtrl:getTaskByIndex(_index)
			if task.statue == gCommandHallTaskStatue.FINISH then
				c_state:setSelectedIndex(1)
			else
				c_state:setSelectedIndex(0)
			end
		end
	end
	self:updateHurtHp()
	if not isUpdate and event.commitType and event.commitType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
		self:updateArmyGroupTask()
	end
end
function CommandHallMainPanel:updateHurtHp(...)
	if not commandHallCtrl:hasArmyGroupTask() then
		self.hurtHp = 0
		return
	end
	local task = commandHallCtrl:getArmyGroupTaskData()
	local _hurtHp = task.hurtHp
	if _hurtHp == 0 then
		self.hurtHp = 0
	end
	local _rabelHp = task.rabelHp
	if _hurtHp > self.hurtHp and _rabelHp > self.hurtHp then
		self.hurtHp = _hurtHp
		_UPVALUE3_ = nil
		;(nil)[1] = ffa.delay(1.0)
		;(nil)[2] = ffa.callFunc(function()
			self.fields.Com_MainReward:showShandianEffect()
		end)
		;(nil)[3] = ffa.delay(0.5)
		;(nil)[4] = ffa.callFunc(function()
			self.fields.Com_MainReward:showHpEffect()
		end)
		;(nil)[5] = ffa.callFunc(function()
			self.fields.Com_MainReward:showHpEffect()
		end)
		self.fields.Com_MainReward:runAction(ffa.seq(nil))
	end
end
function CommandHallMainPanel:updateTaskList(...)
	local commandHallCtrl, ret
	local taskList = commandHallCtrl:getTaskList()
	for __, task in ipairs(taskList) do
		if task.type ~= gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
			table.insert(ret, task)
		end
	end
	self.taskList = ret
	local taskCount = #self.taskList
	local noTask = taskCount == 0 and not commandHallCtrl:hasArmyGroupTask()
	self.fieldsMap.Image_noTask:setVisible(noTask)
	self.Text_noTask:setVisible(noTask)
	if noTask then
		local order = commandHallCtrl:getArmyGroupID()
		if commandHallRead.isCommandLvRandom(order) then
			local remainTime = commandHallCtrl:getTaskRefreshRemainTime()
			self.Text_noTask:beginTime(remainTime)
		else
			self.Text_noTask:setString(i18n("commandhall_text_68"))
		end
	end
end
function CommandHallMainPanel:updateArmyGroupTask(...)
	local showWarning = false
	local task = commandHallCtrl:getArmyGroupTaskData()
	local hasTask = task and task.statue and task.statue ~= gCommandHallTaskStatue.FINISH
	if hasTask and commandHallUtil.checkShowFlashRed(task.armyGroupID) then
		showWarning = true
	end
	self.fields.imgWarning:setVisible(showWarning)
	if task and next(task) then
		self.Group_palaceTime:setVisible(false)
	else
		self.Group_palaceTime:setVisible(true)
		local remianTime = serviceFunctions.getTodayRemainTime()
		self.Text_palaceTime:beginTime(remianTime)
	end
	if self.moveLine then
		self.moveLine:removeFromParent()
		self.moveLine = nil
	end
	if self.solider then
		self.solider:removeFromParent()
		self.solider = nil
	end
	if hasTask then
		local beginPoint, endPoint = self:getArmyGroupPosition()
		self.moveLine = self:createMoveLine(beginPoint, endPoint)
		self:createArmyGroupSolider()
	end
	self.fields.Com_MainReward:initData()
end
function CommandHallMainPanel:setUsmGray(com_usm, isGray)
	local color = isGray and cc.c3b(149, 149, 149) or cc.c3b(255, 255, 255)
	com_usm:getCriSprite():setColor(color)
end
function CommandHallMainPanel:createMoveLine(beginPoint, endPoint, moveLineColor)
	local moveLine = include("worldMapMoveLine").new(beginPoint, endPoint)
	moveLine:setPosition(beginPoint)
	moveLine:addTo(self.fieldsMap.Node_moveLine:displayObject(), -1)
	moveLine:setVisible(true)
	moveLine:setMoveLineColor(moveLineColor or gMapMoveLineColor.moveLineColorRed)
	return moveLine
end
function CommandHallMainPanel:addDetectionSolider(beginPoint, endPoint, otherData)
	local solider
	local currentMoveTime, marchTime = 0, 0
	local task = otherData and otherData.task
	if task and task.type == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
		solider = include("romanSoulSolider").new()
		solider:setScale(0.8)
		marchTime = task.moveEndTime - task.createTime
		local moveTime = serviceFunctions.systemTime() - task.createTime
		currentMoveTime = math.max(0, math.min(marchTime, moveTime))
	else
		solider = include("detectionSolider").new()
		currentMoveTime = 0
		marchTime = commandHallUtil.getCommonTaskMarchTime()
	end
	solider:setPosition(beginPoint)
	solider:initData(beginPoint, endPoint)
	_ENV = solider.initData
	_ENV, _ENV, solider.initData.currentMoveTime = beginPoint, solider, currentMoveTime
	beginPoint.distancePrecent = 1
	solider.initData.moveTimeSpan, solider[1], beginPoint.time = solider, beginPoint, marchTime
	local moveTimeData = solider.initData
	solider:setMoveTimeData(moveTimeData)
	solider:addTo(self.fieldsMap.Node_solider:displayObject(), -1)
	solider:setVisible(true)
	local moveLine = otherData and otherData.moveLine
	solider:setMoveLine(moveLine)
	local matrixState = otherData and otherData.matrixState or gMapMoveLineStatusType.moveLineStatusTypeMoving
	solider:setMatrixState(matrixState)
	return solider
end
function CommandHallMainPanel:showDispatch(taskIndex)
	local obj = self:getTaskSingleByIndex(taskIndex)
	local objPos = obj:getPosition()
	local mapSize = self.fields.Com_hallMap:getContentSize()
	local beginPoint = cc.p(objPos.x + 25, mapSize.height - objPos.y - 40)
	local playerPos = self.fieldsMap.Image_player:getPosition()
	local endPoint = cc.p(playerPos.x, mapSize.height - playerPos.y)
	local moveLine = self:createMoveLine(endPoint, beginPoint, gMapMoveLineColor.moveLineColorGreen)
	_ENV = nil
	;(nil).moveLine = moveLine
	local solider = self:addDetectionSolider(endPoint, beginPoint, nil)
	local marchTime = commandHallUtil.getCommonTaskMarchTime()
	SoraDShowLoading(self:displayObject(), nil, nil, true)
	commandHallUtil = nil
	;(nil)[1] = cca.delay(marchTime)
	;(nil)[2] = cca.callFunc(function()
		if not tolua.isnull(solider) then
			solider:removeFromParent()
		end
		if not tolua.isnull(moveLine) then
			moveLine:removeFromParent()
		end
		SoraDCloseLoading(self:displayObject())
		local taskData = commandHallCtrl:getTaskByIndex(taskIndex)
		if not taskData then
			SoraDShowMsgTip(i18n("notice_0026"))
			return
		end
		local taskType = taskData.type
		if taskType == gCommandHallTaskType.DIALOGUE_TASK then
			_ENV = i18n("notice_0026")
			i18n("notice_0026").taskData = taskData
			uiManager:show("CommandHallTalk", i18n("notice_0026"))
		elseif taskType == gCommandHallTaskType.RESCUE_TASK then
			commandHallCtrl:reqFinishTask(taskIndex)
		elseif taskType == gCommandHallTaskType.SNIPE_HUNTER_TASK then
			commandHallCtrl:setSoldierRushResultIndex(taskIndex)
		end
	end)
	;(nil)[3] = cca.callFunc(function()
		if not tolua.isnull(solider) then
			solider:removeFromParent()
		end
		if not tolua.isnull(moveLine) then
			moveLine:removeFromParent()
		end
		SoraDCloseLoading(self:displayObject())
		local taskData = commandHallCtrl:getTaskByIndex(taskIndex)
		if not taskData then
			SoraDShowMsgTip(i18n("notice_0026"))
			return
		end
		local taskType = taskData.type
		if taskType == gCommandHallTaskType.DIALOGUE_TASK then
			_ENV = i18n("notice_0026")
			i18n("notice_0026").taskData = taskData
			uiManager:show("CommandHallTalk", i18n("notice_0026"))
		elseif taskType == gCommandHallTaskType.RESCUE_TASK then
			commandHallCtrl:reqFinishTask(taskIndex)
		elseif taskType == gCommandHallTaskType.SNIPE_HUNTER_TASK then
			commandHallCtrl:setSoldierRushResultIndex(taskIndex)
		end
	end)
	self:runAction(cca.seq(nil))
end
function CommandHallMainPanel:checkLmpbHdRes(...)
	local hasHD = worldMapDefine.hasLmqbHdRes()
	if hasHD then
		return
	end
	local ret = _G.SoraDIsFileExistByKey("worldMapLmzh")
	if not ret then
		return
	end
	display.addSpriteFrames("worldMap/worldMapLmzh.plist", "worldMap/worldMapLmzh.png", function(plist)
		if self.solider then
			self.solider:removeFromParent()
			self:createArmyGroupSolider()
		end
	end)
end
function CommandHallMainPanel:createArmyGroupSolider(...)
	local beginPoint, endPoint = self:getArmyGroupPosition()
	local task = commandHallCtrl:getArmyGroupTaskData()
	local matrixState = gMapMoveLineStatusType.moveLineStatusTypeMoving
	if not task.armyGroupIsMoving then
		matrixState = gMapMoveLineStatusType.moveLineStatusTypeWorking
	end
	commandHallCtrl = nil
	;(nil).task = task
	;(nil).matrixState = matrixState
	;(nil).moveLine = self.moveLine
	local solider = self:addDetectionSolider(beginPoint, endPoint, nil)
	self.solider = solider
end
function CommandHallMainPanel:getArmyGroupPosition(...)
	local palacePos = self.fieldsMap.Com_palace:getPosition()
	local playerPos = self.fieldsMap.Image_player:getPosition()
	local mapSize = self.fields.Com_hallMap:getContentSize()
	local beginPoint = cc.p(palacePos.x, mapSize.height - palacePos.y)
	local endPoint = cc.p(playerPos.x, mapSize.height - playerPos.y)
	return beginPoint, endPoint
end
function CommandHallMainPanel:showLvFinger(...)
	local _obj = self.fields.Com_commandLv
	local posx = _obj:getPositionX() + 120
	local posy = _obj:getPositionY() + 20
	_ENV = nil
	;(nil).position = cc.p(posx, self.view:getSize().height - posy)
	;(nil).fingerType = FINGER_TYPE.LV
	self:showFinger(nil)
end
function CommandHallMainPanel:showTaskFinger(...)
	if self.showTaskFingerOnce then
		return
	end
	self.showTaskFingerOnce = true
	local taskIndex = commandHallUtil.getRandomNotFinishTask()
	if taskIndex then
		local obj = self.taskObjList[tostring(taskIndex)]
		if obj == nil then
			return
		end
		local posx = self.fields.Com_hallMap:getPositionX() + obj:getPositionX() + 25
		local posy = self.fields.Com_hallMap:getPositionY() + obj:getPositionY() + 35
		commandHallUtil = nil
		;(nil).position = cc.p(posx, self.view:getSize().height - posy)
		;(nil).fingerType = FINGER_TYPE.TASK
		self:showFinger(nil)
	end
end
function CommandHallMainPanel:showFinger(data)
	if not self.spriteFinger then
		local spriteFinger = SoraDFingerAction()
		spriteFinger:addTo(self.view:displayObject())
		spriteFinger:setScale(0.8)
		self.spriteFinger = spriteFinger
	end
	local position = data.position
	local fingerType = data.fingerType
	local curType = self.spriteFinger.fingerType
	if curType and fingerType > curType then
		return
	end
	self.spriteFinger:setVisible(true)
	self.spriteFinger:setPosition(position)
	self.spriteFinger.fingerType = fingerType
	_UPVALUE1_ = self.spriteFinger
	self.spriteFinger[1] = cca.delay(3.1666666666666665)
	self.spriteFinger[2] = cca.callFunc(function()
		self:hideFinger()
	end)
	self.spriteFinger[3] = cca.callFunc(function()
		self:hideFinger()
	end)
	local seq = cca.seq(self.spriteFinger)
	self.spriteFinger:runAction(seq)
end
function CommandHallMainPanel:hideFinger()
	if self.spriteFinger then
		self.spriteFinger:removeFromParent()
		self.spriteFinger = nil
	end
end
function CommandHallMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Com_taskSingle" then
		local taskType = parameters.taskType
		local obj = self:getTaskSingle(taskType, parameters.taskStatue or gCommandHallTaskStatue.BEGIN)
		if obj then
			return obj.Button_task
		else
			commandHallUtil.checkFinishGuide()
		end
	elseif itemName == "Button_close" then
		return self.fields.Com_title:getCloseBtn()
	elseif itemName == "Button_go1" or itemName == "Guide_rect1" or itemName == "Button_attack" or itemName == "Button_get" then
		return self.fields.Com_MainReward:gameGuide_getTarget(itemName, parameters)
	end
	return self.fields[itemName]
end
function CommandHallMainPanel:getTaskSingle(taskType, statue)
	for __, obj in pairs(self.taskObjList) do
		local index = obj:getTag()
		local task = commandHallCtrl:getTaskByIndex(index)
		if (not taskType or taskType == task.type) and (not statue or statue == task.statue) then
			return obj
		end
	end
end
function CommandHallMainPanel:getTaskSingleByIndex(index)
	for __, obj in pairs(self.taskObjList) do
		if index == obj:getTag() then
			return obj
		end
	end
end
return CommandHallMainPanel
