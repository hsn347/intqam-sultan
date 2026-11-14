local commandHallRead = include("commandHallRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_TSDT_tips = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommandHall/Com_TSDT_tips", Com_TSDT_tips)
_ENV = fgui.register_extension
fgui.register_extension.mainUI = 1
local fgui.register_extension.commandHall, TIP_TYPE = 2, fgui.register_extension
function Com_TSDT_tips:onInit()
	self.resultList, TIP_TYPE = nil, nil
	self.tipCD = 0
	self.tipType = TIP_TYPE.mainUI
	self:setVisible(false)
	self:addClickListener(handler(self, self.onClickTips))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Imgae_bg:setScaleX(-1)
		self.fields.Image_arrow:fix()
	end
end
function Com_TSDT_tips:onShow()
end
function Com_TSDT_tips:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_SHOW_TIPS", handler(self, self.showCommandHallTips))
end
function Com_TSDT_tips:showCommandHallTips(target, event)
	local result = event.data
	table.insert(self.resultList, result)
	if not self.timeHandle then
		self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
		self:updateTime()
	end
end
function Com_TSDT_tips:updateTime(...)
	if self.tipCD > 0 then
		self.tipCD = self.tipCD - 1
		return
	end
	local result = table.remove(self.resultList, 1)
	if not result then
		if self.timeHandle then
			SoraDManagerRemoveTimer(self, self.timeHandle)
			self.timeHandle = nil
		end
		self:setVisible(false)
		return
	end
	self:setVisible(true)
	self:showSingleTip(result)
	self.tipCD = 3
end
function Com_TSDT_tips:showSingleTip(result)
	self.result = result
	local win = result.win
	if win then
		self.fields.Text_result:setString(i18n("Actpass_text_06"))
		self.controllers.c_result:setSelectedIndex(0)
	else
		self.fields.Text_result:setString(i18n("GS_commandhall_guide_12"))
		self.controllers.c_result:setSelectedIndex(1)
	end
	local taskID = result.taskID
	local taskName = commandHallRead.getTaskName(taskID)
	_ENV = i18n("GS_commandhall_guide_12")
	i18n("GS_commandhall_guide_12").name = taskName
	self.fields.Text_task:setString(i18n("GS_commandhall_guide_13", i18n("GS_commandhall_guide_12")))
end
function Com_TSDT_tips:setTipType(tipType)
	self.tipType = tipType
end
function Com_TSDT_tips:onClickTips(...)
	SoraDPlaySound()
	if self.tipType == TIP_TYPE.commandHall then
		local taskIndex = self.result.taskIndex
		if taskIndex then
			_ENV = nil
			;(nil).msg = "MESSAGE_COMMANDHALL_SELECT_TASK"
			;(nil).taskIndex = taskIndex
			SoraDSendMessage(nil)
		end
	else
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.COMMAND_HALL_ACTIVITY)
	end
end
return Com_TSDT_tips
