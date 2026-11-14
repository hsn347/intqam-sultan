local gametop = gModuleMgr.getObject("gametop")
local batteryStateViewLogRecord = class("batteryStateViewLogRecord", function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("batteryStateViewLogRecord")
	end
	if target ~= nil then
		local timerClass = include("batteryStateViewLogBase")
		target = timerClass.new(target)
	end
	return target
end)
function batteryStateViewLogRecord:ctor()
	self.ccs_bg:setTitleName(i18n("common_text_836"))
	self.single = SoraDGetChildByName(self, "Image_kingSIngleCopy")
	self.single:setVisible(false)
end
function batteryStateViewLogRecord:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACE", handler(self, self.updatePalace))
end
function batteryStateViewLogRecord:updatePalace(target, retdate)
	self:updateData(retdate.retdate)
	SoraDCloseLoading(self)
end
function batteryStateViewLogRecord:req4Info()
	if not self.hasMore then
		return
	end
	SoraDShowLoading(self)
	if self.argList.warType == gKingdomClassType.atlantis then
		local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
		atlantisWarCtrl:reqBuildOccupyLog(self.argList.buildId, self.nextIndex)
	elseif self.argList.warType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		nebulaActivityCtrl:reqPalaceOccupyLog(self.argList.buildId, self.nextIndex, 20)
	elseif self.argList.warType == gKingdomClassType.simulatedDrill then
		local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
		simulatedDrillCtrl:reqPalaceOccupyLog(self.argList.buildId, self.nextIndex, 20)
	else
		local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
		KWKingdomCtrl:getPlaceLog(self.argList.uPos.x, self.argList.uPos.y, self.nextIndex)
	end
end
function batteryStateViewLogRecord:createNode()
	return self.single:clone()
end
function batteryStateViewLogRecord:refreshNode(single, index, data)
	single:getChildByName("Image_Bg"):setVisible(index % 2 ~= 0)
	local text_content = single:getChildByName("Text_content")
	if self.argList.warType == gKingdomClassType.nebula then
		local aName = data.name .. "#" .. data.fromKid
		_ENV = nil
		;(nil).name = aName
		;(nil).place = self.argList.place
		text_content:setString(i18n("common_text_1200", nil))
	elseif self.argList.warType == gKingdomClassType.simulatedDrill then
		data.time = data.beginOccupyTime
		local simulatedDrillUtil = include("simulatedDrillUtil")
		local campName = simulatedDrillUtil.getCampName(data.camp)
		local aName = textParser.formatPlayerName(campName, data.nickName)
		_ENV = i18n("common_text_1200", nil)
		i18n("common_text_1200", nil).name = aName
		i18n("common_text_1200", nil).place = self.argList.place
		text_content:setString(i18n("common_text_1200", i18n("common_text_1200", nil)))
	else
		self:reRecordText(data, text_content)
	end
	dump(data, "batteryStateViewLogRecord")
	single:getChildByName("Text_time"):setString(SoraDConvertTimeToDate(data.time or data.t, false, true))
end
function batteryStateViewLogRecord:reRecordText(data, text_content)
	local type = data.logType
	local reText = ""
	if data.aAbbr then
		_ENV = nil
		;(nil).name = data.aName
		;(nil).abbr = data.aAbbr
		if i18n("common_text_186", nil) then
			goto lbl_17
		end
	end
	local aName = data.aName
	::lbl_17::
	if aName and data.aSourceKid and 0 ~= data.aSourceKid then
		aName = aName .. "#" .. tostring(data.aSourceKid)
	end
	if data.dAbbr then
		_ENV = tostring(data.aSourceKid)
		tostring(data.aSourceKid).name = data.dName
		tostring(data.aSourceKid).abbr = data.dAbbr
		if i18n("common_text_186", (tostring(data.aSourceKid))) then
			goto lbl_45
		end
	end
	local dName = data.dName
	::lbl_45::
	if dName and data.dSourceKid and 0 ~= data.dSourceKid then
		dName = dName .. "#" .. tostring(data.dSourceKid)
	end
	local sourceKid = data.aSourceKid
	local rfKid = data.aRfKid
	if gPlaceLogType.occupy == type then
		_ENV = nil
		;(nil).name = aName
		;(nil).place = self.argList.place
		reText = i18n("common_text_1200", nil)
	elseif gPlaceLogType.attackOccupy == type then
		_ENV = nil
		;(nil).attack = aName
		;(nil).defend = dName
		;(nil).place = self.argList.place
		reText = i18n("common_text_1201", nil)
	elseif gPlaceLogType.defendOccupy == type then
		_ENV = nil
		;(nil).attack = aName
		;(nil).defend = dName
		;(nil).place = self.argList.place
		reText = i18n("common_text_1198", nil)
		sourceKid = data.dSourceKid
		rfKid = data.dRfKid
	elseif gPlaceLogType.massOccupy == type then
		_ENV = nil
		;(nil).name = aName
		;(nil).place = self.argList.place
		reText = i18n("common_text_1200", nil)
	elseif gPlaceLogType.massAttackOccupy == type then
		_ENV = nil
		;(nil).attack = aName
		;(nil).defend = dName
		;(nil).place = self.argList.place
		reText = i18n("common_text_1202", nil)
	elseif gPlaceLogType.massDefendOccupy == type then
		_ENV = nil
		;(nil).attack = aName
		;(nil).defend = dName
		;(nil).place = self.argList.place
		reText = i18n("common_text_1421", nil)
		sourceKid = data.dSourceKid
		rfKid = data.dRfKid
	elseif gPlaceLogType.help == type then
		_ENV = nil
		;(nil).name = aName
		;(nil).place = self.argList.place
		reText = i18n("common_text_1199", nil)
	elseif gPlaceLogType.ownFortCmdPost == type then
		if data.aSourceKid then
			local kingdomName = serviceFunctions.getKingdomFormatName(data.aKingdomName, data.aSourceKid)
			_ENV = self.argList.place
			self.argList.place.var1 = kingdomName
			self.argList.place.var2 = ""
			self.argList.place.var3 = self.argList.place
			reText = i18n("atlantiswar_text_0092", self.argList.place)
		else
			_ENV = "atlantiswar_text_0092"
			;("atlantiswar_text_0092").var = self.argList.place
			reText = i18n("atlantiswar_text_0234", "atlantiswar_text_0092")
		end
	end
	local color = display.COLOR_WHITE
	if rfKid and 0 ~= rfKid then
		sourceKid = rfKid
	end
	if sourceKid and 0 ~= sourceKid then
		local kid = worldMapDefine.currentMapKindomID
		if self.argList.warType == gKingdomClassType.atlantis then
			kid = gametop.playertop_:getKingdomID()
		end
		if kid ~= sourceKid then
			color = cc.c3b(190, 40, 40)
		end
	end
	text_content:setColor(color)
	text_content:setString(reText)
end
return batteryStateViewLogRecord
