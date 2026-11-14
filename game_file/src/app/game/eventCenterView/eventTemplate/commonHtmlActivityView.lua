local gametop = gModuleMgr.getObject("gametop")
local accountExtCtrl = gametop.playertop_:getModule("accountExtCtrl")
local commonHtmlActivityView = class("commonHtmlActivityView", function(target)
	return target or SoraDCreateTouchPanel("commonHtmlActivityView")
end)
local _ENV, activityConfig = "commonHtmlActivityView", "commonHtmlActivityView"
function commonHtmlActivityView:ctor(properties)
	self.isAddToPopManager = true
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.spSddrzm = SoraDGetChildByName(self, "frame_sddrzm_Center")
	self.textTip = SoraDGetChildByName(self, "Text_tip")
	self.textTip = SoraDChangeTextToHtml(self.textTip)
	self.Text_tip_shadow = SoraDGetChildByName(self, "Text_tip_shadow")
	self.Text_tip_shadow = SoraDChangeTextToHtml(self.Text_tip_shadow)
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.btnGo:setTouchEnabled(true)
	self.btnGo:setTitleText(i18n("common_text_477"))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
end
function commonHtmlActivityView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function commonHtmlActivityView:initData(activityID)
	self.activityID = activityID
	self.textTip:setString(i18n(activityConfig[activityID].tips))
	self.Text_tip_shadow:setString(i18n(activityConfig[activityID].tips))
	if activityConfig[activityID].noShadow then
		self.Text_tip_shadow:setVisible(false)
	end
	self.nodeCommonPopBox:setTitleName(i18n(activityConfig[activityID].title))
	self.spSddrzm:setSpriteFrame(activityConfig[activityID].bg)
	self.spSddrzm:setTexture(activityConfig[activityID].bg)
end
function commonHtmlActivityView:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		local url
		if userSDKManager.isBeta() then
			url = activityConfig[self.activityID].urlBeta
		else
			url = activityConfig[self.activityID].url
		end
		if activityConfig[self.activityID].isTimeParam then
			local args = serviceFunctions.systemTime()
			url = string.format(url, args)
		end
		print("url====", url)
		userSDKManager.openSDKLink(url)
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function commonHtmlActivityView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:layerClickCallBack(self, ccui.TouchEventType.ended)
	end
end
return commonHtmlActivityView
