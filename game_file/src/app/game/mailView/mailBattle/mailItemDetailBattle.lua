local mailUIConstDef = include("mailUIConstDef")
local propParser = include("propParser")
local equipDesRead = include("equipDesRead")
local mailFunctions = include("mailFunctions")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local mailNodeFactory = include("mailNodeFactory")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local mailDesParser = include("mailDesParser")
local mailItemDetailBattle = class("mailItemDetailBattle", function(target)
	return include("baseView").new()
end)
function mailItemDetailBattle:ctor()
	self:setNodeEventEnabled(true)
	self:setSwallowTouches(false)
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = 0
	local size = cc.size(self.itemWidth, self.itemHeight)
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.singleIsMoved = false
end
function mailItemDetailBattle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_ITEM_DETAIL_SIZE_CHANGE", handler(self, self.msgOnSizeChanged))
end
function mailItemDetailBattle:initWithData(mail, senderId, specialView)
	if nil == mail then
		return
	end
	self:setLayoutType(ccui.LayoutType.VERTICAL)
	self.mail = mail
	self.senderId = senderId
	self.mailSource = self.mail:getProperty("source")
	self.mailType = self.mail:getProperty("mailType")
	self.contentData = self.mail:getProperty("data")
	if not self.contentData.battleInfo then
		self.contentData.battleInfo.defenceArmyInfo, _ENV, self.contentData.battleInfo.attackArmyInfo, _ENV, _ENV = "data", "data", "data", "data", self.contentData.battleInfo
	end
	self.contentData.battleInfo = self.contentData.battleInfo
	if self.contentData and self.contentData.uinfo and self.contentData.uinfo.coordinate and not self.contentData.uinfo.coordinate.kid then
		self.contentData.uinfo.coordinate.kid = self.mail:getKingdomID()
	end
	if specialView then
		if specialView == 1 then
			self:createOnlyShowAdvancedAttr()
		else
			self:createFightDetailInfo()
		end
	else
		local funcName = gMailSetTypeFunc.getCreateFunc(self.mailSource)
		if self[funcName] then
			self[funcName](self)
		end
	end
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self:requestDoLayout()
end
function mailItemDetailBattle:createScoutSuccess()
	local totalHeight = 0
	if self.contentData.cityDefenceArmy and self.contentData.cityDefenceArmy.defenceArmyNum then
		self.contentData.cityDefenceArmy.num = self.contentData.cityDefenceArmy.defenceArmyNum
	end
	mailNodeFactory = nil
	;(nil).imgName = gMailSetTypeFunc.getSceneImgByMailSource(self.mailSource)
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	local image, autoHeight = mailNodeFactory:createImgViewLayout(nil)
	image:addTo(self)
	totalHeight = totalHeight + autoHeight
	local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("history_text_57")
	titleLayout:addTo(self)
	totalHeight = totalHeight + autoHeight
	local playLayout, autoHeight = mailNodeFactory:createPlayerInfo(self.contentData)
	self:addChild(playLayout)
	totalHeight = totalHeight + autoHeight
	if self.contentData.resInfo and 0 < #self.contentData.resInfo then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("mail_2_text_20")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local resLayout, autoHeight = mailNodeFactory:createResLayout(self.contentData.resInfo)
		self:addChild(resLayout)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.cityDefence then
		mailNodeFactory = mailNodeFactory:createResLayout(self.contentData.resInfo)
		mailNodeFactory:createResLayout(self.contentData.resInfo).strName = i18n("common_text_104")
		mailNodeFactory:createResLayout(self.contentData.resInfo).strNum = self:getCityDefenceStr()
		local defenceLayout, autoHeight = mailNodeFactory:createCityDefence(mailNodeFactory:createResLayout(self.contentData.resInfo))
		self:addChild(defenceLayout)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.cityDefenceArmy and (self.contentData.cityDefenceArmy.heroInfo and 0 < #self.contentData.cityDefenceArmy.heroInfo or self.contentData.cityDefenceArmy.armsInfo and 0 < #self.contentData.cityDefenceArmy.armsInfo or self.contentData.cityDefenceArmy.divineBeastInfo and 0 < #self.contentData.cityDefenceArmy.divineBeastInfo) then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("artifact_text_35")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local heroLayout, autoHeight = mailNodeFactory:createHeroInfoLayout(self.contentData.cityDefenceArmy)
		heroLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	local numDefence = 0
	if self.contentData.cityDefenceArmy then
		numDefence = numDefence + 1
	end
	if self.contentData.reinforcements and 0 < self.contentData.reinforcements.num then
		numDefence = numDefence + self.contentData.reinforcements.num
	end
	if 1 < numDefence then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("share_text_02")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local defenceArmyLayout, autoHeight = mailNodeFactory:createDefenceArmyLayout(self:getAllAllianceArmyList(), true)
		defenceArmyLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.cityDefenceArmy and self.contentData.cityDefenceArmy.hasArmyType then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_105")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local defenceArmyLayout, autoHeight = mailNodeFactory:createDefenceArmyLayout(self.contentData.cityDefenceArmy.armyInfo)
		defenceArmyLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.reinforcements and 0 < self.contentData.reinforcements.num and (self.contentData.reinforcements.hasArmyType or self.contentData.reinforcements.playersInfo and 0 < #self.contentData.reinforcements.playersInfo) then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_106")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local AllianceArmyLayout, autoHeight = self:createAllianceArmyLayout(self.contentData.reinforcements)
		AllianceArmyLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.trap and self.contentData.trap.hasTrapType and 0 < #self.contentData.trap.trapsInfo then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_107")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local trapLayout, autoHeight = mailNodeFactory:createTrapLayout(self.contentData.trap.trapsInfo)
		trapLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.towers and self.contentData.towers.towersInfo and 0 < #self.contentData.towers.towersInfo then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("buildDes_name_103")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local towerLayout, autoHeight = mailNodeFactory:createTowerLayout(self.contentData.towers.towersInfo)
		towerLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.academySkillInfos and 0 < #self.contentData.academySkillInfos then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_108")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local towerLayout, autoHeight = mailNodeFactory:createAcademySkillLayout(self.contentData.academySkillInfos)
		towerLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	if self.contentData.lordSkills and 0 < #self.contentData.lordSkills then
		local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_109")
		titleLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
		local towerLayout, autoHeight = mailNodeFactory:createLordSkillLayout(self.contentData.lordSkills)
		towerLayout:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createScoutFailure()
	local totalHeight = 0
	mailNodeFactory = nil
	;(nil).fontSize = 22
	;(nil).str = self:getScoutFailureStr()
	;(nil).color = cc.c3b(57, 11, 11)
	;(nil).autoHeight = true
	local textDes, autoHeight = mailNodeFactory:createTextWithBg(nil)
	self:addChild(textDes)
	totalHeight = totalHeight + autoHeight
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createBeScoutedSuccess()
	local totalHeight = 0
	self.contentData.hideName = true
	self.contentData.hideLv = true
	self.contentData.hideCoordinate = true
	mailNodeFactory = nil
	;(nil).imgName = gMailSetTypeFunc.getSceneImgByMailSource(self.mailSource)
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	local image, autoHeight = mailNodeFactory:createImgViewLayout(nil)
	image:addTo(self)
	totalHeight = totalHeight + autoHeight
	local titleLayout, autoheight = mailNodeFactory:createLayoutRewardItemHead("history_text_57")
	titleLayout:addTo(self)
	totalHeight = totalHeight + autoheight
	local uinfo = clone(self.contentData.uinfo)
	uinfo.name = self:getBeScoutStr()
	local playLayout, autoheight = mailNodeFactory:createPlayerInfo(uinfo, true)
	self:addChild(playLayout)
	totalHeight = totalHeight + autoheight
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createEscortFight()
	local fontColor = cc.c3b(57, 11, 11)
	local totalHeight = 0
	local playerInfo = self.contentData.playerInfo2
	if self:getReceiverPlayerId() ~= tonumber(self.contentData.playerInfo1.uinfo.id) then
		playerInfo = self.contentData.playerInfo1
	end
	if not playerInfo.allianceInfo then
		local _ENV, allianceInfo = playerInfo.allianceInfo, playerInfo.allianceInfo
	end
	if not playerInfo.uinfo then
		local _ENV, uinfo = playerInfo.uinfo, playerInfo.uinfo
	end
	local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
	_ENV = uinfo.nickName
	uinfo.nickName.imgName = gMailSetTypeFunc.getSceneImgByMailSource(self.mailSource)
	uinfo.nickName.linearLayoutType = ccui.LinearGravity.centerHorizontal
	local image, autoHeight = mailNodeFactory:createImgViewLayout(uinfo.nickName)
	image:addTo(self)
	totalHeight = totalHeight + autoHeight
	local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("history_text_57")
	titleLayout:addTo(self)
	totalHeight = totalHeight + autoHeight
	_ENV = self
	self.id = uinfo.id
	self.iconID = uinfo.iconID
	self.avatar = uinfo.avatar
	self.name = strName
	self.lv = uinfo.lv or 0
	self.isCastle = true
	local playerInfoNode, autoHeight = mailNodeFactory:createPlayerInfo(self, true)
	self:addChild(playerInfoNode)
	totalHeight = totalHeight + autoHeight
	local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("common_text_123")
	titleLayout:addTo(self)
	totalHeight = totalHeight + autoHeight
	local robResList = clone(self.contentData.resInfo)
	if robResList and next(robResList) then
		local vLayout, _ = mailNodeFactory:createRewardList(robResList)
		local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
		frameBoxResInfoNode:setSwallowTouches(false)
		_ENV = false
		_ENV, (false).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
		mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isHideTop = true
		;(false).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
		frameBoxResInfoNode:initWithData(false)
		self:addChild(frameBoxResInfoNode)
		totalHeight = totalHeight + frameBoxResInfoNode:getItemHeight()
	end
	_ENV = include("mailItemDetailFrameBox").new()
	include("mailItemDetailFrameBox").new().fontSize = 20
	include("mailItemDetailFrameBox").new().str = i18n("common_text_2419")
	include("mailItemDetailFrameBox").new().color = cc.c3b(57, 11, 11)
	include("mailItemDetailFrameBox").new().autoHeight = true
	include("mailItemDetailFrameBox").new().linearLayoutType = ccui.LinearGravity.centerHorizontal
	local text, autoHeight = mailNodeFactory:createTextLayout((include("mailItemDetailFrameBox").new()))
	text:addTo(self)
	totalHeight = totalHeight + autoHeight
	totalHeight = totalHeight + self:createBtnFightReportLayout()
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createEscortNoFight()
	local fontColor = cc.c3b(57, 11, 11)
	local totalHeight = 0
	local playerInfo = self.contentData.playerInfo2
	if self:getReceiverPlayerId() ~= tonumber(self.contentData.playerInfo1.uinfo.id) then
		playerInfo = self.contentData.playerInfo1
	end
	if not playerInfo.allianceInfo then
		local _ENV, allianceInfo = playerInfo.allianceInfo, playerInfo.allianceInfo
	end
	if not playerInfo.uinfo then
		local _ENV, uinfo = playerInfo.uinfo, playerInfo.uinfo
	end
	local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
	_ENV = uinfo.nickName
	uinfo.nickName.imgName = gMailSetTypeFunc.getSceneImgByMailSource(self.mailSource)
	uinfo.nickName.linearLayoutType = ccui.LinearGravity.centerHorizontal
	local image, autoHeight = mailNodeFactory:createImgViewLayout(uinfo.nickName)
	image:addTo(self)
	totalHeight = totalHeight + autoHeight
	local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("history_text_57")
	titleLayout:addTo(self)
	totalHeight = totalHeight + autoHeight
	_ENV = self
	self.id = uinfo.id
	self.iconID = uinfo.iconID
	self.avatar = uinfo.avatar
	self.name = strName
	self.lv = uinfo.lv or 0
	self.isCastle = true
	local playerInfoNode, autoHeight = mailNodeFactory:createPlayerInfo(self, true)
	self:addChild(playerInfoNode)
	totalHeight = totalHeight + autoHeight
	local strDetail = ""
	if self.mailSource == gMailSource.ESCORT_ROB_FAILED then
		_ENV = nil
		;(nil).name = self.contentData.playerInfo2.uinfo.nickName
		strDetail = i18n("common_text_2422", nil)
	elseif self.mailSource == gMailSource.ESCORT_DEF_SUCCESS then
		_ENV = nil
		;(nil).name = self.contentData.playerInfo1.uinfo.nickName
		strDetail = i18n("common_text_2420", nil)
	end
	_ENV = nil
	;(nil).fontSize = 20
	;(nil).str = strDetail
	;(nil).autoHeight = true
	;(nil).color = cc.c3b(57, 11, 11)
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	local text, autoHeight = mailNodeFactory:createTextLayout(nil)
	text:addTo(self)
	totalHeight = totalHeight + autoHeight
	totalHeight = totalHeight + self:createBtnFightReportLayout()
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createOccupy()
	local totalHeight = 0
	mailNodeFactory = nil
	;(nil).imgName = gMailSetTypeFunc.getSceneImgByMailSource(self.mailSource)
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	local image, autoHeight = mailNodeFactory:createImgViewLayout(nil)
	image:addTo(self)
	totalHeight = totalHeight + autoHeight
	local titleLayout, autoHeight = mailNodeFactory:createLayoutRewardItemHead("history_text_57")
	titleLayout:addTo(self)
	totalHeight = totalHeight + autoHeight
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	frameBoxResInfoNode:setSwallowTouches(false)
	mailNodeFactory = false
	mailNodeFactory, (false).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isHideTop = true
	;(false).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, self:createAllianceArmyItem(self.contentData)
	frameBoxResInfoNode:initWithData(false)
	self:addChild(frameBoxResInfoNode)
	totalHeight = totalHeight + frameBoxResInfoNode:getItemHeight()
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createFight()
	local totalHeight = 0
	local headLayout = ccui.Layout:create()
	headLayout:setCascadeOpacityEnabled(true)
	local headNode = include("mailItemDetailFightHead").new()
	headNode:initData(self.mail)
	headLayout:addChild(headNode)
	headNode:setPosition(0, 0)
	headLayout:setContentSize(cc.size(headNode:getItemWidth(), headNode:getItemHeight()))
	totalHeight = totalHeight + headNode:getItemHeight()
	headLayout:addTo(self)
	if self.contentData.targetCityWall ~= nil then
		_ENV = self
		_ENV = cc.size(headNode:getItemWidth(), headNode:getItemHeight())
		cc.size(headNode:getItemWidth(), headNode:getItemHeight()).name = i18n("common_text_2996")
		cc.size(headNode:getItemWidth(), headNode:getItemHeight()).num = string.format("%d/%d", self.contentData.targetCityWall.cityDefense.currentValue, self.contentData.targetCityWall.cityDefense.maxDefence)
		self.strName = i18n("common_text_036", cc.size(headNode:getItemWidth(), headNode:getItemHeight()))
		self.strNum = i18n("common_text_398") .. SoraDConvertSecondToString(self.contentData.targetCityWall.remainBurningTime)
		local defenceLayout, autoHeight = mailNodeFactory:createCityDefence(self)
		self:addChild(defenceLayout)
		totalHeight = totalHeight + autoHeight
	end
	if not self.contentData.playerInfo1 then
		_ENV = self.contentData.playerInfo1
	end
	self.contentData.playerInfo1 = self.contentData.playerInfo1
	if not self.contentData.playerInfo2 then
		_ENV = self.contentData.playerInfo2
	end
	self.contentData.playerInfo2 = self.contentData.playerInfo2
	if not self.contentData.playerInfo1.fightSummary then
		_ENV = self.contentData.playerInfo1.fightSummary
	end
	if not self.contentData.playerInfo2.fightSummary then
		_ENV = self.contentData.playerInfo2.fightSummary
	end
	totalHeight = totalHeight + self:getBattleBriefList(self.contentData.playerInfo1.fightSummary, self.contentData.playerInfo2.fightSummary)
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = self.contentData.playerInfo2.fightSummary
	_ENV, self.contentData.playerInfo2.fightSummary.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("common_text_120")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.topHeight = 30
	self.contentData.playerInfo2.fightSummary.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.showBtnAttrAnalysis = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, true
	frameBoxInfoNode:initWithData(self.contentData.playerInfo2.fightSummary)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local resLayout = self:createTroopAttr(self.contentData.playerInfo1, self.contentData.playerInfo2, 1)
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = 1
	_ENV, (1).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("battlelog_text_12")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowColorTopBg2 = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	;(1).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(1)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createAdvancedTroopAttr(self.contentData.playerInfo1, self.contentData.playerInfo2)
	_ENV = self.contentData.playerInfo2
	_ENV, self.contentData.playerInfo2.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("battlelog_text_13")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowColorTopBg2 = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	self.contentData.playerInfo2.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(self.contentData.playerInfo2)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout2 = self:createTroopAttr(self.contentData.playerInfo1, self.contentData.playerInfo2, 2)
	_ENV = self.contentData.playerInfo2
	_ENV, self.contentData.playerInfo2.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("battlelog_text_14")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowColorTopBg2 = true
	_ENV, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = i18n("battlelog_text_14"), true
	i18n("battlelog_text_14").title = i18n("battlelog_text_14")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.helpTips, i18n("battlelog_text_14").content = i18n("battlelog_text_14"), i18n("common_text_4921")
	self.contentData.playerInfo2.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout2
	frameBoxInfoNode:initWithData(self.contentData.playerInfo2)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local layout_Tip = ccui.Layout:create()
	layout_Tip:setCascadeOpacityEnabled(true)
	local line = display.newSprite("#frame_yjyh_line_02.png")
	line:addTo(layout_Tip)
	local strHtml = i18n("battlelog_text_15")
	_ENV = i18n("common_text_4921")
	i18n("common_text_4921").color = cc.c3b(83, 65, 47)
	i18n("common_text_4921").str = strHtml
	i18n("common_text_4921").fontSize = 18
	i18n("common_text_4921").AlignH = cc.TEXT_ALIGNMENT_CENTER
	i18n("common_text_4921").AlignV = cc.TEXT_ALIGNMENT_CENTER
	i18n("common_text_4921").autoHeight = true
	i18n("common_text_4921").isHtml = true
	i18n("common_text_4921").linearLayoutType = ccui.LinearGravity.centerHorizontal
	local label1, autoHeight = include("mailNodeFactory"):createTextLayout((i18n("common_text_4921")))
	label1:setTouchEnabled(true)
	label1:setPosition(cc.p(gMailDetaiViewWidth / 2, autoHeight / 2))
	label1:addTo(layout_Tip)
	layout_Tip:setContentSize(gMailDetaiViewWidth, autoHeight + 10)
	line:setPosition(gMailDetaiViewWidth / 2, autoHeight + 10)
	self:addChild(layout_Tip)
	totalHeight = totalHeight + autoHeight + 10
	_ENV = layout_Tip
	layout_Tip.name = "Button_advance"
	layout_Tip.fontSize = 22
	layout_Tip.titleText = i18n("battlelog_text_16")
	layout_Tip.normalImgName = "btn_BXanniu_yellow.png"
	_ENV, layout_Tip.handler = handler(self, self.onClickAdvancedAttr), handler(self, self.onClickAdvancedAttr)
	handler(self, self.onClickAdvancedAttr).left = 0
	handler(self, self.onClickAdvancedAttr).top = 10
	handler(self, self.onClickAdvancedAttr).right = 0
	layout_Tip.margin, handler(self, self.onClickAdvancedAttr).bottom = handler(self, self.onClickAdvancedAttr), 10
	local vLayout, autoHeight = mailNodeFactory:createButtonLayout(layout_Tip)
	self:addChild(vLayout)
	totalHeight = totalHeight + autoHeight
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createHeroAndSkill()
	_ENV = cc.p(gMailDetaiViewWidth / 2, autoHeight / 2)
	_ENV, cc.p(gMailDetaiViewWidth / 2, autoHeight / 2).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("Divine_beast_mark_text_53")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailHeroCollapse~bool"
	cc.p(gMailDetaiViewWidth / 2, autoHeight / 2).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(cc.p(gMailDetaiViewWidth / 2, autoHeight / 2))
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createMagicLampJinn()
	_ENV = i18n("Divine_beast_mark_text_53")
	_ENV, i18n("Divine_beast_mark_text_53").dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("magic_lamp_title_01")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailJinnCollapse~bool"
	i18n("Divine_beast_mark_text_53").dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData((i18n("Divine_beast_mark_text_53")))
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	if self.mail.property.data.mailReportType == gMailReportType.ARENA then
	else
		local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
		local resLayout = self:createManorBuff()
		if resLayout then
			_ENV = i18n("magic_lamp_title_01")
			_ENV, i18n("magic_lamp_title_01").dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("garden_btn_02")
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailManorCollapse~bool"
			i18n("magic_lamp_title_01").dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
			frameBoxInfoNode:initWithData((i18n("magic_lamp_title_01")))
			self:addChild(frameBoxInfoNode)
			totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
		end
	end
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createEliteAndRes()
	_ENV = frameBoxInfoNode
	_ENV, frameBoxInfoNode.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("mail_2_text_20")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailAwardCollapse~bool"
	frameBoxInfoNode.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(frameBoxInfoNode)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local fightDetailLayout = ccui.Layout:create()
	fightDetailLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local fightDetailHeight = 0
	local node, autoHeight = self:createFightDetail(true, self.contentData.battleInfo.attackArmyInfo)
	node:addTo(fightDetailLayout)
	fightDetailHeight = fightDetailHeight + autoHeight
	local node, autoHeight = self:createFightDetail(false, self.contentData.battleInfo.defenceArmyInfo)
	node:addTo(fightDetailLayout)
	fightDetailHeight = fightDetailHeight + autoHeight
	fightDetailLayout:setContentSize(cc.size(gMailDetaiViewWidth, fightDetailHeight))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, fightDetailHeight)
	_ENV, cc.size(gMailDetaiViewWidth, fightDetailHeight).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("mail_2_text_37")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFrame = false
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailFightCollapse~bool"
	cc.size(gMailDetaiViewWidth, fightDetailHeight).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, fightDetailLayout
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, fightDetailHeight))
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	totalHeight = totalHeight + self:createBtnSpeedDetailLayout()
	totalHeight = totalHeight + self:createBtnFightDetailLayout()
	totalHeight = totalHeight + self:createBtnFightReportLayout()
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createHeavyLose()
	dump(self.contentData, "mailItemDetailBattle:createHeavyLose", 10)
	local totalHeight = 0
	if self.contentData.playerInfo1 ~= nil and self.contentData.playerInfo2 ~= nil then
		self.contentData.playerInfo2.fightSummary.lostPower = nil
		self.contentData.playerInfo2.fightSummary.lostNum = nil
		self.contentData.playerInfo2.fightSummary.woundedNum = nil
		self.contentData.playerInfo2.fightSummary.surviveNum = nil
		self.contentData.playerInfo2.fightSummary.lostTrap = nil
		self.contentData.playerInfo2.fightSummary.killNum = nil
		self.contentData.playerInfo2.fightSummary.woundedRebackNum = nil
		self.contentData.playerInfo2.armyAttrInfo, _ENV = "mailItemDetailBattle:createHeavyLose", "mailItemDetailBattle:createHeavyLose"
		self.contentData.playerInfo2.armyAttrAddnum, _ENV = "mailItemDetailBattle:createHeavyLose", "mailItemDetailBattle:createHeavyLose"
		self.contentData.playerInfo2.battleExtraInfo, _ENV = "mailItemDetailBattle:createHeavyLose", "mailItemDetailBattle:createHeavyLose"
		if self.contentData.playerInfo2.uinfo and self.contentData.playerInfo2.uinfo.id then
			self.contentData.heroList[tostring(self.contentData.playerInfo2.uinfo.id)], _ENV = self.contentData.playerInfo2.uinfo.id, self.contentData.playerInfo2.uinfo.id
			self.contentData.armsList[tostring(self.contentData.playerInfo2.uinfo.id)], _ENV = self.contentData.playerInfo2.uinfo.id, self.contentData.playerInfo2.uinfo.id
			if self.contentData.divineBeastList then
				self.contentData.divineBeastList[tostring(self.contentData.playerInfo2.uinfo.id)], _ENV = self.contentData.playerInfo2.uinfo.id, self.contentData.playerInfo2.uinfo.id
			end
		end
		if self.contentData.battleDetails and self.contentData.battleDetails.magicLmapInfo then
			self.contentData.battleDetails.magicLmapInfo.defend = nil
		end
	end
	local headLayout = ccui.Layout:create()
	headLayout:setCascadeOpacityEnabled(true)
	local headNode = include("mailItemDetailFightHead").new()
	headNode:initData(self.mail)
	headLayout:addChild(headNode)
	headNode:setPosition(0, 0)
	headLayout:setContentSize(cc.size(headNode:getItemWidth(), headNode:getItemHeight()))
	totalHeight = totalHeight + headNode:getItemHeight()
	headLayout:addTo(self)
	_ENV = self
	self.fontSize = 24
	self.autoHeight = true
	self.str = i18n("mail_text_109")
	self.AlignH = SoraDFLabelR()
	self.color = cc.c3b(57, 11, 11)
	local loseInfoLayout, autoHeight = mailNodeFactory:createTextWithBg(self)
	self:addChild(loseInfoLayout)
	totalHeight = totalHeight + autoHeight
	totalHeight = totalHeight + self:getBattleBriefList(self.contentData.playerInfo1.fightSummary, self.contentData.playerInfo2.fightSummary)
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = self.contentData.playerInfo2.fightSummary
	_ENV, self.contentData.playerInfo2.fightSummary.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("common_text_120")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.topHeight = 30
	self.contentData.playerInfo2.fightSummary.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.showBtnAttrAnalysis = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, true
	frameBoxInfoNode:initWithData(self.contentData.playerInfo2.fightSummary)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local resLayout = self:createTroopAttr(self.contentData.playerInfo1, self.contentData.playerInfo2, 1)
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = 1
	_ENV, (1).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("battlelog_text_12")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowColorTopBg2 = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	;(1).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(1)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createAdvancedTroopAttr(self.contentData.playerInfo1, self.contentData.playerInfo2)
	_ENV = self.contentData.playerInfo2
	_ENV, self.contentData.playerInfo2.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("battlelog_text_13")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowColorTopBg2 = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	self.contentData.playerInfo2.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(self.contentData.playerInfo2)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout2 = self:createTroopAttr(self.contentData.playerInfo1, self.contentData.playerInfo2, 2)
	_ENV = self.contentData.playerInfo2
	_ENV, self.contentData.playerInfo2.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("battlelog_text_14")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowColorTopBg2 = true
	_ENV, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = i18n("battlelog_text_14"), true
	i18n("battlelog_text_14").title = i18n("battlelog_text_14")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.helpTips, i18n("battlelog_text_14").content = i18n("battlelog_text_14"), i18n("common_text_4921")
	self.contentData.playerInfo2.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout2
	frameBoxInfoNode:initWithData(self.contentData.playerInfo2)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local layout_Tip = ccui.Layout:create()
	layout_Tip:setCascadeOpacityEnabled(true)
	local line = display.newSprite("#frame_yjyh_line_02.png")
	line:addTo(layout_Tip)
	local strHtml = i18n("battlelog_text_15")
	_ENV = i18n("common_text_4921")
	i18n("common_text_4921").color = cc.c3b(83, 65, 47)
	i18n("common_text_4921").str = strHtml
	i18n("common_text_4921").fontSize = 18
	i18n("common_text_4921").AlignH = cc.TEXT_ALIGNMENT_CENTER
	i18n("common_text_4921").AlignV = cc.TEXT_ALIGNMENT_CENTER
	i18n("common_text_4921").autoHeight = true
	i18n("common_text_4921").isHtml = true
	i18n("common_text_4921").linearLayoutType = ccui.LinearGravity.centerHorizontal
	local label1, autoHeight = include("mailNodeFactory"):createTextLayout((i18n("common_text_4921")))
	label1:setTouchEnabled(true)
	label1:setPosition(cc.p(gMailDetaiViewWidth / 2, autoHeight / 2))
	label1:addTo(layout_Tip)
	layout_Tip:setContentSize(gMailDetaiViewWidth, autoHeight + 10)
	line:setPosition(gMailDetaiViewWidth / 2, autoHeight + 10)
	self:addChild(layout_Tip)
	totalHeight = totalHeight + autoHeight + 10
	_ENV = layout_Tip
	layout_Tip.name = "Button_advance"
	layout_Tip.fontSize = 22
	layout_Tip.titleText = i18n("battlelog_text_16")
	layout_Tip.normalImgName = "btn_BXanniu_yellow.png"
	_ENV, layout_Tip.handler = handler(self, self.onClickAdvancedAttr), handler(self, self.onClickAdvancedAttr)
	handler(self, self.onClickAdvancedAttr).left = 0
	handler(self, self.onClickAdvancedAttr).top = 10
	handler(self, self.onClickAdvancedAttr).right = 0
	layout_Tip.margin, handler(self, self.onClickAdvancedAttr).bottom = handler(self, self.onClickAdvancedAttr), 10
	local vLayout, autoHeight = mailNodeFactory:createButtonLayout(layout_Tip)
	self:addChild(vLayout)
	totalHeight = totalHeight + autoHeight
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createHeroAndSkill()
	_ENV = cc.p(gMailDetaiViewWidth / 2, autoHeight / 2)
	_ENV, cc.p(gMailDetaiViewWidth / 2, autoHeight / 2).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("Divine_beast_mark_text_53")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailHeroCollapse~bool"
	cc.p(gMailDetaiViewWidth / 2, autoHeight / 2).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(cc.p(gMailDetaiViewWidth / 2, autoHeight / 2))
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createMagicLampJinn()
	_ENV = i18n("Divine_beast_mark_text_53")
	_ENV, i18n("Divine_beast_mark_text_53").dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("magic_lamp_title_01")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailJinnCollapse~bool"
	i18n("Divine_beast_mark_text_53").dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData((i18n("Divine_beast_mark_text_53")))
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	if self.mail.property.data.mailReportType == gMailReportType.ARENA then
	else
		local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
		local resLayout = self:createManorBuff()
		if resLayout then
			_ENV = i18n("magic_lamp_title_01")
			_ENV, i18n("magic_lamp_title_01").dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("garden_btn_02")
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
			mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailManorCollapse~bool"
			i18n("magic_lamp_title_01").dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
			frameBoxInfoNode:initWithData((i18n("magic_lamp_title_01")))
			self:addChild(frameBoxInfoNode)
			totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
		end
	end
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createEliteAndRes()
	_ENV = frameBoxInfoNode
	_ENV, frameBoxInfoNode.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("mail_2_text_20")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailAwardCollapse~bool"
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	frameBoxInfoNode.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(frameBoxInfoNode)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	local textLayout = ccui.Layout:create()
	textLayout:setCascadeOpacityEnabled(true)
	_ENV = true
	;(true).str = i18n("common_text_480")
	;(true).color = cc.c3b(102, 50, 12)
	;(true).AlignH = cc.TEXT_ALIGNMENT_CENTER
	;(true).AlignV = cc.TEXT_ALIGNMENT_CENTER
	;(true).autoHeight = true
	local textTips, autoHeight = mailNodeFactory:createTextLayout(true)
	textTips:addTo(textLayout)
	textLayout:setContentSize(cc.size(532, 52))
	textTips:setPosition(cc.p(266, 15))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.p(266, 15)
	_ENV, cc.p(266, 15).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("mail_2_text_37")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.collageLocalKey = "Game:GameSettingView:mailFightCollapse~bool"
	cc.p(266, 15).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, textLayout
	frameBoxInfoNode:initWithData(cc.p(266, 15))
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	totalHeight = totalHeight + self:createBtnSpeedDetailLayout()
	totalHeight = totalHeight + self:createBtnFightReportLayout()
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createTextLayout()
	local totalHeight = 0
	local strDetail = "undefined"
	if self.mailSource == gMailSource.ATTACK_INVALID then
		strDetail = i18n("mail_text_329")
	elseif self.mailSource == gMailSource.SCOUT_INVALID then
		strDetail = i18n("common_text_3061")
	elseif self.mailSource == gMailSource.MASS_RECALL then
		local name = mailFunctions:getWrappedName(self.contentData.abbr, self.contentData.name, self.contentData.kid)
		_ENV = self.contentData.name
		self.contentData.name.name = name
		strDetail = i18n("common_text_4578", self.contentData.name)
	end
	local text
	_ENV = self.contentData.name
	self.contentData.name.fontSize = 20
	self.contentData.name.str = strDetail
	self.contentData.name.autoHeight = true
	self.contentData.name.AlignH = cc.TEXT_ALIGNMENT_CENTER
	self.contentData.name.linearLayoutType = ccui.LinearGravity.centerHorizontal
	self.contentData.name.color = cc.c3b(57, 11, 11)
	text, totalHeight = mailNodeFactory:createTextLayout(self.contentData.name)
	text:addTo(self)
	totalHeight = totalHeight + self:createBtnFightReportLayout()
	return totalHeight
