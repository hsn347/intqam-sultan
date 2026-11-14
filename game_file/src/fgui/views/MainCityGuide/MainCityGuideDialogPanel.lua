local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MainCityGuideDialogPanel = class("MainCityGuideDialogPanel", baseFguiPanel)
local mainCityGuideRead = include("mainCityGuideRead")
local newActivityRead = include("newActivityRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordSpineDef = include("lordSpineDef")
_ENV, _ENV = nil, "lordSpineDef"
;(nil).res = "spine/nianqingzhujue.skel"
;(nil).posYAdd = -165
_ENV, ("lordSpineDef").figure1, (nil).scale = nil, nil, 0.7
;(nil).res = "spine/herosV/heroModle_170901.skel"
;(nil).posYAdd = 240
_ENV, ("lordSpineDef").figure2, (nil).scale = nil, nil, 1.1
;(nil).res = "spine/jiefei.skel"
;(nil).scale = 0.7
_ENV, ("lordSpineDef").figure3, (nil).posYAdd = nil, nil, -165
;(nil).res = "spine/herosV/heroModle_170201.skel"
;(nil).posYAdd = 240
_ENV, ("lordSpineDef").figure4, (nil).scale = nil, nil, 1.1
;(nil).res = "spine/zhaoya.skel"
;(nil).scale = 0.7
_ENV, ("lordSpineDef").figure5, (nil).posYAdd = nil, nil, -125
;(nil).res = "spine/soldiersV4/12_5bubing.skel"
;(nil).scale = 1.5
_ENV, ("lordSpineDef").figure6, (nil).posYAdd = nil, nil, -95
;(nil).res = "spine/madeling.skel"
;(nil).action = "gaoxing"
;(nil).scale = 1.4
_ENV, ("lordSpineDef").figure7, (nil).posYAdd = nil, nil, -180
;(nil).res = "spine/luomazhanhunNPC.skel"
;(nil).scale = 0.8
_ENV, ("lordSpineDef").figure8, (nil).posYAdd = nil, nil, -140
;(nil).res = "lordHead"
;(nil).scale = 0.9
_ENV, ("lordSpineDef").lord, (nil).posYAdd = nil, nil, -220
_ENV, _ENV, ("lordSpineDef").delult, (nil).res = nil, nil, nil, "spine/jiefei.skel"
local dialogRoles = "lordSpineDef"
;(nil)[1] = "newplayer_whip"
;(nil)[81010004], (nil)[2] = nil, "newplayer_cry"
local soundCfgs
function MainCityGuideDialogPanel:ctor(...)
	self.debug = true
	self.super.ctor(self, ...)
	print("MainCityGuideDialogPanel:ctor", self.viewName)
end
function MainCityGuideDialogPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MainCityGuideDialogPanel:onInit()
	print("=======MainCityGuideDialogPanel:onInit")
	self.dialogFields = fguiHelper.get_fields(self.fields.dialog)
	self.dialogCtrls = fguiHelper.get_controllers(self.fields.dialog)
	self.fields.btn_next:addEventListener(fgui.UIEventType.Click, handler(self, self.nextClick))
	if self.fields.Button_close then
		self.fields.Button_close:setVisible(device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop())
	end
	self.dialogFields.arrow:fix()
	self.dialogFields.arrow:fixPos()
end
function MainCityGuideDialogPanel:onShow()
	print("=======MainCityGuideDialogPanel:onShow")
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.moveBy(0.5, cc.p(10, 0))
	;(nil)[2] = ffa.moveBy(0.5, cc.p(-10, 0))
	;(nil)[3] = ffa.moveBy(0.5, cc.p(-10, 0))
	;(nil)[4] = ffa.moveBy(0.5, cc.p(-10, 0))
	;(nil)[5] = ffa.moveBy(0.5, cc.p(-10, 0))
	;(nil)[6] = ffa.moveBy(0.5, cc.p(-10, 0))
	self.dialogFields.arrow:runAction(ffa.repeatForever(ffa.seq(nil)))
	self.width = self.view:getSize().width
	self.height = self.view:getSize().height
	self:initData()
end
function MainCityGuideDialogPanel:onHide()
	if self.endCallback then
		self.endCallback()
	end
	SoraDManagerRemoveTimerByTarget(self.dialogFields.text_dialog)
	SoraDManagerRemoveTimerByTarget(self.fields.center_text)
end
function MainCityGuideDialogPanel:initData()
	if self.param.type == "activity" then
		self.dialogues = newActivityRead:getDialogues(self.param.dialogueID)
	else
		self.dialogues = mainCityGuideRead:getDialogues(self.param.dialogueID)
	end
	if not self.dialogues then
		return
	end
	self.soundCfg = soundCfgs[self.param.dialogueID]
	self.endCallback = self.param and self.param.callback
	self.curIdx = 0
	self:showDialogue()
end
function MainCityGuideDialogPanel:showDialogue()
	self.curIdx = self.curIdx + 1
	self.curDialogue = self.dialogues[self.curIdx]
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
		self.soundId = nil
	end
	if not self.curDialogue then
		self:endDialogue()
		return
	end
	local dialogType = self.curDialogue.type
	local nickName = lordInfoCtrl:getBaseInfo().nickName
	local key = self.curDialogue.key
	self.dialogFields.arrow:setVisible(false)
	self.talkShowCount = false
	_ENV = nil
	;(nil).name = nickName
	self.dialogFields.text_dialog:setString(i18n(key, nil))
	_ENV = i18n(key, nil)
	i18n(key, nil).name = nickName
	self.showStr = i18n(key, i18n(key, nil))
	self.dialogFields.text_dialog:setString(self.showStr)
	local sound = self.soundCfg and self.soundCfg[self.curIdx] or nil
	if sound then
		self.soundId = SoraDPlaySound("mainCityGuide", sound)
	end
	local buble = self.curDialogue.bubble
	if buble then
		_ENV = sound
		sound.msg = "MESSAGE_MAINCITYGUIDE_ROLETALK"
		sound.role = buble
		SoraDSendMessage(sound)
	end
	self.curRole = self:setModel(self.curDialogue)
	self.dialogFields.name1:setTitle(i18n(self.curDialogue.name))
	self.dialogFields.name2:setTitle(i18n(self.curDialogue.name))
	self.dialogCtrls.c1:setSelectedIndex(self.curDialogue.location == 1 and 0 or 1)
	self:showInAction(true, function()
	end)
	local bgImg
	self.oldBgImg = bgImg
end
function MainCityGuideDialogPanel:setModel(curDialogue)
	local image = curDialogue.image
	local roleCfg = dialogRoles[image] or dialogue.default
	local showRole = curDialogue.location == 1 and self.fields.role_1 or self.fields.role_2
	local hideRole = curDialogue.location == 1 and self.fields.role_2 or self.fields.role_1
	local res = roleCfg.res
	if roleCfg.res == "lordHead" then
		local info = lordSpineDef.getLordSpineInfo(lordInfoCtrl:getBaseInfo().imageId)
		res = info.json
	end
	showRole:setEffectPath(res, roleCfg.action)
	local scale = roleCfg.scale == nil and 1.0 or roleCfg.scale
	showRole:setScaleX(curDialogue.turn == 1 and -scale or scale)
	showRole:setScaleY(scale)
	showRole:setPositionY(self.height + (roleCfg.posYAdd ~= nil and roleCfg.posYAdd or 0))
	showRole:setVisible(true)
	hideRole:setVisible(false)
	return showRole
end
function MainCityGuideDialogPanel:endDialogue()
	self:close()
end
function MainCityGuideDialogPanel:showInAction(isShowBg, callBack)
	self.adjustBoxDown = 4
	self.isPlaying = true
	if self.curRole then
		self.curRole:stopAllActions()
		self.curRole:setAlpha(0)
		local startX = self.curDialogue.location == 1 and self.width / 2 - 170 or self.width / 2 + 170
		local MoveX = self.curDialogue.location == 1 and -30 or 30
		self.curRole:setPositionX(startX + MoveX)
		self.curRole:runAction(ffa.spawn(ffa.fadeIn(0.11666666666666667), ffa.moveBy(0.25, -MoveX, 0)))
		if self.curRole.effect then
			self.curRole.effect:stopAllActions()
			self.curRole.effect:setOpacity(0)
			self.curRole.effect:runAction(cca.fadeIn(0.11666666666666667))
		end
	end
	self.fields.dialog:stopAllActions()
	self.fields.dialog:setAlpha(0)
	self.fields.dialog:setPositionY(self.height + 30)
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
function MainCityGuideDialogPanel:showOutAction(callBack)
	local delayTime = 0
	if self.curRole then
		self.curRole:stopAllActions()
		self.curRole:setAlpha(1)
		local startX = self.curDialogue.location == 1 and self.width / 2 - 170 or self.width / 2 + 170
		local MoveX = self.curDialogue.location == 1 and -30 or 30
		self.curRole:setPositionX(startX)
		self.curRole:runAction(ffa.spawn(ffa.fadeOut(0.11666666666666667), ffa.moveBy(0.11666666666666667, MoveX, 0)))
		if self.curRole.effect then
			self.curRole.effect:stopAllActions()
			self.curRole.effect:runAction(cca.fadeOut(0.11666666666666667))
		end
	end
	self.fields.dialog:stopAllActions()
	self.fields.dialog:setAlpha(1)
	self.fields.dialog:setPositionY(self.height)
	self.fields.dialog:runAction(ffa.spawn(ffa.fadeOut(0.16666666666666666), ffa.moveBy(0.16666666666666666, 0, 30)))
	delayTime = 0.16666666666666666
	self:runAction(ffa.seq(ffa.delay(delayTime), ffa.callFunc(function()
		self.isPlaying = false
		if callBack then
			callBack()
		end
	end)))
end
function MainCityGuideDialogPanel:nextClick()
	if self.talkShowCount then
		SoraDManagerRemoveTimer(self.dialogFields.text_dialog, self.dialogFields.text_dialog.timer)
		self.dialogFields.text_dialog:setString(self.showStr)
		self.dialogFields.arrow:setVisible(true)
		self.talkShowCount = false
		return
	end
	if self.isPlaying or self.isClicked then
		return
	end
	self.isClicked = true
	SoraDPlaySound()
	self:showOutAction(function()
		self:showDialogue()
		self.isClicked = false
	end)
end
return MainCityGuideDialogPanel
