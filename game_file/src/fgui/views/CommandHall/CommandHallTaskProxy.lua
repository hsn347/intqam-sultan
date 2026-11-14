local baseProxy = require("fgui.base.baseProxy")
local CommandHallTaskProxy = class("CommandHallTaskProxy", baseProxy)
function CommandHallTaskProxy:onRegisterEvent()
	print("=======CommandHallTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.onMsgUpdateLordInfo))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_INITDATA_UPDATE", handler(self, self.onMsgUpdateInitData))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE", handler(self, self.onMsgUpdateCommitTask))
end
function CommandHallTaskProxy:onMsgUpdateLordInfo(...)
	self.view:updatePhysical(...)
end
function CommandHallTaskProxy:onMsgUpdateInitData(target, event)
	dump(event, "==CommandHallTaskProxy:onMsgUpdateInitData==")
	if self.view:getTaskType() == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK and self.view:getTaskStatue() ~= gCommandHallTaskStatue.FINISH then
		local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
		local task = commandHallCtrl:getArmyGroupTaskData()
		if task and next(task) and task.statue ~= gCommandHallTaskStatue.FINISH then
			return
		end
	end
	SoraDRemoveAllAfterPanelFromManager(self.view)
end
function CommandHallTaskProxy:onMsgUpdateCommitTask(target, event)
	if not event.diffList then
		local _ENV, diffList = event.diffList, event.diffList
	end
	if not diffList.removeList then
		local _ENV, removeList = diffList.removeList, diffList.removeList
	end
	if not diffList.updateList then
		local _ENV, updateList = diffList.updateList, diffList.updateList
	end
	local task = self.view:getTaskData()
	for __, index in ipairs(removeList) do
		if task.index == index then
			self.view:closePanel()
			break
		end
	end
	for __, index in ipairs(updateList) do
		if task.index == index then
			local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
			local newTask = commandHallCtrl:getTaskByIndex(index)
			self.view:updateTaskData(newTask)
			break
		end
	end
end
return CommandHallTaskProxy
