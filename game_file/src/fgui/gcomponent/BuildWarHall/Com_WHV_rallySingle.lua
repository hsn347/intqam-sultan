local baseComponent = require("fgui.base.baseComponent")
local Com_WHV_rallySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWarHall/Com_WHV_rallySingle", Com_WHV_rallySingle)
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
function Com_WHV_rallySingle:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.nodeMass:setPositionX(self.fields.nodeMass:getParent():getSize().width - self.fields.nodeMass:getX() - self.fields.nodeMass:getWidth())
	end
	self.indexID = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.isFilter = false
	self.timer = nil
	self.tableMainData = nil
	self.attackType = gAWarViewMemberType.DEFENDER
	self.viewType = gAWarViewMemberType.NONE
	self.showPlus = true
	self.showClose = false
	self.hasCapture = false
	self.targetData = nil
	self.fields.imgWarnning = nil
	self.maxCount = 0
	self.headDatas2, _ENV, self.headDatas1, _ENV, self.hasMyArmy = self.fields, self.fields, self.fields, self.fields, false
	self.fields.list1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.list2:setItemRenderer(handler(self, self.onItemRenderer2))
	self.fields.btn_close:addClickEventListener(handler(self, self.onPlusClick))
	self.fields.layerTouch:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickCallBack))
	self.spriteMass, _ENV = self.fields.layerTouch.addEventListener, self.fields.layerTouch.addEventListener
	for i = 4, 1, -1 do
		self.spriteMass[i] = self.fields["spriteMass" .. i]
	end
end
function Com_WHV_rallySingle:onShow()
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
end
function Com_WHV_rallySingle:oHide()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function Com_WHV_rallySingle:initMassView()
	local massSlaveForbidArmyClass = self.tableMainData:getMassSlaveForbidArmyClass()
	for i = 4, 1, -1 do
		local node = self.spriteMass[i]
		if node and massSlaveForbidArmyClass and massSlaveForbidArmyClass[tostring(i)] then
			node:setVisible(false)
		end
	end
end
function Com_WHV_rallySingle:hideAllHead()
	self.fields.list1:setVisible(false)
	self.fields.list2:setVisible(false)
end
function Com_WHV_rallySingle:onItemRenderer1(index, obj)
	local data = self.headDatas1[index + 1]
	if data.headid then
		obj:setHeadSprite(data.headid, data.avatar)
	else
		obj:setImage(data.headImg, data.touch)
	end
end
function Com_WHV_rallySingle:onItemRenderer2(index, obj)
	local data = self.headDatas2[index + 1]
	if data.headid then
		obj:setHeadSprite(data.headid, data.avatar)
	else
		obj:setImage(data.headImg, data.touch)
	end
end
function Com_WHV_rallySingle:setHeadImg(index, owner, headid, avatar)
	_ENV = nil
	;(nil).headid = headid
	;(nil).avatar = avatar
	table.insert(owner and self.headDatas1 or self.headDatas2, nil)
end
function Com_WHV_rallySingle:setHeadImgByImgPath(index, owner, headImg, touch)
	_ENV = nil
	;(nil).headImg = headImg
	;(nil).touch = touch
	table.insert(owner and self.headDatas1 or self.headDatas2, nil)
end
function Com_WHV_rallySingle:setAddImg(index, owner)
	self:setHeadImgByImgPath(index, owner, "frame_LegendaryKing_green_add.png", true)
end
function Com_WHV_rallySingle:showBlackWarnning(show)
	if show then
		local actionTintTo1 = ffa.tintBy(1, -1, -1, -1)
		local actionTintTo2 = ffa.tintBy(1, 0, 0, 0)
		local actionDelay = ffa.delay(0.5)
		local actionTinBack = ffa.tintBy(1, 1, 1, 1)
		_UPVALUE5_ = 1
		;(1)[1] = actionTintTo1
		;(1)[2] = actionTintTo2
		;(1)[3] = actionDelay
		;(1)[4] = actionTinBack
		;(1)[5] = actionTintTo2
		local actionRepeat = ffa.repeatForever(ffa.seq(1))
		self.fields.imgWarnning:setVisible(true)
		self.fields.imgWarnning:stopAllActions()
		self.fields.imgWarnning:runAction(actionRepeat)
	elseif self.fields.imgWarnning then
		self.fields.imgWarnning:setVisible(false)
		self.fields.imgWarnning:stopAllActions()
	end
