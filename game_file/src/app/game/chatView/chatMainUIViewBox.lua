local mailFunctions = include("mailFunctions")
local chatDataParser = include("chatDataParser")
local chatFunctions = include("chatFunctions")
local gametop = gModuleMgr.getObject("gametop")
local translateCtrl = gametop.playertop_:getModule("translateCtrl")
local settingCtrl = gametop.playertop_:getModule("settingCtrl")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local mainUIDef = include("mainUIDef")
_ENV = "mainUIDef"
;("mainUIDef").limitWidth = display.width * math.max(1, 1136 / display.height) - 160
;("mainUIDef").vipLocalizedOn = false
local ("mainUIDef").fontSize, _defaultParam = 18, "mainUIDef"
local chatMainUIViewBox = class("chatMainUIViewBox", function(target)
	return SoraDCreateBasePanel("chatMainUIViewBox")
end)
function chatMainUIViewBox:ctor()
	self.chatType = 0
	self.chatChannel = gChatTypeDef.chat_kingDom_type
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	print("display.width=====", display.width, display.width * math.max(1, 1136 / display.height), _defaultParam.limitWidth)
	self.layout_content:setContentSize(cc.size(_defaultParam.limitWidth + 90, 40))
	self.text_content = SoraDGetChildByName(self, "text_content")
	if G_IS_UNITY then
		self.text_content = SoraDChangeTextToHtmlFgui(self.text_content)
		SoraDSetupEmojies(self.text_content)
	else
		SoraDChangeTextToHtml(self.text_content)
	end
	self.text_vip = SoraDGetChildByName(self, "text_vip")
	self.img_vip = SoraDGetChildByName(self, "icon_font_ar")
	self.text_ar = SoraDGetChildByName(self, "BitmapFontLabel_vip_ar")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.img_content = SoraDGetChildByName(self, "img_content")
	self.text_equip = SoraDGetChildByName(self, "text_equip")
	local text_at = self.text_name:clone()
	text_at:addTo(self.text_name:getParent())
	text_at:setName("text_at")
	text_at:setColor(display.COLOR_RED)
	text_at:setString(i18n("chat_text_76"))
	self.text_at = text_at
	local isAR = SoraDFIsRA()
	if not _defaultParam.vipLocalizedOn then
		isAR = false
	end
	if isAR then
		_UPVALUE2_ = _defaultParam.vipLocalizedOn
		self.text_vip_ar, _defaultParam.vipLocalizedOn[1] = _defaultParam.vipLocalizedOn, self.img_vip
		self.text_vip_ar, _defaultParam.vipLocalizedOn[2] = _defaultParam.vipLocalizedOn, self.text_ar
	else
		_UPVALUE2_ = _defaultParam.vipLocalizedOn
		self.text_vip_ar, _defaultParam.vipLocalizedOn[1] = _defaultParam.vipLocalizedOn, self.text_ar
		self.text_vip_ar, _defaultParam.vipLocalizedOn[2] = _defaultParam.vipLocalizedOn, self.img_vip
	end
	self:showDefaultTip()
end
function chatMainUIViewBox:initGroup()
end
function chatMainUIViewBox:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_UPDATE_CHAT_BOX", handler(self, self.onUpdateChatBox))
	SoraDAddMessage(self, "MESSAGE_CHAT_TRANSLATION_CHANGED", handler(self, self.msgOnTranslationChanged))
	SoraDAddMessage(self, "MESSAGE_CHAT_CHANGE_CHAT_CHANEL", handler(self, self.msgOnChanelChange))
	SoraDAddMessage(self, "MESSAGE_CHAT_UNREAD_AT_UPDATE", handler(self, self.onUpdateUnreadAt))
