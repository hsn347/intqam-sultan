local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local romeActivityltCtrl = include("romeActivityltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_entrance = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_entrance", Com_entrance)
_ENV = fgui.register_extension
fgui.register_extension.ready = 1
fgui.register_extension.attacking = 2
local fgui.register_extension.close, RomanSoulEventType = 3, fgui.register_extension
function Com_entrance:onInit()
	self:fixChildrenPos()
	self.fields.n1:fix(false)
	self.fields.n2:fix(false)
	self.fields.n3:fix(false)
	self.fields.n4:fix(false)
	self.fields.Icon_pos:fix(false)
	local lang = SoraDGetDefaultLanguage()
	self.pos = self.fields.Node_pos
	self.count = self.fields.Node_count
	if lang ~= "ar" then
	end
	local lang = SoraDGetDefaultLanguage()
	self.fields.Image_title_yy:setVisible(lang ~= "ar")
	self.fields.Image_title_ar:setVisible(lang == "ar")
	self.fields.Text_des:setString(i18n("common_text_1234"))
	self.fields.Text_tip:setString(i18n("romanInvaders_text_01"))
	self.fields.Text_des:setString(i18n("common_text_1234"))
	self.fields.Button_fight:setTitle(i18n("common_text_1241"))
	_ENV = i18n("common_text_1241")
	i18n("common_text_1241").num = 8
	self.fields.Text_bout:setString(i18n("common_text_1236", i18n("common_text_1241")))
	self.fields.Text_place:setString(i18n("common_text_1237"))
	self.fields.Text_name:setString(i18n("common_text_1238"))
	self.fields.Text_pos:setString("X:321 Y:123")
	self.fields.Text_count:setString("x12")
	self.controllers.state:setSelectedIndex(0)
	self.fields.Button_fight:addClickListener(handler(self, self.onClickFight))
	self.fields.Icon_pos:setTouchable(true)
	self.fields.Icon_pos:addClickListener(handler(self, self.onClickPos))
end
function Com_entrance:initData()
	self.bringData, _ENV = nil, nil
	if self.activeTimer then
		SoraDManagerRemoveTimer(self, self.activeTimer)
		self.activeTimer = nil
	end
	self.tableTimers, _ENV = SoraDManagerRemoveTimer, SoraDManagerRemoveTimer
	local mainTimer = romeActivityCtrl:queryQueue(romeActivityCtrl.activityState)
	if gRomeActivityState.CLOSE == romeActivityCtrl.activityState then
		_ENV, self.isEnter = RomanSoulEventType.close, RomanSoulEventType.close
		RomanSoulEventType.close.timer = mainTimer
		RomanSoulEventType.close.timeLast = "romanInvaders_text_01"
		self.bringData, RomanSoulEventType.close.des = RomanSoulEventType.close, "common_text_1234"
	elseif gRomeActivityState.OPEN == romeActivityCtrl.activityState then
		if gAllianceRomeActivityState.NOT_OPEN == romeActivityCtrl.state then
			_ENV, self.isEnter = RomanSoulEventType.ready, RomanSoulEventType.ready
			RomanSoulEventType.ready.timer = mainTimer
			RomanSoulEventType.ready.timeLast = "romanInvaders_text_03"
			self.bringData, RomanSoulEventType.ready.des = RomanSoulEventType.ready, "common_text_1234"
			local startTime = mainTimer.timerNode.timer:getFinishTime()
			_ENV = nil
			;(nil).byUID = true
			local lastStarTime = SoraDConfigGet("Game:romansoul:startTime~integer", nil)
			if lastStarTime ~= startTime then
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:romansoul:startTime~integer", startTime, nil)
				_ENV = nil
				;(nil).type = "activity"
				;(nil).dialogueID = 900106201
				uiManager:show("MainCityGuideDialog", nil)
			end
		elseif gAllianceRomeActivityState.RUNNING == romeActivityCtrl.state then
			_ENV, self.isEnter = RomanSoulEventType.attacking, RomanSoulEventType.attacking
			RomanSoulEventType.attacking.timeLast = "common_text_1494"
			RomanSoulEventType.attacking.smallTimer = romeActivityCtrl:queryQueue("ROME_ACTIVITY_ATTACK_KEY")
			RomanSoulEventType.attacking.smallTimeLast = "common_text_1239"
			RomanSoulEventType.attacking.bout = romeActivityCtrl.times
			RomanSoulEventType.attacking.pos = romeActivityCtrl:getRomeActivityAtkPos(romeActivityCtrl.times)
			RomanSoulEventType.attacking.power = romeActivityltCtrl.getRomeActivityArmyConf(romeActivityCtrl.level, romeActivityCtrl.times)
			RomanSoulEventType.attacking.diffLevel = romeActivityCtrl.level
			self.bringData, RomanSoulEventType.attacking.selfState = RomanSoulEventType.attacking, romeActivityCtrl:getFlag()
		elseif gAllianceRomeActivityState.FINISH == romeActivityCtrl.state then
			_ENV, self.isEnter = RomanSoulEventType.close, RomanSoulEventType.close
			RomanSoulEventType.close.timer = mainTimer
			RomanSoulEventType.close.timeLast = "romanInvaders_text_04"
			self.bringData, RomanSoulEventType.close.des = RomanSoulEventType.close, "common_text_1480"
		end
	end
	self:initView()
