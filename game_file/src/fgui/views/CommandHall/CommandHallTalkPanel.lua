local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local commandHallRead = include("commandHallRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallTalkPanel = class("CommandHallTalkPanel", baseFguiPanel)
function CommandHallTalkPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallTalkPanel:ctor", self.viewName)
end
function CommandHallTalkPanel:onInit()
	print("=======CommandHallTalkPanel:onInit")
	self.taskData = self.proxy.param.taskData
	self.dialogues = commandHallRead.getTaskDialogueConfig(self.taskData.shellType)
	dump(self.dialogues, "==CommandHallTalk self.dialogues==")
	self.fields.btn_next:addClickListener(handler(self, self.onClickBtnNext))
	self.fields.btn_answer1:addClickListener(handlerEx(self, self.onClickBtnAnswer, 1))
	self.fields.btn_answer2:addClickListener(handlerEx(self, self.onClickBtnAnswer, 2))
	self.fields.btn_answer1:setVisible(false)
	self.fields.btn_answer2:setVisible(false)
	self.fields.btn_next2:setVisible(false)
	self.fields.btn_next2:addClickListener(handler(self, self.onClickBtnNext2))
end
function CommandHallTalkPanel:onShow()
	print("=======CommandHallTalkPanel:onShow")
	self.totalH = 0
	self.curStep = 1
	self:autoShowDialogue()
end
function CommandHallTalkPanel:showDialogue(...)
	if not self.curStep then
		self:endDialogue()
		return false
	end
	local data = self.dialogues[self.curStep]
	dump(data, "==CommandHallTalk:showDialogue==" .. self.curStep)
	self.fields.Load_bg:setURL(data.banner)
	local dialogType = data.type
	local key1 = data.key1
	local key2 = data.key2
	if dialogType == 1 then
		local gobj = fgui.UIPackage:createObject("CommandHall", "Talk_single")
		self.fields.scroll:addChild(gobj)
		gobj:initTalkData(data)
		gobj:setPosition(0, 30 + self.totalH)
		self.totalH = self.totalH + gobj:getHeight()
		self.fields.scroll:getScrollPane():scrollBottom(true)
	elseif dialogType == 2 then
		local gobj = fgui.UIPackage:createObject("CommandHall", "Talk_aside")
		self.fields.scroll:addChild(gobj)
		gobj:setString(i18n(key1))
		gobj:setPosition(0, 30 + self.totalH)
		self.totalH = self.totalH + gobj:getHeight()
		self.fields.scroll:getScrollPane():scrollBottom(true)
	elseif dialogType == 3 then
		self.fields.btn_answer1:setTitle(i18n(key1))
		self.fields.btn_answer2:setTitle(i18n(key2))
	end
	local showAnswer = dialogType == 3
	self.fields.btn_answer1:setVisible(showAnswer)
	self.fields.btn_answer2:setVisible(showAnswer)
	local showClose = data.later1 == 0
	self.fields.btn_next2:setVisible(showClose)
	return true
end
function CommandHallTalkPanel:endDialogue(...)
	commandHallCtrl:reqFinishTask(self.taskData.index)
	self:closePanel()
end
function CommandHallTalkPanel:getNextDialog(anwser)
	anwser = anwser or 1
	local data = self.dialogues[self.curStep]
	local nextID = data and data["later" .. anwser] or 0
	if nextID == 0 then
		return
	end
	for step, value in ipairs(self.dialogues) do
		if value.talkID == nextID then
			return step
		end
	end
	return
end
function CommandHallTalkPanel:onClickBtnNext()
	SoraDPlaySound()
	if not self.curStep then
		self:endDialogue()
		return
	end
	local data = self.dialogues[self.curStep]
	if data.type == 3 then
		return
	end
	self:stopAllActions()
	while self.curStep do
		self.curStep = self:getNextDialog()
		if not self.curStep then
			break
		end
		self:showDialogue()
		local data = self.dialogues[self.curStep]
		if data.type == 3 then
			break
		end
	end
end
function CommandHallTalkPanel:onClickBtnAnswer(tag)
	SoraDPlaySound()
	self.curStep = self:getNextDialog(tag)
	self:autoShowDialogue()
end
function CommandHallTalkPanel:autoShowDialogue(...)
	if not self:showDialogue() then
		return
	end
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		self:showNextDialogue()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:showNextDialogue()
	end)
	self:runAction(ffa.repeatForever(ffa.seq(nil)))
end
function CommandHallTalkPanel:showNextDialogue(...)
	self.curStep = self:getNextDialog()
	if not self.curStep then
		self:stopAllActions()
		return
	end
	local data = self.dialogues[self.curStep]
	self:showDialogue()
	if data.type == 3 then
		self:stopAllActions()
	end
end
function CommandHallTalkPanel:onClickBtnNext2(...)
	SoraDPlaySound()
	self:endDialogue()
end
return CommandHallTalkPanel
