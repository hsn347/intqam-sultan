local gametop = gModuleMgr.getObject("gametop")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local lordSpineDef = include("lordSpineDef")
local WorldMapKingdomCityOfficialManagerHead = class("worldMapKingdomCityOfficialManagerHead", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityOfficialManagerHead")
	end
	return target
end)
function WorldMapKingdomCityOfficialManagerHead:ctor()
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.Node_king = SoraDGetChildByName(self, "Node_king")
	self.txtName = SoraDGetChildByName(self, "Text_person")
	self.Text_alliance = SoraDGetChildByName(self, "Text_alliance")
	self.Node_btns = SoraDGetChildByName(self, "Node_btns")
	self.btnGift = SoraDGetChildByName(self, "Button_gift")
	self.btnGift:setPressedActionEnabled(false)
	SoraDGetChildByName(self.btnGift, "Text_name"):setString(i18n("common_text_1189"))
	self.btnCity = SoraDGetChildByName(self, "Button_city")
	self.btnCity:setPressedActionEnabled(false)
	SoraDGetChildByName(self.btnCity, "Text_name"):setString(i18n("common_text_1187"))
	self.btnFlag = SoraDGetChildByName(self, "Button_flag")
	self.btnFlag:setPressedActionEnabled(false)
	SoraDGetChildByName(self.btnFlag, "Text_name"):setString(i18n("common_text_1192"))
	self.btnKing = SoraDGetChildByName(self, "Button_king")
	self.btnKing:setPressedActionEnabled(false)
	SoraDGetChildByName(self.btnKing, "Text_name"):setString(i18n("common_text_1193"))
	local btnMoveCity = self.btnKing:clone()
	btnMoveCity:addTo(self.btnKing:getParent())
	self.btnMoveCity = btnMoveCity
	self.btnMoveCity:setPressedActionEnabled(false)
	self.btnMoveCity:setVisible(false)
	SoraDGetChildByName(self.btnMoveCity, "Image_7"):setURL("icon_kingdom_qiancheng.png")
	SoraDGetChildByName(self.btnMoveCity, "Text_name"):setString(i18n("mail_text_69"))
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.imgHead:setVisible(false)
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	self.imgFlag = SoraDGetChildByName(self, "Image_flag")
	self.spTitle = SoraDGetChildByName(self, "Panel_kbg")
	self.Node_title = SoraDGetChildByName(self, "Node_title")
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_touch:setTouchEnabled(false)
	self.Node_fire_L = SoraDGetChildByName(self, "Node_fire_L")
	local nodeFireL = SoraDGetCommonJetFireNode(true)
	nodeFireL:setPositionY(80)
	nodeFireL:addTo(self.Node_fire_L)
	self.Node_fire_R = SoraDGetChildByName(self, "Node_fire_R")
	local nodeFireR = SoraDGetCommonJetFireNode(true)
	nodeFireR:setPositionY(80)
	nodeFireR:addTo(self.Node_fire_R)
	self.Image_lordBg = SoraDGetChildByName(self, "Image_lordBg")
	self.Image_lordBg:loadTexture(SoraDCheckPNG("bg_activity_king_road.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.btnGift:addTouchEventListener(handler(self, self.btnGiftClick))
	self.btnFlag:addTouchEventListener(handler(self, self.btnFlagClick))
	self.btnCity:addTouchEventListener(handler(self, self.btnCityClick))
	self.btnKing:addTouchEventListener(handler(self, self.btnKingClick))
	self.btnMoveCity:addTouchEventListener(handler(self, self.btnMoveCityClick))
	self.imgHead:ignoreContentAdaptWithSize(true)
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_GETLIST", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.updateKing))
	self.Button_touch:addTouchEventListener(handler(self, self.imgHeadClick))
	self:crownEffect()
	self:changeCityEffect()
	self:updateKing()
end
function WorldMapKingdomCityOfficialManagerHead:updateKing(target, data)
	local bShowKing = false
	if SoraDIsLookMyKingdom() and allianceMgr:hasJoinAlliance() then
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank == gAllianceRank.R5 and KWKingdomCtrl:isProxyKing() then
			bShowKing = true
		end
	end
	self.btnKing:setVisible(bShowKing)
	SoraDToCenter(self.Node_btns, 100)
end
function WorldMapKingdomCityOfficialManagerHead:update(target, data)
	self:initView()
	local dataList = data.retdate
	self.kingInfo = dataList["1"]
	if self.kingInfo and next(self.kingInfo) ~= nil then
		local lordLocalData = include("lordLocalData")
		local info = lordSpineDef.getLordSpineInfo(self.kingInfo.iconID)
		if info then
			if self.spine then
				self.spine:removeFromParent()
				self.spine = nil
			end
			self.imgHead:setVisible(false)
			self.spine = sp.SkeletonAnimation:create(info.json, info.atlas, 0.6)
			local offset = info.offset or cc.p(0, 0)
			self.spine:setPosition(cc.p(offset.x, offset.y))
			self.spine:setAnimation(0, "animation", true)
			self.spine:addTo(self.Node_spine, 9)
		elseif self.kingInfo.iconID then
			self.imgHead:setVisible(true)
			self.imgHead:loadTexture(lordLocalData.getPortrait(self.kingInfo.iconID), ccui.TextureResType.plistType)
		else
			self.imgHead:setVisible(false)
		end
		local allianceName = self.kingInfo.allianceName or ""
		self.Text_alliance:setString(allianceName)
		self.txtName:setString(self.kingInfo.nickName)
		self.Text_alliance:setPositionY(12)
		self.txtName:setPositionY(-12)
		self.Button_touch:setTouchEnabled(true)
	else
		self.imgHead:setVisible(false)
		self.Text_alliance:setVisible(false)
		self.txtName:setString(i18n("common_text_480"))
		self.txtName:setPositionY(0)
		self.Button_touch:setTouchEnabled(false)
	end
end
function WorldMapKingdomCityOfficialManagerHead:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		local panel = SoraDSearchPanelFromManagerByName("worldMapKingdomCityOfficialPop")
		if targetName == self.__cname and not panel then
			local panel = SoraDCreatePanel("worldMapKingdomCityOfficialPop")
			panel:initData(1, data.lord.base)
			panel:show()
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
		end
	end
end
function WorldMapKingdomCityOfficialManagerHead:imgHeadClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
		local playerID = self.kingInfo.uid
		local kid = worldMapDefine.currentMapKindomID
		_ENV = handler(self, self.serverMessageGetLordInfo)
		handler(self, self.serverMessageGetLordInfo).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, handler(self, self.serverMessageGetLordInfo))
	end
end
function WorldMapKingdomCityOfficialManagerHead:initData()
	self:initView()
end
function WorldMapKingdomCityOfficialManagerHead:initView()
	if SoraDClickFromKingManager() then
		self.btnFlag:setVisible(KWKingdomCtrl:canChangeKingdomFlag() or false)
		self.btnCity:setVisible(KWKingdomCtrl:canChangeKingdomPlace() or false)
		local nationalFlagRead = include("nationalFlagRead")
		local flagImg = nationalFlagRead.getImgByID(KWKingdomCtrl:getKingdomFlag())
		self.imgFlag:loadTexture(flagImg, ccui.TextureResType.plistType)
		self.spTitle:setVisible(false)
	else
		self.btnCity:setVisible(false)
		self.btnFlag:setVisible(false)
		self.spTitle:setVisible(true)
		local kingName = KWKingdomCtrl:getKingdomInfo()
		if kingName.kingdomName then
			_ENV = ccui.TextureResType.plistType
			ccui.TextureResType.plistType.kid = KWKingdomCtrl:getKingdomName(SoraDIsLookMyKingdom())
			self.txtTitle:setString(i18n("common_text_342", ccui.TextureResType.plistType))
			local nationalFlagRead = include("nationalFlagRead")
			local flagImg = nationalFlagRead.getImgByID(KWKingdomCtrl:getKingdomFlag())
			self.imgFlag:loadTexture(flagImg, ccui.TextureResType.plistType)
			SoraDToCenter(self.Node_title)
		else
			self.spTitle:setVisible(false)
		end
	end
	self.btnGift:setVisible(SoraDIsSelfKing() and not SoraDIsSelfQueen())
	self.btnMoveCity:setVisible(self.btnGift:isVisible())
	SoraDToCenter(self.Node_btns, 100)
end
function WorldMapKingdomCityOfficialManagerHead:btnGiftClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
		_ENV = nil
		;(nil).viewType = 1
		panel:init(nil)
		panel:show()
	end
end
function WorldMapKingdomCityOfficialManagerHead:btnFlagClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("worldMapKingdomCityChangeKingFlag"):show()
	end
end
function WorldMapKingdomCityOfficialManagerHead:btnCityClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("worldMapKingdomCityChangePalace"):show()
	end
end
function WorldMapKingdomCityOfficialManagerHead:btnKingClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceMemberList")
		else
			local panel = SoraDCreatePanel("allianceMemberList")
			panel:initData()
			panel:show()
		end
	end
end
function WorldMapKingdomCityOfficialManagerHead:getHeigh()
	return 350
end
function WorldMapKingdomCityOfficialManagerHead:crownEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_Crown_display_01.plist"
	_ENV, (nil)[2], (nil).plist = nil, nil, "et_Crown_display_02.plist"
	;(nil)[3], (nil).plist = nil, "et_Crown_display_03.plist"
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(self.btnGift:getContentSize().width / 2, self.btnGift:getContentSize().height / 2))
	parNode:addTo(self.btnGift)
end
function WorldMapKingdomCityOfficialManagerHead:changeCityEffect()
	_ENV, _ENV = nil, nil
	;(nil)[1], (nil).plist = nil, "et_PalaceIcon_display.plist"
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(self.btnCity:getContentSize().width / 2, self.btnCity:getContentSize().height / 2))
	parNode:setLocalZOrder(-1)
	parNode:addTo(self.btnCity)
end
function WorldMapKingdomCityOfficialManagerHead:btnMoveCityClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("WorldMapNewPlayerMoveCitySetting")
	end
end
return WorldMapKingdomCityOfficialManagerHead
