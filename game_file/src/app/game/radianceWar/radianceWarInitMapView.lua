local radianceWarRead = include("radianceWarRead")
local resourceMapViewBase = include("resourceMapViewBase")
local radianceWarInitMapView = class("radianceWarInitMapView", resourceMapViewBase)
function radianceWarInitMapView:ctor(...)
	radianceWarInitMapView.super.ctor(self, ...)
end
function radianceWarInitMapView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_MATCH_BACK", handler(self, self.refreshKingdomText))
end
function radianceWarInitMapView:initWidget(...)
	radianceWarInitMapView.super.initWidget(self, ...)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("brightWar_text_22"))
	local _UPVALUE3_, radianceWarInitMapView, nodeInfo = self.nodeTitle, self.nodeTitle.setTitle, self.nodeTitle.setTitle
	self.nodeTitle[1] = gMapObjTypeDef.mapTypeRadianceWarPalace
	self.nodeTitle[2] = 999
	local self.nodeTitle[3], tab = gMapObjTypeDef.mapTypeRadianceWarGate, self.nodeTitle
	for i, v in ipairs(tab) do
		radianceWarInitMapView = i18n("brightWar_text_22")
		i18n("brightWar_text_22").title = radianceWarRead.getBuildName(v)
		local i18n("brightWar_text_22").image, data = radianceWarRead.getBuildIcon(v), i18n("brightWar_text_22")
		table.insert(nodeInfo, data)
	end
	self:initNodeInfo(nodeInfo)
	self.touchlayer:setTouchEnabled(false)
	self:setRadianceWarBuildingInfo()
	self:setRadianceWarBuildingStataues()
	self.Node_tips:setVisible(true)
	self.arrTips = SoraDGetChildsArrayByName(self.Node_tips, "Text_tips_", 4, 1)
	for i, v in ipairs(self.arrTips) do
		v:setString(i18n("brightWar_text_25"))
	end
	self.Node_birthArea = SoraDGetChildByName(self, "Node_birthArea")
	if self.Node_birthArea then
		self.Node_birthArea:setVisible(true)
	end
end
return radianceWarInitMapView
