local gametop = gModuleMgr.getObject("gametop")
local allianceEscortCtrl = SoraDGetCtrl("allianceEscortCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EscortMainPanel = class("EscortMainPanel", baseFguiPanel)
function EscortMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EscortMainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ALLIANCE_ESCORT_ACTIVITY
	self.selfUid = gametop.playertop_:getPlayerID()
end
function EscortMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EscortMainPanel:onInit()
	print("=======EscortMainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001413"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initActivityTimeStyle(self.activityID)
	self.fields.Button_record:setString(i18n("treasureEscort_text12"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	self.fields.Button_map:setString(i18n("treasureEscort_text55"))
	self.fields.Button_map:addClickListener(handler(self, self.onClickBtnMap))
	self.fields.Button_detail:addClickListener(handler(self, self.onClickBtnDetail))
	self.fields.Button_detail:fixPos()
	self.fields.Text_reward:setString(i18n("treasureEscort_text23"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	if not allianceEscortCtrl:getEscortReward(allianceEscortCtrl:getDifficultyCount(), 1) then
		_ENV = allianceEscortCtrl:getEscortReward(allianceEscortCtrl:getDifficultyCount(), 1)
	end
	self.reward = allianceEscortCtrl:getEscortReward(allianceEscortCtrl:getDifficultyCount(), 1)
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setNumItems(#self.reward)
end
function EscortMainPanel:onShow()
	print("=======EscortMainPanel:onShow")
	self:refreshView()
end
function EscortMainPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("treasureEscort_text01")
	uiManager:show("RuleView", nil)
end
function EscortMainPanel:onClickBtnRecord()
	SoraDPlaySound()
	_ENV = nil
	;(nil).viewType = 1
	uiManager:show("Escortrecord", nil)
	self.fields.Button_record:setRedVisible(false)
	_ENV = self.fields.Button_record
	self.fields.Button_record.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.fields.Button_record.eventID = self.activityID
	SoraDSendMessage(self.fields.Button_record)
end
function EscortMainPanel:onClickBtnMap()
	SoraDPlaySound()
	uiManager:show("EscortMapUI")
end
function EscortMainPanel:onClickBtnDetail()
	SoraDPlaySound()
	uiManager:show("Escortreward")
end
function EscortMainPanel:onClickBtnGo()
	SoraDPlaySound()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	end
	local state = self.escortData.state
	if state == gAllianceEscortState.PREPARE then
		uiManager:show("EscortSignUp")
	elseif state == gAllianceEscortState.ESCORT then
		uiManager:show("EscortMapUI")
	else
		local allianceDesRead = include("allianceDesRead")
		if not allianceDesRead.checkRank(gAllianceRank.R4, true, i18n("treasureEscort_text02")) then
			return
		end
		if self.leftCount < 1 then
			SoraDShowMsgTip(i18n("treasureEscort_text51"))
			return
		end
		if not allianceEscortCtrl:checkOpenTime() then
			return
		end
		uiManager:show("EscortDifficultyChoose")
	end
end
function EscortMainPanel:onRewardItemRenderer(index, obj)
	local data = self.reward[index + 1]
	obj:initData(data.id, data.count)
end
function EscortMainPanel:refreshView(...)
	self.escortData = allianceEscortCtrl:getEscortData()
	self:refreshEscortCount()
	self.fields.Text_time:setVisible(false)
	self.fields.Button_go:setReddot(false)
	local state = self.escortData.state
	if state == gAllianceEscortState.PREPARE then
		if self.escortData.signUpUserList[tostring(self.selfUid)] then
			self.fields.Button_go:setString(i18n("treasureEscort_text05"))
		else
			self.fields.Button_go:setString(i18n("treasureEscort_text03"))
			self.fields.Button_go:setReddot(true)
		end
		local stateStartTime = self.escortData.stateStartTime
		local constantRead = include("constantRead")
		local time = constantRead.getConstValue("TreasureEscort_Prepare_Time", 0)
		local leftTime = math.max(0, stateStartTime + time - serviceFunctions.systemTime())
		local signUpCount = table.nums(self.escortData.signUpUserList)
		self.fields.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			;(nil).num = signUpCount
			return i18n("treasureEscort_text04", nil)
		end)
		self.fields.Text_time:setVisible(true)
		self.fields.Text_time:beginTime(leftTime)
	elseif state == gAllianceEscortState.ESCORT then
		self.fields.Button_go:setString(i18n("treasureEscort_text06"))
	else
		self.fields.Button_go:setString(i18n("treasureEscort_text07"))
		self.fields.Button_record:setRedVisible(allianceEscortCtrl:checkEscortRecordRed())
		self:refreshBtnGoReddot()
	end
end
function EscortMainPanel:refreshEscortCount(...)
	local count = allianceEscortCtrl:getEscortTimes()
	local countColor = 0 < count and "#FFFFFF" or "#FF2E00"
	allianceEscortCtrl = nil
	allianceEscortCtrl, allianceEscortCtrl, (nil).count = nil, nil, count
	;(nil).count, (nil).color = nil, countColor
	self.fields.Text_count:setString(i18n_html("common_text_1673", nil, nil))
	self.leftCount = count
end
function EscortMainPanel:refreshBtnGoReddot(...)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local allianceDesRead = include("allianceDesRead")
	if allianceMgr:hasJoinAlliance() and allianceDesRead.checkRank(gAllianceRank.R4) and self.leftCount > 0 then
		self.fields.Button_go:setReddot(true)
	end
end
function EscortMainPanel:newDay(...)
	self:refreshEscortCount()
	self:refreshBtnGoReddot()
end
return EscortMainPanel
