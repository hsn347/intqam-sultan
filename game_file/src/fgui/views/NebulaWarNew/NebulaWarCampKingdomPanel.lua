local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local nationalFlagRead = include("nationalFlagRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarCampKingdomPanel = class("NebulaWarCampKingdomPanel", baseFguiPanel)
function NebulaWarCampKingdomPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarCampKingdomPanel:ctor", self.viewName)
	self.isHidePrePanel = true
end
function NebulaWarCampKingdomPanel:onInit()
	print("=======NebulaWarCampKingdomPanel:onInit")
	self.fields.List_item:setItemRenderer(handler(self, self.onKingdomItemRederer))
	self.fields.Usm_bg:updateUsmColor(self.fields.Image_bg:getColor())
end
function NebulaWarCampKingdomPanel:onShow()
	print("=======NebulaWarCampKingdomPanel:onShow")
	local activityID = self.proxy.param and self.proxy.param.activityID
	if activityID == gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY then
		local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
		local showRound = self.proxy.param.showRound
		local kidList, selfCamp = nebulaActivityCtrl:getSelfCampKidList(showRound)
		_ENV = nil
		;(nil).camp = nebulaWarRead.getWarCampName(selfCamp)
		self.fields.Text_title:setString(i18n("nebula_war_text_0508", nil))
		self.kingdoms = kidList
		self.fields.List_item:setNumItems(#self.kingdoms)
	else
		local regionInfo = nebulaActivityCtrl:getSelfRegionInfo()
		local groupId = self.proxy.param and self.proxy.param.groupId or nebulaActivityCtrl:getSelfGroupId()
		_ENV = #self.kingdoms
		;(#self.kingdoms).camp = nebulaWarRead.getWarGroupName(groupId)
		self.fields.Text_title:setString(i18n("nebula_war_text_0508", #self.kingdoms))
		self.kingdoms = regionInfo.groups[groupId]
		self.fields.List_item:setNumItems(#self.kingdoms)
	end
end
function NebulaWarCampKingdomPanel:onKingdomItemRederer(index, obj)
	local kid = self.kingdoms[index + 1]
	obj:fixChildrenPos()
	obj:setString(string.format("#%0d", kid))
	local ret, kingdom = kingdomCtrl:isFoundKingdomID(kid)
	if ret then
		local flagImage = nationalFlagRead.getImgByID(kingdom.flagid)
		obj:setIcon(flagImage)
	end
end
return NebulaWarCampKingdomPanel
