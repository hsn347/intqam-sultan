local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatRoomReName = class("chatRoomReName", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("chatRoomReName")
	end
	return target
end)
function chatRoomReName:ctor()
	self.isHaveTextField = true
	self.imgBg1 = SoraDGetChildByName(self, "Image_bg1")
	self.imgBg1:setFillType(1)
	self.labelName = SoraDGetChildByName(self, "Text_Name")
	self.btnRename = SoraDGetChildByName(self, "Button_ReName")
	self.btnRename:setTitleText(i18n("common_text_2148"))
	self.tfdRename = SoraDGetChildByName(self, "TextField_rename")
	self.tfdRename:setPlaceHolder(i18n("common_text_2149"))
	self.tfdRename:setTextColor(cc.c4b(0, 0, 0, 255))
	self.tfdRename:setPlaceHolderColor(cc.c3b(170, 170, 170))
	self.tfdRename:setMaxLength(20)
	self.imgTip = SoraDGetChildByName(self, "image_tip")
	self.imgTip:setVisible(false)
	if self.btnRename then
		self.btnRename:addTouchEventListener(handler(self, self.btnRenameClickCallBack))
	end
	self.labelName:setString(i18n("common_text_2148"))
	self.tfdRename:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdRename:addEventListener(handler(self, self.OnInputChangeEnd))
end
function chatRoomReName:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_MODIFY_NAME_SUCCESS", handler(self, self.sMsgModifyNameSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_MODIFY_NAME_FAILED", handler(self, self.sMsgModifyNameFailed))
end
function chatRoomReName:sMsgModifyNameSuccess(target, data)
	SoraDCloseLoading(self.btnRename)
	self:close(nil, ccui.TouchEventType.ended)
end
function chatRoomReName:sMsgModifyNameFailed(target, data)
	SoraDCloseLoading(self.btnRename)
end
function chatRoomReName:nickNameErr(target, data)
end
function chatRoomReName:setBtnState(canUse)
	self.btnRename:setTouchEnabled(canUse)
	self.btnRename:setBright(canUse)
end
function chatRoomReName:updateView()
	local returnName = self.tfdRename:getString()
	local nameLen = string.utf8len(returnName)
	self.imgTip:setVisible(true)
	local ok, err = chatroomCtrl:checkName(returnName)
	if ok then
		self.imgTip:loadTexture("icon_yes.png", ccui.TextureResType.plistType)
		self:setBtnState(true)
	else
		self.imgTip:loadTexture("icon_no.png", ccui.TextureResType.plistType)
		self:setBtnState(false)
	end
end
function chatRoomReName:initWithData(data)
	self.itemData = data
	self:setBtnState(false)
end
function chatRoomReName:OnInputChangeEnd(textField, eventType)
	self.imgTip:setVisible(false)
	local returnName = textField:getString()
	local nameLen = string.utf8len(returnName)
	self:updateView()
end
function chatRoomReName:btnRenameClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local newName = self.tfdRename:getString()
		local loading = SoraDShowLoading(self.btnRename, self.btnRename:getContentSize())
		if loading.loadingImg then
			loading.loadingImg:setScale((self.btnRename:getContentSize().height - 15) / loading.loadingImg:getContentSize().height)
		end
		loading:setPosition(cc.p(self.btnRename:getContentSize().width / 2, self.btnRename:getContentSize().height / 2))
		chatroomCtrl:reqChatRoomModifyName(self.itemData.crid, newName)
	elseif type == ccui.TouchEventType.began then
		self:updateView()
	end
end
return chatRoomReName
