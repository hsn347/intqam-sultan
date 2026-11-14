local CitybuffProgressBar = class("citybuffProgressBar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("citybuffProgressBar")
	end
	return target
end)
local RW_BUFF_SRC = _G.RW_BUFF_SRC
function CitybuffProgressBar:ctor()
	self.tableBar = nil
	self.timerNumber = 0
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtInt = SoraDGetChildByName(self, "Text_int")
	self.proBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.proBg = SoraDGetChildByName(self, "Image_frm")
	self.txtTime:setString(SoraDConvertSecondToString(0))
end
function CitybuffProgressBar:initKingBattleData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	self.timerNumber = conquestWarCtrl:getConquestWarWinBuffLefttime()
	self.txtTime:setTimeLast(function(str, tick)
		self.proBar:setPercent(tick / CONQUESTWAR_WIN_BUFF_LASTTIME * 100)
		self.txtInt:setString(i18n("common_text_246"))
		self = i18n("common_text_246")
		i18n("common_text_246").time = str
		local reText = i18n("common_text_421", i18n("common_text_246"))
		return reText
	end)
	self.txtTime:setTimeEndListener(function(...)
		self:setVisible(false)
	end)
	if self.timerNumber > 0 then
		self.txtTime:beginTime(self.timerNumber)
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function CitybuffProgressBar:initLegendMData(buffData)
	local leftTime = buffData.finishTime - serviceFunctions.systemTime()
	local totalTime = buffData.totalTime
	self.txtTime:setTimeLast(function(str, tick)
		self.proBar:setPercent(tick / totalTime * 100)
		self = tick / totalTime * 100
		;(tick / totalTime * 100).time = str
		local reText = i18n("common_text_421", tick / totalTime * 100)
		return reText
	end)
	self.txtTime:setTimeEndListener(function(...)
		self:setVisible(false)
	end)
	if 0 < leftTime then
		self.txtTime:beginTime(leftTime)
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function CitybuffProgressBar:initRechargeBuff(buffData)
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local buffDesRead = include("buffDesRead")
	local rechargeRead = include("rechargeRead")
	local leftTime = buffData.endTime - serviceFunctions.systemTime()
	local totalTime = buffltCtrl:getTime(buffData.buffID)
	if totalTime == 0 then
		self.txtTime:setString(i18n("common_text_4497"))
		self.proBar:setPercent(100)
		self:setVisible(true)
	else
		self.txtTime:setTimeLast(function(str, tick)
			self.proBar:setPercent(tick / totalTime * 100)
			self = tick / totalTime * 100
			;(tick / totalTime * 100).time = str
			local reText = i18n("common_text_421", tick / totalTime * 100)
			return reText
		end)
		self.txtTime:setTimeEndListener(function(...)
			self:setVisible(false)
			self = self
			self.msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
			SoraDSendMessage(self)
		end)
		if 0 < leftTime then
			self.txtTime:beginTime(leftTime)
			self:setVisible(true)
		else
			self:setVisible(false)
		end
	end
	local buffCfg = rechargeRead.getBuffCfg(buffData.buffID)
	local isActive = false
	if buffCfg then
		if buffCfg.castleLv[1] == 1 then
			isActive = SoraDGetCastleLv() >= buffCfg.castleLv[2] and SoraDGetCastleLv() <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 2 then
			isActive = SoraDGetBuildStarLv() >= buffCfg.castleLv[2] and SoraDGetBuildStarLv() <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 3 then
			local quality, lv, starLv = SoraDGetBuildQuality()
			isActive = lv >= buffCfg.castleLv[2] and lv <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 4 then
			local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
			local jinn1Lv = magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
			isActive = jinn1Lv >= buffCfg.castleLv[2] and jinn1Lv <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 5 then
			local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
			local hatchLv = magicLampHatchCtrl:getHatchLv()
			isActive = hatchLv >= buffCfg.castleLv[2] and hatchLv <= buffCfg.castleLv[3]
		elseif buffCfg.castleLv[1] == 6 then
			local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
			local jinn2Lv = magicLampCtrl:getJinnLv(gJinnType.JINN_TWO)
			isActive = jinn2Lv >= buffCfg.castleLv[2] and jinn2Lv <= buffCfg.castleLv[3]
		end
	end
	if isActive then
		local buffType = buffltCtrl:getEffectType(buffData.buffID)
		local buffValue, buffMode = buffltCtrl:getEffect(buffData.buffID)
		local str = buffDesRead.getTitleValueWithValue(buffType, buffValue)
		_ENV = i18n("common_text_4497")
		i18n("common_text_4497").val = str
		self.txtInt:setString(i18n("common_text_2837", i18n("common_text_4497")))
	else
		self.txtInt:setString(i18n("hero_text_07"))
	end
