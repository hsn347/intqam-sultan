_ENV = nil
;(nil).isEmpty = 1
local (nil).isFull, OfficaialHaveState = 2, nil
local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local WorldMapKingdomCityOfficialPop = class("worldMapKingdomCityOfficialPop", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapKingdomCityOfficialPop")
	end
	return target
end)
function WorldMapKingdomCityOfficialPop:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.officialID = 0
	self.usrData = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeControls = SoraDGetChildByName(self, "Node_contorls")
	self.btnAppoint = SoraDGetChildByName(self, "Button_appoint")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.Node_official = SoraDGetChildByName(self, "Node_official")
	self.Node_official:setVisible(false)
	self.Node_slave = SoraDGetChildByName(self, "Node_slave")
	self.Node_slave:setVisible(false)
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.btnInfo:setPressedActionEnabled(false)
	self.btnMail = SoraDGetChildByName(self, "Button_mail")
	self.btnMail:setPressedActionEnabled(false)
	self.btnRetired = SoraDGetChildByName(self, "Button_retired")
	self.btnRetired:setPressedActionEnabled(false)
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Text_str = SoraDGetChildByName(self, "Text_str")
	self.Image_line = SoraDGetChildByName(self, "Image_line")
	self.btnShow = SoraDGetChildByName(self, "Button_show")
	self.btnShow:setTitleText(i18n("common_btn_17"))
	self.text_show = SoraDGetChildByName(self, "text_show")
	self.btnShow:setVisible(false)
	self.nodeControls:setVisible(false)
	self.btnAppoint:setVisible(false)
	self.Text_str:setVisible(false)
	self.Image_line:setVisible(false)
	SoraDGetChildByName(self, "Text_info"):setString(i18n("common_text_002"))
	SoraDGetChildByName(self, "Text_mail"):setString(i18n("chat_text_69"))
	SoraDGetChildByName(self, "Text_retired"):setString(i18n("common_text_326"))
	self.Text_str:setString(i18n("common_text_1194"))
	SoraDSetTextWidthHeight(self.Text_str, cc.size(520, 35))
	self.btnAppoint:setTitleText(i18n("common_text_687"))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_ADD", handler(self, self.officialAddMsgRes))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_SUB", handler(self, self.officialSubMsgRes))
	self.btnAppoint:addTouchEventListener(handler(self, self.btnAppointClick))
	self.btnShow:addTouchEventListener(handler(self, self.btnShowClick))
	self.btnInfo:addTouchEventListener(handler(self, self.btnInfoClick))
	self.btnMail:addTouchEventListener(handler(self, self.btnMailClick))
	self.btnRetired:addTouchEventListener(handler(self, self.btnRetiredClick))
end
function WorldMapKingdomCityOfficialPop:officialSubMsgRes(target, data)
	if data then
		SoraDShowMsgTip(i18n("common_text_1444"))
		self:update(target, data)
	end
end
function WorldMapKingdomCityOfficialPop:officialAddMsgRes(target, data)
	if data then
		SoraDShowMsgTip(i18n("common_text_1431"))
		self:update(target, data)
	end
end
function WorldMapKingdomCityOfficialPop:update(target, data)
	if tonumber(data.redata.type) == tonumber(self.officialID) then
		local usrData = KWKingdomCtrl:getOfficialUser(self.officialID)
		self:initData(nil, usrData)
	end
end
function WorldMapKingdomCityOfficialPop:initData(officialID, usrData, isShowMode)
	print("·officialID =", officialID)
	self.isShowMode = isShowMode
	if officialID then
		self.officialID = officialID
	end
	self.usrData = usrData
	self:initView()
