local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_EventQuestion = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_EventQuestion", Com_EventQuestion)
local LIST_CHOOSE_SIZEH = 122
local LIST_CHOOSE_EXTRA_SIZEH = 60
local BASIC_OPTIONS_NUM = 4
function Com_EventQuestion:onInit()
	self.fields.List_Choose:setItemRenderer(handler(self, self.itemRenderer_List_Choose))
	self.fields.List_Choose:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItemEnter))
	self.fields.button_Bet:setTitle(i18n("NebulaAllstar_213"))
	self.fields.button_Bet:addClickListener(handler(self, self.onClick_button_Bet))
	self.fields.button_CancelBet:setTitle(i18n("football_betting_text_08"))
	self.fields.button_CancelBet:addClickListener(handler(self, self.onClick_button_CancelBet))
	self.fields.Panel_touch:addClickListener(handler(self, self.onClick_btn_Add))
	self.fields.text_notselect:setString(i18n("football_betting_text_10"))
	self.fields.lab_RewardNum:setTitle(i18n("football_betting_text_12"))
	self.fields.lab_BetNum:setTitle(i18n("football_betting_text_11"))
	self.matchId = 9999
	self.title = 0
	self:fixChildrenPos()
end
function Com_EventQuestion:onShow()
end
function Com_EventQuestion:initData(data)
	self.title = data.title
	self.options = data.options
	self.curOption = 0
	local titleCfg = activity_9001734_Read.getBetTitleCfg(self.title)
	self.fields.Title1:setString(i18n(titleCfg.betTitle))
	self.OptionsRecord = activity_9001734_Ctrl:getOptionsRecord(self.matchId, self.title)
	if self.OptionsRecord then
		self.curOption = self.OptionsRecord.optionid
		local itemId = constantRead.getConstValue("FOOTBALL_BETTING_BETITEM", 882701)
		local itemIdReward = constantRead.getConstValue("FOOTBALL_BETTING_REWARDITEM", 882801)
		self.fields.lab_BetNum:setItemAndNum(itemId, self.OptionsRecord.num)
		local oddsid = activity_9001734_Read.getOptionOddsId(self.title, self.OptionsRecord.optionid)
		local oddsCfg = activity_9001734_Read.getOddsCfg(oddsid)
		self.fields.lab_RewardNum:setItemAndNum(itemIdReward, math.ceil(self.OptionsRecord.num * oddsCfg.odds))
	else
		local isTimeOut = activity_9001734_Ctrl:isMatchInTimeOut(self.matchId)
		if not isTimeOut then
			self.curOption = activity_9001734_Ctrl:getLocalPredictSelect(self.matchId, self.title)
		end
	end
	self:updateOptionsList()
	self:updateMatchTimeOut()
	self:updateBtnStatus()
end
function Com_EventQuestion:updateOptionsList()
	local isChampionSelect = self.title == 1
	self.controllers.c2:setSelectedIndex(isChampionSelect and 0 or 1)
	if isChampionSelect then
		self:updateChampionSelect()
	else
		self:updateChooseList()
	end
