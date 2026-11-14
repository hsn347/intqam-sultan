local gametop = gModuleMgr.getObject("gametop")
local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local worldMapDefine = include("worldMapDefine")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local worldMapWarDef = include("worldMapWarDef")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local heroJailShareView = class("heroJailShareView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroJailShareView")
	end
	return target
end)
function heroJailShareView:ctor()
	self:initWidget()
end
function heroJailShareView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REQ_ALL_CHAT_ROOM_INFO", function(target, data)
		contactCtrl:reqGetData(true, false, false)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", function(target, data)
		self:initData(self.mapData)
		SoraDCloseLoading(self)
		self:sortData()
		self:initScroll()
	end)
end
function heroJailShareView:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.tableCheckBox, _ENV, self.totalData, _ENV = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget
	self.confirmTag = 0
	self.Text_select:setString(i18n("position_share_04"))
	self.Button_confirm = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_gold")
	self.Button_confirm:addTouchEventListener(handler(self, self.btnConfirmClickCallBack))
	_ENV = handler(self, self.btnConfirmClickCallBack)
	handler(self, self.btnConfirmClickCallBack).title = i18n("common_text_533")
	handler(self, self.btnConfirmClickCallBack).gold = 50
	self.Button_confirm:initData(handler(self, self.btnConfirmClickCallBack))
	SoraDSetGray(self.Button_confirm, self.confirmTag ~= 0)
	self.Button_confirm:setTouchEnabled(self.confirmTag ~= 0)
	chatroomCtrl:reqChatRoomAllInfo(20)
	SoraDShowLoading(self)
	self.Text_whatsapp:setString("WhatsApp")
	SoraDToCenter(self.Node_whatsapp)
	self.Text_facebook:setString("FaceBook")
	SoraDToCenter(self.Node_facebook)
	self.Button_whatsapp:addTouchEventListener(handler(self, self.onClick_Button_Whatsapp))
	self.Button_facebook:addTouchEventListener(handler(self, self.onClick_Button_FaceBook))
end
function heroJailShareView:initData(heroJailInfo, otherLordInfo)
	if not heroJailInfo then
		return
	end
	dump(heroJailInfo, "heroJailShareView:initData")
	self.heroJailInfo = heroJailInfo
	dump(otherLordInfo, "lordInfo", 10)
	self.otherLordInfo = otherLordInfo
end
function heroJailShareView:sortData()
	local _ENV, dataKindom
	dataKindom.channel = gChatChannel.KINGDOM
	table.insert(self.totalData, dataKindom)
	if allianceMgr:hasJoinAlliance() then
		local _ENV, dataAlliance = allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance()
		dataAlliance.channel = gChatChannel.ALLIANCE
		table.insert(self.totalData, dataAlliance)
	end
	local chatRoomList = chatroomCtrl:getAllChatRoomInfo()
	local friendList = contactCtrl:getContactList()
	if chatRoomList and next(chatRoomList) then
		for _, v in ipairs(chatRoomList) do
			v.channel = gChatChannel.CHATROOM
			table.insert(self.totalData, v)
		end
	end
	table.sort(friendList, function(l, r)
		return l.totalFc > r.totalFc
	end)
	for k, v in pairs(friendList) do
		v.uid = tonumber(k)
		if not chatCtrl:isShield(v.uid) then
			v.channel = gChatChannel.MAIL
			table.insert(self.totalData, v)
		end
	end
