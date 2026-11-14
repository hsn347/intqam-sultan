local summerPrayCtrl = SoraDGetCtrl("summerPrayCtrl")
local summerPrayersPopReset = class("summerPrayersPopReset", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("summerPrayersPopReset")
end)
function summerPrayersPopReset:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.textGuideTip = SoraDGetChildByName(self.node, "Text_GuideTip")
	self.btnOk = SoraDGetChildByName(self.node, "Button_ok")
	self.btnOk:setTouchEnabled(true)
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
end
function summerPrayersPopReset:initData(target, boxData)
	self.tableBoxData = boxData
	self.btnOk:setTitleText(self.tableBoxData.yes)
	self.textGuideTip:setString(self.tableBoxData.tips)
	self.parentView = boxData.view
end
function summerPrayersPopReset:btnOkClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		summerPrayCtrl:reqSummerPrayReset()
		SoraDShowLoading(self.parentView)
		self:layerClickCallBack(self, eventType)
	end
end
return summerPrayersPopReset
