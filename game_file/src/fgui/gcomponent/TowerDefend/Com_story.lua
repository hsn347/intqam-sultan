local baseComponent = require("fgui.base.baseComponent")
local Com_story = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_story", Com_story)
local foreignPavilionRead = include("foreignPavilionRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
_ENV = "exoticPavilionCtrl"
;("exoticPavilionCtrl").ROADROUGH = 1
;("exoticPavilionCtrl").LINKGAME = 2
local ("exoticPavilionCtrl").SHOOTGAME, gameTypes = 3, "exoticPavilionCtrl"
function Com_story:onInit()
	if not SoraDFIsRA() then
	end
	self.talkShowCount = 0
	self.dialogFields = fguiHelper.get_fields(self.fields.dialog)
	self.dialogControllers = fguiHelper.get_controllers(self.fields.dialog)
	self.isFirstOpen = true
	self.fields.btn_next:addEventListener(fgui.UIEventType.Click, handler(self, self.nextClick))
	self.dialogFields.btn_answer1:addClickEventListener(handler(self, self.answerClick), 1)
	self.dialogFields.btn_answer2:addClickEventListener(handler(self, self.answerClick), 2)
end
function Com_story:onShow()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.moveBy(0.5, cc.p(17, 0))
	;(nil)[2] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[3] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[4] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[5] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[6] = ffa.moveBy(0.5, cc.p(-17, 0))
	self.dialogFields.arrow:runAction(ffa.repeatForever(ffa.seq(nil)))
end
function Com_story:onHide()
	SoraDManagerRemoveTimerByTarget(self.dialogFields.text_dialog)
	SoraDManagerRemoveTimerByTarget(self.fields.center_text)
end
function Com_story:initData(show, dialogues)
	SoraDCloseLoading()
	if not show then
		self:setVisible(false)
		_ENV = self
		self.msg = "MESSAGE_TOWER_DEFEND_GAME_START"
		SoraDSendMessage(self)
		return
	end
	self.dialogues = dialogues
	self:showDialogue(self.dialogues[1])
end
function Com_story:showDialogue(dialogue)
	self.curDialogue = dialogue
	if not dialogue then
		self:endDialogue()
		return
	end
	local dialogType = self.curDialogue.type
	self.controllers.c1:setSelectedIndex(dialogType - 1)
	self.dialogControllers.c1:setSelectedIndex(dialogType - 1)
	local nickName = lordInfoCtrl:getBaseInfo().nickName
	local key1 = self.curDialogue.key1
	local key2 = self.curDialogue.key2
	local bgImg = self.curDialogue.banner
	self.dialogFields.arrow:setVisible(false)
	if dialogType == 1 then
		self.talkShowCount = true
		lordInfoCtrl = nil
		;(nil).name = nickName
		SoraDTalkModelShowText(self.dialogFields.text_dialog, i18n(key1, nil), 2.0, function()
			self.dialogFields.arrow:setVisible(true)
			self.talkShowCount = false
		end)
		SoraDTalkModelShowText(self.dialogFields.text_npcName, i18n(key2), 2.0, function()
		end)
		self.curRole = self:setModel(self.curDialogue.person)
	elseif dialogType == 2 then
		self.talkShowCount = true
		function lordInfoCtrl()
		end
		;(function()
		end).name = nickName
		SoraDTalkModelShowText(self.fields.center_text, i18n(key1, function()
		end), 2.0, function()
			self.talkShowCount = false
		end)
	elseif dialogType == 3 then
		function lordInfoCtrl()
			self.talkShowCount = false
		end
		;(function()
			self.talkShowCount = false
		end).name = nickName
		self.dialogFields.btn_answer1:setTitle(i18n(key1, function()
			self.talkShowCount = false
		end))
		lordInfoCtrl = i18n(key1, function()
			self.talkShowCount = false
		end)
		i18n(key1, function()
			self.talkShowCount = false
		end).name = nickName
		self.dialogFields.btn_answer2:setTitle(i18n(key2, i18n(key1, function()
			self.talkShowCount = false
		end)))
	end
	if bgImg and bgImg ~= "" then
		self.fields.bg:setURL(bgImg)
	end
	self:showInAction(self.oldBgImg ~= bgImg, function()
	end)
	self.oldBgImg = bgImg
end
function Com_story:setModel(modelType)
	local showRole
	if modelType == 1 then
		local lordSpineDef = include("lordSpineDef")
		local info = lordSpineDef.getLordSpineInfo(lordInfoCtrl:getBaseInfo().imageId)
		self.fields.role_1:setEffectPath(info.json)
		self.fields.role_1:setVisible(true)
		self.fields.role_1:setScale(1)
		self.fields.role_1:setPositionY(display.height - 200)
		self.fields.role_2:setVisible(false)
		self.fields.role_npc:setVisible(false)
		showRole = self.fields.role_1
	elseif modelType == 2 then
		self.fields.role_1:setEffectPath("spine/madeling.skel", "gaoxing")
		self.fields.role_1:setVisible(true)
		self.fields.role_1:setScale(1.5)
		self.fields.role_1:setPositionY(display.height - 200)
		self.fields.role_2:setVisible(false)
		self.fields.role_npc:setVisible(false)
		showRole = self.fields.role_1
	elseif modelType == 3 then
		self.fields.role_2:setEffectPath("spine/meinvguan01.skel", "daiji")
		self.fields.role_2:setVisible(true)
		self.fields.role_2:setPositionY(display.height + 300)
		self.fields.role_1:setVisible(false)
		self.fields.role_npc:setVisible(false)
		showRole = self.fields.role_2
	else
		if modelType == 4 then
			self.fields.role_2:setEffectPath("spine/jiefei.skel")
			self.fields.role_2:setPositionY(display.height)
			self.fields.role_2:setVisible(true)
			self.fields.role_1:setVisible(false)
			showRole = self.fields.role_2
		else
		end
	end
	return showRole
end
function Com_story:endDialogue()
	self:setVisible(false)
	_ENV = self
	self.msg = "MESSAGE_TOWER_DEFEND_GAME_START"
	SoraDSendMessage(self)
end
function Com_story:getNextDialog(anwser)
	anwser = anwser and anwser or 1
	local nextID = self.curDialogue["later" .. anwser]
	for index, value in ipairs(self.dialogues) do
		if value.talkID == nextID then
			return value
		end
	end
	return nil
end
function Com_story:nextClick()
	if self.isPlaying or self.talkShowCount or self.isClicked then
		return
	end
	if self.curStep == 2 then
		return
	end
	self.isClicked = true
	if self.curDialogue and self.curDialogue.type ~= 3 then
		SoraDPlaySound()
		self:showOutAction(function()
			local nextDialog = self:getNextDialog()
			self:showDialogue(nextDialog)
			self.isClicked = false
		end)
	elseif self.curStep == 3 then
		self.isClicked = false
		if self.curDialogue and self.curDialogue.type == 3 then
			return
		end
		_ENV = nil
		;(nil).gameType = gameTypes.ROADROUGH
		;(nil).isInStory = true
		uiManager:show("ForeginPGameStart", nil)
	end
end
function Com_story:answerClick(sender, tag)
	if self.isPlaying or self.isClicked then
		return
	end
	local nextDialog = self:getNextDialog(tag)
	self.isClicked = true
	self:showOutAction(function()
		self:showDialogue(nextDialog)
		self.isClicked = false
	end)
end
function Com_story:showInAction(isShowBg, callBack)
	self.isPlaying = true
	if self.curRole then
		self.curRole:stopAllActions()
		self.curRole:setAlpha(0)
		self.curRole:setPositionX(350)
		self.curRole:runAction(ffa.spawn(ffa.fadeIn(0.11666666666666667), ffa.moveBy(0.25, -30, 0)))
		if self.curRole.effect then
			self.curRole.effect:stopAllActions()
			self.curRole.effect:setOpacity(0)
			self.curRole.effect:runAction(cca.fadeIn(0.11666666666666667))
		end
	end
	self.fields.dialog:stopAllActions()
	self.fields.dialog:setAlpha(0)
	if not self.curPosition then
		self.curPosition = self.fields.dialog:getPositionY()
		self.offset = self.fields.dialog:getHeight() + 30
	end
	self.fields.dialog:setPositionY(self.curPosition + self.offset)
	self.fields.dialog:runAction(ffa.spawn(ffa.fadeIn(0.16666666666666666), ffa.moveBy(0.16666666666666666, 0, -self.offset)))
	self:runAction(ffa.seq(ffa.delay(0.25), ffa.callFunc(function()
		self.isPlaying = false
		if callBack then
			callBack()
		end
	end)))
	if isShowBg then
		self.transitions.show:play()
	end
end
function Com_story:showOutAction(callBack)
	local delayTime = 0
	if self.curRole then
		self.curRole:stopAllActions()
		self.curRole:setAlpha(1)
		self.curRole:setPositionX(320)
		self.curRole:runAction(ffa.spawn(ffa.fadeOut(0.11666666666666667), ffa.moveBy(0.11666666666666667, 30, 0)))
		if self.curRole.effect then
			self.curRole.effect:stopAllActions()
			self.curRole.effect:runAction(cca.fadeOut(0.11666666666666667))
		end
	end
	self.fields.dialog:stopAllActions()
	self.fields.dialog:setAlpha(1)
	self.fields.dialog:setPositionY(self.curPosition)
	self.fields.dialog:runAction(ffa.spawn(ffa.fadeOut(0.16666666666666666), ffa.moveBy(0.16666666666666666, 0, -self.offset)))
	delayTime = 0.16666666666666666
	self:runAction(ffa.seq(ffa.delay(delayTime), ffa.callFunc(function()
		self.isPlaying = false
		if callBack then
			callBack()
		end
	end)))
end
return Com_story
