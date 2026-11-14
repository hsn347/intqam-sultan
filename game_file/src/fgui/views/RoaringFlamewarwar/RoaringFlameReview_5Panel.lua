local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameReview_5Panel = class("RoaringFlameReview_5Panel", baseFguiPanel)
function RoaringFlameReview_5Panel:ctor(...)
	self.isLRU = true
	RoaringFlameReview_5Panel.super.ctor(self, ...)
	print("RoaringFlameReview_5Panel:ctor", self.viewName)
end
function RoaringFlameReview_5Panel:onInit()
	print("=======RoaringFlameReview_5Panel:onInit")
	self.fields.Btn_review:setString(i18n("flames_dunes_text307"))
	self.fields.Btn_review:addClickListener(handler(self, self.btnReviewClick))
	self.fields.Btn_new:setString(i18n("flames_dunes_text308"))
	self.fields.Btn_new:addClickListener(handler(self, self.btnNewClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_review:fixPos()
	self.fields.Btn_new:fixPos()
end
function RoaringFlameReview_5Panel:onItemRenderer(index, obj)
	obj:initData(self.recordList[index + 1])
end
function RoaringFlameReview_5Panel:endShow()
	print("=======RoaringFlameReview_5Panel:endShow")
	if not roaringFlameWarCtrl:getSeaonRecordData() then
		local _ENV, seasonData = roaringFlameWarCtrl:getSeaonRecordData(), roaringFlameWarCtrl:getSeaonRecordData()
	end
	if not seasonData.personRecord then
		local _ENV, personRecord = seasonData.personRecord, seasonData.personRecord
	end
	if not seasonData.historyTop then
		local _ENV, historyTop = seasonData.historyTop, seasonData.historyTop
	end
	local base = lordInfoCtrl:getBaseInfo()
	self.fields.Spine_lord:initData(base.imageId)
	local fontName = string.format("<font color='#FFD43E' size='36'>%s</font>", base.nickName)
	_ENV = nil
	;(nil).name = fontName
	self.fields.Text_des:setString(i18n("flames_dunes_text205", nil))
	_ENV, _ENV = self.fields.Text_des, self.fields.Text_des.setString
	self.fields.Text_des.key = "flames_dunes_text206"
	self.fields.Text_des.curVal = personRecord.phoenixBestDamage or 0
	_ENV, self.fields.Text_des.setString[1], self.fields.Text_des.historyVal = self.fields.Text_des, self.fields.Text_des, historyTop.phoenixBestDamage or 0
	self.fields.Text_des.key = "flames_dunes_text207"
	self.fields.Text_des.curVal = personRecord.battleNum or 0
	_ENV, self.fields.Text_des.setString[2], self.fields.Text_des.historyVal = self.fields.Text_des, self.fields.Text_des, historyTop.battleNum or 0
	self.fields.Text_des.key = "flames_dunes_text208"
	self.fields.Text_des.curVal = personRecord.killScore or 0
	_ENV, self.fields.Text_des.setString[3], self.fields.Text_des.historyVal = self.fields.Text_des, self.fields.Text_des, historyTop.killScore or 0
	self.fields.Text_des.key = "flames_dunes_text209"
	self.fields.Text_des.curVal = personRecord.hostpitalSpeed or 0
	self.recordList, self.fields.Text_des.setString[4], self.fields.Text_des.historyVal = self.fields.Text_des.setString, self.fields.Text_des, historyTop.hostpitalSpeed or 0
	self.fields.List:setNumItems(#self.recordList)
end
function RoaringFlameReview_5Panel:btnReviewClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlameReview_1")
end
function RoaringFlameReview_5Panel:btnNewClick()
	SoraDPlaySound()
	self:close()
end
return RoaringFlameReview_5Panel
