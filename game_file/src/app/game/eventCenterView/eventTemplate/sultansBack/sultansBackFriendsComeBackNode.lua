local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackFriendsComeBackNode = class("sultansBackFriendsComeBackNode", function(target)
	local target = SoraDCreateBasePanel("sultansBackFriendsComeBackNode")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackFriendsComeBackNode:onEnterPanel()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
function sultansBackFriendsComeBackNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.SULTAN_BACK_FRIEND_COMEBACK
	self:initWidget()
	self:addEffect()
	self:addBtnEffect()
end
function sultansBackFriendsComeBackNode:addEffect(...)
	local effectBack = SoraDCreatAnimation("Node_Effect_hygl01", nil, true)
	self.effectBack = effectBack
	effectBack:setPosition(cc.p(320, 360))
	self.Image_back:setLocalZOrder(-2)
	self.Bottom_Node:addChild(effectBack, -1)
end
function sultansBackFriendsComeBackNode:addBtnEffect()
	local effectbtn = SoraDCreatAnimation("Node_Effect_hygl02", nil, true)
	self.effectbtn = effectbtn
	effectbtn:setPosition(cc.p(108, 36))
	self.Button_receive:addChild(effectbtn)
end
function sultansBackFriendsComeBackNode:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.TextField_code:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	self.TextField_code:setPlaceHolder(i18n("common_text_1068"))
	self.TextField_code:setPlaceHolderColor(cc.c3b(185, 185, 185))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.Button_receive:addTouchEventListener(handler(self, self.btnReceiveClick))
	print("slkdjfklsjflksd", display.height)
	if display.height < 1000 then
		if display.height < 860 then
			self.Node_box:setPositionY(self.Node_box:getPositionY() - 40)
		end
		self.bg_hghl_ipad2:setVisible(false)
	elseif display.height > 1136 then
		local offsety = display.height - 1136
		local iSize = self.Image_back:getContentSize()
		self.Image_back:setContentSize(cc.size(iSize.width, iSize.height + offsety + 200))
		self.Node_box:setPositionY(self.Node_box:getPositionY() + offsety / 2)
	end
	self.Text_des:setString(i18n("friend_back_text06"))
	SoraDSetTextWidthHeight(self.Text_des, cc.size(400, 60))
	self:changeToEditBox()
end
function sultansBackFriendsComeBackNode:changeToEditBox()
	if self.TextField_code then
		local size = self.TextField_code:getContentSize()
		local pos = cc.p(self.TextField_code:getPositionX(), self.TextField_code:getPositionY())
		local ap = self.TextField_code:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		editBox:setMaxLength(15)
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(self.TextField_code:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
		if device.platform ~= "mac" then
			editBox:setTextHorizontalAlignment(SoraDFLabelR())
		end
		editBox:setPlaceHolder(i18n("friend_back_text07"))
		editBox:setPlaceholderFontColor(cc.c3b(170, 170, 170))
		editBox:setPlaceholderFontSize(28)
		self.TextField_code:removeFromParent()
		self.TextField_code = editBox
	end
end
function sultansBackFriendsComeBackNode:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function sultansBackFriendsComeBackNode:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
	end
end
function sultansBackFriendsComeBackNode:setParentView(parent)
	self.parentView = parent
end
function sultansBackFriendsComeBackNode:initData()
	self:initActivityTime()
	self.friendsData = sultansBackCtrl:getFriendComeBackData()
	local rewards = sultansBackRead.getFriendBackReward()
	for i, v in ipairs(rewards) do
		local award = SoraDCreatePanel("commonItemAward")
		award:addTo(self.Node_rewards)
		award:setOwnView(self.parentView)
		award:initData(v.id, v.count)
		award:setPosition(0, 0)
		award:setScale(0.8)
	end
	SoraDToCenter(self.Node_rewards, 110, SoraDFIsRA())
	self:refreshBtnState()
end
function sultansBackFriendsComeBackNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_FRIENDSCOMEBACK_REFRESH", function()
		SoraDCloseLoading(self)
		self.friendsData = sultansBackCtrl:getFriendComeBackData()
		self:refreshBtnState()
	end)
end
function sultansBackFriendsComeBackNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, nil, SoraDFIsRA())
	else
		self.Node_time:setVisible(false)
	end
end
function sultansBackFriendsComeBackNode:btnReceiveClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local enterCode = self.TextField_code:getText()
		if enterCode == "" then
			SoraDShowMsgTip(i18n("common_text_1068"))
		else
			sultansBackCtrl:reqFriendsComeBackReward(enterCode)
			SoraDShowLoading(self)
		end
	end
end
function sultansBackFriendsComeBackNode:refreshBtnState()
	self.Button_receive:setEnabled(not self.friendsData.inviterRewardFlag)
	self.Button_receive:setBright(not self.friendsData.inviterRewardFlag)
	self.Button_receive:setTitleText(not self.friendsData.inviterRewardFlag and i18n("common_text_1146") or i18n("common_text_1892"))
	self.Node_none:setVisible(not self.friendsData.inviterRewardFlag)
	self.text_inviter:setVisible(self.friendsData.inviterRewardFlag)
	if self.friendsData.inviterRewardFlag then
		_ENV = nil
		;(nil).num = self.friendsData.inviterKid
		;(nil).lord = self.friendsData.inviterName
		self.text_inviter:setString(i18n("reurn_text_11", nil))
		self.effectbtn:setVisible(false)
	end
end
return sultansBackFriendsComeBackNode
