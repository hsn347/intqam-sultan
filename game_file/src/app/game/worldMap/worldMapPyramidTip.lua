local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local worldMapPyramidTip = class("worldMapPyramidTip", function()
	return SoraDCreateBasePanel("worldMapPyramidTip")
end)
local gKingdomClassType = _G.gKingdomClassType
function worldMapPyramidTip:ctor()
	self.txtTime = SoraDGetChildByName(self, "Text_tip")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.nodeTips = SoraDGetChildByName(self, "Node_tip")
	self.nodeTips:setVisible(false)
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.centerNode:setVisible(false)
	self.bmFontCountDown = SoraDGetChildByName(self, "bm_font_count_down")
	_ENV, self.inWarEnd = SoraDGetChildByName(self, "bm_font_count_down"), false
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.pyramid] = function()
		self:updateData_pyramid()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.legendLord] = function()
		self:updateData_legend()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.remains] = function()
		self:updateData_remains()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.newTrial] = function()
		self:updateData_newTrials()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.radiance] = function()
		self:updateData_radiance()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.nebula] = function()
		self:updateData_nebula()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.nebulaEmperor] = function()
		self:updateData_nebulaEmperor()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.nebulaAllStar] = function()
		self:updateData_nebulaAllStar()
	end
	SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.roaringFlame] = function()
		self:updateData_roaringFlame()
	end
	self.tabFun, SoraDGetChildByName(self, "bm_font_count_down")[gKingdomClassType.simulatedDrill] = SoraDGetChildByName(self, "bm_font_count_down"), function()
		self:updateData_simulatedDrill()
	end
end
function worldMapPyramidTip:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.updateDataLogin))
end
function worldMapPyramidTip:onEnterPanel()
	self:updateData()
end
function worldMapPyramidTip:updateDataLogin()
	self.inWarEnd = false
	self:updateData()
end
function worldMapPyramidTip:updateData()
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	local updateFun = self.tabFun[mapClassType]
	if updateFun then
		updateFun()
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:updateData_pyramid()
	if worldMapDefine.isInPyramid() then
		if not self.strWarName then
			self.strWarName = i18n("common_text_2517")
		end
		self:updatePyramidTip()
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:updateData_legend()
	if worldMapDefine.isInLegendLord() then
		local hegemonRead = include("hegemonRead")
		local bid = legendLordWarCtrl:getOpenBuildID(worldMapDefine.currentMapKindomID)
		if not bid or bid <= 0 or hegemonRead.isLegendLordBuilding(bid) then
			self.strWarName = i18n("common_text_4243")
		else
			local name = hegemonRead.getName(bid)
			self.strWarName = name
		end
		self:updateLegendLordTip()
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:updateData_remains()
	if not self.strWarName then
		self.strWarName = i18n("activityname_23")
	end
	self:updateRemainsTip()
end
function worldMapPyramidTip:updateData_newTrials()
	self:updateNewTrialTip()