end
function Com_EventQuestion:updateChooseList()
	local ListH = LIST_CHOOSE_SIZEH
	if #self.options > BASIC_OPTIONS_NUM then
		ListH = math.ceil((#self.options - BASIC_OPTIONS_NUM) / 2) * LIST_CHOOSE_EXTRA_SIZEH + LIST_CHOOSE_SIZEH
	end
	self.fields.List_Choose:setNumItems(#self.options)
	local isTime = activity_9001734_Ctrl:isMatchInBetTime(self.matchId)
	self.fields.List_Choose:setEnabled(isTime and not self.OptionsRecord)
	self.fields.List_Choose:setHeight(ListH)
end
function Com_EventQuestion:updateChampionSelect()
	if self.curOption > 0 then
		local config = activity_9001734_Read.getCountryCfg(self.curOption)
		self.fields.icon:setIcon(config.flag)
	else
		self.fields.icon:setIcon("")
	end
	self:updateBtnStatus()
end
function Com_EventQuestion:onClickItemEnter()
	SoraDPlaySound()
	local index = self.fields.List_Choose:getSelectedIndex() + 1
	if index == 0 then
		return
	end
	local optionData = self.options[index]
	if self.curOption == optionData.optionid then
		self.curOption = 0
		self.fields.List_Choose:clearSelection()
	else
		self.curOption = optionData.optionid
	end
	activity_9001734_Ctrl:setLocalPredictSelect(self.matchId, self.title, self.curOption)
	self:updateBtnStatus()
end
function Com_EventQuestion:updateBtnStatus()
	if self.OptionsRecord and self.OptionsRecord.optionid > 0 then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(0 < self.curOption and 1 or 0)
	end
end
function Com_EventQuestion:updateMatchTimeOut()
	local nowTime = serviceFunctions.systemTime()
	local endTime = CONST_ARRAY.FOOTBALL_BETTING_PREBET_TIME[2]
	local isTimeOut = nowTime > endTime
	self.controllers.c3:setSelectedIndex(isTimeOut and 1 or 0)
	self.fields.text_timeout:setString(i18n("football_betting_text_13"))
	self.fields.Panel_touch:setEnabled(not isTimeOut)
end
function Com_EventQuestion:getMatchData()
	_UPVALUE0_ = nil
	;(nil).matchid = self.matchId
	;(nil).title = self.title
	return nil
end
function Com_EventQuestion:itemRenderer_List_Choose(index, obj)
	local optionData = self.options[index + 1]
	local oddsCfg = activity_9001734_Read.getOddsCfg(optionData.oddsid)
	local optionCfg = activity_9001734_Read.getOptionCfg(optionData.optionid)
	if optionCfg then
		obj:setString(i18n(optionCfg.optionText))
	end
	if oddsCfg then
		local oddsText = obj:getChild("odds")
		local oddsType = 0
		local odds = tonumber(oddsCfg.odds)
		if 2 <= odds and odds <= 4 then
			oddsType = 1
		elseif 4 < odds then
			oddsType = 2
		end
		obj:setOddsColorIndex(oddsType)
		oddsText:setString(odds)
	end
	local isSelect = false
	if self.curOption == optionData.optionid then
		isSelect = true
	end
	obj:setSelected(isSelect)
end
function Com_EventQuestion:onClick_button_Bet(context)
	SoraDPlaySound()
	local isTimeOut = not activity_9001734_Ctrl:isMatchInBetTime(self.matchId)
	if isTimeOut then
		_ENV = self.matchId
		self.matchId.msg = "MESSAGE_ACTIVITY_9001734_TIMEOUT"
		SoraDSendMessage(self.matchId)
		return
	end
	if self.curOption > 0 then
		_ENV = nil
		;(nil).callback = function(num)
			local isTimeOut = not activity_9001734_Ctrl:isMatchInBetTime(self.matchId)
			if isTimeOut then
				activity_9001734_Ctrl = self.matchId
				self.matchId.msg = "MESSAGE_ACTIVITY_9001734_TIMEOUT"
				SoraDSendMessage(self.matchId)
				return
			end
			activity_9001734_Ctrl:reqBetMsg(self.matchId, self.title, self.curOption, num)
		end
		uiManager:show("Activity_9001734_BetConfirm", nil)
	end
end
function Com_EventQuestion:onClick_button_CancelBet(context)
	SoraDPlaySound()
	local isTimeOut = not activity_9001734_Ctrl:isMatchInBetTime(self.matchId)
	if isTimeOut then
		_ENV = self.matchId
		self.matchId.msg = "MESSAGE_ACTIVITY_9001734_TIMEOUT"
		SoraDSendMessage(self.matchId)
		return
	end
	if self.OptionsRecord then
		activity_9001734_Ctrl:reqCancelBetMsg(self.matchId, self.title)
		self.curOption = activity_9001734_Ctrl:setLocalPredictSelect(self.matchId, self.title, 0)
	end
end
function Com_EventQuestion:onClick_btn_Add(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).callback = function(num)
		self.curOption = num
		activity_9001734_Ctrl:setLocalPredictSelect(self.matchId, self.title, self.curOption)
		self:updateChampionSelect()
		SoraDShowMsgTip(i18n("football_betting_text_05"))
	end
	;(nil).optionid = self.curOption
	uiManager:show("Activity_9001734_Champion", nil)
end
return Com_EventQuestion
