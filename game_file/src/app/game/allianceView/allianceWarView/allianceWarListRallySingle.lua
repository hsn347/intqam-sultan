local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local palaceInfoRead = include("palaceInfoRead")
local allianceDesRead = include("allianceDesRead")
local queueTimeUtil = include("queueTimeUtil")
local kingdomMapUtil = include("kingdomMapUtil")
local socket = require("socket")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl", gametop)
local AllianceWarListRallySingle = class("allianceWarListRallySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceWarListRallySingle")
	end
	return target
end)
local POS_Y_TOP = 180
local POS_Y_BOTTOM = 60
function AllianceWarListRallySingle:ctor()
	self.indexID = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.isFilter = false
	self.timer = nil
	self.tableHead, _ENV, self.tableMainData = nil, nil, nil
	self.attackType = gAWarViewMemberType.DEFENDER
	self.viewType = gAWarViewMemberType.NONE
	self.showPlus = true
	self.showClose = false
	self.hasCapture = false
	self.targetData = nil
	self.imgWarnning = nil
	self.imgBg2 = SoraDGetChildByName(self, "Image_bg2")
	self.imgBg2:setFillType(1)
	self.imgTitleBg = SoraDGetChildByName(self, "Image_title_bg")
	self.imgHeadBg = SoraDGetChildByName(self, "Image_headBg")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Panel_cut:setSwallowTouches(false)
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.labelTroops = SoraDGetChildByName(self, "Text_troops")
	self.nodeTarget = SoraDGetExtendChildFromCCSByName(self, "CCS_allianceWarCitySingle_target")
	self.spriteOwnState = SoraDGetChildByName(self, "Sprite_ownState")
	self.labelOwnName = SoraDGetChildByName(self, "Text_ownName")
	self.imgOwnMember = SoraDGetChildByName(self, "Image_ownMember")
	self.labelOwnMember = SoraDGetChildByName(self, "Text_ownMember")
	self.spriteOtherState = SoraDGetChildByName(self, "Sprite_otherState")
	self.labelOtherName = SoraDGetChildByName(self, "Text_otherName")
	self.imgOtherMember = SoraDGetChildByName(self, "Image_otherMember")
	self.labelOtherMember = SoraDGetChildByName(self, "Text_otherMember")
	self.btn_close = SoraDGetChildByName(self, "Button_close")
	self.btn_close:setVisible(false)
	self.btn_close:setTouchEnabled(true)
	self.btn_close:addTouchEventListener(handler(self, self.onPlusClick))
	self.maxCount = 0
	self.hasMyArmy = false
	local imgOwnFrame = SoraDGetChildByName(self, "Image_ownFrame")
	local imgOwnHead = SoraDGetChildByName(self, "Image_ownHead")
	local imgOtherFrame = SoraDGetChildByName(self, "Image_otherFrame")
	local imgOtherHead = SoraDGetChildByName(self, "Image_otherHead")
	local imgOwnBg = SoraDGetChildByName(self, "Image_ownBg")
	local imgOtherBg = SoraDGetChildByName(self, "Image_otherBg")
	imgOwnBg:setLocalZOrder(-1)
	imgOtherBg:setLocalZOrder(-1)
	self:addHeadData(imgOwnFrame, imgOwnHead, imgOwnBg)
	self:addHeadData(imgOtherFrame, imgOtherHead, imgOtherBg)
	self.pos_x = imgOwnHead:getPositionX()
	if self.layerTouch then
		self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.spriteMass, _ENV, self.nodeMass = SoraDGetChildByName(self, "Node_mass"), SoraDGetChildByName(self, "Node_mass"), SoraDGetChildByName(self, "Node_mass")
	for i = 4, 1, -1 do
		local sprite = self.nodeMass:getChildByName("Sprite_mass_" .. i)
		self.spriteMass[i] = sprite
	end
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_DELETE_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_ADD_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE_NEW", handler(self, self.updateView))
end
function AllianceWarListRallySingle:initMassView()
	local width = SoraDFIsRA() and 35 or -35
	local posX = 0
	local massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
	for i = 4, 1, -1 do
		local node = self.spriteMass[i]
		if node then
			if massSlaveForbidArmyClass and massSlaveForbidArmyClass[tostring(i)] then
				node:setVisible(false)
			else
				node:setPositionX(posX)
				posX = posX + width
			end
		end
	end
end
function AllianceWarListRallySingle:hideAllHead()
	for _, v in pairs(self.tableHead) do
		v.alloc = false
		v.frame:setVisible(false)
		v.head:setVisible(false)
		v.head:setTouchEnabled(false)
		v.bg:setVisible(false)
	end
end
function AllianceWarListRallySingle:addHeadData(frame, head, bg)
	_ENV = nil
	;(nil).alloc = false
	;(nil).frame = frame
	;(nil).head = head
	local (nil).bg, tableNew = bg, nil
	table.insert(self.tableHead, tableNew)
