local lordLocalData = include("lordLocalData")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_SearchSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_SearchSingle", Com_SearchSingle)
function Com_SearchSingle:onInit()
	self:fixChildrenPos()
	self.fields.Burron_Invatation:setString(i18n("common_text_189"))
	self.fields.Burron_Invatation:addClickListener(handler(self, self.onClickInvatation))
	self.fields.Image_bust:addClickListener(handler(self, self.onClickHead))
	self.needLv = constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_CASTLE", 64)
	self.maxNum = constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10)
	self.cdTime = constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_CD", 600)
	self.fields.Text_Status = SoraDCreateTimerLabel(self, self.fields.Text_Status)
	self.fields.Text_Status:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_725", nil, nil)
	end)
	self.fields.Text_Status:setTimeEndListener(function()
		self.fields.Text_Status:setVisible(false)
		self.fields.Burron_Invatation:setGrayed(false)
	end)
end
function Com_SearchSingle:onShow()
end
function Com_SearchSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_REINFORCEMENTS", function(target, data)
		if data.uid == self.uid and data.subMsg == "reinforcementsUpdate" then
			self:updateView()
		end
	end)
end
function Com_SearchSingle:initData(data)
	self.uid = data.uid
	self.kid = data.kid or data.partition
	self.starLv = data.starLv
	self.beginTime = nil
	self.fields.Image_bust:setURL(lordLocalData.getBust(data.iconID))
	self.fields.Text_Name:setString(textParser.formatPlayerName(data.allianceAbbr, data.nickName, self.kid))
	self.fields.Text_Power:setString(string.formatnumberthousands(data.strength))
	self.fields.Com_CastleLv:initData(data.cityLevel, data.starLv)
	if data.starLv < self.needLv then
		self.fields.Burron_Invatation:setGrayed(true)
	else
		self.fields.Burron_Invatation:setGrayed(false)
	end
	self:updateView()
end
function Com_SearchSingle:updateView()
	local info = conquestWarCtrl:getReinforceByUid(self.uid)
	self.fields.Text_Status:endTime()
	self.fields.Burron_Invatation:setVisible(true)
	self.fields.Text_Status:setVisible(false)
	if info then
		if info.state == gConquestWarReinforcementsState.INVETED then
			self.fields.Text_Status:setVisible(true)
			self.fields.Text_Status:setString(i18n("remains_btn_15"))
			self.fields.Burron_Invatation:setVisible(false)
		elseif info.state == gConquestWarReinforcementsState.AGREE then
			self.fields.Text_Status:setString(i18n("conquestwar_text_23"))
			self.fields.Text_Status:setVisible(true)
			self.fields.Burron_Invatation:setVisible(false)
		elseif info.lastInvitetime then
			self.beginTime = info.lastInvitetime
			if serviceFunctions.systemTime() - self.beginTime < self.cdTime then
				self.fields.Text_Status:beginTime(self.cdTime - (serviceFunctions.systemTime() - self.beginTime))
				self.fields.Burron_Invatation:setGrayed(true)
				self.fields.Text_Status:setVisible(true)
			end
		end
	end
end
function Com_SearchSingle:onClickInvatation()
	SoraDPlaySound()
	if self.isAgree then
		return
	end
	local battleState = conquestWarCtrl:getConquestWarState()
	if battleState < gConquestWarState.PREPARE then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
	if not conquestWarCtrl:isTriggerReinforcements() then
		SoraDShowMsgTip(i18n("conquestwar_text_35"))
		return
	end
	if not SoraDIsSelfKing() then
		SoraDShowMsgTip(i18n("conquestwar_text_36"))
		return
	end
	if self.starLv < self.needLv then
		SoraDShowMsgTip(i18n("conquestwar_text_53"))
		return
	end
	if self.beginTime and serviceFunctions.systemTime() - self.beginTime < self.cdTime then
		SoraDShowMsgTip(i18n("common_text_046"))
		return
	end
	local power, num = conquestWarCtrl:getAgreePowerAndNum()
	if num >= self.maxNum then
		_ENV = i18n("common_text_046")
		i18n("common_text_046").num = self.maxNum
		SoraDShowMsgTip(i18n("conquestwar_text_38", i18n("common_text_046")))
		return
	end
	conquestWarCtrl:reqReinforcementsInvite(self.uid)
end
function Com_SearchSingle:onClickHead()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.uid
	;(nil).kid = self.kid
	SoraDSendMessage(nil)
end
return Com_SearchSingle
