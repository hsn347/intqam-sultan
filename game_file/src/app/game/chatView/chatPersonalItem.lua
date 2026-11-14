local gametop = gModuleMgr.getObject("gametop")
local chatCoverMgr = gChatMgrs:getMgr("chatCoverMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatDataParser = include("chatDataParser")
local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
local mailCtrl = SoraDGetCtrl("mailCtrl")
local chatPersonalItem = class("chatPersonalItem", function(target)
	local size = target:getContentSize()
	return include("baseView").new(size, false, target)
end)
function chatPersonalItem:ctor()
	self.contenWidth = 400
	self.itemWidth = 425
	self.maxMoveWidth = 235
	self.deltaX = 0
	self.offsetX = 0
	self.judgeHMove = 2 * TOUCH_MOVED_ERROR_VALUE
	self.judgeVMove = 2 * TOUCH_MOVED_ERROR_VALUE
	self.itemIsMoved = false
	self.deleteIsMoved = false
	self.isMoveV = false
	self.isMoveH = false
	self.layout_item = SoraDGetChildByName(self, "layout_item")
	self.layout_item:setSwallowTouches(false)
	self.layout_item:addTouchEventListener(handler(self, self.onLayoutItem))
	self.btnDelete = SoraDGetChildByName(self, "btnDelete")
	self.btnDelete:setSwallowTouches(false)
	self.btnDelete:addTouchEventListener(handler(self, self.btnDeleteClick))
	self.btnSetTop = SoraDGetChildByName(self, "btnSetTop")
	self.btnSetTop:setSwallowTouches(false)
	self.btnSetTop:addTouchEventListener(handler(self, self.btnSetTopClick))
	self.panelItem = SoraDGetChildByName(self, "layout_item")
	self.nodeCommonHead = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead")
	self.redIcon = SoraDGetChildByName(self, "img_number")
	self.setTopIcon = SoraDGetChildByName(self, "icon_Top")
	self.textRedNum = SoraDGetChildByName(self.redIcon, "label_number")
	self.textTitle = SoraDGetChildByName(self, "label_title")
	self.text_content = SoraDGetChildByName(self, "text_content")
	SoraDChangeTextToHtml(self.text_content)
	self.text_vip = SoraDGetChildByName(self, "text_vip")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.textTime = SoraDGetChildByName(self, "label_time")
end
function chatPersonalItem:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_VIEW_MAIL_SUCCESS", handler(self, self.refreshRedIcon))
end
function chatPersonalItem:initData(data, otherData)
	self.itemData = data
	self.scrollView = otherData.scroll
	self.parentView = otherData.view
	self.chatDelegate = otherData.chatDelegate
	self.key = data.key
	self.chatChannel = data.chatChannel
	self.target = data.target
	local imageId = "head_m_001.png"
	local avatar = ""
	if data.chatChannel == gChatChannel.CHATROOM then
		imageId = "icon_mail_group.png"
	else
		imageId = tonumber(data.customData.playerInfo.iconID)
		avatar = data.customData.playerInfo.avatar
	end
	if imageId == nil then
		imageId = "head_m_001.png"
	end
	self.nodeCommonHead:setHeadSprite(imageId, avatar)
	local date = SoraDConvertTimeToDate(data.date, false, true)
	self.textTime:setString(date)
	self.textTitle:setString(chatDataParser.getChatMailTitle(data))
	self:updateContent()
	self:refreshRedIcon(self, data)
	self:reset(true)
	local iconName = chatCoverMgr:isSetTop(self.key) and "btn_yjyh_zd_qx_02.png" or "btn_yjyh_zd_01.png"
	self.btnSetTop:loadTextures(iconName, iconName, iconName, ccui.TextureResType.plistType)
	self.setTopIcon:setVisible(not not chatCoverMgr:isSetTop(self.key))
end
function chatPersonalItem:updateContent()
	local width = self:updateContent_VipAndName()
	local summary = self.itemData.content
	if self.itemData.dataType == gChatDataType.dataType_emotion then
		summary = i18n("common_text_2869") or "[emoji]"
	elseif self.itemData.dataType == gChatDataType.dataType_audio then
		summary = i18n("common_text_2054") or "[audio]"
	end
	summary = self:trimText(summary)
	local _
	summary, _ = SoraDConvertOmissionText(self.contenWidth - width, summary, 21, nil, true)
	self.text_content:setPositionX(SoraDFPosX(-width, 0))
	self.text_content:setString(summary)
end
function chatPersonalItem:trimText(textContent)
	local trimedStr = string.trim(textContent)
	trimedStr = string.gsub(trimedStr, "\n", ",")
	trimedStr = RemoveStringSpecial(trimedStr)
	return trimedStr
end
function chatPersonalItem:refreshRedIcon(target, data)
	if data.key and data.key == self.key then
		local redInfo = chatCoverMgr:getNumInfoByKey(data.key)
		print("chatPersonalItem:refreshRedIcon", data.key, redInfo.newNum)
		if redInfo and redInfo.newNum and redInfo.newNum > 0 then
			self.redIcon:setVisible(true)
			self.textRedNum:setString(redInfo.newNum)
		else
			self.redIcon:setVisible(false)
		end
	end
end
function chatPersonalItem:updateContent_VipAndName()
	local content = self.itemData
	local width = 0
	if self.chatChannel == gChatChannel.CHATROOM then
		if content.isVip == false then
			self.text_vip:setVisible(false)
		else
			local vipLocalData = include("vipLocalData")
			local vipLv = content.vipLv or 0
			local vipNum, isSVip = vipLocalData:getVipNum(vipLv)
			self.text_vip:setVisible(true)
			self.text_vip:setPositionX(0)
			self.text_vip:setString(vipLocalData:getVipSmallFntChar(vipLv))
			width = self.text_vip:getContentSize().width * self.text_vip:getScale()
		end
		local abbr = content.alliance
		local nickName = content.nickName
		local strName = nickName
		strName = content.name
		if content.kid ~= nil then
			local currentKid = gametop.playertop_:getKingdomID()
			if content.kid ~= currentKid then
				strName = strName .. "#" .. content.kid
			end
		end
		if strName == nil then
			strName = ""
		end
		strName = strName .. ":"
		print("strName", strName, width)
		self.text_name:setVisible(true)
		self.text_name:setString(strName)
		self.text_name:setPositionX(SoraDFPosX(-width, 0))
		width = width + self.text_name:getContentSize().width
	else
		self.text_vip:setVisible(false)
		self.text_name:setVisible(false)
	end
	return width
end
function chatPersonalItem:onLayoutItem(target, event)
	if event == ccui.TouchEventType.ended then
		self.isMoveV = false
		self.isMoveH = false
		if self.deltaX > 0 then
			if self.deltaX >= self.maxMoveWidth / 3 then
				if self.deltaX < self.maxMoveWidth then
					local offsetX = -(self.maxMoveWidth - self.deltaX)
					self:doEaseMove(self.layout_item, offsetX)
					self.deltaX = 0
				end
				self.btnDelete:setTouchEnabled(true)
				self.btnDelete:setSwallowTouches(false)
				self.btnSetTop:setTouchEnabled(true)
			elseif self.deltaX < self.maxMoveWidth / 3 then
				local offsetX = self.deltaX
				self:doEaseMove(self.layout_item, offsetX)
				self.offsetX = 0
				self.deltaX = 0
				self.btnSetTop:setTouchEnabled(false)
				self.btnDelete:setTouchEnabled(false)
				self.parentView:setCurrentOperateData(nil)
			end
			return
		end
		if self.itemIsMoved then
			self.itemIsMoved = false
			return
		end
		if self.scrollView and not SoraDIsNodeVisibleOnScroll(target, self.scrollView) then
			return
		end
		SoraDPlaySound()
		self.chatDelegate:hidePersonalList(true)
		self.redIcon:setVisible(false)
		dump(self.itemData, "self.itemData")
		if self.chatChannel == gChatChannel.CHATROOM then
			self.chatDelegate:resetContentInit(self.chatChannel)
			_ENV = self.chatChannel
			self.chatChannel.chatChannel = self.chatChannel
			self.chatChannel.key = self.key
			self.chatChannel.tab = self.chatChannel
			self.chatChannel.target = self.itemData.target
			self.chatChannel.titleName = self.itemData.serverMsg.chatroom.crName
			self.chatDelegate:init(self.chatChannel)
			_ENV = self.chatDelegate.init
			self.chatDelegate.init.chatChannel = self.chatChannel
			self.chatDelegate.init.chatSet = gChatSet.TOTAL
			self.chatDelegate.init.key = self.key
			local self.chatDelegate.init.target, param = self.itemData.target, self.chatDelegate.init
			chatSendMgr:requestHistory(param)
			_ENV = chatSendMgr
			chatSendMgr.msg = "MESSAGE_CHAT_CHANGE_CHAT_CHANEL"
			chatSendMgr.chatChannel = self.chatChannel
			SoraDSendMessage(chatSendMgr)
		else
			self.chatDelegate:resetContentInit(self.chatChannel)
			_ENV = self.chatChannel
			self.chatChannel.chatChannel = self.chatChannel
			self.chatChannel.tab = self.chatChannel
			self.chatChannel.key = self.key
			self.chatChannel.chatSet = gChatSet.TOTAL
			self.chatChannel.target = self.itemData.target
			self.chatChannel.titleName = textParser.formatPlayerName(self.itemData.customData.playerInfo.allianceAbbr, self.itemData.customData.playerInfo.nickName)
			self.chatDelegate:init(self.chatChannel)
			_ENV = self.chatDelegate.init
			self.chatDelegate.init.chatChannel = self.chatChannel
			self.chatDelegate.init.chatSet = gChatSet.TOTAL
			local self.chatDelegate.init.key, param = self.key, self.chatDelegate.init
			chatSendMgr:requestHistory(param)
			_ENV = chatSendMgr
			chatSendMgr.msg = "MESSAGE_CHAT_CHANGE_CHAT_CHANEL"
			chatSendMgr.chatChannel = self.chatChannel
			SoraDSendMessage(chatSendMgr)
		end
		self:reset()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.itemIsMoved = true
		end
		local touchDeltaX = touchBeganPoint.x - touchmovePoint.x
		local touchDeltaY = touchBeganPoint.y - touchmovePoint.y
		if self.isMoveH == false and self.isMoveV == false then
			if math.abs(touchDeltaX) >= self.judgeHMove and self.isMoveV == false and math.abs(touchDeltaY) < self.judgeVMove then
				self.isMoveH = true
				self.layout_item:setSwallowTouches(true)
			end
			if math.abs(touchDeltaX) < self.judgeHMove and math.abs(touchDeltaY) >= self.judgeVMove and self.isMoveH == false then
				self.isMoveV = true
			end
		elseif self.isMoveH == true then
			local deltaX = touchDeltaX + self.offsetX
			if deltaX < 0 then
				deltaX = 0
			end
			if deltaX > self.maxMoveWidth then
				deltaX = self.maxMoveWidth
			end
			self.deltaX = deltaX
			self.layout_item:setPositionX(-deltaX)
		elseif self.isMoveV == true then
			return
		end
	elseif event == ccui.TouchEventType.canceled then
		self.itemIsMoved = false
		self.layout_item:setSwallowTouches(false)
		self.isMoveV = false
		self.isMoveH = false
		if self.deltaX > 0 then
			if self.deltaX >= self.maxMoveWidth / 3 then
				if self.deltaX < self.maxMoveWidth then
					local offsetX = -(self.maxMoveWidth - self.deltaX)
					self:doEaseMove(self.layout_item, offsetX)
					self.deltaX = 0
				end
				self.btnSetTop:setTouchEnabled(true)
				self.btnDelete:setTouchEnabled(true)
			elseif self.deltaX < self.btnDelete:getContentSize().width / 3 then
				self:reset()
				self.offsetX = 0
				self.deltaX = 0
				self.btnSetTop:setTouchEnabled(false)
				self.btnDelete:setTouchEnabled(false)
				self.parentView:setCurrentOperateData(nil)
			end
			return
		end
	elseif event == ccui.TouchEventType.began then
		self.itemIsMoved = false
		self.layout_item:stopAllActions()
		self.offsetX = 0
		if self.scrollView and not SoraDIsNodeVisibleOnScroll(target, self.scrollView, event) then
			return
		end
		self.btnSetTop:setTouchEnabled(false)
		self.btnDelete:setTouchEnabled(false)
		if self.parentView:getCurrentOperateData() ~= nil then
			self.parentView:getCurrentOperateData():reset(true)
			self.parentView:setCurrentOperateData(nil)
		end
		self.parentView:setCurrentOperateData(self)
	end
end
function chatPersonalItem:btnDeleteClick(target, event)
	if not target:isTouchEnabled() then
		return
	end
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:reset(true)
		if self.chatChannel == gChatChannel.CHATROOM then
			_UPVALUE1_ = true
			;(true)[1] = self.itemData.serverMsg
			SoraDGetCtrl("chatroomCtrl"):reqChatRoomDelCover(true)
		else
			SoraDGetCtrl("mailCtrl"):removeMailList(gMailSetType.CHAT, self.key)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.deleteIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.deleteIsMoved = false
	end
end
function chatPersonalItem:btnSetTopClick(target, event)
	if not target:isTouchEnabled() then
		return
	end
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:reset(true)
		if self.chatChannel == gChatChannel.CHATROOM then
			if chatCoverMgr:isSetTop(self.key) then
				_ENV = self.key
				self.key.crid = self.target
				chatroomCtrl:reqCancelChatTop(self.key)
				chatCoverMgr:setTopInfoByKey(self.key, nil)
			else
				_ENV = self.key
				self.key.crid = self.target
				chatroomCtrl:reqSetChatTop(self.key)
			end
		elseif chatCoverMgr:isSetTop(self.key) then
			_ENV = self.key
			self.key.key = self.key
			mailCtrl:reqCancelChatTop(self.key)
			chatCoverMgr:setTopInfoByKey(self.key, nil)
		else
			_ENV = self.key
			self.key.key = self.key
			mailCtrl:reqSetChatTop(self.key)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.deleteIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.deleteIsMoved = false
	end
end
function chatPersonalItem:reset(ignoreAnim)
	if self.layout_item:getPositionX() == 0 then
		return
	end
	if ignoreAnim then
		self.layout_item:stopAllActions()
		self.layout_item:setPositionX(0)
		self.deltaX = 0
		return
	end
	local deltaX = -self.layout_item:getPositionX()
	print("deltaX", deltaX)
	self:doEaseMove(self.layout_item, deltaX)
	self.deltaX = 0
end
function chatPersonalItem:doEaseMove(itemNode, deltaX)
	itemNode:stopAllActions()
	local deltaX2 = deltaX / math.abs(deltaX) * 25
	local speed = 1000
	local acTime1 = math.abs(deltaX + deltaX2) / speed
	local moveBy1 = cca.moveBy(acTime1, deltaX + deltaX2, 0)
	local easeAct1 = cc.EaseOut:create(moveBy1, 1.0)
	local actTime2 = math.abs(deltaX2) / speed
	local moveBy2 = cca.moveBy(actTime2, -deltaX2, 0)
	local easeAct2 = cc.EaseOut:create(moveBy2, 1.0)
	_UPVALUE2_ = 1.0
	;(1.0)[1] = easeAct1
	;(1.0)[2] = easeAct2
	local seq = cc.Sequence:create(1.0)
	itemNode:runAction(seq)
end
return chatPersonalItem
