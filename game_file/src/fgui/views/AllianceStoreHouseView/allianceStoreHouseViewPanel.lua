local allianceTreasureCtrl = SoraDGetCtrl("allianceTreasureCtrl")
local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceStoreHouseViewPanel = class("allianceStoreHouseViewPanel", baseFguiPanel)
function allianceStoreHouseViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceStoreHouseViewPanel:ctor", self.viewName)
end
function allianceStoreHouseViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceStoreHouseViewPanel:onInit()
	print("=======allianceStoreHouseViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.tag = 1
	self.tableSingle, _ENV, self.isInit = print, print, true
	self.fields.Com_title:initData(i18n("allitreas_title_01"), handler(self, self.onClickClose), handler(self, self.onBtnFAQClick))
	self.fields.Text_mineTips:setString(i18n("allitreas_text_13"))
	self.fields.Text_join1hour:setVisible(false)
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setVisible(false)
	self.fields.Text_autoFreshTime = SoraDCreateTimerLabel(self, self.fields.Text_autoFreshTime)
	self.fields.Text_autoFreshTime:setTimeUpdateListener(function(time)
		if time <= 0 then
			self.fields.Text_autoFreshTime:setVisible(false)
		else
			self = nil
			;(nil).time = SoraDConvertSecondToString(time)
			self.fields.Text_autoFreshTime:setString(i18n("allitreas_text_12", nil))
		end
	end)
	self.fields.Text_chance = SoraDCreateTimerLabel(self, self.fields.Text_chance)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_record:setString(i18n("common_text_836"))
	self.fields.Button_record:addClickListener(handler(self, self.btnRecordClick))
	self.fields.Button_fresh:setString(i18n("allitreas_btn_06"))
	self.fields.Button_freshGold:setString(i18n("allitreas_btn_06"))
	self.fields.Button_fresh:addClickListener(handler(self, self.onBtnRefreshClick))
	self.fields.Button_freshGold:addClickListener(handler(self, self.onBtnRefreshClick))
	self.fields.Button_find:addClickListener(handler(self, self.onBtnFindClick))
end
function allianceStoreHouseViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableSingle[index + 1])
end
function allianceStoreHouseViewPanel:onShow()
	print("=======allianceStoreHouseViewPanel:onShow")
	SoraDPlaySound("uicontrol", 51)
	self.fields.Com_bg:setGradientColor()
	self.tag = self.param and self.param.tag or 1
	_ENV = 51
	_ENV, _ENV, (51).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("allitreas_btn_01")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("allitreas_btn_02")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("allitreas_btn_03")
	;(51).tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	;(51).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(51)
	self:refreshGreenPoint()
end
function allianceStoreHouseViewPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		if self.isInit then
			SoraDShowLoading(self)
			allianceTreasureCtrl:reqInitData()
			self.isInit = false
		else
			self:showTreasureListView()
		end
	elseif self.tag == 2 then
		self:showMyTreasureView()
	elseif self.tag == 3 then
		self:showHelpListView()
	end
