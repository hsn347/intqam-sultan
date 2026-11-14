local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local equipStrengthStoneGetWaySingle = class("equipStrengthStoneGetWaySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipStrengthStoneGetWaySingle")
	end
	return target
end)
function equipStrengthStoneGetWaySingle:ctor()
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.btnClickJump))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Image_target = SoraDGetChildByName(self, "Image_target")
end
function equipStrengthStoneGetWaySingle:initData(data, otherData)
	self.data = data
	self.parent = otherData.parent
	self.Text_des:setString(i18n(self.data.des))
	self.Image_target:loadTexture(self.data.icon, ccui.TextureResType.plistType)
end
function equipStrengthStoneGetWaySingle:btnClickJump(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local activityID = self.data.guide.activity_id
		local activityStatus = activityShowCtrl:getStateByID(activityID)
		if activityID == gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY then
			if activityStatus == gActivityState.OPEN then
				clientEventMgr.singleClickEvent(activityID)
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		elseif activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
			if activityStatus ~= gActivityState.CLOSE then
				clientEventMgr.singleClickEvent(activityID)
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		elseif activityID == gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_ADVANCE then
			if gActivityState.OPEN == activityStatus then
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").id = activityID
				uiManager:show("ExchangeEventPage", i18n("common_text_2486"))
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		end
	end
end
return equipStrengthStoneGetWaySingle
