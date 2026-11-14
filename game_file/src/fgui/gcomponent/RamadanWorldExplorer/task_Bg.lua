local ramadanWorldExplorerCtrl = SoraDGetCtrl("ramadanWorldExplorerCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local baseComponent = require("fgui.base.baseComponent")
local task_Bg = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanWorldExplorer/task_Bg", task_Bg)
function task_Bg:onInit()
	_ENV, _ENV = nil, nil
	;(nil).des = "ramadan_world_explorer_text_0005"
	;(nil).height = 239
	;(nil).c1 = 0
	_ENV, (nil)[1], (nil).gameName = nil, nil, "ForeignPShootGame"
	;(nil).des = "ramadan_world_explorer_text_0006"
	;(nil).height = 239
	;(nil).c1 = 0
	_ENV, (nil)[2], (nil).gameName = nil, nil, "LinkLinkView"
	;(nil).des = "ramadan_world_explorer_text_0007"
	;(nil).height = 239
	;(nil).c1 = 0
	_ENV, (nil)[3], (nil).gameName = nil, nil, "RoadRoughView"
	;(nil).des = "ramadan_world_explorer_text_0008"
	;(nil).height = 239
	;(nil).c1 = 0
	_ENV, (nil)[4], (nil).gameName = nil, nil, "PuzzleGame"
	;(nil).des = "ramadan_world_explorer_text_0011"
	;(nil).height = 435
	_ENV, (nil)[5], (nil).c1 = nil, nil, 1
	;(nil).des = "ramadan_world_explorer_text_0013"
	;(nil).height = 239
	_ENV, (nil)[6], (nil).c1 = nil, nil, 1
	;(nil).des = "ramadan_world_explorer_text_0014"
	;(nil).height = 239
	_ENV, (nil)[7], (nil).c1 = nil, nil, 1
	;(nil).des = "ramadan_world_explorer_text_0015"
	;(nil).height = 239
	self.config, (nil)[8], (nil).c1 = nil, nil, 1
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.Button:addClickListener(handler(self, self.onClickButton))
	SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self.fields.Text_Time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("ramadan_world_explorer_text_0016", nil)
	end)
end
function task_Bg:onShow()
end
function task_Bg:initData(data)
	self.taskId = ramadanWorldExplorerCtrl:getTaskIDByIndex(data.taskIdx)
	self.taskIdx = data.taskIdx
	self.endPoint = data.endPoint
	self.instanceID = data.instanceID
	if not self.config[self.taskId] then
		ramadanWorldExplorerCtrl = self.config[self.taskId]
		self.config[self.taskId].des = "ramadan_world_explorer_text_0017"
		self.config[self.taskId].height = 239
		local self.config[self.taskId].c1, info = 1, self.config[self.taskId]
	end
	self.fields.Text_Des:setString(i18n(info.des))
	self:setViewHeight(info.height)
	self.controllers.c1:setSelectedIndex(info.c1)
	self.fields.Text_Time:endTime()
	local isDoingTask = false
	if self.taskIdx == 0 then
		self.fields.Button:setString(i18n("common_text_477"))
	elseif self.taskId <= 4 then
		self.fields.Button:setString(i18n("common_text_1139"))
	elseif self.taskId == 5 then
		self.fields.Text_Time:setString("")
	elseif self.taskId == 6 then
		self.fields.Button:setString(i18n("sheepFeed_text_12"))
	elseif self.taskId == 7 then
		self.fields.Button:setString(i18n("common_text_560"))
		local queque = kingdomMapCtrl:getToInstanceIDQueue(self.instanceID)
		if queque then
			self.fields.Text_Time:setString(i18n("Battlefield_queue_text_007"))
			isDoingTask = true
		end
	elseif self.taskId == 8 then
		self.fields.Button:setString(i18n("across_approval_btn"))
		local queque = kingdomMapCtrl:getFromInstanceIDQueue(self.instanceID)
		if queque then
			self.fields.Text_Time:beginTime(queque:getStatusRemainTime())
			isDoingTask = true
		end
	end
	self.controllers.c3:setSelectedIndex(self.taskId == 5 and 0 or 1)
	self.controllers.c2:setSelectedIndex(isDoingTask and 0 or 1)
end
function task_Bg:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).taskID = self.taskId
	uiManager:show("RamadanWorldExplorerTip", nil)
end
function task_Bg:onClickButton()
	SoraDPlaySound()
	if self.taskIdx == 0 then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER)
		_ENV = gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER
		gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_CLOSE_TASK_VIEW"
		SoraDSendMessage(gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER)
	elseif self.taskId <= 4 then
		_ENV = self.taskId
		function self.taskId.resultCallback(isWin)
			_ENV = nil
			;(nil).isWin = isWin
			uiManager:show("RamadanWorldExplorerResult", nil)
		end
		uiManager:show(self.config[self.taskId].gameName, self.taskId)
	elseif self.taskId == 6 then
		_ENV = uiManager
		uiManager.msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
		uiManager.isWin = true
		SoraDSendMessage(uiManager)
	elseif self.taskId == 7 then
		if SoraDEnoughTroops() then
			_ENV = SoraDEnoughTroops()
			SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_zhenCha
			SoraDEnoughTroops().toPoint = self.endPoint
			local SoraDEnoughTroops().instanceID, armyData = self.instanceID, SoraDEnoughTroops()
			worldMapFunction.gotoDispatch(armyData, true)
		end
		_ENV = worldMapFunction.gotoDispatch
		worldMapFunction.gotoDispatch.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_CLOSE_TASK_VIEW"
		SoraDSendMessage(worldMapFunction.gotoDispatch)
	elseif self.taskId == 8 then
		ramadanWorldExplorerCtrl:reqRamadanWorldExplorerTaskTradeVisit(self.taskIdx)
		_ENV = ramadanWorldExplorerCtrl
		ramadanWorldExplorerCtrl.msg = "MESSAGE_RAMADAN_WORLD_EXPLORER_CLOSE_TASK_VIEW"
		SoraDSendMessage(ramadanWorldExplorerCtrl)
	end
end
return task_Bg