end
function allianceStoreHouseViewPanel:showTreasureListView(target)
	SoraDCloseLoading(self)
	if self.tag ~= 1 then
		return
	end
	self.tableSingle, _ENV = self.tag, self.tag
	self.fields.Button_find:setVisible(false)
	self.fields.Com_none:setVisible(false)
	local left1hourTime = allianceTreasureCtrl:getJoin1hourTime()
	if 0 < left1hourTime then
		self.fields.Text_join1hour:setVisible(true)
		self.fields.Text_join1hour:setString(i18n("allitreas_text_23"))
		self.fields.Text_time:setVisible(true)
		self.fields.Text_time:beginTime(left1hourTime)
		self.fields.Text_autoFreshTime:setVisible(false)
		self.fields.Button_fresh:setVisible(false)
		self.fields.Button_freshGold:setVisible(false)
		self.fields.Text_tips:setVisible(false)
		self.fields.Text_chance:setVisible(false)
	else
		self.fields.Text_join1hour:setVisible(false)
		self.fields.Text_time:setVisible(false)
		local nextAutoTime = allianceTreasureCtrl:getNextAutoRefreshTime()
		if 0 < nextAutoTime then
			self.fields.Text_autoFreshTime:setVisible(true)
			self.fields.Text_autoFreshTime:beginTime(nextAutoTime)
		else
			self.fields.Text_autoFreshTime:setVisible(false)
		end
		self.fields.Text_chance:setVisible(true)
		local chance = allianceTreasureCtrl:getLeftChance()
		local refreshGold = allianceTreasureCtrl:getRefreshCostGold()
		if 0 < chance then
			if 0 < refreshGold then
				self.fields.Button_fresh:setVisible(false)
				self.fields.Button_freshGold:setVisible(true)
				self.fields.Button_freshGold:setCostTitle(refreshGold)
			else
				self.fields.Button_fresh:setVisible(true)
				self.fields.Button_freshGold:setVisible(false)
			end
			local isDigging = allianceTreasureCtrl:isDigging()
			if isDigging then
				local leftTime = allianceTreasureCtrl:getNextFreeTime()
				if 0 < leftTime then
					self.fields.Text_chance:setTimeUpdateListener(function(time)
						if time <= 0 then
							self = nil
							;(nil).num = chance
							self.fields.Text_chance:setString(i18n("allitreas_text_08", nil) .. fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09")))
						else
							self = "#C89B64"
							;("#C89B64").num = chance
							self = i18n("allitreas_text_09")
							i18n("allitreas_text_09").time = SoraDConvertSecondToString(time)
							self.fields.Text_chance:setString(i18n("allitreas_text_08", "#C89B64") .. fguiHelper.getColorString("#C89B64", i18n("allitreas_text_10", i18n("allitreas_text_09"))))
						end
					end)
					self.fields.Text_chance:beginTime(leftTime)
				else
					self.fields.Text_chance:endTime()
					_ENV = i18n("allitreas_text_23")
					i18n("allitreas_text_23").num = chance
					self.fields.Text_chance:setString(i18n("allitreas_text_08", i18n("allitreas_text_23")) .. fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09")))
				end
			else
				self.fields.Text_chance:endTime()
				_ENV = fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09"))
				fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09")).num = chance
				self.fields.Text_chance:setString(i18n("allitreas_text_08", (fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09")))) .. fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09")))
			end
		else
			self.fields.Button_fresh:setEnabled(false)
			self.fields.Button_fresh:setVisible(true)
			self.fields.Button_freshGold:setVisible(false)
			self.fields.Text_chance:endTime()
			_ENV = fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09"))
			fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09")).num = chance
			self.fields.Text_chance:setString(i18n("allitreas_text_08", (fguiHelper.getColorString("#C89B64", i18n("allitreas_text_09")))))
		end
		self.fields.Text_tips:setString(i18n("allitreas_text_11"))
		self.fields.Text_tips:setVisible(true)
		local btnStatus, digGold = allianceTreasureCtrl:getDigBtnStatus()
		local treasureList = allianceTreasureCtrl:getTreasureList()
		if table.nums(treasureList) > 0 then
			_ENV = table.nums(treasureList)
			_ENV = i18n("allitreas_text_11")
			i18n("allitreas_text_11").text = i18n("allitreas_btn_04")
			i18n("allitreas_text_11").showStyle = 1
			table.nums(treasureList)[gTreasureBtnStatus.FREE], i18n("allitreas_text_11").handle = i18n("allitreas_text_11")
			_ENV = i18n("allitreas_text_11")
			i18n("allitreas_text_11").text = i18n("allitreas_btn_05")
			i18n("allitreas_text_11").showStyle = 2
			i18n("allitreas_text_11").gold = digGold
			table.nums(treasureList)[gTreasureBtnStatus.COST_GOLD], i18n("allitreas_text_11").handle = i18n("allitreas_text_11")
			_ENV = i18n("allitreas_text_11")
			i18n("allitreas_text_11").text = i18n("allitreas_btn_05")
			table.nums(treasureList)[gTreasureBtnStatus.UNDIG], i18n("allitreas_text_11").showStyle = i18n("allitreas_text_11")
			local btnVarConfig = table.nums(treasureList)
			for k, v in ipairs(treasureList) do
				_ENV = i18n("allitreas_text_11")
				i18n("allitreas_text_11").data = v
				i18n("allitreas_text_11").tipText = v.openTime
				i18n("allitreas_text_11").btnStyle = btnVarConfig[btnStatus].showStyle
				i18n("allitreas_text_11").text = btnVarConfig[btnStatus].text
				i18n("allitreas_text_11").gold = btnVarConfig[btnStatus].gold
				local i18n("allitreas_text_11").handle, data = btnVarConfig[btnStatus].handle, i18n("allitreas_text_11")
				_ENV = i18n("allitreas_text_11")
				i18n("allitreas_text_11").style = 1
				self.tableSingle[k], i18n("allitreas_text_11").data = i18n("allitreas_text_11")
			end
		else
			self.fields.Com_none:setVisible(true)
			self.fields.Com_none:setString(i18n("allitreas_text_27"))
		end
	end
	self.fields.List:setNumItems(#self.tableSingle)
	if not target then
		self.fields.List:jumpToTop()
	end
end
function allianceStoreHouseViewPanel:showMyTreasureView(target)
	SoraDCloseLoading(self)
	if self.tag ~= 2 then
		return
	end
	self.tableSingle, _ENV = self.tag, self.tag
	self.fields.Button_find:setVisible(false)
	self.fields.Com_none:setVisible(false)
	local left1hourTime = allianceTreasureCtrl:getJoin1hourTime()
	if 0 < left1hourTime then
		self.fields.Text_join1hour:setVisible(true)
		self.fields.Text_join1hour:setString(i18n("allitreas_text_23"))
		self.fields.Text_time:setVisible(false)
		self.fields.Text_mineTips:setVisible(false)
	else
		self.fields.Text_mineTips:setVisible(true)
		local digList = allianceTreasureCtrl:getDigList()
		if 0 < table.nums(digList) then
			_ENV = table.nums(digList)
			_ENV = i18n("allitreas_text_23")
			i18n("allitreas_text_23").text = i18n("allitreas_btn_07")
			i18n("allitreas_text_23").showStyle = 1
			table.nums(digList)[gTreasureDigStatus.CALL_HELP], i18n("allitreas_text_23").handle = i18n("allitreas_text_23")
			_ENV = i18n("allitreas_text_23")
			i18n("allitreas_text_23").text = i18n("allitreas_btn_07")
			table.nums(digList)[gTreasureDigStatus.CALLED_HELP], i18n("allitreas_text_23").showStyle = i18n("allitreas_text_23")
			_ENV = i18n("allitreas_text_23")
			i18n("allitreas_text_23").text = i18n("allitreas_btn_07")
			table.nums(digList)[gTreasureDigStatus.BE_HELPED], i18n("allitreas_text_23").showStyle = i18n("allitreas_text_23")
			_ENV = i18n("allitreas_text_23")
			i18n("allitreas_text_23").text = i18n("common_text_854")
			i18n("allitreas_text_23").showStyle = 1
			i18n("allitreas_text_23").isReward = true
			table.nums(digList)[gTreasureDigStatus.REWARD], i18n("allitreas_text_23").handle = i18n("allitreas_text_23")
			local btnVarConfig = table.nums(digList)
			for k, v in ipairs(digList) do
				local btnStatus, time = allianceTreasureCtrl:getDigedBtnStatus(v.index)
				_ENV = v.index
				v.index.data = v
				v.index.tipText = v.openTime
				v.index.btnStyle = btnVarConfig[btnStatus].showStyle
				v.index.text = btnVarConfig[btnStatus].text
				v.index.gold = 0
				v.index.isReward = btnVarConfig[btnStatus].isReward
				v.index.handle = btnVarConfig[btnStatus].handle
				v.index.status = btnStatus
				v.index.time = time
				local v.index.assistNickName, data = v.assistNickName, v.index
				_ENV = i18n("allitreas_text_23")
				i18n("allitreas_text_23").style = 2
				self.tableSingle[k], i18n("allitreas_text_23").data = i18n("allitreas_text_23")
			end
		else
			self.fields.Com_none:setVisible(true)
			self.fields.Com_none:setString(i18n("allitreas_text_25"))
			self.fields.Button_find:setVisible(true)
			self.fields.Button_find:setString(i18n("allitreas_btn_08"))
		end
	end
	self.fields.List:setNumItems(#self.tableSingle)
	if not target then
		self.fields.List:jumpToTop()
	end
end
function allianceStoreHouseViewPanel:showHelpListView(target)
	SoraDCloseLoading(self)
	if self.tag ~= 3 then
		return
	end
	self.tableSingle, _ENV = self.tag, self.tag
	self.fields.Com_none:setVisible(false)
	self.fields.Button_find:setVisible(false)
	local left1hourTime = allianceTreasureCtrl:getJoin1hourTime()
	if 0 < left1hourTime then
		self.fields.Text_join1hour:setVisible(true)
		self.fields.Text_join1hour:setString(i18n("allitreas_text_22"))
		self.fields.Text_time:setVisible(false)
		self.fields.Text_tips:setVisible(false)
		self.fields.Text_chance:setVisible(false)
	else
		self.fields.Text_tips:setString(i18n("allitreas_text_31"))
		self.fields.Text_tips:setVisible(true)
		local helpCount = allianceTreasureCtrl:getHelpCount()
		self.fields.Text_chance:setVisible(true)
		self.fields.Text_chance:endTime()
		_ENV = i18n("allitreas_text_31")
		i18n("allitreas_text_31").num = helpCount
		self.fields.Text_chance:setString(i18n("allitreas_text_18", i18n("allitreas_text_31")))
		local helpList = allianceTreasureCtrl:getHelpList()
		if 0 < table.nums(helpList) then
			_ENV = table.nums(helpList)
			_ENV = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			i18n("allitreas_text_18", i18n("allitreas_text_31")).text = i18n("common_text_854")
			i18n("allitreas_text_18", i18n("allitreas_text_31")).showStyle = 1
			i18n("allitreas_text_18", i18n("allitreas_text_31")).isReward = true
			table.nums(helpList)[gTreasureHelpStatus.REWARD], i18n("allitreas_text_18", i18n("allitreas_text_31")).handle = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			_ENV = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			i18n("allitreas_text_18", i18n("allitreas_text_31")).text = i18n("common_text_037")
			i18n("allitreas_text_18", i18n("allitreas_text_31")).showStyle = 1
			table.nums(helpList)[gTreasureHelpStatus.CAN_HELP], i18n("allitreas_text_18", i18n("allitreas_text_31")).handle = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			_ENV = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			i18n("allitreas_text_18", i18n("allitreas_text_31")).text = i18n("common_text_037")
			table.nums(helpList)[gTreasureHelpStatus.CANNOT_HELP], i18n("allitreas_text_18", i18n("allitreas_text_31")).showStyle = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			_ENV = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			i18n("allitreas_text_18", i18n("allitreas_text_31")).text = i18n("common_text_018")
			i18n("allitreas_text_18", i18n("allitreas_text_31")).showStyle = 2
			i18n("allitreas_text_18", i18n("allitreas_text_31")).isReward = true
			table.nums(helpList)[gTreasureHelpStatus.HELPED], i18n("allitreas_text_18", i18n("allitreas_text_31")).handle = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			local btnVarConfig = table.nums(helpList)
			for k, v in ipairs(helpList) do
				local btnStatus, gold, openLeftTime, openTime = allianceTreasureCtrl:getHelpDigStatus(v.ownUid, v.index)
				local configData = btnVarConfig[btnStatus]
				_ENV = i18n("allitreas_text_18", i18n("allitreas_text_31"))
				i18n("allitreas_text_18", i18n("allitreas_text_31")).curTime = openLeftTime
				local i18n("allitreas_text_18", i18n("allitreas_text_31")).totalTime, timeData = openTime, i18n("allitreas_text_18", i18n("allitreas_text_31"))
				local time = v.openTime
				if btnStatus == gTreasureHelpStatus.HELPED then
					time = openLeftTime
				end
				_ENV = gTreasureHelpStatus.HELPED
				gTreasureHelpStatus.HELPED.data = v
				gTreasureHelpStatus.HELPED.btnStyle = configData.showStyle
				gTreasureHelpStatus.HELPED.text = configData.text
				gTreasureHelpStatus.HELPED.gold = gold
				gTreasureHelpStatus.HELPED.isReward = configData.isReward
				gTreasureHelpStatus.HELPED.timeData = timeData
				gTreasureHelpStatus.HELPED.ownUid = v.ownUid
				gTreasureHelpStatus.HELPED.avatar = v.avatar
				gTreasureHelpStatus.HELPED.headID = v.iconID
				gTreasureHelpStatus.HELPED.name = v.nickName
				gTreasureHelpStatus.HELPED.handle = btnVarConfig[btnStatus].handle
				gTreasureHelpStatus.HELPED.status = btnStatus
				local gTreasureHelpStatus.HELPED.time, data = time, gTreasureHelpStatus.HELPED
				_ENV = i18n("allitreas_text_18", i18n("allitreas_text_31"))
				i18n("allitreas_text_18", i18n("allitreas_text_31")).style = 3
				self.tableSingle[k], i18n("allitreas_text_18", i18n("allitreas_text_31")).data = i18n("allitreas_text_18", i18n("allitreas_text_31"))
			end
		else
			self.fields.Com_none:setVisible(true)
			self.fields.Com_none:setString(i18n("allitreas_text_26"))
			self.fields.Button_find:setVisible(true)
			self.fields.Button_find:setString(i18n("allitreas_btn_08"))
		end
	end
	self.fields.List:setNumItems(#self.tableSingle)
	if not target then
		self.fields.List:jumpToTop()
	end
end
function allianceStoreHouseViewPanel:refreshGreenPoint(target, data)
	local mineNum = allianceTreasureCtrl:getDigRewardCount()
	local helpNum = allianceTreasureCtrl:getHelpRewardCount()
	self.fields.Com_tab:setBtnRedDot(2, 0 < mineNum, mineNum)
	self.fields.Com_tab:setBtnRedDot(3, 0 < helpNum, helpNum)
end
function allianceStoreHouseViewPanel:onBtnDigClick(data)
	local index = data.data.index
	local num = allianceTreasureCtrl:getDigRewardCount()
	if num >= ALLIANCE_TREASURE_AWARD_MAX_COUNT then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_01"))
	else
		local btnStatus, digGold = allianceTreasureCtrl:getDigBtnStatus()
		if 0 < digGold then
			if SoraDEnoughGold(digGold) then
				allianceTreasureCtrl = i18n("alliance_treasure_tip_01")
				i18n("alliance_treasure_tip_01").num = digGold
				SoraDShowMsgBox(i18n("allitreas_text_30", i18n("alliance_treasure_tip_01")), i18n("common_text_204"), nil, function(event)
					if event == MSGBOX_CALLBACK_YES then
						SoraDShowLoading(self)
						allianceTreasureCtrl:reqDig(index)
					end
				end)
			end
		else
			SoraDShowLoading(self)
			allianceTreasureCtrl:reqDig(index)
		end
	end
end
function allianceStoreHouseViewPanel:onBtnRefreshClick()
	SoraDPlaySound()
	local refreshGold = allianceTreasureCtrl:getRefreshCostGold()
	if SoraDEnoughGold(refreshGold) then
		if refreshGold == ALLIANCE_TREASURE_GOLD_REFRESH then
			_ENV = nil
			;(nil).num = refreshGold
			SoraDShowMsgBox(i18n("allitreas_text_29", nil), i18n("common_text_204"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					allianceTreasureCtrl:reqReFresh()
				end
			end)
		else
			SoraDShowLoading(self)
			allianceTreasureCtrl:reqReFresh()
		end
	end
end
function allianceStoreHouseViewPanel:btnRecordClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).recordType = self.tag == 3 and 2 or 1
	uiManager:show("allianceStoreHouseRecordView", nil)
end
function allianceStoreHouseViewPanel:onBtnFindClick()
	SoraDPlaySound()
	self.fields.Com_tab:setDefaultClick(1, 1)
end
function allianceStoreHouseViewPanel:onBtnCallHelpClick(data)
	SoraDShowLoading(self)
	local index = data.data.index
	allianceTreasureCtrl:reqCallHelp(index)
end
function allianceStoreHouseViewPanel:onBtnReceiveClick(data)
	SoraDShowLoading(self)
	local receiveType = 1
	if self.tag == 3 then
		receiveType = 2
	end
	allianceTreasureCtrl:reqReceive(receiveType, data.data.ownUid, data.data.index)
end
function allianceStoreHouseViewPanel:onBtnHelpOtherClick(data)
	local num = allianceTreasureCtrl:getHelpRewardCount()
	if num >= ALLIANCE_TREASURE_AWARD_MAX_COUNT then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_02"))
	else
		SoraDShowLoading(self)
		allianceTreasureCtrl:reqHelpAlies(data.data.ownUid, data.data.index)
	end
end
function allianceStoreHouseViewPanel:onBtnHelpOtherByGoldClick(data)
	local num = allianceTreasureCtrl:getHelpRewardCount()
	if num >= ALLIANCE_TREASURE_AWARD_MAX_COUNT then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_02"))
	else
		local btnStatus, gold, openLeftTime, openTime = allianceTreasureCtrl:getHelpDigStatus(data.data.ownUid, data.data.index)
		local realGold = math.ceil(gold * openLeftTime / openTime)
		if SoraDEnoughGold(realGold) then
			allianceTreasureCtrl = i18n("alliance_treasure_tip_02")
			i18n("alliance_treasure_tip_02").num = realGold
			local panel = SoraDShowMsgBox(i18n("allitreas_text_28", i18n("alliance_treasure_tip_02")), i18n("common_text_204"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					allianceTreasureCtrl:reqHelpAliesByGold(data.data.ownUid, data.data.index)
				end
			end)
			_ENV = nil
			;(nil).num = realGold
			allianceTreasureCtrl, (nil)[1] = "allitreas_text_28", "allitreas_text_28"
			;("allitreas_text_28").gold = gold
			;("allitreas_text_28").curTime = openLeftTime
			;("allitreas_text_28").totalTime = openTime
			panel:setTimerText(nil, "allitreas_text_28")
		end
	end
end
function allianceStoreHouseViewPanel:onBtnFAQClick()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ALLIANCE_TREASURE)
end
return allianceStoreHouseViewPanel
