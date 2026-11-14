local friendsCallbackRead = include("friendsCallbackRead")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local honorBackNewBrokeNode = class("honorBackNewBrokeNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackNewBrokeNode")
	end
	return target
end)
function honorBackNewBrokeNode:ctor()
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.imageBg = SoraDGetChildByName(self.Top_Node, "Image_activity", true)
	self.oldSize = self.Panel_cut:getContentSize()
	self.btnLook = SoraDGetChildByName(self.Top_Node, "Button_Look", true)
	self.btnLook:setTitleText(i18n("common_text_477"))
	self.btnLook:addTouchEventListener(handler(self, self.btnClickLook))
	self.blackPanel = SoraDGetChildByName(self, "Panel_Black")
	self.blackPanel:setVisible(false)
	local _, ret = SoraDIsFileExistByFileName("bg_return_newbroke.png")
	if not ret then
		self.isRealBg = false
		self.imageBg:ignoreContentAdaptWithSize(true)
		self.imageBg:loadTexture("bg_zxtc_zhlx.png", ccui.TextureResType.plistType)
		self.blackPanel:setVisible(true)
	else
		self.isRealBg = true
		self.imageBg:loadTexture("bg_return_newbroke.png", ccui.TextureResType.plistType)
	end
end
function honorBackNewBrokeNode:initData()
end
function honorBackNewBrokeNode:setSize(size)
	self.sizeHeight = size.height
	self.Panel_cut:setContentSize(size)
	self.Top_Node:setPositionY(size.height)
	self.btnLook:setPositionY(100 - size.height)
	if self.isRealBg then
		self.imageBg:setAnchorPoint(cc.p(0.5, 0.5))
		self.imageBg:setPositionY(-size.height / 2)
	else
		self.imageBg:setAnchorPoint(cc.p(0.5, 1))
		self.imageBg:setPositionY(0)
	end
end
function honorBackNewBrokeNode:btnClickLook(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local timestamp = serviceFunctions.systemTime()
		local url = string.format("https://h5action.onemt.co/koh/versionnews/?timestamp=%s", timestamp)
		_ENV = nil
		;(nil).eventid = gActivityTimeActivityID.FRIEND_CALLBACK
		;(nil).subid = 9
		userSDKManager.logEvent(gSDKDef.TDonEvent.h5_events_title, nil)
		print("···", url)
		userSDKManager.openSDKLink(url)
	end
end
return honorBackNewBrokeNode