end
function mailItemDetailBattle:createSneakInfo()
	local totalHeight = 0
	mailNodeFactory = nil
	;(nil).imgName = gMailSetTypeFunc.getSceneImgByMailSource(self.mailSource)
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	local image, autoHeight = mailNodeFactory:createImgViewLayout(nil)
	image:addTo(self)
	totalHeight = totalHeight + autoHeight
	local strDetail = ""
	if self.mailSource == gMailSource.SNEAK_SUCCESS then
		if self.contentData.peaceEndTime == 0 then
			local uinfo = self.contentData.uinfo
			if uinfo and uinfo.inBattleField then
				strDetail = i18n("common_text_4365")
			else
				strDetail = i18n("common_text_4046")
			end
		else
			local diftime = self.contentData.peaceEndTime - self.mail.property.time
			if diftime < 0 then
				diftime = 0
			end
			local timeStr = SoraDConvertSecondToString(diftime)
			mailNodeFactory = nil
			;(nil).time = timeStr
			strDetail = i18n("common_text_4045", nil)
		end
		local playLayout, autoheight = mailNodeFactory:createPlayerInfo(self.contentData)
		self:addChild(playLayout)
		totalHeight = totalHeight + autoheight
	elseif self.mailSource == gMailSource.SNEAK_INFORM then
		mailNodeFactory = self.addChild
		self.addChild.name = i18n("common_text_3034")
		strDetail = i18n("common_text_4041", self.addChild)
	end
	local isNotShowPlayerInfo = self.mailSource == gMailSource.SNEAK_INFORM
	local tipHead, autoHeight = mailNodeFactory:createLayoutRewardItemHead(isNotShowPlayerInfo and i18n("common_text_4042") or i18n("common_text_4043"))
	tipHead:addTo(self)
	totalHeight = totalHeight + autoHeight
	mailNodeFactory = self
	self.str = strDetail
	self.autoHeight = true
	self.AlignH = cc.TEXT_ALIGNMENT_CENTER
	self.color = isNotShowPlayerInfo and cc.c3b(255, 0, 0) or cc.c3b(50, 120, 60)
	local vUnderLayout, autoHeight = mailNodeFactory:createTextWithBg(self)
	self:addChild(vUnderLayout)
	totalHeight = totalHeight + autoHeight
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createRomanSoulEnd()
	local totalHeight = 0
	mailNodeFactory = nil
	;(nil).imgName = gMailSetTypeFunc.getSceneImgByMailSource(self.mailSource)
	;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
	local image, autoHeight = mailNodeFactory:createImgViewLayout(nil)
	image:addTo(self)
	totalHeight = totalHeight + autoHeight
	do
		local frameBox = include("mailItemDetailFrameBox")
		local frameBoxRomanSoulResultNode = frameBox.new()
		frameBoxRomanSoulResultNode:setSwallowTouches(false)
		local resultLayout = self:createRomanSoulResultEndLayout()
		mailNodeFactory = nil
		mailNodeFactory, (nil).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
		mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
		mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("common_text_1472")
		;(nil).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resultLayout
		frameBoxRomanSoulResultNode:initWithData(nil)
		self:addChild(frameBoxRomanSoulResultNode)
		totalHeight = totalHeight + frameBoxRomanSoulResultNode:getItemHeight()
	end
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createRomanSoulResultEndLayout()
	local vLayout = ccui.Layout:create()
	local totalHeight = 0
	vLayout:setCascadeOpacityEnabled(true)
	local labelInfo = ccui.Text:create()
	_ENV = nil
	;(nil).waves = self.contentData.waves
	;(nil).score = self.contentData.score
	local strInfo = i18n("common_text_1480", nil)
	labelInfo:setFontSize(21)
	labelInfo:setString(strInfo)
	labelInfo:setTextHorizontalAlignment(SoraDFLabelR())
	labelInfo:setColor(cc.c3b(102, 50, 12))
	labelInfo:setAnchorPoint(SoraDFAP(1, 0))
	labelInfo:setPosition(SoraDFPoint(600, 0, self.itemWidth))
	vLayout:addChild(labelInfo)
	local infoHeight = SoraDGetAutoHeightLabel(labelInfo, 560)
	local labelWave = ccui.Text:create()
	local strWaveInfo = i18n("common_text_1515")
	labelWave:setName("labelWave")
	labelWave:setTextHorizontalAlignment(SoraDFLabelR())
	labelWave:setFontSize(21)
	labelWave:setString(strWaveInfo)
	labelWave:setColor(cc.c3b(102, 50, 12))
	labelWave:setAnchorPoint(SoraDFAP(1, 0))
	labelWave:setPosition(SoraDFPoint(600, 0, self.itemWidth))
	vLayout:addChild(labelWave)
	local waveInfoWidth = labelWave:getContentSize().width
	local waveInfoHeight = labelWave:getContentSize().height
	local labelWaveTime = ccui.Text:create()
	labelWaveTime:setFontSize(21)
	labelWaveTime:setString(self.contentData.waves)
	labelWaveTime:setName("labelWaveTime")
	labelWaveTime:setColor(cc.c3b(115, 41, 41))
	labelWaveTime:setTextHorizontalAlignment(SoraDFLabelR())
	labelWaveTime:setAnchorPoint(SoraDFAP(1, 0))
	labelWaveTime:setPosition(SoraDFPoint(600 - waveInfoWidth, 0, self.itemWidth))
	vLayout:addChild(labelWaveTime)
	local labelScoreInfo = ccui.Text:create()
	local strScorefo = i18n("common_text_1471")
	labelScoreInfo:setName("labelScoreInfo")
	labelScoreInfo:setTextHorizontalAlignment(SoraDFLabelR())
	labelScoreInfo:setFontSize(21)
	labelScoreInfo:setString(strScorefo)
	labelScoreInfo:setColor(cc.c3b(102, 50, 12))
	labelScoreInfo:setAnchorPoint(SoraDFAP(1, 0))
	labelScoreInfo:setPosition(SoraDFPoint(600, 0, self.itemWidth))
	vLayout:addChild(labelScoreInfo)
	local scoreInfoWidth = labelScoreInfo:getContentSize().width
	local scoreInfoHeight = labelScoreInfo:getContentSize().height
	local labelScore = ccui.Text:create()
	labelScore:setFontSize(21)
	labelScore:setString(self.contentData.score)
	labelScore:setName("labelScore")
	labelScore:setColor(cc.c3b(115, 41, 41))
	labelScore:setTextHorizontalAlignment(SoraDFLabelR())
	labelScore:setAnchorPoint(SoraDFAP(1, 0))
	labelScore:setPosition(SoraDFPoint(600 - scoreInfoWidth, 0, self.itemWidth))
	vLayout:addChild(labelScore)
	local allianceScoreInfoHeight = 0
	if self.contentData.allianceScore and self.contentData.allianceScore ~= 0 then
		local labelAllianceScoreInfo = ccui.Text:create()
		local strScorefo = i18n("common_text_2730")
		labelAllianceScoreInfo:setFontSize(21)
		labelAllianceScoreInfo:setString(strScorefo)
		labelAllianceScoreInfo:setTextHorizontalAlignment(SoraDFLabelR())
		labelAllianceScoreInfo:setColor(cc.c3b(102, 50, 12))
		labelAllianceScoreInfo:setAnchorPoint(SoraDFAP(1, 0))
		labelAllianceScoreInfo:setPosition(SoraDFPoint(502, 0, self.itemWidth))
		vLayout:addChild(labelAllianceScoreInfo)
		local scoreAllianceInfoWidth = labelAllianceScoreInfo:getContentSize().width
		allianceScoreInfoHeight = labelAllianceScoreInfo:getContentSize().height
		local labelAllianceScore = ccui.Text:create()
		labelAllianceScore:setFontSize(21)
		labelAllianceScore:setString(self.contentData.allianceScore)
		labelAllianceScore:setColor(cc.c3b(115, 41, 41))
		labelAllianceScore:setTextHorizontalAlignment(SoraDFLabelR())
		labelAllianceScore:setAnchorPoint(SoraDFAP(1, 0))
		labelAllianceScore:setPosition(SoraDFPoint(502 - scoreAllianceInfoWidth, 0, self.itemWidth))
		vLayout:addChild(labelAllianceScore)
	end
	local labelOtherInfo = ccui.Text:create()
	local strOtherfo = i18n("common_text_1514")
	labelOtherInfo:setFontSize(21)
	labelOtherInfo:setString(strOtherfo)
	labelOtherInfo:setTextHorizontalAlignment(SoraDFLabelR())
	labelOtherInfo:setColor(cc.c3b(102, 50, 12))
	labelOtherInfo:setAnchorPoint(SoraDFAP(1, 0))
	labelOtherInfo:setPosition(SoraDFPoint(502, 0, self.itemWidth))
	vLayout:addChild(labelOtherInfo)
	local otherInfoHeight = SoraDGetAutoHeightLabel(labelOtherInfo, 472)
	local otherInfoWidth = labelOtherInfo:getContentSize().width
	local otherInfoHeight = labelOtherInfo:getContentSize().height
	totalHeight = totalHeight + otherInfoHeight + allianceScoreInfoHeight + scoreInfoHeight + waveInfoHeight + infoHeight + 40
	vLayout:setContentSize(cc.size(self.itemWidth, totalHeight))
	local accumulateH = 20
	labelOtherInfo:setPositionY(accumulateH)
	accumulateH = accumulateH + otherInfoHeight
	labelScoreInfo:setPositionY(accumulateH)
	labelScore:setPositionY(accumulateH)
	accumulateH = accumulateH + scoreInfoHeight
	labelWave:setPositionY(accumulateH)
	labelWaveTime:setPositionY(accumulateH)
	accumulateH = accumulateH + waveInfoHeight
	labelInfo:setPositionY(accumulateH)
	return vLayout