end
function Com_WHV_rallySingle:updateView(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if data.indexID == self.indexID and self:needRefresh() then
		self:initData(self.indexID)
	end
end
function Com_WHV_rallySingle:updateData(indexID, warHallData, isFilter)
	if self:needRefresh() then
		self:initData(indexID, warHallData, isFilter)
	end
end
function Com_WHV_rallySingle:initData(indexID, warHallData, isFilter)
	self.headDatas2, _ENV, self.headDatas1, _ENV, self.indexID = nil, nil, nil, nil, indexID
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
		self:setHeight(0)
		self:setScaleY(0)
		self.tableMainData = nil
		return
	else
		self:setHeight(341)
		self:setScaleY(1)
	end
	self.tableMainData = tableMainData
	self.is_delay = false
	local curTime = socket.gettime()
	self.preClockTime = curTime
	local memberAttack = self.queueRoot:getMassQueuesAttacker(self.tableMainData)
	local memberDefend = self.queueRoot:getMassQueuesDefender(self.tableMainData)
	dump(memberDefend, "memberDefend")
	self:hideAllHead()
	self.viewType = gAWarViewMemberType.NONE
	self.hasMyArmy = false
	self.hasCapture = false
	self.showClose = false
	self.isWar = self.queueRoot:isWarQueueRoot()
	self.fields.nodeTarget:initData(self.tableMainData.to, self.tableMainData)
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
		self.fields.labelState:setColor(cc.c3b(50, 180, 0))
		self:showBottom(targetData, memberDefend, gAWarViewMemberType.DEFENDER)
		self:showTop(self.tableMainData.from, memberAttack, gAWarViewMemberType.HELPER)
		for i, v in ipairs(memberAttackQueue) do
			if v.id and 1 < i then
				curMassNum = curMassNum + v.totalNum
			end
		end
		maxMassNum = self.tableMainData.maxMassNum
		self.fields.nodeMass:setVisible(true)
	elseif fromAid == selfAid then
		local memberAttackQueue = self.queueRoot:getMassQueuesAttackQueues(self.tableMainData)
		self:updateMassNum(memberAttackQueue)
		self.attackType = gAWarViewMemberType.ATTACKER
		if uid == self.tableMainData.from.uid and self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self.viewType = gAWarViewMemberType.ATTACKER
			self.showClose = self.tableMainData.status == gMapMoveLineStatusType.moveLineStatusTypeRally
		end
		self.fields.labelState:setColor(cc.c3b(216, 8, 8))
		self:showBottom(targetData, memberDefend, gAWarViewMemberType.DEFENDER)
		self:showTop(self.tableMainData.from, memberAttack, gAWarViewMemberType.ATTACKER)
		for i, v in ipairs(memberAttackQueue) do
			if v.id and 1 < i then
				curMassNum = curMassNum + v.totalNum
			end
		end
		maxMassNum = self.tableMainData.maxMassNum
		self.fields.nodeMass:setVisible(true)
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
		self.fields.labelState:setColor(cc.c3b(55, 180, 190))
		self:showBottom(self.tableMainData.from, memberAttack, gAWarViewMemberType.ATTACKER)
		self:showTop(targetData, memberDefend, gAWarViewMemberType.DEFENDER)
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
		self.fields.nodeMass:setVisible(false)
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
function Com_WHV_rallySingle:showTop(mainData, memberData, attackType)
	local spriteState = "icon_alliancewar_defender.png"
	local colorState = cc.c3b(184, 219, 219)
	if attackType == gAWarViewMemberType.ATTACKER then
		spriteState = "icon_alliancewar_attacker.png"
		colorState = cc.c3b(173, 132, 115)
	elseif attackType == gAWarViewMemberType.HELPER then
		spriteState = "icon_king_support.png"
		colorState = cc.c3b(173, 132, 115)
	end
	self.fields.spriteOwnState:setURL(spriteState)
	self.fields.labelOwnName:setColor(colorState)
	if self:showKingdomWarBuild(mainData, memberData, true, attackType) then
		self.fields.list2:setVisible(true)
		self.fields.list2:setNumItems(#self.headDatas2)
		return
	end
	if mainData.allianceAbb then
		_ENV = true
		;(true).abbr = mainData.allianceAbb
		;(true).name = mainData.name
		self.fields.labelOwnName:setString(i18n("common_text_186", true))
	else
		self.fields.labelOwnName:setString(mainData.name)
	end
	local totalMember = allianceMgr:getAllianceBattlePeopleCount()
	if self.attackType ~= gAWarViewMemberType.DEFENDER then
		self.fields.labelOwnMember:setString(tostring(#memberData) .. "/" .. totalMember)
	else
		self.fields.labelOwnMember:setString(tostring(#memberData))
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
	self.fields.btn_close:setVisible(self.showClose)
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
	self.fields.list1:setVisible(true)
	self.fields.list1:setNumItems(#self.headDatas1)
end
function Com_WHV_rallySingle:showBottom(mainData, memberData, attackType)
	local spriteState = "icon_alliancewar_defender.png"
	if attackType == gAWarViewMemberType.ATTACKER then
		spriteState = "icon_alliancewar_attacker.png"
	elseif attackType == gAWarViewMemberType.HELPER then
		spriteState = "icon_king_support.png"
	end
	self.fields.spriteOtherState:setURL(spriteState)
	if self:showKingdomWarBuild(mainData, memberData, false, attackType) then
		self.fields.list2:setVisible(true)
		self.fields.list2:setNumItems(#self.headDatas2)
		return
	end
	if mainData.allianceAbb then
		_ENV = false
		;(false).abbr = mainData.allianceAbb
		;(false).name = mainData.name
		self.fields.labelOtherName:setString(i18n("common_text_186", false))
	else
		self.fields.labelOtherName:setString(mainData.name)
	end
	self.fields.labelOtherMember:setString(tostring(#memberData))
	for i = 1, math.min(#memberData, 5) do
		self:setHeadImg(i, false, memberData[i].headid, memberData[i].avatar)
	end
	self.fields.list2:setVisible(true)
	self.fields.list2:setNumItems(#self.headDatas2)
end
function Com_WHV_rallySingle:showFightAllianceBuild(memberData, isOwn, starIndex)
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
function Com_WHV_rallySingle:showQueue()
	self:openTimeUp()
end
function Com_WHV_rallySingle:showKingdomWarBuild(mainData, memberData, isOwn, attackType)
	if (attackType ~= gAWarViewMemberType.DEFENDER or self.hasCapture) and mainData.objType ~= gMapObjTypeDef.mapObjTypeAllianceBuild and mainData.objType ~= gMapObjTypeDef.mapObjTypeBattlefieldSite and mainData.objType ~= gMapObjTypeDef.mapObjNewTrialCity then
		return false
	end
	dump(mainData, "Com_WHV_rallySingle:showKingdomWarBuild")
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
		self.fields.labelState:setColor(cc.c3b(50, 180, 0))
	elseif objType == gMapObjTypeDef.mapObjNewTrialCity then
		if self.tableMainData.to and self.tableMainData.to.subMapType == 1 then
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
	elseif objType == gMapObjTypeDef.nebulaDefenceWarBuilding then
		local activity_9001573_Read = include("activity_9001573_Read")
		nameStr = activity_9001573_Read.getBuildName(mainData.objId)
		headImg = activity_9001573_Read.getBuildMailImg(mainData.objId)
	elseif objType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		local bossType = mainData.subMapType
		local bossData = worldMapDefine.getWorldBossShow(bossType)
		nameStr = i18n(bossData.name)
		headImg = bossData.icon
	elseif objType == gMapObjTypeDef.nebulaWarBuilding or objType == gMapObjTypeDef.nebulaEmperorWarBuilding or objType == gMapObjTypeDef.nebulaAllStarWarBuilding then
		local mapObjUtil = include("mapObjUtil")
		nameStr = mapObjUtil.getBuildName(objType, mainData.subMapType, mainData.objId)
		memberCount = #memberData
	else
		bRet = false
	end
	if bRet then
		if isOwn then
			self.fields.labelOwnName:setString(nameStr)
			self.fields.labelOwnMember:setString(tostring(memberCount))
		else
			self.fields.labelOtherName:setString(nameStr)
			self.fields.labelOtherMember:setString(tostring(memberCount))
		end
		if headImg then
			self:setHeadImgByImgPath(1, isOwn, headImg)
		end
	end
	return bRet
end
function Com_WHV_rallySingle:openTimeUp(dt)
	if self.tableMainData == nil then
		return
	end
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
	self.fields.labelState:setString(statusLabel)
	if leftTime <= 0 then
		self.fields.labelState:setString(i18n("Battlefield_queue_text_006"))
	end
	if self.is_delay then
		self.delay_time = self.delay_time - dt
		if 0 >= self.delay_time then
			self.is_delay = false
			self:initData(self.indexID)
		end
	end
end
function Com_WHV_rallySingle:updateTroopsNum(cur, max)
	if max <= 0 then
		max = cur
	elseif cur > max then
		cur = max
	end
	_ENV = nil
	;(nil).cur = cur
	;(nil).max = max
	self.fields.labelTroops:setString(i18n("common_text_296", nil))
end
local MIN_TIME = 2.0
function Com_WHV_rallySingle:needRefresh()
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
function Com_WHV_rallySingle:setScroll(scroll, queueRoot)
	self.queueRoot = queueRoot
end
function Com_WHV_rallySingle:btnClickCallBack(button, type)
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
end
function Com_WHV_rallySingle:onPlusClick(button, type)
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
					;("WorldDispatchArmyView").massSlaveArmyMinLv = self.tableMainData:getMassSlaveArmyMinLv()
					;("WorldDispatchArmyView").massSlaveArmyMinNum = self.tableMainData:getMassSlaveArmyMinNum()
					;("WorldDispatchArmyView").massSlaveArmyMaxNum = self.tableMainData:getMassSlaveArmyMaxNum()
					local ("WorldDispatchArmyView").isForbidSpeed, otherData = self.tableMainData:getIsForbidSpeed(), "WorldDispatchArmyView"
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
function Com_WHV_rallySingle:onAddArmy()
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
	self.maxCount.massSlaveArmyMinLv = self.tableMainData:getMassSlaveArmyMinLv()
	self.maxCount.massSlaveArmyMinNum = self.tableMainData:getMassSlaveArmyMinNum()
	self.maxCount.massSlaveArmyMaxNum = self.tableMainData:getMassSlaveArmyMaxNum()
	self.tableMemberData, self.maxCount.isForbidSpeed = self.maxCount, self.tableMainData:getIsForbidSpeed()
	if SoraDEnoughTroops() then
		_ENV = SoraDEnoughTroops()
		_ENV, SoraDEnoughTroops().toPoint = cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y), cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y)
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massId = self.tableMemberData.id
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveForbidArmyClass = self.tableMemberData.massSlaveForbidArmyClass
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMinLv = self.tableMemberData.massSlaveArmyMinLv
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMinNum = self.tableMemberData.massSlaveArmyMinNum
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).massSlaveArmyMaxNum = self.tableMemberData.massSlaveArmyMaxNum
		cc.p(self.tableMemberData.data.x, self.tableMemberData.data.y).isForbidSpeed = self.tableMemberData.isForbidSpeed
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
function Com_WHV_rallySingle:updateFilter()
	if self.attackType == gAWarViewMemberType.DEFENDER then
		if self.isFilter then
			self.fields.panelMask:setVisible(true)
		else
			self.fields.panelMask:setVisible(false)
		end
	else
		self.fields.panelMask:setVisible(false)
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
function Com_WHV_rallySingle:updateMemberColor(memberAttack, memberDefend)
	local memberOwn, memberOther
	if self.attackType == gAWarViewMemberType.DEFENDER then
		memberOwn = memberDefend
		memberOther = memberAttack
	else
		memberOwn = memberAttack
		memberOther = memberDefend
	end
	if isSelfIn(memberOwn) then
		self.fields.labelOwnMember:setColor(cc.c3b(0, 190, 30))
	else
		self.fields.labelOwnMember:setColor(display.COLOR_WHITE)
	end
	if isSelfIn(memberOther) then
		self.fields.labelOtherMember:setColor(cc.c3b(0, 190, 30))
	else
		self.fields.labelOtherMember:setColor(display.COLOR_WHITE)
	end
end
function Com_WHV_rallySingle:getShowTarget()
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
function Com_WHV_rallySingle:updateMassNum(memberQueueData)
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
function Com_WHV_rallySingle:resetData()
	self.tableMainData = nil
	self.targetData = nil
end
return Com_WHV_rallySingle