end
function CitybuffProgressBar:initData(proBarType)
	self.timerNumber = proBarType:getRemainTime()
	local getTimeNodeTicket = function()
		if proBarType then
			return proBarType:getRemainTime() or 0
		else
			return 0
		end
	end
	local id = proBarType:getProperty("effectType")
	local value = proBarType:getProperty("effect")
	if "boolean" == type(value) then
		self.txtInt:setString(i18n("common_text_246"))
	elseif "number" == type(value) then
		local buffDesRead = include("buffDesRead")
		local str = buffDesRead.getTitleValueWithValue(id, value)
		_ENV = i18n("common_text_246")
		i18n("common_text_246").val = str
		self.txtInt:setString(i18n("common_text_2837", i18n("common_text_246")))
	end
	self.txtTime:setTimeLast(function(str, tick)
		self.proBar:setPercent(tick / proBarType:getProperty("time") * 100)
		self = tick / proBarType:getProperty("time") * 100
		;(tick / proBarType:getProperty("time") * 100).time = str
		local reText = i18n("common_text_421", tick / proBarType:getProperty("time") * 100)
		return reText
	end)
	self.txtTime:setTimeEndListener(function(...)
		self:setVisible(false)
	end)
	if self.timerNumber > 0 then
		self.txtTime:beginTimeNode(getTimeNodeTicket)
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function CitybuffProgressBar:initRemainsWarBuff(buffData)
	self.timerNumber = 0
	self.timerTotal = 1
	local getTimeNodeTicket
	if buffData and buffData.endTime then
		function getTimeNodeTicket()
			local timeRemains = buffData.endTime - serviceFunctions.systemTime()
			if timeRemains < 0 then
				timeRemains = 0
			end
			return timeRemains
		end
		local timeRemains = buffData.endTime - serviceFunctions.systemTime()
		if timeRemains < 0 then
			timeRemains = 0
		end
		if buffData.beginTime then
			local timeTotal = buffData.endTime - buffData.beginTime
			if timeTotal <= 0 then
				timeTotal = 1
			end
			self.timerTotal = timeTotal
		end
		self.timerNumber = timeRemains
	end
	local value = buffData.value
	self.txtInt:setVisible(true)
	if buffData.effect == gBuffEffect.RUINS_WAR_OCCUPY_DOUBLE_POINTS or buffData.effect == gBuffEffect.RUINS_WAR_MOVE_CITY_LOCKED or buffData.effect == gBuffEffect.RUINS_WAR_SPEED_QUEUE_LOCKED then
		self.txtInt:setVisible(false)
	elseif "boolean" == type(value) or buffData.effect == gBuffEffect.RUINS_WAR_SEND_ROME or buffData.effect == gBuffEffect.RUINS_WAR_LOCK_PLAYER_MOVE_CITY or buffData.effect == gBuffEffect.RUINS_WAR_LOCK_PLAYER_SPEED_QUEUE then
		self.txtInt:setString(i18n("common_text_246"))
	elseif "number" == type(value) then
		local val = ""
		if buffData.effect == gBuffEffect.TROOP_ATTACK_REDUCE or buffData.effect == gBuffEffect.TROOP_DEFENSE_REDUCE then
			val = "-" .. value / 10 .. "%"
		else
			_ENV = "%"
			;("%").title = ""
			;("%").value = value / 10
			val = i18n("common_text_1298", "%")
		end
		_ENV = i18n("common_text_246")
		i18n("common_text_246").val = val
		self.txtInt:setString(i18n("common_text_2837", i18n("common_text_246")))
	end
	self.txtTime:setTimeLast(function(str, tick)
		self.proBar:setPercent(tick / self.timerTotal * 100)
		self = tick / self.timerTotal * 100
		;(tick / self.timerTotal * 100).time = str
		local reText = i18n("common_text_421", tick / self.timerTotal * 100)
		return reText
	end)
	self.txtTime:setTimeEndListener(function(...)
		self:setVisible(false)
		self = self
		self.msg = "MESSAGE_SERVER_REMAINS_WAR_BUFF_REFRESH"
		SoraDSendMessage(self)
		if self.listener then
			self.listener()
		end
	end)
	if self.timerNumber > 0 then
		self.txtTime:beginTimeNode(getTimeNodeTicket)
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function CitybuffProgressBar:initTrickData(skill)
	self.timerNumber = skill:getSkillEffectTime()
	self.txtTime:setTimeLast(function(str, tick)
		self.proBar:setPercent(tick / CONQUESTWAR_WIN_BUFF_LASTTIME * 100)
		self.txtInt:setString(i18n("common_text_246"))
		self = i18n("common_text_246")
		i18n("common_text_246").time = str
		local reText = i18n("common_text_421", i18n("common_text_246"))
		return reText
	end)
	self.txtTime:setTimeEndListener(function(...)
		self:setVisible(false)
	end)
	if self.timerNumber > 0 then
		self.txtTime:beginTime(self.timerNumber)
		self:setVisible(true)
	else
		self:setVisible(false)
	end