end
function mailItemDetailBattle:createAllianceArmyLayout()
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalWidth = gMailDetaiViewWidth
	local totalHeight = self:createItems(vLayout, "createAllianceArmyItem", self.contentData.reinforcements.playersInfo)
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	local frameBoxResInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(totalWidth, totalHeight)
	_ENV, cc.size(totalWidth, totalHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
	include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isHideTop = true
	cc.size(totalWidth, totalHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxResInfoNode:initWithData(cc.size(totalWidth, totalHeight))
	return frameBoxResInfoNode, frameBoxResInfoNode:getItemHeight()
end
function mailItemDetailBattle:createAllianceArmyItem(item)
	local vLayout = ccui.VBox:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	if not item.allianceInfo then
		local _ENV, allianceInfo = item.allianceInfo, item.allianceInfo
	end
	if not item.uinfo then
		local _ENV, uinfo = item.uinfo, item.uinfo
	end
	local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
	local playerInfoNode = include("mailItemDetailPlayerInfo").new()
	_ENV = nil
	;(nil).id = uinfo.playerId or uinfo.id
	;(nil).iconID = uinfo.iconID
	;(nil).avatar = uinfo.avatar
	;(nil).name = strName
	;(nil).lv = uinfo.lv or 0
	;(nil).power = item.defenceArmyNum
	playerInfoNode:initWithCommonData(nil)
	vLayout:addChild(playerInfoNode)
	totalHeight = totalHeight + playerInfoNode:getItemHeight()
	_ENV = playerInfoNode
	playerInfoNode.imgName = "frame_yjyh_line_02.png"
	playerInfoNode.imagWidth = 563
	playerInfoNode.imagHeight = 6
	playerInfoNode.linearLayoutType = ccui.LinearGravity.centerHorizontal
	local line, autoHeight = mailNodeFactory:createImgViewLayout(playerInfoNode)
	line:addTo(vLayout)
	_ENV = vLayout
	vLayout.str = i18n("remains_text_156")
	vLayout.linearLayoutType = ccui.LinearGravity.centerHorizontal
	vLayout.color = cc.c3b(105, 56, 21)
	vLayout.AlignH = cc.TEXT_ALIGNMENT_CENTER
	local textTitle, autoHeight = mailNodeFactory:createTextLayout(vLayout)
	textTitle:addTo(vLayout)
	totalHeight = totalHeight + autoHeight + 6
	if item.heroInfo and 0 < #item.heroInfo or item.armsInfo and 0 < #item.armsInfo or item.divineBeastInfo and 0 < #item.divineBeastInfo then
		local heroLayout, autoHeight = mailNodeFactory:createHeroInfoLayout(item, 2)
		heroLayout:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	if not item.armyInfo then
		_ENV = item.armyInfo
	end
	totalHeight = totalHeight + self:createItems(vLayout, "createItemArmy", item.armyInfo)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	return vLayout
end
function mailItemDetailBattle:createItemArmy(item)
	return mailNodeFactory:getArmyItem(item)
end
function mailItemDetailBattle:createOnlyShowAdvancedAttr()
	local totalHeight = 0
	local headLayout = ccui.Layout:create()
	headLayout:setCascadeOpacityEnabled(true)
	local headNode = include("mailItemDetailFightHead").new()
	headNode:initData(self.mail)
	headLayout:addChild(headNode)
	headNode:setPosition(0, 0)
	headLayout:setContentSize(cc.size(headNode:getItemWidth(), headNode:getItemHeight()))
	totalHeight = totalHeight + headNode:getItemHeight()
	headLayout:addTo(self)
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	local resLayout = self:createAdvancedTroopAttrV2(self.contentData.playerInfo1, self.contentData.playerInfo2)
	_ENV = self.contentData.playerInfo2
	_ENV, self.contentData.playerInfo2.dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("share_text_03")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowFightColor = true
	self.contentData.playerInfo2.dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, resLayout
	frameBoxInfoNode:initWithData(self.contentData.playerInfo2)
	self:addChild(frameBoxInfoNode)
	if resLayout:getContentSize().height == 0 then
		_ENV = frameBoxInfoNode
		frameBoxInfoNode.str = i18n("mail_2_text_80")
		frameBoxInfoNode.color = cc.c3b(102, 50, 12)
		frameBoxInfoNode.AlignH = cc.TEXT_ALIGNMENT_CENTER
		frameBoxInfoNode.AlignV = cc.TEXT_ALIGNMENT_CENTER
		_ENV, frameBoxInfoNode.linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 15
		ccui.LinearGravity.centerHorizontal.right = 0
		frameBoxInfoNode.margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 0
		frameBoxInfoNode.autoHeight = true
		local textTips, autoHeight = mailNodeFactory:createTextLayout(frameBoxInfoNode)
		textTips:addTo(self)
		totalHeight = totalHeight + autoHeight
	end
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:createFightDetailInfo()
	local totalHeight = 0
	local isDefense = self:getIsDefense()
	local headLayout = ccui.Layout:create()
	headLayout:setCascadeOpacityEnabled(true)
	local headNode = include("mailItemDetailFightHead").new()
	headNode:initData(self.mail, true)
	headNode:setArmyNum()
	headLayout:addChild(headNode)
	headNode:setPosition(0, 0)
	headLayout:setContentSize(cc.size(headNode:getItemWidth(), headNode:getItemHeight()))
	totalHeight = totalHeight + headNode:getItemHeight()
	headLayout:addTo(self)
	local offsetHeight = math.max(0, display.height - 854) / 6
	local attackName = mailDesParser.getPlayerFightTitle(self.contentData, self.contentData.playerInfo1, #self.contentData.battleInfo.attackArmyInfo)
	local defendName = mailDesParser.getPlayerFightTitle(self.contentData, self.contentData.playerInfo2, #self.contentData.battleInfo.defenceArmyInfo)
	dump(self.contentData.battleDetails.roundArmy, "self.contentData.battleDetails1")
	dump(self.contentData.battleDetails.roundLiveNum, "self.contentData.battleDetails2")
	if IsArClient then
		local vLayout = ccui.Layout:create()
		vLayout:setCascadeOpacityEnabled(true)
		vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
		local Com_Mail_BattlePreview = fguiHelper.createObject("mailView", "Com_Mail_BattlePreview")
		Com_Mail_BattlePreview:initData(self.contentData, isDefense)
		Com_Mail_BattlePreview:addTo(vLayout)
		vLayout:setContentSize(cc.size(gMailDetaiViewWidth, Com_Mail_BattlePreview:getHeight()))
		local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
		_ENV = cc.size(gMailDetaiViewWidth, Com_Mail_BattlePreview:getHeight())
		_ENV, cc.size(gMailDetaiViewWidth, Com_Mail_BattlePreview:getHeight()).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("battlelog_text_55")
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFrame = false
		cc.size(gMailDetaiViewWidth, Com_Mail_BattlePreview:getHeight()).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
		frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, Com_Mail_BattlePreview:getHeight()))
		self:addChild(frameBoxInfoNode)
		totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	end
	if IsArClient then
		local vLayout = ccui.Layout:create()
		vLayout:setCascadeOpacityEnabled(true)
		vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
		local tempHeight = 0
		dump(self.contentData, "self.contentData")
		local _ENV, effectTimes = dump, dump
		if self.contentData.battleDetails.effectTimes and next(self.contentData.battleDetails.effectTimes) then
			effectTimes.attack_shield = self.contentData.battleDetails.effectTimes.attack and self.contentData.battleDetails.effectTimes.attack[tostring(gBattleEffctStatType.FIRST_ROUND_HP_SHIELD)]
			effectTimes.defend_shield = self.contentData.battleDetails.effectTimes.defend and self.contentData.battleDetails.effectTimes.defend[tostring(gBattleEffctStatType.FIRST_ROUND_HP_SHIELD)]
		end
		local attackIntimidateInfo, defendIntimidateInfo
		if not self.contentData.playerInfo1 or not self.contentData.playerInfo1.fightSummary then
			_ENV = self.contentData.playerInfo1.fightSummary
		end
		if not self.contentData.playerInfo2 or not self.contentData.playerInfo2.fightSummary then
			_ENV = self.contentData.playerInfo2.fightSummary
		end
		local attackTotalNum, defendTotalNum = mailFunctions:getTotalNumStr(self.contentData.playerInfo1.fightSummary, self.contentData.playerInfo2.fightSummary, true)
		local intimidateInfo = self.contentData.battleDetails and self.contentData.battleDetails.intimidateInfo
		local intimidateSelfArmyNum = intimidateInfo and tonumber(intimidateInfo.selfArmyNum)
		if intimidateSelfArmyNum then
			if attackTotalNum == intimidateSelfArmyNum then
				attackIntimidateInfo = intimidateInfo
			elseif defendTotalNum == intimidateSelfArmyNum then
				defendIntimidateInfo = intimidateInfo
			end
		end
		if not self.contentData.heroList[tostring(self.contentData.playerInfo1.uinfo.id)] then
			local _ENV, attackHero = self.contentData.heroList[tostring(self.contentData.playerInfo1.uinfo.id)], self.contentData.heroList[tostring(self.contentData.playerInfo1.uinfo.id)]
		end
		if not self.contentData.armsList[tostring(self.contentData.playerInfo1.uinfo.id)] then
			local _ENV, attackArms = self.contentData.armsList[tostring(self.contentData.playerInfo1.uinfo.id)], self.contentData.armsList[tostring(self.contentData.playerInfo1.uinfo.id)]
		end
		local attackRetreat
		if self.contentData.battleDetails and self.contentData.battleDetails.retreat then
			attackRetreat = self.contentData.battleDetails.retreat.defend
		end
		local pierceRatePlus
		if self.contentData.battleDetails.pierceRatePlus then
			pierceRatePlus = self.contentData.battleDetails.pierceRatePlus
		end
		if not self.contentData.divineBeastList or not self.contentData.divineBeastList[tostring(self.contentData.playerInfo1.uinfo.id)] then
			local _ENV, attackDivineBeasts = self.contentData.divineBeastList[tostring(self.contentData.playerInfo1.uinfo.id)], self.contentData.divineBeastList[tostring(self.contentData.playerInfo1.uinfo.id)]
		end
		if not self.contentData.divineBeastMarkList or not self.contentData.divineBeastMarkList[tostring(self.contentData.playerInfo1.uinfo.id)] then
			local _ENV, attackDBMarks = self.contentData.divineBeastMarkList[tostring(self.contentData.playerInfo1.uinfo.id)], self.contentData.divineBeastMarkList[tostring(self.contentData.playerInfo1.uinfo.id)]
		end
		if not self.contentData.playerInfo2 or not self.contentData.playerInfo2.armyAttrInfo then
			local _ENV, armyAttrInfo = self.contentData.playerInfo2.armyAttrInfo, self.contentData.playerInfo2.armyAttrInfo
		end
		if not (self.contentData.battleDetails and self.contentData.battleDetails.akdfhpDmgPlus) or not self.contentData.battleDetails.akdfhpDmgPlus.attack then
			local _ENV, atkAkdfhpDmgPlus = self.contentData.battleDetails.akdfhpDmgPlus.attack, self.contentData.battleDetails.akdfhpDmgPlus.attack
		end
		dump(atkAkdfhpDmgPlus, "atkAkdfhpDmgPlus")
		if not (self.contentData.battleDetails and self.contentData.battleDetails.akdfhpDmgReduce) or not self.contentData.battleDetails.akdfhpDmgReduce.attack then
			local _ENV, atkAkdfhpDmgReduce = self.contentData.battleDetails.akdfhpDmgReduce.attack, self.contentData.battleDetails.akdfhpDmgReduce.attack
		end
		if not (self.contentData.battleDetails and self.contentData.battleDetails.buffDetail) or not self.contentData.battleDetails.buffDetail.attack then
			local _ENV, atkBuffDetail = self.contentData.battleDetails.buffDetail.attack, self.contentData.battleDetails.buffDetail.attack
		end
		dump(atkBuffDetail, "atkBuffDetail")
		local attackLayout, autoHeight = mailNodeFactory:createFightPrepareTextList(attackName, true, not isDefense, attackHero, attackArms, attackDivineBeasts, attackDBMarks, effectTimes.attack_shield, defendName, attackRetreat, armyAttrInfo, pierceRatePlus, atkAkdfhpDmgPlus, nil, attackIntimidateInfo, atkAkdfhpDmgReduce, atkBuffDetail)
		vLayout:addChild(attackLayout)
		tempHeight = tempHeight + autoHeight
		if self.contentData.playerInfo2.uinfo then
			if not self.contentData.heroList[tostring(self.contentData.playerInfo2.uinfo.id)] then
				local _ENV, defendHero = self.contentData.heroList[tostring(self.contentData.playerInfo2.uinfo.id)], self.contentData.heroList[tostring(self.contentData.playerInfo2.uinfo.id)]
			end
			if not self.contentData.armsList[tostring(self.contentData.playerInfo2.uinfo.id)] then
				local _ENV, defendArms = self.contentData.armsList[tostring(self.contentData.playerInfo2.uinfo.id)], self.contentData.armsList[tostring(self.contentData.playerInfo2.uinfo.id)]
			end
			if not self.contentData.divineBeastList or not self.contentData.divineBeastList[tostring(self.contentData.playerInfo2.uinfo.id)] then
				local _ENV, defendDivineBeasts = self.contentData.divineBeastList[tostring(self.contentData.playerInfo2.uinfo.id)], self.contentData.divineBeastList[tostring(self.contentData.playerInfo2.uinfo.id)]
			end
			if not self.contentData.divineBeastMarkList or not self.contentData.divineBeastMarkList[tostring(self.contentData.playerInfo2.uinfo.id)] then
				local _ENV, defendDBMarks = self.contentData.divineBeastMarkList[tostring(self.contentData.playerInfo2.uinfo.id)], self.contentData.divineBeastMarkList[tostring(self.contentData.playerInfo2.uinfo.id)]
			end
			local defendRetreat
			if self.contentData.battleDetails and self.contentData.battleDetails.retreat then
				defendRetreat = self.contentData.battleDetails.retreat.attack
			end
			local defPalacePierceRatePlus
			if self.contentData.battleDetails.defPalacePierceRatePlus then
				defPalacePierceRatePlus = self.contentData.battleDetails.defPalacePierceRatePlus
			end
			if not self.contentData.playerInfo1 or not self.contentData.playerInfo1.armyAttrInfo then
				local _ENV, armyAttrInfo = self.contentData.playerInfo1.armyAttrInfo, self.contentData.playerInfo1.armyAttrInfo
			end
			if not (self.contentData.battleDetails and self.contentData.battleDetails.akdfhpDmgPlus) or not self.contentData.battleDetails.akdfhpDmgPlus.defend then
				local _ENV, defAkdfhpDmgPlus = self.contentData.battleDetails.akdfhpDmgPlus.defend, self.contentData.battleDetails.akdfhpDmgPlus.defend
			end
			if not (self.contentData.battleDetails and self.contentData.battleDetails.akdfhpDmgReduce) or not self.contentData.battleDetails.akdfhpDmgReduce.defend then
				local _ENV, defAkdfhpDmgReduce = self.contentData.battleDetails.akdfhpDmgReduce.defend, self.contentData.battleDetails.akdfhpDmgReduce.defend
			end
			if not (self.contentData.battleDetails and self.contentData.battleDetails.buffDetail) or not self.contentData.battleDetails.buffDetail.defend then
				local _ENV, defBuffDetail = self.contentData.battleDetails.buffDetail.defend, self.contentData.battleDetails.buffDetail.defend
			end
			local defendLayout, autoHeight = mailNodeFactory:createFightPrepareTextList(defendName, false, isDefense, defendHero, defendArms, defendDivineBeasts, defendDBMarks, effectTimes.defend_shield, attackName, defendRetreat, armyAttrInfo, nil, defAkdfhpDmgPlus, defPalacePierceRatePlus, defendIntimidateInfo, defAkdfhpDmgReduce, defBuffDetail)
			vLayout:addChild(defendLayout)
			tempHeight = tempHeight + autoHeight
		end
		vLayout:setContentSize(cc.size(gMailDetaiViewWidth, tempHeight))
		local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
		_ENV = cc.size(gMailDetaiViewWidth, tempHeight)
		_ENV, cc.size(gMailDetaiViewWidth, tempHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("fight_mail_18")
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = vLayout
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isEnableCollapse = true
		cc.size(gMailDetaiViewWidth, tempHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.collageLocalKey = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, "Game:GameSettingView:mailFighPreparetLog~bool"
		frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, tempHeight))
		self:addChild(frameBoxInfoNode)
		totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	else
		local frameBoxInfoNode = mailNodeFactory:createFightEndTextList(self:getFightDetailBeginStrList(), i18n("fight_mail_18"), 55 + offsetHeight)
		self:addChild(frameBoxInfoNode)
		totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	end
	if IsArClient and self.contentData.battleDetails.battleDetailsV1[1] and self.contentData.battleDetails.battleDetailsV1[1][5] then
		local vLayout = ccui.Layout:create()
		vLayout:setCascadeOpacityEnabled(true)
		vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
		local _ENV, allRoundDatas = vLayout.setLayoutType, vLayout.setLayoutType
		local round
		local showRound = 0
		for i, v in ipairs(self.contentData.battleDetails.battleDetailsV1) do
			if v[6] ~= round then
				round = v[6]
				if round == 0 then
					showRound = 0
				else
					showRound = showRound + 1
				end
			end
			if not allRoundDatas[showRound] then
				_ENV = allRoundDatas[showRound]
			end
			allRoundDatas[showRound] = allRoundDatas[showRound]
			table.insert(allRoundDatas[showRound], v)
		end
		local countHeight = 0
		for i = 0, table.nums(allRoundDatas) do
			local v = allRoundDatas[i]
			if v then
				local preRealRound = allRoundDatas[i - 1] and allRoundDatas[i - 1][1] and allRoundDatas[i - 1][1][6] or 0
				local Com_Mail_BattleRoundRecount = fguiHelper.createObject("mailView", "Com_Mail_BattleRoundRecount")
				Com_Mail_BattleRoundRecount:initData(self.contentData, v, isDefense, i, preRealRound, attackName, defendName)
				Com_Mail_BattleRoundRecount:addTo(vLayout)
				Com_Mail_BattleRoundRecount:setY(countHeight)
				countHeight = countHeight + Com_Mail_BattleRoundRecount:getHeight()
				print("Com_Mail_BattleRoundRecount:getHeight()", Com_Mail_BattleRoundRecount:getHeight())
			end
		end
		vLayout:setContentSize(cc.size(gMailDetaiViewWidth, countHeight))
		local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
		_ENV = cc.size(gMailDetaiViewWidth, countHeight)
		_ENV, cc.size(gMailDetaiViewWidth, countHeight).dataType = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.textShowTitle = i18n("fight_mail_19")
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFightTop = true
		include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.isShowFrame = false
		cc.size(gMailDetaiViewWidth, countHeight).dataContent, include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM.customNode = include("mailUIConstDef").MAIL_UI_TYPE_CUSTOM, vLayout
		frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, countHeight))
		self:addChild(frameBoxInfoNode)
		totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	else
		local frameBoxInfoNode = mailNodeFactory:createFightEndTextList(self:getFightDetailFightingStrList(), i18n("fight_mail_19"), 55 + offsetHeight)
		self:addChild(frameBoxInfoNode)
		totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	end
	local frameBoxInfoNode = mailNodeFactory:createFightEndTextList(self:getFightDetailEndStrList(), i18n("fight_mail_20"), 55 + offsetHeight)
	self:addChild(frameBoxInfoNode)
	totalHeight = totalHeight + frameBoxInfoNode:getItemHeight()
	self.itemHeight = totalHeight
