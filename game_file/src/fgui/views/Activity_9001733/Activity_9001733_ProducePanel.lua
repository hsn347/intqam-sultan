local activity_9001733_Read = include("activity_9001733_Read")
local activity_9001733_Ctrl = SoraDGetCtrl("activity_9001733_Ctrl")
local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001733_ProducePanel = class("Activity_9001733_ProducePanel", baseFguiPanel)
local getProduceItemID = function()
	local cost = activity_9001733_Read.getShootCost()
	return tonumber(cost and cost.id) or 0
end
local formatProduceTime = function(second)
	return SoraDConvertSecondToStringNoDayNoHour(math.max(0, tonumber(second) or 0))
end
local formatAccumulatedTime = function(second)
	return SoraDConvertSecondToStringNoDay(math.max(0, tonumber(second) or 0))
end
function Activity_9001733_ProducePanel:ctor(...)
	self.isLRU = true
	Activity_9001733_ProducePanel.super.ctor(self, ...)
	print("Activity_9001733_ProducePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
end
function Activity_9001733_ProducePanel:onInit()
	print("=======Activity_9001733_ProducePanel:onInit")
	self.fields.comItem:setTouchEnabled(false)
	self.fields.Panel_bg:setString(i18n("football_treasure_text_001"))
	self.fields.txtLv:setString(i18n("football_treasure_text_009"))
	self.fields.txtSpeed:setString(i18n("football_treasure_text_010"))
	self.fields.txtEffeciency:setString(i18n("football_treasure_text_011"))
	self.fields.txtTime:setString(i18n("football_treasure_text_012"))
	self.fields.txtCanReceiveNum:setString(i18n("football_treasure_text_013"))
	self.fields.btnReceive:addClickListener(handler(self, self.onClick_btnReceive))
	self.fields.Button_add:addClickListener(handler(self, self.onClick_Button_add))
	self.fields.comItem:fixPos()
	self.fields.Panel_bg:fixPos()
	self.fields.txtLv:fixPos()
	self.fields.txtSpeed:fixPos()
	self.fields.txtEffeciency:fixPos()
	self.fields.txtTime:fixPos()
	self.fields.txtCanReceiveNum:fixPos()
	self.fields.btnReceive:fixPos()
	self.fields.Button_add:fixPos()
end
function Activity_9001733_ProducePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("football_treasure_text_004")
	uiManager:show("RuleView", nil)
end
function Activity_9001733_ProducePanel:endShow()
	print("=======Activity_9001733_ProducePanel:endShow")
	self.snapshotSettleNum = activity_9001733_Ctrl:getCurrentSettleNum()
	self:updateView()
	self:startProduceTimer()
end
function Activity_9001733_ProducePanel:updateView()
	local factoryLv = activity_9001733_Ctrl:getFactoryLv()
	local actualEff = activity_9001733_Ctrl:getFactoryActualEfficiency(factoryLv)
	local isAdvanceUnlock = activity_9001733_Ctrl:getIsAdvanceRewardUnlock()
	local speedRate = math.floor((1 + activity_9001733_Ctrl:getBattlePassBuff()) * 100)
	local canReceiveNum = tonumber(self.snapshotSettleNum) or 0
	self.fields.comItem:initData(getProduceItemID())
	activity_9001733_Ctrl = getProduceItemID()
	getProduceItemID().time = string.formatnumberthousands(canReceiveNum)
	self.fields.txtCanReceiveNum:setString(i18n("football_treasure_text_013", getProduceItemID()))
	self.fields.txtLv:setString(i18n("football_treasure_text_009") .. " " .. tostring(factoryLv))
	self.fields.txtSpeed:setString(i18n("football_treasure_text_010") .. " " .. formatProduceTime(actualEff))
	self.fields.txtEffeciency:setString(i18n("football_treasure_text_011") .. " " .. speedRate .. "%")
	self.fields.txtEffeciency:setColor(isAdvanceUnlock and display.COLOR_GREEN or display.COLOR_WHITE)
	self.fields.txtTip:setString(i18n("football_treasure_text_015"))
	self.fields.txtTip:setVisible(not isAdvanceUnlock)
	self.fields.Button_add:setVisible(not isAdvanceUnlock)
	self.fields.Button_add:setEnabled(not isAdvanceUnlock)
	self:refreshProduceProgress()
	self.fields.btnReceive:setTitle(i18n("football_treasure_text_014"))
	self.fields.btnReceive:setEnabled(0 < canReceiveNum)
	self.fields.btnReceive:setReddot(false, 0)
end
function Activity_9001733_ProducePanel:refreshClaimFootballState()
	self.snapshotSettleNum = activity_9001733_Ctrl:getCurrentSettleNum()
	self:updateView()
end
function Activity_9001733_ProducePanel:refreshProduceProgress()
	local maxMakeTime = math.max(activity_9001733_Read.getMaxMakeTime(), 1)
	local currentMakeTime = math.min(activity_9001733_Ctrl:getCurrentMakeTime(), maxMakeTime)
	_ENV = nil
	;(nil).member = formatAccumulatedTime(currentMakeTime)
	;(nil).total = formatAccumulatedTime(maxMakeTime)
	local progressTitle = i18n("common_text_155", nil)
	self.fields.txtTime:setString(i18n("football_treasure_text_012"))
	self.fields.bar:setMax(maxMakeTime)
	self.fields.bar:setValue(currentMakeTime)
	self.fields.bar:getChild("title"):setString(progressTitle)
end
function Activity_9001733_ProducePanel:startProduceTimer()
	if self.timeHandle then
		return
	end
	self.timeHandle = schedulerTime.scheduleGlobal(function()
		self:refreshProduceProgress()
	end, 1.0)
end
function Activity_9001733_ProducePanel:stopProduceTimer()
	if not self.timeHandle then
		return
	end
	schedulerTime.unscheduleGlobal(self.timeHandle)
	self.timeHandle = nil
end
function Activity_9001733_ProducePanel:onClaimFootball()
	self:refreshClaimFootballState()
end
function Activity_9001733_ProducePanel:onHide()
	self:stopProduceTimer()
	SoraDCloseLoading(self)
end
function Activity_9001733_ProducePanel:onClick_btnReceive(context)
	SoraDPlaySound()
	if (tonumber(self.snapshotSettleNum) or 0) <= 0 then
		return
	end
	activity_9001733_Ctrl:reqClaimFootballMsg()
end
function Activity_9001733_ProducePanel:onClick_Button_add(context)
	SoraDPlaySound()
	if activity_9001733_Ctrl:getIsAdvanceRewardUnlock() then
		return
	end
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("CommonBuyGift", nil)
end
return Activity_9001733_ProducePanel
