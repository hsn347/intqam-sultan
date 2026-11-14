local mailFunctions = include("mailFunctions")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local cityltCtrl = include("cityltCtrl")
local lordLocalData = include("lordLocalData")
local allianceDesRead = include("allianceDesRead")
local mailDesParser = include("mailDesParser")
local mailItemDetailFightHead = class("mailItemDetailFightHead", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailFightHead")
end)
function mailItemDetailFightHead:ctor(properties)
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "Panel")
	self.itemSize = cc.size(gMailDetaiViewWidth, 180.0)
	self.imgResult = SoraDGetChildByName(self, "Image_Result")
	self.imgResult:ignoreContentAdaptWithSize(true)
	self.nodeAttack = SoraDGetChildByName(self, "Node_Attack")
	self.attackName = SoraDGetChildByName(self.nodeAttack, "Text_Name")
	self.attackCoord = SoraDGetChildByName(self.nodeAttack, "Text_Coordina")
	self.attackCoord:setTouchEnabled(true)
	self.attackCoord = SoraDChangeTextToHtmlFgui(self.attackCoord)
	SoraDGetChildByName(self.nodeAttack, "icon_Side"):setLocalZOrder(99)
	self.attackNodeWar = SoraDGetChildByName(self.nodeAttack, "Node_War")
	self.attackNodeStar = SoraDGetChildByName(self.nodeAttack, "Node_Star")
	self.attackNodeLv = SoraDGetChildByName(self.nodeAttack, "Node_Lv")
	self.aTextArmyCount = SoraDGetChildByName(self.attackNodeLv, "Text_ArmyCount")
	self.aTextArmyCount:setVisible(false)
	self.attackNodeWar:setVisible(false)
	self.attackNodeStar:setVisible(false)
	self.attackNodeLv:setVisible(false)
	self.nodeDefence = SoraDGetChildByName(self, "node_Defence")
	self.defenceName = SoraDGetChildByName(self.nodeDefence, "Text_Name")
	self.defenceCoord = SoraDGetChildByName(self.nodeDefence, "Text_Coordina")
	self.defenceNodeLv = SoraDGetChildByName(self.nodeDefence, "Node_Lv")
	self.defenceCoord:setTouchEnabled(true)
	self.defenceCoord = SoraDChangeTextToHtmlFgui(self.defenceCoord)
	SoraDGetChildByName(self.nodeDefence, "icon_Side"):setLocalZOrder(99)
	self.defenceNodeWar = SoraDGetChildByName(self.nodeDefence, "Node_War")
	self.defenceNodeStar = SoraDGetChildByName(self.nodeDefence, "Node_Star")
	self.dTextArmyCount = SoraDGetChildByName(self.defenceNodeLv, "Text_ArmyCount")
	self.dTextArmyCount:setVisible(false)
	self.defenceNodeWar:setVisible(false)
	self.defenceNodeStar:setVisible(false)
	self.defenceNodeLv:setVisible(false)
	local parentScroll = gModuleMgr.sharedMgr("mailMgr"):getScrollParent()
	self.playerAvatarBoxAttack = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBoxAttack:setContentSize(cc.size(self.playerAvatarBoxAttack:getItemWidth(), self.playerAvatarBoxAttack:getItemHeight()))
	self.playerAvatarBoxAttack:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.playerAvatarBoxAttack:setPosition(0, -15)
	self.playerAvatarBoxAttack:addTo(self.nodeAttack)
	self.playerAvatarBoxAttack:setScroll(parentScroll)
	self.playerAvatarBoxAttack:setCascadeOpacityEnabled(true)
	self.playerAvatarBoxAttack:setScale(0.875)
	self.playerAvatarBoxDefence = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBoxDefence:setContentSize(cc.size(self.playerAvatarBoxDefence:getItemWidth(), self.playerAvatarBoxDefence:getItemHeight()))
	self.playerAvatarBoxDefence:setAnchorPoint(SoraDFAP(0.5, 0.5))
	self.playerAvatarBoxDefence:setPosition(0, -15)
	self.playerAvatarBoxDefence:addTo(self.nodeDefence)
	self.playerAvatarBoxDefence:setScroll(parentScroll)
	self.playerAvatarBoxDefence:setCascadeOpacityEnabled(true)
	self.playerAvatarBoxDefence:setScale(0.875)
