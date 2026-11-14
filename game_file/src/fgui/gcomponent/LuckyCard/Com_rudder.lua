local publicRead = include("publicRead")
local loginRewardCtrl = SoraDGetCtrl("loginRewardCtrl")
local dailyLoginRead = include("dailyLoginRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_rudder = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LuckyCard/Com_rudder", Com_rudder)
_UPVALUE5_ = fgui.register_extension
fgui.register_extension[1] = -40
fgui.register_extension[2] = 133
fgui.register_extension[3] = 0
fgui.register_extension[4] = 92
local fgui.register_extension[5], reflectList = 46, fgui.register_extension
function Com_rudder:onInit()
	self.isInGuide = false
	self.fields.Text_tip:setString(i18n("login_text_04"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_Choose:addClickListener(handler(self, self.onClickChoose))
	self.fields.Light:setVisible(false)
	self.fields.com_Spine:setEffectPath("spine/meiriqiandaorenwu.skel")
	self.fields.com_Spine.effect:setAnimation(0, "animation01", true)
	self.fields.com_Spine.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "animation02" == data.animation then
			self.fields.com_Spine.effect:setAnimation(0, "animation01", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.movie:setAllFrameName("dh_mrwz_add_%.2d.png", 1)
end
function Com_rudder:onShow()
	self:updateView()
end
function Com_rudder:updateView()
	self.curDay = loginRewardCtrl:getCurDay()
	self.isCanReceive = loginRewardCtrl:getCanReceive()
	self:removeTimer()
	if self.isCanReceive then
		self.fields.Text_Time:setString(i18n("login_text_03"))
	else
		self.timer = SoradCreateTimer(self, handler(self, self.updateTime))
		self:updateTime()
		local mul = loginRewardCtrl:getTodayMul()
		if mul then
			self.fields.Light:setVisible(true)
			self.fields.Light:setRotation(reflectList[mul])
		end
	end
	local maxDay = dailyLoginRead.getMaxDay()
	local numScroll = maxDay / 5
	print("maxDay", maxDay, maxDay / 5, self.curDay, math.ceil(self.curDay / 5) - 1)
	self.fields.List:setNumItems(numScroll)
	self.fields.List:scrollToView(math.ceil(self.curDay / 5) - 1, false, true)
	self:setNextPreview()
end
function Com_rudder:playAnimation(data)
	self.fields.com_Spine.effect:setAnimation(0, "animation02", true)
	local index = data.index
	local mul = data.mul
	local reward = data.reward
	dump(data, "playAnimation")
	self.fields.Light:setVisible(true)
	self.fields.Light:setRotation(133)
	local index = 1
	_UPVALUE5_ = nil
	;(nil)[1] = 133
	;(nil)[2] = 92
	;(nil)[3] = 46
	;(nil)[4] = 0
	;(nil)[5] = -40
	local rotations = self:getRandomNumList(nil)
	table.insert(rotations, reflectList[mul])
	dump(rotations, "rotations")
	self.transitions.t0:play(1, 0, 0, -1, function()
		_ENV = nil
		;(nil)[1] = ffa.delay(0.1)
		;(nil)[2] = ffa.callFunc(function()
			self.fields.Light:setRotation(rotations[index])
			if index == 7 then
				self:stopAllActions()
				_UPVALUE9_ = self
				self[1] = ffa.delay(0.1)
				self[2] = ffa.fadeTo(0.05, 0.0)
				self[3] = ffa.delay(0.1)
				self[4] = ffa.fadeTo(0.05, 1)
				self[5] = ffa.delay(0.1)
				self[6] = ffa.delay(0.1)
				self[7] = ffa.fadeTo(0.05, 0.0)
				self[8] = ffa.delay(0.1)
				self[9] = ffa.fadeTo(0.05, 1)
				self[10] = ffa.callFunc(function()
					local mul, awardList
					for i = 1, mul do
						mul = nil
						;(nil).id = reward[1].id
						;(nil).count = reward[1].count / mul
						table.insert(awardList, nil)
					end
					SoraDMailGainItems(awardList, true)
					if self.isInGuide and not loginRewardCtrl:isFinishGuide() then
						loginRewardCtrl:finishiGuide()
					end
					mul = loginRewardCtrl
					loginRewardCtrl.msg = "MESSAGE_UI_PYRAMID_SHOW_ITEM_REWARD"
					SoraDSendMessage(loginRewardCtrl)
				end)
				self[11] = ffa.callFunc(function()
					local mul, awardList
					for i = 1, mul do
						mul = nil
						;(nil).id = reward[1].id
						;(nil).count = reward[1].count / mul
						table.insert(awardList, nil)
					end
					SoraDMailGainItems(awardList, true)
					if self.isInGuide and not loginRewardCtrl:isFinishGuide() then
						loginRewardCtrl:finishiGuide()
					end
					mul = loginRewardCtrl
					loginRewardCtrl.msg = "MESSAGE_UI_PYRAMID_SHOW_ITEM_REWARD"
					SoraDSendMessage(loginRewardCtrl)
				end)
				local seq = ffa.seq(self)
				self.fields.Light:runAction(seq)
			end
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.Light:setRotation(rotations[index])
			if index == 7 then
				self:stopAllActions()
				_UPVALUE9_ = self
				self[1] = ffa.delay(0.1)
				self[2] = ffa.fadeTo(0.05, 0.0)
				self[3] = ffa.delay(0.1)
				self[4] = ffa.fadeTo(0.05, 1)
				self[5] = ffa.delay(0.1)
				self[6] = ffa.delay(0.1)
				self[7] = ffa.fadeTo(0.05, 0.0)
				self[8] = ffa.delay(0.1)
				self[9] = ffa.fadeTo(0.05, 1)
				self[10] = ffa.callFunc(function()
					local mul, awardList
					for i = 1, mul do
						mul = nil
						;(nil).id = reward[1].id
						;(nil).count = reward[1].count / mul
						table.insert(awardList, nil)
					end
					SoraDMailGainItems(awardList, true)
					if self.isInGuide and not loginRewardCtrl:isFinishGuide() then
						loginRewardCtrl:finishiGuide()
					end
					mul = loginRewardCtrl
					loginRewardCtrl.msg = "MESSAGE_UI_PYRAMID_SHOW_ITEM_REWARD"
					SoraDSendMessage(loginRewardCtrl)
				end)
				self[11] = ffa.callFunc(function()
					local mul, awardList
					for i = 1, mul do
						mul = nil
						;(nil).id = reward[1].id
						;(nil).count = reward[1].count / mul
						table.insert(awardList, nil)
					end
					SoraDMailGainItems(awardList, true)
					if self.isInGuide and not loginRewardCtrl:isFinishGuide() then
						loginRewardCtrl:finishiGuide()
					end
					mul = loginRewardCtrl
					loginRewardCtrl.msg = "MESSAGE_UI_PYRAMID_SHOW_ITEM_REWARD"
					SoraDSendMessage(loginRewardCtrl)
				end)
				local seq = ffa.seq(self)
				self.fields.Light:runAction(seq)
			end
		end)
		self:runAction(ffa.repeatForever(ffa.seq(nil)))
	end)
end
function Com_rudder:updateTime()
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(serviceFunctions.getTodayZeroHourUTC() + 86400 - serviceFunctions.systemTime())
	self.fields.Text_Time:setString(i18n("solomon_text_02", nil))
end
function Com_rudder:removeTimer()
	if self.timer then
		self.fields.Text_Time:setString(i18n("login_text_03"))
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function Com_rudder:setNextPreview()
	local maxDay = dailyLoginRead.getMaxDay()
	local targetShowData = dailyLoginRead.getNextShow(self.curDay)
	local targetDay = targetShowData.day
	local ret = self.curDay == targetDay and not self.isCanReceive
	if ret then
		local curDay = math.max(1, (self.curDay + 1) % maxDay)
		targetShowData = dailyLoginRead.getNextShow(curDay)
		targetDay = targetShowData.day
	end
	dailyLoginRead = nil
	;(nil).day = targetDay
	self.fields.Text_des:setString(i18n("solomon_text_01", nil))
	self.fields.Bar:setMax(targetDay)
	self.fields.Bar:setValue(ret and self.curDay % maxDay or self.curDay)
	local targetData = targetShowData.reward
	local showID = targetData[1].id
	local showNum = targetData[1].count
	self.fields.Icon_next:setURL(publicRead.getIcon(showID))
end
function Com_rudder:onItemRederer(index, target)
	target:initData(index + 1)
end
function Com_rudder:onClickChoose()
	SoraDPlaySound()
	if self.isCanReceive then
		loginRewardCtrl:receiveReward(loginRewardCtrl:getNewLocation())
	end
end
function Com_rudder:setIsInGuide(isInGuide)
	self.isInGuide = isInGuide
end
function Com_rudder:getRandomNumList(rsList)
	local num, tmp
	local len = #rsList
	for i = 1, len do
		num = math.random(1, len)
		tmp = rsList[i]
		rsList[i] = rsList[num]
		rsList[num] = tmp
	end
	return rsList
end
return Com_rudder
