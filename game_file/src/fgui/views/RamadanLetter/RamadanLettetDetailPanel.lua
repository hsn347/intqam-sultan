local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanLettetDetailPanel = class("RamadanLettetDetailPanel", baseFguiPanel)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local ramadanLetterCtrl = SoraDGetCtrl("ramadanLetterCtrl")
local activityTimeRead = include("activityTimeRead")
function RamadanLettetDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanLettetDetailPanel:ctor", self.viewName)
end
function RamadanLettetDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanLettetDetailPanel:onInit()
	print("=======RamadanLettetDetailPanel:onInit")
	self.cfg = self.proxy.param.cfg
	self.activityID = self.cfg.activityID
	self.fields.text_reward_desc:setString(i18n("ramadan_letter_03"))
	_ENV = i18n("ramadan_letter_03")
	i18n("ramadan_letter_03").item = self.cfg.chapter
	self.fields.text_chapter:setString(i18n("ramadan_letter_02", i18n("ramadan_letter_03")))
	self.fields.text_title:setString(i18n(activityTimeRead.getActivityNameByID(self.activityID)))
	self.fields.text_desc:setString(i18n(self.cfg.activityIntroduction))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.fields.Scroll_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.button_go:addClickEventListener(handler(self, self.onClickGo))
	self.fields.button_go:setTitle(i18n("common_text_477"))
end
function RamadanLettetDetailPanel:onShow()
	print("=======RamadanLettetDetailPanel:onShow")
	local activityStartTime = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.RAMADAN_LETTER_ACTIVITY)
	local curActivityID = self.activityID
	if self.cfg.index == 4 then
		fguiHelper.get_fields(self.fields.icon_bg).icon_bg:setIcon("bg_ramadanletter_0" .. self.cfg.index .. ".png")
	else
		fguiHelper.get_fields(self.fields.icon_bg).icon_bg:setIcon("bg_ramadanletter_0" .. self.cfg.index .. ".png")
	end
	local curStartTime = activityStartTime + (self.cfg.time - 1) * 24 * 60 * 60
	self.text_time:removeTime()
	if curStartTime > serviceFunctions.systemTime() then
		self.error = "common_text_2486"
		if ramadanLetterCtrl:getCurChapter() then
			self.text_time:setTimeLast(function(strTime)
				_ENV = nil
				;(nil).time = strTime
				return i18n("common_text_606", nil)
			end)
			self.text_time:beginTime(curStartTime - serviceFunctions.systemTime())
		end
		self.fields.button_go:setBright(false)
	else
		self.error = "common_text_1859"
		self.isOpen = true
		local timer = activityShowCtrl:getTimeInfoByID(curActivityID)
		if timer then
			local leftTime = timer.timerNode.timer:getRemainTime()
			self.text_time:setTimeLast(function(strTime)
				local state = activityShowCtrl:getStateByID(curActivityID)
				if state == gActivityState.OPEN then
					activityShowCtrl = nil
					;(nil).time = strTime
					return i18n("common_text_607", nil)
				else
					self.error = "common_text_2486"
					activityShowCtrl = nil
					;(nil).time = strTime
					return i18n("common_text_606", nil)
				end
			end)
			self.text_time:beginTime(leftTime)
			self.fields.button_go:setBright(true)
		else
			self.text_time:setString(i18n("common_text_1859"))
			self.fields.button_go:setBright(false)
		end
	end
	if not activityTimeRead.getActivityConfigByID(curActivityID) then
		local _ENV, config = activityTimeRead.getActivityConfigByID(curActivityID), activityTimeRead.getActivityConfigByID(curActivityID)
	end
	if not config.show_reward then
		_ENV = config.show_reward
	end
	self.awards = config.show_reward
	self.fields.Scroll_award:setNumItems(#self.awards)
end
function RamadanLettetDetailPanel:onHide()
	print("=======RamadanLettetDetailPanel:onHide")
end
function RamadanLettetDetailPanel:onDispose()
	print("=======RamadanLettetDetailPanel:onDispose")
end
function RamadanLettetDetailPanel:onItemRenderer(index, object)
	object:initData(self.awards[index + 1])
end
function RamadanLettetDetailPanel:onClickGo()
	SoraDPlaySound()
	local activityID = self.activityID
	if clientEventMgr.judgeIsOpen(activityID) then
		SoraDRemoveAllPanelFromManager()
		clientEventMgr.singleClickEvent(activityID, 7)
		return true
	else
		SoraDShowMsgTip(i18n(self.error))
	end
end
return RamadanLettetDetailPanel
