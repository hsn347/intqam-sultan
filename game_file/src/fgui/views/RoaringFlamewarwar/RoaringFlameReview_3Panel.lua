local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameReview_3Panel = class("RoaringFlameReview_3Panel", baseFguiPanel)
function RoaringFlameReview_3Panel:ctor(...)
	self.isLRU = true
	RoaringFlameReview_3Panel.super.ctor(self, ...)
	print("RoaringFlameReview_3Panel:ctor", self.viewName)
end
function RoaringFlameReview_3Panel:onInit()
	print("=======RoaringFlameReview_3Panel:onInit")
	self.fields.Text_tip:setString(i18n("common_text_3701"))
	self.fields.Text_des:setString(i18n("flames_dunes_text197"))
end
function RoaringFlameReview_3Panel:endShow()
	print("=======RoaringFlameReview_3Panel:endShow")
	if not roaringFlameWarCtrl:getSeaonRecordData() then
		local _ENV, seasonData = roaringFlameWarCtrl:getSeaonRecordData(), roaringFlameWarCtrl:getSeaonRecordData()
	end
	if not seasonData.seasonRecord then
		local _ENV, seasonRecord = seasonData.seasonRecord, seasonData.seasonRecord
	end
	if not seasonRecord.campInfo then
		local _ENV, campInfo = seasonRecord.campInfo, seasonRecord.campInfo
	end
	if not campInfo.playerList then
		local _ENV, playerList = campInfo.playerList, campInfo.playerList
	end
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFFBD5", #playerList)
	self.fields.Text_member:setString(i18n("flames_dunes_text198", nil))
	local cityNum = 0
	for k, v in ipairs(roaringFlameWarRead.get_flames_dunes_city()) do
		if v.type ~= 11 and v.type ~= 12 then
			cityNum = cityNum + 1
		end
	end
	local occupyNum = seasonRecord.occupyNum or 0
	local occupyStr = fguiHelper.getColorString("#FFFBD5", SoraDPreciseDecimal(occupyNum * 100 / cityNum, 2) .. "%")
	_ENV = roaringFlameWarRead.get_flames_dunes_city()
	roaringFlameWarRead.get_flames_dunes_city().num = occupyStr
	self.fields.Text_occupy:setString(i18n("flames_dunes_text199", roaringFlameWarRead.get_flames_dunes_city()))
	local battleNum = seasonRecord.battleNum or 0
	_ENV = i18n("flames_dunes_text199", roaringFlameWarRead.get_flames_dunes_city())
	i18n("flames_dunes_text199", roaringFlameWarRead.get_flames_dunes_city()).num = fguiHelper.getColorString("#FFFBD5", battleNum)
	self.fields.Text_fightCount:setString(i18n("flames_dunes_text200", i18n("flames_dunes_text199", roaringFlameWarRead.get_flames_dunes_city())))
	local soldierNum = seasonRecord.soldierNum or 0
	_ENV = i18n("flames_dunes_text200", i18n("flames_dunes_text199", roaringFlameWarRead.get_flames_dunes_city()))
	i18n("flames_dunes_text200", i18n("flames_dunes_text199", roaringFlameWarRead.get_flames_dunes_city())).num = fguiHelper.getColorString("#FFFBD5", soldierNum)
	self.fields.Text_armyCount:setString(i18n("flames_dunes_text201", i18n("flames_dunes_text200", i18n("flames_dunes_text199", roaringFlameWarRead.get_flames_dunes_city()))))
end
function RoaringFlameReview_3Panel:onHide()
	uiManager:show("RoaringFlameReview_4")
end
return RoaringFlameReview_3Panel
