local rechargeltCtrl = include("rechargeltCtrl")
local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
local eventCrazyGiftSingle = class("eventCrazyGiftSingle", function(target)
	return target
end)
local nodeSize = cc.size(300, 128)
function eventCrazyGiftSingle:ctor()
	self.contentNode = SoraDGetChildByName(self, "contentNode")
	self.iconGift = SoraDGetChildByName(self, "icon_Gift")
	self.btnJump = SoraDGetChildByName(self, "Button_Jump")
	self.btnJump:addTouchEventListener(handler(self, self.btnRechargeClick))
	self.btnJump:setSwallowTouches(false)
	self.textGiftDescribe = SoraDGetChildByName(self, "Text_GiftDescribe")
	self.textMore = SoraDGetChildByName(self, "Text_More")
	self.textMore:setString(i18n("common_text_3825"))
	self.nodeGift = SoraDGetChildByName(self, "Node_GiftInfo")
	self.iconJump = SoraDGetChildByName(self, "icon_qcz_enter")
	self.nodeWidth = nodeSize.width
	self.nodeHeight = nodeSize.height
	self.nodeEffect = SoraDCreatAnimationEx("eventCrazyNewEffect", nil, true)
	self.nodeEffect:addTo(self.contentNode, 9)
	self.nodeEffect:setPosition(150, 64)
end
function eventCrazyGiftSingle:init(data)
	self.giftId = data.recommendId
	self.iconGift:setSpriteFrame(data.recommendPicture)
	if data.recommendDescribe then
		self.textGiftDescribe:ignoreContentAdaptWithSize(true)
		self.textGiftDescribe:setTextAreaSize(cc.size(0, 0))
		self.textGiftDescribe:setString(i18n(data.recommendDescribe))
		if self.textGiftDescribe:getContentSize().width > 250 then
			SoraDGetAutoHeightLabel(self.textGiftDescribe, 250)
		end
		self.iconJump:setPositionX(SoraDFPosX(self.textGiftDescribe:getContentSize().width / 2 + self.nodeWidth / 2 + 15, self.nodeWidth))
	end
	self.nodeEffect:setVisible(false)
	if self.giftId then
		self.textMore:setVisible(false)
		self.nodeGift:setVisible(true)
	else
		self.textMore:setVisible(true)
		self.nodeGift:setVisible(false)
	end
end
function eventCrazyGiftSingle:showAction(data)
	self.nodeEffect:setVisible(true)
	if data.recommendPicture == "bg_qcz_img_01.png" then
		SoraDGetChildByName(self.nodeEffect, "Node_1"):setVisible(false)
		SoraDGetChildByName(self.nodeEffect, "Node_2"):setVisible(true)
	elseif self:checkIsVipBg(data.recommendPicture) then
		SoraDGetChildByName(self.nodeEffect, "Node_1"):setVisible(true)
		SoraDGetChildByName(self.nodeEffect, "Node_2"):setVisible(false)
	else
		SoraDGetChildByName(self.nodeEffect, "Node_1"):setVisible(false)
		SoraDGetChildByName(self.nodeEffect, "Node_2"):setVisible(false)
	end
end
function eventCrazyGiftSingle:hideAction()
	self.nodeEffect:setVisible(false)
end
function eventCrazyGiftSingle:setScroll(scroll)
	self.scroll = scroll
end
function eventCrazyGiftSingle:getNodeWidth()
	return self.nodeWidth
end
function eventCrazyGiftSingle:getNodeHeight()
	return self.nodeHeight
end
function eventCrazyGiftSingle:setContentScale(scale)
	self.contentNode:setScale(scale)
end
function eventCrazyGiftSingle:setContentOffset(offsetX, offsetY)
	if offsetX then
		self.contentNode:setPositionX(self.nodeWidth / 2 + offsetX)
	end
	if offsetY then
		self.contentNode:setPositionY(self.nodeHeight / 2 + offsetY)
	end
end
function eventCrazyGiftSingle:setNodeSize(size)
	self.nodeWidth = size.width
	self.nodeHeight = size.height
	self.nodeEffect:setScale(size.width / 300)
	self.iconGift:setScale(size.width / 224)
	self.nodeEffect:setPosition(size.width / 2, size.height / 2)
