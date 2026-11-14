local constantRead = include("constantRead")
local princeGiftTaskExplainPopView = class("princeGiftTaskExplainPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("princeGiftTaskExplainPopView")
end)
function princeGiftTaskExplainPopView:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox")
	self.nodeCommonPopBox:setTitleName(i18n("Payment_activity_optimization_text_07"))
	self.textDescribe = SoraDGetChildByName(self.node, "Text_Describe")
	self.textDescribe:setString(i18n("Wisdom_of_oriental_prince_text_04"))
	local castlePoint = constantRead.getConstValue("WISDOM_OF_ORIENTAL_PRINCECASTLE_POINTS")
	local otherPoint = constantRead.getConstValue("WISDOM_OF_ORIENTAL_PRINCEOTHER_BUILDING_POINTS")
	_ENV = i18n("Wisdom_of_oriental_prince_text_04")
	i18n("Wisdom_of_oriental_prince_text_04").num1 = castlePoint
	i18n("Wisdom_of_oriental_prince_text_04").num2 = otherPoint
	self.textDescribe:setString(i18n("Wisdom_of_oriental_prince_text_04", i18n("Wisdom_of_oriental_prince_text_04")))
	self.textRule = SoraDGetChildByName(self.node, "Text_Rule")
	self.textRule:setString(i18n("Payment_activity_optimization_text_09"))
end
return princeGiftTaskExplainPopView
