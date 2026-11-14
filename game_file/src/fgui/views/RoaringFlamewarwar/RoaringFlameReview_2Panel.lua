local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local lordLocalData = include("lordLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameReview_2Panel = class("RoaringFlameReview_2Panel", baseFguiPanel)
function RoaringFlameReview_2Panel:ctor(...)
	self.isLRU = true
	RoaringFlameReview_2Panel.super.ctor(self, ...)
	print("RoaringFlameReview_2Panel:ctor", self.viewName)
end
function RoaringFlameReview_2Panel:onInit()
	print("=======RoaringFlameReview_2Panel:onInit")
	self.fields.Text_tip:setString(i18n("common_text_3701"))
	self.fields.Text_lead:setString(i18n("flames_dunes_text91"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RoaringFlameReview_2Panel:onItemRenderer(index, obj)
	obj:initData(self.memberList[index + 1], index + 1)
end
function RoaringFlameReview_2Panel:endShow()
	print("=======RoaringFlameReview_2Panel:endShow")
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
	local adminData
	for k, v in ipairs(playerList) do
		if v.memberClass == ROARING_FLAME_WAR_MEMBER_CLASS.ADMIN then
			adminData = v
			break
		end
	end
	if adminData then
		local portrait = lordLocalData.getPortrait(adminData.headid)
		self.fields.icon_lord:setSpriteFrame(portrait)
		self.fields.Text_name:setString(textParser.formatPlayerName(nil, adminData.name, adminData.kid))
	end
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	local campName = roaringFlameWarRead.getCampName(selfCamp)
	_ENV = textParser.formatPlayerName(nil, adminData.name, adminData.kid)
	textParser.formatPlayerName(nil, adminData.name, adminData.kid).camp = fguiHelper.getColorString("#FFD43E", campName)
	self.fields.Text_des:setString(i18n("flames_dunes_text195", textParser.formatPlayerName(nil, adminData.name, adminData.kid)))
	self.memberList, self.fields.Text_des.setString[2], _ENV, self.fields.Text_des.setString[1], _ENV, _ENV = self.fields.Text_des.setString, self.fields.Text_des, self.fields.Text_des, self.fields.Text_des, self.fields.Text_des, self.fields.Text_des.setString
	for k, v in ipairs(playerList) do
		if v.memberClass >= ROARING_FLAME_WAR_MEMBER_CLASS.MANAGER then
			table.insert(self.memberList[1], v)
		else
			table.insert(self.memberList[2], v)
		end
	end
	self.fields.List:setNumItems(#self.memberList)
end
function RoaringFlameReview_2Panel:onHide()
	uiManager:show("RoaringFlameReview_3")
end
return RoaringFlameReview_2Panel