end
function mailItemDetailBattle:getBattleBriefList(attackSummary, defenceSummary)
	local unknownStr = "????"
	local mailFunctions, items
	local attackTotalNum, defenceTotalNum = mailFunctions:getTotalNumStr(attackSummary, defenceSummary)
	mailFunctions, _UPVALUE7_ = defenceSummary, attackSummary
	defenceSummary.strName = i18n("common_text_1477")
	defenceSummary.attackNum = attackSummary.lostPower and string.formatnumberthousands(attackSummary.lostPower) or unknownStr
	defenceSummary.defenceNum = defenceSummary.lostPower and string.formatnumberthousands(defenceSummary.lostPower) or unknownStr
	mailFunctions, defenceSummary.color = cc.c3b(234, 23, 22), cc.c3b(234, 23, 22)
	cc.c3b(234, 23, 22).strName = i18n("mail_2_text_27")
	cc.c3b(234, 23, 22).attackNum = attackTotalNum
	cc.c3b(234, 23, 22).defenceNum = defenceTotalNum
	mailFunctions, cc.c3b(234, 23, 22).color = cc.c3b(102, 50, 12), cc.c3b(102, 50, 12)
	cc.c3b(102, 50, 12).strName = i18n("battlelog_text_10")
	cc.c3b(102, 50, 12).attackNum = attackSummary.killNum and string.formatnumberthousands(attackSummary.killNum) or unknownStr
	cc.c3b(102, 50, 12).defenceNum = defenceSummary.killNum and string.formatnumberthousands(defenceSummary.killNum) or unknownStr
	mailFunctions, cc.c3b(102, 50, 12).color = cc.c3b(0, 110, 0), cc.c3b(0, 110, 0)
	cc.c3b(0, 110, 0).strName = i18n("mail_2_text_28")
	cc.c3b(0, 110, 0).attackNum = attackSummary.lostNum and string.formatnumberthousands(attackSummary.lostNum) or unknownStr
	cc.c3b(0, 110, 0).defenceNum = defenceSummary.lostNum and string.formatnumberthousands(defenceSummary.lostNum) or unknownStr
	mailFunctions, cc.c3b(0, 110, 0).color = cc.c3b(160, 40, 40), cc.c3b(160, 40, 40)
	cc.c3b(160, 40, 40).strName = i18n("mail_2_text_29")
	cc.c3b(160, 40, 40).attackNum = attackSummary.woundedNum and string.formatnumberthousands(attackSummary.woundedNum) or unknownStr
	cc.c3b(160, 40, 40).defenceNum = defenceSummary.woundedNum and string.formatnumberthousands(defenceSummary.woundedNum) or unknownStr
	mailFunctions, cc.c3b(160, 40, 40).color = cc.c3b(160, 40, 40), cc.c3b(160, 40, 40)
	cc.c3b(160, 40, 40).strName = i18n("mail_2_text_30")
	cc.c3b(160, 40, 40).attackNum = attackSummary.surviveNum and string.formatnumberthousands(attackSummary.surviveNum) or unknownStr
	cc.c3b(160, 40, 40).defenceNum = defenceSummary.surviveNum and string.formatnumberthousands(defenceSummary.surviveNum) or unknownStr
	mailFunctions, cc.c3b(160, 40, 40).color = cc.c3b(0, 110, 0), cc.c3b(0, 110, 0)
	cc.c3b(0, 110, 0).strName = i18n("accessories_skill_11")
	cc.c3b(0, 110, 0).attackNum = attackSummary.woundedRebackNum and string.formatnumberthousands(attackSummary.woundedRebackNum) or unknownStr
	cc.c3b(0, 110, 0).defenceNum = defenceSummary.woundedRebackNum and string.formatnumberthousands(defenceSummary.woundedRebackNum) or unknownStr
	cc.c3b(0, 110, 0).color = cc.c3b(0, 110, 0)
	attackSummary[1] = defenceSummary
	attackSummary[2] = cc.c3b(234, 23, 22)
	attackSummary[3] = cc.c3b(102, 50, 12)
	attackSummary[4] = cc.c3b(0, 110, 0)
	attackSummary[5] = cc.c3b(160, 40, 40)
	attackSummary[6] = cc.c3b(160, 40, 40)
	local attackSummary[7], items = cc.c3b(0, 110, 0), attackSummary
	local briefLayout, autoHeight = mailNodeFactory:createFightBriefLayout(items)
	self:addChild(briefLayout)
	local totalHeight = autoHeight
	local showFightDetail = true
	if self.mailSource == gMailSource.ATTACK_CITY_BIG_FAILURE or self.mailSource == gMailSource.ATTACK_TROOP_BIG_FAILURE then
		showFightDetail = false
	end
	if showFightDetail then
		local vLayout = ccui.Layout:create()
		vLayout:setCascadeOpacityEnabled(true)
		vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
		local detailBtnTitle = i18n("battlelog_text_11")
		local callback = handler(self, self.onBtnDetail)
		local layout_Tip = ccui.Layout:create()
		layout_Tip:setCascadeOpacityEnabled(true)
		mailFunctions = detailBtnTitle
		detailBtnTitle.u = "true"
		detailBtnTitle.c = "true"
		detailBtnTitle.color = "#006E00"
		local strHtml = SoraDWrapHtmlTagByStyle(i18n(detailBtnTitle), detailBtnTitle)
		mailFunctions = nil
		;(nil).color = "#53412F"
		strHtml = SoraDWrapHtmlTagByStyle(strHtml, nil)
		mailFunctions = nil
		;(nil).color = cc.c3b(255, 255, 255)
		;(nil).str = strHtml
		;(nil).fontSize = 20
		;(nil).AlignH = cc.TEXT_ALIGNMENT_CENTER
		;(nil).AlignV = cc.TEXT_ALIGNMENT_CENTER
		;(nil).autoHeight = true
		;(nil).isHtml = true
		;(nil).linearLayoutType = ccui.LinearGravity.centerHorizontal
		local label1, autoHeight = include("mailNodeFactory"):createTextLayout(nil)
		label1:setTouchEnabled(true)
		label1:addTouchEventListener(callback)
		label1:setPosition(cc.p(gMailDetaiViewWidth / 2, autoHeight / 2 + 5))
		label1:addTo(layout_Tip)
		layout_Tip:setContentSize(gMailDetaiViewWidth, autoHeight + 10)
		layout_Tip:addTo(vLayout)
		vLayout:setContentSize(cc.size(gMailDetaiViewWidth, autoHeight + 10))
		self:addChild(vLayout)
		totalHeight = totalHeight + autoHeight + 10
	end
	return totalHeight
