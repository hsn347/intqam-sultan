local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local newDayTaskPopView = class("newDayTaskPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("newDayTaskPopView")
end)
function newDayTaskPopView:ctor(properties)
	self.activityID = gActivityTimeActivityID.EXCHANGE_MALL_NEW_DAY_TASK
	self.itemId = 836501
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.nodeItm = SoraDGetChildByName(self, "Node_Itm")
	self.imgIcon = SoraDGetChildByName(self.nodeItm, "Image_Icon")
	self.btnItem = SoraDGetChildByName(self.nodeItm, "Button_Item")
	self.btnItem = include("commonBtnInstance").new(self.btnItem)
	self.btnItem:setItemInfo(self, self.itemId, 1)
	self.textTip = SoraDGetChildByName(self, "Text_Tip")
	self.textTip:setString(i18n("item_des_836501"))
	self.btnGo = SoraDGetChildByName(self, "Button_Go")
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
end
function newDayTaskPopView:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local state = activityShowCtrl:getStateByID(self.activityID)
		if state == gActivityState.OPEN then
			_ENV = nil
			;(nil).id = self.activityID
			uiManager:show("ExchangeEventPage", nil)
			self:removeFromParent()
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	end
end
return newDayTaskPopView
