local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
local nationalFlagRead = include("nationalFlagRead")
local nebulaWarRead = include("nebulaWarRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001479_CampNoticePanel = class("Activity_9001479_CampNoticePanel", baseFguiPanel)
function Activity_9001479_CampNoticePanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001479_CampNoticePanel:ctor", self.viewName)
end
function Activity_9001479_CampNoticePanel:onInit()
	print("=======Activity_9001479_CampNoticePanel:onInit")
	self.fields.Panel_bg:setString(i18n("camp_integral_17"))
	self.fields.List_kid:setItemRenderer(handler(self, self.onKidItemRenderer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self:bindBtnClose(self.fields.Button_ok)
end
function Activity_9001479_CampNoticePanel:onShow()
	print("=======Activity_9001479_CampNoticePanel:onShow")
	local curRound = activity_9001479_Ctrl:getCurRound()
	if 1 <= curRound and curRound <= 4 then
		local kidList, selfCamp = nebulaActivityCtrl:getSelfCampKidList(curRound)
		self.kidList = kidList
		local campName = nebulaWarRead.getWarCampName(selfCamp)
		_ENV = nil
		;(nil).camp = campName
		self.fields.Text_des:setString(i18n("camp_integral_18", nil))
		_ENV = i18n("camp_integral_18", nil)
		i18n("camp_integral_18", nil).camp = campName
		self.fields.Text_kingdom:setString(i18n("camp_integral_19", i18n("camp_integral_18", nil)))
		self.fields.List_kid:setNumItems(#self.kidList)
	end
end
function Activity_9001479_CampNoticePanel:onKidItemRenderer(index, obj)
	local kid = self.kidList[index + 1]
	local ret, kingdom = kingdomCtrl:isFoundKingdomID(kid)
	if not ret then
		obj:setVisible(false)
		return
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	obj:setString(string.format("#%0d", kid))
	local flagImage = nationalFlagRead.getImgByID(kingdom.flagid)
	obj:setIcon(flagImage)
end
return Activity_9001479_CampNoticePanel
