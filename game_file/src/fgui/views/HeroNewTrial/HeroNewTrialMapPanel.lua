local heroNewTrialRead = include("heroNewTrialRead")
local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroNewTrialMapPanel = class("HeroNewTrialMapPanel", baseFguiPanel)
function HeroNewTrialMapPanel:ctor(...)
	HeroNewTrialMapPanel.super.ctor(self, ...)
	print("HeroNewTrialMapPanel:ctor", self.viewName)
	self.debug = true
	self.frameName = "zhujue_%s_%s_%%02d.png"
end
function HeroNewTrialMapPanel:onInit()
	print("=======HeroNewTrialMapPanel:onInit")
	self.fields.Com_title:initData(i18n("hero_experience_01"), handler(self, self.onClickClose))
	self.heroID = self.param and self.param.heroID or 1747
	self.stageMax = heroNewTrialRead.getStageMax(self.heroID)
	_ENV = handler(self, self.onClickClose)
	handler(self, self.onClickClose).num = self.stageMax
	self.fields.Text_tip:setString(i18n("hero_experience_14", handler(self, self.onClickClose)))
	self.fields.Load_map:setURL("ui://HeroNewTrial/Com_map" .. self.stageMax)
	self.fields.Com_map = self.fields.Load_map:getComponent()
	self.fieldsMap = fguiHelper.get_fields(self.fields.Com_map)
	_UPVALUE2_, self.scrollPane = self.fields.Com_map:getScrollPane(), self.fields.Com_map:getScrollPane()
	self.comStageList, self.fields.Com_map:getScrollPane()[1] = self.fields.Com_map:getScrollPane(), self.fieldsMap.Com_stage_begin
	self.comStageList, self.fields.Com_map:getScrollPane()[2] = self.fields.Com_map:getScrollPane(), self.fieldsMap.Com_stage_end
	for i = 1, self.stageMax - 2 do
		local Com_stage = self.fieldsMap["Com_stage" .. i]
		table.insert(self.comStageList, i + 1, Com_stage)
	end
	for stage, Com_stage in ipairs(self.comStageList) do
		local Button_click = Com_stage:getChild("Button_click")
		Button_click:addClickListener(handler(self, self.onClickBtnStage))
		Button_click:setTag(stage)
		local Text_stage = Com_stage:getChild("Text_stage")
		_ENV = handler(self, self.onClickBtnStage)
		handler(self, self.onClickBtnStage).num = stage
		Text_stage:setString(i18n("hero_experience_02", handler(self, self.onClickBtnStage)))
	end
	self.imageLineList, _ENV = ipairs(self.comStageList)
	for i = 1, self.stageMax - 1 do
		local Image_line = self.fieldsMap["Image_line" .. i]
		table.insert(self.imageLineList, Image_line)
	end
end
function HeroNewTrialMapPanel:onShow()
	print("=======HeroNewTrialMapPanel:onShow")
	self.fields.Com_map:setHeight(self.fields.Load_map:getHeight())
	self.curStage = heroNewTrialCtrl:getCurStage(self.heroID)
	self.showStage = math.min(self.stageMax, self.curStage)
	self:updateComStageColor()
	self:updateImageLine()
	self:updateScrollPane()
	self:updateFinishDialog()
	local beginStage = 0
	if self.showStage > 1 then
		beginStage = self.showStage - 1
	else
		beginStage = self.showStage
	end
	local pos1 = self:getComStagePos(beginStage)
	local pos2 = self:getComStagePos(beginStage + 1)
	local angle, isFlipX = self:getStageImgAngel(pos1, pos2)
	self.fieldsMap.mv_zhujue:setFlip(isFlipX and 1 or 0)
	local frameName = string.format(self.frameName, "dj", angle)
	self.fieldsMap.mv_zhujue:setAllFrameName(frameName, 1)
	local pos = self:getComStagePos(self.showStage)
	self.fieldsMap.mv_zhujue:setPosition(pos)
end
function HeroNewTrialMapPanel:getComStagePos(stage)
	local Com_stage = self.comStageList[stage]
	return Com_stage:getPosition()
end
function HeroNewTrialMapPanel:getStageImgAngel(pos1, pos2)
	local __, angle, isFlipX = worldMapFunction.getSoliderImgAngel(cc.p(pos1.x, -pos1.y), cc.p(pos2.x, -pos2.y))
	return angle, isFlipX
end
function HeroNewTrialMapPanel:onClickBtnStage(EventContext)
	SoraDPlaySound()
	local stage = EventContext:getSender():getTag()
	if stage > self.curStage then
		SoraDShowMsgTip(i18n("hero_experience_03"))
		return
	end
	local taskStatus = heroNewTrialCtrl:getStageTaskState(self.heroID, stage)
	if taskStatus == gBtnTargetStatusDef.GOT then
		SoraDShowMsgTip(i18n("hero_experience_12"))
		return
	end
	if stage == self.curStage and self.showStage ~= self.curStage then
		self:showRunAction()
		return
	end
	self:openTaskView(stage)
end
function HeroNewTrialMapPanel:onClickBtnDialog(...)
	SoraDPlaySound()
	self:openTaskView(self.curStage)
