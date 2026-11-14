local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EighthAnniversaryMainPanel = class("EighthAnniversaryMainPanel", baseFguiPanel)
function EighthAnniversaryMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EighthAnniversaryMainPanel:ctor", self.viewName)
end
function EighthAnniversaryMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EighthAnniversaryMainPanel:onInit()
	print("=======EighthAnniversaryMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.CALENDAR_9001561_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001561"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.actConfig = activityShowCtrl:getParamByID(self.activityID).showConfig
	dump(self.actConfig, "self.actConfig")
end
function EighthAnniversaryMainPanel:onShow()
	print("=======EighthAnniversaryMainPanel:onShow")
	for i = 1, 4 do
		self.fields["label_" .. i]:setString(i18n("ruise_rabia_0" .. i))
		_ENV = i18n("ruise_rabia_0" .. i)
		i18n("ruise_rabia_0" .. i).num = i
		self.fields["label_" .. i]:getChildByName("Text_week"):setString(i18n("ruise_rabia_06", i18n("ruise_rabia_0" .. i)))
		self.fields["label_" .. i]:addClickListener(handlerEx(self, self.onClickItem, i))
		self.fields["Button_" .. i]:addClickListener(handlerEx(self, self.onClickItem, i))
	end
end
function EighthAnniversaryMainPanel:onClickHelp()
	SoraDPlaySound()
end
function EighthAnniversaryMainPanel:onClickItem(index)
	_ENV = nil
	;(nil).week = index
	uiManager:show("EighthAnniversaryActivity", nil)
end
return EighthAnniversaryMainPanel
