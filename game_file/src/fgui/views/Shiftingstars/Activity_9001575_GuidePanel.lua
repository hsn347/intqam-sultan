local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001575_GuidePanel = class("Activity_9001575_GuidePanel", baseFguiPanel)
local guideCtrl = SoraDGetCtrl("guideCtrl")
local buffDesRead = include("buffDesRead")
local buffltCtrl = include("buffltCtrl")
local constantRead = include("constantRead")
function Activity_9001575_GuidePanel:ctor(...)
	Activity_9001575_GuidePanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001575_GuidePanel:ctor", self.viewName)
end
function Activity_9001575_GuidePanel:onInit()
	print("=======Activity_9001575_GuidePanel:onInit")
	self.isAddToPopManager = true
	local lang = SoraDGetDefaultLanguage()
	self.fields.icon_title:setURL(lang == "ar" and "frame_hdyd_ar.png" or "frame_hdyd_en.png")
	self.fields.txt_title:setString(i18n("Icefestival2024_text09"))
	self.fields.btn_sure:setTitle(i18n("common_text_204"))
	self.fields.btn_sure:addClickEventListener(handler(self, self.onSureClick))
	local buffID = constantRead.getConstValue("NEW_YEAR_BUFF", 0)
	if buffID ~= 0 then
		local eid = buffltCtrl:getEffectType(buffID)
		local buffEffect, effectType = buffltCtrl:getEffect(buffID)
		self.fields.Image_icon:setURL("icon_kingdomLv_buff_13.png")
		self.fields.txt_des:setString(i18n("Icefestival2024_text24"))
	end
end
function Activity_9001575_GuidePanel:onShow()
	print("=======Activity_9001575_GuidePanel:onShow")
end
function Activity_9001575_GuidePanel:onHide()
	print("=======Activity_9001575_GuidePanel:onHide")
	guideCtrl:updateGuideModule(gGuideModule.ACTIVITY_GUIDE)
end
function Activity_9001575_GuidePanel:onSureClick()
	self:close()
end
return Activity_9001575_GuidePanel