end
function mailItemDetailBattle:createEliteInfo(eliteInfoData)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 50
	local node = display.newNode()
	node:setCascadeOpacityEnabled(true)
	node:addTo(vLayout)
	local eliteIcon = display.newSprite("#icon_Elite_Poin.png")
	eliteIcon:addTo(node)
	eliteIcon:setPosition(0, 0)
	local labelName = ccui.Text:create()
	labelName:setFontSize(22)
	labelName:setColor(cc.c3b(102, 50, 12))
	labelName:setString(i18n("common_text_3130"))
	labelName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	labelName:addTo(node)
	local labelNum = ccui.Text:create()
	labelNum:setFontSize(22)
	labelNum:setColor(cc.c3b(0, 110, 0))
	labelNum:setString(string.formatnumberthousands(eliteInfoData.power) or 0)
	labelNum:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	labelNum:addTo(node)
	SoraDToCenter(node)
	local tipHeight = 0
	if eliteInfoData.reachMax == 0 then
		local textTip
		_ENV = cc.c3b(0, 110, 0)
		cc.c3b(0, 110, 0).fontSize = 18
		cc.c3b(0, 110, 0).str = i18n("common_text_3131")
		cc.c3b(0, 110, 0).color = cc.c3b(102, 50, 12)
		cc.c3b(0, 110, 0).autoHeight = true
		textTip, tipHeight = mailNodeFactory:createTextLayout(cc.c3b(0, 110, 0))
		totalHeight = totalHeight + tipHeight
		textTip:addTo(vLayout)
		textTip:setPosition(gMailDetaiViewWidth / 2, 6)
	end
	local imgLine = ccui.ImageView:create()
	imgLine:loadTexture("frame_yjyh_line_02.png", ccui.TextureResType.plistType)
	imgLine:ignoreContentAdaptWithSize(false)
	imgLine:setContentSize(cc.size(563, 6))
	imgLine:addTo(vLayout)
	imgLine:setPosition(gMailDetaiViewWidth / 2, 0)
	totalHeight = totalHeight + 6
	vLayout:setContentSize(gMailDetaiViewWidth, totalHeight)
	node:setPosition(gMailDetaiViewWidth / 2, totalHeight - 25)
	return vLayout, totalHeight
end
function mailItemDetailBattle:createEliteAndRes()
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	local eliteInfo
	if self:getIsDefense() then
		if self.contentData.defenderElitePointInfo then
			eliteInfo = self.contentData.defenderElitePointInfo[tostring(self:getReceiverPlayerId())]
		end
	elseif self.contentData.attackerElitePointInfo then
		eliteInfo = self.contentData.attackerElitePointInfo[tostring(self:getReceiverPlayerId())]
	end
	if eliteInfo ~= nil and 0 < eliteInfo.power then
		local eliteLayout, autoHeight = self:createEliteInfo(eliteInfo)
		vLayout:addChild(eliteLayout)
		totalHeight = totalHeight + autoHeight
	end
	local isDefense = self:getIsDefense()
	local resInfo = self:getRobRes()
	if resInfo and next(resInfo) then
		local resLayout, autoHeight = mailNodeFactory:createResList(resInfo, isDefense)
		vLayout:addChild(resLayout)
		totalHeight = totalHeight + autoHeight
	end
	if totalHeight <= 0 then
		_ENV = vLayout.addChild
		vLayout.addChild.str = i18n("common_text_480")
		vLayout.addChild.color = cc.c3b(102, 50, 12)
		vLayout.addChild.AlignH = cc.TEXT_ALIGNMENT_CENTER
		vLayout.addChild.AlignV = cc.TEXT_ALIGNMENT_CENTER
		_ENV, vLayout.addChild.linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 15
		ccui.LinearGravity.centerHorizontal.right = 0
		vLayout.addChild.margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 0
		local textTips, autoHeight = mailNodeFactory:createTextLayout(vLayout.addChild)
		textTips:addTo(vLayout)
		totalHeight = totalHeight + 52
	end
	vLayout:setContentSize(gMailDetaiViewWidth, totalHeight)
	return vLayout, totalHeight
end
function mailItemDetailBattle:createHeroAndSkill()
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 0
	local heroLayout = include("mailItemDetailFightHero").new()
	heroLayout:initData(self.contentData)
	if heroLayout:getItemHeight() == 0 then
		_ENV = self.contentData
		self.contentData.str = i18n("common_text_480")
		self.contentData.color = cc.c3b(102, 50, 12)
		self.contentData.AlignH = cc.TEXT_ALIGNMENT_CENTER
		self.contentData.AlignV = cc.TEXT_ALIGNMENT_CENTER
		self.contentData.point = cc.p(0.5, 0.5)
		self.contentData.pos = cc.p(gMailDetaiViewWidth / 2, 26)
		local textTips, autoHeight = mailNodeFactory:createTextLayout(self.contentData)
		textTips:addTo(vLayout)
		totalHeight = totalHeight + 52
	else
		totalHeight = heroLayout:getItemHeight()
		heroLayout:addTo(vLayout)
		heroLayout:setPosition(0, 0)
	end
	vLayout:setContentSize(heroLayout:getItemWidth(), totalHeight)
	return vLayout
end
function mailItemDetailBattle:createMagicLampJinn()
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local totalHeight = 0
	local jinnLayout = include("mailItemDetailFightJinn").new()
	jinnLayout:initData(self.contentData)
	if jinnLayout:getItemHeight() == 0 then
		_ENV = self.contentData
		self.contentData.str = i18n("common_text_480")
		self.contentData.color = cc.c3b(102, 50, 12)
		self.contentData.AlignH = cc.TEXT_ALIGNMENT_CENTER
		self.contentData.AlignV = cc.TEXT_ALIGNMENT_CENTER
		self.contentData.point = cc.p(0.5, 0.5)
		self.contentData.pos = cc.p(gMailDetaiViewWidth / 2, 26)
		local textTips, autoHeight = mailNodeFactory:createTextLayout(self.contentData)
		textTips:addTo(vLayout)
		totalHeight = totalHeight + 52
	else
		totalHeight = jinnLayout:getItemHeight()
		jinnLayout:addTo(vLayout)
		jinnLayout:setPosition(0, 0)
	end
	vLayout:setContentSize(jinnLayout:getItemWidth(), totalHeight)
	return vLayout
end
_ENV, mailItemDetailBattle.createManorBuff = function(self)
	local leftData = self.contentData.playerInfo2.uinfo
	local rightData = self.contentData.playerInfo1.uinfo
	local isShowLeft = leftData and leftData.gardenLv and leftData.gardenLv > 0
	local isShowRight = rightData and rightData.gardenLv and rightData.gardenLv > 0
	if not isShowLeft and not isShowRight then
		return nil
	end
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local Com_Mail_ItemDetailFight = fguiHelper.createObject("mailView", "Com_Mail_ItemDetailFight")
	Com_Mail_ItemDetailFight:initManorData(self.contentData)
	Com_Mail_ItemDetailFight:addTo(vLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, Com_Mail_ItemDetailFight:getHeight()))
	return vLayout
end, function(self)
	local leftData = self.contentData.playerInfo2.uinfo
	local rightData = self.contentData.playerInfo1.uinfo
	local isShowLeft = leftData and leftData.gardenLv and leftData.gardenLv > 0
	local isShowRight = rightData and rightData.gardenLv and rightData.gardenLv > 0
	if not isShowLeft and not isShowRight then
		return nil
	end
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local Com_Mail_ItemDetailFight = fguiHelper.createObject("mailView", "Com_Mail_ItemDetailFight")
	Com_Mail_ItemDetailFight:initManorData(self.contentData)
	Com_Mail_ItemDetailFight:addTo(vLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, Com_Mail_ItemDetailFight:getHeight()))
	return vLayout
end
;(function(self)
	local leftData = self.contentData.playerInfo2.uinfo
	local rightData = self.contentData.playerInfo1.uinfo
	local isShowLeft = leftData and leftData.gardenLv and leftData.gardenLv > 0
	local isShowRight = rightData and rightData.gardenLv and rightData.gardenLv > 0
	if not isShowLeft and not isShowRight then
		return nil
	end
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local Com_Mail_ItemDetailFight = fguiHelper.createObject("mailView", "Com_Mail_ItemDetailFight")
	Com_Mail_ItemDetailFight:initManorData(self.contentData)
	Com_Mail_ItemDetailFight:addTo(vLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, Com_Mail_ItemDetailFight:getHeight()))
	return vLayout
end)[gTroopAttrType.HURT] = true
local (function(self)
	local leftData = self.contentData.playerInfo2.uinfo
	local rightData = self.contentData.playerInfo1.uinfo
	local isShowLeft = leftData and leftData.gardenLv and leftData.gardenLv > 0
	local isShowRight = rightData and rightData.gardenLv and rightData.gardenLv > 0
	if not isShowLeft and not isShowRight then
		return nil
	end
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local Com_Mail_ItemDetailFight = fguiHelper.createObject("mailView", "Com_Mail_ItemDetailFight")
	Com_Mail_ItemDetailFight:initManorData(self.contentData)
	Com_Mail_ItemDetailFight:addTo(vLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, Com_Mail_ItemDetailFight:getHeight()))
	return vLayout
end)[gTroopAttrType.DMG_REDUCE], damageAttrType = true, function(self)
	local leftData = self.contentData.playerInfo2.uinfo
	local rightData = self.contentData.playerInfo1.uinfo
	local isShowLeft = leftData and leftData.gardenLv and leftData.gardenLv > 0
	local isShowRight = rightData and rightData.gardenLv and rightData.gardenLv > 0
	if not isShowLeft and not isShowRight then
		return nil
	end
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	local Com_Mail_ItemDetailFight = fguiHelper.createObject("mailView", "Com_Mail_ItemDetailFight")
	Com_Mail_ItemDetailFight:initManorData(self.contentData)
	Com_Mail_ItemDetailFight:addTo(vLayout)
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, Com_Mail_ItemDetailFight:getHeight()))
	return vLayout