end
function WorldMapKingdomCityOfficialPop:initView()
	local haveState = table.nums(self.usrData) > 1 and OfficaialHaveState.isFull or OfficaialHaveState.isEmpty
	local isQueen = lordInfoCtrl:getSelfOfficial() == gKingOfficialType.queen
	if self.usrData.nickName then
		local allianceAbbr = self.usrData.allianceAbbr and "(" .. self.usrData.allianceAbbr .. ")" or ""
		self.txtName:setString(allianceAbbr .. self.usrData.nickName)
		self.txtName:setVisible(true)
	else
		self.txtName:setVisible(false)
	end
	local officialBuffRead = include("officialBuffRead")
	local officialInfoRead = include("officialInfoRead")
	local officialInfo = officialInfoRead.getInfoByType(self.officialID)
	local _ENV, skillTbl = self.officialID, self.officialID
	for _, v in ipairs(officialInfo.buff) do
		table.insert(skillTbl, i18n(officialBuffRead.getItem(v).buffDes) or "")
	end
	local Image_official, Image_head
	if 1 == officialInfo.class then
		self.Node_official:setVisible(true)
		self.Node_slave:setVisible(false)
		Image_official = self.Node_official:getChildByName("Image_official")
		Image_head = self.Node_official:getChildByName("Image_head")
	elseif 2 == officialInfo.class then
		self.Node_official:setVisible(false)
		self.Node_slave:setVisible(true)
		Image_official = self.Node_slave:getChildByName("Image_official")
		Image_head = self.Node_slave:getChildByName("Image_head")
	elseif 0 == officialInfo.class then
		self.Node_official:setVisible(true)
		self.Node_slave:setVisible(false)
		Image_official = self.Node_official:getChildByName("Image_official")
		Image_head = self.Node_official:getChildByName("Image_head")
	end
	if Image_official then
		Image_official:loadTexture(officialInfo.img, ccui.TextureResType.plistType)
		Image_official:setVisible(OfficaialHaveState.isFull ~= haveState)
		if self.usrData.iconID or self.usrData.imageId then
			SoraDGetHeadFromManager(Image_head, self.usrData.iconID or self.usrData.imageId, self.usrData.avatar)
		end
		if OfficaialHaveState.isEmpty == haveState then
			Image_head:setVisible(false)
			Image_head:setTouchEnabled(false)
		else
			Image_head:setVisible(true)
			Image_head:setTouchEnabled(true)
			Image_head:addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
					local playerID = self.usrData.uid
					local kid = worldMapDefine.currentMapKindomID
					_ENV = handler(self, self.serverMessageGetLordInfo)
					handler(self, self.serverMessageGetLordInfo).targetName = self.__cname
					local playerData = lordInfoCtrl:getLordInfoByUid(playerID, kid, handler(self, self.serverMessageGetLordInfo))
				end
			end)
		end
	end
	self.ccs_bg:setTitleName(i18n(officialInfo.name))
	for k, v in pairs(self.Node_content:getChildren()) do
		if v ~= self.Node_item and v ~= self.Node_official and v ~= self.Node_slave then
			v:removeFromParent()
		end
	end
	OfficaialHaveState = (for generator)
	local pairs(self.Node_content:getChildren())[1], ocxTbl = self.Node_item, pairs(self.Node_content:getChildren())
	if 1 < #skillTbl then
		for i = 2, #skillTbl do
			local newSingle = self.Node_item:clone()
			newSingle:addTo(self.Node_content)
			table.insert(ocxTbl, newSingle)
		end
	end
	self.txtName:setPositionY(150)
	if self.isShowMode then
		self:updateBoxBorder()
		self.txtName:setPositionY(150)
		self.btnAppoint:setVisible(false)
		self.btnShow:setVisible(true)
		self.nodeControls:setVisible(false)
		self.Text_str:setVisible(false)
		if lordInfoCtrl:getShowOfficialType() == gShowOfficialType.KING then
			self.btnShow:setBright(false)
			self.btnShow:setTouchEnabled(false)
			self.btnShow:setVisible(false)
			self.text_show:setString(i18n("common_text_4361"))
		elseif lordInfoCtrl:canChangeShowOfficialType() then
			print("可以切换-----")
			self.btnShow:setBright(true)
			self.btnShow:setTouchEnabled(true)
		else
			print("无法切换--------")
			self.btnShow:setTouchEnabled(true)
			self.btnShow:setBright(false)
		end
	elseif SoraDClickFromKingManager() or (SoraDIsSelfKing() or SoraDIsSelfQueen()) and SoraDIsLookMyKingdom() then
		print("isQueen======111", isQueen, self.officialID)
		self:updateBoxBorder()
		if OfficaialHaveState.isEmpty == haveState then
			self.btnAppoint:setVisible(true)
			self.nodeControls:setVisible(false)
			self.Text_str:setVisible(true)
			if isQueen and officialInfo.class == 2 then
				self.txtName:setPositionY(95)
				self.nodeControls:setVisible(false)
				self:updateBoxBorder(true)
				self.btnAppoint:setVisible(false)
				self.Text_str:setVisible(false)
			end
		else
			self.nodeControls:setVisible(true)
			self.btnAppoint:setVisible(false)
			self.Text_str:setVisible(false)
			if self.usrData.uid == lordInfoCtrl:getLordInfo().base.uid then
				self.txtName:setPositionY(95)
				self.nodeControls:setVisible(false)
				self:updateBoxBorder(true)
			end
			if isQueen and (self.officialID == 1 or officialInfo.class == 2) then
				self.btnRetired:setVisible(false)
			end
		end
	else
		print("isQueen======222", isQueen, self.officialID)
		if OfficaialHaveState.isFull == haveState then
			self.nodeControls:setVisible(true)
			self.btnRetired:setVisible(false)
			self.Text_str:setVisible(false)
			if self.usrData.uid == lordInfoCtrl:getLordInfo().base.uid then
				self.btnMail:setVisible(false)
			end
			self:updateBoxBorder()
		else
			self.nodeControls:setVisible(false)
			self.Text_str:setVisible(false)
			self:updateBoxBorder(true)
		end
	end
	if self.nodeControls:isVisible() then
		SoraDToCenter(self.nodeControls, 70, true)
	end
	local offsetH = 60
	for i, v in ipairs(ocxTbl) do
		local Text_content = v:getChildByName("Text_content")
		Text_content:setString(skillTbl[i])
		if 1 == officialInfo.class then
			Text_content:setColor(cc.c3b(0, 190, 30))
		elseif 2 == officialInfo.class then
			Text_content:setColor(cc.c3b(200, 155, 100))
		end
		local pascal = #ocxTbl - 1 - 2 * (i - 1)
		v:setPosition(SoraDFPosX(-70, 0), 45 + offsetH * pascal / 2)
	end
