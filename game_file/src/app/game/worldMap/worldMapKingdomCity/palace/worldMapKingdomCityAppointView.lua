local WorldMapKingdomCityAppointView = class("worldMapKingdomCityAppointView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityAppointView")
	end
	return target
end)
function WorldMapKingdomCityAppointView:ctor()
	self.readyToAppointUsr = 0
	self.ocxTable, _ENV, self.tableList, _ENV, self.msgGetList, _ENV, self.classType = nil, nil, nil, nil, nil, nil, 1
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_appoint")
	self.btnOfficial = SoraDGetChildByName(self, "Button_official")
	self.btnSlaver = SoraDGetChildByName(self, "Button_slaver")
	self.btnAppoint = SoraDGetChildByName(self, "Button_appoint")
	self.btnOfficial:setTitleText(i18n("common_text_1196"))
	self.btnSlaver:setTitleText(i18n("common_text_1197"))
	self.btnOfficial:setTitleColor(cc.c3b(80, 80, 80))
	self.btnSlaver:setTitleColor(cc.c3b(80, 80, 80))
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_appoint"):setTitle(i18n("common_text_687"))
	self.btnAppoint:addTouchEventListener(handler(self, self.btnAppointClick))
	self.btnOfficial:addTouchEventListener(handler(self, self.btnOfficialClick))
	self.btnSlaver:addTouchEventListener(handler(self, self.btnSlaverClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_GETLIST", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_ADD", handler(self, self.officialAdd))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_SUB", handler(self, self.officialSub))
	self:setAppointBtnType()
	self:switchTab(self.btnOfficial)
end
function WorldMapKingdomCityAppointView:officialSub(target, data)
	if data then
		SoraDShowMsgTip(i18n("common_text_1444"))
		self:reqData()
	end
end
function WorldMapKingdomCityAppointView:officialAdd(target, data)
	if data then
		SoraDShowMsgTip(i18n("common_text_1431"))
		self:reqData()
	end
end
function WorldMapKingdomCityAppointView:reqData()
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	KWKingdomCtrl:getOfficialData()
end
function WorldMapKingdomCityAppointView:update(target, data)
	dump(data, "WorldMapKingdomCityAppointView:update", 4)
	self.msgGetList = data.retdate
	self:bindData(self:getNowClass())
end
function WorldMapKingdomCityAppointView:initData(class, uID)
	if uID then
		self.readyToAppointUsr = uID
		self.classType = class
		self:reqData()
	end
end
function WorldMapKingdomCityAppointView:bindData(class)
	local officialInfoRead = include("officialInfoRead")
	local _ENV, keyTbl = "officialInfoRead", "officialInfoRead"
	if 1 == class then
		keyTbl = table.keys(officialInfoRead.getGoodPerson())
	elseif 2 == class then
		keyTbl = table.keys(officialInfoRead.getBadPerson())
	end
	self.tableList, _ENV = table.keys(officialInfoRead.getBadPerson()), table.keys(officialInfoRead.getBadPerson())
	for _, v in ipairs(keyTbl) do
		_ENV = officialInfoRead.getBadPerson()
		officialInfoRead.getBadPerson().singleID = v
		officialInfoRead.getBadPerson().otherData = self.msgGetList[tostring(v)]
		table.insert(self.tableList, officialInfoRead.getBadPerson())
	end
	self:initView()
end
function WorldMapKingdomCityAppointView:initView()
	local sSize = self.scroll:getContentSize()
	local needH = 0
	local haveNotOcx = not next(self.ocxTable)
	for i, v in ipairs(self.tableList) do
		if haveNotOcx then
			local single = SoraDCreatePanel("worldMapKingdomCityAppointSingle")
			single:initData(v)
			single:callBackToParent(handler(self, self.eventFromSingle))
			single:setScroll(self.scroll)
			single:addTo(self.scroll)
			needH = needH + single:returnHeigh()
			table.insert(self.ocxTable, single)
		else
			self.ocxTable[i]:initData(v)
			needH = needH + self.ocxTable[i]:returnHeigh()
		end
	end
	local sH = math.max(needH, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.ocxTable) do
		v:setPosition(SoraDFPosX(0, 626), sH)
		sH = sH - v:returnHeigh()
	end
end
function WorldMapKingdomCityAppointView:eventFromSingle(single, singleData)
	dump(singleData, "single")
	if singleData.isChecked then
		for i, v in ipairs(self.ocxTable) do
			if v ~= single then
				v:setMeUnCheck()
			end
		end
		if singleData.usrID then
			self:setAppointBtnType(2)
		else
			self:setAppointBtnType(1)
		end
	else
		self:setAppointBtnType()
	end
end
function WorldMapKingdomCityAppointView:setAppointBtnType(type)
	if type == 1 then
		self.btnAppoint:setBright(true)
		self.btnAppoint:setTouchEnabled(true)
		self.btnAppoint:setTitleText(i18n("common_text_687"))
	elseif type == 2 then
		self.btnAppoint:setBright(true)
		self.btnAppoint:setTouchEnabled(true)
		self.btnAppoint:setTitleText(i18n("common_text_326"))
	else
		self.btnAppoint:setBright(false)
		self.btnAppoint:setTouchEnabled(false)
		self.btnAppoint:setTitleText(i18n("common_text_687"))
	end
end
function WorldMapKingdomCityAppointView:switchTab(button)
	local checkColor = cc.c3b(100, 80, 40)
	local uncheckColor = cc.c3b(255, 200, 100)
	local isStore = self.btnOfficial == button
	self.btnOfficial:setTouchEnabled(not isStore)
	self.btnOfficial:setBright(isStore)
	self.btnOfficial:setTitleColor(isStore and uncheckColor or checkColor)
	self.btnSlaver:setTouchEnabled(isStore)
	self.btnSlaver:setBright(not isStore)
	self.btnSlaver:setTitleColor(isStore and checkColor or uncheckColor)
	self:setAppointBtnType()
	for i, v in ipairs(self.ocxTable) do
		v:setMeUnCheck()
	end
end
function WorldMapKingdomCityAppointView:btnOfficialClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:bindData(1)
		self:switchTab(button)
	end
end
function WorldMapKingdomCityAppointView:btnSlaverClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:bindData(2)
		self:switchTab(button)
	end
end
function WorldMapKingdomCityAppointView:btnAppointClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		for i, v in ipairs(self.ocxTable) do
			local singleInfo = v:returnMeInfo()
			if singleInfo.isChecked then
				local gametop = gModuleMgr.getObject("gametop")
				local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
				if singleInfo.usrID then
					print("解雇 single:" .. singleInfo.singleID .. " theUsr:" .. singleInfo.usrID)
					KWKingdomCtrl:dismissOfficial(singleInfo.usrID, singleInfo.singleID)
				else
					print("任命: single:" .. singleInfo.singleID .. " readyUsr:" .. self.readyToAppointUsr)
					local haveName = self:checkMeInList()
					if haveName then
						_ENV = self.readyToAppointUsr
						self.readyToAppointUsr.name = haveName
						SoraDShowMsgBox(i18n("common_text_1423", self.readyToAppointUsr), i18n("common_text_204"), nil, nil)
					elseif self:checkMeIsKing(self.readyToAppointUsr) then
						KWKingdomCtrl:appointOfficial(self.readyToAppointUsr, singleInfo.singleID)
					end
				end
				v:setMeUnCheck()
				self:setAppointBtnType()
			end
		end
	end
end
function WorldMapKingdomCityAppointView:checkMeIsKing(uid)
	local gametop = gModuleMgr.getObject("gametop")
	local meUID = gametop.playertop_:getPlayerID()
	if tonumber(uid) == tonumber(meUID) then
		_ENV = nil
		;(nil).name = ""
		SoraDShowHelpMsgTip(i18n("common_text_1429", nil))
		return false
	end
	return true
end
function WorldMapKingdomCityAppointView:checkMeInList(...)
	local nickName
	for k, v in pairs(self.msgGetList) do
		if v.uid == self.readyToAppointUsr then
			nickName = v.nickName
		end
	end
	return nickName
end
function WorldMapKingdomCityAppointView:getNowClass(...)
	if self.btnSlaver:isTouchEnabled() then
		return 1
	else
		return 2
	end
end
return WorldMapKingdomCityAppointView
