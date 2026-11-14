local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local gametop = gModuleMgr.getObject("gametop")
local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
local NebulaOfflcerDetailPop = class("NebulaOfflcerDetailPop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisPrivilegeDetailPop")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function NebulaOfflcerDetailPop:ctor()
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node_Grant")
	self.officeIcon = SoraDGetChildByName(self, "Sprite_Official_Icon")
	self.textUserName = SoraDGetChildByName(self, "Text_Name")
	self.nodeControls = SoraDGetChildByName(self, "Node_Controls")
	self.spDismiss = SoraDGetChildByName(self, "Sprite_Circle_Dismiss")
	self.btnDismiss = SoraDGetChildByName(self, "Button_Dismiss")
	self.TextDismiss = SoraDGetChildByName(self, "Text_Dismiss")
	self.btnMail = SoraDGetChildByName(self, "Button_Mail")
	self.textMail = SoraDGetChildByName(self, "Text_Mail")
	self.btnInfo = SoraDGetChildByName(self, "Button_Info")
	self.textInfo = SoraDGetChildByName(self, "Text_Info")
	self.nodeBuff = SoraDGetChildByName(self, "Node_Buff")
	self.buffNodes = SoraDGetChildsArrayByName(self, "Node_jiacheng_", 3, 1)
	self.textTips = SoraDGetChildByName(self, "text_Tips")
	self.textTips:setString(i18n("atlantiswar_privilege_text_0007"))
	self.btnOrder = SoraDGetChildByName(self, "Button_Order")
	self.btnOrder:setTitleText(i18n("common_text_687"))
	self.btnOrder:setVisible(false)
	self.btnOrder:addTouchEventListener(handler(self, self.btnOrderClick))
	self.btnDismiss:addTouchEventListener(handler(self, self.btnDismissClick))
	self.btnMail:addTouchEventListener(handler(self, self.btnMailClick))
	self.btnInfo:addTouchEventListener(handler(self, self.btnInfoClick))
	self.officeIcon:addTouchEventListener(handler(self, self.btnInfoClick))
	self.TextDismiss:setString(i18n("common_text_1297"))
	self.textMail:setString(i18n("chat_text_69"))
	self.textInfo:setString(i18n("common_text_002"))
end
function NebulaOfflcerDetailPop:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
end
function NebulaOfflcerDetailPop:init(officialInfo, officialUserInfo)
	self.warType = officialInfo.warType
	if self.warType and self.warType == gKingdomClassType.nebulaEmperor then
		self.officialID = officialInfo.officerID
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		self.isKing = nebulaEmperorCtrl:getIsSelfNebulaEmperor()
		self.limitList = officialInfo.limitList
		officialInfo = officialInfo.cfg
		if officialInfo.buffType == gLegendBuffType.KINGDOM then
			self.regionId = officialUserInfo or true
			self.textTips:setString("")
			self.textTips:setString(officialUserInfo)
		else
			self.textTips:setString(i18n("nebulaemperor_text_230"))
		end
	else
		self.officialID = officialInfo.officerID
		self.isKing = nebulaPrivilegeCtrl:isKing(officialInfo.appointID)
	end
	self.officialUserInfo = officialUserInfo
	self.nodeCommonPopBox:setSize(cc.size(552, 450))
	self.nodeCommonPopBox:setPositionY((self:getPanelOffsetHeight() - 450) / 2)
	if self.officialUserInfo then
		self.nodeControls:setVisible(true)
		self.textUserName:setVisible(true)
		self.btnOrder:setVisible(false)
		self.textTips:setVisible(false)
		if self.regionId then
			local nebulaWarRead = include("nebulaWarRead")
			local areaIcon = nebulaWarRead.getAreaIcon(self.regionId)
			self.officeIcon:loadTexture(areaIcon, ccui.TextureResType.plistType)
		else
			SoraDGetHeadFromManager(self.officeIcon, self.officialUserInfo.iconID, self.officialUserInfo.avatar)
		end
		self.officeIcon:setScale(0.5714285714285714)
		if self.warType and self.warType == gKingdomClassType.nebulaEmperor then
			local nebulaWarRead = include("nebulaWarRead")
			if self.regionId then
				local areaName = nebulaWarRead.getAreaName(self.regionId)
				self.textUserName:setString(areaName)
				self.spDismiss:setVisible(false)
			else
				local abbr = nebulaWarRead.getAreaAbbr(self.officialUserInfo.regionId)
				self.textUserName:setString(_G.textParser.formatPlayerName(abbr, self.officialUserInfo.nickname, self.officialUserInfo.kid))
				self.spDismiss:setVisible(self.isKing)
			end
		else
			self.textUserName:setString(_G.textParser.formatPlayerName(self.officialUserInfo.allianceAbbr, self.officialUserInfo.nickName, self.officialUserInfo.officerKid))
			self.spDismiss:setVisible(self.isKing and officialInfo.appointID ~= 0)
		end
		local uid = gametop.playertop_:getPlayerID()
		if self.warType and self.warType == gKingdomClassType.nebulaEmperor then
			if self.regionId or uid == self.officialUserInfo.uid then
				self:hideDownUI()
			end
		elseif uid == self.officialUserInfo.officerUid then
			self:hideDownUI()
		end
		if self.regionId then
			self.officeIcon:setTouchEnabled(false)
		else
			self.officeIcon:setTouchEnabled(true)
		end
	else
		self.nodeControls:setVisible(false)
		self.textUserName:setVisible(false)
		self.officeIcon:setTouchEnabled(false)
		self.textTips:setVisible(self.isKing)
		self.officeIcon:setScale(1)
		self.officeIcon:loadTexture(officialInfo.img, ccui.TextureResType.plistType)
		if not self.isKing then
			self:hideDownUI()
		else
			self.btnOrder:setVisible(true)
			SoraDGetChildByName(self, "Sprite_lace_t"):setVisible(true)
			SoraDGetChildByName(self, "Sprite_Line"):setVisible(true)
		end
	end
	self.nodeCommonPopBox:setTitleName(i18n(officialInfo.name))
	self:showBuffs(officialInfo.buff)
	SoraDToCenter(self.nodeControls, 70, true)