end
function heroJailShareView:initScroll()
	self.ScrollView_1:removeAllChildren()
	local scrollH = math.max(self.ScrollView_1:getContentSize().height, #self.totalData * 90)
	self.ScrollView_1:setInnerContainerSize(cc.size(self.ScrollView_1:getContentSize().width, scrollH))
	dump(self.totalData, "skdfsljdflsjdfkldsj")
	for i, v in ipairs(self.totalData) do
		local cell = self.Node_single:clone()
		local Node_head = SoraDGetChildByName(cell, "Node_head")
		local Sprite_kingdom = SoraDGetChildByName(cell, "Sprite_kingdom")
		local Sprite_head = SoraDGetChildByName(Node_head, "Sprite_head")
		local Text_one_select = SoraDGetChildByName(cell, "Text_one_select")
		local CheckBox = SoraDGetChildByName(cell, "CheckBox")
		CheckBox:addEventListener(handler(self, self.btnChioceClickCallBack))
		CheckBox:setSelected(false)
		cell:setPosition(self.ScrollView_1:getContentSize().width / 2, scrollH - (i - 1) * 90)
		cell:addTo(self.ScrollView_1)
		if v.channel == 1 or v.channel == 2 then
			Node_head:setVisible(false)
			Sprite_kingdom:setVisible(true)
			Sprite_kingdom:setSpriteFrame(v.channel == 1 and "icon_position_world.png" or "icon_position_alliance.png")
			Text_one_select:setString(v.channel == 1 and i18n("common_text_070") or i18n("common_text_946"))
		elseif v.crid then
			Node_head:setVisible(false)
			Sprite_kingdom:setVisible(true)
			Text_one_select:setString(v.crName)
			Sprite_kingdom:setSpriteFrame("icon_position_chat.png")
		else
			Node_head:setVisible(true)
			Sprite_kingdom:setVisible(false)
			SoraDGetHeadFromManager(Sprite_head, v.headid, v.avatar)
			Text_one_select:setString(v.name)
		end
		CheckBox:setTag(i)
		table.insert(self.tableCheckBox, CheckBox)
	end
end
function heroJailShareView:btnConfirmClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not SoraDEnoughGold(50, true) then
			return
		end
		local subType, targetid, roomCrid
		for i, v in ipairs(self.totalData) do
			if v.crid and self.confirmTag == i then
				roomCrid = v.crid
				break
			elseif v.uid and self.confirmTag == i then
				targetid = v.uid
				break
			end
		end
		_ENV, self.confirmTag = self.totalData[self.confirmTag].channel, self.totalData[self.confirmTag].channel
		self.totalData[self.confirmTag].channel.heroID = self.heroJailInfo.heroID
		self.totalData[self.confirmTag].channel.ownerUid = self.heroJailInfo.ownerUid
		self.totalData[self.confirmTag].channel.channel = self.confirmTag
		self.totalData[self.confirmTag].channel.crid = roomCrid
		local self.totalData[self.confirmTag].channel.targetUid, shareData = targetid, self.totalData[self.confirmTag].channel
		heroJailCtrl:reqPrisionShareHero(shareData)
		self:removeFromParent()
	end
end
function heroJailShareView:btnChioceClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected or type == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		for i, v in ipairs(self.tableCheckBox) do
			v:setSelected(button:getTag() == v:getTag())
		end
		self.confirmTag = button:getTag()
		print("slkdjfksldjflskdjf1111", button:getTag())
		SoraDSetGray(self.Button_confirm, self.confirmTag ~= 0)
		self.Button_confirm:setTouchEnabled(self.confirmTag ~= 0)
	end
end
function heroJailShareView:getShareUrl(source)
	local lordInfo = self.otherLordInfo
	if lordInfo.abbr and lordInfo.abbr ~= "" then
		_ENV = nil
		;(nil).name = lordInfo.base.nickName
		;(nil).abbr = lordInfo.abbr
		if i18n("common_text_186", nil) then
			goto lbl_21
		end
	end
	local showName = lordInfo.base.nickName
	::lbl_21::
	local invCode = SoraDGetCtrl("accountExtCtrl"):getAccountInviteCode()
	local nickName = string.urlencode(SoraDGetCtrl("lordInfoCtrl"):getBaseInfo().nickName)
	if type(source) == "number" then
		local cInfo = include("gameInviteltCtrl").getPlatformByVersion(source)
		source = cInfo.platform or ""
	end
	local channel = userSDKManager.getChannel()
	local language = SoraDGetDefaultLanguage() or ""
	local reUrl = ""
	local comUrl = "https://h5share.onemtshare.com/koh/herocapture/?lang=%s&code=%s&id=%s&name=%s&source=%s&kid=%s&timestamp=%s"
	if device.platform == "mac" or userSDKManager.isBeta() then
		comUrl = "https://testh5share.onemtshare.com/koh/herocapture/?lang=%s&code=%s&id=%s&name=%s&source=%s&kid=%s&timestamp=%s"
	end
	reUrl = string.format(comUrl, language, invCode, "" .. self.heroJailInfo.heroID, showName, source, "" .. self.heroJailInfo.ownerKid, "" .. math.floor(socket:gettime()))
	return reUrl
end
function heroJailShareView:onClick_Button_FaceBook(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentUrl = self:getShareUrl("facebook")
		print(contentUrl)
		if device.platform == "mac" then
			device.openURL(contentUrl)
		end
		_ENV = nil
		;(nil).channel = gSDKDef.shareChannel.facebook
		userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_begin, nil)
		userSDKManager.shareFacebookLinkContent(contentUrl)
	end
end
function heroJailShareView:onClick_Button_Whatsapp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local contentUrl = self:getShareUrl("whatsapp")
		print(contentUrl)
		if device.platform == "mac" then
			device.openURL(contentUrl)
		end
		_ENV = nil
		;(nil).channel = gSDKDef.shareChannel.whatsapp
		userSDKManager.logEvent(gSDKDef.TDonEvent.hero_share_begin, nil)
		userSDKManager.shareWhatsappLinkContent(contentUrl)
	end
end
return heroJailShareView
