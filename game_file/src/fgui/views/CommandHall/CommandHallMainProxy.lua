local baseProxy = require("fgui.base.baseProxy")
local CommandHallMainProxy = class("CommandHallMainProxy", baseProxy)
function CommandHallMainProxy:onRegisterEvent()
	print("=======CommandHallMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_INITDATA_UPDATE", handler(self, self.onMsgUpdateInitData))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_SELECT_TASK", handler(self, self.onMsgSelectTaskSingle))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE", handler(self, self.onMsgUpdateCommitTask))
end
function CommandHallMainProxy:onMsgUpdateInitData(...)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateInitData(...)
end
function CommandHallMainProxy:setTaskPosListConfig(taskPosList)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:CommandHallMain:taskPosList~table", taskPosList, nil)
end
function CommandHallMainProxy:getTaskPosListConfig()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:CommandHallMain:taskPosList~table", nil) then
		_ENV = SoraDConfigGet("Game:CommandHallMain:taskPosList~table", nil)
	end
	return (SoraDConfigGet("Game:CommandHallMain:taskPosList~table", nil))
end
function CommandHallMainProxy:reSetAllTaskSingle(...)
	self.view:reSetAllTaskSingle(...)
end
function CommandHallMainProxy:onMsgSelectTaskSingle(target, event)
	SoraDRemoveAllAfterPanelFromManager(self.view, true)
	self.view:reSetAllTaskSingle()
	if event.taskIndex then
		self.view:selectTaskByIndex(event.taskIndex)
	else
		self.view:selectTaskByTaskType(event.taskType)
	end
end
function CommandHallMainProxy:onMsgUpdateCommitTask(...)
	self.view:updateCommitTask(...)
end
function CommandHallMainProxy:showDispatch(...)
	self.view:showDispatch(...)
end
function CommandHallMainProxy:updateBtnWaring(...)
	self.view:updateBtnWaring(...)
end
return CommandHallMainProxy
