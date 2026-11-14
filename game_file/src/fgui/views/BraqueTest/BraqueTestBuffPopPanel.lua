local warOrderRead = include("warOrderRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BraqueTestBuffPopPanel = class("BraqueTestBuffPopPanel", baseFguiPanel)
function BraqueTestBuffPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BraqueTestBuffPopPanel:ctor", self.viewName)
end
_UPVALUE4_, BraqueTestBuffPopPanel.getPackageList = function(self)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExtremelySkillful"
	end
	return self._packageList
end, function(self)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExtremelySkillful"
	end
	return self._packageList
end
;(function(self)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExtremelySkillful"
	end
	return self._packageList
end)[1] = "Battle_Towers_10"
;(function(self)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExtremelySkillful"
	end
	return self._packageList
end)[2] = "Battle_Towers_10"
;(function(self)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExtremelySkillful"
	end
	return self._packageList
end)[3] = "Braque_text_25"
local (function(self)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExtremelySkillful"
	end
	return self._packageList
end)[4], tipsConfig = "Braque_text_26", function(self)
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ExtremelySkillful"
	end
	return self._packageList
end
function BraqueTestBuffPopPanel:onInit()
	print("=======BraqueTestBuffPopPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	self.curCtrl = warOrderCtrl:getCurCtrl(self.activityID)
	local activityName = i18n(activityTimeRead.getActivityNameByID(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)))
	self.fields.panel_normal:setTitle(activityName)
	self.fields.Button_Go:addClickListener(handler(self, self.onClickGo))
	self.fields.Button_Go:setString(i18n("common_text_477"))
	self.fields.Text_Tips = SoraDCreateTimerLabel(self, self.fields.Text_Tips)
	self.fields.Text_Tips:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		return i18n("Braque_text_09", nil)
	end)
	self.fields.Text_Tips:setTimeEndListener(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Text_Tips:beginTime(leftTime)
	end
	self.fields.BuffList:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.Button_Ques:addClickListener(handler(self, self.onClickQuestion))
	self.buffBuildType = self.proxy.param.buffBuildType
	local isMax, lv = self.curCtrl:isMaxLvByType(self.activityID, self.buffBuildType)
	if isMax then
		self.fields.Text_Tips:endTimeNoCauseEndCallBack()
		_ENV = handler(self, self.onClickQuestion)
		handler(self, self.onClickQuestion).lv = lv
		self.fields.Text_Tips:setString(i18n(tipsConfig[self.buffBuildType], handler(self, self.onClickQuestion)))
	end
end
function BraqueTestBuffPopPanel:onShow()
	local buffIndex = self.curCtrl:getBuffType()
	self.valueList, warOrderRead = self.curCtrl, self.curCtrl
	if 0 < buffIndex then
		self.effectInfo = warOrderRead.getBuffInfo(self.activityID, self.buffBuildType, buffIndex)
		if self.effectInfo then
			for i, v in ipairs(self.effectInfo.PrivilegeEffect) do
				local effectType = buffltCtrl:getEffectType(v)
				table.insert(self.valueList, self.curCtrl:getBuffVale(effectType))
			end
			self.fields.BuffList:setNumItems(table.nums(self.effectInfo.PrivilegeEffect))
		end
	else
		return
	end
end
function BraqueTestBuffPopPanel:onClickGo()
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.activityID)
	self:removeFromParent()
end
function BraqueTestBuffPopPanel:onBuffItemRenderer(index, object)
	object:initData(self.effectInfo.EffectIcon[index + 1] .. ".png", self.effectInfo.PrivilegeEffect[index + 1], true, self.valueList[index + 1])
end
function BraqueTestBuffPopPanel:onClickQuestion()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY then
		uiManager:show("Activity_9001656_Buff")
	else
		warOrderRead.openSkillBuffView(self.activityID)
	end
end
return BraqueTestBuffPopPanel