end
function chatMainUIViewBox:getHeadWidth(showNodes)
	local totalWidth = 0
	for i, v in ipairs(showNodes) do
		if v == self.text_vip_ar then
			for _k, _v in ipairs(self.text_vip_ar) do
				totalWidth = totalWidth + _v:getContentSize().width * _v:getScaleX()
			end
		else
			totalWidth = totalWidth + v:getContentSize().width * v:getScaleX()
		end
		if v == self.text_name then
			totalWidth = totalWidth + 10
		elseif v == self.text_vip or v == self.text_vip_ar then
			totalWidth = totalWidth + 5
		end
	end
	return totalWidth
end
function chatMainUIViewBox:reArrangeNodes(showNodes, hideNodes)
	local contentWidth = self.layout_content:getContentSize().width
	local totalWidth = 0
	if showNodes == nil then
		showNodes, _ENV = nil, nil
	end
	for _, v in ipairs(showNodes) do
		local x = totalWidth
		local y = 20
		if v == self.text_vip_ar then
			for _k, _v in ipairs(self.text_vip_ar) do
				x = totalWidth
				_v:setVisible(true)
				_v:setAnchorPoint(SoraDFAP(1, 0.5))
				_v:setPosition(SoraDFPoint(contentWidth - x, y, contentWidth))
				totalWidth = totalWidth + _v:getContentSize().width * _v:getScaleX() + 2
			end
		else
			v:setAnchorPoint(SoraDFAP(1, 0.5))
			v:setPosition(SoraDFPoint(contentWidth - x, y, contentWidth))
			v:setVisible(true)
			totalWidth = totalWidth + v:getContentSize().width * v:getScaleX() + 2
		end
		if v == self.text_name then
			totalWidth = totalWidth + 10
		elseif v == self.text_vip or v == self.text_vip_ar then
			totalWidth = totalWidth + 5
		end
	end
	if hideNodes == nil then
		hideNodes, _ENV = ipairs(showNodes)
	end
	for _, v in ipairs(hideNodes) do
		if v == self.text_vip_ar then
			for _, _v in ipairs(self.text_vip_ar) do
				_v:setVisible(false)
			end
		else
			v:setVisible(false)
		end
	end
end
function chatMainUIViewBox:initWithData(data)
	local chatChannel = data.chatChannel
	self.chatChannel = chatChannel
	self.chatSet = gChatSet.TOTAL
	if chatChannel == nil then
		print("聊天 初始化失败")
		return
	end
	local contentData
	if chatChannel == gChatChannel.KINGDOM then
		contentData = chatDataMgr:getKingdomData(gChatSet.TOTAL)
	elseif chatChannel == gChatChannel.ALLIANCE then
		contentData = chatDataMgr:getAllianceData(gChatSet.TOTAL)
	elseif chatChannel == gChatChannel.MAIL or chatChannel == gChatChannel.CHATROOM then
		if not chatDataMgr:getChatChannelInfo() then
			local _ENV, info = chatDataMgr:getChatChannelInfo(), chatDataMgr:getChatChannelInfo()
		end
		local key = info.key
		contentData = chatDataMgr:getData(chatChannel, gChatSet.TOTAL, key)
	else
		contentData = chatDataMgr:getData(chatChannel, gChatSet.TOTAL)
	end
	if contentData and 1 <= #contentData then
		local showContent
		for k, v in ipairs(contentData) do
			local isShieldData = self:isShieldData(v)
			if not isShieldData and v.dataType ~= gChatDataType.dataType_date then
				showContent = contentData[k]
				break
			end
		end
		if showContent == nil then
			self:showDefaultTip()
		else
			_ENV = ipairs(contentData)
			ipairs(contentData).chatChannel = self.chatChannel
			ipairs(contentData).chatSet = self.chatSet
			ipairs(contentData).content = showContent
			self:updateData(ipairs(contentData))
		end
	else
		self:showDefaultTip()
	end
end
function chatMainUIViewBox:getChatChannel()
	return self.curData and self.curData.chatChannel or self.chatChannel