end
function WorldMapKingdomCityOfficialPop:updateBoxBorder(isSmall)
	if isSmall then
		self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, 340))
		self.ccs_bg:setPositionY(-170)
		self.Node_content:setPositionY(-63)
		self.Image_line:setVisible(false)
	else
		self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, 466))
		self.ccs_bg:setPositionY(-233)
		self.Node_content:setPositionY(0)
		self.Image_line:setVisible(true)
	end
end
function WorldMapKingdomCityOfficialPop:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == self.__cname then
			SoraDOpenLordView(data.lord)
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
		end
	end
end
function WorldMapKingdomCityOfficialPop:btnAppointClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
		panel:setOfficialID(self.officialID, self.limitUsrList)
		panel:show()
	end
end
function WorldMapKingdomCityOfficialPop:btnShowClick(button, type)
	if type == ccui.TouchEventType.ended then
		print("todohlp:展示当前官职------")
		if not lordInfoCtrl:canChangeShowOfficialType() then
			SoraDShowMsgTip(i18n("hegemon_text_52"))
			return
		end
		lordInfoCtrl:reqSetShowOfficialType(gShowOfficialType.KING)
		self:closePanel()
	end
end
function WorldMapKingdomCityOfficialPop:btnInfoClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.usrData.uid then
			SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
			local kid = gametop.playertop_:getMapID()
			_ENV = handler(self, self.msgGetLordInfo)
			handler(self, self.msgGetLordInfo).fromOfficialPop = true
			handler(self, self.msgGetLordInfo).targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(self.usrData.uid, kid, handler(self, self.msgGetLordInfo))
		end
	end
end
function WorldMapKingdomCityOfficialPop:btnMailClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.usrData.uid then
			local chatFunctions = include("chatFunctions")
			if self.usrData.uid == chatFunctions:getSelfId() then
				SoraDShowMsgTip(i18n("common_text_4265"))
				return
			end
			_ENV = SoraDShowMsgTip
			SoraDShowMsgTip.targetType = gMailType.CHAT
			SoraDShowMsgTip.target = self.usrData.uid
			SoraDShowMsgTip.nickName = self.usrData.nickName
			local SoraDShowMsgTip.allianceAbbr, data = self.usrData.allianceAbbr or "", SoraDShowMsgTip
			SoraDCreateChatView(data)
		end
	end
end
function WorldMapKingdomCityOfficialPop:btnRetiredClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		KWKingdomCtrl:dismissOfficial(self.usrData.uid, self.officialID)
	end
end
function WorldMapKingdomCityOfficialPop:msgGetLordInfo(target, data)
	if data.clientData and data.lord then
		local fromOfficialPop = data.clientData.fromOfficialPop
		if fromOfficialPop == true then
			SoraDOpenLordView(data.lord)
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
		end
	end
end
return WorldMapKingdomCityOfficialPop
