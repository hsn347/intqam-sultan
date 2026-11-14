local worldMapNewTrialTopInfo = class("worldMapNewTrialTopInfo", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapNewTrialTopInfo")
	end
	return target
end)
function worldMapNewTrialTopInfo:ctor()
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		return i18n("common_text_2669") .. ticket
	end)
	SoraDSetTextWidthHeight(self.Text_time, cc.size(200, 50))
	self.Text_1 = SoraDGetChildByName(self, "Text_1")
	self.Text_1:setString(i18n("devilvalley_text_02"))
	self.Text_2 = SoraDGetChildByName(self, "Text_2")
	self.Text_2:setString(i18n("bulidDyf_title_1022"))
	self.progress1 = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapBossProgressBar_1")
	self.progress2 = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapBossProgressBar_2")
	self.maxArmyNum = 1
	self.maxDefense = 1
	self:initView()
end
function worldMapNewTrialTopInfo:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_REFRESH_DEFENSE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.initView))
end
function worldMapNewTrialTopInfo:initView()
	self.isInit = false
	local timeCount = _G.SoraDGetCtrl("devilValleyCtrl"):getBattleEndTime()
	if timeCount then
		self.Text_time:beginTime(timeCount)
	end
	self:initData()
	self:updateView()
end
function worldMapNewTrialTopInfo:initData()
	self.progress1:setPercent(100)
	self.progress2:setPercent(100)
end
function worldMapNewTrialTopInfo:updateView(target, data)
	if not self.isInit then
		local DC = _G.require_data("devilvalley_config", true)
		local teamInfo = _G.SoraDGetCtrl("devilValleyCtrl"):getMyTeams()
		if not teamInfo or not next(teamInfo) then
			return
		end
		local challengeLv = teamInfo.challengeLv or 1
		local info = DC.data[challengeLv].CastleArmyType
		local maxSize = #info
		self.maxArmyNum = 0
		for i = 1, maxSize, 2 do
			self.maxArmyNum = self.maxArmyNum + info[i + 1]
		end
		self.maxDefense = DC.data[challengeLv].CastleDefense
		self.isInit = true
	end
	local warData = _G.SoraDGetCtrl("devilValleyCtrl"):getDevilValleyWarData()
	if warData.dvwCastleHP then
		self.progress1:setPercent(math.floor(warData.dvwCastleHP / self.maxArmyNum * 100))
	end
	if warData.dvwCastleDF then
		self.progress2:setPercent(math.ceil(warData.dvwCastleDF * 100 / self.maxDefense))
	end
end
return worldMapNewTrialTopInfo
