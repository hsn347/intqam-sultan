local gametop = gModuleMgr.getObject("gametop")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local allianceDesRead = include("allianceDesRead")
local chatRoomPlayerAvatar = class("chatRoomPlayerAvatar", function(target)
	if target == nil then
		return ccui.Layout:create()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatRoomPlayerAvatar:ctor()
	local layoutWidth = 100
	local layoutHeight = 120
	self.singleIsMoved = false
	self.imgPlayerBg = ccui.ImageView:create("frame_mailinfo_18.png", ccui.TextureResType.plistType)
	self.imgPlayerBg:setAnchorPoint(cc.p(0.5, 0))
	self.imgPlayerBg:setContentSize(cc.size(90, 90))
	self.imgPlayerBg:setPosition(cc.p(layoutWidth / 2, 30))
	self.imgPlayerBg:ignoreContentAdaptWithSize(false)
	self.imgPlayerBg:addTo(self, 1)
	self.imgPlayer = ccui.ImageView:create("head_m_001.png", ccui.TextureResType.plistType)
	self.imgPlayer:setContentSize(cc.size(72, 72))
	self.imgPlayer:setPosition(cc.p(50, 75))
	self.imgPlayer:ignoreContentAdaptWithSize(false)
	self.imgPlayer:addTo(self, 0)
	self.btnPlayer = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.btnPlayer:setAnchorPoint(cc.p(0.5, 0))
	self.btnPlayer:setPressedActionEnabled(false)
	self.btnPlayer:ignoreContentAdaptWithSize(false)
	self.btnPlayer:setContentSize(cc.size(90, 90))
	self.btnPlayer:setPosition(cc.p(layoutWidth / 2, 30))
	self.btnPlayer:addTo(self, 2)
	if self.btnPlayer then
		self.btnPlayer:setSwallowTouches(false)
		self.btnPlayer:addTouchEventListener(handler(self, self.btnPlayerEvent))
	end
	local text_name = ccui.Text:create()
	text_name:setString("")
	text_name:setFontSize(20)
	text_name:setName("text_name")
	text_name:setColor(cc.c3b(82, 58, 38))
	text_name:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	text_name:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	text_name:setAnchorPoint(cc.p(0.5, 0.5))
	text_name:ignoreContentAdaptWithSize(false)
	text_name:setContentSize(cc.size(100, 30))
	text_name:setPosition(cc.p(layoutWidth / 2, 15))
	self:addChild(text_name)
	self.text_name = text_name
	self.itemWidth = layoutWidth
	self.itemHeight = layoutHeight
	self:setAnchorPoint(SoraDFAP(1.0, 0))
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.imgDel = ccui.ImageView:create("icon_mail_delete_02.png", ccui.TextureResType.plistType)
	self.imgDel:setAnchorPoint(cc.p(0.5, 0.5))
	self.imgDel:setPosition(SoraDFPoint(self.itemWidth - 20, self.itemHeight - 10, self.itemWidth))
	self.imgDel:setContentSize(cc.size(41, 41))
	self.imgDel:ignoreContentAdaptWithSize(false)
	self.imgDel:addTo(self, 5)
	self.imgDel:setVisible(false)
	self.isInDelMode = false
end
function chatRoomPlayerAvatar:initWithData(data)
	self.itemData = data
	local playerId = data.playerId
	local imgPlayer = data.imgPlayer
	local nickName = data.nickName or ""
	local imageId = data.imageId
	local avatar = data.avatar
	self.playerId = playerId
	self.chatType = data.chatType
	self.imgPlayer.curlKey = nil
	print("imageId = ", imageId, ", avatar = ", avatar)
	SoraDGetHeadFromManager(self.imgPlayer, imageId, avatar)
	if self.text_name then
		self.text_name:setString(nickName)
	end
	if self.imgDel then
		self.imgDel:setVisible(false)
	end
	if self.itemData.isInDelMode == true then
		self:enterDelMode()
	else
		self:leaveDelMode()
	end
end
function chatRoomPlayerAvatar:getItemWidth()
	return self.itemWidth
end
function chatRoomPlayerAvatar:getItemHeight()
	return self.itemHeight
end
function chatRoomPlayerAvatar:btnPlayerEvent(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		print("点击了头像!!!!")
		SoraDPlaySound()
		if self.isInDelMode == true then
			dump(self.scrollView.itemsData, "self.scrollView.itemsData<")
			if #self.scrollView.itemsData <= 5 then
				SoraDShowMsgBox(i18n("common_text_4594"), i18n("common_text_204"), nil, function(msgType)
					if MSGBOX_CALLBACK_YES == msgType then
						_ENV = nil
						;(nil).crid = self.scrollView.itemData.crid
						chatroomCtrl:reqDismissChat(nil)
					end
				end)
				return
			end
			print("删除某个成员出聊天室, id = ", self.playerId)
			local crid = self.scrollView.itemData.crid
			_ENV, chatroomCtrl = self.playerId, "删除某个成员出聊天室, id = "
			self.playerId.uid = self.playerId
			local ("删除某个成员出聊天室, id = ")[1], members = self.playerId, "删除某个成员出聊天室, id = "
			chatroomCtrl:reqChatRoomDelMembers(crid, members)
		else
			print("不做任何操作")
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatRoomPlayerAvatar:setScrollView(scrollView)
	self.scrollView = scrollView
end
function chatRoomPlayerAvatar:enterDelMode()
	self.imgDel:setVisible(true)
	self.isInDelMode = true
end
function chatRoomPlayerAvatar:leaveDelMode()
	self.imgDel:setVisible(false)
	self.isInDelMode = false
end
return chatRoomPlayerAvatar
