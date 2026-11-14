local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local commandHallCtrl = class("commandHallCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local commandHallRead = include("commandHallRead")
function commandHallCtrl:ctor(properties)
	commandHallCtrl.super.ctor(self, properties)
	self:resetData()
end
function commandHallCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_UPGRADE_COMMAND_LV, handler(self, self.reqUpgradeCommandLvRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_UPGRADE_POWER_LV, handler(self, self.reqUpgradePowerLvRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_FINISH_TASK, handler(self, self.reqFinishTaskRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_SET_DEFEND, handler(self, self.reqSetDefendRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_ATTACK_ARMY_GROUP, handler(self, self.reqAttackArmyGroupRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_COMMIT_TASK, handler(self, self.reqCommitTaskRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_REFRESH_POS, handler(self, self.reqRefreshPosRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_REFRESH_POS2, handler(self, self.reqRefreshPos2Rsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_GET_BATTLE_INFO, handler(self, self.reqGetBatleInfoRsp))
	msgCtrl.register(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_GET_RANK_INFO, handler(self, self.reqGetRankInfoRsp))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onMsgGameResult))
	self:registerNotify()
	self:reqInit()
end
function commandHallCtrl:Logout()
	commandHallCtrl.super.Logout(self)
	self:resetData()
end
function commandHallCtrl:resetData()
	self.index2taskIndex, _UPVALUE0_, self.pos2taskIndex, _UPVALUE0_, self.taskList, _UPVALUE0_, self.initData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
	self.isShowFighting = false
	self.fightingResult = nil
	self.resultIndex = nil
end
function commandHallCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.COMMAND_HALL, handler(self, self.notifyHandler))
end
function commandHallCtrl:notifyHandler(event)
	dump(event.data, "commandHallCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self:onMsgNotifyHandler(v)
	end
end
function commandHallCtrl:onMsgNotifyHandler(data)
	if data.initData then
		self:setInitData(data.initData, true)
	end
	local notifyType = data.notifyType
	if notifyType == gCommandHallTaskNotifyType.TIME_REFRESH then
		_ENV = data.initData
		data.initData.msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
		SoraDSendMessage(data.initData)
	elseif notifyType == gCommandHallTaskNotifyType.PIONEER_TASK then
		local win = data.result and data.result.win
		if win ~= nil then
			local task = self:getArmyPioneerTaskData()
			local mapSyncUtilClient = include("mapSyncUtilClient")
			local pos = mapSyncUtilClient.serverTOClientPos(cc.p(task.obj.x, task.obj.y))
			_ENV = cc.p(task.obj.x, task.obj.y)
			cc.p(task.obj.x, task.obj.y).msg = "MESSAGE_COMMANDHALL_NPC_UPDATE"
			_ENV, cc.p(task.obj.x, task.obj.y).msgType = gMapSyncMsgType.UPDATE_MAPOBJ, gMapSyncMsgType.UPDATE_MAPOBJ
			gMapSyncMsgType.UPDATE_MAPOBJ.pos = pos
			gMapSyncMsgType.UPDATE_MAPOBJ.statue = win and gMapObjStateTypeDef.gMapObjStateTypeHurtDie or gMapObjStateTypeDef.gMapObjStateTypeFighting
			cc.p(task.obj.x, task.obj.y).data, gMapSyncMsgType.UPDATE_MAPOBJ.taskID = gMapSyncMsgType.UPDATE_MAPOBJ, task.taskID
			SoraDSendMessage(cc.p(task.obj.x, task.obj.y))
			if win then
				commandHallRead, _ENV = cc.p(task.obj.x, task.obj.y)
				SoraDSendMessage.updateList, cc.p(task.obj.x, task.obj.y)[1] = cc.p(task.obj.x, task.obj.y)
				local diffList = SoraDSendMessage
				_ENV = task.index
				task.index.msg = "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE"
				task.index.diffList = diffList
				task.index.showFighting = true
				SoraDSendMessage(task.index)
			end
			local result = data.result
			_ENV = task.index
			_ENV, task.index.msg = task.taskID, "MESSAGE_COMMANDHALL_SHOW_TIPS"
			task.taskID.win = result.win
			task.taskID.taskID = result.taskID
			task.index.data, task.taskID.taskIndex = task.taskID, task.index
			SoraDSendMessage(task.index)
		else
			_ENV = include("mapSyncUtilClient")
			include("mapSyncUtilClient").msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
			SoraDSendMessage((include("mapSyncUtilClient")))
		end
	elseif notifyType == gCommandHallTaskNotifyType.MOVE_CITY_REFRESH_POS then
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
		SoraDSendMessage(SoraDSendMessage)
	elseif notifyType == gCommandHallTaskNotifyType.GROUP_TASK then
		if not data.result then
			local _ENV, result = data.result, data.result
		end
		local win = result.win
		if win ~= nil then
			local isSelfAttack = result.isSelfAttack
			local isAdvanceAttack = result.isAdvanceAttack
			if isSelfAttack then
				SoraDRemoveAllPanelFromManager()
				self:setIsShowFighting(true, result)
				local commandHallUtil = include("commandHallUtil")
				commandHallUtil.jumpToShowFighting()
			else
				local mainCityView = SoraDCurrentSceneShowView("mainCityView")
				if mainCityView then
					self:setIsShowFighting(true, result)
					_ENV = self
					self.msg = "MESSAGE_MAINCITYVIEW_SHOW_COMMANDHALL_NPC"
					SoraDSendMessage(self)
				end
			end
		else
		end
		_ENV = result.isAdvanceAttack
		result.isAdvanceAttack.msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
		SoraDSendMessage(result.isAdvanceAttack)
	elseif notifyType == gCommandHallTaskNotifyType.SNIPE_HUNTER_TASK_REACH then
		if not data.result then
			local _ENV, result = data.result, data.result
		end
		self:setSoldierRushResultIndex(result.index)
	elseif notifyType == gCommandHallTaskNotifyType.COMMON_TASK then
		if not data.result then
			local _ENV, result = data.result, data.result
		end
		local taskID = result.taskID
		local taskType = commandHallRead.getTaskType(taskID)
		if result.reward then
			if taskType == gCommandHallTaskType.RESCUE_TASK then
				if SoraDCurrentSceneShowView("worldMapView") and not SoraDCurrentTopPanelFromManager() then
					_ENV = self
					self.type = 5
					self.isWin = true
					self.rewards = result.reward
					uiManager:show("ForeignPsettlement", self)
				end
			else
				SoraDMailGainItems(result.reward, true)
			end
		end
		local win = result.win
		if win ~= nil then
			local pos = cc.p(result.x, result.y)
			if taskType == gCommandHallTaskType.BATTLE_TASK then
				local mapSyncUtilClient = include("mapSyncUtilClient")
				_ENV = result.reward
				result.reward.msg = "MESSAGE_COMMANDHALL_NPC_UPDATE"
				_ENV, result.reward.msgType = gMapSyncMsgType.UPDATE_MAPOBJ, gMapSyncMsgType.UPDATE_MAPOBJ
				gMapSyncMsgType.UPDATE_MAPOBJ.pos = mapSyncUtilClient.serverTOClientPos(pos)
				gMapSyncMsgType.UPDATE_MAPOBJ.statue = win and gMapObjStateTypeDef.gMapObjStateTypeHurtDie or gMapObjStateTypeDef.gMapObjStateTypeFighting
				result.reward.data, gMapSyncMsgType.UPDATE_MAPOBJ.taskID = gMapSyncMsgType.UPDATE_MAPOBJ, taskID
				SoraDSendMessage(result.reward)
			end
			if win then
				local task = self:getTaskByPoint(pos)
				commandHallRead, _ENV = pos, self
				self.updateList, pos[1] = pos, task.index
				local diffList = self
				_ENV = task.index
				task.index.msg = "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE"
				task.index.diffList = diffList
				task.index.showFighting = taskType == gCommandHallTaskType.BATTLE_TASK
				SoraDSendMessage(task.index)
			end
			local task = self:getTaskByPoint(pos)
			_ENV = pos
			_ENV, pos.msg = task.index, "MESSAGE_COMMANDHALL_SHOW_TIPS"
			task.index.win = result.win
			task.index.taskID = result.taskID
			pos.data, task.index.taskIndex = task.index, task.index
			SoraDSendMessage(pos)
		else
			_ENV = self:getTaskByPoint(pos)
			self:getTaskByPoint(pos).msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
			SoraDSendMessage((self:getTaskByPoint(pos)))
		end
	elseif notifyType == gCommandHallTaskNotifyType.CASTLE_UPGRADE then
	end
end
function commandHallCtrl:onMsgGameResult(target, event)
	dump(event, "==commandHallCtrl:onMsgGameResult==")
	if self.resultIndex then
		local task = self:getTaskByIndex(self.resultIndex)
		if not task then
			self.resultIndex = nil
			SoraDShowMsgTip(i18n("notice_0026"))
			return
		end
		if event.isWin then
			commandHallCtrl:reqFinishTask(self.resultIndex)
		else
			_ENV = commandHallCtrl
			_ENV, commandHallCtrl.msg = self.resultIndex, "MESSAGE_COMMANDHALL_SHOW_TIPS"
			self.resultIndex.win = event.isWin
			self.resultIndex.taskID = task.taskID
			commandHallCtrl.data, self.resultIndex.taskIndex = self.resultIndex, self.resultIndex
			SoraDSendMessage(commandHallCtrl)
		end
		self.resultIndex = nil
	end
end
function commandHallCtrl:getReceiveStatusAndNum(...)
	if not next(self.initData) then
		return false
	end
	if self:getLvReceiveStatus() then
		return true, -1
	end
	if self:getTaskReceiveStatus() then
		return true, -1
	end
	return false
end
function commandHallCtrl:getLvReceiveStatus(...)
	local curLv = self.initData.commandLv
	local commandLvMax = commandHallRead.getCommandLvMax()
	if curLv >= commandLvMax then
		return false
	end
	local curExp = self.initData.commandExp
	local needExp = commandHallRead.getCommandLvNeedExp(curLv)
	if curExp >= needExp then
		return true
	end
	return false
end
function commandHallCtrl:getTaskReceiveStatus(...)
	for __, task in ipairs(self.taskList) do
		if task.statue == gCommandHallTaskStatue.FINISH then
			return true
		end
	end
	return false
end
function commandHallCtrl:reqInit()
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_INIT)
end
function commandHallCtrl:reqInitRsp(content)
	dump(content, "commandHallCtrl:reqInitRsp(content)", 10)
	if worldMapDefine.inInCrossWar() then
		return
	end
	if content.err == gErrDef.Err_None then
		self:setInitData(content.rspdata.initData, true)
	end
	_ENV = self
	self.msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
	SoraDSendMessage(self)
end
function commandHallCtrl:reqUpgradeCommandLv()
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_UPGRADE_COMMAND_LV)
end
function commandHallCtrl:reqUpgradeCommandLvRsp(content)
	dump(content, "commandHallCtrl:reqUpgradeCommandLvRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local oldTaskList = self.taskList
		local rspdata = content.rspdata
		self:setInitData(rspdata.initData, true)
		_ENV = self
		self.msg = "MESSAGE_COMMANDHALL_COMMANDLV_UPDATE"
		SoraDSendMessage(self)
		local diffList = self:getDiffList(oldTaskList, self.taskList)
		_ENV = oldTaskList
		oldTaskList.msg = "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE"
		oldTaskList.diffList = diffList
		SoraDSendMessage(oldTaskList)
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
	end
end
function commandHallCtrl:reqUpgradePowerLv()
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_UPGRADE_POWER_LV)
end
function commandHallCtrl:reqUpgradePowerLvRsp(content)
	dump(content, "commandHallCtrl:reqUpgradePowerLvRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local oldTaskList = self.taskList
		local rspdata = content.rspdata
		self:setInitData(rspdata.initData, true)
		_ENV = self
		self.msg = "MESSAGE_COMMANDHALL_POWERLV_UPDATE"
		SoraDSendMessage(self)
		local diffList = self:getDiffList(oldTaskList, self.taskList)
		_ENV = oldTaskList
		oldTaskList.msg = "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE"
		oldTaskList.diffList = diffList
		SoraDSendMessage(oldTaskList)
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
	end
end
function commandHallCtrl:reqFinishTask(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_FINISH_TASK, nil)
end
function commandHallCtrl:reqFinishTaskRsp(content)
	dump(content, "commandHallCtrl:reqFinishTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local oldTaskList = self.taskList
		local rspdata = content.rspdata
		self:setInitData(rspdata.initData, true)
		local diffList = self:getDiffList(oldTaskList, self.taskList)
		_ENV = oldTaskList
		oldTaskList.msg = "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE"
		oldTaskList.diffList = diffList
		SoraDSendMessage(oldTaskList)
		local index = content.data.index
		local task = self:getTaskByIndex(index)
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
		_ENV = rspdata.reward
		_ENV, rspdata.reward.msg = true, "MESSAGE_COMMANDHALL_SHOW_TIPS"
		;(true).win = true
		;(true).taskID = task.taskID
		rspdata.reward.data, (true).taskIndex = true, index
		SoraDSendMessage(rspdata.reward)
	end
end
function commandHallCtrl:reqSetDefend(armyInfo, heroInfo, armsInfo, divineBeastInfo)
	serverproxy = nil
	;(nil).armyInfo = armyInfo
	;(nil).heroInfo = heroInfo
	;(nil).armsInfo = armsInfo
	;(nil).divineBeastInfo = divineBeastInfo
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_SET_DEFEND, nil)
end
function commandHallCtrl:reqSetDefendRsp(content)
	dump(content, "commandHallCtrl:reqSetDefendRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setInitData(content.rspdata.initData)
		SoraDShowMsgTip(i18n("arena_text_34"))
	end
end
function commandHallCtrl:reqAttackArmyGroup(armyInfo, heroInfo, armsInfo, divineBeastInfo)
	serverproxy = nil
	;(nil).armyInfo = armyInfo
	;(nil).heroInfo = heroInfo
	;(nil).armsInfo = armsInfo
	;(nil).divineBeastInfo = divineBeastInfo
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_ATTACK_ARMY_GROUP, nil)
end
function commandHallCtrl:reqAttackArmyGroupRsp(content)
	dump(content, "commandHallCtrl:reqAttackArmyGroup(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setInitData(content.rspdata.initData, true)
		SoraDRemoveAllPanelFromManager()
		local task = self:getArmyGroupTaskData()
		if task and task.armyGroupID then
			_ENV = nil
			;(nil).win = true
			;(nil).armyGroupID = task.armyGroupID
			self:setIsShowFighting(true, nil)
			local commandHallUtil = include("commandHallUtil")
			commandHallUtil.jumpToShowFighting()
		end
		_ENV = commandHallUtil.jumpToShowFighting
		commandHallUtil.jumpToShowFighting.msg = "MESSAGE_COMMANDHALL_INITDATA_UPDATE"
		SoraDSendMessage(commandHallUtil.jumpToShowFighting)
	end
end
function commandHallCtrl:reqCommitTask(commitType, index)
	serverproxy = nil
	;(nil).commitType = commitType
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_COMMIT_TASK, nil)
end
function commandHallCtrl:reqCommitTaskRsp(content)
	dump(content, "commandHallCtrl:reqCommitTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local oldTaskList = self.taskList
		local rspdata = content.rspdata
		self:setInitData(rspdata.initData, true)
		local diffList = self:getDiffList(oldTaskList, self.taskList)
		local commitType = content.data.commitType
		_ENV = self.taskList
		self.taskList.msg = "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE"
		self.taskList.diffList = diffList
		self.taskList.commitType = commitType
		SoraDSendMessage(self.taskList)
		if rspdata.reward then
			SoraDMailGainItems(rspdata.reward, true)
		end
	end
end
function commandHallCtrl:getDiffList(oldTaskList, newTaskList)
	local _ENV, oldTaskMap
	for i, v in ipairs(oldTaskList) do
		oldTaskMap[tostring(v.index)] = i
	end
	local _ENV, newTaskMap = (for generator), ipairs(oldTaskList)
	for i, v in ipairs(newTaskList) do
		newTaskMap[tostring(v.index)] = i
	end
	local _ENV, addList = (for generator), ipairs(newTaskList)
	for i, v in ipairs(newTaskList) do
		if not oldTaskMap[tostring(v.index)] then
			table.insert(addList, v.index)
		end
	end
	local _ENV, removeList = (for generator), ipairs(newTaskList)
	for i, v in ipairs(oldTaskList) do
		if not newTaskMap[tostring(v.index)] then
			table.insert(removeList, v.index)
		end
	end
	local _ENV, updateList = (for generator), ipairs(oldTaskList)
	for i, v in ipairs(newTaskList) do
		local tableIndex = oldTaskMap[tostring(v.index)]
		if tableIndex then
			local oldTask = oldTaskList[tableIndex]
			if oldTask.statue ~= v.statue then
				table.insert(updateList, v.index)
			end
		end
	end
	_ENV = (for generator)
	ipairs(newTaskList).addList = addList
	ipairs(newTaskList).removeList = removeList
	ipairs(newTaskList).updateList = updateList
	return ipairs(newTaskList)
end
function commandHallCtrl:reqRefreshPos(pos)
	serverproxy = nil
	;(nil).x = pos.x
	;(nil).y = pos.y
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_REFRESH_POS, nil)
end
function commandHallCtrl:reqRefreshPosRsp(content)
	dump(content, "commandHallCtrl:reqRefreshPosRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local mapSyncUtilClient = include("mapSyncUtilClient")
		local pos = cc.p(content.data.x, content.data.y)
		_ENV = content.data.y
		content.data.y.msg = "MESSAGE_COMMANDHALL_NPC_UPDATE"
		_ENV, content.data.y.msgType = gMapSyncMsgType.REMOVE_MAPOBJ, gMapSyncMsgType.REMOVE_MAPOBJ
		content.data.y.data, gMapSyncMsgType.REMOVE_MAPOBJ.pos = gMapSyncMsgType.REMOVE_MAPOBJ, mapSyncUtilClient.serverTOClientPos(pos)
		SoraDSendMessage(content.data.y)
		local task = self:getTaskByPoint(pos)
		if task == nil then
			return
		end
		task.obj.x = content.rspdata.x
		task.obj.y = content.rspdata.y
		self:updatePos2taskIndex(task.obj, content.data)
		_ENV = self
		self.msg = "MESSAGE_COMMANDHALL_NPC_UPDATE"
		_ENV, self.msgType = gMapSyncMsgType.ADD_MAPOBJ, gMapSyncMsgType.ADD_MAPOBJ
		self.data, gMapSyncMsgType.ADD_MAPOBJ.task = gMapSyncMsgType.ADD_MAPOBJ, task
		SoraDSendMessage(self)
	end
end
function commandHallCtrl:reqRefreshPos2(pos)
	serverproxy = nil
	;(nil).x = pos.x
	;(nil).y = pos.y
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_REFRESH_POS2, nil)
end
function commandHallCtrl:reqRefreshPos2Rsp(content)
	dump(content, "commandHallCtrl:reqRefreshPos2Rsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local task = self:getTaskByPoint(cc.p(content.data.x, content.data.y))
		local rspdata = content.rspdata
		if rspdata.x then
			task.obj.x = rspdata.x
			task.obj.y = rspdata.y
			self:updatePos2taskIndex(task.obj, content.data)
		end
		local mapSyncUtilClient = include("mapSyncUtilClient")
		local pos = mapSyncUtilClient.serverTOClientPos(cc.p(task.obj.x, task.obj.y))
		SoraDRemoveAllPanelFromManager()
		SoraDGotoWorldMapPoint(pos, true)
		if SoraDIsGameGuide() then
			print("==MESSAGE_SERVER_GUIDE_STEP_END=3=", SoraDIsGameGuide())
			_ENV = "==MESSAGE_SERVER_GUIDE_STEP_END=3="
			;("==MESSAGE_SERVER_GUIDE_STEP_END=3=").msg = "MESSAGE_SERVER_GUIDE_STEP_END"
			;("==MESSAGE_SERVER_GUIDE_STEP_END=3=").step = SoraDIsGameGuide()
			;("==MESSAGE_SERVER_GUIDE_STEP_END=3=").reload = false
			SoraDSendMessage("==MESSAGE_SERVER_GUIDE_STEP_END=3=")
		end
	end
end
function commandHallCtrl:updatePos2taskIndex(pos1, pos2)
	local newKey = pos1.x .. "," .. pos1.y
	local oldKey = pos2.x .. "," .. pos2.y
	self.pos2taskIndex[newKey] = self.pos2taskIndex[oldKey]
	self.pos2taskIndex[oldKey] = nil
end
function commandHallCtrl:reqGetBatleInfo(armyInfo, heroInfo, armsInfo)
	serverproxy = nil
	;(nil).armyInfo = armyInfo
	;(nil).heroInfo = heroInfo
	;(nil).armsInfo = armsInfo
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_GET_BATTLE_INFO, nil)
end
function commandHallCtrl:reqGetBatleInfoRsp(content)
	dump(content, "commandHallCtrl:reqGetBatleInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_COMMANDHALL_UPDATE_ADVISE_BATTLEINFO"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function commandHallCtrl:reqGetRankInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_GET_RANK_INFO, nil)
end
function commandHallCtrl:reqGetRankInfoRsp(content)
	dump(content, "commandHallCtrl:reqGetRankInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_COMMANDHALL_UPDATE_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function commandHallCtrl:getInitData(...)
	return self.initData
end
function commandHallCtrl:getDefendData(...)
	return self.initData.defendData
end
function commandHallCtrl:getArmyPioneerTaskCount(...)
	return self.initData.armyPioneerTaskCount or 0
end
function commandHallCtrl:getArmyPioneerTaskData(...)
	return self.initData.armyPioneerTaskData
end
function commandHallCtrl:checkArmyPioneerTaskStatue(...)
	local task = self:getArmyPioneerTaskData()
	return task and task.statue and task.statue == gCommandHallTaskStatue.FINISH
end
function commandHallCtrl:getArmyGroupTaskData(...)
	return self.initData.armyGroupTaskData
end
function commandHallCtrl:getArmyGroupTaskHurtHp(...)
	local task = self:getArmyGroupTaskData()
	return task and task.hurtHp or 0
end
function commandHallCtrl:hasArmyGroupTask(...)
	local task = self:getArmyGroupTaskData()
	if task and next(task) then
		return true
	else
		return false
	end
end
function commandHallCtrl:getArmyGroupID(...)
	return self.initData.armyGroupID or 1
end
function commandHallCtrl:getTomorrowArmyGroupTaskData(...)
	return self.initData.tomorrowArmyGroupTaskData
end
function commandHallCtrl:getCommonTaskData(...)
	if not self.initData.commonTaskData then
		_UPVALUE0_ = self.initData.commonTaskData
	end
	return self.initData.commonTaskData
end
function commandHallCtrl:getTaskByType(taskType)
	for __, task in ipairs(self.taskList) do
		if commandHallRead.getTaskType(task.taskID) == taskType then
			return task
		end
	end
end
function commandHallCtrl:getFinishTaskData(...)
	return self.initData.finishTaskData
end
function commandHallCtrl:checkTaskFinish(taskID)
	if self.initData.finishTaskData and self.initData.finishTaskData[tostring(taskID)] then
		return true
	else
		return false
	end
end
function commandHallCtrl:setInitData(initData, resetTaskList)
	self.initData = initData
	if not resetTaskList then
		return
	end
	local _ENV, ret
	local task = self:getArmyGroupTaskData()
	if task and next(task) then
		table.insert(ret, task)
	end
	local task = self:getArmyPioneerTaskData()
	if task and next(task) then
		table.insert(ret, task)
	end
	for i, task in ipairs(self:getCommonTaskData()) do
		table.insert(ret, task)
	end
	self.taskList = ret
	local _ENV, ret = ipairs(self:getCommonTaskData())
	for i, v in ipairs(self.taskList) do
		ret[tostring(v.index)] = i
	end
	self.index2taskIndex = ret
	local _ENV, ret = ipairs(self.taskList)
	for i, task in ipairs(self.taskList) do
		if task and task.obj and task.obj.x then
			local key = task.obj.x .. "," .. task.obj.y
			ret[key] = i
		end
	end
	self.pos2taskIndex = ret
	self:updateBuildTopTip()
end
function commandHallCtrl:updateBuildTopTip(...)
	local cityBuildConstDef = include("cityBuildConstDef")
	local buildIndex = cityBuildConstDef.buildIndexDef.index_CommandHall
	local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_COMMANDHALL
	if self:getReceiveStatusAndNum() then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		self.buildIndex = buildIndex
		self.buildTopTipType = buildTopTipType
		SoraDSendMessage(self)
	else
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = buildIndex
		self.buildTopTipType = buildTopTipType
		SoraDSendMessage(self)
	end
end
function commandHallCtrl:getTaskRefreshRemainTime()
	local nextRefreshTime = self.initData.nextRefreshTime
	return math.max(0, nextRefreshTime - serviceFunctions.systemTime())
end
function commandHallCtrl:getTaskList(...)
	return self.taskList
end
function commandHallCtrl:getTaskByPoint(point)
	local key = point.x .. "," .. point.y
	local taskIndex = self.pos2taskIndex[key]
	if taskIndex then
		return self.taskList[taskIndex]
	end
end
function commandHallCtrl:getTaskByIndex(index)
	local taskIndex = self.index2taskIndex[tostring(index)]
	if taskIndex then
		return self.taskList[taskIndex]
	end
end
function commandHallCtrl:checkMapObjPoint(mapObjData)
	if mapObjData.kid ~= gametop.playertop_:getKingdomID() then
		print("==commandHallCtrl:checkMapObjPoint kid==", mapObjData.kid)
		return
	end
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local instanceFactory = include("instanceFactory")
	local serverPos = mapSyncUtilClient.clientTOServerPos(cc.p(mapObjData.x, mapObjData.y))
	local holdInstace = instanceFactory.getHoldInstaceByType(mapObjData.type, mapObjData.class, mapObjData.subMapType)
	local tilesArray = instanceFactory.getTilesArrayByInstace(serverPos, holdInstace)
	for _, tilePoint in pairs(tilesArray) do
		local taskIndex = self.pos2taskIndex[tilePoint]
		if taskIndex then
			local task = self.taskList[taskIndex]
			self:reqRefreshPos(cc.p(task.obj.x, task.obj.y))
			local commandHallUtil = include("commandHallUtil")
			commandHallUtil.checkFinishGuide()
		end
	end
end
function commandHallCtrl:setIsShowFighting(isShow, result)
	self.isShowFighting = isShow
	if isShow then
		self.fightingResult = result
	end
end
function commandHallCtrl:getIsShowFighting()
	return self.isShowFighting
end
function commandHallCtrl:getFightingResult()
	return self.fightingResult
end
function commandHallCtrl:checkIsDataInit(...)
	return self.initData.commandLv ~= nil
end
function commandHallCtrl:getCurDamageRadioStr(commandLv)
	local curRadio = self:getCurDamageRadio(commandLv)
	if curRadio.valueType == 1 then
		return curRadio.value / 10 .. "%"
	else
		return curRadio.value
	end
end
function commandHallCtrl:getCurDamageRadio(commandLv)
	commandLv = commandLv or self.initData.commandLv
	return commandHallRead.getCommandLvDamageRadio(commandLv)
end
function commandHallCtrl:getCurRewardRadio(commandLv)
	commandLv = commandLv or self.initData.commandLv
	local curRadio = commandHallRead.getCommandLvRewardRadio(commandLv)
	return curRadio / 10
end
function commandHallCtrl:getCurRewardRadioStr(commandLv)
	return self:getCurRewardRadio(commandLv) .. "%"
end
function commandHallCtrl:updateGuide1(...)
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:isGuideNotCompleted(gGuideModule.COMMAND_HALL1) then
		local commandHallUtil = include("commandHallUtil")
		if commandHallUtil.checkOpenLv() and guideCtrl:updateGuideModule(gGuideModule.COMMAND_HALL1) then
			return true
		end
	end
end
function commandHallCtrl:getTaskNotFinishCount(...)
	local count = 0
	if self:getLvReceiveStatus() then
		count = count + 1
	end
	for __, task in ipairs(self.taskList) do
		if task.statue == gCommandHallTaskStatue.BEGIN then
			count = count + 1
		end
	end
	return count
end
function commandHallCtrl:setSoldierRushResultIndex(index)
	self.resultIndex = index
	local task = self:getTaskByIndex(self.resultIndex)
	local archeryId = task.shellType
	_ENV = nil
	;(nil).sceneType = archeryId
	;(nil).isTaskGame = true
	uiManager:show("SneakSnipeGame", nil)
end
return commandHallCtrl
