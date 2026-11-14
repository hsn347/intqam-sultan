local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local worldMapKingdomLvTower = class("worldMapKingdomLvTower", function(target)
	local target = include("worldMapInstance").new("worldMapKingdomLvTower")
	return target
end)
function worldMapKingdomLvTower:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapKingdomLvTower:_initData()
	self.level = 0
end
function worldMapKingdomLvTower:_initUI()
	local offsetX = 45
	local offsetY = 95
	self.occupyIcon = display.newSpriteNoChild("#icon_map_res_me.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setVisible(false)
	self:addChild(self.occupyIcon, 2)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	self.resourceImage = display.newSprite("#Map_build_kingdomLv.png")
	self.resourceImage:setScale(0.8)
	self.resourceImage:setPosition(cc.p(-90 + offsetX, 20 + offsetY))
	self:addChild(self.resourceImage, -1)
	local effectBottom = SoraDCreatAnimation("xiangyata_bottom")
	effectBottom:setPosition(cc.p(effectBottom:getContentSize().width / 2, effectBottom:getContentSize().height / 2 + 110))
	self:addChild(effectBottom, -10)
	effectBottom:setVisible(false)
	self.effectBottom = effectBottom
	effectBottom:setGroupID(worldMapDefine.GROU_ID.group_particle_bg)
	effectBottom:setGroupAuto(true)
	local effect = SoraDCreatAnimation("xiangyata")
	effect:setPosition(cc.p(self.resourceImage:getContentSize().width / 2 + 70, self.resourceImage:getContentSize().height / 2 - 30))
	self.resourceImage:addChild(effect)
	effect:setVisible(false)
	self.effect = effect
	self.image_nameLv = display.newSprite("#frame_map_07.png")
	self.image_nameLv:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_nameLv:setPosition(cc.p(self.centerPoint.x - 30 + offsetX, self.centerPoint.y - 90 + offsetY))
	self.image_nameLv:addTo(self, 1)
	local buldName = i18n("common_text_3957")
	_ENV = self
	self.UILabelType = 2
	self.text = buldName
	self.size = 20
	self.text_NameLv = cc.ui.UILabel.new(self)
	self.text_NameLv:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_NameLv:setPosition(cc.p(self.centerPoint.x - 30 + offsetX, self.centerPoint.y - 93 + offsetY))
	self.text_NameLv:addTo(self, 2)
	self.text_NameLv:setColor(cc.c3b(255, 200, 100))
	self.text_NameLv:setGroupID(worldMapDefine.GROU_ID.group_text)
	local textLen = self.text_NameLv:getContentSize().width
	local maxWidth = math.max(textLen + 120, self.image_nameLv:getContentSize().width)
	print("textLen = ", textLen, "maxWidth = ", maxWidth)
	self.image_nameLv:setScaleX(maxWidth / self.image_nameLv:getContentSize().width)
	local spriteLock = display.newSprite("#" .. "frame_techtree_lock_01.png")
	local lockName = "img_build_lock"
	spriteLock:setName(lockName)
	spriteLock:setScale(1.3)
	spriteLock:setPosition(cc.p(self.centerPoint.x - 30 + offsetX, self.centerPoint.y + offsetY))
	spriteLock:addTo(self, 3)
	self.spriteLock = spriteLock
	local offsetLv = cc.p(80, -25)
	self.image_level = display.newSprite("#icon_map_kingdomlv.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x + offsetLv.x, self.centerPoint.y + offsetLv.y))
	self.image_level:addTo(self, 3)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = "1"
	self.image_level.size = 14
	self.resourceLevelLabel = SoraDCreateLabel(self.image_level)
	self.resourceLevelLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.resourceLevelLabel:setSkewY(25)
	self.resourceLevelLabel:setPosition(cc.p(self.centerPoint.x + offsetLv.x + 6, self.centerPoint.y + offsetLv.y))
	self.resourceLevelLabel:addTo(self, 3)
	self.resourceLevelLabel:setGroupID(worldMapDefine.GROU_ID.group_text)
	self:updateActivityState()
end
function worldMapKingdomLvTower:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLDKINGDOM_LV_OPEN_CHANGE", handler(self, self.updateActivityState))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_UPDATE", handler(self, self.updateIsBeOccupied))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if data.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001573 then
			self:updateIsBeOccupied()
		end
	end)
end
function worldMapKingdomLvTower:addCacheBefore()
end
function worldMapKingdomLvTower:setBatchNodeGroupID(groupID)
	self.resourceImage:setGroupID(groupID)
end
function worldMapKingdomLvTower:initInstanceData(buildData)
	dump(buildData, "worldMapKingdomLvTower:initInstanceData(buildData)")
	if not buildData then
		return
	end
	self:updateData(buildData)
end
function worldMapKingdomLvTower:updateData(data)
	dump(data, "worldMapKingdomLvTower:updateData")
	if not data then
		return
	end
	if data.level then
		self.level = data.level
		self.isUnlock = data.isUnlock
	end
	self:updateLevel()
	if not self.isUnlock then
		self.spriteLock:setVisible(true)
	else
		self.spriteLock:setVisible(false)
	end
	self:updateIsBeOccupied()
end
function worldMapKingdomLvTower:updateLevel()
	self.resourceLevelLabel:setString(self.level)
