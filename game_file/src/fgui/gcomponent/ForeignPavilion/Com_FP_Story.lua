local baseComponent = require("fgui.base.baseComponent")
local Com_FP_Story = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_Story", Com_FP_Story)
local foreignPavilionRead = include("foreignPavilionRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
_ENV = "exoticPavilionCtrl"
;("exoticPavilionCtrl").ROADROUGH = 1
;("exoticPavilionCtrl").LINKGAME = 2
;("exoticPavilionCtrl").SHOOTGAME = 3
local ("exoticPavilionCtrl").TOWERDEFEND, gameTypes = 4, "exoticPavilionCtrl"
function Com_FP_Story:onInit()
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
function Com_FP_Story:onShow()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.moveBy(0.5, cc.p(17, 0))
	;(nil)[2] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[3] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[4] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[5] = ffa.moveBy(0.5, cc.p(-17, 0))
	;(nil)[6] = ffa.moveBy(0.5, cc.p(-17, 0))
	self.dialogFields.arrow:runAction(ffa.repeatForever(ffa.seq(nil)))
end
function Com_FP_Story:onHide()
	SoraDManagerRemoveTimerByTarget(self.dialogFields.text_dialog)
	SoraDManagerRemoveTimerByTarget(self.fields.center_text)
end
function Com_FP_Story:initData(curStage, curStep)
	SoraDCloseLoading()
	if curStage == 2 or curStep == 0 or curStep == nil then
		self:setVisible(false)
		return
	end
	self.curStep = curStep
	if curStep == 2 and self.isFirstOpen then
		self:endDialogue()
	end
	self.isFirstOpen = false
	self.dialogues = foreignPavilionRead:getDialogues(curStep)
	local dialogue = self.dialogues and self.dialogues[1]
	self:showDialogue(dialogue, true)
end
function Com_FP_Story:showDialogue(dialogue)
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
		self.dialogFields.arrow:setVisible(true)
		self.talkShowCount = false
		lordInfoCtrl = nil
		;(nil).name = nickName
		self.dialogFields.text_dialog:setString(i18n(key1, nil))
		self.curRole = self:setModel(self.curDialogue.person)
	elseif dialogType == 2 then
		self.talkShowCount = true
		lordInfoCtrl = i18n(key1, nil)
		i18n(key1, nil).name = nickName
		self.fields.center_text:setString(i18n(key1, i18n(key1, nil)))
		self.talkShowCount = false
	elseif dialogType == 3 then
		lordInfoCtrl = i18n(key1, i18n(key1, nil))
		i18n(key1, i18n(key1, nil)).name = nickName
		self.dialogFields.btn_answer1:setTitle(i18n(key1, i18n(key1, i18n(key1, nil))))
		lordInfoCtrl = i18n(key1, i18n(key1, i18n(key1, nil)))
		i18n(key1, i18n(key1, i18n(key1, nil))).name = nickName
		self.dialogFields.btn_answer2:setTitle(i18n(key2, i18n(key1, i18n(key1, i18n(key1, nil)))))
	end
	self.fields.bg:setURL(bgImg)
	self:showInAction(self.oldBgImg ~= bgImg, function()
	end)
	self.oldBgImg = bgImg
end
function Com_FP_Story:setModel(modelType)
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
		self.fields.role_2:setEffectPath("spine/jiefei.skel")
		self.fields.role_2:setPositionY(display.height)
		self.fields.role_2:setVisible(true)
		self.fields.role_1:setVisible(false)
		showRole = self.fields.role_2
	end
	return showRole
end
function Com_FP_Story:endDialogue()
	if self.curStep == 3 then
		_ENV = nil
		;(nil).gameType = gameTypes.TOWERDEFEND
		;(nil).isInStory = true
		uiManager:show("ForeginPGameStart", nil)
	elseif self.curStep == 4 then
		SoraDShowLoading()
		exoticPavilionCtrl:reqEPFinshStep()
		_ENV = nil
		;(nil).isFromTask = true
		gModuleMgr.sharedMgr("mildGuideManager"):setVariate("ForeignPavilionActivity", nil)
	else
		SoraDShowLoading()
		exoticPavilionCtrl:reqEPFinshStep()
	end
end
function Com_FP_Story:getNextDialog(anwser)
	anwser = anwser and anwser or 1
	local nextID = self.curDialogue["later" .. anwser]
	for index, value in ipairs(self.dialogues) do
		if value.talkID == nextID then
			return value
		end
	end
	return nil
end
function Com_FP_Story:nextClick()
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
		;(nil).gameType = gameTypes.TOWERDEFEND
		;(nil).isInStory = true
		uiManager:show("ForeginPGameStart", nil)
	end
end
function Com_FP_Story:answerClick(sender, tag)
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
function Com_FP_Story:showInAction(isShowBg, callBack)
	self.adjustBoxDown = 4
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
	self.fields.dialog:setPositionY(display.height + 30)
	self.fields.dialog:runAction(ffa.spawn(ffa.fadeIn(0.16666666666666666), ffa.moveBy(0.16666666666666666, 0, -30 + self.adjustBoxDown)))
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
function Com_FP_Story:showOutAction(callBack)
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
	self.fields.dialog:setPositionY(display.height)
	self.fields.dialog:runAction(ffa.spawn(ffa.fadeOut(0.16666666666666666), ffa.moveBy(0.16666666666666666, 0, 30)))
	delayTime = 0.16666666666666666
	self:runAction(ffa.seq(ffa.delay(delayTime), ffa.callFunc(function()
		self.isPlaying = false
		if callBack then
			callBack()
		end
	end)))
end
return Com_FP_Story
