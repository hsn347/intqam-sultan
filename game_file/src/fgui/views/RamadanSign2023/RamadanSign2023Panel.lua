local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local signRewadRead = include("signRewadRead")
local RamadanSign2023Ctrl = SoraDGetCtrl("RamadanSign2023Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanSign2023Panel = class("RamadanSign2023Panel", baseFguiPanel)
function RamadanSign2023Panel:ctor(...)
	self.super.ctor(self, ...)
	print("RamadanSign2023Panel:ctor", self.viewName)
end
function RamadanSign2023Panel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ThirtyDaySign2021"
	end
	return self._packageList
end
function RamadanSign2023Panel:onInit()
	print("=======RamadanSign2023Panel:onInit")
	self.activityID = gActivityTimeActivityID.RAMADAN_SIGN_2023_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001491"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_tip2:setString(i18n("common_text_2876"))
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
		self.fields.Text_ServerTime:setString(str1)
	else
		self.fields.Text_ServerTime:setString(str2)
	end
	self.fields.Text_tip:setString(i18n("common_text_2882"))
	self.fields.List_Day:setItemRenderer(handler(self, self.onItemDayRederer))
	self.fields.List_Box:setItemRenderer(handler(self, self.onItemBoxRederer))
end
function RamadanSign2023Panel:onShow()
	print("=======RamadanSign2023Panel:onShow")
	self:refreshView()
end
function RamadanSign2023Panel:refreshView()
	_ENV = nil
	;(nil).day = RamadanSign2023Ctrl:getTotalSignDay()
	self.fields.Text_TotalDay:setString(i18n("common_text_2879", nil))
	self.fields.List_Day:setNumItems(signRewadRead.getRamadan2023TotalDay(RamadanSign2023Ctrl:getClassType()))
	self.extraStage = signRewadRead.getRamadan2023ExtraDay(RamadanSign2023Ctrl:getClassType())
	self.fields.List_Box:setNumItems(table.nums(self.extraStage))
end
function RamadanSign2023Panel:onItemDayRederer(index, object)
	object:initData(index + 1)
end
function RamadanSign2023Panel:onItemBoxRederer(index, object)
	object:initData(self.extraStage[index + 1])
end
function RamadanSign2023Panel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_signin_rule")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RamadanSign2023Panel:refreshPageInZero()
	RamadanSign2023Ctrl:sendReqInitDataMsg()
end
return RamadanSign2023Panel