end
function worldMapPyramidTip:updateData_radiance()
	if worldMapDefine.isInRadiance() then
		if not self.strWarName then
			self.strWarName = i18n("brightWar_text_21")
		end
		self:updateRadianceTip()
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:setPyramidBegin(time)
	self:setVisible(false)
	self.txtTime:setTimeLast(function(str, tick)
		if tick <= 60 then
			self:setVisible(true)
			self.nodeTips:setVisible(true)
			self = true
			;(true).name = self.strWarName
			;(true).time = str
			local reText = i18n("common_text_1050", true)
			return reText
		end
		return self.strWarName
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:setPyramidEnd(time)
	self:setVisible(true)
	self.nodeTips:setVisible(true)
	self.inWarEnd = true
	self.txtTime:setTimeLast(function(str, tick)
		_ENV = nil
		;(nil).time = str
		local reText = i18n("common_text_3200", nil)
		return reText
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
		self = self.txtTime
		self.txtTime.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_START"
		SoraDSendMessage(self.txtTime)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:removeTime(doEndHandle)
	self:setVisible(false)
	self.nodeTips:setVisible(false)
	self.centerNode:setVisible(false)
	self.inWarEnd = false
	if doEndHandle then
		self.txtTime:endTime()
	else
		self.txtTime:removeTime()
	end
end
function worldMapPyramidTip:updatePyramidTip()
	local warStatus = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatus
	if warStatus then
		if warStatus == gKingdomWarStatusType.inWar then
			self:removeTime(self.inWarEnd)
			local warTime = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatusTime or 0
			local time = kingdomMapCtrl:getPyramidWarStatusTime()
			if 0 < warTime and 0 < time then
				self:setPyramidBegin(time)
			end
		else
			local warTime = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatusTime or 0
			local time = kingdomMapCtrl:getPyramidWarStatusTime()
			if 0 < warTime and 0 < time then
				self:setPyramidEnd(time)
			else
				self:removeTime(true)
			end
		end
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:setLeagueLordBegin(time)
	self.txtTime:setTimeLast(function(str, tick)
		if tick <= 60 then
			self:setVisible(true)
			self.nodeTips:setVisible(true)
			self = true
			;(true).name = self.strWarName
			;(true).time = str
			local reText = i18n("common_text_1050", true)
			return reText
		end
		return self.strWarName
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:setLeagueLordEnd(time)
	self.inWarEnd = true
	self:setVisible(true)
	self.nodeTips:setVisible(true)
	self.txtTime:setTimeLast(function(str, tick)
		_ENV = nil
		;(nil).time = str
		local reText = i18n("common_text_3200", nil)
		return reText
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
		self = self.txtTime
		self.txtTime.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_START"
		SoraDSendMessage(self.txtTime)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:updateLegendLordTip()
	if legendLordWarCtrl:isOpen() then
		local isInWar = legendLordWarCtrl:isInWar()
		if isInWar then
			self:removeTime(self.inWarEnd)
			local time = legendLordWarCtrl:getStatusTime()
			if 0 < time then
				self:setLeagueLordBegin(time)
			end
		else
			local time = legendLordWarCtrl:getStatusTime()
			if 0 < time then
				self:setLeagueLordEnd(time)
			else
				self:removeTime(true)
			end
		end
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:setRemainsBegin(time)
	self.txtTime:setTimeLast(function(str, tick)
		if tick <= 60 then
			self:setVisible(true)
			self.nodeTips:setVisible(true)
			self = true
			;(true).name = self.strWarName
			;(true).time = str
			local reText = i18n("common_text_1050", true)
			return reText
		end
		return self.strWarName
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:setRemainsEnd(time)
	self.inWarEnd = true
	self:setVisible(true)
	self.nodeTips:setVisible(true)
	self.txtTime:setTimeLast(function(str, tick)
		_ENV = nil
		;(nil).time = str
		local reText = i18n("common_text_3200", nil)
		return reText
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
		self = self.txtTime
		self.txtTime.msg = "MESSAGE_SERVER_PYRAMIDBATTLE_START"
		SoraDSendMessage(self.txtTime)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:updateRemainsTip()
	if remainsWarCtrl:isOpen() then
		local isInWar = remainsWarCtrl:isInWar()
		if isInWar then
			self:removeTime(self.inWarEnd)
			local time = remainsWarCtrl:getStatusTime()
			if 0 < time then
				self:setRemainsBegin(time)
			end
		else
			local time = remainsWarCtrl:getStatusTime()
			if 0 < time then
				self:setRemainsEnd(time)
			else
				self:removeTime(true)
			end
		end
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:updateNewTrialTip()
	if devilValleyCtrl:isOpen() then
		local isInWar = devilValleyCtrl:isInWar()
		if not isInWar then
			local time = devilValleyCtrl:getStatusTime()
			if 0 < time then
				self:setNewTrialEnd(time)
			end
		end
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:setNewTrialEnd(time)
	self:setVisible(true)
	self.nodeTips:setVisible(false)
	self.centerNode:setVisible(true)
	self.countNum = time
	self:removeTimerHandle()
	self:updateCountTime()
	self.ctTimeHandler = SoradCreateTimer(self, handler(self, self.updateCountTime))
end
function worldMapPyramidTip:updateCountTime()
	if self.countNum <= 0 then
		self:removeTimerHandle()
		self:removeTime()
		return
	end
	self.bmFontCountDown:setString(self.countNum)
	self.bmFontCountDown:setOpacity(255)
	self:playCountDownAction()
	self.countNum = math.max(0, self.countNum - 1)
end
function worldMapPyramidTip:removeTimerHandle(time)
	if self.ctTimeHandler then
		SoraDManagerRemoveTimer(self, self.ctTimeHandler)
		self.ctTimeHandler = nil
	end
end
function worldMapPyramidTip:playCountDownAction()
	if self.bmFontCountDown then
		self.bmFontCountDown:stopAllActions()
		self.bmFontCountDown:setScale(3.2)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.scaleTo(0.4, 2.0)
		;(nil)[2] = cca.fadeOut(0.3)
		;(nil)[3] = cca.fadeOut(0.3)
		self.bmFontCountDown:runAction(cca.seq(nil))
	end
end
function worldMapPyramidTip:setRadianceBegin(time)
	self:setVisible(false)
	self.txtTime:setTimeLast(function(str, tick)
		if tick <= 60 then
			self:setVisible(true)
			self.nodeTips:setVisible(true)
			self = true
			;(true).name = self.strWarName
			;(true).time = str
			local reText = i18n("common_text_1050", true)
			return reText
		end
		return ""
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:updateRadianceTip()
	if radianceWarCtrl:isOpen() then
		local isInWar = radianceWarCtrl:isInWar()
		if isInWar then
			local time = radianceWarCtrl:getStatusTime()
			if 0 < time then
				self:setRadianceBegin(time)
			end
		end
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:updateData_nebula(...)
	if worldMapDefine.isInNebula() then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local remainTime = nebulaActivityCtrl:getWarTipRemainTime()
		if 0 < remainTime then
			self:setNebulaBegin(remainTime)
			return
		end
	end
	self:removeTime()
end
function worldMapPyramidTip:setNebulaBegin(time)
	self:setVisible(true)
	self.txtTime:setTimeLast(function(str, tick)
		self.nodeTips:setVisible(true)
		self = nil
		;(nil).time = str
		return i18n("nebula_war_text_0113") .. "\n" .. i18n("nebula_war_text_0098", nil)
	end)
	self.txtTime:setTimeEndListener(function()
		self:setVisible(false)
		self.txtTime:setTimeEndListener(nil)
	end)
	self.txtTime:beginTime(time)
end
function worldMapPyramidTip:updateData_nebulaEmperor(...)
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		local remainTime = nebulaEmperorCtrl:getWarTipRemainTime()
		if 0 < remainTime then
			self:setNebulaBegin(remainTime)
			return
		end
	end
	self:removeTime()
end
function worldMapPyramidTip:updateData_nebulaAllStar(...)
	if worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		local remainTime = nebulaAllStarCtrl:getWarTipRemainTime()
		if 0 < remainTime then
			self:setNebulaBegin(remainTime)
			self.txtTime:setTimeLast(function(str, tick)
				if tick == 3 and not SoraDCurrentTopPanelFromManager() then
					uiManager:show("NebulaAllStarReady")
				end
				self.nodeTips:setVisible(true)
				_ENV = nil
				;(nil).time = str
				return i18n("nebula_war_text_0113") .. "\n" .. i18n("nebula_war_text_0098", nil)
			end)
			return
		end
	end
	self:removeTime()
end
function worldMapPyramidTip:updateData_roaringFlame(...)
	local remainTime
	if worldMapDefine.isInRoaringFlame() then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		if not roaringFlameWarCtrl:checkInWarStatus() then
			local roaringFlameWarUtil = include("roaringFlameWarUtil")
			remainTime = roaringFlameWarUtil.getPeaceStateRemainTime()
		end
	end
	if remainTime and 0 < remainTime then
		self:setNebulaBegin(remainTime)
		self.txtTime:setTimeUpdateListener(function(timeNumber)
			if timeNumber == 3 and not SoraDCurrentTopPanelFromManager() then
				uiManager:show("NebulaAllStarReady")
			end
		end)
	else
		self:removeTime()
	end
end
function worldMapPyramidTip:updateData_simulatedDrill()
	local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
	local remainTime = simulatedDrillCtrl:getWarTipRemainTime()
	if 0 < remainTime then
		self:setNebulaBegin(remainTime)
	else
		self:removeTime()
	end
end
return worldMapPyramidTip