end
function mailItemDetailBattle:createTroopAttr(attackPlayer, defencePlayer, showType)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	local defaultStr = "--"
	if self.mailSource == gMailSource.ATTACK_CITY_BIG_FAILURE or self.mailSource == gMailSource.ATTACK_TROOP_BIG_FAILURE then
		defaultStr = "????"
	end
	local _ENV, items = self.mailSource, self.mailSource
	if not attackPlayer.armyAttrInfo then
		_ENV = attackPlayer.armyAttrInfo
	end
	for i, v in ipairs(attackPlayer.armyAttrInfo) do
		if v.num and 0 < v.num and (not (showType ~= 1 or damageAttrType[v.attrType]) or showType == 2 and damageAttrType[v.attrType]) then
			local isAdd = false
			local color = cc.c3b(160, 40, 40)
			if v.attrBuff == 1 then
				isAdd = true
				color = cc.c3b(0, 110, 0)
			end
			local key = v.attrType
			if v.targetId then
				key = key .. "_" .. v.targetId
			end
			if not items[key] then
				items[key], _ENV = items[key], items[key]
			end
			local showValue
			if showType == 1 then
				showValue = math.floor(v.num)
			else
				showValue = v.num
			end
			items[key].attackNum = mailFunctions:getFormatedPercentNum(isAdd, showValue)
			items[key].baseAttackNum = isAdd and showValue or -showValue
			items[key].strName = mailFunctions:getFormattedTroopAttr(v.targetId, v.attrType)
			items[key].attackColor = color
			items[key].sortIndex = mailFunctions:getSortIndex(v.targetId, v.attrType)
		end
	end
	_UPVALUE4_ = (for generator)
	ipairs(attackPlayer.armyAttrInfo)[1] = i18n("common_text_143")
	ipairs(attackPlayer.armyAttrInfo)[2] = i18n("common_text_144")
	ipairs(attackPlayer.armyAttrInfo)[3] = i18n("common_text_145")
	ipairs(attackPlayer.armyAttrInfo)[4] = i18n("common_text_146")
	ipairs(attackPlayer.armyAttrInfo)[5] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[6] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[7] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[8] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[9] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[10] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[11] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[12] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[13] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[14] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[15] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[16] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[17] = i18n("common_text_3772")
	ipairs(attackPlayer.armyAttrInfo)[18] = i18n("common_text_3772")
	local ipairs(attackPlayer.armyAttrInfo)[19], armyClassName = i18n("common_text_3772")
	if attackPlayer.battleExtraInfo then
		local battleExtraInfo = attackPlayer.battleExtraInfo
		local color = cc.c3b(0, 110, 0)
		if battleExtraInfo.dmgPlus2Target and showType == 2 then
			for armyClass, dmgPlus2Target in pairs(battleExtraInfo.dmgPlus2Target) do
				for toArmy, num in pairs(dmgPlus2Target) do
					local key = tostring(1001) .. "_" .. tostring(armyClass) .. "_" .. tostring(toArmy)
					if not items[key] then
						_ENV = items[key]
					end
					items[key] = items[key]
					items[key].baseAttackNum = num
					items[key].attackNum = tostring(num / 10) .. "%"
					_ENV = tostring(toArmy)
					tostring(toArmy).name1 = armyClassName[tonumber(armyClass)]
					tostring(toArmy).name2 = armyClassName[tonumber(toArmy)]
					items[key].strName = i18n("common_text_4919", (tostring(toArmy)))
					items[key].attackColor = color
					items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), tonumber(toArmy) + 40)
				end
			end
		end
		if battleExtraInfo.dmgReduce2Target and showType == 2 then
			for armyClass, reduceSelfDmgPlus in pairs(battleExtraInfo.dmgReduce2Target) do
				for toArmy, num in pairs(reduceSelfDmgPlus) do
					local key = tostring(1002) .. "_" .. tostring(armyClass) .. "_" .. tostring(toArmy)
					if not items[key] then
						_ENV = items[key]
					end
					items[key] = items[key]
					items[key].baseAttackNum = num
					items[key].attackNum = tostring(num / 10) .. "%"
					_ENV = tostring(toArmy)
					tostring(toArmy).name1 = armyClassName[tonumber(armyClass)]
					tostring(toArmy).name2 = armyClassName[tonumber(toArmy)]
					items[key].strName = i18n("common_text_4920", (tostring(toArmy)))
					items[key].attackColor = color
					items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), tonumber(toArmy) + 50)
				end
			end
		end
	end
	if attackPlayer.mnzdExtraInfo and showType == 1 then
		_UPVALUE5_ = attackPlayer.mnzdExtraInfo
		attackPlayer.mnzdExtraInfo[1] = gArmyClass.infantry
		attackPlayer.mnzdExtraInfo[2] = gArmyClass.cavalry
		attackPlayer.mnzdExtraInfo[3] = gArmyClass.archer
		attackPlayer.mnzdExtraInfo[4] = gArmyClass.charists
		local attackPlayer.mnzdExtraInfo[5], armyClassList = gArmyClass.elite, attackPlayer.mnzdExtraInfo
		for _, armyClass in ipairs(armyClassList) do
			local increaseHitRate = attackPlayer.mnzdExtraInfo.increaseHitRate[tostring(armyClass)]
			if increaseHitRate then
				local key = tostring(1003) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = increaseHitRate
				items[key].attackNum = tostring(increaseHitRate / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队命中值"
				items[key].attackColor = cc.c3b(255, 255, 0)
				items[key].sortIndex = 1003
			end
			local armyDodgePlus = attackPlayer.mnzdExtraInfo.armyDodgePlus[tostring(armyClass)]
			if armyDodgePlus then
				local key = tostring(1004) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = armyDodgePlus
				items[key].attackNum = tostring(armyDodgePlus / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队闪避值"
				items[key].attackColor = cc.c3b(255, 255, 0)
				items[key].sortIndex = 1004
			end
			local punctureDmgPlus = attackPlayer.mnzdExtraInfo.punctureDmgPlus[tostring(armyClass)]
			if punctureDmgPlus then
				local key = tostring(1005) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = punctureDmgPlus
				items[key].attackNum = tostring(punctureDmgPlus / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队穿刺伤害比"
				items[key].attackColor = cc.c3b(255, 255, 0)
				items[key].sortIndex = 1005
			end
			local armyCritPlus = attackPlayer.mnzdExtraInfo.armyCritPlus[tostring(armyClass)]
			if armyCritPlus then
				local key = tostring(1006) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = armyCritPlus
				items[key].attackNum = tostring(armyCritPlus / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队暴击率"
				items[key].attackColor = cc.c3b(255, 255, 0)
				items[key].sortIndex = 1006
			end
		end
	end
	if not defencePlayer.armyAttrInfo then
		_ENV = defencePlayer.armyAttrInfo
	end
	for i, v in ipairs(defencePlayer.armyAttrInfo) do
		if v.num and 0 < v.num and (not (showType ~= 1 or damageAttrType[v.attrType]) or showType == 2 and damageAttrType[v.attrType]) then
			local isAdd = false
			local color = cc.c3b(160, 40, 40)
			if v.attrBuff == 1 then
				isAdd = true
				color = cc.c3b(0, 110, 0)
			end
			local key = v.attrType
			if v.targetId then
				key = key .. "_" .. v.targetId
			end
			if not items[key] then
				items[key], _ENV = items[key], items[key]
			end
			local showValue
			if showType == 1 then
				showValue = math.floor(v.num)
			else
				showValue = v.num
			end
			items[key].baseDefenceNum = isAdd and showValue or -showValue
			local attrType
			if attrType == gTroopAttrType.TRAP_ATK or attrType == gTroopAttrType.HURT then
				if self.mailSource == gMailSource.DEFENSE_CITY_VICTORY or self.mailSource == gMailSource.DEFENSE_CITY_LOSE or self.mailSource == gMailSource.ATTACT_CITY_VICTORY or self.mailSource == gMailSource.ATTACT_CITY_LOSE then
					items[key].defenceNum = mailFunctions:getFormatedPercentNum(isAdd, showValue)
					items[key].strName = mailFunctions:getFormattedTroopAttr(v.targetId, v.attrType)
					items[key].defenceColor = color
					items[key].sortIndex = mailFunctions:getSortIndex(v.targetId, v.attrType)
				end
			else
				items[key].defenceNum = mailFunctions:getFormatedPercentNum(isAdd, showValue)
				items[key].strName = mailFunctions:getFormattedTroopAttr(v.targetId, v.attrType)
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(v.targetId, v.attrType)
			end
		end
	end
	if defencePlayer.battleExtraInfo then
		local battleExtraInfo = defencePlayer.battleExtraInfo
		local color = cc.c3b(0, 110, 0)
		if battleExtraInfo.dmgPlus2Target and showType == 2 then
			for armyClass, dmgPlus2Target in pairs(battleExtraInfo.dmgPlus2Target) do
				for toArmy, num in pairs(dmgPlus2Target) do
					local key = tostring(1001) .. "_" .. tostring(armyClass) .. "_" .. tostring(toArmy)
					if not items[key] then
						_ENV = items[key]
					end
					items[key] = items[key]
					items[key].baseDefenceNum = num
					items[key].defenceNum = tostring(num / 10) .. "%"
					_ENV = tostring(toArmy)
					tostring(toArmy).name1 = armyClassName[tonumber(armyClass)]
					tostring(toArmy).name2 = armyClassName[tonumber(toArmy)]
					items[key].strName = i18n("common_text_4919", (tostring(toArmy)))
					items[key].defenceColor = color
					items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), tonumber(toArmy) + 40)
				end
			end
		end
		if battleExtraInfo.dmgReduce2Target and showType == 2 then
			for armyClass, reduceSelfDmgPlus in pairs(battleExtraInfo.dmgReduce2Target) do
				for toArmy, num in pairs(reduceSelfDmgPlus) do
					local key = tostring(1002) .. "_" .. tostring(armyClass) .. "_" .. tostring(toArmy)
					if not items[key] then
						_ENV = items[key]
					end
					items[key] = items[key]
					items[key].baseDefenceNum = num
					items[key].defenceNum = tostring(num / 10) .. "%"
					_ENV = tostring(toArmy)
					tostring(toArmy).name1 = armyClassName[tonumber(armyClass)]
					tostring(toArmy).name2 = armyClassName[tonumber(toArmy)]
					items[key].strName = i18n("common_text_4920", (tostring(toArmy)))
					items[key].defenceColor = color
					items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), tonumber(toArmy) + 50)
				end
			end
		end
	end
	if defencePlayer.mnzdExtraInfo and showType == 1 then
		_UPVALUE5_ = defencePlayer.mnzdExtraInfo
		defencePlayer.mnzdExtraInfo[1] = gArmyClass.infantry
		defencePlayer.mnzdExtraInfo[2] = gArmyClass.cavalry
		defencePlayer.mnzdExtraInfo[3] = gArmyClass.archer
		defencePlayer.mnzdExtraInfo[4] = gArmyClass.charists
		local defencePlayer.mnzdExtraInfo[5], armyClassList = gArmyClass.elite, defencePlayer.mnzdExtraInfo
		for _, armyClass in ipairs(armyClassList) do
			local increaseHitRate = defencePlayer.mnzdExtraInfo.increaseHitRate[tostring(armyClass)]
			if increaseHitRate then
				local key = tostring(1003) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = increaseHitRate
				items[key].defenceNum = tostring(increaseHitRate / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队命中值"
				items[key].defenceColor = cc.c3b(0, 255, 0)
				items[key].sortIndex = 1003
			end
			local armyDodgePlus = defencePlayer.mnzdExtraInfo.armyDodgePlus[tostring(armyClass)]
			if armyDodgePlus then
				local key = tostring(1004) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = armyDodgePlus
				items[key].defenceNum = tostring(armyDodgePlus / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队闪避值"
				items[key].defenceColor = cc.c3b(0, 255, 0)
				items[key].sortIndex = 1004
			end
			local punctureDmgPlus = defencePlayer.mnzdExtraInfo.punctureDmgPlus[tostring(armyClass)]
			if punctureDmgPlus then
				local key = tostring(1005) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = punctureDmgPlus
				items[key].defenceNum = tostring(punctureDmgPlus / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队穿刺伤害比"
				items[key].defenceColor = cc.c3b(0, 255, 0)
				items[key].sortIndex = 1005
			end
			local armyCritPlus = defencePlayer.mnzdExtraInfo.armyCritPlus[tostring(armyClass)]
			if armyCritPlus then
				local key = tostring(1006) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = armyCritPlus
				items[key].defenceNum = tostring(armyCritPlus / 10) .. "%"
				items[key].strName = armyClassName[armyClass] .. "部队暴击率"
				items[key].defenceColor = cc.c3b(0, 255, 0)
				items[key].sortIndex = 1006
			end
		end
	end
	local isDefense = self:getIsDefense()
	for key, item in ipairs(self:sortAttrList(items)) do
		if next(item) then
			item.defaultStr = defaultStr
			item.baseDefenceNum = item.baseDefenceNum or 0
			item.baseAttackNum = item.baseAttackNum or 0
			if item.baseDefenceNum ~= 0 or item.baseAttackNum ~= 0 then
				if isDefense then
					item.defenceCompareResult = item.baseDefenceNum > item.baseAttackNum and 1 or item.baseDefenceNum < item.baseAttackNum and 2 or 0
				else
					item.attackCompareResult = item.baseAttackNum > item.baseDefenceNum and 1 or item.baseAttackNum < item.baseDefenceNum and 2 or 0
				end
				print("item.compareResult", item.defenceCompareResult, item.attackCompareResult, isDefense, item.baseDefenceNum, item.baseAttackNum)
				local hLayout = mailNodeFactory:createFightBriefItem(item, key)
				totalHeight = totalHeight + hLayout:getContentSize().height
				vLayout:addChild(hLayout)
			end
		end
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	return vLayout
end
function mailItemDetailBattle:createAdvancedTroopAttr(attackPlayer, defencePlayer)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	local defaultStr = "--"
	if self.mailSource == gMailSource.ATTACK_CITY_BIG_FAILURE or self.mailSource == gMailSource.ATTACK_TROOP_BIG_FAILURE then
		defaultStr = "????"
	end
	local isDefense = self:getIsDefense()
	local _ENV, items = self, self
	if not attackPlayer.armyAttrAddnum then
		_ENV = attackPlayer.armyAttrAddnum
	end
	for i, v in ipairs(attackPlayer.armyAttrAddnum) do
		if v.num and 0 < v.num then
			local isAdd = false
			local color = cc.c3b(160, 40, 40)
			if v.attrBuff == 1 then
				isAdd = true
				color = cc.c3b(0, 110, 0)
			end
			local key = v.attrType
			if v.targetId then
				key = key .. "_" .. v.targetId
			end
			if not items[key] then
				items[key], _ENV = items[key], items[key]
			end
			items[key].baseAttackNum = isAdd and v.num or -v.num
			if v.attrType ~= gTroopAttrType.ATK_SPEED_ADD then
				items[key].attackNum = mailFunctions:getFormatedNum(isAdd, v.num)
			else
				items[key].attackNum = mailFunctions:getFormatedPercentNum(isAdd, v.num / 10)
			end
			items[key].strName = mailFunctions:getFormattedTroopAttr(v.targetId, v.attrType)
			items[key].attackColor = color
			items[key].sortIndex = mailFunctions:getSortIndex(v.targetId, v.attrType)
		end
	end
	if not defencePlayer.armyAttrAddnum then
		_ENV = defencePlayer.armyAttrAddnum
	end
	for i, v in ipairs(defencePlayer.armyAttrAddnum) do
		if v.num and 0 < v.num then
			local isAdd = false
			local color = cc.c3b(160, 40, 40)
			if v.attrBuff == 1 then
				isAdd = true
				color = cc.c3b(0, 110, 0)
			end
			local key = v.attrType
			if v.targetId then
				key = key .. "_" .. v.targetId
			end
			if not items[key] then
				items[key], _ENV = items[key], items[key]
			end
			items[key].baseDefenceNum = isAdd and v.num or -v.num
			local attrType
			if attrType == gTroopAttrType.TRAP_ATK or attrType == gTroopAttrType.HURT then
				if self.mailSource == gMailSource.DEFENSE_CITY_VICTORY or self.mailSource == gMailSource.DEFENSE_CITY_LOSE or self.mailSource == gMailSource.ATTACT_CITY_VICTORY or self.mailSource == gMailSource.ATTACT_CITY_LOSE then
					items[key].defenceNum = mailFunctions:getFormatedNum(isAdd, v.num)
					items[key].strName = mailFunctions:getFormattedTroopAttr(v.targetId, v.attrType)
					items[key].defenceColor = color
					items[key].sortIndex = mailFunctions:getSortIndex(v.targetId, v.attrType)
				end
			else
				if v.attrType ~= gTroopAttrType.ATK_SPEED_ADD then
					items[key].defenceNum = mailFunctions:getFormatedNum(isAdd, v.num)
				else
					items[key].defenceNum = mailFunctions:getFormatedPercentNum(isAdd, v.num / 10)
				end
				items[key].strName = mailFunctions:getFormattedTroopAttr(v.targetId, v.attrType)
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(v.targetId, v.attrType)
			end
		end
	end
	local isDefense = self:getIsDefense()
	for key, item in ipairs(self:sortAttrList(items)) do
		if next(item) then
			item.defaultStr = defaultStr
			item.isDefense = isDefense
			item.baseDefenceNum = item.baseDefenceNum or 0
			item.baseAttackNum = item.baseAttackNum or 0
			if isDefense then
				item.defenceCompareResult = item.baseDefenceNum > item.baseAttackNum and 1 or item.baseDefenceNum < item.baseAttackNum and 2 or 0
			else
				item.attackCompareResult = item.baseAttackNum > item.baseDefenceNum and 1 or item.baseAttackNum < item.baseDefenceNum and 2 or 0
			end
			local hLayout = mailNodeFactory:createFightBriefItem(item, key)
			totalHeight = totalHeight + hLayout:getContentSize().height
			vLayout:addChild(hLayout)
		end
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	return vLayout
end
function mailItemDetailBattle:createAdvancedTroopAttrV2(attackPlayer, defencePlayer)
	local vLayout = ccui.Layout:create()
	vLayout:setCascadeOpacityEnabled(true)
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	local defaultStr = "--"
	if self.mailSource == gMailSource.ATTACK_CITY_BIG_FAILURE or self.mailSource == gMailSource.ATTACK_TROOP_BIG_FAILURE then
		defaultStr = "????"
	end
	_UPVALUE4_ = self.mailSource
	self.mailSource[1] = i18n("common_text_143")
	self.mailSource[2] = i18n("common_text_144")
	self.mailSource[3] = i18n("common_text_145")
	self.mailSource[4] = i18n("common_text_146")
	self.mailSource[5] = i18n("common_text_3772")
	self.mailSource[6] = i18n("common_text_3772")
	self.mailSource[7] = i18n("common_text_3772")
	self.mailSource[8] = i18n("common_text_3772")
	self.mailSource[9] = i18n("common_text_3772")
	self.mailSource[10] = i18n("common_text_3772")
	self.mailSource[11] = i18n("common_text_3772")
	self.mailSource[12] = i18n("common_text_3772")
	self.mailSource[13] = i18n("common_text_3772")
	self.mailSource[14] = i18n("common_text_3772")
	self.mailSource[15] = i18n("common_text_3772")
	local self.mailSource[16], armyClassName = i18n("common_text_3772")
	local isDefense = self:getIsDefense()
	local _ENV, items = self, self
	if attackPlayer.battleExtraInfo then
		local battleExtraInfo = attackPlayer.battleExtraInfo
		local color = cc.c3b(0, 110, 0)
		if battleExtraInfo.increaseHitRate then
			for armyClass, num in pairs(battleExtraInfo.increaseHitRate) do
				local key = tostring(1001) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = i18n("common_text_3772")
				i18n("common_text_3772").name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_23", i18n("common_text_3772"))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 40)
			end
		end
		if battleExtraInfo.armyDodgePlus then
			for armyClass, num in pairs(battleExtraInfo.armyDodgePlus) do
				local key = tostring(1002) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_24", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 50)
			end
		end
		if battleExtraInfo.punctureDmgPlus then
			for armyClass, num in pairs(battleExtraInfo.punctureDmgPlus) do
				local key = tostring(1003) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_25", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 60)
			end
		end
		if battleExtraInfo.punctureDmgReduce then
			for armyClass, num in pairs(battleExtraInfo.punctureDmgReduce) do
				local key = tostring(1004) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_26", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 70)
			end
		end
		if battleExtraInfo.armyCritPlus then
			for armyClass, num in pairs(battleExtraInfo.armyCritPlus) do
				local key = tostring(1005) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_27", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 80)
			end
		end
		if battleExtraInfo.dmgExtraPlusForCrit then
			for armyClass, num in pairs(battleExtraInfo.dmgExtraPlusForCrit) do
				local key = tostring(1006) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_28", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 90)
			end
		end
		dump(battleExtraInfo.strikeBackDamagePlus, "battleExtraInfo.strikeBackDamagePlus")
		if battleExtraInfo.strikeBackDamagePlus then
			for armyClass, num in pairs(battleExtraInfo.strikeBackDamagePlus) do
				local key = tostring(1007) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_29", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 100)
			end
		end
		if battleExtraInfo.strikeBackDamageReduce then
			for armyClass, num in pairs(battleExtraInfo.strikeBackDamageReduce) do
				local key = tostring(1008) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_30", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 110)
			end
		end
		if battleExtraInfo.critReduce then
			for armyClass, num in pairs(battleExtraInfo.critReduce) do
				local key = tostring(1009) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseAttackNum = num
				items[key].attackNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("mail_2_text_97", (tonumber(armyClass)))
				items[key].attackColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 120)
			end
		end
	end
	if defencePlayer.battleExtraInfo then
		local battleExtraInfo = defencePlayer.battleExtraInfo
		local color = cc.c3b(0, 110, 0)
		if battleExtraInfo.increaseHitRate then
			for armyClass, num in pairs(battleExtraInfo.increaseHitRate) do
				local key = tostring(1001) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_23", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 40)
			end
		end
		if battleExtraInfo.armyDodgePlus then
			for armyClass, num in pairs(battleExtraInfo.armyDodgePlus) do
				local key = tostring(1002) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_24", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 50)
			end
		end
		if battleExtraInfo.punctureDmgPlus then
			for armyClass, num in pairs(battleExtraInfo.punctureDmgPlus) do
				local key = tostring(1003) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_25", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 60)
			end
		end
		if battleExtraInfo.punctureDmgReduce then
			for armyClass, num in pairs(battleExtraInfo.punctureDmgReduce) do
				local key = tostring(1004) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_26", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 70)
			end
		end
		if battleExtraInfo.armyCritPlus then
			for armyClass, num in pairs(battleExtraInfo.armyCritPlus) do
				local key = tostring(1005) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_27", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 80)
			end
		end
		if battleExtraInfo.dmgExtraPlusForCrit then
			for armyClass, num in pairs(battleExtraInfo.dmgExtraPlusForCrit) do
				local key = tostring(1006) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_28", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 90)
			end
		end
		if battleExtraInfo.strikeBackDamagePlus then
			for armyClass, num in pairs(battleExtraInfo.strikeBackDamagePlus) do
				local key = tostring(1007) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_29", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 100)
			end
		end
		if battleExtraInfo.strikeBackDamageReduce then
			for armyClass, num in pairs(battleExtraInfo.strikeBackDamageReduce) do
				local key = tostring(1008) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("battlelog_text_30", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 110)
			end
		end
		if battleExtraInfo.critReduce then
			for armyClass, num in pairs(battleExtraInfo.critReduce) do
				local key = tostring(1009) .. "_" .. tostring(armyClass)
				if not items[key] then
					_ENV = items[key]
				end
				items[key] = items[key]
				items[key].baseDefenceNum = num
				items[key].defenceNum = tostring(num / 10) .. "%"
				_ENV = tonumber(armyClass)
				tonumber(armyClass).name = armyClassName[tonumber(armyClass)]
				items[key].strName = i18n("mail_2_text_97", (tonumber(armyClass)))
				items[key].defenceColor = color
				items[key].sortIndex = mailFunctions:getSortIndex(tonumber(armyClass), 120)
			end
		end
	end
	local isDefense = self:getIsDefense()
	dump(items, "sortAttrList items")
	for key, item in ipairs(self:sortAttrList(items)) do
		if next(item) then
			item.defaultStr = defaultStr
			item.isDefense = isDefense
			item.baseDefenceNum = item.baseDefenceNum or 0
			item.baseAttackNum = item.baseAttackNum or 0
			if item.baseDefenceNum ~= 0 or item.baseAttackNum ~= 0 then
				if isDefense then
					item.defenceCompareResult = item.baseDefenceNum > item.baseAttackNum and 1 or item.baseDefenceNum < item.baseAttackNum and 2 or 0
				else
					item.attackCompareResult = item.baseAttackNum > item.baseDefenceNum and 1 or item.baseAttackNum < item.baseDefenceNum and 2 or 0
				end
				local hLayout = mailNodeFactory:createFightBriefItem(item, key)
				totalHeight = totalHeight + hLayout:getContentSize().height
				vLayout:addChild(hLayout)
			end
		end
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	return vLayout
end
function mailItemDetailBattle:createFightDetail(isAttack, armyInfo)
	local vLayout = ccui.Layout:create()
	vLayout:setLayoutType(ccui.LayoutType.VERTICAL)
	local totalHeight = 0
	if armyInfo and next(armyInfo) then
		local headLayout = ccui.Layout:create()
		local headNode = include("mailItemDetailFightInfo").new()
		headNode:setPosition(0, 0)
		headNode:addTo(headLayout)
		headLayout:addTo(vLayout)
		headLayout:setContentSize(cc.size(headNode:getItemWidth(), headNode:getItemHeight()))
		totalHeight = totalHeight + headNode:getItemHeight()
		for index, v in ipairs(self:getFightDetailList(armyInfo)) do
			local hLayout = ccui.Layout:create()
			local fdInfoNode = include("mailItemDetailFightSingle").new()
			fdInfoNode:initData(v, index)
			fdInfoNode:setPosition(0, 0)
			fdInfoNode:addTo(hLayout)
			hLayout:setContentSize(cc.size(fdInfoNode:getItemWidth(), fdInfoNode:getItemHeight()))
			hLayout:addTo(vLayout)
			totalHeight = totalHeight + fdInfoNode:getItemHeight()
		end
	else
		_ENV = ipairs(self:getFightDetailList(armyInfo))
		ipairs(self:getFightDetailList(armyInfo)).str = i18n("common_text_480")
		ipairs(self:getFightDetailList(armyInfo)).color = cc.c3b(102, 50, 12)
		ipairs(self:getFightDetailList(armyInfo)).AlignH = cc.TEXT_ALIGNMENT_CENTER
		ipairs(self:getFightDetailList(armyInfo)).AlignV = cc.TEXT_ALIGNMENT_CENTER
		_ENV, ipairs(self:getFightDetailList(armyInfo)).linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
		ccui.LinearGravity.centerHorizontal.left = 0
		ccui.LinearGravity.centerHorizontal.top = 15
		ccui.LinearGravity.centerHorizontal.right = 0
		ipairs(self:getFightDetailList(armyInfo)).margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 0
		ipairs(self:getFightDetailList(armyInfo)).autoHeight = true
		local textTips, autoHeight = mailNodeFactory:createTextLayout(ipairs(self:getFightDetailList(armyInfo)))
		textTips:addTo(vLayout)
		totalHeight = totalHeight + autoHeight
	end
	vLayout:setContentSize(cc.size(gMailDetaiViewWidth, totalHeight))
	local frameBoxInfoNode = include("mailItemDetailFrameBox").new()
	_ENV = cc.size(gMailDetaiViewWidth, totalHeight)
	_ENV, cc.size(gMailDetaiViewWidth, totalHeight).dataType = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, mailUIConstDef.MAIL_UI_TYPE_CUSTOM
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.textShowTitle = isAttack and i18n("common_text_125") or i18n("common_text_126")
	mailUIConstDef.MAIL_UI_TYPE_CUSTOM.isShowBlueTop = not isAttack
	cc.size(gMailDetaiViewWidth, totalHeight).dataContent, mailUIConstDef.MAIL_UI_TYPE_CUSTOM.customNode = mailUIConstDef.MAIL_UI_TYPE_CUSTOM, vLayout
	frameBoxInfoNode:initWithData(cc.size(gMailDetaiViewWidth, totalHeight))
	return frameBoxInfoNode, frameBoxInfoNode:getItemHeight()
end
function mailItemDetailBattle:createItems(vLayout, funcName, items)
	local totalHeight = 0
	for _, item in ipairs(items) do
		local hLayout = self[funcName](self, item)
		local lp3 = ccui.LinearLayoutParameter:create()
		hLayout:setLayoutParameter(lp3)
		lp3:setGravity(ccui.LinearGravity.centerHorizontal)
		totalHeight = totalHeight + hLayout:getContentSize().height
		vLayout:addChild(hLayout)
	end
	return totalHeight
end
function mailItemDetailBattle:createItemSimple(item)
	return mailNodeFactory:createNameWithNum(item)
end
function mailItemDetailBattle:createAtlantisWarSkillInfo(skillList)
	local vLayout = ccui.VBox:create()
	local totalWidth = 310
	local totalHeight = 0
	local nodeH = math.ceil(#skillList / 3) * 100
	totalHeight = totalHeight + nodeH
	local skillNode = display.newNode()
	skillNode:addTo(vLayout)
	for i, skillId in ipairs(skillList) do
		local btnSkill = ccui.Button:create()
		btnSkill:addTo(skillNode)
		btnSkill:loadTextures("frame_bskxq_btnbg_01.png", "", "", ccui.TextureResType.plistType)
		btnSkill = SoraDCreatePanelByCloneNode(btnSkill, "commonBtnInstance")
		btnSkill:setSwallowTouches(false)
		btnSkill:setScale(0.75)
		local row = math.ceil(i / 3)
		local col = (i - 1) % 3 + 1
		btnSkill:setPosition(20 + 90 * (col - 0.5), nodeH - 100 * (row - 0.5))
		local imgSkill = ccui.ImageView:create()
		imgSkill:addTo(btnSkill)
		local ASD = require_data("atlantiswar_skill_display").data
		imgSkill:loadTexture(ASD[skillId].img, ccui.TextureResType.plistType)
		imgSkill:setPosition(57, 57)
	end
	vLayout:setContentSize(cc.size(totalWidth, totalHeight))
	return vLayout
end
function mailItemDetailBattle:createBtnDetailLayout()
	mailNodeFactory = nil
	;(nil).name = "Button_Detail"
	;(nil).fontSize = 22
	;(nil).titleText = i18n("common_text_121")
	;(nil).normalImgName = "btn_BXanniu_yellow.png"
	mailNodeFactory, (nil).handler = handler(self, self.onBtnDetail), handler(self, self.onBtnDetail)
	handler(self, self.onBtnDetail).left = 0
	handler(self, self.onBtnDetail).top = 10
	handler(self, self.onBtnDetail).right = 0
	;(nil).margin, handler(self, self.onBtnDetail).bottom = handler(self, self.onBtnDetail), 10
	local vLayout, totalHeight = mailNodeFactory:createButtonLayout(nil)
	self:addChild(vLayout)
	return totalHeight
end
function mailItemDetailBattle:createBtnFightDetailLayout()
	if IsArClient and self.contentData.battleDetails and self.contentData.battleDetails.battleDetailsV1 and next(self.contentData.battleDetails.battleDetailsV1) then
		_ENV = nil
		;(nil).name = "Button_Detail"
		;(nil).fontSize = 22
		;(nil).titleText = i18n("fight_mail_01")
		;(nil).normalImgName = "btn_BXanniu_yellow.png"
		_ENV, (nil).handler = handler(self, self.onBtnFightDetail), handler(self, self.onBtnFightDetail)
		handler(self, self.onBtnFightDetail).left = 0
		handler(self, self.onBtnFightDetail).top = 10
		handler(self, self.onBtnFightDetail).right = 0
		;(nil).margin, handler(self, self.onBtnFightDetail).bottom = handler(self, self.onBtnFightDetail), 10
		local vLayout, totalHeight = mailNodeFactory:createButtonLayout(nil)
		self:addChild(vLayout)
		return totalHeight
	end
	return 0
end
function mailItemDetailBattle:createBtnSpeedDetailLayout()
	local totalHeight = 0
	local viewAngle = mailFunctions:getViewAngleFromMail(self.mail)
	if self.contentData.speedRecord == nil or viewAngle == gMailViewAngle.DEFENCE then
		return 0
	end
	mailFunctions = nil
	;(nil).fontSize = 22
	;(nil).name = "Button_SpeedDetail"
	;(nil).titleText = i18n("common_text_4520")
	;(nil).normalImgName = "btn_alliance_green.png"
	mailFunctions, (nil).handler = handler(self, self.onBtnSpeedDetail), handler(self, self.onBtnSpeedDetail)
	handler(self, self.onBtnSpeedDetail).left = 0
	handler(self, self.onBtnSpeedDetail).top = 10
	handler(self, self.onBtnSpeedDetail).right = 0
	;(nil).margin, handler(self, self.onBtnSpeedDetail).bottom = handler(self, self.onBtnSpeedDetail), 10
	local vLayout, totalHeight = mailNodeFactory:createButtonLayout(nil)
	self:addChild(vLayout)
	return totalHeight
end
function mailItemDetailBattle:createBtnFightReportLayout()
	if self.contentData.fightDetail == nil then
		return 0
	end
	mailNodeFactory = nil
	;(nil).name = "Button_Report"
	;(nil).fontSize = 22
	;(nil).titleText = i18n("mail_text_01")
	;(nil).normalImgName = "btn_BXanniu_yellow.png"
	mailNodeFactory, (nil).handler = handler(self, self.onBtnFightReport), handler(self, self.onBtnFightReport)
	handler(self, self.onBtnFightReport).left = 0
	handler(self, self.onBtnFightReport).top = 10
	handler(self, self.onBtnFightReport).right = 0
	;(nil).margin, handler(self, self.onBtnFightReport).bottom = handler(self, self.onBtnFightReport), 10
	local vLayout, totalHeight = mailNodeFactory:createButtonLayout(nil)
	self:addChild(vLayout)
	return totalHeight
end
function mailItemDetailBattle:onBtnDetail(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mailItemDetailFightDefense")
		panel:initWithData(self.contentData, mailFunctions:getMailDetailDate(self.mail))
		panel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailBattle:onBtnFightDetail(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mailItemDetailAdvancedAttr")
		panel:initWithFightDetail(self.mail)
		panel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailBattle:onBtnSpeedDetail(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mailItemDetailSpeedUp")
		panel:initWithData(self.contentData.speedRecord)
		panel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailBattle:onBtnFightReport(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mailItemDetailFightDefense")
		_ENV = nil
		;(nil).fightDetail = self.contentData.fightDetail
		panel:initWithFightDetail(nil)
		panel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailBattle:onClickAdvancedAttr(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mailItemDetailAdvancedAttr")
		panel:initData(self.mail)
		panel:show()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailBattle:getFightDetailBeginStrList()
	local mailDesParser, strList
	local attackName = mailDesParser.getPlayerFightTitle(self.contentData, self.contentData.playerInfo1, #self.contentData.battleInfo.attackArmyInfo)
	local defendName = mailDesParser.getPlayerFightTitle(self.contentData, self.contentData.playerInfo2, #self.contentData.battleInfo.defenceArmyInfo)
	if self.contentData.playerInfo1.uinfo and self.contentData.playerInfo1.uinfo.id then
		local str = "fight_mail_04"
		local heroNames = ""
		local mailDesParser, heroNameList = #self.contentData.battleInfo.defenceArmyInfo, #self.contentData.battleInfo.defenceArmyInfo
		if not self.contentData.heroList[tostring(self.contentData.playerInfo1.uinfo.id)] then
			mailDesParser = self.contentData.heroList[tostring(self.contentData.playerInfo1.uinfo.id)]
		end
		attackHero = self.contentData.heroList[tostring(self.contentData.playerInfo1.uinfo.id)]
		for _, v in ipairs(attackHero) do
			table.insert(heroNameList, i18n(heroltCtrl.getHeroName(v.heroID)))
			if v.slaveInfo and v.slaveInfo.heroID then
				table.insert(heroNameList, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)))
			end
		end
		if next(heroNameList) then
			heroNames = table.concat(heroNameList, ", ")
		else
			str = "fight_mail_05"
		end
		mailDesParser = nil
		;(nil).var = attackName
		mailDesParser, mailDesParser, (nil).name = heroNameList, table.insert, heroNames
		mailDesParser, table.insert.var, heroNameList.color = heroNameList, heroNameList, "#A02828"
		mailDesParser, table.insert.name, heroNameList.color = heroNameList, heroNameList, "#693815"
		table.insert.__default, heroNameList.color = heroNameList, "#55230F"
		table.insert(strList, i18n_html(str, nil, table.insert))
		if not self.contentData.armsList[tostring(self.contentData.playerInfo1.uinfo.id)] then
			mailDesParser = self.contentData.armsList[tostring(self.contentData.playerInfo1.uinfo.id)]
		end
		attackArms = self.contentData.armsList[tostring(self.contentData.playerInfo1.uinfo.id)]
		if next(attackArms) and attackArms[1] then
			local armsID = attackArms[1].armsID
			local level = attackArms[1].level
			local awakeStatus = attackArms[1].awakeStatus
			local armsName = include("equipDesRead").getArtifactName(attackArms[1].armsID)
			mailDesParser = i18n_html(str, nil, table.insert)
			i18n_html(str, nil, table.insert).var = attackName
			mailDesParser, mailDesParser, i18n_html(str, nil, table.insert).name = i18n_html(str, nil, table.insert)
			mailDesParser, i18n_html(str, nil, table.insert).var, i18n_html(str, nil, table.insert).color = i18n_html(str, nil, table.insert)
			mailDesParser, i18n_html(str, nil, table.insert).name, i18n_html(str, nil, table.insert).color = i18n_html(str, nil, table.insert)
			i18n_html(str, nil, table.insert).__default, i18n_html(str, nil, table.insert).color = i18n_html(str, nil, table.insert)
			table.insert(strList, i18n_html("fight_mail_06", i18n_html(str, nil, table.insert)))
			if awakeStatus then
				for i = 1, 4 do
					local skillID = tonumber(armsID .. i)
					local attrInfo = equipDesRead.getArtifactAttrInfo(skillID, level, awakeStatus)
					if level >= attrInfo.init_skill then
						local desStr = equipDesRead.getArtifactSkillName(skillID, awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE)
						local valueStr = propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1])
						mailDesParser = i18n_html("fight_mail_06", i18n_html(str, nil, table.insert))
						i18n_html("fight_mail_06", i18n_html(str, nil, table.insert)).name = desStr
						i18n_html("fight_mail_06", i18n_html(str, nil, table.insert)).num = valueStr
						table.insert(strList, i18n("common_text_036", i18n_html("fight_mail_06", i18n_html(str, nil, table.insert))))
					end
				end
			end
		end
	end
	if self.contentData.playerInfo2.uinfo and self.contentData.playerInfo2.uinfo.id then
		local str = "fight_mail_04"
		local heroNames = ""
		local mailDesParser, heroNameList = #self.contentData.battleInfo.defenceArmyInfo, #self.contentData.battleInfo.defenceArmyInfo
		if not self.contentData.heroList[tostring(self.contentData.playerInfo2.uinfo.id)] then
			mailDesParser = self.contentData.heroList[tostring(self.contentData.playerInfo2.uinfo.id)]
		end
		attackHero = self.contentData.heroList[tostring(self.contentData.playerInfo2.uinfo.id)]
		for _, v in ipairs(attackHero) do
			table.insert(heroNameList, i18n(heroltCtrl.getHeroName(v.heroID)))
			if v.slaveInfo and v.slaveInfo.heroID then
				table.insert(heroNameList, i18n(heroltCtrl.getHeroName(v.slaveInfo.heroID)))
			end
		end
		if next(heroNameList) then
			heroNames = table.concat(heroNameList, ", ")
		else
			str = "fight_mail_05"
		end
		mailDesParser = 1
		;(1).var = defendName
		mailDesParser, mailDesParser, (1).name = heroNameList, table.insert, heroNames
		mailDesParser, table.insert.var, heroNameList.color = heroNameList, heroNameList, "#13508F"
		mailDesParser, table.insert.name, heroNameList.color = heroNameList, heroNameList, "#693815"
		table.insert.__default, heroNameList.color = heroNameList, "#55230F"
		table.insert(strList, i18n_html(str, 1, table.insert))
		if not self.contentData.armsList[tostring(self.contentData.playerInfo2.uinfo.id)] then
			mailDesParser = self.contentData.armsList[tostring(self.contentData.playerInfo2.uinfo.id)]
		end
		attackArms = self.contentData.armsList[tostring(self.contentData.playerInfo2.uinfo.id)]
		if next(attackArms) and attackArms[1] then
			local armsID = attackArms[1].armsID
			local level = attackArms[1].level
			local awakeStatus = attackArms[1].awakeStatus
			local armsName = include("equipDesRead").getArtifactName(attackArms[1].armsID)
			mailDesParser = i18n_html(str, 1, table.insert)
			i18n_html(str, 1, table.insert).var = defendName
			mailDesParser, mailDesParser, i18n_html(str, 1, table.insert).name = i18n_html(str, 1, table.insert)
			mailDesParser, i18n_html(str, 1, table.insert).var, i18n_html(str, 1, table.insert).color = i18n_html(str, 1, table.insert)
			mailDesParser, i18n_html(str, 1, table.insert).name, i18n_html(str, 1, table.insert).color = i18n_html(str, 1, table.insert)
			i18n_html(str, 1, table.insert).__default, i18n_html(str, 1, table.insert).color = i18n_html(str, 1, table.insert)
			table.insert(strList, i18n_html("fight_mail_06", i18n_html(str, 1, table.insert)))
			if awakeStatus then
				for i = 1, 4 do
					local skillID = tonumber(armsID .. i)
					local attrInfo = equipDesRead.getArtifactAttrInfo(skillID, level, awakeStatus)
					if level >= attrInfo.init_skill then
						local desStr = equipDesRead.getArtifactSkillName(skillID, awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE)
						local valueStr = propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1])
						mailDesParser = i18n_html("fight_mail_06", i18n_html(str, 1, table.insert))
						i18n_html("fight_mail_06", i18n_html(str, 1, table.insert)).name = desStr
						i18n_html("fight_mail_06", i18n_html(str, 1, table.insert)).num = valueStr
						table.insert(strList, i18n("common_text_036", i18n_html("fight_mail_06", i18n_html(str, 1, table.insert))))
					end
				end
			end
		end
	end
	return strList
end
function mailItemDetailBattle:getFightDetailFightingStrList()
	local mailDesParser, strList
	local attackName = mailDesParser.getPlayerFightTitle(self.contentData, self.contentData.playerInfo1, #self.contentData.battleInfo.attackArmyInfo)
	local defendName = mailDesParser.getPlayerFightTitle(self.contentData, self.contentData.playerInfo2, #self.contentData.battleInfo.defenceArmyInfo)
	if self.contentData.battleDetails and self.contentData.battleDetails.battleDetailsV1 then
		dump(self.contentData.battleDetails.battleDetailsV1, "battleDetailsV1")
		for _, v in ipairs(self.contentData.battleDetails.battleDetailsV1) do
			local name1, name2
			if v[1] == 0 then
				name1 = defendName
				name2 = attackName
				color2 = "#A02828"
				color1 = "#13508F"
			else
				name1 = attackName
				name2 = defendName
				color1 = "#A02828"
				color2 = "#13508F"
			end
			mailDesParser = nil
			;(nil).name1 = name1
			;(nil).name2 = name2
			;(nil).damageType = mailFunctions:getAttackName(v[2])
			;(nil).damage = string.formatnumberthousands(math.floor(v[3]))
			mailDesParser, mailDesParser, (nil).num = v[4], string.formatnumberthousands(v[4]), string.formatnumberthousands(v[4])
			mailDesParser, string.formatnumberthousands(v[4]).name1, v[4].color = v[4], v[4], color1
			mailDesParser, string.formatnumberthousands(v[4]).name2, v[4].color = v[4], v[4], color2
			mailDesParser, string.formatnumberthousands(v[4]).damageType, v[4].b = v[4], v[4], gDmgType.normal ~= v[2]
			mailDesParser, string.formatnumberthousands(v[4]).damage, v[4].color = v[4], v[4], "#A02828"
			mailDesParser, string.formatnumberthousands(v[4]).num, v[4].color = v[4], v[4], "#B45900"
			string.formatnumberthousands(v[4]).__default, v[4].color = v[4], "#55230F"
			table.insert(strList, i18n_html("fight_mail_10", nil, (string.formatnumberthousands(v[4]))))
		end
	end
	return strList
end
function mailItemDetailBattle:getFightDetailEndStrList()
	local isDefend = self:getIsDefense()
	local _ENV, strList = self, self
	local attackName = isDefend and i18n("battlelog_text_40") or i18n("battlelog_text_41")
	local defendName = isDefend and i18n("battlelog_text_41") or i18n("battlelog_text_40")
	local attackColor = isDefend and "#D24B01" or "#006E00"
	local defendColor = isDefend and "#006E00" or "#D24B01"
	local attackLostNum = self.contentData.playerInfo1.fightSummary.lostNum
	local attackwoundedNum = self.contentData.playerInfo1.fightSummary.woundedNum
	local defendLostNum = self.contentData.playerInfo2.fightSummary.lostNum
	local defendwoundedNum = self.contentData.playerInfo2.fightSummary.woundedNum
	_ENV = nil
	;(nil).name1 = attackName
	;(nil).num1 = string.formatnumberthousands(attackLostNum)
	_ENV, _ENV, (nil).num2 = attackwoundedNum, string.formatnumberthousands(attackwoundedNum), string.formatnumberthousands(attackwoundedNum)
	_ENV, string.formatnumberthousands(attackwoundedNum).name1, attackwoundedNum.color = attackwoundedNum, attackwoundedNum, attackColor
	_ENV, string.formatnumberthousands(attackwoundedNum).num1, attackwoundedNum.color = attackwoundedNum, attackwoundedNum, "#B45900"
	_ENV, string.formatnumberthousands(attackwoundedNum).num2, attackwoundedNum.color = attackwoundedNum, attackwoundedNum, attackColor
	string.formatnumberthousands(attackwoundedNum).__default, attackwoundedNum.color = attackwoundedNum, "#55230F"
	table.insert(strList, i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))))
	_ENV = i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))
	i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))).name1 = defendName
	i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))).num1 = string.formatnumberthousands(defendLostNum)
	_ENV, _ENV, i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))).num2 = defendwoundedNum, string.formatnumberthousands(defendwoundedNum), string.formatnumberthousands(defendwoundedNum)
	_ENV, string.formatnumberthousands(defendwoundedNum).name1, defendwoundedNum.color = defendwoundedNum, defendwoundedNum, defendColor
	_ENV, string.formatnumberthousands(defendwoundedNum).num1, defendwoundedNum.color = defendwoundedNum, defendwoundedNum, "#B45900"
	_ENV, string.formatnumberthousands(defendwoundedNum).num2, defendwoundedNum.color = defendwoundedNum, defendwoundedNum, defendColor
	string.formatnumberthousands(defendwoundedNum).__default, defendwoundedNum.color = defendwoundedNum, "#55230F"
	table.insert(strList, i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))))
	local loserName, winnerName, color1, color2
	if self.contentData.result == 1 then
		loserName = isDefend and defendName or attackName
		winnerName = isDefend and attackName or defendName
		color1 = isDefend and defendColor or attackColor
		color2 = isDefend and attackColor or defendColor
	else
		loserName = isDefend and attackName or defendName
		winnerName = isDefend and defendName or attackName
		color1 = isDefend and attackColor or defendColor
		color2 = isDefend and defendColor or attackColor
	end
	_ENV = i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))))
	i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).name1 = loserName
	_ENV, _ENV, i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).name2 = i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))))
	_ENV, i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).name1, i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).color = i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))))
	_ENV, i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).name2, i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).color = i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))))
	i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).__default, i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum)))).color = i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))))
	table.insert(strList, i18n_html("fight_mail_16", i18n_html("fight_mail_15", i18n_html("fight_mail_15", nil, (string.formatnumberthousands(attackwoundedNum))))))
	return strList
