local annivColossusCtrl = SoraDGetCtrl("annivColossusCtrl")
local annivColossusRead = include("annivColossusRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local jumpDesRead = include("jumpDesRead")
local itemDesRead = include("itemDesRead")
local longEventTime = 0.4
local spaceTime = 0.1
local longActTag = 100
_ENV = nil
;(nil).PERSON = 1
local (nil).GLOBAL, REWARDTYPE = 2, nil
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AnnivColossusActivityPanel = class("AnnivColossusActivityPanel", baseFguiPanel)
function AnnivColossusActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	print("AnnivColossusActivityPanel:ctor", self.viewName)
end
function AnnivColossusActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AnnivColossusActivity"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function AnnivColossusActivityPanel:onInit()
	SoraDPlaySound("sixYear", "ui_colossus")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	self.itemID = 841801
	self.giftID = 14482
	self.fields.Com_title:initData(i18n("activity_name_9001360"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		return strTime
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ANNIV_COLOSSUS_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
	for i = 1, 5 do
		self.fields["btn_box_" .. i]:addClickEventListener(handler(self, self.onBoxClick), i)
	end
	self.fields.button_use:setTitle(i18n("build_colossus_03"))
	self.fields.txt_use_tip:setString(i18n("build_colossus_14"))
	self.fields.button_use:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onUseClickStart))
	self.fields.button_use:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onUseClickMove))
	self.fields.button_use:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onUseClickEnd))
	self.fields.Button_add:addClickEventListener(handler(self, self.onAddClick))
	self.fields.sun_effect:setAllFrameName("dh_yg_alpha_%02d.png", 1)
	self.fields.sun_effect:setBlendFunc(gl.ONE, gl.ONE)
	self:updateView(true)
	annivColossusCtrl:reqInit()
end
function AnnivColossusActivityPanel:onShow()
	print("=======AnnivColossusActivityPanel:onShow")
	self.soundId = SoraDPlaySound("sixYear", "amb_city")
end
function AnnivColossusActivityPanel:onHide()
	AudioEngine.stopEffect(self.soundId)
end
function AnnivColossusActivityPanel:onDispose()
	print("=======AnnivColossusActivityPanel:onDispose")
end
function AnnivColossusActivityPanel:updateView(isFirst)
	self:updatePersonBox()
	self:updateGlobalBox()
	self:updateMainSp(isFirst)
end
function AnnivColossusActivityPanel:updateMainSp(isFirst)
	local scale = math.min(0.54 + (display.height - 853) / 853, 1)
	print("scale === ", scale)
	if SoraDFIsRA() then
		self.fields.sp_main_show:setScale(scale, scale)
	else
		self.fields.sp_main_show:setScale(-scale, scale)
	end
	local isShowShunShine = self.fields.sp_main_show:updateMainSp(isFirst)
	self.fields.sun_effect:setVisible(isShowShunShine)
	if isShowShunShine then
		self.fields.sun_effect:setPlaySettings(0, -1, -1)
	end
end
function AnnivColossusActivityPanel:updatePersonBox()
	local myScore = annivColossusCtrl:getMyScore()
	local myRewardCfgs = annivColossusRead:getRewards(REWARDTYPE.PERSON)
	self.myRewardCfgs = myRewardCfgs
	for i, v in ipairs(myRewardCfgs) do
		local isGot = annivColossusCtrl:isRewardGot(REWARDTYPE.PERSON, v.Rank)
		self.fields["box_txt_" .. i]:setString(v.NeedNum)
		self.fields["sp_r_" .. i]:setVisible(isGot)
		local lefSp = self.fields["s_l_" .. i]
		lefSp:setVisible(myScore >= v.NeedNum and not isGot)
		if lefSp:isVisible() then
			lefSp:stopAllActions()
			lefSp:setRotation(0)
			annivColossusCtrl = nil
			;(nil)[1] = ffa.rotateBy(2.25, 360)
			;(nil)[2] = ffa.rotateBy(2.25, 360)
			;(nil)[3] = ffa.rotateBy(2.25, 360)
			lefSp:runAction(ffa.repeatForever(ffa.seq(nil)))
		end
	end
	local myScore = annivColossusCtrl:getMyScore()
	local maxScore = annivColossusRead:getMaxScore(REWARDTYPE.PERSON)
	self.fields.progressBar2:setValue(myScore / maxScore * 100)
	annivColossusCtrl = self.fields["s_l_" .. i]
	annivColossusCtrl, annivColossusCtrl, self.fields["s_l_" .. i].var = lefSp, lefSp.runAction, myScore
	lefSp.runAction.var, lefSp.color = lefSp, "#7fcc56"
	self.fields.txt_value:setString(i18n_html("build_colossus_02", self.fields["s_l_" .. i], lefSp.runAction))
	self.haveNum = backpackCtrl:getItemCount(self.itemID)
	self.fields.button_use:setNum(self.haveNum, 1)
	self.fields.txt_have:setString(self.haveNum)
end
function AnnivColossusActivityPanel:updateGlobalBox()
	self.fields.global_box:updateGlobalBox()
end
function AnnivColossusActivityPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("build_colossus_09")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function AnnivColossusActivityPanel:onBoxClick(button, params)
	SoraDPlaySound()
	_ENV = nil
	;(nil).rewardCfg = self.myRewardCfgs[params]
	uiManager:show("AnnivColossusBoxReward", nil)
end
function AnnivColossusActivityPanel:onUseClick()
	SoraDPlaySound()
	if self.haveNum > 0 then
		self.haveNum = self.haveNum - 1
		annivColossusCtrl:reqAnnivColossusBuild()
		if self.haveNum > 0 and self.isLong then
			self:runLongPress(spaceTime)
		end
	else
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
		self:stopActionByTag(longActTag)
	end
end
function AnnivColossusActivityPanel:onUseClickStart(eventContext)
	self:runLongPress(longEventTime)
	print("AnnivColossusActivityPanel:onUseClickStart")
	self.touchBeganPoint = eventContext:getInput():getPosition()
end
function AnnivColossusActivityPanel:onUseClickMove(eventContext)
	print("AnnivColossusActivityPanel:onUseClickMove")
	self.touchmovePoint = eventContext:getInput():getPosition()
	local distance = cc.pGetDistance(self.touchBeganPoint, self.touchmovePoint)
	if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
		print("AnnivColossusActivityPanel:Moved")
		self:stopActionByTag(longActTag)
	end
end
function AnnivColossusActivityPanel:onUseClickEnd(eventContext)
	print("AnnivColossusActivityPanel:onUseClickEnd")
	self:stopActionByTag(longActTag)
	if not self.isLong then
		self:onUseClick()
	end
	self.isLong = false
end
function AnnivColossusActivityPanel:runLongPress(dt)
	self.isLong = false
	self.stop = true
	longActTag = nil
	;(nil)[1] = ffa.delay(dt)
	;(nil)[2] = ffa.callFunc(function()
		self.isLong = true
		self:onUseClick()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isLong = true
		self:onUseClick()
	end)
	local seqLong = ffa.seq(nil)
	seqLong:setTag(longActTag)
	self:runAction(seqLong)
end
function AnnivColossusActivityPanel:onAddClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
return AnnivColossusActivityPanel
