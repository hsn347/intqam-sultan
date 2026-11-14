local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local exaltedPrivilegeCtrl = class("exaltedPrivilegeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function exaltedPrivilegeCtrl:ctor(properties)
	exaltedPrivilegeCtrl.super.ctor(self, properties)
	self:resetData()
end
function exaltedPrivilegeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_GETREWARD, handler(self, self.reqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_BUYGIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_SET_BIRTHDAY, handler(self, self.reqSetBirthdayRsp))
	msgCtrl.register(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_CLEAR_NEWFLAG, handler(self, self.reqCleanNewFlagRsp))
	msgCtrl.register(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_EXALTED_PHONE, handler(self, self.reqPhoneNumRsp))
	self:resetData()
	self:registerNotify()
	self:reqInitInfo()
end
function exaltedPrivilegeCtrl:Logout()
	exaltedPrivilegeCtrl.super.Logout(self)
	self:resetData()
end
function exaltedPrivilegeCtrl:initClientData(data)
end
function exaltedPrivilegeCtrl:resetData()
	self.clientData = nil
	self.welfareData = nil
end
function exaltedPrivilegeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.EXALTED_PRIVILEGE, handler(self, self.notifyHandler))
end
function exaltedPrivilegeCtrl:notifyHandler(event)
	dump(event.data, "exaltedPrivilegeCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			if content.type == "buyGift" then
				self.clientData.userData.buyGiftList = content.data.buyGiftList
				_ENV = content.data.buyGiftList
				content.data.buyGiftList.msg = "MESSAGE_EXCLUSIVE_VIP_BUY_PACKAGE"
				SoraDSendMessage(content.data.buyGiftList)
				_ENV = content.data.buyGiftList
				_ENV, content.data.buyGiftList.msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				content.data.buyGiftList.data, (nil).result = nil, true
				SoraDSendMessage(content.data.buyGiftList)
			elseif content.type == "initData" then
				self.clientData = content.data
				if content.data.rewardData then
					self.welfareData = content.data.rewardData
				end
				_ENV = content.data.buyGiftList
				content.data.buyGiftList.msg = "MESSAGE_EXCLUSIVE_VIP_REFRESH_DATA"
				SoraDSendMessage(content.data.buyGiftList)
				_ENV = content.data.buyGiftList
				content.data.buyGiftList.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
				SoraDSendMessage(content.data.buyGiftList)
			end
		end
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART"
	SoraDSendMessage(pairs(event.data))
end
function exaltedPrivilegeCtrl:reqInitInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_INIT, data)
end
function exaltedPrivilegeCtrl:reqGetReward(privilegeType, opencount)
	serverproxy = nil
	;(nil).privilegeType = privilegeType
	local (nil).opencount, data = opencount, nil
	serverproxy:Request(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_GETREWARD, data)
end
function exaltedPrivilegeCtrl:reqBuyGift(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_BUYGIFT, data)
end
function exaltedPrivilegeCtrl:reqSetBirthday(month, day, year)
	serverproxy = nil
	;(nil).month = month
	;(nil).day = day
	local (nil).year, data = year, nil
	serverproxy:Request(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_SET_BIRTHDAY, data)
end
function exaltedPrivilegeCtrl:reqSetPhoneNum(phoneNum, areatype)
	serverproxy = nil
	;(nil).phoneNum = phoneNum
	local (nil).areatype, data = areatype, nil
	serverproxy:Request(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_EXALTED_PHONE, data)
end
function exaltedPrivilegeCtrl:reqCleanNewFlag(switchType)
	serverproxy = nil
	local (nil).switchType, data = switchType, nil
	serverproxy:Request(gCmd.CMD_EXALTED_PRIVILEGE_MODULE, gCmd.REQ_EXALTED_PRIVILEGE_CLEAR_NEWFLAG, data)