end
function mailItemDetailFightHead:initData(mail, needKid)
	self.scroll = SoraDGetChildByName(gModuleMgr.sharedMgr("mailMgr"):getDetaiView(), "Size_scrollView")
	self.mail = mail
	self.mailType = self.mail:getProperty("mailType")
	self.contentData = self.mail:getProperty("data")
	dump(self.contentData, "mailItemDetailFightHead")
	local battleInfo = self.contentData.battleInfo or nil
	local isTrialMail, isAttackWin = self:checkMailTypeIsTrial()
	if not self.contentData.playerInfo1 then
		local _ENV, playerInfo1 = self.contentData.playerInfo1, self.contentData.playerInfo1
	end
	playerInfo1.isTrialMail = isTrialMail
	if playerInfo1.uinfo and playerInfo1.uinfo.coordinate then
		if not playerInfo1.uinfo.coordinate.kid then
			playerInfo1.uinfo.coordinate.kid = self.mail:getKingdomID()
		end
		if not playerInfo1.uinfo.coordinate then
			_ENV = playerInfo1.uinfo.coordinate
			playerInfo1.uinfo.coordinate.x = 0
			local playerInfo1.uinfo.coordinate.y, coordinate = 0, playerInfo1.uinfo.coordinate
		end
		local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
		_ENV = nil
		_ENV, _ENV, (nil).commonStr = nil, nil, strCoordinate
		;(nil).commonStr, (nil).u = nil, true
		self.attackCoord:setString(i18n_html("common_text_034", nil, nil))
		self.attackCoord:addTouchEventListener(handlerEx(self, self.onCoordinate, coordinate))
	end
	self.attackName:setString(mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid))
	self:initFightPlayerInfo(self.playerAvatarBoxAttack, playerInfo1)
	if not self.contentData.playerInfo2 then
		local _ENV, playerInfo2 = self.contentData.playerInfo2, self.contentData.playerInfo2
	end
	playerInfo2.isTrialMail = isTrialMail
	if playerInfo2.uinfo and playerInfo2.uinfo.coordinate then
		if not playerInfo2.uinfo.coordinate.kid then
			playerInfo2.uinfo.coordinate.kid = self.mail:getKingdomID()
		end
		if not playerInfo2.uinfo.coordinate then
			_ENV = playerInfo2.uinfo.coordinate
			playerInfo2.uinfo.coordinate.x = 0
			local playerInfo2.uinfo.coordinate.y, coordinate = 0, playerInfo2.uinfo.coordinate
		end
		local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
		_ENV = mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid)
		_ENV, _ENV, mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid).commonStr = mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid)
		mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid).commonStr, mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid).u = mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid)
		self.defenceCoord:setString(i18n_html("common_text_034", mailDesParser.getPlayerFightTitle(self.contentData, playerInfo1, battleInfo and #battleInfo.attackArmyInfo or 0, needKid)))
		self.defenceCoord:addTouchEventListener(handlerEx(self, self.onCoordinate, coordinate))
	elseif playerInfo2.bInfo then
		if not playerInfo2.bInfo.coordinate then
			_ENV = playerInfo2.bInfo.coordinate
			playerInfo2.bInfo.coordinate.x = 0
			local playerInfo2.bInfo.coordinate.y, coordinate = 0, playerInfo2.bInfo.coordinate
		end
		local strCoordinate = mailFunctions:getStrCoordinate(coordinate.x, coordinate.y)
		_ENV = handlerEx(self, self.onCoordinate, coordinate)
		_ENV, _ENV, handlerEx(self, self.onCoordinate, coordinate).commonStr = handlerEx(self, self.onCoordinate, coordinate)
		handlerEx(self, self.onCoordinate, coordinate).commonStr, handlerEx(self, self.onCoordinate, coordinate).u = handlerEx(self, self.onCoordinate, coordinate)
		self.defenceCoord:setString(i18n_html("common_text_034", handlerEx(self, self.onCoordinate, coordinate)))
		self.defenceCoord:addTouchEventListener(handlerEx(self, self.onCoordinate, coordinate))
	end
	self.defenceName:setString(mailDesParser.getPlayerFightTitle(self.contentData, playerInfo2, battleInfo and #battleInfo.defenceArmyInfo or 0, needKid))
	self:initFightPlayerInfo(self.playerAvatarBoxDefence, playerInfo2)
	local isLose = self.contentData.result == 1
	local pngName = ""
	if isLose then
		pngName = string.format("title_yjyh_lose%s.png", SoraDFIsRA() and "" or "_en")
	else
		pngName = string.format("title_yjyh_win%s.png", SoraDFIsRA() and "" or "_en")
	end
	self.imgResult:loadTexture(pngName, ccui.TextureResType.plistType)
	self:initCastleLv()
end
function mailItemDetailFightHead:initCastleLv(...)
	if self.contentData.playerInfo2 and self.contentData.playerInfo2.uinfo then
		if self.contentData.playerInfo2.uinfo.cityLevel and self.contentData.playerInfo2.uinfo.cityLevel >= CASTLE_LV40_LIMITED then
			self.defenceNodeWar:setVisible(true)
			self.defenceNodeLv:setVisible(true)
			local castleLv = self.contentData.playerInfo2.uinfo.cityLevel
			local warLv = math.floor((castleLv - CASTLE_MAXLV_NOWAR) / 10)
			SoraDGetChildByName(self.defenceNodeWar, "Text_WarLv"):setString(warLv)
		end
		if self.contentData.playerInfo2.uinfo.starLv and self.contentData.playerInfo2.uinfo.starLv > 0 then
			self.defenceNodeStar:setVisible(true)
			self.defenceNodeLv:setVisible(true)
			local starImage = cityltCtrl.getBuildStarImage(self.contentData.playerInfo2.uinfo.starLv)
			SoraDGetChildByName(self.defenceNodeStar, "Image_Star"):loadTexture(starImage, ccui.TextureResType.plistType)
			SoraDGetChildByName(self.defenceNodeStar, "Text_StarLv"):setString(self.contentData.playerInfo2.uinfo.starLv)
		end
	end
	if self.contentData.playerInfo1 and self.contentData.playerInfo1.uinfo then
		if self.contentData.playerInfo1.uinfo.cityLevel and self.contentData.playerInfo1.uinfo.cityLevel >= CASTLE_LV40_LIMITED then
			self.attackNodeWar:setVisible(true)
			self.attackNodeLv:setVisible(true)
			local castleLv = self.contentData.playerInfo1.uinfo.cityLevel
			local warLv = math.floor((castleLv - CASTLE_MAXLV_NOWAR) / 10)
			SoraDGetChildByName(self.attackNodeWar, "Text_WarLv"):setString(warLv)
		end
		if self.contentData.playerInfo1.uinfo.starLv and 0 < self.contentData.playerInfo1.uinfo.starLv then
			self.attackNodeStar:setVisible(true)
			self.attackNodeLv:setVisible(true)
			local starImage = cityltCtrl.getBuildStarImage(self.contentData.playerInfo1.uinfo.starLv)
			SoraDGetChildByName(self.attackNodeStar, "Image_Star"):loadTexture(starImage, ccui.TextureResType.plistType)
			SoraDGetChildByName(self.attackNodeStar, "Text_StarLv"):setString(self.contentData.playerInfo1.uinfo.starLv)
		end
	end
end
function mailItemDetailFightHead:initFightPlayerInfo(node, playerInfo)
	local _ENV, baseInfoData
	local battleType
	node:setBtnTouchEnabled(false)
	dump(playerInfo, "mailItemDetailFightHead:initFightPlayerInfo")
	if playerInfo.isNpc then
		local _ENV, buildIcon = playerInfo, playerInfo.buildIcon or "qlzjt_full.png"
		playerInfo.playerId = playerInfo.uinfo.id
		playerInfo.imgPlayer = buildIcon
		playerInfo.avatar = playerInfo.uinfo.avatar
		baseInfoData, playerInfo.isRobot = playerInfo, playerInfo.uinfo.robotFlag
	elseif playerInfo.uinfo and next(playerInfo.uinfo) ~= nil then
		_ENV = next(playerInfo.uinfo)
		next(playerInfo.uinfo).playerId = playerInfo.uinfo.id
		next(playerInfo.uinfo).imageId = playerInfo.uinfo.iconID
		next(playerInfo.uinfo).imgPlayer = lordLocalData.getHead(playerInfo.uinfo.iconID)
		next(playerInfo.uinfo).avatar = playerInfo.uinfo.avatar
		baseInfoData, next(playerInfo.uinfo).isRobot = next(playerInfo.uinfo), playerInfo.uinfo.robotFlag
		battleType = playerInfo.uinfo.battleType
		node:setBtnTouchEnabled(true)
	elseif playerInfo.bInfo and next(playerInfo.bInfo) ~= nil then
		local buildId = playerInfo.bInfo.id
		local buildName = allianceDesRead.getBuildName(buildId)
		local buildIcon = allianceDesRead.getBuildIcon(buildId)
		local flag
		if buildId == gAllianceBuilding.FLAG then
			flag = playerInfo.allianceInfo.flag
		end
		_ENV = playerInfo.allianceInfo
		playerInfo.allianceInfo.playerId = 0
		playerInfo.allianceInfo.name = mailFunctions:getWrappedName(playerInfo.allianceInfo.abbr, buildName)
		playerInfo.allianceInfo.imgPlayer = buildIcon
		baseInfoData, playerInfo.allianceInfo.flag = playerInfo.allianceInfo, flag
	end
	node:initWithData(baseInfoData)
	if battleType == gArenaBattleType.RAIDER_LOST_ARK or battleType == gArenaBattleType.STAR_ENERGY_CUBE then
		node:setBtnTouchEnabled(false)
	end
end
function mailItemDetailFightHead:checkMailTypeIsTrial()
	local isMailType = false
	local isAttackWin = false
	if self.mailType == gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS or self.mailType == gMailSource.DEFENSE_DEVILVALLEYBUILD_FAILED or self.mailType == gMailSource.ATTACK_DEVILVALLEYBUILD_FAILED or self.mailType == gMailSource.DEFENSE_DEVILVALLEYBUILD_SUCCESS then
		isMailType = true
		isAttackWin = true
	end
	return isMailType, isAttackWin
end
function mailItemDetailFightHead:onCoordinate(coordinate, target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local targetPoint = cc.p(coordinate.x, coordinate.y)
		targetPoint.kid = coordinate.kid
		_ENV = coordinate.y
		coordinate.y.msg = "MESSAGE_MAIL_CLOSE_VIEW"
		SoraDSendMessage(coordinate.y)
		SoraDGotoWorldMapPoint(targetPoint, true, targetPoint.kid)
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
function mailItemDetailFightHead:setArmyNum()
	self.attackNodeWar:setVisible(false)
	self.attackNodeStar:setVisible(false)
	self.defenceNodeWar:setVisible(false)
	self.defenceNodeStar:setVisible(false)
	self.defenceNodeLv:setVisible(true)
	self.attackNodeLv:setVisible(true)
	self.aTextArmyCount:setVisible(true)
	self.dTextArmyCount:setVisible(true)
	local attackTotalNum, defenceTotalNum = mailFunctions:getTotalNumStr(self.contentData.playerInfo1.fightSummary, self.contentData.playerInfo2.fightSummary)
	self.aTextArmyCount:setString(i18n("fight_mail_03") .. attackTotalNum)
	self.dTextArmyCount:setString(i18n("fight_mail_03") .. defenceTotalNum)
end
function mailItemDetailFightHead:getItemHeight()
	return self.itemSize.height
end
function mailItemDetailFightHead:getItemWidth()
	return self.itemSize.width
end
return mailItemDetailFightHead