end
function NebulaOfflcerDetailPop:initData(itemData, officialID, isShowMode, showOfficialType, info)
	self.officialID = officialID
	self.showOfficialType = showOfficialType
	local _ENV, officialInfo
	if showOfficialType == gShowOfficialType.NEBULA_EMPEROR then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		officialInfo = nebulaEmperorRead.getOfficerConfig(self.officialID)
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		self.isKing = nebulaEmperorCtrl:getIsSelfNebulaEmperor()
		self.warType = gKingdomClassType.nebulaEmperor
	else
		officialInfo = nebulaPrivilegelRead.getOfficerInfo(self.officialID)
		self.isKing = nebulaPrivilegeCtrl:isKing(officialInfo.appointID)
	end
	self.nodeCommonPopBox:setSize(cc.size(552, 450))
	self.nodeCommonPopBox:setPositionY((self:getPanelOffsetHeight() - 450) / 2)
	self.spDismiss:setVisible(self.isKing)
	self.isShowMode = isShowMode
	self.officialUserInfo = itemData
	self.textUserName:setString(_G.textParser.formatPlayerName(info.abbr, self.officialUserInfo.nickName, self.officialUserInfo.kid))
	self.nodeControls:setVisible(not self.isShowMode)
	self.btnOrder:setVisible(self.isShowMode)
	self.btnOrder:setTitleText(i18n("common_btn_17"))
	self.nodeCommonPopBox:setTitleName(i18n(officialInfo.name))
	self:showBuffs(officialInfo.buff)
	self.textTips:setVisible(false)
	self.officeIcon:loadTexture(officialInfo.img, ccui.TextureResType.plistType)
	SoraDToCenter(self.nodeControls, 70, true)
	if self.isShowMode then
		if showOfficialType == lordInfoCtrl:getShowOfficialType() then
			self.textTips:setVisible(true)
			self.btnOrder:setVisible(false)
			self.textTips:setString(i18n("common_text_4361"))
		end
	else
		self:hideDownUI()
	end
	if showOfficialType == gShowOfficialType.NEBULA or showOfficialType == gShowOfficialType.NEBULA2 then
		self.officeIcon:setScale(0.7)
	end