end
function AllianceWarListRallySingle:getOrCreateUnusedHead()
	local tableFirst = self.tableHead[1]
	if tableFirst.alloc then
		local _ENV, tableNew = tableFirst.alloc, tableFirst.alloc
		tableNew.alloc = true
		tableNew.frame = tableFirst.frame:clone()
		tableNew.head = tableFirst.head:clone()
		tableNew.bg = tableFirst.bg:clone()
		tableNew.bg:addTo(self.layerTouch)
		tableNew.head:addTo(self.layerTouch)
		tableNew.frame:addTo(self.layerTouch)
		table.insert(self.tableHead, tableNew)
		return tableNew
	end
	table.remove(self.tableHead, 1)
	tableFirst.alloc = true
	table.insert(self.tableHead, tableFirst)
	return tableFirst
end
function AllianceWarListRallySingle:setHeadImg(index, owner, headid, avatar)
	local tableNode = self:getOrCreateUnusedHead()
	local posY = owner and POS_Y_TOP or POS_Y_BOTTOM
	local posX = self.pos_x - SoraDFPosX(80 * (index - 1), 0)
	local pos = cc.p(posX, posY)
	tableNode.frame:setVisible(true)
	tableNode.frame:setPosition(pos)
	tableNode.head:setVisible(true)
	tableNode.head:setPosition(pos)
	tableNode.head:setTouchEnabled(false)
	tableNode.bg:setVisible(true)
	tableNode.bg:setPosition(pos)
	SoraDGetHeadFromManager(tableNode.head, headid, avatar)
end
function AllianceWarListRallySingle:setHeadImgByImgPath(index, owner, headImg, touch)
	local tableNode = self:getOrCreateUnusedHead()
	local posY = owner and POS_Y_TOP or POS_Y_BOTTOM
	local posX = self.pos_x - SoraDFPosX(80 * (index - 1), 0)
	local pos = cc.p(posX, posY)
	tableNode.frame:setVisible(true)
	tableNode.frame:setPosition(pos)
	tableNode.head:setVisible(true)
	tableNode.head:setPosition(pos)
	tableNode.head:loadTexture(headImg, ccui.TextureResType.plistType)
	if touch then
		tableNode.head:setTouchEnabled(true)
		tableNode.head:addTouchEventListener(handler(self, self.onPlusClick))
	end
end
function AllianceWarListRallySingle:setAddImg(index, owner)
	self:setHeadImgByImgPath(index, owner, "frame_LegendaryKing_green_add.png", true)
end
function AllianceWarListRallySingle:showBlackWarnning(show)
	if show then
		if self.imgWarnning == nil then
			self.imgWarnning = ccui.ImageView:create("frame_sheer_red_01.png", ccui.TextureResType.plistType)
			self.imgWarnning:ignoreContentAdaptWithSize(false)
			self.imgWarnning:setAnchorPoint(cc.p(0.5, 0.5))
			self.imgWarnning:setPosition(cc.p(320, 170))
			self.imgWarnning:setContentSize(cc.size(620, 320))
			self.imgWarnning:addTo(self.layerTouch, 1)
		end
		local actionTintTo1 = cca.tintBy(1, -1, -1, -1)
		local actionTintTo2 = cca.tintBy(1, 0, 0, 0)
		local actionDelay = cca.delay(0.5)
		local actionTinBack = cca.tintBy(1, 1, 1, 1)
		_UPVALUE5_ = 1
		;(1)[1] = actionTintTo1
		;(1)[2] = actionTintTo2
		;(1)[3] = actionDelay
		;(1)[4] = actionTinBack
		;(1)[5] = actionTintTo2
		local actionRepeat = cca.repeatForever(cca.seq(1))
		self.imgWarnning:setVisible(true)
		self.imgWarnning:stopAllActions()
		self.imgWarnning:runAction(actionRepeat)
	elseif self.imgWarnning then
		self.imgWarnning:setVisible(false)
		self.imgWarnning:stopAllActions()
	end