end
function mailItemDetailBattle:getAllAllianceArmyList()
	local _ENV, ret
	dump(self.contentData.reinforcements.playersInfo, "self.contentData.cityDefenceArmy.armyInfo")
	if not self.contentData.cityDefenceArmy or not self.contentData.cityDefenceArmy.armyInfo then
		_ENV = self.contentData.cityDefenceArmy.armyInfo
	end
	for i, v in ipairs(self.contentData.cityDefenceArmy.armyInfo) do
		ret[v.armyId] = clone(v)
	end
	if not self.contentData.reinforcements.playersInfo then
		_ENV = self.contentData.reinforcements.playersInfo
	end
	for _, item in ipairs(self.contentData.reinforcements.playersInfo) do
		for _, v in ipairs(item.armyInfo) do
			if ret[v.armyId] then
				ret[v.armyId].num = v.num + ret[v.armyId].num
			else
				ret[v.armyId] = clone(v)
			end
		end
	end
	local _ENV, newTb = (for generator), ipairs(self.contentData.reinforcements.playersInfo)
	local _ENV, keys = ipairs(self.contentData.reinforcements.playersInfo)
	for k, v in pairs(ret) do
		table.insert(keys, k)
	end
	for i = 1, #keys do
		newTb[i] = ret[keys[i]]
	end
	local armyLogic = include("armyLogic")
	table.sort(newTb, function(l, r)
		local lSoldierType = armyLogic.getArmyTypeByID(tonumber(l.armyId) % 1000)
		local rSoldierType = armyLogic.getArmyTypeByID(tonumber(r.armyId) % 1000)
		if lSoldierType == rSoldierType then
			return l.armyId > r.armyId
		else
			return lSoldierType < rSoldierType
		end
	end)
	return newTb