end
function NebulaOfflcerDetailPop:hideDownUI()
	self.nodeControls:setVisible(false)
	self.btnOrder:setVisible(false)
	self.nodeCommonPopBox:setSize(cc.size(552, 350))
	self.nodeCenter:setPositionY(125.0)
	self.nodeCommonPopBox:setPositionY((self:getPanelOffsetHeight() - 350) / 2)
	SoraDGetChildByName(self, "Sprite_lace_t"):setVisible(false)
	SoraDGetChildByName(self, "Sprite_Line"):setVisible(false)
end
function NebulaOfflcerDetailPop:showBuffs(buffList)
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
	end
	for i, bufferId in ipairs(buffList) do
		local buffDes = ""
		if self.warType and self.warType == gKingdomClassType.nebulaEmperor then
			local nebulaEmperorRead = include("nebulaEmperorRead")
			buffDes = nebulaEmperorRead.getBufferName(bufferId)
		else
			buffDes = nebulaPrivilegelRead.getBufferName(bufferId)
		end
		if self.buffNodes[i] then
			self.buffNodes[i]:setVisible(true)
			SoraDGetChildByName(self.buffNodes[i], "text_buff"):setString(buffDes)
		end
	end
	SoraDToVerticalCenter(self.nodeBuff, 60)
end
function NebulaOfflcerDetailPop:btnDismissClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.officialUserInfo then
			if self.warType and self.warType == gKingdomClassType.nebulaEmperor then
				local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
				nebulaEmperorCtrl:reqCancelLordTitle(self.officialID)
			else
				nebulaPrivilegeCtrl:sendDismiss(self.officialUserInfo.officerUid)
			end
			self:close(nil, ccui.TouchEventType.ended)
		end
	end
end
function NebulaOfflcerDetailPop:btnMailClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.officialUserInfo then
			_ENV = self.officialUserInfo
			self.officialUserInfo.targetType = gMailType.CHAT
			self.officialUserInfo.target = self.officialUserInfo.officerUid
			self.officialUserInfo.nickName = self.officialUserInfo.nickName
			local self.officialUserInfo.allianceAbbr, data = self.officialUserInfo.allianceAbbr, self.officialUserInfo
			if self.warType and self.warType == gKingdomClassType.nebulaEmperor then
				_ENV = self.warType
				self.warType.targetType = gMailType.CHAT
				self.warType.target = self.officialUserInfo.uid
				self.warType.nickName = self.officialUserInfo.nickname
				data, self.warType.allianceAbbr = self.warType, self.officialUserInfo.abbr
			end
			SoraDCreateChatView(data)
		end
	end
end
function NebulaOfflcerDetailPop:btnInfoClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.officialUserInfo then
			local kid = self.officialUserInfo.officerKid
			local uid = self.officialUserInfo.officerUid
			if self.warType and self.warType == gKingdomClassType.nebulaEmperor then
				kid = self.officialUserInfo.kid
				uid = self.officialUserInfo.uid
			end
			_ENV = nil
			;(nil).fromnebulaofflcerDetailPop = true
			;(nil).targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
		end
	end
end
function NebulaOfflcerDetailPop:btnOrderClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isShowMode then
			if not lordInfoCtrl:canChangeShowOfficialType() then
				SoraDShowMsgTip(i18n("hegemon_text_52"))
				return
			end
			lordInfoCtrl:reqSetShowOfficialType(self.showOfficialType)
		elseif self.warType and self.warType == gKingdomClassType.nebulaEmperor then
			if self.regionId then
				_ENV = i18n("hegemon_text_52")
				i18n("hegemon_text_52").officialID = self.officialID
				i18n("hegemon_text_52").limitList = self.limitList
				uiManager:show("NebulaEmperorAppointRT", i18n("hegemon_text_52"))
			else
				local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
				panel:setNebulaEmperorOfficialID(self.officialID, self.limitList)
				panel:show()
			end
		else
			local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
			panel:setNebulaOfficialID(self.officialID, nebulaPrivilegeCtrl:getMemberList(), nebulaPrivilegeCtrl:getKindomList())
			panel:show()
		end
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function NebulaOfflcerDetailPop:msgGetLordInfo(target, data)
	if data.clientData then
		local fromatlantisPrivilegeDetailPop = data.clientData.fromnebulaofflcerDetailPop
		if fromatlantisPrivilegeDetailPop == true then
			SoraDOpenLordView(data.lord)
		end
	end
end
return NebulaOfflcerDetailPop