end
function eventCrazyGiftSingle:setContentOpacity(opacity)
	if not self.contentNode:isCascadeOpacityEnabled() then
		self.contentNode:setCascadeOpacityEnabled(true)
	end
	self.contentNode:setOpacity(opacity)
end
function eventCrazyGiftSingle:btnRechargeClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local giftInfo = rechargeltCtrl.getGiftConfigByIndex(self.giftId)
		if self.giftId then
			if giftInfo.jumpType == 2 and clientEventMgr.judgeIsOpen(giftInfo.activityID) then
				clientEventMgr.singleClickEvent(giftInfo.activityID)
			elseif giftInfo.jumpType == 1 then
				local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
				local giftInfo = rechargeActivityCtrl:getRechargeActivityData(self.giftId)
				if giftInfo then
					if GLOBAL_GAME_RECHARGE_MODE then
						if gRechargeActiveModelType.MONTHLYGIFT == giftInfo.category then
							_ENV = nil
							;(nil).toCategory = gRechargeCenterCategory.MONTH
							uiManager:show("rechargeView", nil)
						else
							_ENV = nil
							;(nil).rechargeID = self.giftId
							uiManager:show("rechargeView", nil)
						end
					else
						local panel = SoraDCreatePanel("rechargeView")
						if gRechargeActiveModelType.MONTHLYGIFT == giftInfo.category then
							panel:expect2SelectTabEx(gRechargeCenterCategory.MONTH, self.giftId)
						else
							panel:expect2SelectTabEx(gRechargeCenterCategory.LIMITGIFT, self.giftId)
						end
						panel:show()
					end
					paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD22)
				end
			elseif giftInfo.jumpType == 3 then
				local privilegeGiftRead = include("privilegeGiftRead")
				local curLv = privilegeGiftRead.getVipLvByRechargeID(self.giftId)
				uiManager:show("vipCenterView")
				_ENV = gRechargeCenterCategory.LIMITGIFT
				gRechargeCenterCategory.LIMITGIFT.curLv = curLv
				uiManager:show("vipPrivilegeGiftPopView", gRechargeCenterCategory.LIMITGIFT)
			elseif giftInfo.jumpType == 4 then
				if GLOBAL_GAME_RECHARGE_MODE then
					local rechargeID
					if princeGiftNewCtrl:getNewPrinceData() then
						rechargeID = princeGiftNewCtrl:getActiviyID()
					end
					_ENV = "vipPrivilegeGiftPopView"
					;("vipPrivilegeGiftPopView").rechargeID = rechargeID
					uiManager:show("rechargeView", "vipPrivilegeGiftPopView")
				else
					local panel = SoraDCreatePanel("rechargeView")
					if panel:isNewPriceGfitOpen() then
						panel:expect2SelectTab(gRechargeCenterCategory.LIMITGIFT, princeGiftNewCtrl:getActiviyID())
					end
					panel:show()
				end
				paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD22)
			end
		else
			if GLOBAL_GAME_RECHARGE_MODE then
				local rechargeID
				if princeGiftNewCtrl:getNewPrinceData() then
					rechargeID = princeGiftNewCtrl:getActiviyID()
				end
				_ENV = princeGiftNewCtrl:getActiviyID()
				princeGiftNewCtrl:getActiviyID().rechargeID = rechargeID
				uiManager:show("rechargeView", princeGiftNewCtrl:getActiviyID())
			else
				local panel = SoraDCreatePanel("rechargeView")
				if panel:isNewPriceGfitOpen() then
					panel:expect2SelectTab(gRechargeCenterCategory.LIMITGIFT, princeGiftNewCtrl:getActiviyID())
				end
				panel:show()
			end
			paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD22)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function eventCrazyGiftSingle:checkIsVipBg(bgName)
	_UPVALUE6_ = nil
	;(nil)[1] = "bg_qcz_img_02.png"
	;(nil)[2] = "bg_qcz_img_03.png"
	;(nil)[3] = "bg_qcz_img_04.png"
	;(nil)[4] = "bg_qcz_img_05.png"
	;(nil)[5] = "bg_qcz_img_06.png"
	local (nil)[6], vipBgList = "bg_qcz_img_07.png", nil
	for _, name in pairs(vipBgList) do
		if name == bgName then
			return true
		end
	end
end
return eventCrazyGiftSingle