end
function Com_entrance:initView(...)
	local nodeTab = function(index)
		local selected = 0
		if RomanSoulEventType.close == index then
			selected = 0
			if gAllianceRomeActivityState.FINISH == romeActivityCtrl.state then
				selected = 3
			end
			RomanSoulEventType = nil
			;(nil).counts = self.bringData.timer and self.bringData.timer.timerNode.timer:getRemainTime() or 0
			;(nil).txtOcx = self.fields.Text_lastTime_close
			table.insert(self.tableTimers, nil)
			self.fields.Text_des_close:setString(i18n(self.bringData.des))
			self.fields.Text_tip_close:setString(i18n(self.bringData.timeLast))
		elseif RomanSoulEventType.attacking == index then
			selected = 2
			if self.bringData.smallTimer then
				RomanSoulEventType = i18n(self.bringData.timeLast)
				i18n(self.bringData.timeLast).counts = self.bringData.smallTimer.timerNode.timer:getRemainTime() + romeActivityCtrl:getAllianceActivityLeftTime()
				i18n(self.bringData.timeLast).txtOcx = self.fields.Text_title
				i18n(self.bringData.timeLast).timeLast = self.bringData.timeLast
				table.insert(self.tableTimers, i18n(self.bringData.timeLast))
				RomanSoulEventType = i18n(self.bringData.timeLast)
				i18n(self.bringData.timeLast).counts = self.bringData.smallTimer.timerNode.timer:getRemainTime()
				i18n(self.bringData.timeLast).txtOcx = self.fields.Text_lastTime
				table.insert(self.tableTimers, i18n(self.bringData.timeLast))
			end
			RomanSoulEventType = self.bringData.smallTimer.timerNode.timer
			self.bringData.smallTimer.timerNode.timer.num = self.bringData.bout
			self.fields.Text_bout:setString(i18n("common_text_1236", self.bringData.smallTimer.timerNode.timer))
			RomanSoulEventType = i18n("common_text_1236", self.bringData.smallTimer.timerNode.timer)
			i18n("common_text_1236", self.bringData.smallTimer.timerNode.timer).level = self.bringData.diffLevel
			self.fields.Text_diffLV:setString(i18n("common_text_1229", i18n("common_text_1236", self.bringData.smallTimer.timerNode.timer)))
			self.fields.Text_des:setString(i18n("common_text_1240"))
			self.fields.Button_fight:setTitle(i18n("common_text_1242"))
			self.fields.Text_count:setString("x" .. self.bringData.power)
			self.fields.Text_pos:setString("X:" .. self.bringData.pos.x .. " Y:" .. self.bringData.pos.y)
			self.fields.Text_tip:setString(i18n("romanInvaders_text_05"))
			if self.bringData.selfState ~= gRomeActivityFlag.JOIN_ING then
				self:attackInfoShow(false)
			else
				self:attackInfoShow(true)
			end
		elseif RomanSoulEventType.ready == index then
			selected = 1
			if self.bringData.timer then
				RomanSoulEventType = true
				;(true).counts = self.bringData.timer.timerNode.timer:getRemainTime()
				;(true).txtOcx = self.fields.Text_lastTime_open
				table.insert(self.tableTimers, true)
			end
			self.fields.Text_tip_open:setString(i18n(self.bringData.timeLast))
			self.fields.Text_des:setString(i18n(self.bringData.des))
			self.fields.Button_fight:setTitleText(i18n("common_text_1241"))
		end
		self.controllers.state:setSelectedIndex(selected)
	end
	nodeTab(self.isEnter)
	self.activeTimer = SoradCreateTimer(self, handler(self, self.activeTimeUp))
	self:activeTimeUp()
end
function Com_entrance:attackInfoShow(flag)
	if flag then
	else
	end
	self.fields.Node_count:setVisible(flag)
	self.fields.Node_pos:setVisible(flag)
end
function Com_entrance:activeTimeUp(dt)
	if next(self.tableTimers) ~= nil then
		for i, v in ipairs(self.tableTimers) do
			if v.counts > 0 then
				v.counts = v.counts - 1
				if v.timeLast then
					_ENV = nil
					;(nil).time = SoraDConvertSecondToString(v.counts)
					v.txtOcx:setString(i18n(v.timeLast, nil))
				else
					v.txtOcx:setString(SoraDConvertSecondToString(v.counts))
				end
			end
		end
	end
end
function Com_entrance:onClickFight()
	SoraDPlaySound()
	if RomanSoulEventType.ready == self.isEnter then
		if allianceMgr:hasJoinAlliance() then
			uiManager:show("RomanChallengeSelect"):setOwnerKey(self)
			self.newFlag = false
		else
			SoraDShowMsgTip(i18n("common_text_583"))
		end
	elseif RomanSoulEventType.attacking == self.isEnter then
		local panel = uiManager:show("AllianceWarView")
		panel.view:tabChange(gAllianceQueueClassType.pve)
	end
end
function Com_entrance:onClickPreViewReward()
	SoraDPlaySound()
	uiManager:show("RomanRewardPreview"):setOwnerKey(self)
end
function Com_entrance:onClickPos()
	SoraDPlaySound()
	if self.bringData.pos and self.bringData.pos.x ~= 0 and self.bringData.pos.x ~= 0 then
		SoraDGotoWorldMapPoint(self.bringData.pos, false)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
return Com_entrance
