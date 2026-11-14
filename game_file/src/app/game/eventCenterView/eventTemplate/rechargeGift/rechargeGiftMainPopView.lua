local rechargeGiftMainPopView = class("rechargeGiftMainPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("rechargeGiftMainPopView")
end)
function rechargeGiftMainPopView:ctor(properties)
	self.activityID = gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.node_spine = SoraDGetChildByName(self, "Node_Spine")
	local spine_npc = sp.SkeletonAnimation:create("spine/chongzhizengli_renwu.skel", "spine/chongzhizengli_renwu.atlas", 1)
	spine_npc:setAnimation(0, "animation", true)
	spine_npc:setPosition(cc.p(0, -10))
	spine_npc:addTo(self.node_spine)
	self.panel = SoraDGetChildByName(self.node, "panelTouch")
	self.btnGo = SoraDGetChildByName(self.node, "btn_go")
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self.btnGo:getTitleRenderer():setPositionY(32)
	self.textExplain = SoraDGetChildByName(self.node, "Text_Explain")
	self.textExplain:setString(i18n("rechargeGift_text_01"))
	self.textBFTitle = SoraDGetChildByName(self.node, "BitmapFontLabel_Title")
	local cssFileName = "rechargeGiftMainPopView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:setTimeSpeed(0.8)
	action:gotoFrameAndPlay(0, false)
	self:runAction(action)
end
function rechargeGiftMainPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function rechargeGiftMainPopView:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function rechargeGiftMainPopView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return rechargeGiftMainPopView
