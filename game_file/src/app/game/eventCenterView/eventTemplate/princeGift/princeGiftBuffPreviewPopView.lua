local princeGiftRead = include("princeGiftRead")
local princeGiftBuffPreviewPopView = class("princeGiftBuffPreviewPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("princeGiftBuffPreviewPopView")
end)
function princeGiftBuffPreviewPopView:ctor(properties)
	local packageInfo = princeGiftRead.getFirstPackageInfo()
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox")
	self.nodeCommonPopBox:setTitleName(i18n("Payment_activity_optimization_text_08"))
	self.textDescribe = SoraDGetChildByName(self.node, "Text_Describe")
	self.textDescribe = SoraDChangeTextToHtml(self.textDescribe)
	princeGiftRead = i18n("Payment_activity_optimization_text_08")
	i18n("Payment_activity_optimization_text_08").num1 = 120
	princeGiftRead, princeGiftRead, i18n("Payment_activity_optimization_text_08").num2 = i18n("Payment_activity_optimization_text_08")
	princeGiftRead, (packageInfo.buffTime / 86400).num1, i18n("Payment_activity_optimization_text_08").color = i18n("Payment_activity_optimization_text_08")
	princeGiftRead, (packageInfo.buffTime / 86400).num2, i18n("Payment_activity_optimization_text_08").color = i18n("Payment_activity_optimization_text_08")
	;(packageInfo.buffTime / 86400).__default, i18n("Payment_activity_optimization_text_08").color = i18n("Payment_activity_optimization_text_08")
	self.textDescribe:setString(i18n_html("Wisdom_of_oriental_prince_text_11", i18n("Payment_activity_optimization_text_08")))
end
return princeGiftBuffPreviewPopView
