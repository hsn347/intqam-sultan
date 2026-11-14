local signRewadRead = include("signRewadRead")
local actCtrl = SoraDGetCtrl("ThirtyDaySign2022Ctrl")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ThirtyDaySign2022Panel = class("ThirtyDaySign2022Panel", baseFguiPanel)
function ThirtyDaySign2022Panel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ThirtyDaySign2022Panel:ctor", self.viewName)
end
function ThirtyDaySign2022Panel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AnniversaryCountdown2022"
		self._packageList, self._packageList[2] = self._packageList, "ThirtyDaySign2021"
	end
	return self._packageList
end
function ThirtyDaySign2022Panel:onInit()
	print("=======ThirtyDaySign2022Panel:onInit")
	self.functionCol = self:initFunc()
	actCtrl:sendReqInitDataMsg()
	self:fixPosition()
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_SIGN_2022_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001453"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:adjustTitleWidth()
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Text_tip2:setString(i18n("common_text_2876"))
	_ENV = "common_text_2880"
	;("common_text_2880").sd = "10"
	;("common_text_2880").ed = "20"
	self.fields.Text_serverTime:setString(i18n("common_text_2880"), "common_text_2880")
	local startDate = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local endDate = activityShowCtrl:getEndTimeSecond(self.activityID)
	_ENV = i18n("common_text_2876")
	i18n("common_text_2876").sd = _pq(os.date("%Y-%m-%d", endDate))
	i18n("common_text_2876").ed = _pq(os.date("%Y-%m-%d", startDate))
	local str1 = i18n("common_text_2880", i18n("common_text_2876"))
	_ENV = _pq(os.date("%Y-%m-%d", startDate))
	_pq(os.date("%Y-%m-%d", startDate)).sd = _pq(os.date("%Y-%m-%d", startDate))
	_pq(os.date("%Y-%m-%d", startDate)).ed = _pq(os.date("%Y-%m-%d", endDate))
	local str2 = i18n("common_text_2880", (_pq(os.date("%Y-%m-%d", startDate))))
	if SoraDFIsRA() then
		self.fields.Text_serverTime:setString(str1)
	else
		self.fields.Text_serverTime:setString(str2)
	end
	local i = 1
	_UPVALUE3_ = self.fields.Text_serverTime
	self.fields.Text_serverTime[1] = "common_text_2882"
	self.fields.Text_serverTime[2] = "common_text_2883"
	local self.fields.Text_serverTime[3], noteTipNumsPool = "common_text_2884", self.fields.Text_serverTime
	self.fields.Text_tip:setString(i18n(noteTipNumsPool[1]))
	i = i + 1
	self.transitions.t0:setHook("End", function()
		self.fields.Text_tip:setString(i18n(noteTipNumsPool[i]))
	end)
	self:bottomTipLoop()
	self.fields.List_day:setItemRenderer(handler(self, self.onItemRedererDay))
	self.fields.List_accuDay:setItemRenderer(handler(self, self.onItemRedererCumuDay))
end
function ThirtyDaySign2022Panel:adjustTitleWidth()
	local title = self.fields.Com_title:getChild("title")
	if title:getWidth() > self:getWidth() * 0.7 then
		title:setAutoSize(fgui.AutoSizeType.SHRINK)
		title:setWidth(self:getWidth() * 0.7)
	else
		title:setAutoSize(fgui.AutoSizeType.BOTH)
	end
end
function ThirtyDaySign2022Panel:refreshPageInZero()
	actCtrl:sendReqInitDataMsg()
end
function ThirtyDaySign2022Panel:fixPosition()
	local lang = SoraDGetDefaultLanguage()
	self.lang = lang
end
function ThirtyDaySign2022Panel:initData()
	_ENV = nil
	;(nil).day = actCtrl:getTotalSignDay()
	self.fields.Text_accuTimes:setString(i18n("common_text_2879", nil))
	self.fields.List_day:setNumItems(actCtrl:getTotalDay())
	self.extraStage = signRewadRead.getAnniversary2022ExtraDay()
	self.fields.List_accuDay:setNumItems(table.nums(self.extraStage))
	if actCtrl:getCurDay() >= 1 and actCtrl:getCurDay() <= 30 then
		self.fields.List_day:scrollToView(actCtrl:getCurDay() - 1)
	end
end
function ThirtyDaySign2022Panel:initFunc()
	_UPVALUE0_ = nil
	;(nil).init = function()
		self:initData()
	end
	;(nil).sign = function()
		self:refreshDay()
	end
	local (nil).extra, functionCol = function()
		self:initData()
	end, nil
	return functionCol
end
function ThirtyDaySign2022Panel:refreshDay()
	_ENV = nil
	;(nil).day = actCtrl:getTotalSignDay()
	self.fields.Text_accuTimes:setString(i18n("common_text_2879", nil))
	self.extraStage = signRewadRead.getAnniversary2022ExtraDay()
	self.fields.List_accuDay:setNumItems(table.nums(self.extraStage))
	local obj = self.fields.List_day:getChildAt(self.data.blockDay - 1)
	obj:showEffect()
	self.data = nil
end
function ThirtyDaySign2022Panel:refreshView(data)
	if not data then
		return
	end
	dump(data, "ThirtyDaySign2022Panel:refreshView")
	self.data = data
	self.rewards = data.reward
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function ThirtyDaySign2022Panel:onItemRedererDay(index, object)
	object:initData(index + 1)
end
function ThirtyDaySign2022Panel:onItemRedererCumuDay(index, object)
	object:initData(index + 1, self.extraStage[index + 1])
end
function ThirtyDaySign2022Panel:refreshCumuDay(target, data)
	self.fields.List_accuDay:setItemRenderer(handler(self, self.onItemRedererCumuDay))
	self.fields.List_accuDay:setNumItems(#actCtrl:getCumuDayArray())
end
function ThirtyDaySign2022Panel:onClickItem(context)
	local item = context:getGObjectData()
	item:onClickDay()
end
function ThirtyDaySign2022Panel:bottomTipLoop()
	self.transitions.t0:play(-1, 0)
end
function ThirtyDaySign2022Panel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("common_text_2881")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ThirtyDaySign2022Panel:onShow()
	print("=======ThirtyDaySign2022Panel:onShow")
end
function ThirtyDaySign2022Panel:onHide()
	print("=======ThirtyDaySign2022Panel:onHide")
end
function ThirtyDaySign2022Panel:onDispose()
	print("=======ThirtyDaySign2022Panel:onDispose")
end
return ThirtyDaySign2022Panel
