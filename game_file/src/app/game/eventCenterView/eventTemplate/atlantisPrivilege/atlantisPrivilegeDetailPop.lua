local atlantisActivityRead = include("atlantisActivityRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local atlantisPrivilegeCtrl = SoraDGetCtrl("atlantisPrivilegeCtrl")
local atlantisPrivilegeDetailPop = class("atlantisPrivilegeDetailPop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisPrivilegeDetailPop")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function atlantisPrivilegeDetailPop:ctor()
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
	self.TextDismiss:setString(i18n("common_text_1297"))
	self.textMail:setString(i18n("chat_text_69"))
	self.textInfo:setString(i18n("common_text_002"))
end
function atlantisPrivilegeDetailPop:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
end
function atlantisPrivilegeDetailPop:init(officialType)
	self.officialID = officialType
	local officialInfo = atlantisActivityRead.getOfficialInfoByType(self.officialID)
	self.isKing = atlantisPrivilegeCtrl:isKing()
	self.officialUserInfo = atlantisPrivilegeCtrl:getInfoByOfficialType(officialType)
	self.nodeCommonPopBox:setSize(cc.size(552, 450))
	self.nodeCommonPopBox:setPositionY((self:getPanelOffsetHeight() - 450) / 2)
	if self.officialUserInfo then
		self.nodeControls:setVisible(true)
		self.textUserName:setVisible(true)
		self.btnOrder:setVisible(false)
		self.textTips:setVisible(false)
		SoraDGetHeadFromManager(self.officeIcon, self.officialUserInfo.iconID, self.officialUserInfo.avatar)
		self.officeIcon:setScale(0.5714285714285714)
		self.textUserName:setString(textParser.formatPlayerName(self.officialUserInfo.allianceAbbr, self.officialUserInfo.nickName, self.officialUserInfo.kid))
		self.spDismiss:setVisible(self.isKing)
		if self.isKing and self.officialID == gAtlantisOfficialType.QZWZ then
			self:hideDownUI()
		end
	else
		self.nodeControls:setVisible(false)
		self.textUserName:setVisible(false)
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
function atlantisPrivilegeDetailPop:initData(itemData, officialType, isShowMode)
	self.nodeCommonPopBox:setSize(cc.size(552, 450))
	self.nodeCommonPopBox:setPositionY((self:getPanelOffsetHeight() - 450) / 2)
	self.isKing = atlantisPrivilegeCtrl:isKing()
	self.spDismiss:setVisible(self.isKing)
	self.officialID = officialType
	self.isShowMode = isShowMode
	self.officialUserInfo = itemData
	self.textUserName:setString(textParser.formatPlayerName(self.officialUserInfo.abbr, self.officialUserInfo.nickName, self.officialUserInfo.kid))
	self.nodeControls:setVisible(not self.isShowMode)
	self.btnOrder:setVisible(self.isShowMode)
	self.btnOrder:setTitleText(i18n("common_btn_17"))
	local officialInfo = atlantisActivityRead.getOfficialInfoByType(self.officialID)
	self.nodeCommonPopBox:setTitleName(i18n(officialInfo.name))
	self:showBuffs(officialInfo.buff)
	self.textTips:setVisible(false)
	self.officeIcon:loadTexture(officialInfo.img, ccui.TextureResType.plistType)
	SoraDToCenter(self.nodeControls, 70, true)
	if self.isShowMode and lordInfoCtrl:getShowOfficialType() == gShowOfficialType.ATLANTIS then
		self.textTips:setVisible(true)
		self.btnOrder:setVisible(false)
		self.textTips:setString(i18n("common_text_4361"))
	end
end
function atlantisPrivilegeDetailPop:hideDownUI()
	self.nodeControls:setVisible(false)
	self.btnOrder:setVisible(false)
	self.nodeCommonPopBox:setSize(cc.size(552, 350))
	self.nodeCenter:setPositionY(125.0)
	self.nodeCommonPopBox:setPositionY((self:getPanelOffsetHeight() - 350) / 2)
	SoraDGetChildByName(self, "Sprite_lace_t"):setVisible(false)
	SoraDGetChildByName(self, "Sprite_Line"):setVisible(false)
end
function atlantisPrivilegeDetailPop:showBuffs(buffList)
	for i = 1, #self.buffNodes do
		self.buffNodes[i]:setVisible(false)
	end
	for i, bufferId in ipairs(buffList) do
		local buffDes, type = atlantisActivityRead.getBufferName(bufferId)
		if self.buffNodes[i] then
			self.buffNodes[i]:setVisible(true)
			SoraDGetChildByName(self.buffNodes[i], "text_buff"):setString(buffDes)
		end
	end
	SoraDToVerticalCenter(self.nodeBuff, 60)
end
function atlantisPrivilegeDetailPop:btnDismissClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.officialUserInfo then
			_ENV = nil
			;(nil).disMissUid = self.officialUserInfo.uid
			atlantisPrivilegeCtrl:reqAtlantisPrivilegeDismiss(nil)
			self:close(nil, ccui.TouchEventType.ended)
		end
	end
end
function atlantisPrivilegeDetailPop:btnMailClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.officialUserInfo then
			_ENV = self.officialUserInfo
			self.officialUserInfo.targetType = gMailType.CHAT
			self.officialUserInfo.target = self.officialUserInfo.uid
			self.officialUserInfo.nickName = self.officialUserInfo.nickName
			local self.officialUserInfo.allianceAbbr, data = self.officialUserInfo.allianceAbbr, self.officialUserInfo
			SoraDCreateChatView(data)
		end
	end
end
function atlantisPrivilegeDetailPop:btnInfoClick(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.officialUserInfo then
			local kid = self.officialUserInfo.kid
			local uid = self.officialUserInfo.uid
			_ENV = nil
			;(nil).fromatlantisPrivilegeDetailPop = true
			;(nil).targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
		end
	end
end
function atlantisPrivilegeDetailPop:btnOrderClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isShowMode then
			if not lordInfoCtrl:canChangeShowOfficialType() then
				SoraDShowMsgTip(i18n("hegemon_text_52"))
				return
			end
			lordInfoCtrl:reqSetShowOfficialType(gShowOfficialType.ATLANTIS)
		else
			local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
			panel:setAtlantisOfficialID(self.officialID, atlantisPrivilegeCtrl:getMemberList(), atlantisPrivilegeCtrl:getKindomList())
			panel:show()
		end
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function atlantisPrivilegeDetailPop:msgGetLordInfo(target, data)
	if data.clientData then
		local fromatlantisPrivilegeDetailPop = data.clientData.fromatlantisPrivilegeDetailPop
		if fromatlantisPrivilegeDetailPop == true then
			SoraDOpenLordView(data.lord)
		end
	end
end
return atlantisPrivilegeDetailPop
