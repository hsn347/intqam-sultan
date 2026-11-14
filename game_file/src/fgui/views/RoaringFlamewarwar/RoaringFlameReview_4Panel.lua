local lordLocalData = include("lordLocalData")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameReview_4Panel = class("RoaringFlameReview_4Panel", baseFguiPanel)
function RoaringFlameReview_4Panel:ctor(...)
	self.isLRU = true
	RoaringFlameReview_4Panel.super.ctor(self, ...)
	print("RoaringFlameReview_4Panel:ctor", self.viewName)
end
function RoaringFlameReview_4Panel:onInit()
	print("=======RoaringFlameReview_4Panel:onInit")
	self.fields.Text_tip:setString(i18n("common_text_3701"))
	self.fields.Text_des:setString(i18n("flames_dunes_text303"))
	self.view:fixChildrenPos()
end
function RoaringFlameReview_4Panel:endShow()
	print("=======RoaringFlameReview_4Panel:endShow")
	if not roaringFlameWarCtrl:getSeaonRecordData() then
		local _ENV, seasonData = roaringFlameWarCtrl:getSeaonRecordData(), roaringFlameWarCtrl:getSeaonRecordData()
	end
	if not seasonData.seasonRecord then
		local _ENV, seasonRecord = seasonData.seasonRecord, seasonData.seasonRecord
	end
	local phoenixTop = seasonRecord.phoenixTop
	if phoenixTop then
		self.fields.icon_phoenix:setSpriteFrame(lordLocalData.getPortrait(phoenixTop.headid))
		_ENV = lordLocalData.getPortrait(phoenixTop.headid)
		lordLocalData.getPortrait(phoenixTop.headid).name = fguiHelper.getColorString("#FFD43E", phoenixTop.name)
		lordLocalData.getPortrait(phoenixTop.headid).val = fguiHelper.getColorString("#FFD43E", phoenixTop.score)
		self.fields.Text_phoenix:setString(i18n("flames_dunes_text202", lordLocalData.getPortrait(phoenixTop.headid)))
	else
		self.fields.icon_phoenix:setSpriteFrame("bust_small_m_005.png")
		self.fields.Text_phoenix:setString("")
	end
	local honorTop = seasonRecord.honorTop
	if honorTop then
		self.fields.icon_honor:setSpriteFrame(lordLocalData.getPortrait(honorTop.headid))
		_ENV = lordLocalData.getPortrait(honorTop.headid)
		lordLocalData.getPortrait(honorTop.headid).name = fguiHelper.getColorString("#FFD43E", honorTop.name)
		lordLocalData.getPortrait(honorTop.headid).val = fguiHelper.getColorString("#FFD43E", honorTop.score)
		self.fields.Text_honor:setString(i18n("flames_dunes_text203", lordLocalData.getPortrait(honorTop.headid)))
	else
		self.fields.icon_honor:setSpriteFrame("bust_small_m_005.png")
		self.fields.Text_honor:setString("")
	end
	local killTop = seasonRecord.killTop
	if killTop then
		self.fields.icon_score:setSpriteFrame(lordLocalData.getPortrait(killTop.headid))
		_ENV = lordLocalData.getPortrait(killTop.headid)
		lordLocalData.getPortrait(killTop.headid).name = fguiHelper.getColorString("#FFD43E", killTop.name)
		lordLocalData.getPortrait(killTop.headid).val = fguiHelper.getColorString("#FFD43E", killTop.score)
		self.fields.Text_score:setString(i18n("flames_dunes_text204", lordLocalData.getPortrait(killTop.headid)))
	else
		self.fields.icon_score:setSpriteFrame("bust_small_m_005.png")
		self.fields.Text_score:setString("")
	end
end
function RoaringFlameReview_4Panel:onHide()
	uiManager:show("RoaringFlameReview_5")
end
return RoaringFlameReview_4Panel
