local princeGiftNewBuffPreviewPopView = class("princeGiftNewBuffPreviewPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("princeGiftNewBuffPreviewPopView")
end)
function princeGiftNewBuffPreviewPopView:ctor()
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox")
	self.nodeCommonPopBox:setTitleName(i18n("Payment_activity_optimization_text_08"))
end
function princeGiftNewBuffPreviewPopView:initData(desc)
	self.textDescribe = SoraDGetChildByName(self.node, "Text_Describe")
	self.textDescribe:setContentSize(cc.size(500, 110))
	self.textDescribe = SoraDChangeTextToHtml(self.textDescribe)
	self.textDescribe:setString(desc)
end
return princeGiftNewBuffPreviewPopView
