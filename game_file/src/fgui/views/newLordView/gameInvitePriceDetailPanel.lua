local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameInvitePriceDetailPanel = class("gameInvitePriceDetailPanel", baseFguiPanel)
function gameInvitePriceDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameInvitePriceDetailPanel:ctor", self.viewName)
end
function gameInvitePriceDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameInvitePriceDetailPanel:onInit()
	print("=======gameInvitePriceDetailPanel:onInit")
	self.gType = self.proxy.param.viewType
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Panel_bg:setString(i18n("hero_title_02"))
end
function gameInvitePriceDetailPanel:onShow()
	print("=======gameInvitePriceDetailPanel:onShow")
	local gameInviteltCtrl = include("gameInviteltCtrl")
	self.myInfo = gameInviteltCtrl.getItemListByType(self.gType)
	if gGameInviteType.PEOPLE == self.gType then
		self.fields.Text_des:setString(i18n("invite_text_02"))
	elseif gGameInviteType.PEOPLECASTLE == self.gType then
		self.fields.Text_des:setString(i18n("invite_text_05"))
	end
	self:initView()
end
function gameInvitePriceDetailPanel:onItemRederer(index, target)
	target:initData(self.myInfo[index + 1], self.gType)
end
function gameInvitePriceDetailPanel:initView(...)
	self.fields.List:setNumItems(#self.myInfo)
end
return gameInvitePriceDetailPanel
