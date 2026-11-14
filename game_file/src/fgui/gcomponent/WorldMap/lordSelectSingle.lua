local baseComponent = require("fgui.base.baseComponent")
local lordSelectSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WorldMap/lordSelectSingle", lordSelectSingle)
local buildLogic = include("buildLogic")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local cityltCtrl = include("cityltCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
function lordSelectSingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
	self.tableSingleData, _ENV = self.fixChildrenPos, self.fixChildrenPos
	self.handle = nil
	self.scroll = nil
	self.isSelect = false
	self.isLock = false
	self.singleIsMoved = false
	self.isShowOnline = false
	self.isCheckKingdom = false
	self.imgFlg = self.fields.Image_flg
	self.imgPortrait = self.fields.Image_portrait
	self.spriteCastle = self.fields.Sprite_castle
	self.labelOnline = self.fields.Text_online
	self.labelOnline:setString(i18n("common_text_224"))
	self.labelLastTime = self.fields.Text_lastTime
	self.labelState = self.fields.Text_state
	self.labelState:setString(i18n("remains_text_172"))
	self.labelState:setPosition(cc.p(self.imgPortrait:getPositionX(), self.imgPortrait:getPositionY() - 16))
	self.labelState:setVisible(false)
	self.labelCastleLv = self.fields.Text_castleLv
	self.labelPowerTitle = self.fields.Text_powerLab
	self.labelPowerTitle:setString(i18n("common_text_090"))
	self.labelPower = self.fields.Text_power
	self.labelName = self.fields.Text_name
	self.btnCheck = self.fields.Check_tick
	self.btnCheck:setTouchEnabled(false)
	self:setCheck(self.isSelect)
	self:addClickEventListener(handler(self, self.btnClickCallBack))
	self:initBuildStarLvUI()
	self:hiddleOther()
end
function lordSelectSingle:onShow()
	SoraDAddMessage(self, "MESSAGE_LORD_SELECT_BACK", handler(self, self.lockSingle))
end
function lordSelectSingle:setCheck(isCheck)
	self.btnCheck:setSelected(isCheck)
	self.isSelect = isCheck
end
function lordSelectSingle:lockSingle(target, data)
	self.isLock = data.isLock
	self.btnCheck:setVisible((self.isSelect or not self.isLock) and not self.labelState:isVisible())
end
function lordSelectSingle:setOnline(isShow)
	self.isShowOnline = isShow
end
function lordSelectSingle:setOwnKingdom(isCheck)
	self.isCheckKingdom = isCheck
end
function lordSelectSingle:setScroll(scroll)
	self.scroll = scroll
end
function lordSelectSingle:setHandle(handle)
	self.handle = handle
end
function lordSelectSingle:setLimitCasteLV(lv)
	self.limitLV = lv
end
function lordSelectSingle:setLimitTips(strKey)
	self.limitTips = i18n(strKey)
end
function lordSelectSingle:dark()
end
function lordSelectSingle:bright()
end
function lordSelectSingle:initData(singleData)
	self.tableSingleData = singleData
	self:showPublic()
end
function lordSelectSingle:showCastleLimit(...)
	local cityLevel = self.tableSingleData.cityLevel or self.tableSingleData:getProperty("cityLevel")
	if self.limitLV and cityLevel and cityLevel < self.limitLV then
		self:dark()
	else
		self:bright()
	end
end
function lordSelectSingle:showOwnKingdom()
	local notOwn = false
	if self.isCheckKingdom and self.tableSingleData.getProperty then
		local gametop = gModuleMgr.getObject("gametop")
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local sourceKid = self.tableSingleData:getProperty("sourceKid")
		if sourceKid and 0 < sourceKid and ownmember:getProperty("sourceKid") ~= sourceKid then
			notOwn = true
		else
			local mapId = self.tableSingleData:getProperty("mapId")
			if mapId then
				notOwn = true
			end
		end
	end
	if notOwn then
		self.imgPortrait:setGrayed(true)
		self.labelState:setVisible(true)
		self.btnCheck:setVisible(false)
		self.labelOnline:setVisible(false)
		self.labelLastTime:setVisible(false)
	else
		self.imgPortrait:setGrayed(false)
		self.labelState:setVisible(false)
		self.btnCheck:setVisible(self.isSelect or not self.isLock)
	end
end
function lordSelectSingle:showOnline()
	if self.isShowOnline and self.tableSingleData.getProperty then
		local isOnline = self.tableSingleData:getProperty("online") == 0
		self.labelOnline:setVisible(isOnline)
		self.labelLastTime:setVisible(not isOnline)
		if not isOnline then
			self.imgFlg:setGrayed(true)
			self.labelLastTime:setString(SoraDConverSecondToDate(self.tableSingleData:getProperty("online"), false, true))
		else
			self.imgFlg:setGrayed(false)
		end
	else
		self.labelOnline:setVisible(false)
		self.labelLastTime:setVisible(false)
		self.imgFlg:setGrayed(false)
	end
end
function lordSelectSingle:showPublic()
	self.imgFlg:setURL(allianceDesRead.getFlg(gAllianceRank.R2))
	if self.tableSingleData.iconID then
		self.imgPortrait:setURL(lordLocalData.getBust(self.tableSingleData.iconID))
		self.labelPower:setString(string.formatnumberthousands(self.tableSingleData.totalFc))
		self:setCastleLv(self.tableSingleData.cityLevel)
		self:setBuildStarLv(self.tableSingleData.starLv)
		if self.isShowAbbr then
			self.labelName:setString(textParser.formatPlayerName(self.tableSingleData.allianceAbbr or self.tableSingleData.abbr, self.tableSingleData.nickName, self.tableSingleData.kid))
		else
			self.labelName:setString(self.tableSingleData.nickName)
		end
	else
		self.imgPortrait:setURL(lordLocalData.getBust(self.tableSingleData:getProperty("iconID")))
		self.labelPower:setString(string.formatnumberthousands(self.tableSingleData:getProperty("totalFc")))
		self:setCastleLv(self.tableSingleData:getProperty("cityLevel"))
		self:setBuildStarLv(self.tableSingleData:getProperty("starLv"))
		self.labelName:setString(textParser.formatPlayerName(SoraDGetCtrl("allianceMgr"):getAllianceProperty("abbr"), self.tableSingleData:getProperty("nickName"), self.tableSingleData:getProperty("kid") or lordInfoCtrl:getMapSourceKid()))
	end
	self:showOnline()
	self:showOwnKingdom()
	self:showCastleLimit()
end
function lordSelectSingle:initBuildStarLvUI(...)
	self.starLvSprite = self.fields.starLvSprite
	self.starLvSprite:setVisible(true)
	self.starLvText = self.fields.starLvText
	self.starLvText:setVisible(true)
end
function lordSelectSingle:setBuildStarLv(slv)
	local enable = slv and 0 < slv
	self.starLvSprite:setVisible(enable)
	self.starLvText:setVisible(enable)
	if enable then
		self.starLvSprite:setURL(cityltCtrl.getBuildStarImage(slv))
		self.starLvText:setString(tostring(slv))
	end
end
function lordSelectSingle:setCastleLv(clv)
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and warLv >= CASTLE_MIN_WARLV then
		clv = warLv
		castleImg = "301101.png"
	end
	self.spriteCastle:setURL(castleImg)
	self.spriteCastle:setScale(35 / self.spriteCastle:getContentSize().width)
	self.labelCastleLv:setString(tostring(math.min(clv, CASTLE_MAXLV_NOWAR)))
end
function lordSelectSingle:hiddleOther()
	self.labelOnline:setVisible(false)
	self.labelLastTime:setVisible(false)
end
function lordSelectSingle:initSearchData(data)
	if data and next(data) and data.kid then
		self.labelLastTime:setVisible(true)
		if data.kid >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and data.sourceKid and data.sourceKid > 0 then
			_ENV = nil
			;(nil).kid = data.sourceKid
			self.labelLastTime:setString(i18n("common_text_342", nil))
		else
			_ENV = i18n("common_text_342", nil)
			i18n("common_text_342", nil).kid = data.kid
			self.labelLastTime:setString(i18n("common_text_342", i18n("common_text_342", nil)))
		end
	end
end
function lordSelectSingle:btnClickCallBack(button, type)
	SoraDPlaySound()
	if self.labelState:isVisible() then
		SoraDShowMsgTip(i18n("remains_text_172"))
		return
	end
	if self.handle then
		local cityLevel = self.tableSingleData.cityLevel or self.tableSingleData:getProperty("cityLevel")
		if self.limitLV and cityLevel and cityLevel < self.limitLV then
			SoraDShowMsgTip(self.limitTips or i18n("pyramid_text_03"))
			return
		end
		if not self.isLock or self.isSelect then
			self:setCheck(not self.isSelect)
		end
		_ENV = not self.isSelect
		;(not self.isSelect).isSelect = self.isSelect
		;(not self.isSelect).data = self.tableSingleData
		self.handle(self, not self.isSelect)
	end
end
function lordSelectSingle:showAbbr(isShow)
	self.isShowAbbr = isShow
end
return lordSelectSingle