end
function CitybuffProgressBar:initAtlantisOutWarBuff(buffData)
	local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
	local skillConfig = atlantisActivityCtrl:getSkillConfig(buffData.skillId)
	local totalTime = skillConfig.time
	_ENV = nil
	;(nil).finishTime = buffData.time + totalTime
	;(nil).totalTime = totalTime
	self:initLegendMData(nil)
	local count = skillConfig.count
	local remainCount = math.max(0, count - buffData.useCount)
	if 0 < remainCount then
		_ENV = nil
		;(nil).count = remainCount
		self.txtInt:setString(i18n("common_text_1673", nil))
	end
	self.txtInt:setVisible(0 < remainCount)
end
function CitybuffProgressBar:initAtlantisInWarBuff(buffData)
	local endTime = buffData.endTime
	_UPVALUE0_ = nil
	;(nil).finishTime = endTime
	;(nil).totalTime = endTime - buffData.beginTime
	self:initLegendMData(nil)
	self.txtInt:setVisible(false)
end
function CitybuffProgressBar:setMeSize(long)
	local bgSize = self.imgBg:getContentSize()
	local pbSize = self.proBar:getContentSize()
	local ppSize = self.proBg:getContentSize()
	self.imgBg:setContentSize(cc.size(410 + long, bgSize.height))
	self.proBar:setContentSize(cc.size(410 + long, pbSize.height))
	self.proBg:setContentSize(cc.size(420 + long, ppSize.height))
	self.txtInt:setPositionX(-SoraDFSign(180 + long / 2))
	self.txtTime:setPositionX(SoraDFSign(180 + long / 2))
end
function CitybuffProgressBar:setMeHeightSize(long)
	local bgSize = self.imgBg:getContentSize()
	local pbSize = self.proBar:getContentSize()
	local ppSize = self.proBg:getContentSize()
	self.imgBg:setContentSize(cc.size(bgSize.width, 24 + long))
	self.proBar:setContentSize(cc.size(pbSize.width, 21 + long))
	self.proBg:setContentSize(cc.size(ppSize.width, 41 + long))
end
function CitybuffProgressBar:setVisible(boolean)
	self.proBg:setVisible(boolean)
	self.txtTime:setVisible(boolean)
	self.proBar:setVisible(boolean)
	self.imgBg:setVisible(boolean)
	self.txtInt:setVisible(boolean)
end
function CitybuffProgressBar:setTimeEndListener(listener)
	self.listener = listener
end
return CitybuffProgressBar
