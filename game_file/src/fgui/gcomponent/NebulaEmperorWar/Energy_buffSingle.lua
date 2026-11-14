local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Energy_buffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperorWar/Energy_buffSingle", Energy_buffSingle)
function Energy_buffSingle:onInit()
	self.fields.icon:addClickListener(handler(self, self.onClickBtnBuff))
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.fields.Text_time:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("common_text_1762", nil)
	end)
	self.fields.Text_time:setTimeEndListener(function()
		self.fields.Text_time:setVisible(false)
	end)
	self.fields.Button_exchange:addClickListener(handler(self, self.onClickBtnExchange))
end
function Energy_buffSingle:onShow()
end
function Energy_buffSingle:onClickBtnBuff(EventContext)
	SoraDPlaySound()
	_ENV = nil
	;(nil).buffID = self.buffID
	;(nil).activityID = self.activityID
	uiManager:show("NebulaEmperorEnergyBuff", nil)
end
function Energy_buffSingle:onClickBtnExchange(EventContext)
	SoraDPlaySound()
	if not self:checkActivityState() then
		SoraDShowMsgTip(i18n("nebulaemperor_text_5"))
		return
	end
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		if not nebulaAllStarCtrl:getStartPalaceWar() then
			SoraDShowMsgTip(i18n("NebulaAllstar_127"))
			return
		end
	elseif not nebulaEmperorCtrl:getStartPalaceWar() then
		SoraDShowMsgTip(i18n("nebulaemperor_text_116"))
		return
	end
	if not self:checkCanExchange() then
		if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
			SoraDShowMsgTip(i18n("NebulaAllstar_301"))
		else
			SoraDShowMsgTip(i18n("nebulaemperor_text_117"))
		end
		return
	end
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		if not worldMapDefine.isInNebulaAllStar() then
			SoraDShowMsgTip(i18n("NebulaAllstar_310"))
			return
		end
	elseif not worldMapDefine.isInNebulaEmperor() then
		SoraDShowMsgTip(i18n("nebulaemperor_text_218"))
		return
	end
	local index = EventContext:getSender():getTag()
	local exchangeCount = 0
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		exchangeCount = nebulaAllStarCtrl:getEnergyExchangeCount(self.buffID)
	else
		exchangeCount = nebulaEmperorCtrl:getEnergyExchangeCount(self.buffID)
	end
	if exchangeCount >= self.cfg.limitNum then
		SoraDShowMsgTip(i18n("nebulaemperor_text_118"))
		return
	end
	if self.buffEnergy < self.cfg.needEnergy then
		SoraDShowMsgTip(i18n("nebulaemperor_text_119"))
		return
	end
	if self.handler then
		self.handler(self.buffID)
	end
end
function Energy_buffSingle:initData(data)
	self.cfg = data.cfg
	self.buffEnergy = data.buffEnergy
	self.handler = data.handler
	self.activityID = data.activityID
	self.buffID = self.cfg.id
	self.fields.title:setString(i18n(self.cfg.name))
	self.fields.icon:setURL(self.cfg.icon)
	local buffTime = 0
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		buffTime = nebulaAllStarCtrl:getEnergyBuffTime(self.buffID)
	else
		buffTime = nebulaEmperorCtrl:getEnergyBuffTime(self.buffID)
	end
	if 0 < buffTime then
		self.fields.Text_time:setVisible(true)
		self.fields.Text_time:beginTime(buffTime)
	else
		self.fields.Text_time:setVisible(false)
	end
	local exchangeCount = 0
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		exchangeCount = nebulaAllStarCtrl:getEnergyExchangeCount(self.buffID)
	else
		exchangeCount = nebulaEmperorCtrl:getEnergyExchangeCount(self.buffID)
	end
	local count = math.max(0, self.cfg.limitNum - exchangeCount)
	_ENV = i18n(self.cfg.name)
	i18n(self.cfg.name).num = count
	self.fields.Text_count:setString(i18n("nebulaemperor_text_114", i18n(self.cfg.name)))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
	self.fields.Button_exchange:setCostNum(self.cfg.needEnergy)
	local color = cc.c3b(255, 255, 255)
	if self.buffEnergy < self.cfg.needEnergy then
		color = cc.c3b(255, 0, 0)
	end
	self.fields.Button_exchange:setGoldColor(color)
	local grayed = false
	if count <= 0 or self:checkBtnGray() then
		grayed = true
	end
	self.controllers.c_gray:setSelectedIndex(grayed and 1 or 0)
end
function Energy_buffSingle:checkBtnGray(...)
	if not self:checkCanExchange() then
		return true
	end
	if not self:checkActivityState() then
		return true
	end
	return false
end
function Energy_buffSingle:checkActivityState(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		local curState = nebulaAllStarCtrl:getActivityCurState()
		local nebulaAllStarRead = include("nebulaAllStarRead")
		if curState == nebulaAllStarRead.NEBULA_ALL_STAR_STATE.BATTLE then
			return true
		else
			return false
		end
	else
		return nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.ACTIVE)
	end
end
function Energy_buffSingle:checkCanExchange(...)
	local canExchange = false
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
		if myTeamInfo:isTeamLeader() or myTeamInfo:isTeamCommander() then
			canExchange = true
		end
	else
		local myTeamInfo = nebulaEmperorCtrl:getMyTeamInfo()
		if myTeamInfo:isTeamLeader() then
			canExchange = true
		end
	end
	return canExchange
end
return Energy_buffSingle
