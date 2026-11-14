local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTreasure_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaTreasure/Com_NebulaTreasure_Task", Com_NebulaTreasure_Task)
local eventQuestRead = include("eventQuestRead")
local nebulaTreasureRead = include("nebulaTreasureRead")
local nebulaTreasureCtrl = SoraDGetCtrl("nebulaTreasureCtrl")
_ENV = "nebulaTreasureCtrl"
;("nebulaTreasureCtrl").FINISH = 1
;("nebulaTreasureCtrl").UNCOMPLETE = 2
local ("nebulaTreasureCtrl").RECEIVE, TaskStatus = 3, "nebulaTreasureCtrl"
function Com_NebulaTreasure_Task:onInit()
	self.fields.Button:addClickListener(handler(self, self.onButtonClick))
	self.fields.shine:setAllFrameName("dh_xingyunbzqz_%02d.png", 1)
	self.fields.shine:setPlaySettings(0, -1, -1)
	self.fields.txt_got:setString(i18n("common_text_1892"))
end
function Com_NebulaTreasure_Task:onShow()
end
function Com_NebulaTreasure_Task:initData(taskID)
	self.taskID = taskID
	local lang = SoraDGetDefaultLanguage()
	local titleName = nebulaTreasureRead.getName(taskID)
	titleName = lang == "ar" and SoraDStringSplit(titleName, ".png")[1] .. "_ar.png" or SoraDStringSplit(titleName, ".png")[1] .. "_en.png"
	self.fields.icon_title:setURL(titleName)
	self.fields.Text_Des:setString(eventQuestRead.getDesEx(tonumber(taskID)))
	self.fields.Icon:setURL(nebulaTreasureRead.getIcon(taskID))
	self.status = nebulaTreasureCtrl:getTaskStatus(taskID)
	if self.status == TaskStatus.UNCOMPLETE then
		self.fields.Button:setString(i18n("StarTreasure_text_02"))
	elseif self.status == TaskStatus.FINISH then
		self.fields.Button:setString(i18n("common_text_1146"))
	else
		self.fields.Button:setString(i18n("common_text_1892"))
	end
	local lastCompleteCount = nebulaTreasureCtrl:getLastDailyCompleteCount()
	if lastCompleteCount <= 0 then
		self.fields.Button:setString(i18n("StarTreasure_text_32"))
	end
	self.fields.Button:setGrayed(lastCompleteCount <= 0)
	self.controllers.c1:setSelectedIndex(self.status ~= TaskStatus.RECEIVE and 0 or 1)
	self.fields.Button:setBtnColorIndex(self.status == TaskStatus.FINISH and 0 < lastCompleteCount and 2 or 0)
	local progress = nebulaTreasureCtrl:getTaskProgress(taskID)
	local targetStr = eventQuestRead.getAim(tonumber(taskID))
	if type(targetStr) == "number" then
		if progress > targetStr then
			progress = targetStr
		end
		targetStr = string.formatnumberthousands(targetStr)
	end
	_ENV = tonumber(taskID)
	tonumber(taskID).count = string.formatnumberthousands(progress)
	_ENV, tonumber(taskID).total = string.formatnumberthousands(progress), targetStr
	if self.status == TaskStatus.FINISH then
		_ENV = self.status
		self.status.color = "#b2b2b2"
		if self.status then
			goto lbl_173
		end
	end
	_ENV = self.status
	_ENV, string.formatnumberthousands(progress).count, self.status.color = self.status, self.status, "#c40500"
	::lbl_173::
	_ENV, string.formatnumberthousands(progress).total, self.status.color = self.status, self.status, "#b2b2b2"
	string.formatnumberthousands(progress).__default, self.status.color = self.status, "#b2b2b2"
	self.fields.Text_progress:setString(i18n_html("common_text_3683", tonumber(taskID)))
end
function Com_NebulaTreasure_Task:onButtonClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).taskID = self.taskID
	uiManager:show("NebulaTreasureTaskDetails", nil)
end
return Com_NebulaTreasure_Task