end
function chatMainUIViewBox:getTextContent(data)
	local content = data.content
	local textContent = content.content
	if content.isShowTranslate then
		local tl = settingCtrl:getTranslateLanguage()
		if content.translation.tText ~= nil and content.translation.tText[tl] ~= nil then
			textContent = content.translation.tText[tl].text or content.content
		end
	end
	textContent = textContent or "undefined"
	if not content.isSysMsg then
		textContent = string.htmlspecialchars(textContent)
	end
	return textContent
end
function chatMainUIViewBox:trimText(textContent)
	local trimedStr = string.trim(textContent)
	trimedStr = string.gsub(trimedStr, "\n", ",")
	trimedStr = RemoveStringSpecial(trimedStr)
	return trimedStr
end
function chatMainUIViewBox:updateContent_VipAndName(data, showNodes, hideNodes)
	local chatChannel = data.chatChannel
	local content = data.content
	local isAR = SoraDFIsRA()
	if not _defaultParam.vipLocalizedOn then
		isAR = false
	end
	local chatCtrl = SoraDGetCtrl("chatCtrl")
	if not chatDataMgr:getChatChannelInfo() then
		local _ENV, info = chatDataMgr:getChatChannelInfo(), chatDataMgr:getChatChannelInfo()
	end
	if chatCtrl:getUnreadAtSelfMsg(self.chatChannel, info.target) > 0 then
		table.insert(showNodes, #showNodes + 1, self.text_at)
	else
		table.insert(hideNodes, #hideNodes + 1, self.text_at)
	end
	if content.isVip == false then
		if not isAR then
			table.insert(hideNodes, #hideNodes + 1, self.text_vip)
		else
			table.insert(hideNodes, #hideNodes + 1, self.text_vip_ar)
		end
	else
		local vipLocalData = include("vipLocalData")
		local vipLv = content.vipLv or 0
		local vipNum, isSVip = vipLocalData:getVipNum(vipLv)
		self.text_vip:setVisible(not isAR)
		self.img_vip:setVisible(isAR)
		self.text_ar:setVisible(isAR)
		if isAR then
			local img = vipLocalData:getVipImg(vipLv)
			self.img_vip:loadTexture(img, ccui.TextureResType.plistType)
			self.img_vip:setScale(0.85)
			self.text_ar:setString(vipNum)
			table.insert(showNodes, #showNodes + 1, self.text_vip_ar)
		else
			self.text_vip:setString(vipLocalData:getVipSmallFntChar(vipLv))
			table.insert(showNodes, #showNodes + 1, self.text_vip)
		end
	end
	local abbr = content.alliance
	local nickName = content.nickName
	local strName = nickName
	if chatChannel ~= gChatChannel.ALLIANCE then
		strName = mailFunctions:getWrappedName(abbr, nickName)
	end
	if chatChannel == gChatChannel.KINGDOM and content.kid ~= nil then
		local currentKid = gametop.playertop_:getKingdomID()
		if content.kid ~= currentKid then
			strName = strName .. "#" .. content.kid
		end
	end
	if strName == nil then
		strName = ""
	end
	strName = strName .. ":"
	self.text_name:setString(strName)
	table.insert(showNodes, #showNodes + 1, self.text_name)
end
function chatMainUIViewBox:updateContent_Text(data, showNodes, hideNodes)
	print("chatMainUIViewBox=======666")
	local textContent = self:getTextContent(data)
	local trimedStr = self:trimText(textContent)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize, nil, true)
	print("retString=====", retString, _defaultParam.limitWidth, headWidth, _defaultParam.limitWidth - headWidth)
	self.text_content:setString(retString)
	table.insert(showNodes, #showNodes + 1, self.text_content)
	table.insert(hideNodes, #hideNodes + 1, self.img_content)
	table.insert(hideNodes, #hideNodes + 1, self.text_equip)
end
function chatMainUIViewBox:updateContent_Audio(data, showNodes, hideNodes)
	local retString = i18n("common_text_2054") or "[audio]"
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	table.insert(showNodes, #showNodes + 1, self.text_content)
	table.insert(hideNodes, #hideNodes + 1, self.img_content)
	table.insert(hideNodes, #hideNodes + 1, self.text_equip)
end
function chatMainUIViewBox:updateContent_sharePos(data, showNodes, hideNodes)
	local textContent = self:getTextContent(data)
	local trimedStr = self:trimText(textContent)
	local content = data.content
	local customData = content.customData
	local color = cc.c3b(0, 190, 30)
	local posStr
	if (not customData.values or not customData.values) and not customData.data.content then
		local _ENV, info = customData.data.content, customData.data.content
	end
	if worldMapDefine.isWarKingdomID(info.mapId) then
		local worldMapWarDef = include("worldMapWarDef")
		local name = worldMapWarDef.getKingdomNameByKid(info.mapId) or ""
		posStr = string.format("（%s,X:%d,Y:%d）", name, info.x, info.y)
	else
		posStr = string.format("（K:%d,X:%d,Y:%d）", info.mapId, info.x, info.y)
	end
	self.text_equip:setString(posStr)
	self.text_equip:setColor(color)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		self.img_content:loadTexture("icon_zbfx_dw.png", ccui.TextureResType.plistType)
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
	end
end
function chatMainUIViewBox:updateContent_Equip(data, showNodes, hideNodes)
	local textContent = self:getTextContent(data)
	local trimedStr = self:trimText(textContent)
	local content = data.content
	local customData = content.customData
	local equipDesRead = include("equipDesRead")
	local eid = customData.eid
	local quality = customData.qly
	local equipName = equipDesRead.getName(eid)
	local color = equipDesRead.getAttrColor(quality)
	self.text_equip:setString(equipName)
	self.text_equip:setColor(color)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	if retString == trimedStr then
		local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
		if 20 <= remainWidth then
			local retEquipString, label = SoraDConvertOmissionText(remainWidth, equipName, _defaultParam.fontSize)
			self.text_equip:setString(retEquipString)
			table.insert(showNodes, #showNodes + 1, self.text_content)
			table.insert(showNodes, #showNodes + 1, self.text_equip)
			table.insert(hideNodes, #hideNodes + 1, self.img_content)
		else
			table.insert(showNodes, #showNodes + 1, self.text_content)
			table.insert(hideNodes, #hideNodes + 1, self.text_equip)
			table.insert(hideNodes, #hideNodes + 1, self.img_content)
		end
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
	end
end
function chatMainUIViewBox:updateContent_Emotion(data, showNodes, hideNodes)
	local retString = i18n("common_text_2869") or "[emoji]"
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	table.insert(showNodes, #showNodes + 1, self.text_content)
	table.insert(hideNodes, #hideNodes + 1, self.img_content)
	table.insert(hideNodes, #hideNodes + 1, self.text_equip)
end
_ENV, chatMainUIViewBox.updateContent_RedPacket = function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end, function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end
;(function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end)[gChatDataType.dataType_emotion] = chatMainUIViewBox.updateContent_Emotion
;(function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end)[gChatDataType.dataType_audio] = chatMainUIViewBox.updateContent_Audio
;(function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end)[gChatDataType.dataType_equip_create] = chatMainUIViewBox.updateContent_Equip
;(function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end)[gChatDataType.dataType_equip_share] = chatMainUIViewBox.updateContent_Equip
;(function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end)[gChatDataType.dataType_red_packet] = chatMainUIViewBox.updateContent_RedPacket
;(function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end)[gChatDataType.dataType_drop_box] = chatMainUIViewBox.updateContent_RedPacket
local (function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end)[gChatDataType.dataType_pos_share], specialFuncMap = chatMainUIViewBox.updateContent_sharePos, function(self, data, showNodes, hideNodes)
	local content = data.content
	_ENV = nil
	;(nil).name = ""
	local retString = i18n("common_text_1788", nil)
	if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		_ENV = nil
		;(nil).name = ""
		retString = i18n("treasureChest_text_28", nil)
	end
	local trimedStr = self:trimText(retString)
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(_defaultParam.limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	local remainWidth = _defaultParam.limitWidth - headWidth - self.text_content:getContentSize().width
	if 40 <= remainWidth then
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(showNodes, #showNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
		if content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
			self.img_content:loadTexture("icon_recharge_wallet_02.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
			self.img_content:loadTexture("8355.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
			self.img_content:loadTexture("8579.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
			self.img_content:loadTexture("frame_9001687_bxjnh_libao2.png", ccui.TextureResType.plistType)
		elseif content.customData and content.customData.redPacketInfo and content.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			self.img_content:loadTexture("icon_tjbx_bx06.png", ccui.TextureResType.plistType)
		else
			self.img_content:loadTexture("icon_redpacket_bag_02.png", ccui.TextureResType.plistType)
		end
		self.img_content:ignoreContentAdaptWithSize(true)
		local scale = self.img_content:getContentSize().height / 40
		local imgSize = self.img_content:getContentSize()
		self.img_content:ignoreContentAdaptWithSize(false)
		self.img_content:setContentSize(cc.size(imgSize.width / scale, imgSize.height / scale))
	else
		table.insert(showNodes, #showNodes + 1, self.text_content)
		table.insert(hideNodes, #hideNodes + 1, self.img_content)
		table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	end
end
function chatMainUIViewBox:isShieldData(content)
	local ret = false
	if content then
		_ENV = nil
		;(nil).byUID = true
		local level = SoraDConfigGet("Game:chat:castleLv~integer", nil)
		local castleLv = content.serverMsg and content.serverMsg.castleLv
		if castleLv and level > castleLv and not content.isSelf then
			ret = true
		end
		_ENV = nil
		;(nil).byUID = true
		local starLevel = SoraDConfigGet("Game:chat:castleStarLv~integer", nil)
		local starLv = content.serverMsg and content.serverMsg.starLv
		if starLv and starLevel > starLv and not content.isSelf then
			ret = true
		end
		local isForbiddenMessage = (not (content.serverMsg and content.serverMsg.content) or not content.serverMsg.content.is_adv) and (not content.data or not content.data.is_adv) and (not content.customData or not content.customData.is_adv) and content.customData and content.customData.data and content.customData.data.is_adv
		if isForbiddenMessage then
			local playerId = content.playerId or content.from or content.sender or content.user and content.user.uid or 0
			local isSelfMessage = chatFunctions.getIsPlayerSelf(playerId)
			if not isSelfMessage then
				ret = true
			end
		end
	end
	return ret
end
function chatMainUIViewBox:updateData(data)
	local chatChannel = data.chatChannel
	local content = data.content
	local chatSet = data.chatSet
	local isShield = self:isShieldData(content)
	print("chatMainUIViewBox=======111", isShield)
	if chatSet ~= nil and chatSet ~= gChatSet.TOTAL then
		return
	end
	print("chatMainUIViewBox=======222")
	local dirty = false
	if not worldMapDefine.isInNebulaAllStar() and self.chatChannel == gChatChannel.ALLIANCE and chatChannel == gChatChannel.TEAM then
		dirty = true
	end
	if not isShield and (chatChannel == self.chatChannel or dirty) then
		self.curData = content
		if content == nil then
			self:showDefaultTip()
			return
		end
		print("chatMainUIViewBox=======333")
		local _ENV, showNodes = print, print
		local _ENV, hideNodes = "chatMainUIViewBox=======333", "chatMainUIViewBox=======333"
		self:updateContent_VipAndName(data, showNodes, hideNodes)
		local updateContentFunc = specialFuncMap[content.dataType]
		if updateContentFunc then
			print("chatMainUIViewBox=======444")
			updateContentFunc(self, data, showNodes, hideNodes)
		else
			print("chatMainUIViewBox=======555")
			self:updateContent_Text(data, showNodes, hideNodes)
		end
		self:reArrangeNodes(showNodes, hideNodes)
	end
end
function chatMainUIViewBox:showTrialChatTips(content)
	local textContent = "chatInfoType:" .. content.chatInfoType
	local trimedStr = string.trim(textContent)
	trimedStr = string.gsub(trimedStr, "\n", ",")
	local headWidth = self:getHeadWidth(showNodes)
	local retString, label = SoraDConvertOmissionText(limitWidth - headWidth, trimedStr, _defaultParam.fontSize)
	self.text_content:setString(retString)
	self.text_name = content.nickName
	table.insert(showNodes, #showNodes + 1, self.text_content)
	table.insert(showNodes, #hideNodes + 1, self.text_name)
	table.insert(hideNodes, #hideNodes + 1, self.text_vip)
	table.insert(hideNodes, #hideNodes + 1, self.img_content)
	table.insert(hideNodes, #hideNodes + 1, self.text_equip)
end
function chatMainUIViewBox:showDefaultTip()
	local _ENV, showNodes
	local _ENV, hideNodes
	self.text_content:setString(i18n("common_text_543"))
	table.insert(showNodes, #showNodes + 1, self.text_content)
	table.insert(hideNodes, #hideNodes + 1, self.text_vip)
	table.insert(hideNodes, #hideNodes + 1, self.text_vip_ar)
	table.insert(hideNodes, #hideNodes + 1, self.text_name)
	table.insert(hideNodes, #hideNodes + 1, self.img_content)
	table.insert(hideNodes, #hideNodes + 1, self.text_equip)
	table.insert(hideNodes, #hideNodes + 1, self.text_at)
	self:reArrangeNodes(showNodes, hideNodes)
	self.curData = nil
end
function chatMainUIViewBox:onUpdateChatBox(target, data)
	self:updateData(data)
end
function chatMainUIViewBox:onUpdateUnreadAt(target, data)
	_UPVALUE0_ = nil
	;(nil).chatChannel = self.chatChannel
	;(nil).chatSet = self.chatSet
	;(nil).content = self.curData
	self:updateData(nil)
end
function chatMainUIViewBox:msgOnTranslationChanged(target, data)
	local chatChannel = data.chatChannel
	local translationList = data.translationList
	local isAutoTranslate = data.isAutoTranslate
	local isShowTranslate = data.isShowTranslate
	if chatChannel ~= self.chatChannel then
		return
	end
	if not self.curData then
		return
	end
	local isFound = false
	for i, v in ipairs(translationList) do
		if v.chatId == self.curData.chatId then
			isFound = true
			self.curData.translation = v
			if isShowTranslate ~= nil then
				self.curData.isShowTranslate = isShowTranslate
			end
			break
		end
	end
	print("isFound = ", isFound)
	if not isFound then
		return
	end
	local contentData
	if chatChannel == gChatChannel.KINGDOM then
		contentData = chatDataMgr:getKingdomData(gChatSet.TOTAL)
	elseif chatChannel == gChatChannel.ALLIANCE then
		contentData = chatDataMgr:getAllianceData(gChatSet.TOTAL)
	end
	if contentData == nil then
		return
	end
	print("isAutoTranslate = ", isAutoTranslate)
	if 1 <= #contentData then
		print("开始刷新chatmainuiviewbox")
		_ENV = isAutoTranslate
		isAutoTranslate.chatChannel = self.chatChannel
		isAutoTranslate.chatSet = self.chatSet
		isAutoTranslate.content = contentData[1]
		isAutoTranslate.isAutoTranslate = isAutoTranslate
		isAutoTranslate.isShowTranslate = isShowTranslate
		self:updateData(isAutoTranslate)
	end
end
function chatMainUIViewBox:msgOnChanelChange(target, data)
	if self.chatChannel == gChatChannel.MAIL or self.chatChannel == gChatChannel.CHATROOM then
		_ENV = nil
		;(nil).chatChannel = data.chatChannel
		self:initWithData(nil)
	end
end
return chatMainUIViewBox
