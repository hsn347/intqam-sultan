local gametop = gModuleMgr.getObject("gametop")
local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
local contactCtrl = SoraDGetCtrl("contactCtrl")
local worldMapDefine = include("worldMapDefine")
local chatCtrl = SoraDGetCtrl("chatCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local worldMapWarDef = include("worldMapWarDef")
local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroJailSharePanel = class("HeroJailSharePanel", baseFguiPanel)
function HeroJailSharePanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroJailSharePanel:ctor", self.viewName)
end
function HeroJailSharePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroJailSharePanel:onInit()
	print("=======HeroJailSharePanel:onInit")
	self.totalData, _ENV = print, print
	self.confirmTag = 0
	if not self.proxy.param.heroJailInfo then
		_ENV = self.proxy.param.heroJailInfo
	end
	self.heroJailInfo = self.proxy.param.heroJailInfo
	if not self.proxy.param.otherLordInfo then
		_ENV = self.proxy.param.otherLordInfo
	end
	self.otherLordInfo = self.proxy.param.otherLordInfo
	self.fields.Panel_bg:setString(i18n("position_share_04"))
	self.fields.Button_Cost:addClickListener(handler(self, self.btnConfirmClickCallBack))
	self.fields.Button_Cost:setString(i18n("common_text_533"))
	self.fields.Button_Cost:setCost(gIDDef.GOLD, 50)
	self.fields.Button_ShareW:setString("WhatsApp")
	self.fields.Button_ShareF:setString("FaceBook")
	self.fields.Button_ShareW:addClickListener(handler(self, self.onClick_Button_Whatsapp))
	self.fields.Button_ShareF:addClickListener(handler(self, self.onClick_Button_FaceBook))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:addClickListener(handler(self, self.onItemClick))
end
function HeroJailSharePanel:onShow()
	print("=======HeroJailSharePanel:onShow")
	self:updateButtonCost()
	chatroomCtrl:reqChatRoomAllInfo(20)
	SoraDShowLoading(self)
end
function HeroJailSharePanel:sortData()
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
function HeroJailSharePanel:initScroll()
	self.fields.List:setNumItems(#self.totalData)
end
function HeroJailSharePanel:updateButtonCost()
	self.fields.Button_Cost:setEnabled(self.confirmTag ~= 0)
end
function HeroJailSharePanel:onItemRender(index, target)
	target:initData(self.totalData[index + 1])
end
function HeroJailSharePanel:onItemClick()
	SoraDPlaySound()
	local selectIndex = self.fields.List:getSelectedIndex() + 1
	local isSelect = self.fields.List:getChildAt(selectIndex - 1):isTickSelect()
	self.confirmTag = isSelect and selectIndex or 0
	self.confirmTag = isSelect and selectIndex or 0
	self:updateButtonCost()
end
function HeroJailSharePanel:btnConfirmClickCallBack()
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
	local channel = self.totalData[self.confirmTag].channel
	_ENV = self.confirmTag
	self.confirmTag.heroID = self.heroJailInfo.heroID
	self.confirmTag.ownerUid = self.heroJailInfo.ownerUid
	self.confirmTag.channel = channel
	self.confirmTag.crid = roomCrid
	local self.confirmTag.targetUid, shareData = targetid, self.confirmTag
	heroJailCtrl:reqPrisionShareHero(shareData)
	self:removeFromParent()
end
function HeroJailSharePanel:onClick_Button_FaceBook()
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
function HeroJailSharePanel:onClick_Button_Whatsapp()
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
function HeroJailSharePanel:getShareUrl(source)
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
return HeroJailSharePanel