end
function AllianceWarListRallySingle:updateView(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if data.indexID == self.indexID and self:needRefresh() then
		self:initData(self.indexID)
	end
end
function AllianceWarListRallySingle:updateData(indexID, warHallData, isFilter)
	if self:needRefresh() then
		self:initData(indexID, warHallData, isFilter)
	end
end
function AllianceWarListRallySingle:initData(indexID, warHallData, isFilter)
	self.indexID = indexID
	local warHallQueues
	if warHallData then
		warHallQueues = warHallData
		self.isFilter = isFilter
	else
		warHallData = self.queueRoot:getWarHallData(self.indexID)
		if warHallData then
			self.isFilter = warHallData.isFilter
			warHallQueues, _ENV = warHallData.queues, warHallData.queues
			warHallQueues = warHallData and warHallData.queues or warHallData
		end
	end
	local tableMainData
	if warHallQueues then
		local index, queue = next(warHallQueues)
		if index and queue then
			tableMainData = queue
		end
	end
	if not tableMainData then
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		return
	end
	self.tableMainData = tableMainData
	self.is_delay = false
	local curTime = socket.gettime()
	self.preClockTime = curTime
	local memberAttack = self.queueRoot:getMassQueuesAttacker(self.tableMainData)
	local memberDefend = self.queueRoot:getMassQueuesDefender(self.tableMainData)
	self:hideAllHead()
	self.viewType = gAWarViewMemberType.NONE
	self.hasMyArmy = false
	self.hasCapture = false
	self.showClose = false
	self.isWar = self.queueRoot:isWarQueueRoot()
	self.nodeTarget:initData(self.tableMainData.to, self.tableMainData)
	local targetData = self:getShowTarget()
	self.targetData = targetData
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local fromAid = self.tableMainData:getAid()
	local selfAid = self.queueRoot:getOwnTeamID()
	local toAid = kingdomMapUtil.getTargetAid(targetData, fromAid, selfAid)
	local curMassNum = 0
	local maxMassNum = 0
	if fromAid == toAid then
		local memberAttackQueue = self.queueRoot:getMassQueuesAttackQueues(self.tableMainData)
		self:updateMassNum(memberAttackQueue)
		self.attackType = gAWarViewMemberType.HELPER
		if uid == self.tableMainData.from.uid and self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self.viewType = gAWarViewMemberType.ATTACKER
			self.showClose = self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally
		end
		self.labelState:setColor(cc.c3b(50, 180, 0))
		self:showBottom(targetData, memberDefend, gAWarViewMemberType.DEFENDER)
		self:showTop(self.tableMainData.from, memberAttack, gAWarViewMemberType.HELPER)
		self.imgTitleBg:setColor(cc.c3b(50, 180, 0))
		self.imgHeadBg:setColor(cc.c3b(50, 180, 0))
		for i, v in ipairs(memberAttackQueue) do
			if v.id and 1 < i then
				curMassNum = curMassNum + v.totalNum
			end
		end
		maxMassNum = self.tableMainData.maxMassNum
		self.nodeMass:setVisible(true)
	elseif fromAid == selfAid then
		local memberAttackQueue = self.queueRoot:getMassQueuesAttackQueues(self.tableMainData)
		self:updateMassNum(memberAttackQueue)
		self.attackType = gAWarViewMemberType.ATTACKER
		if uid == self.tableMainData.from.uid and self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self.viewType = gAWarViewMemberType.ATTACKER
			self.showClose = self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally
		end
		self.labelState:setColor(cc.c3b(216, 8, 8))
		self:showBottom(targetData, memberDefend, gAWarViewMemberType.DEFENDER)
		self:showTop(self.tableMainData.from, memberAttack, gAWarViewMemberType.ATTACKER)
		self.imgTitleBg:setColor(cc.c3b(216, 8, 8))
		self.imgHeadBg:setColor(cc.c3b(216, 8, 8))
		for i, v in ipairs(memberAttackQueue) do
			if v.id and 1 < i then
				curMassNum = curMassNum + v.totalNum
			end
		end
		maxMassNum = self.tableMainData.maxMassNum
		self.nodeMass:setVisible(true)
	elseif toAid == selfAid then
		local memberDefendQueue = self.queueRoot:getMassQueuesDefendQueues(self.tableMainData)
		self:updateMassNum(memberDefendQueue)
		self.attackType = gAWarViewMemberType.DEFENDER
		if uid ~= targetData.uid then
			self.viewType = gAWarViewMemberType.ALLY
			self.showPlus = self.massNum < self.tableMainData.maxMassNum
			if not self.showPlus and self.tableMainData.maxHelpNum then
				self.maxCount = self.tableMainData.maxHelpNum - self.massNum
				self.showPlus = self.massNum < self.tableMainData.maxHelpNum
			end
		else
			self.viewType = gAWarViewMemberType.DEFENDER
			if self.tableMainData.to.objType == gMapObjTypeDef.mapObjTypePlayer then
				self.showClose = true
			end
		end
		self.labelState:setColor(cc.c3b(55, 180, 190))
		self:showBottom(self.tableMainData.from, memberAttack, gAWarViewMemberType.ATTACKER)
		self:showTop(targetData, memberDefend, gAWarViewMemberType.DEFENDER)
		self.imgTitleBg:setColor(cc.c3b(55, 180, 190))
		self.imgHeadBg:setColor(cc.c3b(55, 180, 190))
		local isPlayerCastle = false
		for i, v in ipairs(memberDefendQueue) do
			if v.to.objType == gMapObjTypeDef.mapObjTypePlayer then
				isPlayerCastle = true
				if v.id and 1 < i and selfAid == v.from.aid then
					curMassNum = curMassNum + v.totalNum
				end
			elseif v.id and selfAid == v.from.aid then
				curMassNum = curMassNum + v.totalNum
			end
		end
		if isPlayerCastle then
			maxMassNum = self.tableMainData.maxMassNum
		else
			maxMassNum = memberDefendQueue[1].maxMassNum
		end
		self.nodeMass:setVisible(false)
	end
	if 0 > self.maxCount then
		self.maxCount = 0
	end
	self:showQueue()
	local isBlack = self.queueRoot:isBlock(self.tableMainData)
	self:showBlackWarnning(isBlack)
	self:updateFilter()
	self:updateMemberColor(memberAttack, memberDefend)
	self:updateTroopsNum(curMassNum, maxMassNum)
	self:initMassView()
end
function AllianceWarListRallySingle:showTop(mainData, memberData, attackType)
	local spriteState = "icon_alliancewar_defender.png"
	local colorState = cc.c3b(184, 219, 219)
	if attackType == gAWarViewMemberType.ATTACKER then
		spriteState = "icon_alliancewar_attacker.png"
		colorState = cc.c3b(173, 132, 115)
	elseif attackType == gAWarViewMemberType.HELPER then
		spriteState = "icon_king_support.png"
		colorState = cc.c3b(173, 132, 115)
	end
	self.spriteOwnState:setSpriteFrame(spriteState)
	self.labelOwnName:setColor(colorState)
	if self:showKingdomWarBuild(mainData, memberData, true, attackType) then
		return
	end
	if mainData.allianceAbb then
		_ENV = true
		;(true).abbr = mainData.allianceAbb
		;(true).name = mainData.name
		self.labelOwnName:setString(i18n("common_text_186", true))
	else
		self.labelOwnName:setString(mainData.name)
	end
	local totalMember = allianceMgr:getAllianceBattlePeopleCount()
	if self.attackType ~= gAWarViewMemberType.DEFENDER then
		self.labelOwnMember:setString(tostring(#memberData) .. "/" .. totalMember)
	else
		self.labelOwnMember:setString(tostring(#memberData))
	end
	if (self.viewType == gAWarViewMemberType.NONE or self.viewType == gAWarViewMemberType.ALLY) and totalMember <= #memberData then
		self.showPlus = false
	end
	local uid = lordInfoCtrl:getLordInfo().base.uid
	for _, v in ipairs(memberData) do
		if uid == v.uid then
			self.showPlus = false
			self.hasMyArmy = true
			break
		end
	end
	self.btn_close:setVisible(self.showClose)
	local memberCount = math.min(#memberData + (self.showPlus and 1 or 0), 5)
	for i = 1, memberCount do
		if i == memberCount and self.showPlus then
			if not self.isWar then
				self:setAddImg(i, true)
			end
		else
			self:setHeadImg(i, true, memberData[i].headid, memberData[i].avatar)
		end
	end
end
function AllianceWarListRallySingle:showBottom(mainData, memberData, attackType)
	local spriteState = "icon_alliancewar_defender.png"
	if attackType == gAWarViewMemberType.ATTACKER then
		spriteState = "icon_alliancewar_attacker.png"
	elseif attackType == gAWarViewMemberType.HELPER then
		spriteState = "icon_king_support.png"
	end
	self.spriteOtherState:setSpriteFrame(spriteState)
	if self:showKingdomWarBuild(mainData, memberData, false, attackType) then
		return
	end
	if mainData.allianceAbb then
		_ENV = false
		;(false).abbr = mainData.allianceAbb
		;(false).name = mainData.name
		self.labelOtherName:setString(i18n("common_text_186", false))
	else
		self.labelOtherName:setString(mainData.name)
	end
	self.labelOtherMember:setString(tostring(#memberData))
	for i = 1, math.min(#memberData, 5) do
		self:setHeadImg(i, false, memberData[i].headid, memberData[i].avatar)
	end
end
function AllianceWarListRallySingle:showFightAllianceBuild(memberData, isOwn, starIndex)
	starIndex = starIndex or 2
	local memberCount = math.min(#memberData, 4 + starIndex)
	if isOwn then
		local uid = lordInfoCtrl:getLordInfo().base.uid
		for _, v in ipairs(memberData) do
			if uid == v.uid then
				self.showPlus = false
				self.hasMyArmy = true
				break
			end
		end
		memberCount = math.min(#memberData + (self.showPlus and 1 or 0), 4 + starIndex)
		for i = starIndex, memberCount do
			if i == memberCount and self.showPlus then
				self:setAddImg(i, isOwn)
			else
				self:setHeadImg(i, isOwn, memberData[i].headid, memberData[i].avatar)
			end
		end
	else
		for i = starIndex, memberCount do
			self:setHeadImg(i, isOwn, memberData[i].headid, memberData[i].avatar)
		end
	end
end
function AllianceWarListRallySingle:showQueue()
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function AllianceWarListRallySingle:showKingdomWarBuild(mainData, memberData, isOwn, attackType)
	if (attackType ~= gAWarViewMemberType.DEFENDER or self.hasCapture) and mainData.objType ~= gMapObjTypeDef.mapObjTypeAllianceBuild and mainData.objType ~= gMapObjTypeDef.mapObjTypeBattlefieldSite then
		return false
	end
	local headImg
	local nameStr = ""
	local memberCount = 1
	local bRet = true
	local objType = mainData.objType
	if objType == gMapObjTypeDef.mapObjTypeCastale then
		local bigCastale = KWKingdomCtrl:getKingdomCastaleModel()
		nameStr = i18n("common_text_839")
		headImg = palaceInfoRead.getIcon(bigCastale)
	elseif objType == gMapObjTypeDef.mapObjTypeBattery then
		if mainData.objId then
			nameStr = palaceInfoRead.getBatteryName(mainData.objId)
			headImg = palaceInfoRead.getBatteryIcon(mainData.objId)
		else
			nameStr = i18n("common_text_840")
			headImg = "paotai_dj_w_01.png"
		end
	elseif objType == gMapObjTypeDef.mapTypeATBuilding then
		nameStr = i18n("AncienTreasure_buildname_01")
		headImg = "Map_build_sgmk.png"
		self.labelState:setColor(cc.c3b(50, 180, 0))
	elseif objType == gMapObjTypeDef.mapObjNewTrialCity then
		if mainData.subMapType == 1 then
			nameStr = i18n("devilvalley_text_48")
			headImg = "map_devilValley_wall_01.png"
		else
			nameStr = i18n("common_text_840")
			headImg = "paotai_dj_w_01.png"
		end
	elseif objType == gMapObjTypeDef.mapObjTypeBoss or objType == gMapObjTypeDef.wastelandBoss or objType == gMapObjTypeDef.fireDragon2 or objType == gMapObjTypeDef.sweetMeatRobber then
		local bossType = mainData.bossType
		local bossData = worldMapDefine.getWorldBossShow(bossType, mainData.lv)
		_ENV = cc.c3b(50, 180, 0)
		cc.c3b(50, 180, 0).lv = mainData.lv
		cc.c3b(50, 180, 0).name = i18n(bossData.name)
		nameStr = i18n("common_text_134", cc.c3b(50, 180, 0))
		headImg = bossData.icon
	elseif objType == gMapObjTypeDef.mapTypeHeroBattleBoss1 then
		local bossType = mainData.bossType
		local bossData = worldMapDefine.getWorldBossShow(bossType)
		_ENV = cc.c3b(50, 180, 0)
		cc.c3b(50, 180, 0).lv = mainData.lv
		cc.c3b(50, 180, 0).name = i18n(bossData.name)
		nameStr = i18n("common_text_134", cc.c3b(50, 180, 0))
		headImg = bossData.icon
	elseif objType == gMapObjTypeDef.mapTypeHeroBattleBoss2 then
		local bossType = mainData.bossType
		local bossData = worldMapDefine.getWorldBossShow(bossType)
		_ENV = cc.c3b(50, 180, 0)
		cc.c3b(50, 180, 0).lv = mainData.lv
		cc.c3b(50, 180, 0).name = i18n(bossData.name)
		nameStr = i18n("common_text_134", cc.c3b(50, 180, 0))
		headImg = bossData.icon
	elseif objType == gMapObjTypeDef.mapTypeWrathBeast then
		local beastData = wrathBeastCtrl:getWrathBeastData(mainData.bossType)
		local bossType = beastData.bossType
		local lv = beastData.level
		local bossData = worldMapDefine.getWorldBossShow(bossType)
		_ENV = bossData.name
		bossData.name.lv = lv
		bossData.name.name = i18n(bossData.name)
		nameStr = i18n("common_text_134", bossData.name)
		headImg = bossData.icon
	elseif objType == gMapObjTypeDef.mapTypeWerewolf then
		local bossType = mainData.bossType
		local bossData = worldMapDefine.getWorldBossShow(bossType)
		_ENV = i18n("common_text_134", bossData.name)
		i18n("common_text_134", bossData.name).lv = mainData.lv
		i18n("common_text_134", bossData.name).name = i18n(bossData.name)
		nameStr = i18n("common_text_134", (i18n("common_text_134", bossData.name)))
		headImg = bossData.icon
	elseif objType == gMapObjTypeDef.mapObjTypeLegendLord then
		if mainData.objId then
			local hegemonRead = include("hegemonRead")
			nameStr = hegemonRead.getName(mainData.objId)
		elseif worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			nameStr = i18n("kingstarbattle_text_64")
		else
			nameStr = i18n("common_text_4242")
		end
		memberCount = #memberData
	elseif objType == gMapObjTypeDef.mapObjTypeRemainsWar then
		if mainData.objId then
			local remainsWarRead = include("remainsWarRead")
			nameStr = remainsWarRead.getBuildName(mainData.objId)
		end
		memberCount = #memberData
	elseif objType == gMapObjTypeDef.mapTypeRadianceWarPalace or objType == gMapObjTypeDef.mapTypeRadianceWarGate or objType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
		local radianceWarRead = include("radianceWarRead")
		nameStr = radianceWarRead.getBuildName(objType, mainData.objId)
		memberCount = #memberData
	elseif objType == gMapObjTypeDef.mapObjTypeFortress then
		nameStr = i18n("common_text_2859")
		headImg = "Map_build_fort.png"
	elseif objType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
		local buildType = mainData.subMapType
		nameStr = worldMapDefine.getPyramidbuildingName(buildType, mainData.objId)
		if mainData.allianceAbb then
			_ENV = mainData.objId
			mainData.objId.abbr = mainData.allianceAbb
			mainData.objId.name = nameStr
			nameStr = i18n("common_text_186", mainData.objId)
		end
		self:showFightAllianceBuild(memberData, isOwn, 1)
		memberCount = #memberData
	elseif objType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		_ENV = self
		self.abbr = mainData.allianceAbb
		self.name = allianceDesRead.getBuildName(mainData.objId)
		nameStr = i18n("common_text_186", self)
		memberCount = #memberData
		self:showFightAllianceBuild(memberData, isOwn, 1)
	elseif objType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		local AMBC = require_data("atlantiswar_map_build_config").data
		nameStr = i18n(AMBC[mainData.objId].name)
		memberCount = #memberData
	elseif objType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		local bossType = mainData.subMapType
		local bossData = worldMapDefine.getWorldBossShow(bossType)
		nameStr = i18n(bossData.name)
		headImg = bossData.icon
	elseif objType == gMapObjTypeDef.nebulaWarBuilding or objType == gMapObjTypeDef.nebulaEmperorWarBuilding then
		local mapObjUtil = include("mapObjUtil")
		nameStr = mapObjUtil.getBuildName(objType, mainData.subMapType, mainData.objId)
		memberCount = #memberData
	else
		bRet = false
	end
	if bRet then
		if isOwn then
			self.labelOwnName:setString(nameStr)
			self.labelOwnMember:setString(tostring(memberCount))
		else
			self.labelOtherName:setString(nameStr)
			self.labelOtherMember:setString(tostring(memberCount))
		end
		if headImg then
			self:setHeadImgByImgPath(1, isOwn, headImg)
		end
	end
	return bRet
end
function AllianceWarListRallySingle:openTimeUp(dt)
	local leftTime = queueTimeUtil.getRemainTime(self.tableMainData)
	local statusLabel
	if self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		queueTimeUtil = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		statusLabel = i18n("common_text_295", nil)
	else
		queueTimeUtil = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		statusLabel = i18n("common_text_293", nil)
	end
	self.labelState:setString(statusLabel)
	if leftTime <= 0 then
		self.labelState:setString(i18n("Battlefield_queue_text_006"))
	end
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if 0 >= self.delay_time then
			self.is_delay = false
			self:initData(self.indexID)
		end
	end
end
function AllianceWarListRallySingle:updateTroopsNum(cur, max)
	if max <= 0 then
		max = cur
	elseif cur > max then
		cur = max
	end
	_ENV = nil
	;(nil).cur = cur
	;(nil).max = max
	self.labelTroops:setString(i18n("common_text_296", nil))
end
local MIN_TIME = 2.0
function AllianceWarListRallySingle:needRefresh()
	if self.is_delay then
		return false
	end
	local curTime = socket.gettime()
	if self.preClockTime then
		local time = curTime - self.preClockTime
		if time < MIN_TIME then
			self.is_delay = true
			self.delay_time = MIN_TIME
			return false
		end
	end
	self.preClockTime = curTime
	return true
end
function AllianceWarListRallySingle:setScroll(scroll, queueRoot)
	self.scroll = scroll
	self.nodeTarget:setScroll(self.scroll)
	self.queueRoot = queueRoot
end
function AllianceWarListRallySingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if not self.tableMainData then
			return
		end
		SoraDPlaySound()
		local objType = self.tableMainData.to.objType
		if self.attackType == gAWarViewMemberType.DEFENDER and objType ~= gMapObjTypeDef.mapObjTypePlayer and objType ~= gMapObjTypeDef.mapObjTypeAllianceBuild then
			if SoraDGotoWorldMapPoint(cc.p(self.tableMainData.to.x, self.tableMainData.to.y), true, self.tableMainData:getMapID()) then
				SoraDRemoveAllPanelFromManager()
			end
		else
			local panel = uiManager:show("AllianceWarRallyView")
			panel:initData(self.indexID, self.tableMainData, self.queueRoot)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceWarListRallySingle:onPlusClick(button, type)
	if type == ccui.TouchEventType.ended then
		if not self.tableMainData then
			return
		end
		SoraDPlaySound()
		if self.viewType == gAWarViewMemberType.ATTACKER then
			SoraDShowMsgBox(i18n("common_text_3617"), i18n("common_text_204"), nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES and not tolua.isnull(self) and self:isVisible() and self.viewType == gAWarViewMemberType.ATTACKER and self.tableMainData and self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally then
					kingdomMapCtrl:reqBackQueueById(self.tableMainData.id)
				end
			end)
		elseif self.viewType == gAWarViewMemberType.NONE then
			local worldMapWarDef = include("worldMapWarDef")
			_ENV = i18n("common_text_204")
			i18n("common_text_204").massData = self.tableMainData.from
			if not worldMapWarDef.checkCanJoinMass((i18n("common_text_204"))) then
				return
			end
			self:onAddArmy()
		elseif self.viewType == gAWarViewMemberType.ALLY then
			local worldMapWarDef = include("worldMapWarDef")
			_ENV = self
			self.massData = self.tableMainData.to
			if not worldMapWarDef.checkCanJoinMass(self) then
				return
			end
			if not kingdomMapCtrl:hasArmyHelpQueue2Player(self.tableMainData.to.uid) then
				local instanceID = self.tableMainData.to.id
				if self.tableMainData.to.objType == gMapObjTypeDef.mapObjTypeAllianceBuild then
					if kingdomMapCtrl:hasArmyHelpQueue2Object(instanceID) then
						SoraDShowMsgTip(i18n("common_text_704"))
					elseif SoraDEnoughTroops() then
						local endPoint = cc.p(self.tableMainData.to.x, self.tableMainData.to.y)
						local instanceType = gMapObjTypeDef.mapObjTypeAllianceBuild
						local dispatchPanel = uiManager:show("WorldDispatchArmyView")
						local dispatchType = worldMapDefine.worldMapTipButtonType_xiefang
						_ENV = "WorldDispatchArmyView"
						;("WorldDispatchArmyView").massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
						local ("WorldDispatchArmyView").massSlaveArmyMinLv, otherData = self.tableMainData:getMassSlaveArmyMinLv(), "WorldDispatchArmyView"
						_ENV = i18n("common_text_704")
						i18n("common_text_704").maxCount = self.maxCount
						i18n("common_text_704").toPoint = endPoint
						i18n("common_text_704").dispatchType = dispatchType
						i18n("common_text_704").instanceID = instanceID
						i18n("common_text_704").otherData = otherData
						i18n("common_text_704").isJoinMass = true
						i18n("common_text_704").instanceType = instanceType
						dispatchPanel:initData(i18n("common_text_704"))
					end
				else
					_ENV = cc.p(self.tableMainData.to.x, self.tableMainData.to.y)
					cc.p(self.tableMainData.to.x, self.tableMainData.to.y).uid = self.tableMainData.to.uid
					cc.p(self.tableMainData.to.x, self.tableMainData.to.y).dispatchType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
					local cc.p(self.tableMainData.to.x, self.tableMainData.to.y).instanceID, cityArmyData = instanceID, cc.p(self.tableMainData.to.x, self.tableMainData.to.y)
					_ENV = "WorldDispatchArmyView"
					;("WorldDispatchArmyView").cityArmyData = cityArmyData
					uiManager:show("ReinforcementsMsgBox", "WorldDispatchArmyView")
				end
			else
				SoraDShowMsgTip(i18n("common_text_704"))
			end
		elseif self.viewType == gAWarViewMemberType.DEFENDER then
			SoraDShowMsgBox(i18n("common_text_3620"), i18n("common_text_204"), nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES and not tolua.isnull(self) and self:isVisible() then
					local _ENV, queueIds = self:isVisible(), self:isVisible()
					local memberDefend = self.queueRoot:getMassQueuesDefendQueues(self.tableMainData)
					for i, v in ipairs(memberDefend) do
						if 1 < i then
							table.insert(queueIds, v.id)
						end
					end
					kingdomMapCtrl:reqBackAllQueue(queueIds)
				end
			end)
		end
	end
end
function AllianceWarListRallySingle:onAddArmy()
	if self.hasMyArmy then
		SoraDShowMsgTip(i18n("common_text_652"))
		return
	end
	if self.maxCount <= 0 then
	end
	_ENV = self.maxCount
	self.maxCount.data = self.tableMainData.from
	self.maxCount.id = self.tableMainData.id
	self.maxCount.mainObjType = self.tableMainData.to.objType
	self.maxCount.mainObjId = self.tableMainData.to.objId
	self.maxCount.isManuPlace = self.tableMainData.to.isManuPlace
	self.maxCount.attr = self.tableMainData.attr
	self.maxCount.massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
	self.tableMemberData, self.maxCount.massSlaveArmyMinLv = self.maxCount, self.tableMainData:getMassSlaveArmyMinLv()
	if SoraDEnoughTroops() then
		_ENV = SoraDEnoughTroops()
		_ENV, SoraDEnoughTroops().toPoint = cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y), cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y)
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massId = self.tableMemberData.id
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveForbidArmyClass = self.tableMemberData.massSlaveForbidArmyClass
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMinLv = self.tableMemberData.massSlaveArmyMinLv
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).endTime = queueTimeUtil.getFinishTime(self.tableMainData)
		SoraDEnoughTroops().otherData, cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).mainInstanceType = cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y), self.tableMemberData.mainObjType
		SoraDEnoughTroops().instanceID = self.tableMemberData.data.mapObjId
		SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_xuanZhan
		SoraDEnoughTroops().instanceType = gMapObjTypeDef.mapObjTypePlayer
		SoraDEnoughTroops().maxCount = self.maxCount
		SoraDEnoughTroops().isJoinMass = true
		local SoraDEnoughTroops().attr, dispatchData = self.tableMemberData.attr, SoraDEnoughTroops()
		local dispatchFun = function(callType)
			if callType == nil or callType == MSGBOX_CALLBACK_YES then
				if not self.__cname then
					print("对象已经被释放")
					return
				end
				dispatchData.maxCount = self.maxCount
				self.dispatchPanel = uiManager:show("WorldDispatchArmyView")
				self.dispatchPanel:initData(dispatchData)
			end
		end
		if kingdomMapCtrl:reqIsSafe() and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapObjTypeBoss and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeHeroBattleBoss1 and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeHeroBattleBoss2 and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeATBuilding and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeWerewolf and self.tableMemberData.mainObjType ~= gMapObjTypeDef.mapTypeWrathBeast and self.tableMemberData.mainObjType ~= gMapObjTypeDef.sweetMeatRobber and self.tableMemberData.mainObjType == gMapObjTypeDef.mapObjTypeAllianceBuild and self.tableMemberData.mainObjId ~= gMapAllianceBuildType.subTypeAllianceAltar then
			local showMsg = i18n("notice_0160")
			SoraDShowMsgBox(showMsg, i18n("common_text_490"), i18n("common_text_185"), dispatchFun)
		elseif self.tableMemberData.mainObjType == gMapObjTypeDef.mapObjTypeBoss or self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeWerewolf or self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeHuntFair then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local bossType = self.tableMainData.to.bossType
			local limitType = _G.gBossType2LimitType[bossType] or bossType
			if self.tableMemberData.mainObjType == gMapObjTypeDef.mapTypeWerewolf then
				limitType = gBossType.werewolf
			elseif self.tableMainData.to.bossType == gBossType.huntFairBoss then
				limitType = gBossType.huntFairBoss
			end
			local isAttackReward = kingdomMapCtrl:canGetBossAttackRewards(limitType)
			local isKillReward = kingdomMapCtrl:canGetBossKillRewards(limitType)
			print("集结啦！！！", self.tableMemberData.mainObjType, isAttackReward, isKillReward, limitType)
			if not isAttackReward then
				local maxAttack = activityShowCtrl:getBossMaxAttackNum(limitType)
				if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 then
					_ENV = isKillReward
					isKillReward.maxAttack = maxAttack
					SoraDShowMsgBox(i18n("herobattle_text_19", isKillReward), i18n("common_text_204"), nil, dispatchFun)
				else
					_ENV = nil
					;(nil).maxAttack = maxAttack
					SoraDShowMsgBox(i18n("common_text_2151", nil), i18n("common_text_204"), nil, dispatchFun)
				end
			elseif not isKillReward then
				local maxKill = activityShowCtrl:getBossMaxKillNum(limitType)
				if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 then
					_ENV = nil
					;(nil).maxKill = maxKill
					SoraDShowMsgBox(i18n("herobattle_text_20", nil), i18n("common_text_204"), nil, dispatchFun)
				else
					_ENV = nil
					;(nil).maxKill = maxKill
					SoraDShowMsgBox(i18n("common_text_2152", nil), i18n("common_text_204"), nil, dispatchFun)
				end
			else
				dispatchFun()
			end
		else
			dispatchFun()
		end
	end
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function AllianceWarListRallySingle:updateFilter()
	if self.attackType == gAWarViewMemberType.DEFENDER then
		if self.isFilter then
			self.layerTouch:setColor(colorGray)
		else
			self.layerTouch:setColor(colorNormal)
		end
	else
		self.layerTouch:setColor(colorNormal)
	end
end
local isSelfIn = function(data)
	local id = lordInfoCtrl:getLordInfo().base.uid
	for _, v in ipairs(data) do
		if v.uid and v.uid == id then
			return true
		end
	end
end
function AllianceWarListRallySingle:updateMemberColor(memberAttack, memberDefend)
	local memberOwn, memberOther
	if self.attackType == gAWarViewMemberType.DEFENDER then
		memberOwn = memberDefend
		memberOther = memberAttack
	else
		memberOwn = memberAttack
		memberOther = memberDefend
	end
	if isSelfIn(memberOwn) then
		self.labelOwnMember:setColor(cc.c3b(0, 190, 30))
	else
		self.labelOwnMember:setColor(display.COLOR_WHITE)
	end
	if isSelfIn(memberOther) then
		self.labelOtherMember:setColor(cc.c3b(0, 190, 30))
	else
		self.labelOtherMember:setColor(display.COLOR_WHITE)
	end
end
function AllianceWarListRallySingle:getShowTarget()
	if self.tableMainData:isTargetCapture() then
		local queuesFix = self.queueRoot:getWorkingCaptainQueue(self.tableMainData)
		if queuesFix then
			self.hasCapture = true
			return queuesFix:getFrom()
		end
	end
	self.hasCapture = false
	return self.tableMainData.to
end
function AllianceWarListRallySingle:updateMassNum(memberQueueData)
	self.maxCount = 0
	local massNum = 0
	for i, v in ipairs(memberQueueData) do
		if 1 < i then
			massNum = massNum + v.totalNum
		end
	end
	self.massNum = massNum
	self.maxCount = self.tableMainData.maxMassNum - self.massNum
	self.showPlus = self.massNum < self.tableMainData.maxMassNum and self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally
end
function AllianceWarListRallySingle:resetData()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.tableMainData = nil
	self.targetData = nil
end
return AllianceWarListRallySingle