end
function exaltedPrivilegeCtrl:reqInitRsp(content)
	dump(content, "exaltedPrivilegeCtrl:reqInitRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.clientData = content.rspdata
		if content.rspdata.rewardData then
			self.welfareData = content.rspdata.rewardData
		end
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_EXCLUSIVE_VIP_INIT"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function exaltedPrivilegeCtrl:reqGetRewardRsp(content)
	if content.err == gErrDef.Err_None then
		self.welfareData = content.rspdata.rewardData
		self.clientData.userData.privilegeRewardData = content.rspdata.userData.privilegeRewardData
		SoraDMailGainItems(content.rspdata.rewardInfo, true)
		_ENV = content.rspdata.rewardInfo
		content.rspdata.rewardInfo.msg = "MESSAGE_EXCLUSIVE_VIP_WELFARE_REFRESH"
		SoraDSendMessage(content.rspdata.rewardInfo)
	elseif content.err == gErrDef.Err_EXALTED_PRIVILEGE_NOT_ACTIVE then
		SoraDShowMsgTip("privilege_text_36")
	end
end
function exaltedPrivilegeCtrl:reqBuyGiftRsp(content)
	if content.err == gErrDef.Err_None then
		paymentManager.purchase(content.data.rechargeID, content.rspdata.orderID)
	end
end
function exaltedPrivilegeCtrl:reqSetBirthdayRsp(content)
	dump(content, "exaltedPrivilegeCtrl:reqSetBirthdayRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.welfareData = content.rspdata.rewardData
		self.clientData.userData.birthDate = content.rspdata.userData.birthDate
		self.clientData.userData.setBirthTime = content.rspdata.userData.setBirthTime
		_ENV = content.rspdata.userData.setBirthTime
		content.rspdata.userData.setBirthTime.msg = "MESSAGE_EXCLUSIVE_VIP_BIRTHDAY_SET_BACK"
		SoraDSendMessage(content.rspdata.userData.setBirthTime)
	elseif content.err == gErrDef.Err_ILLEGAL_PARAMS then
		SoraDCloseLoading()
		SoraDShowMsgTip(i18n("privilege_text_131"))
	end
end
function exaltedPrivilegeCtrl:reqPhoneNumRsp(content)
	dump(content, "exaltedPrivilegeCtrl:reqPhoneNumRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.clientData.userData.exaltedPhoneNum = content.rspdata.userData.exaltedPhoneNum
		self.clientData.userData.areatype = content.rspdata.userData.areatype
		self.clientData.userData.prefix = content.rspdata.userData.prefix
		self.clientData.userData.phoneTime = content.rspdata.userData.phoneTime
		local reward = content.rspdata.rewardInfo
		if reward and next(reward) then
			local panel = SoraDCreatePanel("bindPhoneRewardView")
			panel:initData(reward)
			panel:show()
		end
		_ENV = panel.show
		panel.show.msg = "MESSAGE_EXCLUSIVE_VIP_PHONE_SET_BACK"
		SoraDSendMessage(panel.show)
	end
end
function exaltedPrivilegeCtrl:reqCleanNewFlagRsp(content)
	if content.err == gErrDef.Err_None then
		self.clientData.userData.newFlag = content.rspdata.newFlag
		_ENV = content.rspdata.newFlag
		content.rspdata.newFlag.msg = "MESSAGE_EXCLUSIVE_VIP_CLEAN_NEW_FLAG"
		SoraDSendMessage(content.rspdata.newFlag)
	end
end
function exaltedPrivilegeCtrl:checkPrivilege(ptype)
	local exclusiveVipRead = include("exclusiveVipRead")
	local retVal, retList = exclusiveVipRead:getPrivilegeValue(ptype, self:getTotalScores())
	if retVal == 0 then
		return false
	else
		return retVal, retList
	end
end
function exaltedPrivilegeCtrl:getItemScore()
	local itemScore = 0
	if self.clientData and self.clientData.userData and self.clientData.userData.privilegeItemScore then
		itemScore = self.clientData.userData.privilegeItemScore
	end
	return itemScore
end
function exaltedPrivilegeCtrl:getLoginScore()
	local loginScore = 0
	if self.clientData and self.clientData.userData and self.clientData.userData.privilegeLoginScore then
		loginScore = self.clientData.userData.privilegeLoginScore
	end
	return loginScore
end
function exaltedPrivilegeCtrl:getRechargeScore()
	local rechargeScore = 0
	if self.clientData and self.clientData.userData and self.clientData.userData.privilegeRechargeScore then
		rechargeScore = self.clientData.userData.privilegeRechargeScore
	end
	return rechargeScore
end
function exaltedPrivilegeCtrl:getTotalScores()
	local totalScore = 0
	totalScore = self:getItemScore() + self:getLoginScore() + self:getRechargeScore()
	return totalScore
end
function exaltedPrivilegeCtrl:getTelephoneNum()
	local telephoneNum = 0
	local areatype, prefix
	if self.clientData and self.clientData.userData and self.clientData.userData.exaltedPhoneNum then
		telephoneNum = self.clientData.userData.exaltedPhoneNum
	end
	if self.clientData and self.clientData.userData and self.clientData.userData.areatype then
		areatype = self.clientData.userData.areatype
	end
	if self.clientData and self.clientData.userData and self.clientData.userData.prefix then
		prefix = self.clientData.userData.prefix
	end
	return telephoneNum, areatype, prefix
end
function exaltedPrivilegeCtrl:getPhoneTime()
	local phoneTime
	if self.clientData and self.clientData.userData and self.clientData.userData.phoneTime then
		phoneTime = self.clientData.userData.phoneTime
	end
	return phoneTime
end
function exaltedPrivilegeCtrl:getWeekRechargeGold()
	local weekRecharge = 0
	if self.clientData and self.clientData.userData and self.clientData.userData.weekRecharge then
		weekRecharge = self.clientData.userData.weekRecharge
	end
	return weekRecharge
end
function exaltedPrivilegeCtrl:getPackageBoughtNums(rechargeID)
	local nums = 0
	if self.clientData and self.clientData.userData and self.clientData.userData.buyGiftList[tostring(rechargeID)] then
		nums = self.clientData.userData.buyGiftList[tostring(rechargeID)]
	end
	return nums
end
function exaltedPrivilegeCtrl:getBirthdayInfo()
	if self.clientData and self.clientData.userData and self.clientData.userData.birthDate then
		return self.clientData.userData.birthDate
	end
end
function exaltedPrivilegeCtrl:hasBirthdayYearSet()
	if self.clientData and self.clientData.userData and self.clientData.userData.birthDate then
		return self.clientData.userData.birthDate.year
	end
end
function exaltedPrivilegeCtrl:checkExclusiveVip()
	local exclusiveVipRead = include("exclusiveVipRead")
	local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
	local totalScore = self:getTotalScores()
	local curPrivilegeList, curSore = exclusiveVipRead:getPrivilegeList(totalScore)
	local welfareInfo = self:getWelfareInfo()
	local totalRecharge = premiumStoreCtrl:getDollor()
	local historyInfo, nextHistoryInfo = exclusiveVipRead:getReachRechargeInfo(totalRecharge)
	local weekNeedHistoryRechargeGold = exclusiveVipRead:getweeklyHistoryRechargeNeedGold()
	local packageList, isPackageExit = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	local isHistoryReach = false
	local isWeekReach = false
	local ret = false
	if not historyInfo then
		if totalRecharge >= nextHistoryInfo.charge_amount then
			isHistoryReach = true
		end
	elseif totalRecharge >= historyInfo.charge_amount then
		isHistoryReach = true
	end
	if totalRecharge >= weekNeedHistoryRechargeGold then
		isWeekReach = true
	end
	if table.nums(curPrivilegeList) > 0 or table.nums(welfareInfo) > 0 or isPackageExit or isHistoryReach or isWeekReach then
		ret = true
	end
	return ret
end
function exaltedPrivilegeCtrl:getBirthdaySettingTime()
	if self.clientData and self.clientData.userData and self.clientData.userData.setBirthTime then
		return self.clientData.userData.setBirthTime
	end
end
function exaltedPrivilegeCtrl:getWelfareInfo()
	local _ENV, tempWelfare
	if self.welfareData then
		for i, v in ipairs(self.welfareData) do
			if v.endTime - serviceFunctions.systemTime() > 0 then
				table.insert(tempWelfare, v)
			end
		end
		if next(tempWelfare) then
			for i, v in ipairs(tempWelfare) do
				local isGot = self:isAlreadyGotWelfare(v.privilegeType, v.opencount)
				v.weight = isGot and 1 or 0
			end
		end
		table.sort(tempWelfare, function(a, b)
			if a.weight == b.weight then
				return a.endTime < b.endTime
			else
				return a.weight < b.weight
			end
		end)
	end
	return tempWelfare
end
function exaltedPrivilegeCtrl:isAlreadyGotWelfare(welfareType, openCount)
	local isGot = false
	if self.clientData and self.clientData.userData and self.clientData.userData.privilegeRewardData and self.clientData.userData.privilegeRewardData[tostring(welfareType)] and self.clientData.userData.privilegeRewardData[tostring(welfareType)][tostring(openCount)] then
		isGot = true
	end
	return isGot
end
function exaltedPrivilegeCtrl:isHavingNewFlagInAnyTab(switchType)
	local isNew = false
	if self.clientData and self.clientData.userData and self.clientData.userData.newFlag and self.clientData.userData.newFlag[tostring(switchType)] then
		isNew = self.clientData.userData.newFlag[tostring(switchType)]
	end
	return isNew
end
function exaltedPrivilegeCtrl:isNewFlagTotalJudge()
	local isNewTotal = false
	for i = gExaltedPrivilegeSwitchType.WELFARE, gExaltedPrivilegeSwitchType.PRIVILEGE do
		if self:isHavingNewFlagInAnyTab(i) then
			isNewTotal = self:isHavingNewFlagInAnyTab(i)
			break
		end
	end
	return isNewTotal
end
function exaltedPrivilegeCtrl:isGotSuperVIP()
	local curScore = self:getTotalScores()
	local exclusiveVipRead = include("exclusiveVipRead")
	local etValue, valueList = exclusiveVipRead:getPrivilegeValue(gExaltedPrivilegeType.HONOUR_PIIVILEGE, curScore)
	return valueList[tostring(gExaltedPrivilegeWelfareReward.EXALTED_CALL)] and true or false
end
return exaltedPrivilegeCtrl
