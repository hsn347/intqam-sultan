local friendsCallbackRead = include("friendsCallbackRead")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local honorBackNode = class("honorBackNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackNode")
	end
	return target
end)
function honorBackNode:ctor()
	self:initWidget()
end
function honorBackNode:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	_UPVALUE3_ = self
	self[1] = "ar"
	self[2] = "en"
	self[3] = "ko"
	local icon = SoraDGetImageNameByLang("bg_hyhg_%s.png", self)
	self.Sprite_welcome:setSpriteFrame(icon)
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(100)
	nodeFireL:addTo(self.Node_fire_L)
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(100)
	nodeFireR:addTo(self.Node_fire_R)
	self.oldSize = self.Panel_cut:getContentSize()
	if SoraDFIsRA() then
		self.Node_input:setPositionX(320)
		self.Node_input_en:setPositionX(-320)
		SoraDGetAllChildFromWidget(self.Node_input, self)
	else
		self.Node_input:setPositionX(-320)
		self.Node_input_en:setPositionX(320)
		SoraDGetAllChildFromWidget(self.Node_input_en, self)
	end
	self.TextField_input:setTextHorizontalAlignment(SoraDFLabelR())
	self.TextField_input:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.TextField_input:addEventListener(handler(self, self.onInputCode))
	self:changeToEditBox()
	self.Text_inviteKey:setString(i18n("common_text_974"))
	self.Text_notice:setString(i18n("reurn_text_09"))
	self.Button_receive:addTouchEventListener(handler(self, self.onClickBtnReceive))
	self.Button_receive:setBright(false)
	self.Button_receive:setTouchEnabled(false)
	self.Button_receive:setTitleText(i18n("common_text_1146"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_CALLBACK)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, 10, SoraDFIsRA())
	end
	self.rewardList = friendsCallbackRead.getInvitorGiftByLevel(SoraDGetCastleLv())
	local itemWidth = 94
	for k, v in ipairs(self.rewardList) do
		local item = SoraDCreatePanel("commonItemAward")
		item:setScale(0.8)
		item:setPosition(SoraDFSign(itemWidth * 3.5 - itemWidth * k), 0)
		item:setOwnView(self.Panel_cut)
		item:addTo(self.Node_items)
		item:initData(v.id, v.count)
		item:showCoolSquare()
	end
end
function honorBackNode:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_COMMIT_CODE", function(target, data)
		self:initData()
	end)
end
function honorBackNode:initData()
	if honorBackCtrl:isReceiveReturnGift() then
		self.Node_input:setVisible(false)
		self.Node_input_en:setVisible(false)
		self.Button_receive:setBright(false)
		self.Button_receive:setTouchEnabled(false)
		self.Button_receive:setTitleText(i18n("common_text_1892"))
		self.Node_showInvite:setVisible(true)
		local inviterInfo = honorBackCtrl:getInviterInfo()
		honorBackCtrl = i18n("common_text_1892")
		i18n("common_text_1892").num = inviterInfo.kid
		i18n("common_text_1892").lord = inviterInfo.nickName
		self.Text_inviterInfo:setString(i18n("reurn_text_11", i18n("common_text_1892")))
	else
		self.TextField_input:setPlaceHolder((i18n("reurn_text_10")))
		self.Node_input:setVisible(true)
		self.Node_input_en:setVisible(true)
		self.Node_showInvite:setVisible(false)
	end
end
function honorBackNode:setSize(size)
	self.Panel_cut:setContentSize(size)
	self.Top_Node:setPositionY(size.height)
	local offsety = math.max(0, self.oldSize.height - size.height)
	self.Sprite_bg:setPositionY(self.Sprite_bg:getPositionY() - offsety)
	if display.height >= 1036 and display.height <= 1236 then
		self.Sprite_bg:setPositionY(self.Sprite_bg:getPositionY() - 100)
	end
end
function honorBackNode:onInputCode(textField, eventType)
	if eventType == ccui.TextFiledEventType.detach_with_ime then
		self.input = textField:getString()
		if self.input and self.input ~= "" then
			dump(self.input, "self.inputself.input", 10)
			self.Button_receive:setBright(true)
			self.Button_receive:setTouchEnabled(true)
		end
	end
end
function honorBackNode:onClickBtnReceive(sender, event)
	if event == ccui.TouchEventType.ended then
		print("self.input", self.input)
		_ENV = self.input
		self.input.code = self.input
		honorBackCtrl:reqCommitInvalidCode(self.input)
	end
end
function honorBackNode:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		target:touchDownAction(target, type)
	end
end
function honorBackNode:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
		self.input = editBox:getText()
		if self.input and self.input ~= "" then
			dump(self.input, "self.inputself.input", 10)
			self.Button_receive:setBright(true)
			self.Button_receive:setTouchEnabled(true)
		end
	end
end
function honorBackNode:changeToEditBox()
	if self.TextField_input then
		_ENV = nil
		;(nil).func = handler(self, self.OnInputChangeByEditBoxEnd)
		local editBox = SoraDChangeToEditBox(self.TextField_input, nil)
		editBox:setMaxLength(15)
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		if device.platform ~= "mac" then
			editBox:setTextHorizontalAlignment(SoraDFLabelR())
		end
		editBox:setPlaceHolder(i18n("reurn_text_10"))
		editBox:setPlaceholderFontColor(cc.c3b(170, 170, 170))
		editBox:setPlaceholderFontSize(25)
		self.TextField_input = editBox
	end
end
return honorBackNode