end
function worldMapKingdomLvTower:updateIsBeOccupied()
	local isOccupied = activity_9001573_Ctrl:getIsTowerBeOccupied()
	if self.occupiedIcon ~= nil then
		self.occupiedIcon:setVisible(isOccupied)
	end
	if isOccupied and self.occupiedIcon == nil then
		self.occupiedIcon = display.newSprite("#Celestial_build_monster.png")
		self.occupiedIcon:addTo(self)
		self.occupiedIcon:setPosition(self.centerPoint.x + 15, 250)
		self.occupiedIcon:setScale(1.1)
		_ENV = 1.1
		;(1.1)[1] = cca.scaleTo(0.5, 0.9)
		;(1.1)[2] = cca.scaleTo(0.5, 1.1)
		;(1.1)[3] = cca.scaleTo(0.5, 1.1)
		;(1.1)[4] = cca.scaleTo(0.5, 1.1)
		local repeatAction = cca.repeatForever(cca.seq(1.1))
		self.occupiedIcon:runAction(repeatAction)
	end
end
function worldMapKingdomLvTower:playClickSound()
	SoraDPlaySound("worldmap", 18)
end
function worldMapKingdomLvTower:updateActivityState()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY, false) then
		self.effect:setVisible(false)
		self.effectBottom:setVisible(false)
	else
		self.effect:setVisible(true)
		self.effectBottom:setVisible(true)
	end
end
function worldMapKingdomLvTower:onClickInstance(onShowView)
	local gametop = gModuleMgr.getObject("gametop")
	local myKindomID = gametop.playertop_:getMapID()
	print("self.kingdomID = ", self.kingdomID, ", myKindomID = ", myKindomID)
	if myKindomID ~= self.kingdomID then
		_ENV = "self.kingdomID = "
		;("self.kingdomID = ").title = i18n("common_text_3957")
		;("self.kingdomID = ").content = i18n("common_text_3958")
		SoraDShowServerTip("self.kingdomID = ")
		return
	end
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local isInWarKingdom = false
	local worldMapDefine = include("worldMapDefine")
	if worldMapDefine.isInWar() then
		isInWarKingdom = true
	elseif conquestWarCtrl:isPlayerConquestWarMigration() and 0 < lordInfoCtrl:getSourceKid() then
		isInWarKingdom = true
	end
	if isInWarKingdom then
		_ENV = lordInfoCtrl
		lordInfoCtrl.title = i18n("common_text_3957")
		lordInfoCtrl.content = i18n("common_text_3958")
		SoraDShowServerTip(lordInfoCtrl)
	else
		if not self.isUnlock then
			SoraDShowMsgTip(i18n("common_text_3968"))
			return
		end
		if activity_9001573_Ctrl:getIsInBattle() then
			self:playClickSound()
			return self:onShowWorldMapTip(onShowView), true
		else
			uiManager:show("WorldKingdomLv")
		end
	end
	self:playClickSound()
end
function worldMapKingdomLvTower:getFavoriteName()
	return i18n("common_text_3957")
end
function worldMapKingdomLvTower:getInstanceOp(isSelfKindom, isInWar, data)
	if activity_9001573_Ctrl:getIsInBattle() and data.data.build then
		dump(data, "worldMapKingdomLvTower:getInstanceOp")
		self.npcLife = data.data.build.npcLife
		self.npcArmy = data.data.build.npcArmy
		local isHaveEnemy = data.data.build.npcLife and data.data.build.npcLife > 0
		local isSelfIn = self:checkIsSelfIn()
		local activity_9001573_Ctrl, buttonTypeArray = self, self
		_UPVALUE2_ = nil
		;(nil)[1] = isHaveEnemy
		;(nil)[2] = isSelfIn
		dump(nil, "getInstanceOp")
		if isHaveEnemy then
			activity_9001573_Ctrl = "getInstanceOp"
			;("getInstanceOp").buttonType = worldMapDefine.worldMapTipButtonType_nebuladefence_gongji
			table.insert(buttonTypeArray, "getInstanceOp")
		else
			activity_9001573_Ctrl = "getInstanceOp"
			;("getInstanceOp").buttonType = worldMapDefine.worldMapTipButtonType_nebuladefence_xiefang
			table.insert(buttonTypeArray, "getInstanceOp")
		end
		if isSelfIn then
			activity_9001573_Ctrl = "getInstanceOp"
			;("getInstanceOp").buttonType = worldMapDefine.worldMapTipButtonType_fanHui
			table.insert(buttonTypeArray, "getInstanceOp")
		end
		if isHaveEnemy then
			activity_9001573_Ctrl = "getInstanceOp"
			;("getInstanceOp").buttonType = worldMapDefine.worldMapTipButtonType_nebuladefence_chakanshoujun
			table.insert(buttonTypeArray, "getInstanceOp")
		else
			activity_9001573_Ctrl = "getInstanceOp"
			;("getInstanceOp").buttonType = worldMapDefine.worldMapTipButtonType_chakanYuanjun
			table.insert(buttonTypeArray, "getInstanceOp")
		end
		activity_9001573_Ctrl = "getInstanceOp"
		;("getInstanceOp").buttonType = worldMapDefine.worldMapTipButtonType_chakanxiangqing
		table.insert(buttonTypeArray, "getInstanceOp")
		if data.data.build.moveData ~= nil and 0 < #data.data.build.moveData then
			activity_9001573_Ctrl = "getInstanceOp"
			;("getInstanceOp").buttonType = worldMapDefine.worldMapTipButtonType_nebuladefence_jinjie
			table.insert(buttonTypeArray, "getInstanceOp")
		end
		return buttonTypeArray
	end
end
function worldMapKingdomLvTower:checkIsSelfIn()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	if kingdomMapCtrl.kingdomMapCell:hasMyQueueToMapObj(self.instanceID, gMapMoveLineServerType.occupyNebulaDefenceWar, gMapMoveLineStatusType.moveLineStatusTypeWorking) then
		return true
	end
end
return worldMapKingdomLvTower