end
function mailItemDetailBattle:sortAttrList(tb)
	local _ENV, newTb
	local _ENV, keys
	for k, v in pairs(tb) do
		table.insert(keys, k)
	end
	for i = 1, #keys do
		newTb[i] = tb[keys[i]]
	end
	table.sort(newTb, function(l, r)
		return l.sortIndex < r.sortIndex
	end)
	return newTb
end
function mailItemDetailBattle:getFightDetailList(armyInfo)
	local armyLogic = include("armyLogic")
	local _ENV, ret = "armyLogic", "armyLogic"
	local _ENV, soldierList
	for i, playerInfo in ipairs(armyInfo) do
		for _, v in ipairs(playerInfo.detailInfo) do
			if v.battleItemType == gBattleItemType.SOLDIER then
				local key = ""
				local soldierType = armyLogic.getArmyTypeByID(tonumber(v.battleItemId) % 1000)
				local armyLv = armyLogic.getArmyLV(tonumber(v.battleItemId))
				key = string.format("%d_%d", soldierType, armyLv)
				if soldierList[key] then
					soldierList[key].kill = soldierList[key].kill + v.kill
					soldierList[key].lost = soldierList[key].lost + v.lost
					soldierList[key].survive = soldierList[key].survive + v.survive
					soldierList[key].wounded = soldierList[key].wounded + v.wounded
				else
					soldierList[key] = clone(v)
				end
			else
				table.insert(ret, v)
			end
		end
	end
	for i, v in pairs(soldierList) do
		table.insert(ret, 1, v)
	end
	table.sort(ret, function(l, r)
		if l.battleItemType == r.battleItemType then
			local lSoldierType = armyLogic.getArmyTypeByID(tonumber(l.battleItemId) % 1000)
			local rSoldierType = armyLogic.getArmyTypeByID(tonumber(r.battleItemId) % 1000)
			if lSoldierType == rSoldierType then
				return l.battleItemId > r.battleItemId
			else
				return lSoldierType < rSoldierType
			end
		else
			return l.battleItemType < r.battleItemType
		end
	end)
	return ret
end
function mailItemDetailBattle:getScoutFailureStr()
	local uinfo = self.contentData.uinfo
	if uinfo == nil then
		uinfo, _ENV = nil, nil
	end
	local allianceInfo = self.contentData.allianceInfo
	if allianceInfo == nil then
		allianceInfo, _ENV = nil, nil
	end
	local strInfo = ""
	local strItemName = i18n("common_text_110")
	if self.mailSource == gMailSource.SCOUT_CITY_FAILED or self.mailSource == gMailSource.SCOUT_TROOP_FAILED then
		local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName = strName .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.name = strName
		uinfo.kid.toolName = strItemName
		strInfo = i18n("common_text_111", uinfo.kid)
	elseif self.mailSource == gMailSource.BE_SCOUTED_CITY_FAILED or self.mailSource == gMailSource.BE_SCOUTED_TROOP_FAILED then
		local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName = strName .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.name = strName
		uinfo.kid.toolName = strItemName
		strInfo = i18n("common_text_112", uinfo.kid)
	end
	return strInfo
end
function mailItemDetailBattle:getRobRes()
	local playerId = self:getReceiverPlayerId()
	local battleInfo = self.contentData.battleInfo
	local robRes
	if not self:getIsDefense() then
		local attackArmyInfo = battleInfo.attackArmyInfo
		for i, v in ipairs(attackArmyInfo) do
			if v.uinfo.id == playerId then
				robRes = clone(v.resInfo)
				if robRes == nil then
					robRes, _ENV = clone(v.resInfo), clone(v.resInfo)
				end
				break
			end
		end
	else
		robRes = clone(self.contentData.resInfo)
		if robRes == nil then
			robRes, _ENV = clone(self.contentData.resInfo), clone(self.contentData.resInfo)
		end
	end
	if self.contentData.otherRes and tolua.type(self.contentData.otherRes) == "table" and self.contentData.otherRes[tostring(playerId)] ~= nil then
		local otherRes = clone(self.contentData.otherRes[tostring(playerId)])
		for i, v in ipairs(otherRes) do
			table.insert(robRes, #robRes + 1, v)
		end
	end
	return robRes
end
function mailItemDetailBattle:getIsDefense()
	local isAttack = false
	if self.mailSource == gMailSource.ESCORT_ROB_SUCCESS or self.mailSource == gMailSource.ESCORT_ROB_FAILED then
		isAttack = true
	elseif self.mailSource == gMailSource.ESCORT_DEF_FAILED or self.mailSource == gMailSource.ESCORT_DEF_SUCCESS then
		isAttack = false
	else
		isAttack = mailFunctions:getIsPlayerAttack(self.mail:getProperty("receiver"), self.contentData.battleInfo)
	end
	return not isAttack
end
function mailItemDetailBattle:getReceiverPlayerId()
	return self.senderId or lordInfoCtrl:getLordInfo().base.uid
end
function mailItemDetailBattle:getCityDefenceStr()
	if self.contentData.cityDefence then
		return string.formatnumberthousands(self.contentData.cityDefence.currentValue) .. "/" .. string.formatnumberthousands(self.contentData.cityDefence.maxValue)
	else
		return ""
	end
end
function mailItemDetailBattle:getBeScoutStr()
	dump(self.contentData, "self.contentData")
	local uinfo = self.contentData.uinfo
	local allianceInfo = self.contentData.allianceInfo
	if allianceInfo == nil then
		allianceInfo, _ENV = "self.contentData", "self.contentData"
	end
	local strInfo = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo and uinfo.nickName)
	if uinfo and uinfo.kid and lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
		strInfo = strInfo .. "#" .. uinfo.kid
	end
	if self.mailSource == gMailSource.BE_SCOUTED_CITY_SUCCESS then
		_ENV = uinfo.kid
		uinfo.kid.name = strInfo
		strInfo = i18n("common_text_113", uinfo.kid)
	elseif self.mailSource == gMailSource.BE_SCOUTED_TROOP_SUCCESS then
		_ENV = uinfo.kid
		uinfo.kid.name = strInfo
		strInfo = i18n("common_text_114", uinfo.kid)
	elseif self.mailSource == gMailSource.BE_SCOUTED_PALACE_SUCCESS then
		_ENV = uinfo.kid
		uinfo.kid.name = strInfo
		strInfo = i18n("mail_text_105", uinfo.kid)
	elseif self.mailSource == gMailSource.BE_SCOUTED_CATAPULT_SUCCESS then
		if self.contentData.targetMapObj.mapType == gMapObjTypeDef.mapObjTypeBattery then
			local buildName = mailFunctions:getMapBuildName(self.contentData.targetMapObj)
			_ENV = nil
			;(nil).name = strInfo
			;(nil).build = buildName
			strInfo = i18n("mail_text_304", nil)
		else
			_ENV = "mail_text_304"
			;("mail_text_304").name = strInfo
			strInfo = i18n("mail_text_106", "mail_text_304")
		end
	elseif self.mailSource == gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS or self.mailSource == gMailSource.BE_SCOUTED_PYRAMIDBUILD_SUCCESS or self.mailSource == gMailSource.BE_SCOUTED_RADIANCE_BUILD_SUCCESS or self.mailSource == gMailSource.BE_SCOUTED_LEGENDLORD_SUCCESS then
		local buildName = mailFunctions:getMapBuildName(self.contentData.targetMapObj)
		_ENV = nil
		;(nil).name = strInfo
		;(nil).build = buildName
		strInfo = i18n("mail_text_304", nil)
	end
	return strInfo
end
function mailItemDetailBattle:msgOnSizeChanged(target, data)
	local parent = data.node
	local needUpdate = false
	while parent and parent:getName() ~= "GRootDisplayObject" do
		print("mailItemDetailBattle", self, parent)
		if parent == self then
			needUpdate = true
			break
		end
		parent = parent:getParent()
	end
	print("mailItemDetailBattle", needUpdate)
	if not needUpdate then
		return
	end
	local deltaY = data.deltaY
	local oldHeight = self:getContentSize().height
	local newHeight = oldHeight + deltaY
	self.itemHeight = newHeight
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self:requestDoLayout()
	_ENV = self
	self.msg = "MESSAGE_MAIL_UI_DETAIL_SCROLL_CONTENT_SIZE_CHANGED"
	self.deltaY = deltaY
	self.node = self:getParent()
	SoraDSendMessage(self)
end
function mailItemDetailBattle:getItemWidth()
	return self.itemWidth
end
function mailItemDetailBattle:getItemHeight()
	return self.itemHeight
end
return mailItemDetailBattle