end
function HeroNewTrialMapPanel:showRunAction(...)
	local _ENV, actionList
	local moveTime = 2
	local _ENV, moveData
	local pos1 = self:getComStagePos(self.showStage)
	local pos2 = self:getComStagePos(self.showStage + 1)
	local angle, isFlipX = self:getStageImgAngel(pos1, pos2)
	table.insert(actionList, ffa.callFunc(function(...)
		self.fieldsMap.mv_zhujue:setFlip(isFlipX and 1 or 0)
		local frameName = string.format(self.frameName, "yd", angle)
		self.fieldsMap.mv_zhujue:setAllFrameName(frameName, 1)
	end))
	table.insert(actionList, ffa.moveTo(moveTime, pos2.x, pos2.y))
	table.insert(actionList, ffa.callFunc(function(...)
		self.showStage = self.showStage + 1
		SoraDCloseLoading(self)
		local frameName = string.format(self.frameName, "dj", angle)
		self.fieldsMap.mv_zhujue:setAllFrameName(frameName, 1)
		self:updateFinishDialog()
		self:openTaskView(self.showStage)
	end))
	self.fieldsMap.mv_zhujue:runAction(ffa.seq(actionList))
	SoraDShowLoading(self, nil, nil, true)
end
function HeroNewTrialMapPanel:updateComStageColor(...)
	for stage, Com_stage in ipairs(self.comStageList) do
		local Text_stage = Com_stage:getChild("Text_stage")
		if stage > self.curStage then
			Text_stage:setColor(cc.c3b(116, 110, 101))
		elseif stage == self.curStage then
			Text_stage:setColor(cc.c3b(255, 212, 62))
		else
			Text_stage:setColor(cc.c3b(227, 194, 133))
		end
	end
end
function HeroNewTrialMapPanel:updateImageLine(...)
	for stage, v in ipairs(self.imageLineList) do
		if stage >= self.curStage then
			v:setURL("ui://HeroNewTrial/frame_heroicexperience_06")
		else
			v:setURL("ui://HeroNewTrial/frame_heroicexperience_05")
		end
	end
end
function HeroNewTrialMapPanel:updateScrollPane(...)
	local s = self:getHeight() * 0.5 / 2048
	local t = (1 + s * 2) / (self.stageMax - 1)
	local percY = (self.curStage - 1) * t - s
	self.scrollPane:setPercY(1 - percY)
end
function HeroNewTrialMapPanel:onMsgUpdateView(target, event)
	local subMsg = event.subMsg
	if subMsg == "cliam" then
		self.curStage = heroNewTrialCtrl:getCurStage(self.heroID)
		self:updateComStageColor()
		self:updateImageLine()
		self:updateScrollPane()
		self:updateFinishDialog()
		if self.curStage > self.stageMax then
			heroNewTrialCtrl = self.stageMax
			self.stageMax.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			heroNewTrialCtrl, self.stageMax.step = self.heroID, 9990300
			self.stageMax.otherData, self.heroID.heroID = self.heroID, self.heroID
			SoraDSendMessage(self.stageMax)
		end
	end
end
function HeroNewTrialMapPanel:openTaskView(stage)
	local taskId = heroNewTrialRead.getTaskId(self.heroID, stage)
	heroNewTrialRead = nil
	;(nil).stage = stage
	;(nil).taskId = taskId
	uiManager:show("HeroNewTrialTask", nil)
	self.curSelectTaskId = taskId
end
function HeroNewTrialMapPanel:playGameToIncrIntimacy(target, event)
	if self.curSelectTaskId and event.isInStory and event.isWin then
		heroNewTrialCtrl:reqGameWin(self.curSelectTaskId)
		self.curSelectTaskId = nil
	end
end
function HeroNewTrialMapPanel:updateFinishDialog(...)
	if self.showStage ~= self.curStage then
		self:hideFinishDialog()
		return
	end
	local taskStatus = heroNewTrialCtrl:getStageTaskState(self.heroID, self.curStage)
	if taskStatus == gBtnTargetStatusDef.GET then
		self:showFinishDialog()
	else
		self:hideFinishDialog()
	end
end
function HeroNewTrialMapPanel:showFinishDialog(...)
	if not self.finishDialog then
		local obj = fgui.UIPackage:createObject("HeroNewTrial", "Com_dialog")
		obj:addTo(self.fields.Com_map)
		obj:setString(i18n("hero_experience_13"))
		obj:addClickListener(handler(self, self.onClickBtnDialog))
		self.finishDialog = obj
	end
	self.finishDialog:setVisible(true)
	local pos = self:getComStagePos(self.curStage)
	local Image_arrow = self.finishDialog:getChild("Image_arrow")
	local posx = Image_arrow:getPositionX()
	if pos.x > self.fields.Com_map:getWidth() / 2 then
		posx = self.finishDialog:getWidth() - posx
	end
	Image_arrow:setPositionX(posx)
	self.finishDialog:setPosition(cc.p(pos.x - posx, pos.y - 50))
end
function HeroNewTrialMapPanel:hideFinishDialog(...)
	if self.finishDialog then
		self.finishDialog:setVisible(false)
	end
end
function HeroNewTrialMapPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_close" then
		return self.fields.Com_title:gameGuide_getTarget(itemName, parameters)
	end
	return self.fields[itemName]
end
return HeroNewTrialMapPanel
