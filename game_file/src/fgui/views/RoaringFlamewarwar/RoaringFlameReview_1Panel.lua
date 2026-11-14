local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameReview_1Panel = class("RoaringFlameReview_1Panel", baseFguiPanel)
function RoaringFlameReview_1Panel:ctor(...)
	self.isLRU = true
	RoaringFlameReview_1Panel.super.ctor(self, ...)
	print("RoaringFlameReview_1Panel:ctor", self.viewName)
end
function RoaringFlameReview_1Panel:onInit()
	print("=======RoaringFlameReview_1Panel:onInit")
	self.seasonDays = math.ceil(roaringFlameWarRead.getSeasonTime() / 86400)
	self.fields.Text_tip:setString(i18n("common_text_3701"))
	_ENV = i18n("common_text_3701")
	i18n("common_text_3701").num = self.seasonDays
	self.fields.Text_msg:setString(i18n("flames_dunes_text194", i18n("common_text_3701")))
	local fontDay = string.format("<font color='#FFD43E' size='90'>%d</font>", self.seasonDays)
	_ENV = i18n("flames_dunes_text194", i18n("common_text_3701"))
	i18n("flames_dunes_text194", i18n("common_text_3701")).num = fontDay
	self.fields.Text_day:setString(i18n("flames_dunes_text193", i18n("flames_dunes_text194", i18n("common_text_3701"))))
end
function RoaringFlameReview_1Panel:endShow()
	print("=======RoaringFlameReview_1Panel:endShow")
	roaringFlameWarCtrl:reqSeasonRecord()
	SoraDShowLoading(self)
end
function RoaringFlameReview_1Panel:onMsgUpdateStateData(...)
	SoraDCloseLoading(self)
end
function RoaringFlameReview_1Panel:onHide()
	uiManager:show("RoaringFlameReview_2")
end
return RoaringFlameReview_1Panel
